import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// 고표본 홈/어웨이 편향 테스트 (n=150/dir, 총 300경기)
/// 대상: 저표본에서 >15%p 편향 관측된 4개 시나리오

// 동급 선수 (능력치 ~700)
final _terranA = Player(
  id: 'terran_a', name: '이영호', raceIndex: 0,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 700, harass: 690,
    strategy: 700, macro: 700, defense: 700, scout: 690,
  ),
  levelValue: 7, condition: 100,
);
final _terranB = Player(
  id: 'terran_b', name: '최연성', raceIndex: 0,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 700,
    strategy: 690, macro: 700, defense: 690, scout: 700,
  ),
  levelValue: 7, condition: 100,
);
final _protoss = Player(
  id: 'protoss_a', name: '홍진호', raceIndex: 2,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 680,
    strategy: 720, macro: 700, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);
final _terranC = Player(
  id: 'terran_c', name: '임요환', raceIndex: 0,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 700,
    strategy: 680, macro: 690, defense: 700, scout: 680,
  ),
  levelValue: 7, condition: 100,
);
final _zergA = Player(
  id: 'zerg_a', name: '박성준', raceIndex: 1,
  stats: const PlayerStats(
    sense: 700, control: 700, attack: 690, harass: 710,
    strategy: 700, macro: 710, defense: 680, scout: 700,
  ),
  levelValue: 7, condition: 100,
);
final _zergB = Player(
  id: 'zerg_b', name: '이제동', raceIndex: 1,
  stats: const PlayerStats(
    sense: 690, control: 710, attack: 700, harass: 700,
    strategy: 690, macro: 700, defense: 700, scout: 690,
  ),
  levelValue: 7, condition: 100,
);

const _map = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

class _BiasResult {
  final String name;
  final int nPerDir;
  int playerAWins = 0;
  int playerBWins = 0;

  _BiasResult(this.name, this.nPerDir);

  double get winRate => (playerAWins + playerBWins) > 0
      ? playerAWins / (playerAWins + playerBWins) * 100 : 50;
  double get bias => (winRate - 50).abs();
  bool get pass => bias <= 10;
}

Future<_BiasResult> _runBiasTest({
  required String name,
  required Player playerA,
  required Player playerB,
  required String buildA,
  required String buildB,
  int nPerDir = 150,
}) async {
  final result = _BiasResult(name, nPerDir);

  for (int i = 0; i < nPerDir * 2; i++) {
    final reversed = i >= nPerDir;
    final home = reversed ? playerB : playerA;
    final away = reversed ? playerA : playerB;
    final homeBuild = reversed ? buildB : buildA;
    final awayBuild = reversed ? buildA : buildB;

    final service = MatchSimulationService();
    final stream = service.simulateMatchWithLog(
      homePlayer: home, awayPlayer: away, map: _map,
      getIntervalMs: () => 0,
      forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
    );

    SimulationState? state;
    await for (final s in stream) { state = s; }
    if (state == null) continue;

    final aWon = reversed ? state.homeWin == false : state.homeWin == true;
    if (aWon) {
      result.playerAWins++;
    } else {
      result.playerBWins++;
    }
  }
  return result;
}

void main() {
  test('고표본 편향 테스트 (n=150/dir)', () async {
    final results = <_BiasResult>[];

    // 1. PvT S9: mine_triple (pvt_1gate_expand vs tvp_mine_triple)
    print('=== PvT S9: 마인 트리플 ===');
    final pvtS9 = await _runBiasTest(
      name: 'PvT S9 (mine_triple)',
      playerA: _protoss, playerB: _terranC,
      buildA: 'pvt_1gate_expand', buildB: 'tvp_mine_triple',
    );
    results.add(pvtS9);
    print('${pvtS9.pass ? "PASS" : "FAIL"} ${pvtS9.name}: '
        '${pvtS9.playerAWins}-${pvtS9.playerBWins} '
        '(${pvtS9.winRate.toStringAsFixed(1)}%, bias=${pvtS9.bias.toStringAsFixed(1)}%p)');

    // 2. ZvZ S8: 12풀 vs 3해처리 (zvz_12pool vs zvz_3hatch_nopool)
    print('\n=== ZvZ S8: 12풀 vs 3해처리 ===');
    final zvzS8 = await _runBiasTest(
      name: 'ZvZ S8 (12pool_vs_3hatch)',
      playerA: _zergA, playerB: _zergB,
      buildA: 'zvz_12pool', buildB: 'zvz_3hatch_nopool',
    );
    results.add(zvzS8);
    print('${zvzS8.pass ? "PASS" : "FAIL"} ${zvzS8.name}: '
        '${zvzS8.playerAWins}-${zvzS8.playerBWins} '
        '(${zvzS8.winRate.toStringAsFixed(1)}%, bias=${zvzS8.bias.toStringAsFixed(1)}%p)');

    // 3. ZvZ S5: 4풀 vs 9풀 (zvz_pool_first vs zvz_9pool)
    print('\n=== ZvZ S5: 4풀 vs 9풀 ===');
    final zvzS5 = await _runBiasTest(
      name: 'ZvZ S5 (4pool_vs_9pool)',
      playerA: _zergA, playerB: _zergB,
      buildA: 'zvz_pool_first', buildB: 'zvz_9pool',
    );
    results.add(zvzS5);
    print('${zvzS5.pass ? "PASS" : "FAIL"} ${zvzS5.name}: '
        '${zvzS5.playerAWins}-${zvzS5.playerBWins} '
        '(${zvzS5.winRate.toStringAsFixed(1)}%, bias=${zvzS5.bias.toStringAsFixed(1)}%p)');

    // 4. TvT S12: wraith_mirror (tvt_wraith_cloak vs tvt_wraith_cloak)
    print('\n=== TvT S12: 레이스 미러 ===');
    final tvtS12 = await _runBiasTest(
      name: 'TvT S12 (wraith_mirror)',
      playerA: _terranA, playerB: _terranB,
      buildA: 'tvt_wraith_cloak', buildB: 'tvt_wraith_cloak',
    );
    results.add(tvtS12);
    print('${tvtS12.pass ? "PASS" : "FAIL"} ${tvtS12.name}: '
        '${tvtS12.playerAWins}-${tvtS12.playerBWins} '
        '(${tvtS12.winRate.toStringAsFixed(1)}%, bias=${tvtS12.bias.toStringAsFixed(1)}%p)');

    // 종합
    print('\n========== 종합 ==========');
    print('| 시나리오 | 전적 | 승률 | 편향 | 판정 |');
    print('|----------|------|------|------|------|');
    for (final r in results) {
      print('| ${r.name} | ${r.playerAWins}-${r.playerBWins} '
          '| ${r.winRate.toStringAsFixed(1)}% '
          '| ${r.bias.toStringAsFixed(1)}%p '
          '| ${r.pass ? "PASS" : "**FAIL**"} |');
    }

    final allPass = results.every((r) => r.pass);
    print('\n전체 판정: ${allPass ? "ALL PASS" : "FAIL"}');
  }, timeout: const Timeout(Duration(minutes: 30)));
}
