import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  const homeBuildId = 'tvt_bbs';
  const awayBuildId = 'tvt_bbs';

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

  test('BBS 미러 5경기 로그 (병력/자원 추적)', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('# BBS 미러 5경기 로그 (병력/자원 추적)\n');

    for (int game = 1; game <= 5; game++) {
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuildId,
        forcedAwayBuildId: awayBuildId,
      );

      // 매 상태를 전부 수집
      final states = <SimulationState>[];
      await for (final s in stream) {
        states.add(s);
      }

      final finalState = states.last;
      final winner = finalState.homeWin == true ? '홈(이영호)' : '어웨이(임요환)';
      buf.writeln('## 경기 $game');
      buf.writeln('**결과**: $winner 승\n');

      // 헤더
      buf.writeln('```');
      buf.writeln('     │ 홈 병력 │ 홈 자원 │ 어웨이 병력 │ 어웨이 자원 │ 로그');
      buf.writeln('─────┼─────────┼─────────┼────────────┼────────────┼────────────────────────────────');

      // 초기값
      buf.writeln('  초 │     0   │    50   │      0     │     50     │ (시작)');

      int prevHomeArmy = 0;
      int prevAwayArmy = 0;
      int prevHomeRes = 50;
      int prevAwayRes = 50;

      for (int i = 0; i < states.length; i++) {
        final s = states[i];
        // 새 로그가 추가된 시점만 출력
        final logCount = s.battleLogEntries.length;
        if (logCount == 0) continue;

        // 이전 상태와 비교해서 새 로그가 있는 경우만
        final prevLogCount = i > 0 ? states[i - 1].battleLogEntries.length : 0;
        if (logCount <= prevLogCount) continue;

        // 새로 추가된 로그들 출력
        for (int j = prevLogCount; j < logCount; j++) {
          final e = s.battleLogEntries[j];
          final lineNum = (j + 1).toString().padLeft(3);

          // 변동 표시
          final haDiff = s.homeArmy - prevHomeArmy;
          final aaDiff = s.awayArmy - prevAwayArmy;
          final hrDiff = s.homeResources - prevHomeRes;
          final arDiff = s.awayResources - prevAwayRes;

          String fmtVal(int val, int diff) {
            final diffStr = diff > 0 ? '(+$diff)' : diff < 0 ? '($diff)' : '';
            return '$val$diffStr'.padRight(9);
          }

          // 마지막 로그에서만 수치 변동 반영 (중간 로그는 같은 state)
          if (j == logCount - 1) {
            buf.writeln('$lineNum │ ${fmtVal(s.homeArmy, haDiff)}│ ${fmtVal(s.homeResources, hrDiff)}│ ${fmtVal(s.awayArmy, aaDiff).padRight(10)} │ ${fmtVal(s.awayResources, arDiff).padRight(10)} │ ${e.text}');
            prevHomeArmy = s.homeArmy;
            prevAwayArmy = s.awayArmy;
            prevHomeRes = s.homeResources;
            prevAwayRes = s.awayResources;
          } else {
            buf.writeln('$lineNum │ ${''.padRight(9)}│ ${''.padRight(9)}│ ${''.padRight(10)} │ ${''.padRight(10)} │ ${e.text}');
          }
        }
      }
      buf.writeln('```\n');
    }

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/bbs_mirror_5games.md').writeAsStringSync(buf.toString());
    print(buf.toString());
  });
}
