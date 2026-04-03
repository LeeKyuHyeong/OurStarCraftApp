import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// BBS vs 노배럭더블 5경기 로그 (다양성 확인용)
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

  test('BBS vs 노배럭더블 5경기 다양성 확인', () async {
    final buf = StringBuffer();
    buf.writeln('# BBS vs 노배럭더블 5경기 로그');
    buf.writeln();
    buf.writeln('> 동일 능력치(700) / 동일 맵 / 동일 빌드 조합');
    buf.writeln('> 목표: 10경기 중 똑같은 경기가 나오지 않을 것');
    buf.writeln();

    final allLogs = <List<String>>[];
    int homeWins = 0;

    for (int game = 1; game <= 5; game++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_bbs',
        forcedAwayBuildId: 'tvt_1bar_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;

      final isHomeWin = state.homeWin == true;
      if (isHomeWin) homeWins++;
      final winner = isHomeWin
          ? '홈(${homePlayer.name})'
          : '어웨이(${awayPlayer.name})';

      final logLines = <String>[];
      buf.writeln('---');
      buf.writeln('## Game $game');
      buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}');
      buf.writeln();
      buf.writeln('```');
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == 'home'
            ? '[홈]  '
            : e.owner == 'away'
                ? '[어웨이]'
                : '[해설]';
        final line = '${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}';
        buf.writeln(line);
        logLines.add(e.text);
      }
      buf.writeln('```');
      buf.writeln();
      allLogs.add(logLines);
    }

    // 다양성 체크
    buf.writeln('---');
    buf.writeln('## 다양성 분석');
    buf.writeln();
    buf.writeln('| 비교 | 동일 줄 수 | 전체 줄 수 | 일치율 |');
    buf.writeln('|------|-----------|-----------|--------|');

    int duplicatePairs = 0;
    for (int i = 0; i < allLogs.length; i++) {
      for (int j = i + 1; j < allLogs.length; j++) {
        final a = allLogs[i];
        final b = allLogs[j];
        final maxLen = a.length > b.length ? a.length : b.length;
        int same = 0;
        for (int k = 0; k < a.length && k < b.length; k++) {
          if (a[k] == b[k]) same++;
        }
        final ratio = (same / maxLen * 100).toStringAsFixed(1);
        buf.writeln('| Game ${i + 1} vs ${j + 1} | $same | $maxLen | $ratio% |');
        if (same == maxLen && a.length == b.length) duplicatePairs++;
      }
    }

    buf.writeln();
    buf.writeln('**승률**: 홈 $homeWins / 5 (${(homeWins / 5 * 100).toStringAsFixed(0)}%)');
    buf.writeln('**완전 동일 경기 쌍**: $duplicatePairs');
    buf.writeln();
    if (duplicatePairs == 0) {
      buf.writeln('> ✅ 5경기 모두 서로 다른 경기 생성됨');
    } else {
      buf.writeln('> ⚠️ 동일한 경기가 $duplicatePairs쌍 존재');
    }

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/bbs_double_result.md').writeAsStringSync(buf.toString());
    print('BBS vs 노배럭더블 5경기 로그 → test/output/tvt/bbs_double_result.md');
  });
}
