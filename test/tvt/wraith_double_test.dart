import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// 레이스 vs 배럭더블 5경기 로그 + 다양성 검증
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

  test('레이스 vs 배럭더블 5경기 로그 + 다양성 체크', () async {
    final buf = StringBuffer();
    buf.writeln('# 레이스 vs 배럭더블 — 5경기 테스트 결과');
    buf.writeln();
    buf.writeln('빌드: `tvt_2star` vs `tvt_1bar_double`');
    buf.writeln();

    final allLogTexts = <String>[];
    int homeWins = 0;

    for (int game = 1; game <= 5; game++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_2star',
        forcedAwayBuildId: 'tvt_1bar_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;

      final winner = state.homeWin == true
          ? '홈(${homePlayer.name})'
          : '어웨이(${awayPlayer.name})';
      if (state.homeWin == true) homeWins++;

      // 경기 로그 문자열 구성
      final logLines = <String>[];
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == 'home'
            ? '[홈]  '
            : e.owner == 'away'
                ? '[어웨이]'
                : '[해설]';
        logLines.add('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
      }
      final logStr = logLines.join('\n');
      allLogTexts.add(logStr);

      buf.writeln('---');
      buf.writeln('## Game $game');
      buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}');
      buf.writeln();
      buf.writeln('```');
      buf.writeln(logStr);
      buf.writeln('```');
      buf.writeln();
    }

    // 다양성 체크
    final uniqueCount = allLogTexts.toSet().length;
    final duplicateCount = 5 - uniqueCount;

    buf.writeln('---');
    buf.writeln('## 다양성 검증');
    buf.writeln();
    buf.writeln('| 항목 | 값 |');
    buf.writeln('|------|-----|');
    buf.writeln('| 총 경기 수 | 5 |');
    buf.writeln('| 고유 로그 수 | $uniqueCount |');
    buf.writeln('| 중복 로그 수 | $duplicateCount |');
    buf.writeln('| 홈 승률 | ${(homeWins / 5 * 100).toStringAsFixed(0)}% ($homeWins/5) |');
    buf.writeln('| 다양성 판정 | ${uniqueCount == 5 ? "PASS — 5경기 모두 다른 로그" : "FAIL — 중복 발생 ($duplicateCount건)"} |');
    buf.writeln();

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/wraith_double_result.md').writeAsStringSync(buf.toString());
    print('레이스 vs 배럭더블 5경기 로그 → test/output/tvt/wraith_double_result.md');
  });
}
