/// PvP 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../../tools/export_log_helper.dart';

void main() {
  final homePlayer = Player(
    id: 'protoss_home',
    name: '홍진호',
    raceIndex: 2,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'protoss_away',
    name: '이제동',
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

  // 시나리오별 빌드 조합
  final scenarios = [
    {'home': 'pvp_2gate_dragoon', 'away': 'pvp_2gate_dragoon', 'name': '드라군 넥서스 미러'},
    {'home': 'pvp_2gate_dragoon', 'away': 'pvp_1gate_multi', 'name': '드라군 vs 노게이트넥서스'},
    {'home': 'pvp_1gate_robo', 'away': 'pvp_2gate_dragoon', 'name': '로보 vs 투게이트드라군'},
    {'home': 'pvp_dark_allin', 'away': 'pvp_2gate_dragoon', 'name': '다크 vs 드라군'},
    {'home': 'pvp_zealot_rush', 'away': 'pvp_2gate_dragoon', 'name': '질럿러시 vs 드라군'},
    {'home': 'pvp_dark_allin', 'away': 'pvp_zealot_rush', 'name': '다크 vs 질럿러시'},
    {'home': 'pvp_1gate_robo', 'away': 'pvp_1gate_robo', 'name': '로보 미러'},
    {'home': 'pvp_4gate_dragoon', 'away': 'pvp_1gate_multi', 'name': '4게이트 vs 멀티'},
    {'home': 'pvp_zealot_rush', 'away': 'pvp_1gate_robo', 'name': '질럿러시 vs 리버'},
    {'home': 'pvp_dark_allin', 'away': 'pvp_dark_allin', 'name': '다크 미러'},
  ];

  test('PvP 전체 시나리오 보정용 JSON 로그 내보내기', () async {
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
      matchup: 'PvP',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/pvp/log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/pvp/log.json');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
