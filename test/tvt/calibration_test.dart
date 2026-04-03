/// TvT 보정 루프용 테스트 - 45개 전체 시나리오 JSON 로그 내보내기
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

  // TvT 전체 빌드 (9개)
  const builds = [
    'tvt_bbs',
    'tvt_1fac_1star',
    'tvt_2fac_push',
    'tvt_5fac',
    'tvt_2star',
    'tvt_1bar_double',
    'tvt_1fac_double',
    'tvt_nobar_double',
    'tvt_fd_rush',
  ];

  // 45개 시나리오 생성 (9미러 + 36크로스, 크로스는 정렬순으로 한 방향만)
  final scenarios = <Map<String, String>>[];
  for (int i = 0; i < builds.length; i++) {
    for (int j = i; j < builds.length; j++) {
      final name = i == j
          ? '${builds[i]} 미러'
          : '${builds[i]} vs ${builds[j]}';
      scenarios.add({
        'home': builds[i],
        'away': builds[j],
        'name': name,
      });
    }
  }

  test('TvT 전체 45개 시나리오 보정용 JSON 로그 내보내기', () async {
    const gamesPerScenario = 100; // 시나리오당 100경기 (정50 + 역50)
    final allGames = <Map<String, dynamic>>[];
    final branchStats = <String, int>{};

    for (final scenario in scenarios) {
      final homeBuild = scenario['home']!;
      final awayBuild = scenario['away']!;
      final scenarioName = scenario['name']!;

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

          // 분기 통계: 시나리오별로 그룹핑
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

    print('총 ${allGames.length}경기 (${scenarios.length}개 시나리오) → test/output/tvt/log.json');
  }, timeout: const Timeout(Duration(minutes: 30)));
}
