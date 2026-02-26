import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  // =========================================================
  // 공통 선수/맵 설정 (ZvZ - 양쪽 모두 저그, 동일 능력치)
  // =========================================================
  final zerg1 = Player(
    id: 'zerg1_test',
    name: '이재동',
    raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final zerg2 = Player(
    id: 'zerg2_test',
    name: '박성준',
    raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  const testMap = GameMap(
    id: 'test_map',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  const int n = 50; // 방향별 게임 수
  const int total = n * 2; // 전체 게임 수

  /// 승률 퍼센트 계산 헬퍼
  String pct(int wins) => '${(wins / n * 100).toStringAsFixed(0)}%';
  String totalPct(int wins) => '${(wins / total * 100).toStringAsFixed(1)}%';
  String biasPct(int a, int b) => '${((a - b).abs() / n * 100).toStringAsFixed(0)}%p';

  // =========================================================
  // 시나리오 1: 9풀 vs 9오버풀 (zvz_9pool_vs_9overpool)
  // 비미러 - 목표 승률: 30~70%
  // =========================================================
  test('ZvZ S1: 9풀 vs 9오버풀 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_9overpool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9overpool',
        forcedAwayBuildId: 'zvz_9pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S1: 9풀 vs 9오버풀 ===');
    print('정방향 9풀 승률: ${pct(homeWinNormal)}');
    print('역방향 9풀 승률: ${pct(homeWinReversed)}');
    print('합산 9풀 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 2: 12앞마당 vs 9풀 (zvz_12hatch_vs_9pool)
  // 비미러 - 목표 승률: 30~70%
  // =========================================================
  test('ZvZ S2: 12앞마당 vs 9풀 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_12hatch',
        forcedAwayBuildId: 'zvz_9pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_12hatch',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S2: 12앞마당 vs 9풀 ===');
    print('정방향 12앞 승률: ${pct(homeWinNormal)}');
    print('역방향 12앞 승률: ${pct(homeWinReversed)}');
    print('합산 12앞 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 3: 4풀 vs 12앞마당 (zvz_4pool_vs_12hatch)
  // 비미러 - 목표 승률: 30~70% (4풀이 home)
  // =========================================================
  test('ZvZ S3: 4풀 vs 12앞마당 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_pool_first',
        forcedAwayBuildId: 'zvz_12hatch',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_12hatch',
        forcedAwayBuildId: 'zvz_pool_first',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S3: 4풀 vs 12앞마당 ===');
    print('정방향 4풀 승률: ${pct(homeWinNormal)}');
    print('역방향 4풀 승률: ${pct(homeWinReversed)}');
    print('합산 4풀 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 4: 노풀 3해처리 미러 (zvz_3hatch_mirror)
  // 미러 매치 - 목표 승률: 45~55%
  // =========================================================
  test('ZvZ S4: 3해처리 미러 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_3hatch_nopool',
        forcedAwayBuildId: 'zvz_3hatch_nopool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_3hatch_nopool',
        forcedAwayBuildId: 'zvz_3hatch_nopool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S4: 3해처리 미러 ===');
    print('정방향 홈 승률: ${pct(homeWinNormal)}');
    print('역방향 어웨이 승률: ${pct(homeWinReversed)}');
    print('합산 홈 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 5: 4풀 vs 9풀/9오버풀 (zvz_4pool_vs_9pool)
  // 비미러 - 목표 승률: 30~70% (4풀이 home)
  // =========================================================
  test('ZvZ S5: 4풀 vs 9풀 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_pool_first',
        forcedAwayBuildId: 'zvz_9pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_pool_first',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S5: 4풀 vs 9풀 ===');
    print('정방향 4풀 승률: ${pct(homeWinNormal)}');
    print('역방향 4풀 승률: ${pct(homeWinReversed)}');
    print('합산 4풀 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 6: 4풀 vs 3해처리 (zvz_4pool_vs_3hatch)
  // 비미러 - 목표 승률: 30~70% (4풀이 home)
  // =========================================================
  test('ZvZ S6: 4풀 vs 3해처리 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_pool_first',
        forcedAwayBuildId: 'zvz_3hatch_nopool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_3hatch_nopool',
        forcedAwayBuildId: 'zvz_pool_first',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S6: 4풀 vs 3해처리 ===');
    print('정방향 4풀 승률: ${pct(homeWinNormal)}');
    print('역방향 4풀 승률: ${pct(homeWinReversed)}');
    print('합산 4풀 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 7: 9풀/9오버풀 미러 (zvz_9pool_mirror)
  // 미러 매치 - 목표 승률: 45~55%
  // =========================================================
  test('ZvZ S7: 9풀 미러 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_9pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_9pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S7: 9풀 미러 ===');
    print('정방향 홈 승률: ${pct(homeWinNormal)}');
    print('역방향 어웨이 승률: ${pct(homeWinReversed)}');
    print('합산 홈 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 8: 12풀/12앞 vs 3해처리 (zvz_12pool_vs_3hatch)
  // 비미러 - 목표 승률: 30~70% (12풀이 home)
  // =========================================================
  test('ZvZ S8: 12풀 vs 3해처리 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_12pool',
        forcedAwayBuildId: 'zvz_3hatch_nopool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_3hatch_nopool',
        forcedAwayBuildId: 'zvz_12pool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S8: 12풀 vs 3해처리 ===');
    print('정방향 12풀 승률: ${pct(homeWinNormal)}');
    print('역방향 12풀 승률: ${pct(homeWinReversed)}');
    print('합산 12풀 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });

  // =========================================================
  // 시나리오 9: 9오버풀 미러 (zvz_9overpool_mirror)
  // 미러 매치 - 목표 승률: 45~55%
  // =========================================================
  test('ZvZ S9: 9오버풀 미러 ${total}경기', () async {
    int homeWinNormal = 0, homeWinReversed = 0;

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9overpool',
        forcedAwayBuildId: 'zvz_9overpool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWinNormal++;
    }

    for (int i = 0; i < n; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: zerg1, awayPlayer: zerg2,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9overpool',
        forcedAwayBuildId: 'zvz_9overpool',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == false) homeWinReversed++;
    }

    final totalWin = homeWinNormal + homeWinReversed;
    print('=== ZvZ S9: 9오버풀 미러 ===');
    print('정방향 홈 승률: ${pct(homeWinNormal)}');
    print('역방향 어웨이 승률: ${pct(homeWinReversed)}');
    print('합산 홈 승률: ${totalPct(totalWin)}');
    print('홈/어웨이 편향: ${biasPct(homeWinNormal, homeWinReversed)}');
  });
}
