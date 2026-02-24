import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  // 동급 선수 생성 (능력치 ~700, 레벨 7)
  final terranPlayer = Player(
    id: 'terran_test',
    name: '이영호',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final zergPlayer = Player(
    id: 'zerg_test',
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

  const int gameCount = 100;

  // =======================================================
  // 1. 바이오 러시 vs 뮤탈 (tvz_bio_vs_mutal)
  // =======================================================
  test('TvZ 시나리오 1: 바이오 러시 vs 뮤탈 100경기 → tvz_scenario1.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 분기 (first_contact): 4 branches
    int p2TerranPush = 0, p2TerranPushWin = 0;
    int p2ZergFastMutal = 0, p2ZergFastMutalWin = 0;
    int p2ZergLingAmbush = 0, p2ZergLingAmbushWin = 0;
    int p2TerranScout = 0, p2TerranScoutWin = 0;
    int p2Unknown = 0;

    // Phase 4 분기 (transition): 3 branches
    int p4TimingPush = 0, p4TimingPushWin = 0;
    int p4MacroTransition = 0, p4MacroTransitionWin = 0;
    int p4DropshipRaid = 0, p4DropshipRaidWin = 0;
    int p4Unknown = 0;

    // Phase 5 분기 (decisive_battle): 3 branches
    int p5StandardClash = 0, p5StandardClashWin = 0;
    int p5DefilerSwarm = 0, p5DefilerSwarmWin = 0;
    int p5LastDrop = 0, p5LastDropWin = 0;
    int p5Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_sk',
        forcedAwayBuildId: 'zvt_3hatch_mutal',
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

      // Phase 2 판별
      final hasP2A = allText.contains('스팀팩 ON') || allText.contains('앞마당 압박') || allText.contains('앞마당으로 전진');
      final hasP2B = allText.contains('뮤탈리스크 등장') || allText.contains('뮤탈이 떴습니다') || allText.contains('SCV 라인을 노립니다');
      final hasP2C = allText.contains('저글링이 튀어나옵니다') || allText.contains('저글링 서라운드') || allText.contains('매복 저글링');
      final hasP2D = allText.contains('스파이어를 발견') || allText.contains('터렛을 미리 건설') || allText.contains('정찰 SCV가 스파이어');

      if (hasP2D) { p2TerranScout++; if (won) p2TerranScoutWin++; }
      else if (hasP2A) { p2TerranPush++; if (won) p2TerranPushWin++; }
      else if (hasP2B) { p2ZergFastMutal++; if (won) p2ZergFastMutalWin++; }
      else if (hasP2C) { p2ZergLingAmbush++; if (won) p2ZergLingAmbushWin++; }
      else { p2Unknown++; }

      // Phase 4 판별
      final hasP4A = allText.contains('이레디에이트') || allText.contains('이레디') || allText.contains('사이언스 베슬 합류');
      final hasP4B = allText.contains('3번째 해처리') || allText.contains('럴커 변태') || allText.contains('럴커 포진') || allText.contains('물량이 점점');
      final hasP4C = allText.contains('드랍십에 마린 메딕') || allText.contains('드랍! 저그 세 번째') || allText.contains('드랍 성공');

      if (hasP4C) { p4DropshipRaid++; if (won) p4DropshipRaidWin++; }
      else if (hasP4A) { p4TimingPush++; if (won) p4TimingPushWin++; }
      else if (hasP4B) { p4MacroTransition++; if (won) p4MacroTransitionWin++; }
      else { p4Unknown++; }

      // Phase 5 판별
      final hasP5A = allText.contains('풀 병력 전면전') || allText.contains('총공격 준비');
      final hasP5B = allText.contains('디파일러') || allText.contains('다크스웜');
      final hasP5C = allText.contains('최후의 승부수') || allText.contains('드랍 올인') || allText.contains('본진 드랍! 해처리를 직접');

      if (hasP5C) { p5LastDrop++; if (won) p5LastDropWin++; }
      else if (hasP5B) { p5DefilerSwarm++; if (won) p5DefilerSwarmWin++; }
      else if (hasP5A) { p5StandardClash++; if (won) p5StandardClashWin++; }
      else { p5Unknown++; }
    }

    // 통계 함수
    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2TerranPush + p2ZergFastMutal + p2ZergLingAmbush + p2TerranScout;
    final p4Total = p4TimingPush + p4MacroTransition + p4DropshipRaid;
    final p5Total = p5StandardClash + p5DefilerSwarm + p5LastDrop;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 1: 바이오 러시 vs 뮤탈 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_sk');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_3hatch_mutal');
    buf.writeln('- 시나리오: tvz_bio_vs_mutal');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} (양수=T유리)');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)} (양수=T유리)');
    buf.writeln('');
    buf.writeln('## Phase 2: 초반 접촉 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 테란 압박 | $p2TerranPush | ${pct(p2TerranPush, p2Total)} | ${winRate(p2TerranPushWin, p2TerranPush)} |');
    buf.writeln('| B. 저그 뮤탈 | $p2ZergFastMutal | ${pct(p2ZergFastMutal, p2Total)} | ${winRate(p2ZergFastMutalWin, p2ZergFastMutal)} |');
    buf.writeln('| C. 저글링 기습 | $p2ZergLingAmbush | ${pct(p2ZergLingAmbush, p2Total)} | ${winRate(p2ZergLingAmbushWin, p2ZergLingAmbush)} |');
    buf.writeln('| D. 스파이어 정찰 | $p2TerranScout | ${pct(p2TerranScout, p2Total)} | ${winRate(p2TerranScoutWin, p2TerranScout)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 전환기 ($p4Total 감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 타이밍 공격 | $p4TimingPush | ${pct(p4TimingPush, p4Total)} | ${winRate(p4TimingPushWin, p4TimingPush)} |');
    buf.writeln('| B. 매크로 전환 | $p4MacroTransition | ${pct(p4MacroTransition, p4Total)} | ${winRate(p4MacroTransitionWin, p4MacroTransition)} |');
    buf.writeln('| C. 드랍십 견제 | $p4DropshipRaid | ${pct(p4DropshipRaid, p4Total)} | ${winRate(p4DropshipRaidWin, p4DropshipRaid)} |');
    buf.writeln('');
    buf.writeln('## Phase 5: 결전 ($p5Total 감지 / 미감지 $p5Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 정면 전면전 | $p5StandardClash | ${pct(p5StandardClash, p5Total)} | ${winRate(p5StandardClashWin, p5StandardClash)} |');
    buf.writeln('| B. 디파일러 | $p5DefilerSwarm | ${pct(p5DefilerSwarm, p5Total)} | ${winRate(p5DefilerSwarmWin, p5DefilerSwarm)} |');
    buf.writeln('| C. 드랍 올인 | $p5LastDrop | ${pct(p5LastDrop, p5Total)} | ${winRate(p5LastDropWin, p5LastDrop)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]',
          LogOwner.away => '[Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
      buf.writeln('');
      buf.writeln('> 병력 T ${lastState.homeArmy} vs Z ${lastState.awayArmy}');
      buf.writeln('> 자원 T ${lastState.homeResources} vs Z ${lastState.awayResources}');
      buf.writeln('> **결과: ${lastState.homeWin == true ? '이영호 (T) 승리' : '이재동 (Z) 승리'}**');
    }

    File('tvz_scenario1.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 1 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 테란압박 $p2TerranPush, 뮤탈 $p2ZergFastMutal, 링기습 $p2ZergLingAmbush, 정찰 $p2TerranScout, 미감지 $p2Unknown');
    print('Phase4: 타이밍 $p4TimingPush, 매크로 $p4MacroTransition, 드랍 $p4DropshipRaid, 미감지 $p4Unknown');
    print('Phase5: 전면전 $p5StandardClash, 디파일러 $p5DefilerSwarm, 드랍올인 $p5LastDrop, 미감지 $p5Unknown');
  });

  // =======================================================
  // 2. 메카닉 vs 럴커/디파일러 (tvz_mech_vs_lurker)
  // =======================================================
  test('TvZ 시나리오 2: 메카닉 vs 럴커 100경기 → tvz_scenario2.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2: lurker_positioning (2 branches)
    int p2ScanLurker = 0, p2ScanLurkerWin = 0;
    int p2LurkerHold = 0, p2LurkerHoldWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_3fac_goliath',
        forcedAwayBuildId: 'zvt_2hatch_lurker',
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

      // Phase 2 판별
      final hasA = allText.contains('스캔') || allText.contains('럴커 위치를 정확히') || allText.contains('정밀 포격');
      final hasB = allText.contains('럴커 포진') || allText.contains('럴커에 마린이 녹') || allText.contains('럴커 매복');

      if (hasA) { p2ScanLurker++; if (won) p2ScanLurkerWin++; }
      else if (hasB) { p2LurkerHold++; if (won) p2LurkerHoldWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2ScanLurker + p2LurkerHold;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 2: 메카닉 vs 럴커 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_3fac_goliath');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_2hatch_lurker');
    buf.writeln('- 시나리오: tvz_mech_vs_lurker');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 럴커 포진 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 스캔 럴커 | $p2ScanLurker | ${pct(p2ScanLurker, p2Total)} | ${winRate(p2ScanLurkerWin, p2ScanLurker)} |');
    buf.writeln('| B. 럴커 수비 | $p2LurkerHold | ${pct(p2LurkerHold, p2Total)} | ${winRate(p2LurkerHoldWin, p2LurkerHold)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario2.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 2 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 스캔 $p2ScanLurker, 럴커수비 $p2LurkerHold, 미감지 $p2Unknown');
  });

  // =======================================================
  // 3. 치즈 vs 스탠다드 (tvz_cheese_vs_standard)
  // =======================================================
  test('TvZ 시나리오 3: 벙커 치즈 vs 스탠다드 100경기 → tvz_scenario3.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2: detection (2 branches)
    int p2Detected = 0, p2DetectedWin = 0;
    int p2BunkerOk = 0, p2BunkerOkWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_bunker',
        forcedAwayBuildId: 'zvt_12pool',
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

      final hasDetected = allText.contains('오버로드가 SCV를 포착') || allText.contains('드론 모아서 SCV') || allText.contains('써큰 콜로니 완성');
      final hasBunkerOk = allText.contains('벙커 건설 성공') || allText.contains('벙커 완성') || allText.contains('마린이 들어갑니다');

      if (hasDetected) { p2Detected++; if (won) p2DetectedWin++; }
      else if (hasBunkerOk) { p2BunkerOk++; if (won) p2BunkerOkWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2Detected + p2BunkerOk;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 3: 벙커 치즈 vs 스탠다드 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_bunker');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_12pool');
    buf.writeln('- 시나리오: tvz_cheese_vs_standard');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 발견 여부 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 벙커 발견 | $p2Detected | ${pct(p2Detected, p2Total)} | ${winRate(p2DetectedWin, p2Detected)} |');
    buf.writeln('| B. 벙커 성공 | $p2BunkerOk | ${pct(p2BunkerOk, p2Total)} | ${winRate(p2BunkerOkWin, p2BunkerOk)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario3.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 3 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 발견 $p2Detected, 벙커성공 $p2BunkerOk, 미감지 $p2Unknown');
  });

  // =======================================================
  // 4. 111 밸런스 vs 매크로 (tvz_111_vs_macro)
  // =======================================================
  test('TvZ 시나리오 4: 111 vs 매크로 100경기 → tvz_scenario4.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (wraith_scout): 2 branches
    int p2OverlordHunt = 0, p2OverlordHuntWin = 0;
    int p2OverlordDefense = 0, p2OverlordDefenseWin = 0;
    int p2Unknown = 0;

    // Phase 4 (late_transition): 2 branches
    int p4SecondPush = 0, p4SecondPushWin = 0;
    int p4MassOverwhelm = 0, p4MassOverwhelmWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_111',
        forcedAwayBuildId: 'zvt_3hatch_nopool',
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

      // Phase 2 판별
      final hasP2A = allText.contains('오버로드를 발견') || allText.contains('오버로드 격추') || allText.contains('서플라이가 막히');
      final hasP2B = allText.contains('오버로드 위치 관리') || allText.contains('레이스가 빈손') || allText.contains('오버로드를 안전한');

      if (hasP2A) { p2OverlordHunt++; if (won) p2OverlordHuntWin++; }
      else if (hasP2B) { p2OverlordDefense++; if (won) p2OverlordDefenseWin++; }
      else { p2Unknown++; }

      // Phase 4 판별
      final hasP4A = allText.contains('2차 공격') || allText.contains('멀티 포인트 공격') || allText.contains('양쪽에서 동시 압박');
      final hasP4B = allText.contains('울트라리스크') || allText.contains('울트라 등장') || allText.contains('울트라 저글링 대규모');

      if (hasP4A) { p4SecondPush++; if (won) p4SecondPushWin++; }
      else if (hasP4B) { p4MassOverwhelm++; if (won) p4MassOverwhelmWin++; }
      else { p4Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2OverlordHunt + p2OverlordDefense;
    final p4Total = p4SecondPush + p4MassOverwhelm;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 4: 111 밸런스 vs 매크로 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_111');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_3hatch_nopool');
    buf.writeln('- 시나리오: tvz_111_vs_macro');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 레이스 정찰 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 오버로드 격추 | $p2OverlordHunt | ${pct(p2OverlordHunt, p2Total)} | ${winRate(p2OverlordHuntWin, p2OverlordHunt)} |');
    buf.writeln('| B. 오버로드 방어 | $p2OverlordDefense | ${pct(p2OverlordDefense, p2Total)} | ${winRate(p2OverlordDefenseWin, p2OverlordDefense)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 후반 전환 ($p4Total 감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 2차 공격 | $p4SecondPush | ${pct(p4SecondPush, p4Total)} | ${winRate(p4SecondPushWin, p4SecondPush)} |');
    buf.writeln('| B. 저그 물량 | $p4MassOverwhelm | ${pct(p4MassOverwhelm, p4Total)} | ${winRate(p4MassOverwhelmWin, p4MassOverwhelm)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario4.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 4 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 오버헌트 $p2OverlordHunt, 오버방어 $p2OverlordDefense, 미감지 $p2Unknown');
    print('Phase4: 2차공격 $p4SecondPush, 물량 $p4MassOverwhelm, 미감지 $p4Unknown');
  });

  // =======================================================
  // 5. 투스타 레이스 vs 뮤탈 (tvz_wraith_vs_mutal)
  // =======================================================
  test('TvZ 시나리오 5: 레이스 vs 뮤탈 100경기 → tvz_scenario5.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (air_first_contact): 2 branches
    int p2WraithSuccess = 0, p2WraithSuccessWin = 0;
    int p2MutalResponse = 0, p2MutalResponseWin = 0;
    int p2Unknown = 0;

    // Phase 4 (transition): 2 branches
    int p4GroundTransition = 0, p4GroundTransitionWin = 0;
    int p4MutalOverwhelm = 0, p4MutalOverwhelmWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_2star_wraith',
        forcedAwayBuildId: 'zvt_2hatch_mutal',
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

      // Phase 2 판별
      final hasP2A = allText.contains('클로킹 레이스가 저그 본진') || allText.contains('오버로드 격추') || allText.contains('드론이 당하고');
      final hasP2B = allText.contains('뮤탈리스크가 빠르게 등장') || allText.contains('레이스가 뮤탈에 쫓기') || allText.contains('뮤탈이 바로 SCV');

      if (hasP2A) { p2WraithSuccess++; if (won) p2WraithSuccessWin++; }
      else if (hasP2B) { p2MutalResponse++; if (won) p2MutalResponseWin++; }
      else { p2Unknown++; }

      // Phase 4 판별
      final hasP4A = allText.contains('지상 병력 전환') || allText.contains('시즈 탱크와 골리앗이 합류') || allText.contains('레이스+지상 복합');
      final hasP4B = allText.contains('뮤탈이 끝없이') || allText.contains('뮤탈 12기') || allText.contains('뮤탈 물량에 밀리');

      if (hasP4A) { p4GroundTransition++; if (won) p4GroundTransitionWin++; }
      else if (hasP4B) { p4MutalOverwhelm++; if (won) p4MutalOverwhelmWin++; }
      else { p4Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2WraithSuccess + p2MutalResponse;
    final p4Total = p4GroundTransition + p4MutalOverwhelm;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 5: 레이스 vs 뮤탈 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_2star_wraith');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_2hatch_mutal');
    buf.writeln('- 시나리오: tvz_wraith_vs_mutal');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 공중 접촉 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 레이스 견제 | $p2WraithSuccess | ${pct(p2WraithSuccess, p2Total)} | ${winRate(p2WraithSuccessWin, p2WraithSuccess)} |');
    buf.writeln('| B. 뮤탈 대응 | $p2MutalResponse | ${pct(p2MutalResponse, p2Total)} | ${winRate(p2MutalResponseWin, p2MutalResponse)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 전환기 ($p4Total 감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 지상 전환 | $p4GroundTransition | ${pct(p4GroundTransition, p4Total)} | ${winRate(p4GroundTransitionWin, p4GroundTransition)} |');
    buf.writeln('| B. 뮤탈 압도 | $p4MutalOverwhelm | ${pct(p4MutalOverwhelm, p4Total)} | ${winRate(p4MutalOverwhelmWin, p4MutalOverwhelm)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario5.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 5 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 레이스성공 $p2WraithSuccess, 뮤탈대응 $p2MutalResponse, 미감지 $p2Unknown');
    print('Phase4: 지상전환 $p4GroundTransition, 뮤탈압도 $p4MutalOverwhelm, 미감지 $p4Unknown');
  });

  // =======================================================
  // 6. 치즈 vs 치즈: 벙커 vs 4풀 (tvz_cheese_vs_cheese)
  // =======================================================
  test('TvZ 시나리오 6: 벙커 vs 4풀 100경기 → tvz_scenario6.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (cross_attack): 2 branches
    int p2LingsHitBase = 0, p2LingsHitBaseWin = 0;
    int p2TerranHitsBase = 0, p2TerranHitsBaseWin = 0;
    int p2Unknown = 0;

    // Phase 3 (cheese_resolution): 2 branches
    int p3BunkerCrush = 0, p3BunkerCrushWin = 0;
    int p3LingsDestroy = 0, p3LingsDestroyWin = 0;
    int p3Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_bunker',
        forcedAwayBuildId: 'zvt_4pool',
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

      // Phase 2 판별
      final hasP2A = allText.contains('저글링 6기가 테란 본진') || allText.contains('본진이 비어있습니다') || allText.contains('텅 빈 본진');
      final hasP2B = allText.contains('마린 SCV가 저그 앞마당에 도착') || allText.contains('벙커 올립니다') || allText.contains('저글링이 엇갈렸');

      if (hasP2A) { p2LingsHitBase++; if (won) p2LingsHitBaseWin++; }
      else if (hasP2B) { p2TerranHitsBase++; if (won) p2TerranHitsBaseWin++; }
      else { p2Unknown++; }

      // Phase 3 판별
      final hasP3A = allText.contains('벙커 완성! 마린이 들어갑') || allText.contains('드론으로 막아보려') || allText.contains('벙커 압박이 성공');
      final hasP3B = allText.contains('저글링이 테란 본진 SCV를 전부') || allText.contains('본진이 괴멸') || allText.contains('돌이킬 수 없는');

      if (hasP3A) { p3BunkerCrush++; if (won) p3BunkerCrushWin++; }
      else if (hasP3B) { p3LingsDestroy++; if (won) p3LingsDestroyWin++; }
      else { p3Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2LingsHitBase + p2TerranHitsBase;
    final p3Total = p3BunkerCrush + p3LingsDestroy;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 6: 벙커 vs 4풀 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_bunker');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_4pool');
    buf.writeln('- 시나리오: tvz_cheese_vs_cheese');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 엇갈린 공격 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 저글링→T본진 | $p2LingsHitBase | ${pct(p2LingsHitBase, p2Total)} | ${winRate(p2LingsHitBaseWin, p2LingsHitBase)} |');
    buf.writeln('| B. 테란→Z본진 | $p2TerranHitsBase | ${pct(p2TerranHitsBase, p2Total)} | ${winRate(p2TerranHitsBaseWin, p2TerranHitsBase)} |');
    buf.writeln('');
    buf.writeln('## Phase 3: 치즈 결말 ($p3Total 감지 / 미감지 $p3Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 벙커 압사 | $p3BunkerCrush | ${pct(p3BunkerCrush, p3Total)} | ${winRate(p3BunkerCrushWin, p3BunkerCrush)} |');
    buf.writeln('| B. 저글링 파괴 | $p3LingsDestroy | ${pct(p3LingsDestroy, p3Total)} | ${winRate(p3LingsDestroyWin, p3LingsDestroy)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario6.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 6 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 링→T $p2LingsHitBase, T→Z $p2TerranHitsBase, 미감지 $p2Unknown');
    print('Phase3: 벙커압사 $p3BunkerCrush, 링파괴 $p3LingsDestroy, 미감지 $p3Unknown');
  });

  // =======================================================
  // 7. 9풀 vs 스탠다드 테란 (tvz_standard_vs_9pool)
  // =======================================================
  test('TvZ 시나리오 7: 스탠다드 vs 9풀 100경기 → tvz_scenario7.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (ling_rush_response): 2 branches
    int p2TerranScouted = 0, p2TerranScoutedWin = 0;
    int p2LingSuccess = 0, p2LingSuccessWin = 0;
    int p2Unknown = 0;

    // Phase 4 (late_development): 2 branches
    int p4TerranRecovers = 0, p4TerranRecoversWin = 0;
    int p4ZergLeverages = 0, p4ZergLeveragesWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: terranPlayer, awayPlayer: zergPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_sk',
        forcedAwayBuildId: 'zvt_9pool',
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

      // Phase 2 판별
      final hasP2A = allText.contains('9풀을 확인') || allText.contains('빠른 풀을 읽었') || allText.contains('벙커가 이미 있');
      final hasP2B = allText.contains('발업 저글링이 진영 입구') || allText.contains('저글링 기습') || allText.contains('SCV까지 물어뜯');

      if (hasP2A) { p2TerranScouted++; if (won) p2TerranScoutedWin++; }
      else if (hasP2B) { p2LingSuccess++; if (won) p2LingSuccessWin++; }
      else { p2Unknown++; }

      // Phase 4 판별
      final hasP4A = allText.contains('경제 복구 완료') || allText.contains('마린 메딕 조합으로 전진') || allText.contains('9풀 이후 경제가 부족');
      final hasP4B = allText.contains('뮤탈리스크 등장! 초반 이득') || allText.contains('뮤탈로 견제하면서 세 번째') || allText.contains('초반 피해 복구가 안');

      if (hasP4A) { p4TerranRecovers++; if (won) p4TerranRecoversWin++; }
      else if (hasP4B) { p4ZergLeverages++; if (won) p4ZergLeveragesWin++; }
      else { p4Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2TerranScouted + p2LingSuccess;
    final p4Total = p4TerranRecovers + p4ZergLeverages;

    final buf = StringBuffer();
    buf.writeln('# TvZ 시나리오 7: 스탠다드 vs 9풀 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvz_sk');
    buf.writeln('- 어웨이: 이재동 (Z) | 빌드: zvt_9pool');
    buf.writeln('- 시나리오: tvz_standard_vs_9pool');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (T) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 이재동 (Z) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 초반 저글링 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 정찰 성공 | $p2TerranScouted | ${pct(p2TerranScouted, p2Total)} | ${winRate(p2TerranScoutedWin, p2TerranScouted)} |');
    buf.writeln('| B. 저글링 성공 | $p2LingSuccess | ${pct(p2LingSuccess, p2Total)} | ${winRate(p2LingSuccessWin, p2LingSuccess)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 후반 전개 ($p4Total 감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 테란 복구 | $p4TerranRecovers | ${pct(p4TerranRecovers, p4Total)} | ${winRate(p4TerranRecoversWin, p4TerranRecovers)} |');
    buf.writeln('| B. 저그 활용 | $p4ZergLeverages | ${pct(p4ZergLeverages, p4Total)} | ${winRate(p4ZergLeveragesWin, p4ZergLeverages)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]', LogOwner.away => '[Z]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvz_scenario7.md').writeAsStringSync(buf.toString());
    print('=== TvZ 시나리오 7 ===');
    print('전적: T $homeWins - $awayWins Z');
    print('Phase2: 정찰 $p2TerranScouted, 링성공 $p2LingSuccess, 미감지 $p2Unknown');
    print('Phase4: T복구 $p4TerranRecovers, Z활용 $p4ZergLeverages, 미감지 $p4Unknown');
  });
}
