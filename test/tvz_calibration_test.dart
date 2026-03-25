/// TvZ 보정 루프용 테스트 - JSON 로그 내보내기
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../tools/export_log_helper.dart';

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
    id: 'zerg_away',
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
    id: 'test_fighting_spirit',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  // 시나리오별 빌드 조합 (scenario_tvz.dart에서 추출)
  final scenarios = [
    {'home': 'tvz_sk', 'away': 'zvt_2hatch_mutal', 'name': '바이오닉 러시 vs 뮤탈리스크'},
    {'home': 'tvz_3fac_goliath', 'away': 'zvt_2hatch_lurker', 'name': '메카닉 vs 럴커/디파일러 장기전'},
    {'home': 'tvz_bunker', 'away': 'zvt_12pool', 'name': '센터 8배럭 벙커 vs 스탠다드 저그'},
    {'home': 'tvz_111', 'away': 'zvt_3hatch_nopool', 'name': '111 밸런스 vs 노풀 3해처리 매크로'},
    {'home': 'tvz_2star_wraith', 'away': 'zvt_2hatch_mutal', 'name': '투스타 레이스 vs 뮤탈리스크 공중전'},
    {'home': 'tvz_bunker', 'away': 'zvt_4pool', 'name': '센터 8배럭 벙커 vs 4풀 극초반 승부'},
    {'home': 'tvz_sk', 'away': 'zvt_9pool', 'name': '스탠다드 테란 vs 9풀/9오버풀 초반 압박'},
    {'home': 'tvz_valkyrie', 'away': 'zvt_2hatch_mutal', 'name': '발키리 대공 vs 뮤탈리스크'},
    {'home': 'tvz_sk', 'away': 'zvt_3hatch_nopool', 'name': '배럭더블 vs 노풀 3해처리 매크로전'},
    {'home': 'tvz_sk', 'away': 'zvt_1hatch_allin', 'name': '스탠다드 테란 vs 원해처리 럴커 올인'},
    {'home': 'tvz_3fac_goliath', 'away': 'zvt_trans_ultra_hive', 'name': '메카닉 vs 하이브 울트라/디파일러 후반전'},
  ];

  test('TvZ 전체 시나리오 보정용 JSON 로그 내보내기', () async {
    const gamesPerScenario = 100;
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
      matchup: 'TvZ',
      scenarioId: null,
      games: allGames,
      outputPath: 'test/output/tvz_log.json',
      branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/tvz_log.json');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
