/// TvT 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../../tools/export_log_helper.dart';

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
    name: '박명수',
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

  // 시나리오별 빌드 조합 (전체 16개 시나리오)
  final scenarios = [
    // 크로스 매치업 (9개)
    {'home': 'tvt_cc_first', 'away': 'tvt_2fac_vulture', 'name': '배럭더블 vs 투팩벌처'},
    {'home': 'tvt_bbs', 'away': 'tvt_cc_first', 'name': 'BBS vs 노배럭더블'},
    {'home': 'tvt_wraith_cloak', 'away': 'tvt_cc_first', 'name': '레이스 vs 배럭더블'},
    {'home': 'tvt_5fac', 'away': 'tvt_1fac_expand', 'name': '5팩 vs 마인트리플'},
    {'home': 'tvt_bbs', 'away': 'tvt_2fac_vulture', 'name': 'BBS vs 테크빌드'},
    {'home': 'tvt_1fac_push', 'away': 'tvt_wraith_cloak', 'name': '공격적 빌드 대결'},
    {'home': 'tvt_cc_first', 'away': 'tvt_1fac_expand', 'name': '배럭더블 vs 원팩익스팬드'},
    {'home': 'tvt_1fac_push', 'away': 'tvt_5fac', 'name': '원팩푸시 vs 5팩'},
    {'home': 'tvt_2fac_vulture', 'away': 'tvt_1fac_expand', 'name': '투팩벌처 vs 원팩익스팬드'},
    // 미러 (7개)
    {'home': 'tvt_bbs', 'away': 'tvt_bbs', 'name': 'BBS 미러'},
    {'home': 'tvt_cc_first', 'away': 'tvt_cc_first', 'name': '배럭더블 미러'},
    {'home': 'tvt_2fac_vulture', 'away': 'tvt_2fac_vulture', 'name': '투팩벌처 미러'},
    {'home': 'tvt_wraith_cloak', 'away': 'tvt_wraith_cloak', 'name': '레이스 미러'},
    {'home': 'tvt_1fac_push', 'away': 'tvt_1fac_push', 'name': '원팩푸시 미러'},
    {'home': 'tvt_5fac', 'away': 'tvt_5fac', 'name': '5팩 미러'},
    {'home': 'tvt_1fac_expand', 'away': 'tvt_1fac_expand', 'name': '원팩익스팬드 미러'},
  ];

  test('TvT 전체 시나리오 보정용 JSON 로그 내보내기', () async {
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
          final allText = state.battleLogEntries.map((e) => e.text).join(' ');
          final branchKey = '$scenarioName|${isReversed ? "R" : "N"}';
          branchStats[branchKey] = (branchStats[branchKey] ?? 0) + 1;
        }
      }
      print('$scenarioName: ${gamesPerScenario}경기 완료');
    }

    await exportLogsToJson(
      matchup: 'TvT',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/tvt/log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/tvt/log.json');
  }, timeout: const Timeout(Duration(minutes: 30)));
}
