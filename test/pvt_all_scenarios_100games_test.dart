import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// 100경기 시뮬레이션 결과 저장용
class ScenarioResult {
  final String scenarioId;
  final String description;
  final String homeBuild;
  final String awayBuild;
  int homeWins = 0;
  int awayWins = 0;
  final List<int> armyMargins = [];
  final List<int> resourceMargins = [];
  final Map<String, int> branchCounts = {};
  final Map<String, int> branchWins = {};
  int unknownBranch = 0;
  List<BattleLogEntry> lastLog = [];
  SimulationState? lastState;

  ScenarioResult({
    required this.scenarioId,
    required this.description,
    required this.homeBuild,
    required this.awayBuild,
  });
}

// 동급 선수 생성 (능력치 ~700, 레벨 7)
final _homeProtoss = Player(
  id: 'protoss_test',
  name: '홍진호',
  raceIndex: 2,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 680,
    strategy: 720, macro: 700, defense: 690, scout: 710,
  ),
  levelValue: 7,
  condition: 100,
);

final _awayTerran = Player(
  id: 'terran_test',
  name: '이영호',
  raceIndex: 0,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 700,
    strategy: 680, macro: 690, defense: 700, scout: 680,
  ),
  levelValue: 7,
  condition: 100,
);

const _testMap = GameMap(
  id: 'test_fighting_spirit',
  name: '파이팅 스피릿',
  rushDistance: 6,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 6,
  centerImportance: 5,
);

String _winRate(int wins, int total) =>
    total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
String _pct(int count, int total) =>
    total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';

Future<ScenarioResult> _run100Games({
  required String scenarioId,
  required String description,
  required String homeBuild,
  required String awayBuild,
  required Map<String, List<String>> branchKeywords,
}) async {
  final result = ScenarioResult(
    scenarioId: scenarioId,
    description: description,
    homeBuild: homeBuild,
    awayBuild: awayBuild,
  );

  for (final branchId in branchKeywords.keys) {
    result.branchCounts[branchId] = 0;
    result.branchWins[branchId] = 0;
  }

  for (int i = 0; i < 100; i++) {
    final service = MatchSimulationService();
    final stream = service.simulateMatchWithLog(
      homePlayer: _homeProtoss,
      awayPlayer: _awayTerran,
      map: _testMap,
      getIntervalMs: () => 0,
      forcedHomeBuildId: homeBuild,
      forcedAwayBuildId: awayBuild,
    );

    SimulationState? state;
    await for (final s in stream) {
      state = s;
    }
    if (state == null) continue;

    result.lastState = state;
    result.lastLog = state.battleLogEntries;

    final won = state.homeWin == true;
    if (won) {
      result.homeWins++;
    } else {
      result.awayWins++;
    }

    result.armyMargins.add(state.homeArmy - state.awayArmy);
    result.resourceMargins.add(state.homeResources - state.awayResources);

    final allText = state.battleLogEntries.map((e) => e.text).join(' ');

    // 분기 감지
    bool detected = false;
    for (final entry in branchKeywords.entries) {
      final found = entry.value.any((kw) => allText.contains(kw));
      if (found) {
        result.branchCounts[entry.key] = (result.branchCounts[entry.key] ?? 0) + 1;
        if (won) {
          result.branchWins[entry.key] = (result.branchWins[entry.key] ?? 0) + 1;
        }
        detected = true;
        break;
      }
    }
    if (!detected) {
      result.unknownBranch++;
    }
  }

  return result;
}

