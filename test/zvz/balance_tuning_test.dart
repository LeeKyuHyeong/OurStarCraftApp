/// ZvZ 빌드 상성 튜닝용 — 특정 시나리오만 빠르게 1000경기 돌림
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final homePlayer = Player(
    id: 'zerg_home', name: '이재동', raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  final awayPlayer = Player(
    id: 'zerg_away', name: '박성준', raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(
    id: 'test_fighting_spirit', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  Future<void> run1000(String homeBuild, String awayBuild, String label) async {
    int homeWins = 0;
    const total = 1000;
    for (int i = 0; i < total; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWins++;
    }
    final rate = (homeWins / total * 100).toStringAsFixed(1);
    print('$label: 홈 승률 $rate% ($homeWins/$total)');
  }

  // ── 튜닝 대상 시나리오 ──

  test('12pool vs 12hatch (목표: 12hatch 60%)', () async {
    await run1000('zvz_12pool', 'zvz_12hatch', '12pool(홈) vs 12hatch(어웨이)');
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('9pool_lair vs 9overpool (목표: 9overpool 55%)', () async {
    await run1000('zvz_9pool_lair', 'zvz_9overpool', '9pool_lair(홈) vs 9overpool(어웨이)');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
