import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// 동급 선수 생성 (능력치 ~700, 레벨 7)
final _homeProtoss = Player(
  id: 'protoss_home',
  name: '홍진호',
  raceIndex: 2,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 680,
    strategy: 720, macro: 700, defense: 690, scout: 710,
  ),
  levelValue: 7,
  condition: 100,
);

final _awayProtoss = Player(
  id: 'protoss_away',
  name: '이제동',
  raceIndex: 2,
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

void main() {
  // ============================================================
  // 시나리오 1: pvp_dragoon_nexus_mirror
  // ============================================================
  test('PvP S1: 원겟 드라군 넥서스 미러 100경기', () async {
    // Phase 2 분기 2개: home_robo_away_dark, double_robo
    // Phase 3 분기 2개: reaver_success, shuttle_shot_down
    int homeWins = 0, awayWins = 0;
    int p2RoboAwayDark = 0, p2RoboAwayDarkWin = 0;
    int p2DoubleRobo = 0, p2DoubleRoboWin = 0;
    int p2Unknown = 0;
    int p3ReaverSuccess = 0, p3ReaverSuccessWin = 0;
    int p3ShuttleDown = 0, p3ShuttleDownWin = 0;
    int p3Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayProtoss,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon',
        forcedAwayBuildId: 'pvp_2gate_dragoon',
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

      // Phase 2: tech_choice
      // 분기 A: home_robo_away_dark - "시타델 오브 아둔 건설! 다크를 노립니다" or "다크 템플러가 잠입합니다"
      final hasRoboAwayDark = allText.contains('시타델 오브 아둔 건설! 다크를 노립니다') ||
          allText.contains('다크 테크! 기습을 노리는') ||
          allText.contains('다크 템플러가 잠입합니다');
      // 분기 B: double_robo - "셔틀 리버 경쟁" or "양측 셔틀 리버가 교차"
      final hasDoubleRobo = allText.contains('셔틀 리버 경쟁') ||
          allText.contains('양측 셔틀 리버가 교차') ||
          allText.contains('서로 견제합니다');

      if (hasRoboAwayDark) { p2RoboAwayDark++; if (won) p2RoboAwayDarkWin++; }
      else if (hasDoubleRobo) { p2DoubleRobo++; if (won) p2DoubleRoboWin++; }
      else { p2Unknown++; }

      // Phase 3: shuttle_reaver_battle
      // 분기 A: reaver_success - "셔틀이 상대 프로브 라인에 리버를 내립니다" or "리버 투하! 프로브가 날아갑니다"
      final hasReaverSuccess = allText.contains('셔틀이 상대 프로브 라인에 리버를 내립니다') ||
          allText.contains('리버 투하! 프로브가 날아갑니다') ||
          allText.contains('셔틀이 리버를 태우고 안전하게 빠집니다') ||
          allText.contains('리버 견제가 성공');
      // 분기 B: shuttle_shot_down - "드라군이 셔틀을 집중 사격합니다! 격추"
      final hasShuttleDown = allText.contains('드라군이 셔틀을 집중 사격합니다! 격추') ||
          allText.contains('드라군 집중! 셔틀이 격추') ||
          allText.contains('셔틀이 떨어집니다! 리버가 고립') ||
          allText.contains('셔틀 격추! PvP에서');

      if (hasReaverSuccess) { p3ReaverSuccess++; if (won) p3ReaverSuccessWin++; }
      else if (hasShuttleDown) { p3ShuttleDown++; if (won) p3ShuttleDownWin++; }
      else { p3Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2RoboAwayDark + p2DoubleRobo;
    final p3Total = p3ReaverSuccess + p3ShuttleDown;

    final buf = StringBuffer();
    buf.writeln('# PvP S1: 원겟 드라군 넥서스 미러 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvp_2gate_dragoon | 어웨이: 이제동 (P) pvp_2gate_dragoon');
    buf.writeln('- 시나리오: pvp_dragoon_nexus_mirror');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 홍진호 (홈) | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| 이제동 (어웨이) | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 테크 분기 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 로보+다크 | $p2RoboAwayDark | ${_pct(p2RoboAwayDark, p2Total)} | ${_winRate(p2RoboAwayDarkWin, p2RoboAwayDark)} |');
    buf.writeln('| B. 양쪽 로보 | $p2DoubleRobo | ${_pct(p2DoubleRobo, p2Total)} | ${_winRate(p2DoubleRoboWin, p2DoubleRobo)} |');
    buf.writeln('');
    buf.writeln('## Phase 3: 셔틀 리버 교전 ($p3Total감지 / 미감지 $p3Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 리버 성공 | $p3ReaverSuccess | ${_pct(p3ReaverSuccess, p3Total)} | ${_winRate(p3ReaverSuccessWin, p3ReaverSuccess)} |');
    buf.writeln('| B. 셔틀 격추 | $p3ShuttleDown | ${_pct(p3ShuttleDown, p3Total)} | ${_winRate(p3ShuttleDownWin, p3ShuttleDown)} |');
    buf.writeln('');

    final file = File('pvp_s1_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvp_s1_report.md 저장 완료');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('P2: 로보+다크=$p2RoboAwayDark 양쪽로보=$p2DoubleRobo 미감지=$p2Unknown');
    print('P3: 리버성공=$p3ReaverSuccess 셔틀격추=$p3ShuttleDown 미감지=$p3Unknown');
  });

  // ============================================================
  // 시나리오 2: pvp_dragoon_vs_nogate
  // ============================================================
  test('PvP S2: 원겟 드라군 vs 노겟 넥서스 100경기', () async {
    // Phase 2 분기 2개: zealot_probe_damage, probe_defense_hold
    int homeWins = 0, awayWins = 0;
    int p2ZealotDamage = 0, p2ZealotDamageWin = 0;
    int p2DefenseHold = 0, p2DefenseHoldWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayProtoss,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_2gate_dragoon',
        forcedAwayBuildId: 'pvp_1gate_multi',
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

      // Phase 2: early_pressure_result
      final hasZealotDamage = allText.contains('질럿이 프로브 3기를 잡습니다') ||
          allText.contains('질럿 컨트롤! 프로브 피해가') ||
          allText.contains('노겟 넥서스의 이점이 줄어듭니다') ||
          allText.contains('노겟 넥서스를 흔듭니다') ||
          allText.contains('질럿 견제 성공');
      final hasDefenseHold = allText.contains('프로브와 질럿의 협공으로 적 질럿을 잡아냅니다') ||
          allText.contains('프로브 컨트롤! 질럿을 잡습니다') ||
          allText.contains('질럿을 잃었습니다! 견제 실패') ||
          allText.contains('넥서스의 자원이 빛을 발합니다') ||
          allText.contains('자원 이점을 병력으로 전환') ||
          allText.contains('프로브 수비 성공');

      if (hasZealotDamage) { p2ZealotDamage++; if (won) p2ZealotDamageWin++; }
      else if (hasDefenseHold) { p2DefenseHold++; if (won) p2DefenseHoldWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2ZealotDamage + p2DefenseHold;

    final buf = StringBuffer();
    buf.writeln('# PvP S2: 원겟 드라군 vs 노겟 넥서스 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvp_2gate_dragoon | 어웨이: 이제동 (P) pvp_1gate_multi');
    buf.writeln('- 시나리오: pvp_dragoon_vs_nogate');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 홍진호 (홈) | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| 이제동 (어웨이) | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 초반 압박 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 질럿 피해 성공 | $p2ZealotDamage | ${_pct(p2ZealotDamage, p2Total)} | ${_winRate(p2ZealotDamageWin, p2ZealotDamage)} |');
    buf.writeln('| B. 프로브 방어 | $p2DefenseHold | ${_pct(p2DefenseHold, p2Total)} | ${_winRate(p2DefenseHoldWin, p2DefenseHold)} |');
    buf.writeln('');

    final file = File('pvp_s2_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvp_s2_report.md 저장 완료');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('P2: 질럿피해=$p2ZealotDamage 방어성공=$p2DefenseHold 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 3: pvp_robo_vs_2gate_dragoon
  // ============================================================
  test('PvP S3: 원겟 로보 리버 vs 투겟 드라군 100경기', () async {
    // Phase 2 분기 2개: dragoon_overwhelm, reaver_turns_tide
    int homeWins = 0, awayWins = 0;
    int p2DragoonOverwhelm = 0, p2DragoonOverwhelmWin = 0;
    int p2ReaverTurns = 0, p2ReaverTurnsWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayProtoss,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_1gate_robo',
        forcedAwayBuildId: 'pvp_2gate_dragoon',
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

      // Phase 2: clash_result
      final hasDragoonOverwhelm = allText.contains('드라군 물량이 리버 나오기 전에 밀어냅니다') ||
          allText.contains('드라군이 압도합니다! 수가 너무 많아요') ||
          allText.contains('리버를 잡아냅니다! 드라군 집중 사격') ||
          allText.contains('드라군 물량 차이가 결정적');
      final hasReaverTurns = allText.contains('리버 스캐럽! 드라군 2기가 한 번에') ||
          allText.contains('스캐럽 명중! 드라군이 터집니다') ||
          allText.contains('셔틀 리버 컨트롤! 내렸다 태웠다') ||
          allText.contains('리버 화력이 드라군 물량을 압도');

      if (hasDragoonOverwhelm) { p2DragoonOverwhelm++; if (won) p2DragoonOverwhelmWin++; }
      else if (hasReaverTurns) { p2ReaverTurns++; if (won) p2ReaverTurnsWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2DragoonOverwhelm + p2ReaverTurns;

    final buf = StringBuffer();
    buf.writeln('# PvP S3: 원겟 로보 리버 vs 투겟 드라군 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvp_1gate_robo | 어웨이: 이제동 (P) pvp_2gate_dragoon');
    buf.writeln('- 시나리오: pvp_robo_vs_2gate_dragoon');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 홍진호 (홈) | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| 이제동 (어웨이) | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 교전 결과 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 드라군 압도 | $p2DragoonOverwhelm | ${_pct(p2DragoonOverwhelm, p2Total)} | ${_winRate(p2DragoonOverwhelmWin, p2DragoonOverwhelm)} |');
    buf.writeln('| B. 리버 역전 | $p2ReaverTurns | ${_pct(p2ReaverTurns, p2Total)} | ${_winRate(p2ReaverTurnsWin, p2ReaverTurns)} |');
    buf.writeln('');

    final file = File('pvp_s3_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvp_s3_report.md 저장 완료');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('P2: 드라군압도=$p2DragoonOverwhelm 리버역전=$p2ReaverTurns 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 4: pvp_dark_vs_dragoon
  // ============================================================
  test('PvP S4: 다크 올인 vs 스탠다드 100경기', () async {
    // Phase 2 분기 2개: dark_massacre, dark_blocked
    int homeWins = 0, awayWins = 0;
    int p2DarkMassacre = 0, p2DarkMassacreWin = 0;
    int p2DarkBlocked = 0, p2DarkBlockedWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayProtoss,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_dark_allin',
        forcedAwayBuildId: 'pvp_2gate_dragoon',
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

      // Phase 2: dark_result
      final hasDarkMassacre = allText.contains('다크가 프로브를 베기 시작합니다! 옵저버가 없어요') ||
          allText.contains('다크 성공! 프로브가 몰살') ||
          allText.contains('디텍이 없습니다! 로보틱스를 짓지 않았어요') ||
          allText.contains('다크가 프로브를 전멸') ||
          allText.contains('다크 올인 대성공');
      final hasDarkBlocked = allText.contains('옵저버가 다크를 포착') ||
          allText.contains('옵저버 있습니다! 다크가 보여요') ||
          allText.contains('드라군이 다크를 집중 사격! 격파') ||
          allText.contains('다크를 잡아냅니다') ||
          allText.contains('다크 올인이 막혔습니다');

      if (hasDarkMassacre) { p2DarkMassacre++; if (won) p2DarkMassacreWin++; }
      else if (hasDarkBlocked) { p2DarkBlocked++; if (won) p2DarkBlockedWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2DarkMassacre + p2DarkBlocked;

    final buf = StringBuffer();
    buf.writeln('# PvP S4: 다크 올인 vs 스탠다드 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvp_dark_allin | 어웨이: 이제동 (P) pvp_2gate_dragoon');
    buf.writeln('- 시나리오: pvp_dark_vs_dragoon');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 홍진호 (홈) | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| 이제동 (어웨이) | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 다크 결과 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 다크 학살 | $p2DarkMassacre | ${_pct(p2DarkMassacre, p2Total)} | ${_winRate(p2DarkMassacreWin, p2DarkMassacre)} |');
    buf.writeln('| B. 다크 차단 | $p2DarkBlocked | ${_pct(p2DarkBlocked, p2Total)} | ${_winRate(p2DarkBlockedWin, p2DarkBlocked)} |');
    buf.writeln('');

    final file = File('pvp_s4_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvp_s4_report.md 저장 완료');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('P2: 다크학살=$p2DarkMassacre 다크차단=$p2DarkBlocked 미감지=$p2Unknown');
  });

  // ============================================================
  // 시나리오 5: pvp_zealot_rush
  // ============================================================
  test('PvP S5: 센터 게이트 질럿 러시 vs 스탠다드 100경기', () async {
    // Phase 2 분기 2개: zealot_rush_wins, rush_defended
    int homeWins = 0, awayWins = 0;
    int p2RushWins = 0, p2RushWinsWin = 0;
    int p2Defended = 0, p2DefendedWin = 0;
    int p2Unknown = 0;
    final armyMargins = <int>[];
    final resourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: _homeProtoss,
        awayPlayer: _awayProtoss,
        map: _testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'pvp_zealot_rush',
        forcedAwayBuildId: 'pvp_2gate_dragoon',
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
      final hasRushWins = allText.contains('질럿이 프로브를 잡습니다! 수적 우위') ||
          allText.contains('질럿이 프로브를 베어냅니다') ||
          allText.contains('추가 질럿까지 합류! 상대 본진 초토화') ||
          allText.contains('질럿 러시 성공! 프로토스가 무너지고');
      final hasDefended = allText.contains('질럿과 프로브로 협공! 적 질럿을 잡아냅니다') ||
          allText.contains('완벽한 수비! 질럿 러시를 막습니다') ||
          allText.contains('질럿이 녹고 있습니다! 러시 실패') ||
          allText.contains('질럿 러시가 막혔습니다! 테크 차이');

      if (hasRushWins) { p2RushWins++; if (won) p2RushWinsWin++; }
      else if (hasDefended) { p2Defended++; if (won) p2DefendedWin++; }
      else { p2Unknown++; }
    }

    final total = homeWins + awayWins;
    final avgArmy = armyMargins.isEmpty ? 0.0 : armyMargins.reduce((a, b) => a + b) / armyMargins.length;
    final avgRes = resourceMargins.isEmpty ? 0.0 : resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
    final p2Total = p2RushWins + p2Defended;

    final buf = StringBuffer();
    buf.writeln('# PvP S5: 센터 게이트 질럿 러시 vs 스탠다드 - 100경기');
    buf.writeln('- 홈: 홍진호 (P) pvp_zealot_rush | 어웨이: 이제동 (P) pvp_2gate_dragoon');
    buf.writeln('- 시나리오: pvp_zealot_rush');
    buf.writeln('');
    buf.writeln('## 종합 ($total경기)');
    buf.writeln('| 선수 | 승 | 패 | 승률 |');
    buf.writeln('|------|----|----|------|');
    buf.writeln('| 홍진호 (홈) | $homeWins | $awayWins | ${_winRate(homeWins, total)} |');
    buf.writeln('| 이제동 (어웨이) | $awayWins | $homeWins | ${_winRate(awayWins, total)} |');
    buf.writeln('- 평균 병력차: ${avgArmy.toStringAsFixed(1)} | 평균 자원차: ${avgRes.toStringAsFixed(1)}');
    buf.writeln('');
    buf.writeln('## Phase 2: 결과 ($p2Total감지 / 미감지 $p2Unknown)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    buf.writeln('| A. 러시 성공 | $p2RushWins | ${_pct(p2RushWins, p2Total)} | ${_winRate(p2RushWinsWin, p2RushWins)} |');
    buf.writeln('| B. 수비 성공 | $p2Defended | ${_pct(p2Defended, p2Total)} | ${_winRate(p2DefendedWin, p2Defended)} |');
    buf.writeln('');

    final file = File('pvp_s5_report.md');
    file.writeAsStringSync(buf.toString());
    print('pvp_s5_report.md 저장 완료');
    print('전적: 홈 $homeWins - $awayWins 어웨이');
    print('P2: 러시성공=$p2RushWins 수비성공=$p2Defended 미감지=$p2Unknown');
  });
}
