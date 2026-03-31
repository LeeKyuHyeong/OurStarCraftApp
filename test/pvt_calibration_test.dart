/// PvT 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../tools/export_log_helper.dart';

void main() {
  final homePlayer = Player(
    id: 'protoss_home',
    name: '김택용',
    raceIndex: 2,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'terran_away',
    name: '이영호',
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

  // scenario_pvt.dart에서 읽은 시나리오별 빌드 조합
  final scenarios = [
    {'home': 'pvt_1gate_expand', 'away': 'tvp_double', 'name': '드라군 확장 vs 팩더블'},
    {'home': 'pvt_reaver_shuttle', 'away': 'tvp_fake_double', 'name': '리버 셔틀 vs 타이밍'},
    {'home': 'pvt_dark_swing', 'away': 'tvp_double', 'name': '다크 vs 스탠다드'},
    {'home': 'pvt_proxy_gate', 'away': 'tvp_double', 'name': '치즈 vs 스탠다드'},
    {'home': 'pvt_carrier', 'away': 'tvp_anti_carrier', 'name': '캐리어 vs 안티'},
    {'home': 'pvt_trans_5gate_push', 'away': 'tvp_double', 'name': '5게이트 푸시'},
    {'home': 'pvt_proxy_gate', 'away': 'tvp_bbs', 'name': '치즈 vs 치즈'},
    {'home': 'pvt_reaver_shuttle', 'away': 'tvp_bbs', 'name': '리버 vs BBS'},
    {'home': 'pvt_1gate_expand', 'away': 'tvp_mine_triple', 'name': '확장 vs 마인트리플'},
    {'home': 'pvt_1gate_expand', 'away': 'tvp_11up_8fac', 'name': '확장 vs 11업8팩'},
    {'home': 'pvt_1gate_expand', 'away': 'tvp_fd', 'name': 'FD테란 vs 프로토스'},
  ];

  test('PvT 전체 시나리오 보정용 JSON 로그 내보내기', () async {
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
      matchup: 'PvT',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/pvt_log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/pvt_log.json');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
