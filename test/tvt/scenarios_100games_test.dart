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
        forcedHomeBuildId: 'tvt_1bar_double',
        forcedAwayBuildId: 'tvt_2fac_push',
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
      final hasP2B = allText.contains('속도 차이로 상대 벌처를 따라잡') || allText.contains('상대 벌처를 잡아냅니다') || allText.contains('마인 매설로 맵 컨트롤');

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
    buf.writeln('# TvT 시나리오 1: 배럭더블 vs 투팩벌처 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_1bar_double');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_2fac_push');
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

    File('test/output/tvt/scenario1.md').writeAsStringSync(buf.toString());
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

    // Phase 2 (marine_cut): 2 branches
    int p2ScvCut = 0, p2ScvCutWin = 0;
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
        forcedAwayBuildId: 'tvt_1bar_double',
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
      final hasScvCut = allText.contains('마린을 끊습니다') || allText.contains('마린이 벙커에 못 들어') || allText.contains('BBS 완전 차단');
      final hasBunkerOk = allText.contains('SCV를 제거하지 못합니다') || allText.contains('벙커 완성') || allText.contains('커맨드를 끝내 파괴');

      if (hasScvCut) { p2ScvCut++; if (won) p2ScvCutWin++; }
      else if (hasBunkerOk) { p2BunkerOk++; if (won) p2BunkerOkWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2ScvCut + p2BunkerOk;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 2: BBS vs 노배럭더블 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_bbs');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_1bar_double');
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
    buf.writeln('## Phase 2: SCV 컨트롤 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 마린 끊김 (SCV 컷) | $p2ScvCut | ${pct(p2ScvCut, p2Total)} | ${winRate(p2ScvCutWin, p2ScvCut)} |');
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

    File('test/output/tvt/scenario2.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 2 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: SCV컷 $p2ScvCut, 벙커성공 $p2BunkerOk, 미감지 $p2Unknown');
  });

  // =======================================================
  // 3. 투스타 레이스 vs 배럭 더블 (tvt_wraith_vs_rax_double)
  // =======================================================
  test('TvT 시나리오 3: 레이스 vs 배럭더블 100경기 → tvt_scenario3.md', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 (cloak_infiltrate): 2 branches
    int p2Devastation = 0, p2DevastationWin = 0;
    int p2Defended = 0, p2DefendedWin = 0;
    int p2Unknown = 0;

    // Phase 3 (post_defense): 2 branches (only when defended)
    int p3GoodDamage = 0, p3GoodDamageWin = 0;
    int p3MinimalDamage = 0, p3MinimalDamageWin = 0;
    int p3Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_2star',
        forcedAwayBuildId: 'tvt_1bar_double',
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
      final hasDevastation = allText.contains('디텍이 없어요') || allText.contains('패배 직결') || allText.contains('SCV 피해가 큽니다');
      final hasDefended = allText.contains('나눠 짓습니다') || allText.contains('골리앗 생산 시작') || allText.contains('레이스를 잡아냅니다') || allText.contains('드랍십이 빠릅니다');

      if (hasDevastation) { p2Devastation++; if (won) p2DevastationWin++; }
      else if (hasDefended) { p2Defended++; if (won) p2DefendedWin++; }
      else { p2Unknown++; }

      // Phase 3 판별 (방어 성공 시만)
      if (hasDefended) {
        final hasGoodDamage = allText.contains('드랍십 전환') || allText.contains('드랍십으로 뒤쪽') || allText.contains('드랍십으로 전환') || allText.contains('드랍 견제');
        final hasMinimalDamage = allText.contains('물량 차이가 벌어집니다') || allText.contains('투자 회수가 안 됩니다') || allText.contains('물량이 쌓입니다');

        if (hasGoodDamage) { p3GoodDamage++; if (won) p3GoodDamageWin++; }
        else if (hasMinimalDamage) { p3MinimalDamage++; if (won) p3MinimalDamageWin++; }
        else { p3Unknown++; }
      }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2Devastation + p2Defended;
    final p3Total = p3GoodDamage + p3MinimalDamage;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 3: 투스타 레이스 vs 배럭더블 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_2star');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_1bar_double');
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
    buf.writeln('## Phase 2: 클로킹 침투 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 클로킹 대학살 | $p2Devastation | ${pct(p2Devastation, p2Total)} | ${winRate(p2DevastationWin, p2Devastation)} |');
    buf.writeln('| B. 견제 방어 | $p2Defended | ${pct(p2Defended, p2Total)} | ${winRate(p2DefendedWin, p2Defended)} |');
    buf.writeln('');
    buf.writeln('## Phase 3: 후속 전개 ($p3Total 감지 / 미감지 $p3Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 드랍십 전환 (피해 큼) | $p3GoodDamage | ${pct(p3GoodDamage, p3Total)} | ${winRate(p3GoodDamageWin, p3GoodDamage)} |');
    buf.writeln('| B. 물량 압도 (피해 적음) | $p3MinimalDamage | ${pct(p3MinimalDamage, p3Total)} | ${winRate(p3MinimalDamageWin, p3MinimalDamage)} |');
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

    File('test/output/tvt/scenario3.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 3 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 대학살 $p2Devastation, 방어 $p2Defended, 미감지 $p2Unknown');
    print('Phase3: 피해큼 $p3GoodDamage, 피해적음 $p3MinimalDamage, 미감지 $p3Unknown');
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
        forcedAwayBuildId: 'tvt_1fac_double',
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
      final hasHold = allText.contains('마인에 벌처가 터집') || allText.contains('마인 폭발') || allText.contains('트리플 확장으로 역전');

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
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_1fac_double');
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

    File('test/output/tvt/scenario4.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 4 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 돌파 $p2TimingBreak, 마인수비 $p2MineHolds, 미감지 $p2Unknown');
  });

  // =======================================================
  // 5. BBS vs 테크 빌드 (tvt_bbs_vs_tech)
  // =======================================================
  test('TvT 시나리오 5: BBS vs 테크빌드 100경기 → tvt_scenario5.md', () async {
    // BBS vs 투팩벌처로 테스트
    int homeWins = 0, awayWins = 0;

    int p2TechDefends = 0, p2TechDefendsWin = 0;
    int p2BbsOverwhelm = 0, p2BbsOverwhelmWin = 0;
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
        forcedAwayBuildId: 'tvt_2fac_push',
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

      final hasTechDefend = allText.contains('팩토리 유닛이 가동') || allText.contains('팩토리 유닛으로 마린 격퇴') || allText.contains('테크 차이가 결정적');
      final hasBbsWin = allText.contains('벙커 완성! 마린 화력') || allText.contains('테크를 앞질렀') || allText.contains('팩토리 유닛이 너무 늦어');

      if (hasTechDefend) { p2TechDefends++; if (won) p2TechDefendsWin++; }
      else if (hasBbsWin) { p2BbsOverwhelm++; if (won) p2BbsOverwhelmWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2TechDefends + p2BbsOverwhelm;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 5: BBS vs 테크빌드 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_bbs');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_2fac_push');
    buf.writeln('- 시나리오: tvt_bbs_vs_tech');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈/BBS) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어/투팩) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 결과 분기 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 테크 방어 | $p2TechDefends | ${pct(p2TechDefends, p2Total)} | ${winRate(p2TechDefendsWin, p2TechDefends)} |');
    buf.writeln('| B. BBS 압도 | $p2BbsOverwhelm | ${pct(p2BbsOverwhelm, p2Total)} | ${winRate(p2BbsOverwhelmWin, p2BbsOverwhelm)} |');
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

    File('test/output/tvt/scenario5.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 5 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 테크방어 $p2TechDefends, BBS압도 $p2BbsOverwhelm, 미감지 $p2Unknown');
  });

  // =======================================================
  // 6. 공격적 빌드 대결 (tvt_aggressive_mirror)
  // =======================================================
  test('TvT 시나리오 6: 공격적 빌드 대결 100경기 → tvt_scenario6.md', () async {
    // 원팩원스타 vs 투스타레이스로 테스트
    int homeWins = 0, awayWins = 0;

    int p2HomeTiming = 0, p2HomeTimingWin = 0;
    int p2AwayCounter = 0, p2AwayCounterWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < gameCount; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvt_1fac_1star',
        forcedAwayBuildId: 'tvt_2star',
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

      final hasHomeTiming = allText.contains('타이밍 공격 성공') || allText.contains('탱크 시즈! 상대 병력을 포격') || allText.contains('탱크+골리앗으로 밀어붙입니다');
      final hasAwayCounter = allText.contains('역습 성공') || allText.contains('병력이 더 빠르게 모입니다') || allText.contains('탱크+골리앗으로 추격');

      if (hasHomeTiming) { p2HomeTiming++; if (won) p2HomeTimingWin++; }
      else if (hasAwayCounter) { p2AwayCounter++; if (won) p2AwayCounterWin++; }
      else { p2Unknown++; }
    }

    String winRate(int wins, int total) => total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) => total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';
    final avgArmy = homeArmyMargins.isEmpty ? 0 : homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0 : homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;
    final total = homeWins + awayWins;
    final p2Total = p2HomeTiming + p2AwayCounter;

    final buf = StringBuffer();
    buf.writeln('# TvT 시나리오 6: 공격적 빌드 대결 - ${gameCount}경기 통계');
    buf.writeln('');
    buf.writeln('- 홈: 이영호 (T) | 빌드: tvt_1fac_1star');
    buf.writeln('- 어웨이: 박명수 (T) | 빌드: tvt_2star');
    buf.writeln('- 시나리오: tvt_aggressive_mirror');
    buf.writeln('');
    buf.writeln('## 종합 전적');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 이영호 (홈/원팩) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buf.writeln('| 박명수 (어/레이스) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buf.writeln('');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)}');
    buf.writeln('- 평균 자원차: ${avgResource.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 타이밍 교전 ($p2Total 감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 홈 타이밍 | $p2HomeTiming | ${pct(p2HomeTiming, p2Total)} | ${winRate(p2HomeTimingWin, p2HomeTiming)} |');
    buf.writeln('| B. 어웨이 역습 | $p2AwayCounter | ${pct(p2AwayCounter, p2Total)} | ${winRate(p2AwayCounterWin, p2AwayCounter)} |');
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

    File('test/output/tvt/scenario6.md').writeAsStringSync(buf.toString());
    print('=== TvT 시나리오 6 ===');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('Phase2: 홈타이밍 $p2HomeTiming, 어웨이역습 $p2AwayCounter, 미감지 $p2Unknown');
  });
}
