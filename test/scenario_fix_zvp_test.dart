import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
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
  final protossPlayer = Player(
    id: 'protoss_test',
    name: '김택용',
    raceIndex: 2,
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

  // Helper to run 20 games (10 normal + 10 reversed) for a scenario
  Future<void> runScenario(String name, String homeBuild, String awayBuild) async {
    int homeWinNormal = 0, homeWinReversed = 0;
    int normalErrors = 0, reversedErrors = 0;

    // Normal direction: Zerg home, Protoss away
    for (int i = 0; i < 25; i++) {
      try {
        final service = MatchSimulationService();
        final stream = service.simulateMatchWithLog(
          homePlayer: zergPlayer,
          awayPlayer: protossPlayer,
          map: testMap,
          getIntervalMs: () => 0,
          forcedHomeBuildId: homeBuild,
          forcedAwayBuildId: awayBuild,
        );
        SimulationState? state;
        await for (final s in stream) { state = s; }
        if (state?.homeWin == true) homeWinNormal++;
      } catch (e) {
        normalErrors++;
        print('  [$name] Normal game $i error: $e');
      }
    }

    // Reversed direction: Protoss home, Zerg away
    for (int i = 0; i < 25; i++) {
      try {
        final service = MatchSimulationService();
        final stream = service.simulateMatchWithLog(
          homePlayer: protossPlayer,
          awayPlayer: zergPlayer,
          map: testMap,
          getIntervalMs: () => 0,
          forcedHomeBuildId: awayBuild,
          forcedAwayBuildId: homeBuild,
        );
        SimulationState? state;
        await for (final s in stream) { state = s; }
        if (state?.homeWin == false) homeWinReversed++;
      } catch (e) {
        reversedErrors++;
        print('  [$name] Reversed game $i error: $e');
      }
    }

    final normalGames = 25 - normalErrors;
    final reversedGames = 25 - reversedErrors;
    final normalRate = normalGames > 0 ? (homeWinNormal / normalGames * 100) : 0.0;
    final reversedRate = reversedGames > 0 ? (homeWinReversed / reversedGames * 100) : 0.0;
    final totalWins = homeWinNormal + homeWinReversed;
    final totalGames = normalGames + reversedGames;
    final totalRate = totalGames > 0 ? (totalWins / totalGames * 100) : 0.0;
    final bias = (normalRate - reversedRate).abs();

    print('[$name] homeBuild=$homeBuild awayBuild=$awayBuild');
    print('  Normal(Z home): $homeWinNormal/${normalGames} (${normalRate.toStringAsFixed(1)}%)');
    print('  Reversed(P home): $homeWinReversed/${reversedGames} (${reversedRate.toStringAsFixed(1)}%)');
    print('  Total: $totalWins/$totalGames (${totalRate.toStringAsFixed(1)}%)');
    print('  Bias: ${bias.toStringAsFixed(1)}%p');
    if (normalErrors > 0 || reversedErrors > 0) {
      print('  Errors: normal=$normalErrors reversed=$reversedErrors');
    }
    print('');
  }

  test('ZvP scenario 1: zvp_hydra_vs_forge', () async {
    await runScenario('S1_hydra_vs_forge', 'zvp_12hatch', 'pvz_forge_cannon');
  });

  test('ZvP scenario 2: zvp_mutal_vs_forge', () async {
    await runScenario('S2_mutal_vs_forge', 'zvp_2hatch_mutal', 'pvz_forge_cannon');
  });

  test('ZvP scenario 3: zvp_9pool_vs_forge', () async {
    await runScenario('S3_9pool_vs_forge', 'zvp_9pool', 'pvz_forge_cannon');
  });

  test('ZvP scenario 4: zvp_cheese_vs_cheese', () async {
    await runScenario('S4_cheese_vs_cheese', 'zvp_4pool', 'pvz_proxy_gate');
  });

  test('ZvP scenario 5: zvp_mukerji_vs_corsair_reaver', () async {
    await runScenario('S5_mukerji_vs_corsair_reaver', 'zvp_mukerji', 'pvz_corsair_reaver');
  });

  test('ZvP scenario 6: zvp_scourge_defiler', () async {
    await runScenario('S6_scourge_defiler', 'zvp_scourge_defiler', 'pvz_forge_cannon');
  });

  test('ZvP scenario 7: zvp_973_hydra_rush', () async {
    await runScenario('S7_973_hydra_rush', 'zvp_973_hydra', 'pvz_forge_cannon');
  });

  test('ZvP scenario 8: zvp_standard_vs_2gate', () async {
    await runScenario('S8_standard_vs_2gate', 'zvp_12hatch', 'pvz_2gate_zealot');
  });

  test('ZvP scenario 9: zvp_3hatch_vs_corsair_reaver', () async {
    await runScenario('S9_3hatch_vs_corsair_reaver', 'zvp_3hatch_nopool', 'pvz_corsair_reaver');
  });

  test('ZvP scenario 10: zvp_hydra_lurker_vs_forge', () async {
    await runScenario('S10_hydra_lurker_vs_forge', 'zvp_trans_hydra_lurker', 'pvz_forge_cannon');
  });

  test('ZvP scenario 11: zvp_cheese_vs_forge', () async {
    await runScenario('S11_cheese_vs_forge', 'zvp_4pool', 'pvz_forge_cannon');
  });
}
