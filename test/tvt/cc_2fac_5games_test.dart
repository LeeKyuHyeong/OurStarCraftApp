import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// 배럭더블 vs 투팩벌처 5경기 로그 생성
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

  test('배럭더블 vs 투팩벌처 5경기', () async {
    final buf = StringBuffer();
    buf.writeln('# 배럭더블 vs 투팩벌처 5경기 로그\n');

    for (int g = 0; g < 5; g++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_1bar_double',
        forcedAwayBuildId: 'tvt_2fac_push',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;

      final winner = state.homeWin == true
          ? '홈(${homePlayer.name})'
          : '어웨이(${awayPlayer.name})';

      buf.writeln('---\n');
      buf.writeln('## 경기 ${g + 1}');
      buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}\n');
      buf.writeln('```');
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == 'home'
            ? '[홈]  '
            : e.owner == 'away'
                ? '[어웨이]'
                : '[해설]';
        buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
      }
      buf.writeln('```\n');
    }

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/cc_2fac_result.md').writeAsStringSync(buf.toString());
    print('5경기 로그 → test/output/tvt/cc_2fac_result.md');
  });
}