void main() {
  // ============================================================
  // 시나리오 1: pvt_dragoon_expand_vs_factory
  // ============================================================
  test('PvT S1: 드라군 확장 vs 팩더블 100경기', () async {
    // Phase 2 분기 3개 + Phase 4 분기 2개 → 순차 감지
    int homeWins = 0, awayWins = 0;
    int p2DragoonPush = 0, p2DragoonPushWin = 0;
    int p2VultureHarass = 0, p2VultureHarassWin = 0;
    int p2ObserverScout = 0, p2ObserverScoutWin = 0;
    int p2Unknown = 0;
    int p4Arbiter = 0, p4ArbiterWin = 0;
    int p4TankPush = 0, p4TankPushWin = 0;
    int p4Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_1gate_expand',
        forcedAwayBuildId: 'tvp_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2
      final hasP2C = allText.contains('옵저버가 전장을 정찰') ||
          allText.contains('마인 위치가 보입니다') ||
          allText.contains('마인 위치를 완벽히 파악') ||
          allText.contains('마인이 무력화');
      final hasP2A = allText.contains('드라군 편대가 전진') ||
          allText.contains('사업 완료된 드라군') ||
          allText.contains('드라군 화력이 탱크 라인을');
      final hasP2B = allText.contains('벌처가 프로토스 멀티로 돌진') ||
          allText.contains('프로브가 마인에') ||
          allText.contains('벌처 견제가 판을 흔들고');

      if (hasP2C) { p2ObserverScout++; if (won) p2ObserverScoutWin++; }
      else if (hasP2A) { p2DragoonPush++; if (won) p2DragoonPushWin++; }
      else if (hasP2B) { p2VultureHarass++; if (won) p2VultureHarassWin++; }
      else { p2Unknown++; }

      // Phase 4
      final hasP4A = allText.contains('아비터 트리뷰널 건설') ||
          allText.contains('아비터 등장') ||
          allText.contains('리콜! 테란 본진') ||
          allText.contains('리콜 투하') ||
          allText.contains('아비터 리콜이 판을');
      final hasP4B = allText.contains('시즈 탱크 5기 이상') ||
          allText.contains('대규모 푸시') ||
          allText.contains('시즈 모드! 프로토스 앞마당') ||
          allText.contains('탱크 화력이 프로토스 전선을');

      if (hasP4A && !hasP4B) { p4Arbiter++; if (won) p4ArbiterWin++; }
      else if (hasP4B && !hasP4A) { p4TankPush++; if (won) p4TankPushWin++; }
      else if (hasP4A && hasP4B) {
        final idxA = allText.indexOf('아비터');
        final idxB = allText.indexOf('시즈 탱크 5기');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) { p4Arbiter++; if (won) p4ArbiterWin++; }
        else { p4TankPush++; if (won) p4TankPushWin++; }
      } else { p4Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2DragoonPush + p2VultureHarass + p2ObserverScout;
    final p4Total = p4Arbiter + p4TankPush;

    final buf = StringBuffer();
    buf.writeln('# PvT S1: 드라군 확장 vs 팩더블 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_1gate_expand | 어웨이: 이영호 (T) tvp_double');
    buf.writeln('- 시나리오: pvt_dragoon_expand_vs_factory');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 중반 접촉 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 드라군 압박 | $p2DragoonPush | ${_pct(p2DragoonPush, p2Total)} | ${_winRate(p2DragoonPushWin, p2DragoonPush)} |');
    buf.writeln('| B. 벌처 견제 | $p2VultureHarass | ${_pct(p2VultureHarass, p2Total)} | ${_winRate(p2VultureHarassWin, p2VultureHarass)} |');
    buf.writeln('| C. 옵저버 정찰 | $p2ObserverScout | ${_pct(p2ObserverScout, p2Total)} | ${_winRate(p2ObserverScoutWin, p2ObserverScout)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 후반 전환 ($p4Total감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 아비터 | $p4Arbiter | ${_pct(p4Arbiter, p4Total)} | ${_winRate(p4ArbiterWin, p4Arbiter)} |');
    buf.writeln('| B. 탱크 푸시 | $p4TankPush | ${_pct(p4TankPush, p4Total)} | ${_winRate(p4TankPushWin, p4TankPush)} |');
    buf.writeln('');

    if (lastState != null) {
      buf.writeln('## 마지막 경기 로그');
      for (final e in lastState!.battleLogEntries) {
        final p = switch (e.owner) { LogOwner.home => '[P]', LogOwner.away => '[T]', LogOwner.system => '[해설]', LogOwner.clash => '[전투]' };
        buf.writeln('$p ${e.text}');
      }
      buf.writeln('');
      buf.writeln('> 병력 P ${lastState!.homeArmy} vs T ${lastState!.awayArmy}');
      buf.writeln('> 자원 P ${lastState!.homeResources} vs T ${lastState!.awayResources}');
      buf.writeln('> 결과: ${lastState!.homeWin == true ? 'P 승' : 'T 승'}');
    }

    final file = File('pvt_s1_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s1_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: A=$p2DragoonPush B=$p2VultureHarass C=$p2ObserverScout 미감지=$p2Unknown');
    print('P4: A=$p4Arbiter B=$p4TankPush 미감지=$p4Unknown');
  });

  // ============================================================
  // 시나리오 2: pvt_reaver_vs_timing
  // ============================================================
  test('PvT S2: 리버 셔틀 vs 타이밍 러시 100경기', () async {
    // Phase 2 분기 2개: reaver_harass_success, shuttle_destroyed
    // Phase 4 분기 2개: protoss_storm_finish, terran_mass_push
    int homeWins = 0, awayWins = 0;
    int p2ReaverSuccess = 0, p2ReaverSuccessWin = 0;
    int p2ShuttleDead = 0, p2ShuttleDeadWin = 0;
    int p2Unknown = 0;
    int p4Storm = 0, p4StormWin = 0;
    int p4MassPush = 0, p4MassPushWin = 0;
    int p4Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_reaver_shuttle',
        forcedAwayBuildId: 'tvp_fake_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: shuttle_survival
      final hasReaverSuccess = allText.contains('SCV 5기가 한 번에') ||
          allText.contains('스캐럽 대박') ||
          allText.contains('셔틀이 리버를 태우고 빠집니다') ||
          allText.contains('셔틀 컨트롤! 리버를 살려냅니다');
      final hasShuttleDead = allText.contains('터렛과 골리앗이 셔틀을 포착') ||
          allText.contains('셔틀 격추! 리버가 땅에') ||
          allText.contains('셔틀 폭사! 프로토스에게 치명적');

      if (hasReaverSuccess) { p2ReaverSuccess++; if (won) p2ReaverSuccessWin++; }
      else if (hasShuttleDead) { p2ShuttleDead++; if (won) p2ShuttleDeadWin++; }
      else { p2Unknown++; }

      // Phase 4: decisive_battle
      final hasStorm = allText.contains('하이 템플러 합류! 사이오닉 스톰') ||
          allText.contains('스톰 투하! 바이오닉') ||
          allText.contains('마린이 스톰에 녹아내립니다') ||
          allText.contains('스톰이 결정적');
      final hasMassPush = allText.contains('5팩토리 풀가동') ||
          allText.contains('팩토리 5개에서 물량') ||
          allText.contains('대규모 시즈 라인') ||
          allText.contains('테란 물량이 프로토스를 압도');

      if (hasStorm && !hasMassPush) { p4Storm++; if (won) p4StormWin++; }
      else if (hasMassPush && !hasStorm) { p4MassPush++; if (won) p4MassPushWin++; }
      else if (hasStorm && hasMassPush) {
        final idxA = allText.indexOf('하이 템플러 합류');
        final idxB = allText.indexOf('5팩토리 풀가동');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) { p4Storm++; if (won) p4StormWin++; }
        else { p4MassPush++; if (won) p4MassPushWin++; }
      } else { p4Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2ReaverSuccess + p2ShuttleDead;
    final p4Total = p4Storm + p4MassPush;

    final buf = StringBuffer();
    buf.writeln('# PvT S2: 리버 셔틀 vs 타이밍 러시 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_reaver_shuttle | 어웨이: 이영호 (T) tvp_fake_double');
    buf.writeln('- 시나리오: pvt_reaver_vs_timing');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 셔틀 생존 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 리버 성공 | $p2ReaverSuccess | ${_pct(p2ReaverSuccess, p2Total)} | ${_winRate(p2ReaverSuccessWin, p2ReaverSuccess)} |');
    buf.writeln('| B. 셔틀 격추 | $p2ShuttleDead | ${_pct(p2ShuttleDead, p2Total)} | ${_winRate(p2ShuttleDeadWin, p2ShuttleDead)} |');
    buf.writeln('');
    buf.writeln('## Phase 4: 결전 ($p4Total감지 / 미감지 $p4Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 스톰 마무리 | $p4Storm | ${_pct(p4Storm, p4Total)} | ${_winRate(p4StormWin, p4Storm)} |');
    buf.writeln('| B. 테란 물량 | $p4MassPush | ${_pct(p4MassPush, p4Total)} | ${_winRate(p4MassPushWin, p4MassPush)} |');
    buf.writeln('');

    final file = File('pvt_s2_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s2_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: 리버성공=$p2ReaverSuccess 셔틀격추=$p2ShuttleDead 미감지=$p2Unknown');
    print('P4: 스톰=$p4Storm 물량=$p4MassPush 미감지=$p4Unknown');
  });

  // ============================================================
  // 시나리오 3: pvt_dark_vs_standard
  // ============================================================
  test('PvT S3: 다크 템플러 vs 스탠다드 100경기', () async {
    // Phase 2 분기 2개: dark_success, dark_failed
    int homeWins = 0, awayWins = 0;
    int p2DarkSuccess = 0, p2DarkSuccessWin = 0;
    int p2DarkFailed = 0, p2DarkFailedWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_dark_swing',
        forcedAwayBuildId: 'tvp_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: detection_check
      final hasDarkSuccess = allText.contains('다크 템플러가 SCV를 베기') ||
          allText.contains('다크 성공! SCV가 줄줄이') ||
          allText.contains('디텍이 없습니다') ||
          allText.contains('다크 한 기가 SCV를 10기') ||
          allText.contains('다크 템플러가 대활약');
      final hasDarkFailed = allText.contains('스캔! 다크 템플러 위치가') ||
          allText.contains('컴샛으로 다크를 포착') ||
          allText.contains('마린이 다크 템플러를 집중 사격') ||
          allText.contains('다크를 잡아냅니다') ||
          allText.contains('다크 전략이 간파');

      if (hasDarkSuccess) { p2DarkSuccess++; if (won) p2DarkSuccessWin++; }
      else if (hasDarkFailed) { p2DarkFailed++; if (won) p2DarkFailedWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2DarkSuccess + p2DarkFailed;

    final buf = StringBuffer();
    buf.writeln('# PvT S3: 다크 템플러 vs 스탠다드 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_dark_swing | 어웨이: 이영호 (T) tvp_double');
    buf.writeln('- 시나리오: pvt_dark_vs_standard');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 디텍 여부 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 다크 성공 | $p2DarkSuccess | ${_pct(p2DarkSuccess, p2Total)} | ${_winRate(p2DarkSuccessWin, p2DarkSuccess)} |');
    buf.writeln('| B. 다크 실패 | $p2DarkFailed | ${_pct(p2DarkFailed, p2Total)} | ${_winRate(p2DarkFailedWin, p2DarkFailed)} |');
    buf.writeln('');

    final file = File('pvt_s3_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s3_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: 다크성공=$p2DarkSuccess 다크실패=$p2DarkFailed 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 4: pvt_cheese_vs_standard
  // ============================================================
  test('PvT S4: 센터 게이트 질럿 러시 vs 스탠다드 100경기', () async {
    // Phase 2 분기 2개: zealot_rush_success, terran_defense_success
    int homeWins = 0, awayWins = 0;
    int p2RushSuccess = 0, p2RushSuccessWin = 0;
    int p2DefenseSuccess = 0, p2DefenseSuccessWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_proxy_gate',
        forcedAwayBuildId: 'tvp_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: rush_result
      final hasRushSuccess = allText.contains('질럿이 SCV를 베기 시작') ||
          allText.contains('벙커가 완성되지 않았어요') ||
          allText.contains('추가 질럿 합류! 테란 본진이 초토화') ||
          allText.contains('질럿 러시가 성공적! 테란이 무너지고');
      final hasDefenseSuccess = allText.contains('벙커 완성! 마린이 들어갑니다') ||
          allText.contains('질럿이 벙커에 막힙니다') ||
          allText.contains('SCV 수리까지') ||
          allText.contains('질럿 러시가 막혔습니다! 프로토스가 위기');

      if (hasRushSuccess) { p2RushSuccess++; if (won) p2RushSuccessWin++; }
      else if (hasDefenseSuccess) { p2DefenseSuccess++; if (won) p2DefenseSuccessWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2RushSuccess + p2DefenseSuccess;

    final buf = StringBuffer();
    buf.writeln('# PvT S4: 센터 게이트 질럿 러시 vs 스탠다드 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_proxy_gate | 어웨이: 이영호 (T) tvp_double');
    buf.writeln('- 시나리오: pvt_cheese_vs_standard');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 수비 여부 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 러시 성공 | $p2RushSuccess | ${_pct(p2RushSuccess, p2Total)} | ${_winRate(p2RushSuccessWin, p2RushSuccess)} |');
    buf.writeln('| B. 수비 성공 | $p2DefenseSuccess | ${_pct(p2DefenseSuccess, p2Total)} | ${_winRate(p2DefenseSuccessWin, p2DefenseSuccess)} |');
    buf.writeln('');

    final file = File('pvt_s4_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s4_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: 러시성공=$p2RushSuccess 수비성공=$p2DefenseSuccess 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 5: pvt_carrier_vs_anti
  // ============================================================
  test('PvT S5: 캐리어 vs 안티 캐리어 100경기', () async {
    // Phase 2 분기 2개: carrier_dominance, goliath_counter
    int homeWins = 0, awayWins = 0;
    int p2CarrierDom = 0, p2CarrierDomWin = 0;
    int p2GoliathCounter = 0, p2GoliathCounterWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_carrier',
        forcedAwayBuildId: 'tvp_anti_carrier',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: carrier_battle
      final hasCarrierDom = allText.contains('캐리어 3기! 인터셉터가 쏟아져') ||
          allText.contains('캐리어 편대! 인터셉터가 비처럼') ||
          allText.contains('골리앗이 캐리어를 노리지만 인터셉터에 막힙니다') ||
          allText.contains('스톰+캐리어') ||
          allText.contains('캐리어가 전장을 지배');
      final hasGoliathCounter = allText.contains('골리앗 편대가 캐리어를 집중 포화') ||
          allText.contains('골리앗 집중 사격! 캐리어가 흔들') ||
          allText.contains('캐리어 1기가 격추') ||
          allText.contains('안티 캐리어 전략이 효과');

      if (hasCarrierDom) { p2CarrierDom++; if (won) p2CarrierDomWin++; }
      else if (hasGoliathCounter) { p2GoliathCounter++; if (won) p2GoliathCounterWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2CarrierDom + p2GoliathCounter;

    final buf = StringBuffer();
    buf.writeln('# PvT S5: 캐리어 vs 안티 캐리어 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_carrier | 어웨이: 이영호 (T) tvp_anti_carrier');
    buf.writeln('- 시나리오: pvt_carrier_vs_anti');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 캐리어 교전 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 캐리어 지배 | $p2CarrierDom | ${_pct(p2CarrierDom, p2Total)} | ${_winRate(p2CarrierDomWin, p2CarrierDom)} |');
    buf.writeln('| B. 골리앗 카운터 | $p2GoliathCounter | ${_pct(p2GoliathCounter, p2Total)} | ${_winRate(p2GoliathCounterWin, p2GoliathCounter)} |');
    buf.writeln('');

    final file = File('pvt_s5_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s5_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: 캐리어지배=$p2CarrierDom 골리앗카운터=$p2GoliathCounter 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 6: pvt_5gate_push
  // ============================================================
  test('PvT S6: 5게이트 푸시 vs 팩더블 100경기', () async {
    // Phase 2 분기 2개: dragoon_overwhelm, terran_holds
    int homeWins = 0, awayWins = 0;
    int p2DragoonOverwhelm = 0, p2DragoonOverwhelmWin = 0;
    int p2TerranHolds = 0, p2TerranHoldsWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayTerran,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvt_trans_5gate_push',
        forcedAwayBuildId: 'tvp_double',
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      lastState = state;

      final won = state.homeWin == true;
      if (won) homeWins++; else awayWins++;
      armyMargins.add(state.homeArmy - state.awayArmy);
      resourceMargins.add(state.homeResources - state.awayResources);

      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // Phase 2: push_result
      final hasDragoonOverwhelm = allText.contains('드라군 물량으로 탱크 라인을 밀어냅니다') ||
          allText.contains('드라군이 탱크를 녹입니다') ||
          allText.contains('앞마당 진입! 테란 앞마당이 무너집니다') ||
          allText.contains('5게이트 타이밍 공격 성공');
      final hasTerranHolds = allText.contains('시즈 탱크 시즈 모드! 드라군이 녹기') ||
          allText.contains('탱크 포격! 드라군이 한 방에') ||
          allText.contains('벌처 측면 기동') ||
          allText.contains('타이밍 공격이 막혔습니다');

      if (hasDragoonOverwhelm) { p2DragoonOverwhelm++; if (won) p2DragoonOverwhelmWin++; }
      else if (hasTerranHolds) { p2TerranHolds++; if (won) p2TerranHoldsWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2DragoonOverwhelm + p2TerranHolds;

    final buf = StringBuffer();
    buf.writeln('# PvT S6: 5게이트 푸시 vs 팩더블 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvt_trans_5gate_push | 어웨이: 이영호 (T) tvp_double');
    buf.writeln('- 시나리오: pvt_5gate_push');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| P 홍진호 | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| T 이영호 | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 교전 결과 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    buf.writeln('| A. 드라군 압도 | $p2DragoonOverwhelm | ${_pct(p2DragoonOverwhelm, p2Total)} | ${_winRate(p2DragoonOverwhelmWin, p2DragoonOverwhelm)} |');
    buf.writeln('| B. 테란 수비 | $p2TerranHolds | ${_pct(p2TerranHolds, p2Total)} | ${_winRate(p2TerranHoldsWin, p2TerranHolds)} |');
    buf.writeln('');

    final file = File('pvt_s6_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvt_s6_report.md 저장 완료');
    print('전적: P $homeWins - $awayWins T');
    print('P2: 드라군압도=$p2DragoonOverwhelm 테란수비=$p2TerranHolds 미감지=$p2Unknown');
  });
}
