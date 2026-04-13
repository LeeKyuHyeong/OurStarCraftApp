// 전 종족전 통합 보정 테스트 - calibration_criteria.js용 JSON 로그 내보내기
//
// 사용법:
//   flutter test test/calibration_test.dart                  # 전체
//   flutter test --name "ZvZ" test/calibration_test.dart     # ZvZ만
//   flutter test --name "TvT" test/calibration_test.dart     # TvT만
//   flutter test --name "PvP" test/calibration_test.dart     # PvP만
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import '../tools/export_log_helper.dart';

// ── 공통 헬퍼 ──

Player _player(String id, String name, int raceIndex) => Player(
  id: id, name: name, raceIndex: raceIndex,
  stats: const PlayerStats(
    sense: 700, control: 700, attack: 700, harass: 700,
    strategy: 700, macro: 700, defense: 700, scout: 700,
  ),
  levelValue: 7, condition: 100,
);

const _testMap = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

const _testMapWithMatchup = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
  matchup: RaceMatchup(tvzTerranWinRate: 50, zvpZergWinRate: 50, pvtProtossWinRate: 50),
);

class _Scenario {
  final String home;
  final String away;
  final String name;
  const _Scenario(this.home, this.away, this.name);
}

/// 미러 매치업용 시나리오 (i <= j 삼각형)
List<_Scenario> _mirrorScenarios(List<String> builds) {
  final list = <_Scenario>[];
  for (int i = 0; i < builds.length; i++) {
    for (int j = i; j < builds.length; j++) {
      final name = i == j ? '${builds[i]} 미러' : '${builds[i]} vs ${builds[j]}';
      list.add(_Scenario(builds[i], builds[j], name));
    }
  }
  return list;
}

/// 크로스 매치업용 시나리오 (homeBuilds x awayBuilds 전체 매트릭스)
List<_Scenario> _crossScenarios(List<String> homeBuilds, List<String> awayBuilds) {
  final list = <_Scenario>[];
  for (final h in homeBuilds) {
    for (final a in awayBuilds) {
      list.add(_Scenario(h, a, '$h vs $a'));
    }
  }
  return list;
}

// ── 종족전별 설정 ──

class _CalibrationConfig {
  final String matchup;       // 'TvT', 'TvZ', ...
  final String outputDir;     // 'tvt', 'tvz', ...
  final Player homePlayer;
  final Player awayPlayer;
  final GameMap map;
  final int gamesPerScenario;
  final List<_Scenario> scenarios;
  final int timeoutMinutes;

  const _CalibrationConfig({
    required this.matchup,
    required this.outputDir,
    required this.homePlayer,
    required this.awayPlayer,
    required this.map,
    required this.gamesPerScenario,
    required this.scenarios,
    this.timeoutMinutes = 30,
  });
}

