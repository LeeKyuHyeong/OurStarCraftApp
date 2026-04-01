/// ZvP 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../../tools/export_log_helper.dart';

void main() {
  final homePlayer = Player(
    id: 'zerg_home',
    name: '이재동',
    raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'protoss_away',
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
    id: 'test_fighting_spirit',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  // 시나리오별 빌드 조합 (각 시나리오에서 대표 빌드 1쌍)
  final scenarios = [
    {'home': 'zvp_12hatch', 'away': 'pvz_forge_cannon', 'name': '히드라 vs 포지더블'},
    {'home': 'zvp_2hatch_mutal', 'away': 'pvz_forge_cannon', 'name': '뮤탈 vs 포지더블'},
    {'home': 'zvp_9pool', 'away': 'pvz_forge_cannon', 'name': '9풀 vs 포지더블'},
    {'home': 'zvp_4pool', 'away': 'pvz_proxy_gate', 'name': '치즈 vs 치즈'},
    {'home': 'zvp_mukerji', 'away': 'pvz_corsair_reaver', 'name': '머커지 vs 커세어리버'},
    {'home': 'zvp_scourge_defiler', 'away': 'pvz_forge_cannon', 'name': '스커지디파일러 vs 포지'},
    {'home': 'zvp_973_hydra', 'away': 'pvz_forge_cannon', 'name': '973히드라 러시'},
    {'home': 'zvp_12hatch', 'away': 'pvz_2gate_zealot', 'name': '스탠다드 vs 투게이트'},
    {'home': 'zvp_12hatch', 'away': 'pvz_corsair_reaver', 'name': '3해처리 vs 커세어리버'},
    {'home': 'zvp_trans_hydra_lurker', 'away': 'pvz_forge_cannon', 'name': '히드라럴커 vs 포지'},
    {'home': 'zvp_4pool', 'away': 'pvz_forge_cannon', 'name': '치즈 vs 포지'},
  ];

  test('ZvP 전체 시나리오 보정용 JSON 로그 내보내기', () async {
    const gamesPerScenario = 200;
    final allGames = <Map<String, dynamic>>[];
    final branchStats = <String, int>{};

    for (final scenario in scenarios) {
      final homeBuild = scenario['home']!;
      final awayBuild = scenario['away']!;
      final scenarioName = scenario['name']!;

      // 정방향 50경기 + 역방향 50경기
      for (int direction = 0; direction < 2; direction++) {
        final isReversed = direction == 1;
        final actualHomeBuild = isReversed ? awayBuild : homeBuild;
        final actualAwayBuild = isReversed ? homeBuild : awayBuild;
        final actualHomePlayer = isReversed ? awayPlayer : homePlayer;
        final actualAwayPlayer = isReversed ? homePlayer : awayPlayer;

        for (int i = 0; i < gamesPerScenario ~/ 2; i++) {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: actualHomePlayer,
            awayPlayer: actualAwayPlayer,
            map: testMap,
            getIntervalMs: () => 0,
            forcedHomeBuildId: actualHomeBuild,
            forcedAwayBuildId: actualAwayBuild,
          );

          SimulationState? state;
          await for (final s in stream) { state = s; }
          if (state == null) continue;

          final gameJson = gameToJson(
            gameIndex: allGames.length,
            finalState: state,
            homePlayerName: actualHomePlayer.name,
            awayPlayerName: actualAwayPlayer.name,
            homeBuildId: homeBuild,
            awayBuildId: awayBuild,
            isReversed: isReversed,
          );
          allGames.add(gameJson);

          // 분기 통계 수집
          final branchKey = '$scenarioName|${isReversed ? "R" : "N"}';
          branchStats[branchKey] = (branchStats[branchKey] ?? 0) + 1;
        }
      }
      print('$scenarioName: ${gamesPerScenario}경기 완료');
    }

    await exportLogsToJson(
      matchup: 'ZvP',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/zvp/log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/zvp/log.json');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
