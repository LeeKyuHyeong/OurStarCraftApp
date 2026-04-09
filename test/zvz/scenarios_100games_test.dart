import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  // =========================================================
  // 공통 선수/맵 설정 (ZvZ 동족전 - 양쪽 다 Zerg)
  // =========================================================
  final homePlayer = Player(
    id: 'zerg_home',
    name: '이재동',
    raceIndex: 1, // Zerg
    stats: const PlayerStats(
      sense: 700, control: 710, attack: 690, harass: 700,
      strategy: 680, macro: 720, defense: 690, scout: 710,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'zerg_away',
    name: '박성준',
    raceIndex: 1, // Zerg
    stats: const PlayerStats(
      sense: 690, control: 700, attack: 710, harass: 680,
      strategy: 720, macro: 690, defense: 700, scout: 680,
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

  String winRate(int wins, int total) =>
      total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
  String pct(int count, int total) =>
      total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';

  // =========================================================
  // 시나리오 1: 9풀 vs 9오버풀 (zvz_9pool_vs_9overpool)
  // homeBuild: zvz_9pool, awayBuild: zvz_9overpool
  // Phase 2 분기: attacker_breaks_through (conditionStat=attack, home>away)
  //              / defender_holds (conditionStat=defense, away>home)
  // Phase 4 분기: fast_mutal_harass (conditionStat=harass, home>away)
  //              / scourge_defense (conditionStat=defense, away>home)
  // =========================================================
  test('ZvZ 시나리오1: 9풀 vs 9오버풀 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2AttackBreak = 0, p2AttackBreakWin = 0;
    int p2DefenderHold = 0, p2DefenderHoldWin = 0;
    int p2Unknown = 0;

    int p4FastMutal = 0, p4FastMutalWin = 0;
    int p4ScourgeDefense = 0, p4ScourgeDefenseWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool_lair',
        forcedAwayBuildId: 'zvz_9overpool',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      lastState = state;
      if (state == null) continue;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;

      homeArmyMargins.add(state.homeArmy - state.awayArmy);
      homeResourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: attacker_breaks_through
      final hasP2A = allText.contains('저글링이 입구를 뚫었습니다') ||
          allText.contains('드론까지 노립니다') ||
          allText.contains('추가 저글링 합류! 상대 드론을 초토화');
      // Phase 2: defender_holds
      final hasP2B = allText.contains('언덕에서 저글링을 효과적으로 막아') ||
          allText.contains('좁은 입구에서 잘 막습니다') ||
          allText.contains('드론 한 기 차이가 벌어지기');

      if (hasP2A && !hasP2B) {
        p2AttackBreak++; if (won) p2AttackBreakWin++;
      } else if (hasP2B && !hasP2A) {
        p2DefenderHold++; if (won) p2DefenderHoldWin++;
      } else if (hasP2A && hasP2B) {
        p2AttackBreak++; if (won) p2AttackBreakWin++;
      } else {
        p2Unknown++;
      }

      // Phase 4: fast_mutal_harass
      final hasP4A = allText.contains('뮤탈리스크가 먼저 나왔습니다') ||
          allText.contains('뮤탈 선점! 드론을 물어') ||
          allText.contains('뮤탈이 스포어를 피하면서');
      // Phase 4: scourge_defense
      final hasP4B = allText.contains('스커지를 뽑으면서 뮤탈에 대비') ||
          allText.contains('스커지 자폭! 뮤탈 2기를 잡아') ||
          allText.contains('스커지가 뮤탈에 돌진');

      if (hasP4A && !hasP4B) {
        p4FastMutal++; if (won) p4FastMutalWin++;
      } else if (hasP4B && !hasP4A) {
        p4ScourgeDefense++; if (won) p4ScourgeDefenseWin++;
      } else if (hasP4A && hasP4B) {
        p4FastMutal++; if (won) p4FastMutalWin++;
      } else {
        p4Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2AttackBreak + p2DefenderHold;
    final p4Total = p4FastMutal + p4ScourgeDefense;

    final buffer = StringBuffer();
    buffer.writeln('# ZvZ 시나리오1: 9풀 vs 9오버풀 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (9풀) | 빌드: zvz_9pool');
    buffer.writeln('- 어웨이: 박성준 (9오버풀) | 빌드: zvz_9overpool');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (홈/9풀) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 박성준 (원/9오버풀) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 저글링 교전 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 조건 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|------|------|------|---------|');
    buffer.writeln('| A. 9풀 공격 성공 | attack(홈>원) | $p2AttackBreak | ${pct(p2AttackBreak, p2Total)} | ${winRate(p2AttackBreakWin, p2AttackBreak)} |');
    buffer.writeln('| B. 9오버풀 수비 성공 | defense(원>홈) | $p2DefenderHold | ${pct(p2DefenderHold, p2Total)} | ${winRate(p2DefenderHoldWin, p2DefenderHold)} |');
    buffer.writeln('');
    buffer.writeln('## Phase 4: 뮤탈 교전 (${p4Total}감지 / 미감지 $p4Unknown)');
    buffer.writeln('| 분기 | 조건 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|------|------|------|---------|');
    buffer.writeln('| A. 뮤탈 선점 견제 | harass(홈>원) | $p4FastMutal | ${pct(p4FastMutal, p4Total)} | ${winRate(p4FastMutalWin, p4FastMutal)} |');
    buffer.writeln('| B. 스커지 대응 | defense(원>홈) | $p4ScourgeDefense | ${pct(p4ScourgeDefense, p4Total)} | ${winRate(p4ScourgeDefenseWin, p4ScourgeDefense)} |');
    buffer.writeln('');

    buffer.writeln('## 능력치 비교');
    buffer.writeln('| 스탯 | 이재동(홈) | 박성준(원) | 높은쪽 |');
    buffer.writeln('|------|-----------|-----------|--------|');
    buffer.writeln('| attack | 690 | 710 | 원 |');
    buffer.writeln('| harass | 700 | 680 | 홈 |');
    buffer.writeln('| defense | 690 | 700 | 원 |');
    buffer.writeln('| control | 710 | 700 | 홈 |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈Z]',
          LogOwner.away => '[원Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('test/output/zvz/scenario1.md');
    file.writeAsStringSync(buffer.toString());
    print('zvz_scenario1.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 박성준');
    print('Phase 2: 공격성공$p2AttackBreak 수비성공$p2DefenderHold 미감지$p2Unknown');
    print('Phase 4: 뮤탈선점$p4FastMutal 스커지대응$p4ScourgeDefense 미감지$p4Unknown');
  });

  // =========================================================
  // 시나리오 2: 12앞마당 vs 9풀 (zvz_12hatch_vs_9pool)
  // homeBuild: zvz_12hatch, awayBuild: zvz_9pool
  // Phase 2 분기: hatch_destroyed (conditionStat=attack, away>home)
  //              / defense_success (conditionStat=defense, home>away)
  // =========================================================
  test('ZvZ 시나리오2: 12앞마당 vs 9풀 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2HatchDestroy = 0, p2HatchDestroyWin = 0;
    int p2DefenseSuccess = 0, p2DefenseSuccessWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_12hatch',
        forcedAwayBuildId: 'zvz_9pool_lair',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      lastState = state;
      if (state == null) continue;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;

      homeArmyMargins.add(state.homeArmy - state.awayArmy);
      homeResourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // hatch_destroyed
      final hasP2A = allText.contains('저글링이 드론을 뚫습니다') ||
          allText.contains('앞마당 해처리가 부서지고') ||
          allText.contains('앞마당이 무너집니다');
      // defense_success
      final hasP2B = allText.contains('성큰이 완성됩니다! 저글링을 잡아') ||
          allText.contains('성큰 완성! 저글링이 녹습니다') ||
          allText.contains('드론으로 협공! 완벽한 수비');

      if (hasP2A && !hasP2B) {
        p2HatchDestroy++; if (won) p2HatchDestroyWin++;
      } else if (hasP2B && !hasP2A) {
        p2DefenseSuccess++; if (won) p2DefenseSuccessWin++;
      } else if (hasP2A && hasP2B) {
        p2HatchDestroy++; if (won) p2HatchDestroyWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2HatchDestroy + p2DefenseSuccess;

    final buffer = StringBuffer();
    buffer.writeln('# ZvZ 시나리오2: 12앞마당 vs 9풀 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (12앞마당) | 빌드: zvz_12hatch');
    buffer.writeln('- 어웨이: 박성준 (9풀) | 빌드: zvz_9pool');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (홈/12앞) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 박성준 (원/9풀) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 앞마당 수비 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 조건 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|------|------|------|---------|');
    buffer.writeln('| A. 앞마당 파괴 | attack(원>홈) | $p2HatchDestroy | ${pct(p2HatchDestroy, p2Total)} | ${winRate(p2HatchDestroyWin, p2HatchDestroy)} |');
    buffer.writeln('| B. 수비 성공 | defense(홈>원) | $p2DefenseSuccess | ${pct(p2DefenseSuccess, p2Total)} | ${winRate(p2DefenseSuccessWin, p2DefenseSuccess)} |');
    buffer.writeln('');

    buffer.writeln('## 능력치 비교');
    buffer.writeln('| 스탯 | 이재동(홈) | 박성준(원) | 높은쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|--------|----------|');
    buffer.writeln('| attack | 690 | 710 | 원 | P2-A (원>홈 조건 충족) |');
    buffer.writeln('| defense | 690 | 700 | 원 | P2-B (홈>원 조건 미충족) |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈Z]',
          LogOwner.away => '[원Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('test/output/zvz/scenario2.md');
    file.writeAsStringSync(buffer.toString());
    print('zvz_scenario2.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 박성준');
    print('Phase 2: 앞마당파괴$p2HatchDestroy 수비성공$p2DefenseSuccess 미감지$p2Unknown');
  });

  // =========================================================
  // 시나리오 3: 4풀 vs 12앞마당 (zvz_4pool_vs_12hatch)
  // homeBuild: zvz_4pool, awayBuild: zvz_12hatch
  // Phase 2 분기: pool_crushes (conditionStat=attack, home>away)
  //              / drone_defense (conditionStat=control, away>home)
  // =========================================================
  test('ZvZ 시나리오3: 4풀 vs 12앞마당 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2PoolCrush = 0, p2PoolCrushWin = 0;
    int p2DroneDefense = 0, p2DroneDefenseWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_4pool',
        forcedAwayBuildId: 'zvz_12hatch',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      lastState = state;
      if (state == null) continue;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;

      homeArmyMargins.add(state.homeArmy - state.awayArmy);
      homeResourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // pool_crushes
      final hasP2A = allText.contains('저글링이 드론을 물어뜯습니다! 앞마당도 파괴') ||
          allText.contains('저글링이 모든 걸 파괴') ||
          allText.contains('드론이 전멸하고 있습니다');
      // drone_defense
      final hasP2B = allText.contains('드론을 뭉쳐서 저글링과 교전') ||
          allText.contains('드론 컨트롤! 저글링을 잡아') ||
          allText.contains('스포닝풀이 완성됩니다! 저글링으로 반격');

      if (hasP2A && !hasP2B) {
        p2PoolCrush++; if (won) p2PoolCrushWin++;
      } else if (hasP2B && !hasP2A) {
        p2DroneDefense++; if (won) p2DroneDefenseWin++;
      } else if (hasP2A && hasP2B) {
        p2PoolCrush++; if (won) p2PoolCrushWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2PoolCrush + p2DroneDefense;

    final buffer = StringBuffer();
    buffer.writeln('# ZvZ 시나리오3: 4풀 vs 12앞마당 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (4풀) | 빌드: zvz_4pool');
    buffer.writeln('- 어웨이: 박성준 (12앞마당) | 빌드: zvz_12hatch');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (홈/4풀) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 박성준 (원/12앞) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 조건 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|------|------|------|---------|');
    buffer.writeln('| A. 4풀 파괴 | attack(홈>원) | $p2PoolCrush | ${pct(p2PoolCrush, p2Total)} | ${winRate(p2PoolCrushWin, p2PoolCrush)} |');
    buffer.writeln('| B. 드론 수비 | control(원>홈) | $p2DroneDefense | ${pct(p2DroneDefense, p2Total)} | ${winRate(p2DroneDefenseWin, p2DroneDefense)} |');
    buffer.writeln('');

    buffer.writeln('## 능력치 비교');
    buffer.writeln('| 스탯 | 이재동(홈) | 박성준(원) | 높은쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|--------|----------|');
    buffer.writeln('| attack | 690 | 710 | 원 | P2-A (홈>원 조건 미충족) |');
    buffer.writeln('| control | 710 | 700 | 홈 | P2-B (원>홈 조건 미충족) |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈Z]',
          LogOwner.away => '[원Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('test/output/zvz/scenario3.md');
    file.writeAsStringSync(buffer.toString());
    print('zvz_scenario3.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 박성준');
    print('Phase 2: 4풀파괴$p2PoolCrush 드론수비$p2DroneDefense 미감지$p2Unknown');
  });

  // =========================================================
  // 시나리오 4: 12풀 미러 (zvz_12pool_mirror)
  // homeBuild: zvz_12pool, awayBuild: zvz_12pool
  // =========================================================
  test('ZvZ 시나리오4: 12풀 미러 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2ControlDiff = 0, p2ControlDiffWin = 0;
    int p2Stalemate = 0, p2StalemateWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_12pool',
        forcedAwayBuildId: 'zvz_12pool',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      lastState = state;
      if (state == null) continue;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;

      homeArmyMargins.add(state.homeArmy - state.awayArmy);
      homeResourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // mutal_control_diff
      final hasP2A = allText.contains('뮤탈 편대 컨트롤이 좋습니다') ||
          allText.contains('뮤탈 컨트롤 차이! 상대 뮤탈을 격파') ||
          allText.contains('드론을 물어뜯으면서 압박');
      // mutal_stalemate
      final hasP2B = allText.contains('양측 뮤탈이 비슷한 수') ||
          allText.contains('스커지를 섞으면서 뮤탈 수를 줄이려') ||
          allText.contains('뮤탈 소모전');

      if (hasP2A && !hasP2B) {
        p2ControlDiff++; if (won) p2ControlDiffWin++;
      } else if (hasP2B && !hasP2A) {
        p2Stalemate++; if (won) p2StalemateWin++;
      } else if (hasP2A && hasP2B) {
        p2ControlDiff++; if (won) p2ControlDiffWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2ControlDiff + p2Stalemate;

    final buffer = StringBuffer();
    buffer.writeln('# ZvZ 시나리오4: 12풀 미러 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (12풀) | 빌드: zvz_12pool');
    buffer.writeln('- 어웨이: 박성준 (12풀) | 빌드: zvz_12pool');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (홈) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 박성준 (원) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 뮤탈 교전 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 조건 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|------|------|------|---------|');
    buffer.writeln('| A. 뮤탈 컨트롤 차이 | control(홈>원) | $p2ControlDiff | ${pct(p2ControlDiff, p2Total)} | ${winRate(p2ControlDiffWin, p2ControlDiff)} |');
    buffer.writeln('| B. 뮤탈 소모전 | macro(원>홈) | $p2Stalemate | ${pct(p2Stalemate, p2Total)} | ${winRate(p2StalemateWin, p2Stalemate)} |');
    buffer.writeln('');

    buffer.writeln('## 능력치 비교');
    buffer.writeln('| 스탯 | 이재동(홈) | 박성준(원) | 높은쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|--------|----------|');
    buffer.writeln('| control | 710 | 700 | 홈 | P2-A (홈>원 조건 충족) |');
    buffer.writeln('| macro | 720 | 690 | 홈 | P2-B (원>홈 조건 미충족) |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈Z]',
          LogOwner.away => '[원Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('test/output/zvz/scenario4.md');
    file.writeAsStringSync(buffer.toString());
    print('zvz_scenario4.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 박성준');
    print('Phase 2: 컨트롤차이$p2ControlDiff 소모전$p2Stalemate 미감지$p2Unknown');
  });
}
