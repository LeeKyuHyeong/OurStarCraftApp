import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final protossPlayer = Player(
    id: 'protoss_test', name: '이제동', raceIndex: 2,
    stats: const PlayerStats(sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700),
    levelValue: 7, condition: 100,
  );
  final terranPlayer = Player(
    id: 'terran_test', name: '이영호', raceIndex: 0,
    stats: const PlayerStats(sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(id: 'test_map', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5, airAccessibility: 6, centerImportance: 5);

  Future<Map<String, dynamic>> run20Games({
    required String homeBuild,
    required String awayBuild,
    required String scenarioId,
    bool verbose = false,
  }) async {
    int homeWinNormal = 0, homeWinReversed = 0;
    final normalLogs = <Set<String>>[];
    final reversedLogs = <Set<String>>[];
    final normalArmyDiffs = <int>[];
    final normalResDiffs = <int>[];
    final reversedArmyDiffs = <int>[];
    final reversedResDiffs = <int>[];

    // 정방향 25경기 (프로토스 홈)
    for (int i = 0; i < 25; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protossPlayer, awayPlayer: terranPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
      if (state != null) {
        normalLogs.add(state.battleLogEntries.map((e) => e.text).toSet());
        normalArmyDiffs.add(state.homeArmy - state.awayArmy);
        normalResDiffs.add(state.homeResources - state.awayResources);
        if (verbose) {
          print('  N#$i: Parmy=${state.homeArmy} Tarmy=${state.awayArmy} diff=${state.homeArmy - state.awayArmy} | Pres=${state.homeResources} Tres=${state.awayResources} | ${state.homeWin == true ? "P" : "T"}');
        }
      }
    }

    // 역방향 25경기 (테란 홈)
    for (int i = 0; i < 25; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: protossPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: awayBuild, forcedAwayBuildId: homeBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
      if (state != null) {
        reversedLogs.add(state.battleLogEntries.map((e) => e.text).toSet());
        reversedArmyDiffs.add(state.awayArmy - state.homeArmy);
        reversedResDiffs.add(state.awayResources - state.homeResources);
        if (verbose) {
          print('  R#$i: Tarmy=${state.homeArmy} Parmy=${state.awayArmy} diff=${state.awayArmy - state.homeArmy} | Tres=${state.homeResources} Pres=${state.awayResources} | ${state.homeWin == false ? "P" : "T"}');
        }
      }
    }

    int uniqueNormal = normalLogs.map((s) => s.join('||')).toSet().length;
    int uniqueReversed = reversedLogs.map((s) => s.join('||')).toSet().length;

    final avgNormalArmy = normalArmyDiffs.isEmpty ? 0.0 : normalArmyDiffs.reduce((a,b) => a+b) / normalArmyDiffs.length;
    final avgReversedArmy = reversedArmyDiffs.isEmpty ? 0.0 : reversedArmyDiffs.reduce((a,b) => a+b) / reversedArmyDiffs.length;

    return {
      'homeWinNormal': homeWinNormal,
      'homeWinReversed': homeWinReversed,
      'uniqueNormal': uniqueNormal,
      'uniqueReversed': uniqueReversed,
      'avgNormalArmyDiff': avgNormalArmy,
      'avgReversedArmyDiff': avgReversedArmy,
    };
  }

  // ===== 0% 시나리오 진단 =====
  test('S1 pvt_dragoon_expand_vs_factory 20경기', () async {
    print('=== S1 pvt_dragoon_expand_vs_factory (DIAGNOSTIC) ===');
    final r = await run20Games(
      homeBuild: 'pvt_1gate_expand', awayBuild: 'tvp_double',
      scenarioId: 'pvt_dragoon_expand_vs_factory', verbose: true,
    );
    print('정방향 P승: ${r['homeWinNormal']}/25 | 역방향 P승: ${r['homeWinReversed']}/25 | 차이: ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
    print('평균 P-T army차: 정방향 ${(r['avgNormalArmyDiff'] as double).toStringAsFixed(1)} / 역방향 ${(r['avgReversedArmyDiff'] as double).toStringAsFixed(1)}');
  });

  test('S2 pvt_reaver_vs_timing 50경기', () async {
    print('=== S2 pvt_reaver_vs_timing (DIAGNOSTIC) ===');
    final r = await run20Games(
      homeBuild: 'pvt_reaver_shuttle', awayBuild: 'tvp_fake_double',
      scenarioId: 'pvt_reaver_vs_timing', verbose: true,
    );
    print('정방향 P승: ${r['homeWinNormal']}/25 | 역방향 P승: ${r['homeWinReversed']}/25 | 차이: ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
    print('평균 P-T army차: 정방향 ${(r['avgNormalArmyDiff'] as double).toStringAsFixed(1)} / 역방향 ${(r['avgReversedArmyDiff'] as double).toStringAsFixed(1)}');
  });

  test('S3 pvt_dark_vs_standard 50경기', () async {
    print('=== S3 pvt_dark_vs_standard (DIAGNOSTIC) ===');
    final r = await run20Games(
      homeBuild: 'pvt_dark_swing', awayBuild: 'tvp_double',
      scenarioId: 'pvt_dark_vs_standard', verbose: true,
    );
    print('정방향 P승: ${r['homeWinNormal']}/25 | 역방향 P승: ${r['homeWinReversed']}/25 | 차이: ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
    print('평균 P-T army차: 정방향 ${(r['avgNormalArmyDiff'] as double).toStringAsFixed(1)} / 역방향 ${(r['avgReversedArmyDiff'] as double).toStringAsFixed(1)}');
  });

  test('S5 pvt_carrier_vs_anti 50경기', () async {
    print('=== S5 pvt_carrier_vs_anti (DIAGNOSTIC) ===');
    final r = await run20Games(
      homeBuild: 'pvt_carrier', awayBuild: 'tvp_anti_carrier',
      scenarioId: 'pvt_carrier_vs_anti', verbose: true,
    );
    print('정방향 P승: ${r['homeWinNormal']}/25 | 역방향 P승: ${r['homeWinReversed']}/25 | 차이: ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
    print('평균 P-T army차: 정방향 ${(r['avgNormalArmyDiff'] as double).toStringAsFixed(1)} / 역방향 ${(r['avgReversedArmyDiff'] as double).toStringAsFixed(1)}');
  });

  test('S10 pvt_11up8fac_vs_expand 50경기', () async {
    print('=== S10 pvt_11up8fac_vs_expand (DIAGNOSTIC) ===');
    final r = await run20Games(
      homeBuild: 'pvt_1gate_expand', awayBuild: 'tvp_11up_8fac',
      scenarioId: 'pvt_11up8fac_vs_expand', verbose: true,
    );
    print('정방향 P승: ${r['homeWinNormal']}/25 | 역방향 P승: ${r['homeWinReversed']}/25 | 차이: ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
    print('평균 P-T army차: 정방향 ${(r['avgNormalArmyDiff'] as double).toStringAsFixed(1)} / 역방향 ${(r['avgReversedArmyDiff'] as double).toStringAsFixed(1)}');
  });

  // ===== 나머지 시나리오 (간략) =====
  test('S4 pvt_cheese_vs_standard 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_proxy_gate', awayBuild: 'tvp_double', scenarioId: 'pvt_cheese_vs_standard');
    print('=== S4: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });

  test('S6 pvt_5gate_push 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_trans_5gate_push', awayBuild: 'tvp_double', scenarioId: 'pvt_5gate_push');
    print('=== S6: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });

  test('S7 pvt_cheese_vs_cheese 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_proxy_gate', awayBuild: 'tvp_bbs', scenarioId: 'pvt_cheese_vs_cheese');
    print('=== S7: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });

  test('S8 pvt_reaver_vs_bbs 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_reaver_shuttle', awayBuild: 'tvp_bbs', scenarioId: 'pvt_reaver_vs_bbs');
    print('=== S8: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });

  test('S9 pvt_mine_triple 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_1gate_expand', awayBuild: 'tvp_mine_triple', scenarioId: 'pvt_mine_triple');
    print('=== S9: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });

  test('S11 pvt_fd_terran 50경기', () async {
    final r = await run20Games(homeBuild: 'pvt_1gate_expand', awayBuild: 'tvp_fd', scenarioId: 'pvt_fd_terran');
    print('=== S11: 정방향 ${r['homeWinNormal']}/25 역방향 ${r['homeWinReversed']}/25 차이 ${((r['homeWinNormal'] as int) - (r['homeWinReversed'] as int)).abs() * 4}%p');
  });
}