final _configs = <_CalibrationConfig>[
  // TvT: 9빌드 삼각형 = 45시나리오, 100경기
  _CalibrationConfig(
    matchup: 'TvT', outputDir: 'tvt',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('terran_away', '박명수', 0),
    map: _testMap,
    gamesPerScenario: 100,
    scenarios: _mirrorScenarios([
      'tvt_bbs', 'tvt_1fac_1star', 'tvt_2fac_push',
      'tvt_2star', 'tvt_1bar_double', 'tvt_1fac_double',
      'tvt_nobar_double', 'tvt_fd_rush',
    ]),
  ),

  // TvZ: 7T x 7Z = 49시나리오, 200경기
  _CalibrationConfig(
    matchup: 'TvZ', outputDir: 'tvz',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('zerg_away', '이재동', 1),
    map: _testMapWithMatchup,
    gamesPerScenario: 200,
    scenarios: _crossScenarios(
      ['tvz_nobar_double', 'tvz_bar_double', 'tvz_111', 'tvz_2bar_academy',
       'tvz_fac_double', 'tvz_2star', 'tvz_bbs'],
      ['zvt_trans_2hatch_mutal', 'zvt_4pool', 'zvt_trans_530_mutal',
       'zvt_trans_lurker_defiler', 'zvt_trans_mutal_lurker',
       'zvt_trans_mutal_ultra', 'zvt_trans_ultra_hive'],
    ),
  ),

  // PvT: 선별 11시나리오, 200경기
  _CalibrationConfig(
    matchup: 'PvT', outputDir: 'pvt',
    homePlayer: _player('protoss_home', '김택용', 2),
    awayPlayer: _player('terran_away', '이영호', 0),
    map: _testMap,
    gamesPerScenario: 200,
    scenarios: [
      const _Scenario('pvt_1gate_expand', 'tvp_double', '드라군 확장 vs 팩더블'),
      const _Scenario('pvt_reaver_shuttle', 'tvp_fake_double', '리버 셔틀 vs 타이밍'),
      const _Scenario('pvt_dark_swing', 'tvp_double', '다크 vs 스탠다드'),
      const _Scenario('pvt_proxy_gate', 'tvp_double', '치즈 vs 스탠다드'),
      const _Scenario('pvt_carrier', 'tvp_anti_carrier', '캐리어 vs 안티'),
      const _Scenario('pvt_trans_5gate_push', 'tvp_double', '5게이트 푸시'),
      const _Scenario('pvt_proxy_gate', 'tvp_bbs', '치즈 vs 치즈'),
      const _Scenario('pvt_reaver_shuttle', 'tvp_bbs', '리버 vs BBS'),
      const _Scenario('pvt_1gate_expand', 'tvp_mine_triple', '확장 vs 마인트리플'),
      const _Scenario('pvt_1gate_expand', 'tvp_11up_8fac', '확장 vs 11업8팩'),
      const _Scenario('pvt_1gate_expand', 'tvp_fd', 'FD테란 vs 프로토스'),
    ],
    timeoutMinutes: 10,
  ),

  // PvP: 선별 10시나리오, 200경기
  _CalibrationConfig(
    matchup: 'PvP', outputDir: 'pvp',
    homePlayer: _player('protoss_home', '홍진호', 2),
    awayPlayer: _player('protoss_away', '이제동', 2),
    map: _testMap,
    gamesPerScenario: 200,
    scenarios: [
      const _Scenario('pvp_2gate_dragoon', 'pvp_2gate_dragoon', '드라군 넥서스 미러'),
      const _Scenario('pvp_2gate_dragoon', 'pvp_1gate_multi', '드라군 vs 노게이트넥서스'),
      const _Scenario('pvp_1gate_robo', 'pvp_2gate_dragoon', '로보 vs 투게이트드라군'),
      const _Scenario('pvp_dark_allin', 'pvp_2gate_dragoon', '다크 vs 드라군'),
      const _Scenario('pvp_zealot_rush', 'pvp_2gate_dragoon', '질럿러시 vs 드라군'),
      const _Scenario('pvp_dark_allin', 'pvp_zealot_rush', '다크 vs 질럿러시'),
      const _Scenario('pvp_1gate_robo', 'pvp_1gate_robo', '로보 미러'),
      const _Scenario('pvp_4gate_dragoon', 'pvp_1gate_multi', '4게이트 vs 멀티'),
      const _Scenario('pvp_zealot_rush', 'pvp_1gate_robo', '질럿러시 vs 리버'),
      const _Scenario('pvp_dark_allin', 'pvp_dark_allin', '다크 미러'),
    ],
    timeoutMinutes: 10,
  ),

  // ZvP: 선별 11시나리오, 200경기
  _CalibrationConfig(
    matchup: 'ZvP', outputDir: 'zvp',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('protoss_away', '김택용', 2),
    map: _testMap,
    gamesPerScenario: 200,
    scenarios: [
      const _Scenario('zvp_12hatch', 'pvz_forge_cannon', '히드라 vs 포지더블'),
      const _Scenario('zvp_2hatch_mutal', 'pvz_forge_cannon', '뮤탈 vs 포지더블'),
      const _Scenario('zvp_9pool', 'pvz_forge_cannon', '9풀 vs 포지더블'),
      const _Scenario('zvp_4pool', 'pvz_proxy_gate', '치즈 vs 치즈'),
      const _Scenario('zvp_mukerji', 'pvz_corsair_reaver', '머커지 vs 커세어리버'),
      const _Scenario('zvp_scourge_defiler', 'pvz_forge_cannon', '스커지디파일러 vs 포지'),
      const _Scenario('zvp_973_hydra', 'pvz_forge_cannon', '973히드라 러시'),
      const _Scenario('zvp_12hatch', 'pvz_2gate_zealot', '스탠다드 vs 투게이트'),
      const _Scenario('zvp_12hatch', 'pvz_corsair_reaver', '3해처리 vs 커세어리버'),
      const _Scenario('zvp_trans_hydra_lurker', 'pvz_forge_cannon', '히드라럴커 vs 포지'),
      const _Scenario('zvp_4pool', 'pvz_forge_cannon', '치즈 vs 포지'),
    ],
    timeoutMinutes: 10,
  ),

  // ZvZ: 6빌드 삼각형 = 21시나리오, 200경기
  _CalibrationConfig(
    matchup: 'ZvZ', outputDir: 'zvz',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('zerg_away', '박성준', 1),
    map: _testMap,
    gamesPerScenario: 200,
    scenarios: _mirrorScenarios([
      'zvz_4pool', 'zvz_9pool_speed', 'zvz_9pool_lair', 'zvz_9overpool',
      'zvz_12pool', 'zvz_12hatch',
    ]),
  ),
];

// ── 테스트 실행 ──

void main() {
  for (final config in _configs) {
    test('${config.matchup} 전체 ${config.scenarios.length}개 시나리오 보정용 JSON 로그 내보내기', () async {
      final allGames = <Map<String, dynamic>>[];
      final branchStats = <String, int>{};

      for (final scenario in config.scenarios) {
        for (int direction = 0; direction < 2; direction++) {
          final isReversed = direction == 1;
          final actualHomeBuild = isReversed ? scenario.away : scenario.home;
          final actualAwayBuild = isReversed ? scenario.home : scenario.away;
          final actualHomePlayer = isReversed ? config.awayPlayer : config.homePlayer;
          final actualAwayPlayer = isReversed ? config.homePlayer : config.awayPlayer;

          for (int i = 0; i < config.gamesPerScenario ~/ 2; i++) {
            final service = MatchSimulationService();
            final stream = service.simulateMatchWithLog(
              homePlayer: actualHomePlayer,
              awayPlayer: actualAwayPlayer,
              map: config.map,
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
              homeBuildId: scenario.home,
              awayBuildId: scenario.away,
              isReversed: isReversed,
            );
            allGames.add(gameJson);

            final branchKey = '${scenario.name}|${isReversed ? "R" : "N"}';
            branchStats[branchKey] = (branchStats[branchKey] ?? 0) + 1;
          }
        }
        print('${scenario.name}: ${config.gamesPerScenario}경기 완료');
      }

      await exportLogsToJson(
        matchup: config.matchup,
        scenarioId: null,
        games: allGames,
        outputPath: 'test/output/${config.outputDir}/log.json',
        branchStats: branchStats,
      );

      print('총 ${allGames.length}경기 (${config.scenarios.length}개 시나리오) → test/output/${config.outputDir}/log.json');
    }, timeout: Timeout(Duration(minutes: config.timeoutMinutes)));
  }
}
