import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final terran1 = Player(
    id: 'terran1_test', name: '이영호', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  final terran2 = Player(
    id: 'terran2_test', name: '박성준', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(
    id: 'test_map', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  Future<Map<String, dynamic>> runScenario(String homeBuild, String awayBuild, {int games = 50}) async {
    int homeWinNormal = 0, homeWinReversed = 0;

    // Forward 10 games
    for (int i = 0; i < games; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terran1, awayPlayer: terran2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    // Reversed 10 games (swap builds)
    for (int i = 0; i < games; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terran1, awayPlayer: terran2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: awayBuild, forcedAwayBuildId: homeBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final normalRate = homeWinNormal * 100 ~/ games;
    final reversedRate = homeWinReversed * 100 ~/ games;
    final totalWins = homeWinNormal + homeWinReversed;
    final totalRate = totalWins * 100 ~/ (games * 2);
    final bias = (normalRate - reversedRate).abs();

    return {
      'homeWinNormal': homeWinNormal,
      'homeWinReversed': homeWinReversed,
      'normalRate': normalRate,
      'reversedRate': reversedRate,
      'totalRate': totalRate,
      'bias': bias,
    };
  }

  // ===== 비미러 시나리오 (8개) =====

  test('1. tvt_rax_double_vs_fac_double (cc_first vs 2fac_vulture)', () async {
    final r = await runScenario('tvt_cc_first', 'tvt_2fac_vulture');
    print('=== tvt_rax_double_vs_fac_double ===');
    print('정방향(cc_first) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(cc_first) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('2. tvt_bbs_vs_double (bbs vs cc_first)', () async {
    final r = await runScenario('tvt_bbs', 'tvt_cc_first');
    print('=== tvt_bbs_vs_double ===');
    print('정방향(bbs) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(bbs) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('3. tvt_wraith_vs_rax_double (wraith_cloak vs cc_first)', () async {
    final r = await runScenario('tvt_wraith_cloak', 'tvt_cc_first');
    print('=== tvt_wraith_vs_rax_double ===');
    print('정방향(wraith_cloak) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(wraith_cloak) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('4. tvt_5fac_vs_mine_triple (5fac vs 1fac_expand)', () async {
    final r = await runScenario('tvt_5fac', 'tvt_1fac_expand');
    print('=== tvt_5fac_vs_mine_triple ===');
    print('정방향(5fac) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(5fac) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('5. tvt_bbs_vs_tech (bbs vs wraith_cloak)', () async {
    final r = await runScenario('tvt_bbs', 'tvt_wraith_cloak');
    print('=== tvt_bbs_vs_tech ===');
    print('정방향(bbs) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(bbs) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('6. tvt_aggressive_mirror (1fac_push vs wraith_cloak)', () async {
    final r = await runScenario('tvt_1fac_push', 'tvt_wraith_cloak');
    print('=== tvt_aggressive_mirror ===');
    print('정방향(1fac_push) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(1fac_push) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('7. tvt_cc_first_vs_1fac_expand (cc_first vs 1fac_expand)', () async {
    final r = await runScenario('tvt_cc_first', 'tvt_1fac_expand');
    print('=== tvt_cc_first_vs_1fac_expand ===');
    print('정방향(cc_first) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(cc_first) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('8. tvt_2fac_vs_1fac_expand (2fac_vulture vs 1fac_expand)', () async {
    final r = await runScenario('tvt_2fac_vulture', 'tvt_1fac_expand');
    print('=== tvt_2fac_vs_1fac_expand ===');
    print('정방향(2fac_vulture) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(2fac_vulture) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('9. tvt_1fac_push_vs_5fac (1fac_push vs 5fac)', () async {
    final r = await runScenario('tvt_1fac_push', 'tvt_5fac');
    print('=== tvt_1fac_push_vs_5fac ===');
    print('정방향(1fac_push) 승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향(1fac_push) 승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합 승률: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  // ===== 미러 시나리오 (7개) =====

  test('10. tvt_bbs_mirror (bbs vs bbs)', () async {
    final r = await runScenario('tvt_bbs', 'tvt_bbs');
    print('=== tvt_bbs_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('11. tvt_1fac_push_mirror (1fac_push vs 1fac_push)', () async {
    final r = await runScenario('tvt_1fac_push', 'tvt_1fac_push');
    print('=== tvt_1fac_push_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('12. tvt_wraith_mirror (wraith_cloak vs wraith_cloak)', () async {
    final r = await runScenario('tvt_wraith_cloak', 'tvt_wraith_cloak');
    print('=== tvt_wraith_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('13. tvt_5fac_mirror (5fac vs 5fac)', () async {
    final r = await runScenario('tvt_5fac', 'tvt_5fac');
    print('=== tvt_5fac_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('14. tvt_cc_first_mirror (cc_first vs cc_first)', () async {
    final r = await runScenario('tvt_cc_first', 'tvt_cc_first');
    print('=== tvt_cc_first_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('15. tvt_2fac_vulture_mirror (2fac_vulture vs 2fac_vulture)', () async {
    final r = await runScenario('tvt_2fac_vulture', 'tvt_2fac_vulture');
    print('=== tvt_2fac_vulture_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });

  test('16. tvt_1fac_expand_mirror (1fac_expand vs 1fac_expand)', () async {
    final r = await runScenario('tvt_1fac_expand', 'tvt_1fac_expand');
    print('=== tvt_1fac_expand_mirror ===');
    print('정방향 홈승률: ${r['normalRate']}% (${r['homeWinNormal']}/30)');
    print('역방향 홈승률: ${r['reversedRate']}% (${r['homeWinReversed']}/30)');
    print('종합: ${r['totalRate']}%  편향: ${r['bias']}%p');
  });
}
