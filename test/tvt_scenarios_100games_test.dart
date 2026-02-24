import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  // 동급 테란 선수 생성 (능력치 ~700, 레벨 7)
  final homePlayer = Player(
    id: 'terran_home',
    name: '이영호',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'terran_away',
    name: '박명수',
    raceIndex: 0,
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
  // 1. 배럭 더블 vs 팩토리 더블 (tvt_rax_double_vs_fac_double)
  // =======================================================
  test('TvT 시나리오 1: 배럭더블 vs 팩더블 100경기 → tvt_scenario1.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (vulture_clash): 2 branches
    int p2HomeVulture = 0, p2HomeVultureWin = 0;
    int p2AwayVulture = 0, p2AwayVultureWin = 0;
    int p2Unknown = 0;

    // Phase 4 (drop_transition): 2 branches
    int p4DropSuccess = 0, p4DropSuccessWin = 0;
    int p4FrontalBreak = 0, p4FrontalBreakWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_cc_first',
        forcedAwayBuildId: 'tvt_2fac_vulture',
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
      final hasP2A = allText.contains('벌처 컨트롤이 좋습니다') || allText.contains('벌처 컨트롤 차이') || allText.contains('벌처로 상대 SCV 라인을 괴롭');
      final hasP2B = allText.contains('벌처 속업이 먼저 완료') || allText.contains('벌처 속업 타이밍') || allText.contains('마인 매설로 맵 컨트롤');

      if (hasP2A) { p2HomeVulture++; if (won) p2HomeVultureWin++; }
      else if (hasP2B) { p2AwayVulture++; if (won) p2AwayVultureWin++; }
      else { p2Unknown++; }

      // Phase 4 판별
      final hasP4A = allText.contains('드랍십 출격') || allText.contains('탱크를 내립니다') || allText.contains('멀티포인트 공격') || allText.contains('드랍+정면');
      final hasP4B = allText.contains('탱크 라인을 밀어냅니다') || allText.contains('시즈 포격! 상대 탱크 라인') || allText.contains('라인이 밀립니다');

      if (hasP4A) { p4DropSuccess++; if (won) p4DropSuccessWin++; }
      else if (hasP4B) { p4FrontalBreak++; if (won) p4FrontalBreakWin++; }
      else { p4Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2HomeVulture + p2AwayVulture;
    final p4Total = p4DropSuccess + p4FrontalBreak;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 1: 배럭더블 vs 팩더블 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_cc_first');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_2fac_vulture');
    buf.writeln('- 시나리오: tvt_rax_double_vs_fac_double');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어웨이) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} (양수=홈유리)');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)} (양수=홈유리)');
    buf.writeln('');
    buf.writeln('## Phase 2: 벌처 교전 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 홈 벌처 우세 | $p2HomeVulture | ${pct(p2HomeVulture, p2Total)} | ${winRate(p2HomeVultureWin, p2HomeVulture)} |');
    buf.writeln('| B. 어웨이 벌처 우세 | $p2AwayVulture | ${pct(p2AwayVulture, p2Total)} | ${winRate(p2AwayVultureWin, p2AwayVulture)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 드랍/돌파 ($p4Total 감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 드랍 성공 | $p4DropSuccess | ${pct(p4DropSuccess, p4Total)} | ${winRate(p4DropSuccessWin, p4DropSuccess)} |');
    buf.writeln('| B. 정면 돌파 | $p4FrontalBreak | ${pct(p4FrontalBreak, p4Total)} | ${winRate(p4FrontalBreakWin, p4FrontalBreak)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈T]', LogOwner.away => '[어T]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
      buf.writeln('');
      buf.writeln('> 병력 홈 ${lastState.homeArmy} vs 어 ${lastState.awayArmy}');
      buf.writeln('> 자원 홈 ${lastState.homeResources} vs 어 ${lastState.awayResources}');
      buf.writeln('> **결과: ${lastState.homeWin == true ? '이영호 (홈) 승리' : '박명수 (어웨이) 승리'}**');
    }

    File('tvt_scenario1.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 1 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 홈벌처 $p2HomeVulture, 어웨이벌처 $p2AwayVulture, 미감지 $p2Unknown');
    print('Phase4: 드랍 $p4DropSuccess, 돌파 $p4FrontalBreak, 미감지 $p4Unknown');
  });

  // =======================================================
  // 2. BBS vs 노배럭 더블 (tvt_bbs_vs_double)
  // =======================================================
  test('TvT 시나리오 2: BBS vs 노배럭더블 100경기 → tvt_scenario2.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (scout_check): 2 branches
    int p2Scouted = 0, p2ScoutedWin = 0;
    int p2BunkerOk = 0, p2BunkerOkWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_bbs',
        forcedAwayBuildId: 'tvt_cc_first',
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
      final hasScouted = allText.contains('센터 배럭을 발견') || allText.contains('BBS를 읽었') || allText.contains('SCV를 뭉쳐서 센터 마린');
      final hasBunkerOk = allText.contains('벙커 건설 성공') || allText.contains('벙커 완성') || allText.contains('벙커에서 마린이 쏟아');

      if (hasScouted) { p2Scouted++; if (won) p2ScoutedWin++; }
      else if (hasBunkerOk) { p2BunkerOk++; if (won) p2BunkerOkWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2Scouted + p2BunkerOk;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 2: BBS vs 노배럭더블 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_bbs');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_cc_first');
    buf.writeln('- 시나리오: tvt_bbs_vs_double');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈/BBS) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어/더블) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 정찰 여부 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. BBS 발견 | $p2Scouted | ${pct(p2Scouted, p2Total)} | ${winRate(p2ScoutedWin, p2Scouted)} |');
    buf.writeln('| B. 벙커 성공 | $p2BunkerOk | ${pct(p2BunkerOk, p2Total)} | ${winRate(p2BunkerOkWin, p2BunkerOk)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈T]', LogOwner.away => '[어T]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvt_scenario2.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 2 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: BBS발견 $p2Scouted, 벙커성공 $p2BunkerOk, 미감지 $p2Unknown');
  });

  // =======================================================
  // 3. 투스타 레이스 vs 배럭 더블 (tvt_wraith_vs_rax_double)
  // =======================================================
  test('TvT 시나리오 3: 레이스 vs 배럭더블 100경기 → tvt_scenario3.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (cloak_result): 2 branches
    int p2Devastation = 0, p2DevastationWin = 0;
    int p2Defended = 0, p2DefendedWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_wraith_cloak',
        forcedAwayBuildId: 'tvt_cc_first',
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
      final hasDevastation = allText.contains('SCV를 학살') || allText.contains('디텍이 없어요') || allText.contains('추가 레이스까지');
      final hasDefended = allText.contains('터렛을 미리 건설') || allText.contains('레이스를 잃었') || allText.contains('터렛이 레이스를 포착');

      if (hasDevastation) { p2Devastation++; if (won) p2DevastationWin++; }
      else if (hasDefended) { p2Defended++; if (won) p2DefendedWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2Devastation + p2Defended;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 3: 투스타 레이스 vs 배럭더블 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_wraith_cloak');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_cc_first');
    buf.writeln('- 시나리오: tvt_wraith_vs_rax_double');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈/레이스) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어/더블) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 클로킹 견제 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 클로킹 대학살 | $p2Devastation | ${pct(p2Devastation, p2Total)} | ${winRate(p2DevastationWin, p2Devastation)} |');
    buf.writeln('| B. 견제 방어 | $p2Defended | ${pct(p2Defended, p2Total)} | ${winRate(p2DefendedWin, p2Defended)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈T]', LogOwner.away => '[어T]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvt_scenario3.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 3 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 대학살 $p2Devastation, 방어 $p2Defended, 미감지 $p2Unknown');
  });

  // =======================================================
  // 4. 5팩 타이밍 vs 마인 트리플 (tvt_5fac_vs_mine_triple)
  // =======================================================
  test('TvT 시나리오 4: 5팩 vs 마인트리플 100경기 → tvt_scenario4.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (clash): 2 branches
    int p2TimingBreak = 0, p2TimingBreakWin = 0;
    int p2MineHolds = 0, p2MineHoldsWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_5fac',
        forcedAwayBuildId: 'tvt_1fac_expand',
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
      final hasBreak = allText.contains('마인 지대를 뚫습니다') || allText.contains('수비 라인이 밀리') || allText.contains('5팩 물량으로 밀어');
      final hasHold = allText.contains('마인에 벌처가 터집') || allText.contains('마인 폭발') || allText.contains('트리플 경제로 역전');

      if (hasBreak) { p2TimingBreak++; if (won) p2TimingBreakWin++; }
      else if (hasHold) { p2MineHolds++; if (won) p2MineHoldsWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2TimingBreak + p2MineHolds;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 4: 5팩 타이밍 vs 마인 트리플 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_5fac');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_1fac_expand');
    buf.writeln('- 시나리오: tvt_5fac_vs_mine_triple');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈/5팩) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어/트리플) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 교전 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 타이밍 돌파 | $p2TimingBreak | ${pct(p2TimingBreak, p2Total)} | ${winRate(p2TimingBreakWin, p2TimingBreak)} |');
    buf.writeln('| B. 마인 수비 | $p2MineHolds | ${pct(p2MineHolds, p2Total)} | ${winRate(p2MineHoldsWin, p2MineHolds)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      buf.writeln('');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[홈T]', LogOwner.away => '[어T]',
          LogOwner.system => '[해설]', LogOwner.clash => '[전투]',
        };
        buf.writeln('$prefix ${entry.text}');
      }
    }

    File('tvt_scenario4.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 4 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 돌파 $p2TimingBreak, 마인수비 $p2MineHolds, 미감지 $p2Unknown');
  });
}
