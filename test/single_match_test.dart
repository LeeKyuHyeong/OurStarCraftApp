import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('TvZ 5팩 골리앗 vs 투해처리 뮤탈 단일 경기', () async {
    final service = MatchSimulationService();

    final homePlayer = Player(
      id: 'terran_test',
      name: '이영호',
      raceIndex: 0, // Terran
      stats: const PlayerStats(
        sense: 680,
        control: 700,
        attack: 660,
        harass: 640,
        strategy: 670,
        macro: 690,
        defense: 680,
        scout: 650,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'zerg_test',
      name: '이제동',
      raceIndex: 1, // Zerg
      stats: const PlayerStats(
        sense: 690,
        control: 680,
        attack: 670,
        harass: 710,
        strategy: 660,
        macro: 680,
        defense: 650,
        scout: 670,
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

    final stream = service.simulateMatchWithLog(
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
      map: testMap,
      getIntervalMs: () => 0,
      forcedHomeBuildId: 'tvz_3fac_goliath',
      forcedAwayBuildId: 'zvt_2hatch_mutal',
    );

    SimulationState? lastState;
    await for (final state in stream) {
      lastState = state;
    }

    if (lastState != null) {
      print('');
      print('========================================');
      print('  TvZ: 5팩 골리앗 vs 투해처리 뮤탈');
      print('  ${homePlayer.name} (T) vs ${awayPlayer.name} (Z)');
      print('  맵: ${testMap.name}');
      print('========================================');
      print('');

      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]',
          LogOwner.away => '[Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        print('$prefix ${entry.text}');
      }

      print('');
      print('========================================');
      print('  최종 병력: T ${lastState.homeArmy} vs Z ${lastState.awayArmy}');
      print('  최종 자원: T ${lastState.homeResources} vs Z ${lastState.awayResources}');
      print('  결과: ${lastState.homeWin == true ? '${homePlayer.name} (T) 승리!' : '${awayPlayer.name} (Z) 승리!'}');
      print('========================================');
    }
  });
}
