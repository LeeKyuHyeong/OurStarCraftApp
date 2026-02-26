import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final protoss1 = Player(
    id: 'protoss1_test', name: '김택용', raceIndex: 2,
    stats: const PlayerStats(sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700),
    levelValue: 7, condition: 100,
  );
  final protoss2 = Player(
    id: 'protoss2_test', name: '박성준', raceIndex: 2,
    stats: const PlayerStats(sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(id: 'test_map', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5, airAccessibility: 6, centerImportance: 5);

  const n = 150; // 각 방향 150경기, 총 300경기

  // S1: pvp_dragoon_nexus_mirror (미러)
  test('S1 원겟 드라군 넥서스 미러 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S1 원겟 드라군 넥서스 미러 (미러) ===');
    print('정방향 홈승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 어웨이승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S2: pvp_dragoon_vs_nogate (비미러)
  test('S2 원겟 드라군 vs 노겟 넥서스 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_1gate_multi',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_multi', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S2 원겟 드라군 vs 노겟 넥서스 (비미러) ===');
    print('정방향 드라군승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 드라군승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('드라군 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S3: pvp_robo_vs_2gate_dragoon (비미러)
  test('S3 원겟 로보 리버 vs 투겟 드라군 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_robo', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_1gate_robo',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S3 원겟 로보 리버 vs 투겟 드라군 (비미러) ===');
    print('정방향 로보승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 로보승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('로보 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S4: pvp_dark_vs_dragoon (비미러)
  test('S4 다크 올인 vs 스탠다드 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_dark_allin', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_dark_allin',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S4 다크 올인 vs 스탠다드 (비미러) ===');
    print('정방향 다크승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 다크승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('다크 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S5: pvp_zealot_rush (비미러)
  test('S5 센터 게이트 질럿 러시 vs 스탠다드 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_zealot_rush', forcedAwayBuildId: 'pvp_2gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon', forcedAwayBuildId: 'pvp_zealot_rush',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S5 센터 게이트 질럿 러시 vs 스탠다드 (비미러) ===');
    print('정방향 러시승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 러시승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('러시 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S6: pvp_dark_vs_zealot_rush (비미러)
  test('S6 다크 올인 vs 질럿 러시 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_dark_allin', forcedAwayBuildId: 'pvp_zealot_rush',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_zealot_rush', forcedAwayBuildId: 'pvp_dark_allin',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S6 다크 올인 vs 질럿 러시 (비미러) ===');
    print('정방향 다크승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 다크승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('다크 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S7: pvp_robo_mirror (미러)
  test('S7 로보 미러 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_robo', forcedAwayBuildId: 'pvp_1gate_robo',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_robo', forcedAwayBuildId: 'pvp_1gate_robo',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S7 로보 미러 (미러) ===');
    print('정방향 홈승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 어웨이승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S8: pvp_4gate_vs_multi (비미러)
  test('S8 포게이트 올인 vs 원겟 멀티 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_4gate_dragoon', forcedAwayBuildId: 'pvp_1gate_multi',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_multi', forcedAwayBuildId: 'pvp_4gate_dragoon',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S8 포게이트 올인 vs 원겟 멀티 (비미러) ===');
    print('정방향 4게이트승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 4게이트승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('4게이트 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S9: pvp_zealot_rush_vs_reaver (비미러)
  test('S9 질럿 러시 vs 로보 리버 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_zealot_rush', forcedAwayBuildId: 'pvp_1gate_robo',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_robo', forcedAwayBuildId: 'pvp_zealot_rush',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S9 질럿 러시 vs 로보 리버 (비미러) ===');
    print('정방향 러시승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 러시승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('러시 종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });

  // S10: pvp_dark_mirror (미러)
  test('S10 다크 미러 ${n*2}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_dark_allin', forcedAwayBuildId: 'pvp_dark_allin',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }
    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protoss1, awayPlayer: protoss2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_dark_allin', forcedAwayBuildId: 'pvp_dark_allin',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }
    final total = n * 2;
    print('=== S10 다크 미러 (미러) ===');
    print('정방향 홈승: $homeWinNormal/$n (${(homeWinNormal/n*100).toStringAsFixed(0)}%)');
    print('역방향 어웨이승: $homeWinReversed/$n (${(homeWinReversed/n*100).toStringAsFixed(0)}%)');
    print('종합 승률: ${((homeWinNormal + homeWinReversed) / total * 100).toStringAsFixed(1)}%');
    print('홈/어웨이 편향: ${((homeWinNormal/n - homeWinReversed/n).abs() * 100).toStringAsFixed(0)}%p');
  });
}
