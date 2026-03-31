/// ZvZ 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../tools/export_log_helper.dart';

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
    id: 'zerg_away',
    name: '박성준',
    raceIndex: 1,
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

  // 시나리오별 빌드 조합
  final scenarios = [
    {'home': 'zvz_9pool', 'away': 'zvz_9overpool', 'name': '9풀 vs 9오버풀'},
    {'home': 'zvz_12hatch', 'away': 'zvz_9pool', 'name': '12앞마당 vs 9풀'},
    {'home': 'zvz_pool_first', 'away': 'zvz_12hatch', 'name': '4풀 vs 12앞마당'},
    {'home': 'zvz_3hatch_nopool', 'away': 'zvz_3hatch_nopool', 'name': '3해처리 미러'},
    {'home': 'zvz_pool_first', 'away': 'zvz_9pool', 'name': '4풀 vs 9풀'},
    {'home': 'zvz_pool_first', 'away': 'zvz_3hatch_nopool', 'name': '4풀 vs 3해처리'},
    {'home': 'zvz_9pool', 'away': 'zvz_9pool', 'name': '9풀 미러'},
    {'home': 'zvz_12pool', 'away': 'zvz_3hatch_nopool', 'name': '12풀 vs 3해처리'},
    {'home': 'zvz_9overpool', 'away': 'zvz_9overpool', 'name': '9오버풀 미러'},
  ];

  test('ZvZ 전체 시나리오 보정용 JSON 로그 내보내기', () async {
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
      matchup: 'ZvZ',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/zvz_log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/zvz_log.json');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
