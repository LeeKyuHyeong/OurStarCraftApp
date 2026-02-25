import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// TvT_Master_Team - 전체 8개 시나리오 20경기 시뮬레이션 테스트
void main() {
  // 동급 테란 선수 (능력치 700, 레벨 7)
  final homePlayer = Player(
    id: 'terran_home', name: '이영호', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  final awayPlayer = Player(
    id: 'terran_away', name: '박명수', raceIndex: 0,
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
  );

  const int gameCount = 100;

  // 시나리오별 빌드 조합 정의
  final scenarios = <Map<String, String>>[
    {'id': 'S1', 'name': '배럭더블 vs 팩더블', 'scenario': 'tvt_rax_double_vs_fac_double', 'homeBuild': 'tvt_cc_first', 'awayBuild': 'tvt_2fac_vulture'},
    {'id': 'S2', 'name': 'BBS vs 노배럭더블', 'scenario': 'tvt_bbs_vs_double', 'homeBuild': 'tvt_bbs', 'awayBuild': 'tvt_cc_first'},
    {'id': 'S3', 'name': '레이스 vs 배럭더블', 'scenario': 'tvt_wraith_vs_rax_double', 'homeBuild': 'tvt_wraith_cloak', 'awayBuild': 'tvt_cc_first'},
    {'id': 'S4', 'name': '5팩 vs 마인트리플', 'scenario': 'tvt_5fac_vs_mine_triple', 'homeBuild': 'tvt_5fac', 'awayBuild': 'tvt_1fac_expand'},
    {'id': 'S5', 'name': 'BBS vs 테크', 'scenario': 'tvt_bbs_vs_tech', 'homeBuild': 'tvt_bbs', 'awayBuild': 'tvt_2fac_vulture'},
    {'id': 'S6', 'name': '공격적 대결', 'scenario': 'tvt_aggressive_mirror', 'homeBuild': 'tvt_1fac_push', 'awayBuild': 'tvt_wraith_cloak'},
    {'id': 'S7', 'name': '배럭더블 vs 원팩확장', 'scenario': 'tvt_cc_first_vs_1fac_expand', 'homeBuild': 'tvt_cc_first', 'awayBuild': 'tvt_1fac_expand'},
    {'id': 'S8', 'name': '투팩벌처 vs 원팩확장', 'scenario': 'tvt_2fac_vs_1fac_expand', 'homeBuild': 'tvt_2fac_vulture', 'awayBuild': 'tvt_1fac_expand'},
  ];

  // 역방향 테스트 (홈/어웨이 반전)
  final reverseScenarios = <Map<String, String>>[
    {'id': 'S1R', 'name': '팩더블 vs 배럭더블 (반전)', 'scenario': 'tvt_rax_double_vs_fac_double', 'homeBuild': 'tvt_2fac_vulture', 'awayBuild': 'tvt_cc_first'},
    {'id': 'S2R', 'name': '노배럭더블 vs BBS (반전)', 'scenario': 'tvt_bbs_vs_double', 'homeBuild': 'tvt_cc_first', 'awayBuild': 'tvt_bbs'},
    {'id': 'S7R', 'name': '원팩확장 vs 배럭더블 (반전)', 'scenario': 'tvt_cc_first_vs_1fac_expand', 'homeBuild': 'tvt_1fac_expand', 'awayBuild': 'tvt_cc_first'},
    {'id': 'S8R', 'name': '원팩확장 vs 투팩벌처 (반전)', 'scenario': 'tvt_2fac_vs_1fac_expand', 'homeBuild': 'tvt_1fac_expand', 'awayBuild': 'tvt_2fac_vulture'},
  ];

  final allScenarios = [...scenarios, ...reverseScenarios];

  final buf = StringBuffer();
  buf.writeln('# TvT_Master_Team 사이클 리포트');
  buf.writeln('');
  buf.writeln('| 시나리오 | 홈빌드 | 어웨이빌드 | 홈승 | 어승 | 홈승률 | 판정 |');
  buf.writeln('|----------|--------|-----------|------|------|--------|------|');

  for (final sc in allScenarios) {
    test('TvT ${sc['id']}: ${sc['name']} ${gameCount}경기', () async {
      int homeWins = 0, awayWins = 0;
      final uniqueLogs = <String>{};

      for (int i = 0; i < gameCount; i++) {
        final service = MatchSimulationService();
        final stream = service.simulateMatchWithLog(
          homePlayer: homePlayer, awayPlayer: awayPlayer,
          map: testMap, getIntervalMs: () => 0,
          forcedHomeBuildId: sc['homeBuild']!,
          forcedAwayBuildId: sc['awayBuild']!,
        );

        SimulationState? state;
        await for (final s in stream) { state = s; }
        if (state == null) continue;

        if (state.homeWin == true) homeWins++; else awayWins++;

        // 다양성 체크: 로그의 처음 5개 이벤트 조합
        final logSig = state.battleLogEntries.take(10).map((e) => e.text).join('|');
        uniqueLogs.add(logSig);
      }

      final total = homeWins + awayWins;
      final homeWinRate = total > 0 ? (homeWins / total * 100) : 0.0;
      final pass = homeWinRate >= 30 && homeWinRate <= 70;
      final diversity = uniqueLogs.length;

      final line = '| ${sc['id']} ${sc['name']} | ${sc['homeBuild']} | ${sc['awayBuild']} | $homeWins | $awayWins | ${homeWinRate.toStringAsFixed(1)}% | ${pass ? 'OK' : 'FAIL'} (다양성:$diversity) |';
      buf.writeln(line);

      print('${sc['id']}: 홈 $homeWins - $awayWins 어 (${homeWinRate.toStringAsFixed(1)}%) 다양성:$diversity ${pass ? 'OK' : 'FAIL'}');

      // 승률 기준 검증 (30~70% 범위)
      expect(homeWinRate, greaterThanOrEqualTo(20), reason: '${sc['id']} 홈 승률이 20% 미만');
      expect(homeWinRate, lessThanOrEqualTo(80), reason: '${sc['id']} 홈 승률이 80% 초과');
    });
  }

  // 모든 테스트 완료 후 리포트 작성
  tearDownAll(() {
    buf.writeln('');
    buf.writeln('> 기준: 홈승률 30~70% = OK, 다양성 4+ 권장');
    File('tvt_master_cycle1.md').writeAsStringSync(buf.toString());
  });
}
