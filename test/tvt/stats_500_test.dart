import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final homePlayer = Player(
    id: 'terran_home',
    name: '이영호',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'terran_away',
    name: '임요환',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  const testMap = GameMap(
    id: 'test_fighting_spirit',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  Future<void> run500(String buildId) async {
    final service = MatchSimulationService();
    int homeWins = 0;
    const totalGames = 500;

    int earlyEnd = 0;
    int midEnd = 0;
    int lateEnd = 0;

    Map<String, int> branchCount = {};
    List<int> homeFinalArmy = [];
    List<int> awayFinalArmy = [];
    List<int> logLengths = [];
    Set<String> uniqueTexts = {};

    for (int i = 0; i < totalGames; i++) {
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: buildId, forcedAwayBuildId: buildId,
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;

      if (state.homeWin == true) homeWins++;

      final logLen = state.battleLogEntries.length;
      logLengths.add(logLen);
      homeFinalArmy.add(state.homeArmy);
      awayFinalArmy.add(state.awayArmy);

      // 고유 텍스트 수집
      final fullLog = state.battleLogEntries.map((e) => e.text).join('\n');
      uniqueTexts.add(fullLog);

      if (logLen <= 28) {
        earlyEnd++;
      } else if (logLen <= 42) {
        midEnd++;
      } else {
        lateEnd++;
      }

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');
      if (allText.contains('벌처가 상대 벌처를 전멸')) {
        branchCount['벌처 압살'] = (branchCount['벌처 압살'] ?? 0) + 1;
      }
      if (allText.contains('탱크 라인이 상대 진영을 압박') || allText.contains('탱크 라인이 상대 앞마당까지')) {
        branchCount['시즈 압도'] = (branchCount['시즈 압도'] ?? 0) + 1;
      }
      if (allText.contains('드랍십 출격') || allText.contains('탱크 드랍')) {
        branchCount['드랍 공격'] = (branchCount['드랍 공격'] ?? 0) + 1;
      }
      if (allText.contains('대규모 드랍') || allText.contains('승부수를 던집니다')) {
        branchCount['한방 뒤집기 드랍'] = (branchCount['한방 뒤집기 드랍'] ?? 0) + 1;
      }
      if (allText.contains('정면 승부') || allText.contains('드랍 없이')) {
        branchCount['정면 교전'] = (branchCount['정면 교전'] ?? 0) + 1;
      }
      if (allText.contains('마인')) {
        branchCount['마인 연구'] = (branchCount['마인 연구'] ?? 0) + 1;
      }
      if (allText.contains('속업') || allText.contains('이온 엔진')) {
        branchCount['속업 연구'] = (branchCount['속업 연구'] ?? 0) + 1;
      }
    }

    final homeWinRate = (homeWins / totalGames * 100).toStringAsFixed(1);
    final avgLogLen = (logLengths.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);
    final avgHomeArmy = (homeFinalArmy.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);
    final avgAwayArmy = (awayFinalArmy.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);
    final buildName = buildId.replaceFirst('tvt_', '');

    final buf = StringBuffer();
    buf.writeln('# TvT ${buildName}_mirror 500경기 통계');
    buf.writeln();
    buf.writeln('**동일 능력치 700** | 맵: 파이팅 스피릿');
    buf.writeln();
    buf.writeln('| 항목 | 값 |');
    buf.writeln('|------|-----|');
    buf.writeln('| 총 경기 | $totalGames |');
    buf.writeln('| 홈 승률 | $homeWinRate% ($homeWins승) |');
    buf.writeln('| 어웨이 승률 | ${(100 - double.parse(homeWinRate)).toStringAsFixed(1)}% (${totalGames - homeWins}승) |');
    buf.writeln('| 평균 로그 길이 | $avgLogLen줄 |');
    buf.writeln('| 평균 최종 병력 | 홈 $avgHomeArmy / 어웨이 $avgAwayArmy |');
    buf.writeln('| 고유 로그 수 | ${uniqueTexts.length} / $totalGames |');
    buf.writeln();
    buf.writeln('## 종료 시점 분포');
    buf.writeln();
    buf.writeln('| 시점 | 경기 수 | 비율 |');
    buf.writeln('|------|---------|------|');
    buf.writeln('| 초반 (~28줄) | $earlyEnd | ${(earlyEnd / totalGames * 100).toStringAsFixed(1)}% |');
    buf.writeln('| 중반 (29~42줄) | $midEnd | ${(midEnd / totalGames * 100).toStringAsFixed(1)}% |');
    buf.writeln('| 후반 (43줄~) | $lateEnd | ${(lateEnd / totalGames * 100).toStringAsFixed(1)}% |');
    buf.writeln();
    buf.writeln('## 분기 발동 횟수');
    buf.writeln();
    buf.writeln('| 분기 | 횟수 | 비율 |');
    buf.writeln('|------|------|------|');
    final sortedBranches = branchCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final e in sortedBranches) {
      buf.writeln('| ${e.key} | ${e.value} | ${(e.value / totalGames * 100).toStringAsFixed(1)}% |');
    }

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/${buildName}_mirror_500stats.md').writeAsStringSync(buf.toString());
    print(buf.toString());
  }

  test('1bar_double_mirror 500경기', () async {
    await run500('tvt_1bar_double');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('1fac_double_mirror 500경기', () async {
    await run500('tvt_1fac_double');
  }, timeout: const Timeout(Duration(minutes: 10)));

  test('2fac_push_mirror 500경기', () async {
    await run500('tvt_2fac_push');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
