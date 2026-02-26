import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final terranPlayer = Player(
    id: 'terran_test',
    name: '이영호',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final zergPlayer = Player(
    id: 'zerg_test',
    name: '이재동',
    raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  const testMap = GameMap(
    id: 'test_map',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  const int n = 50; // 방향별 50경기, 총 100경기

  Future<void> runScenario(String name, String homeBuild, String awayBuild) async {
    int homeWinNormal = 0, homeWinReversed = 0;
    final normalLogs = <String>[];
    final reversedLogs = <String>[];

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
      normalLogs.add(state!.battleLogEntries.map((e) => e.text).join(' '));
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zergPlayer, awayPlayer: terranPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: awayBuild, forcedAwayBuildId: homeBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
      reversedLogs.add(state!.battleLogEntries.map((e) => e.text).join(' '));
    }

    final normalPct = (homeWinNormal / n * 100).round();
    final reversedPct = (homeWinReversed / n * 100).round();
    final avgPct = ((homeWinNormal + homeWinReversed) / (2 * n) * 100).round();
    final biasPct = (normalPct - reversedPct).abs();
    final uniqueNormal = normalLogs.toSet().length;
    final uniqueReversed = reversedLogs.toSet().length;

    print('=== $name ===');
    print('정방향 테란승률: $homeWinNormal/$n ($normalPct%)');
    print('역방향 테란승률: $homeWinReversed/$n ($reversedPct%)');
    print('평균 테란승률: $avgPct%');
    print('홈어웨이 차이: $biasPct%p');
    print('정방향 고유 로그: $uniqueNormal/$n');
    print('역방향 고유 로그: $uniqueReversed/$n');
  }

  test('tvz_bio_vs_mutal 50경기', () => runScenario('tvz_bio_vs_mutal', 'tvz_sk', 'zvt_3hatch_mutal'));
  test('tvz_mech_vs_lurker 50경기', () => runScenario('tvz_mech_vs_lurker', 'tvz_3fac_goliath', 'zvt_2hatch_lurker'));
  test('tvz_cheese_vs_standard 50경기', () => runScenario('tvz_cheese_vs_standard', 'tvz_bunker', 'zvt_12pool'));
  test('tvz_111_vs_macro 50경기', () => runScenario('tvz_111_vs_macro', 'tvz_111', 'zvt_3hatch_nopool'));
  test('tvz_wraith_vs_mutal 50경기', () => runScenario('tvz_wraith_vs_mutal', 'tvz_2star_wraith', 'zvt_2hatch_mutal'));
  test('tvz_cheese_vs_cheese 50경기', () => runScenario('tvz_cheese_vs_cheese', 'tvz_bunker', 'zvt_4pool'));
  test('tvz_standard_vs_9pool 50경기', () => runScenario('tvz_standard_vs_9pool', 'tvz_sk', 'zvt_9pool'));
  test('tvz_valkyrie_vs_mutal 50경기', () => runScenario('tvz_valkyrie_vs_mutal', 'tvz_valkyrie', 'zvt_2hatch_mutal'));
  test('tvz_double_vs_3hatch 50경기', () => runScenario('tvz_double_vs_3hatch', 'tvz_sk', 'zvt_3hatch_nopool'));
  test('tvz_standard_vs_1hatch_allin 50경기', () => runScenario('tvz_standard_vs_1hatch_allin', 'tvz_sk', 'zvt_1hatch_allin'));
  test('tvz_mech_vs_hive 50경기', () => runScenario('tvz_mech_vs_hive', 'tvz_3fac_goliath', 'zvt_trans_ultra_hive'));
}
