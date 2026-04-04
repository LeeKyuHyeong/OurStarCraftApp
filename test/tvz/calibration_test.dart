/// TvZ 보정 루프용 테스트 - JSON 로그 내보내기 (전체 49개 시나리오)
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../../tools/export_log_helper.dart';

void main() {
  final homePlayer = Player(
    id: 'terran_home', name: '이영호', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );

  final awayPlayer = Player(
    id: 'zerg_away', name: '이재동', raceIndex: 1,
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
    matchup: RaceMatchup(tvzTerranWinRate: 50, zvpZergWinRate: 50, pvtProtossWinRate: 50),
  );

  final scenarios = [
    // === 노배럭더블 (7개) ===
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_2hatch_mutal', 'name': '노배럭더블 vs 2해처리뮤탈'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_4pool', 'name': '노배럭더블 vs 4풀'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_530_mutal', 'name': '노배럭더블 vs 530뮤탈'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_lurker_defiler', 'name': '노배럭더블 vs 럴커디파일러'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_mutal_lurker', 'name': '노배럭더블 vs 뮤탈럴커'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_mutal_ultra', 'name': '노배럭더블 vs 뮤탈울트라'},
    {'home': 'tvz_nobar_double', 'away': 'zvt_trans_ultra_hive', 'name': '노배럭더블 vs 울트라하이브'},
    // === 배럭더블 (7개) ===
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_2hatch_mutal', 'name': '배럭더블 vs 2해처리뮤탈'},
    {'home': 'tvz_bar_double', 'away': 'zvt_4pool', 'name': '배럭더블 vs 4풀'},
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_530_mutal', 'name': '배럭더블 vs 530뮤탈'},
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_lurker_defiler', 'name': '배럭더블 vs 럴커디파일러'},
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_mutal_lurker', 'name': '배럭더블 vs 뮤탈럴커'},
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_mutal_ultra', 'name': '배럭더블 vs 뮤탈울트라'},
    {'home': 'tvz_bar_double', 'away': 'zvt_trans_ultra_hive', 'name': '배럭더블 vs 울트라하이브'},
    // === 111 (7개) ===
    {'home': 'tvz_111', 'away': 'zvt_trans_2hatch_mutal', 'name': '111 vs 2해처리뮤탈'},
    {'home': 'tvz_111', 'away': 'zvt_4pool', 'name': '111 vs 4풀'},
    {'home': 'tvz_111', 'away': 'zvt_trans_530_mutal', 'name': '111 vs 530뮤탈'},
    {'home': 'tvz_111', 'away': 'zvt_trans_lurker_defiler', 'name': '111 vs 럴커디파일러'},
    {'home': 'tvz_111', 'away': 'zvt_trans_mutal_lurker', 'name': '111 vs 뮤탈럴커'},
    {'home': 'tvz_111', 'away': 'zvt_trans_mutal_ultra', 'name': '111 vs 뮤탈울트라'},
    {'home': 'tvz_111', 'away': 'zvt_trans_ultra_hive', 'name': '111 vs 울트라하이브'},
    // === 2배럭아카데미 (7개) ===
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_2hatch_mutal', 'name': '2배럭아카 vs 2해처리뮤탈'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_4pool', 'name': '2배럭아카 vs 4풀'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_530_mutal', 'name': '2배럭아카 vs 530뮤탈'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_lurker_defiler', 'name': '2배럭아카 vs 럴커디파일러'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_mutal_lurker', 'name': '2배럭아카 vs 뮤탈럴커'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_mutal_ultra', 'name': '2배럭아카 vs 뮤탈울트라'},
    {'home': 'tvz_2bar_academy', 'away': 'zvt_trans_ultra_hive', 'name': '2배럭아카 vs 울트라하이브'},
    // === 팩토리더블 (7개) ===
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_2hatch_mutal', 'name': '팩더블 vs 2해처리뮤탈'},
    {'home': 'tvz_fac_double', 'away': 'zvt_4pool', 'name': '팩더블 vs 4풀'},
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_530_mutal', 'name': '팩더블 vs 530뮤탈'},
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_lurker_defiler', 'name': '팩더블 vs 럴커디파일러'},
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_mutal_lurker', 'name': '팩더블 vs 뮤탈럴커'},
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_mutal_ultra', 'name': '팩더블 vs 뮤탈울트라'},
    {'home': 'tvz_fac_double', 'away': 'zvt_trans_ultra_hive', 'name': '팩더블 vs 울트라하이브'},
    // === 2스타레이스 (7개) ===
    {'home': 'tvz_2star', 'away': 'zvt_trans_2hatch_mutal', 'name': '2스타 vs 2해처리뮤탈'},
    {'home': 'tvz_2star', 'away': 'zvt_4pool', 'name': '2스타 vs 4풀'},
    {'home': 'tvz_2star', 'away': 'zvt_trans_530_mutal', 'name': '2스타 vs 530뮤탈'},
    {'home': 'tvz_2star', 'away': 'zvt_trans_lurker_defiler', 'name': '2스타 vs 럴커디파일러'},
    {'home': 'tvz_2star', 'away': 'zvt_trans_mutal_lurker', 'name': '2스타 vs 뮤탈럴커'},
    {'home': 'tvz_2star', 'away': 'zvt_trans_mutal_ultra', 'name': '2스타 vs 뮤탈울트라'},
    {'home': 'tvz_2star', 'away': 'zvt_trans_ultra_hive', 'name': '2스타 vs 울트라하이브'},
    // === BBS (7개) ===
    {'home': 'tvz_bbs', 'away': 'zvt_trans_2hatch_mutal', 'name': 'BBS vs 2해처리뮤탈'},
    {'home': 'tvz_bbs', 'away': 'zvt_4pool', 'name': 'BBS vs 4풀'},
    {'home': 'tvz_bbs', 'away': 'zvt_trans_530_mutal', 'name': 'BBS vs 530뮤탈'},
    {'home': 'tvz_bbs', 'away': 'zvt_trans_lurker_defiler', 'name': 'BBS vs 럴커디파일러'},
    {'home': 'tvz_bbs', 'away': 'zvt_trans_mutal_lurker', 'name': 'BBS vs 뮤탈럴커'},
    {'home': 'tvz_bbs', 'away': 'zvt_trans_mutal_ultra', 'name': 'BBS vs 뮤탈울트라'},
    {'home': 'tvz_bbs', 'away': 'zvt_trans_ultra_hive', 'name': 'BBS vs 울트라하이브'},
  ];

  test('TvZ 전체 시나리오 보정용 JSON 로그 내보내기', () async {
    const gamesPerScenario = 200;
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
            homePlayer: actualHomePlayer, awayPlayer: actualAwayPlayer,
            map: testMap, getIntervalMs: () => 0,
            forcedHomeBuildId: actualHomeBuild, forcedAwayBuildId: actualAwayBuild,
          );

          SimulationState? state;
          await for (final s in stream) { state = s; }
          if (state == null) continue;

          final gameJson = gameToJson(
            gameIndex: allGames.length, finalState: state,
            homePlayerName: actualHomePlayer.name, awayPlayerName: actualAwayPlayer.name,
            homeBuildId: homeBuild, awayBuildId: awayBuild, isReversed: isReversed,
          );
          allGames.add(gameJson);

          final branchKey = '$scenarioName|${isReversed ? "R" : "N"}';
          branchStats[branchKey] = (branchStats[branchKey] ?? 0) + 1;
        }
      }
      print('$scenarioName: ${gamesPerScenario}경기 완료');
    }

    await exportLogsToJson(
      matchup: 'TvZ', scenarioId: null, games: allGames,
      outputPath: 'test/output/tvz/log.json', branchStats: branchStats,
    );

    print('총 ${allGames.length}경기 → test/output/tvz/log.json');
  }, timeout: const Timeout(Duration(minutes: 30)));
}
