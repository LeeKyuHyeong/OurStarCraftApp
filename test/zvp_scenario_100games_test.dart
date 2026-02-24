import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  // =========================================================
  // 공통 선수/맵 설정
  // =========================================================
  final homePlayer = Player(
    id: 'zerg_test',
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
    id: 'protoss_test',
    name: '김택용',
    raceIndex: 2, // Protoss
    stats: const PlayerStats(
      sense: 690, control: 700, attack: 710, harass: 680,
      strategy: 720, macro: 690, defense: 700, scout: 710,
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

  // =========================================================
  // 유틸 함수
  // =========================================================
  String winRate(int wins, int total) =>
      total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
  String pct(int count, int total) =>
      total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';

  // =========================================================
  // 시나리오 1: 히드라 압박 vs 포지더블 (zvp_hydra_vs_forge)
  // homeBuild: zvp_3hatch_hydra, awayBuild: pvz_forge_cannon
  // Phase 2 분기: hydra_push_success / corsair_overlord_hunt / cannon_defense_hold
  // Phase 4 분기: zerg_hive_tech / protoss_deathball
  // =========================================================
  test('ZvP 시나리오1: 히드라 압박 vs 포지더블 100경기', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 분기 추적
    int p2HydraPush = 0, p2HydraPushWin = 0;
    int p2CorsairHunt = 0, p2CorsairHuntWin = 0;
    int p2CannonDefense = 0, p2CannonDefenseWin = 0;
    int p2Unknown = 0;

    // Phase 4 분기 추적
    int p4HiveTech = 0, p4HiveTechWin = 0;
    int p4DeathBall = 0, p4DeathBallWin = 0;
    int p4Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_3hatch_hydra',
        forcedAwayBuildId: 'pvz_forge_cannon',
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

      // Phase 2: hydra_push_success
      final hasP2A = allText.contains('히드라 편대가 프로토스 앞마당을 두드립니다') ||
          allText.contains('포토캐논이 무너지고') ||
          allText.contains('히드라가 앞마당 진입');
      // Phase 2: corsair_overlord_hunt
      final hasP2B = allText.contains('커세어 3기가 오버로드를 연속 격추') ||
          allText.contains('오버로드가 줄줄이 떨어집니다') ||
          allText.contains('서플라이가 막혀서');
      // Phase 2: cannon_defense_hold
      final hasP2C = allText.contains('포토캐논 추가 건설') ||
          allText.contains('캐논 라인이 촘촘') ||
          allText.contains('히드라가 캐논+질럿에 막힙니다');

      if (hasP2A && !hasP2B && !hasP2C) {
        p2HydraPush++; if (won) p2HydraPushWin++;
      } else if (hasP2B && !hasP2A && !hasP2C) {
        p2CorsairHunt++; if (won) p2CorsairHuntWin++;
      } else if (hasP2C && !hasP2A && !hasP2B) {
        p2CannonDefense++; if (won) p2CannonDefenseWin++;
      } else if (hasP2A || hasP2B || hasP2C) {
        // 복수 감지 시 첫 번째 우선
        if (hasP2A) { p2HydraPush++; if (won) p2HydraPushWin++; }
        else if (hasP2B) { p2CorsairHunt++; if (won) p2CorsairHuntWin++; }
        else { p2CannonDefense++; if (won) p2CannonDefenseWin++; }
      } else {
        p2Unknown++;
      }

      // Phase 4: zerg_hive_tech
      final hasP4A = allText.contains('하이브 완성') ||
          allText.contains('디파일러 플레이그') ||
          allText.contains('울트라리스크까지 합류');
      // Phase 4: protoss_deathball
      final hasP4B = allText.contains('드라군 질럿 하이 템플러 옵저버') ||
          allText.contains('한방 병력 완성') ||
          allText.contains('셔틀에 하이 템플러를 태워서');

      if (hasP4A && !hasP4B) {
        p4HiveTech++; if (won) p4HiveTechWin++;
      } else if (hasP4B && !hasP4A) {
        p4DeathBall++; if (won) p4DeathBallWin++;
      } else if (hasP4A && hasP4B) {
        final idxA = allText.indexOf('하이브');
        final idxB = allText.indexOf('한방 병력');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p4HiveTech++; if (won) p4HiveTechWin++;
        } else {
          p4DeathBall++; if (won) p4DeathBallWin++;
        }
      } else {
        p4Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2HydraPush + p2CorsairHunt + p2CannonDefense;
    final p4Total = p4HiveTech + p4DeathBall;

    final buffer = StringBuffer();
    buffer.writeln('# ZvP 시나리오1: 히드라 압박 vs 포지더블 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (Zerg) | 빌드: zvp_3hatch_hydra');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_forge_cannon');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)} (양수 = Z 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)} (양수 = Z 유리)');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 히드라 압박 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 히드라 압박 성공 | $p2HydraPush | ${pct(p2HydraPush, p2Total)} | ${winRate(p2HydraPushWin, p2HydraPush)} |');
    buffer.writeln('| B. 커세어 오버로드 사냥 | $p2CorsairHunt | ${pct(p2CorsairHunt, p2Total)} | ${winRate(p2CorsairHuntWin, p2CorsairHunt)} |');
    buffer.writeln('| C. 캐논 방어 | $p2CannonDefense | ${pct(p2CannonDefense, p2Total)} | ${winRate(p2CannonDefenseWin, p2CannonDefense)} |');
    buffer.writeln('');
    buffer.writeln('## Phase 4: 후반 전환 (${p4Total}감지 / 미감지 $p4Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 하이브 테크 | $p4HiveTech | ${pct(p4HiveTech, p4Total)} | ${winRate(p4HiveTechWin, p4HiveTech)} |');
    buffer.writeln('| B. 프로토스 한방 | $p4DeathBall | ${pct(p4DeathBall, p4Total)} | ${winRate(p4DeathBallWin, p4DeathBall)} |');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 마지막 경기 로그');
    if (lastState != null) {
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z]',
          LogOwner.away => '[P]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
      buffer.writeln('');
      buffer.writeln('> 병력 Z ${lastState.homeArmy} vs P ${lastState.awayArmy}');
      buffer.writeln('> 자원 Z ${lastState.homeResources} vs P ${lastState.awayResources}');
      buffer.writeln('> 결과: ${lastState.homeWin == true ? '이재동 (Z) 승리' : '김택용 (P) 승리'}');
    }

    final file = File('zvp_scenario1.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp_scenario1.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 김택용');
    print('Phase 2: 히드라$p2HydraPush 커세어$p2CorsairHunt 캐논$p2CannonDefense 미감지$p2Unknown');
    print('Phase 4: 하이브$p4HiveTech 한방$p4DeathBall 미감지$p4Unknown');
  });

  // =========================================================
  // 시나리오 2: 뮤탈 운영 vs 포지더블 (zvp_mutal_vs_forge)
  // homeBuild: zvp_2hatch_mutal, awayBuild: pvz_forge_cannon
  // Phase 2 분기: mutal_harass_success / corsair_mutal_counter
  // =========================================================
  test('ZvP 시나리오2: 뮤탈 운영 vs 포지더블 100경기', () async {
    int homeWins = 0, awayWins = 0;

    // Phase 2 분기 추적
    int p2MutalSuccess = 0, p2MutalSuccessWin = 0;
    int p2CorsairCounter = 0, p2CorsairCounterWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_2hatch_mutal',
        forcedAwayBuildId: 'pvz_forge_cannon',
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

      // Phase 2: mutal_harass_success
      final hasP2A = allText.contains('뮤탈이 프로브를 물어뜯습니다') ||
          allText.contains('뮤짤') ||
          allText.contains('뮤탈을 빼면서 다른 곳');
      // Phase 2: corsair_mutal_counter
      final hasP2B = allText.contains('커세어가 뮤탈을 쫓아갑니다') ||
          allText.contains('커세어 컨트롤! 뮤탈을 잡아') ||
          allText.contains('스포어도 깔았습니다');

      if (hasP2A && !hasP2B) {
        p2MutalSuccess++; if (won) p2MutalSuccessWin++;
      } else if (hasP2B && !hasP2A) {
        p2CorsairCounter++; if (won) p2CorsairCounterWin++;
      } else if (hasP2A && hasP2B) {
        p2MutalSuccess++; if (won) p2MutalSuccessWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2MutalSuccess + p2CorsairCounter;

    final buffer = StringBuffer();
    buffer.writeln('# ZvP 시나리오2: 뮤탈 운영 vs 포지더블 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (Zerg) | 빌드: zvp_2hatch_mutal');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_forge_cannon');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 뮤탈 견제 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 뮤탈 견제 성공 | $p2MutalSuccess | ${pct(p2MutalSuccess, p2Total)} | ${winRate(p2MutalSuccessWin, p2MutalSuccess)} |');
    buffer.writeln('| B. 커세어 대응 | $p2CorsairCounter | ${pct(p2CorsairCounter, p2Total)} | ${winRate(p2CorsairCounterWin, p2CorsairCounter)} |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z]',
          LogOwner.away => '[P]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
      buffer.writeln('');
      buffer.writeln('> 병력 Z ${lastState.homeArmy} vs P ${lastState.awayArmy}');
      buffer.writeln('> 자원 Z ${lastState.homeResources} vs P ${lastState.awayResources}');
      buffer.writeln('> 결과: ${lastState.homeWin == true ? '이재동 (Z) 승리' : '김택용 (P) 승리'}');
    }

    final file = File('zvp_scenario2.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp_scenario2.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 김택용');
    print('Phase 2: 뮤탈성공$p2MutalSuccess 커세어대응$p2CorsairCounter 미감지$p2Unknown');
  });

  // =========================================================
  // 시나리오 3: 9풀 vs 포지더블 (zvp_9pool_vs_forge)
  // homeBuild: zvp_9pool, awayBuild: pvz_forge_cannon
  // Phase 2 분기: ling_breaks_through / cannon_holds
  // =========================================================
  test('ZvP 시나리오3: 9풀 vs 포지더블 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2LingBreak = 0, p2LingBreakWin = 0;
    int p2CannonHolds = 0, p2CannonHoldsWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_9pool',
        forcedAwayBuildId: 'pvz_forge_cannon',
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

      // ling_breaks_through
      final hasP2A = allText.contains('캐논 완성 전에 도착') ||
          allText.contains('프로브로 막으려 하지만 저글링이 너무 빠릅니다') ||
          allText.contains('본진까지 침투');
      // cannon_holds
      final hasP2B = allText.contains('캐논 완성! 저글링을 잡아') ||
          allText.contains('포토캐논이 제때 완성') ||
          allText.contains('질럿까지 나오면서 완벽한 수비');

      if (hasP2A && !hasP2B) {
        p2LingBreak++; if (won) p2LingBreakWin++;
      } else if (hasP2B && !hasP2A) {
        p2CannonHolds++; if (won) p2CannonHoldsWin++;
      } else if (hasP2A && hasP2B) {
        p2LingBreak++; if (won) p2LingBreakWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2LingBreak + p2CannonHolds;

    final buffer = StringBuffer();
    buffer.writeln('# ZvP 시나리오3: 9풀 vs 포지더블 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (Zerg) | 빌드: zvp_9pool');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_forge_cannon');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 수비 여부 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 저글링 돌파 | $p2LingBreak | ${pct(p2LingBreak, p2Total)} | ${winRate(p2LingBreakWin, p2LingBreak)} |');
    buffer.writeln('| B. 캐논 수비 성공 | $p2CannonHolds | ${pct(p2CannonHolds, p2Total)} | ${winRate(p2CannonHoldsWin, p2CannonHolds)} |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z]',
          LogOwner.away => '[P]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('zvp_scenario3.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp_scenario3.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 김택용');
    print('Phase 2: 돌파$p2LingBreak 수비$p2CannonHolds 미감지$p2Unknown');
  });

  // =========================================================
  // 시나리오 4: 치즈 대결 (zvp_cheese_vs_cheese)
  // homeBuild: zvp_4pool, awayBuild: pvz_proxy_gate
  // Phase 2 분기: lings_overwhelm / zealots_hold
  // =========================================================
  test('ZvP 시나리오4: 4풀 vs 전진 게이트 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2LingsWin_ = 0, p2LingsWinWin = 0;
    int p2ZealotsHold = 0, p2ZealotsHoldWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_4pool',
        forcedAwayBuildId: 'pvz_proxy_gate',
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

      // lings_overwhelm
      final hasP2A = allText.contains('저글링 물량이 질럿을 압도') ||
          allText.contains('저글링이 프로브 라인을 초토화') ||
          allText.contains('프로브로 막으려 하지만 저글링이 너무 많습니다');
      // zealots_hold
      final hasP2B = allText.contains('질럿이 저글링을 다 잡아') ||
          allText.contains('질럿 컨트롤! 저글링이 녹아') ||
          allText.contains('저글링이 전멸');

      if (hasP2A && !hasP2B) {
        p2LingsWin_++; if (won) p2LingsWinWin++;
      } else if (hasP2B && !hasP2A) {
        p2ZealotsHold++; if (won) p2ZealotsHoldWin++;
      } else if (hasP2A && hasP2B) {
        p2LingsWin_++; if (won) p2LingsWinWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2LingsWin_ + p2ZealotsHold;

    final buffer = StringBuffer();
    buffer.writeln('# ZvP 시나리오4: 4풀 vs 전진 게이트 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (Zerg) | 빌드: zvp_4pool');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_proxy_gate');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 저글링 물량 승리 | $p2LingsWin_ | ${pct(p2LingsWin_, p2Total)} | ${winRate(p2LingsWinWin, p2LingsWin_)} |');
    buffer.writeln('| B. 질럿 수비 | $p2ZealotsHold | ${pct(p2ZealotsHold, p2Total)} | ${winRate(p2ZealotsHoldWin, p2ZealotsHold)} |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z]',
          LogOwner.away => '[P]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('zvp_scenario4.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp_scenario4.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 김택용');
    print('Phase 2: 저글링$p2LingsWin_ 질럿$p2ZealotsHold 미감지$p2Unknown');
  });

  // =========================================================
  // 시나리오 5: 뮤커지 vs 커세어 리버 (zvp_mukerji_vs_corsair_reaver)
  // homeBuild: zvp_mukerji, awayBuild: pvz_corsair_reaver
  // Phase 2 분기: reaver_devastation / scourge_shuttle_kill
  // =========================================================
  test('ZvP 시나리오5: 뮤커지 vs 커세어 리버 100경기', () async {
    int homeWins = 0, awayWins = 0;

    int p2ReaverDev = 0, p2ReaverDevWin = 0;
    int p2ScourgeKill = 0, p2ScourgeKillWin = 0;
    int p2Unknown = 0;

    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];
    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_mukerji',
        forcedAwayBuildId: 'pvz_corsair_reaver',
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

      // reaver_devastation
      final hasP2A = allText.contains('리버 투하! 드론이 스캐럽에') ||
          allText.contains('스캐럽 명중! 드론 대학살') ||
          allText.contains('셔틀 회수! 안전하게 빠집니다');
      // scourge_shuttle_kill
      final hasP2B = allText.contains('스커지가 셔틀을 포착') ||
          allText.contains('셔틀이 격추됩니다') ||
          allText.contains('고립된 리버를 잡아냅니다');

      if (hasP2A && !hasP2B) {
        p2ReaverDev++; if (won) p2ReaverDevWin++;
      } else if (hasP2B && !hasP2A) {
        p2ScourgeKill++; if (won) p2ScourgeKillWin++;
      } else if (hasP2A && hasP2B) {
        p2ReaverDev++; if (won) p2ReaverDevWin++;
      } else {
        p2Unknown++;
      }
    }

    final avgArmy = homeArmyMargins.isEmpty ? 0.0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResource = homeResourceMargins.isEmpty ? 0.0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    final total = homeWins + awayWins;
    final p2Total = p2ReaverDev + p2ScourgeKill;

    final buffer = StringBuffer();
    buffer.writeln('# ZvP 시나리오5: 뮤커지 vs 커세어 리버 - 100경기');
    buffer.writeln('');
    buffer.writeln('- 홈: 이재동 (Zerg) | 빌드: zvp_mukerji');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_corsair_reaver');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이재동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmy.toStringAsFixed(1)}');
    buffer.writeln('- 평균 자원 차이: ${avgResource.toStringAsFixed(1)}');
    buffer.writeln('');
    buffer.writeln('## Phase 2: 리버 드랍 결과 (${p2Total}감지 / 미감지 $p2Unknown)');
    buffer.writeln('| 분기 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|------|------|--------|');
    buffer.writeln('| A. 리버 드랍 성공 | $p2ReaverDev | ${pct(p2ReaverDev, p2Total)} | ${winRate(p2ReaverDevWin, p2ReaverDev)} |');
    buffer.writeln('| B. 스커지 셔틀 격추 | $p2ScourgeKill | ${pct(p2ScourgeKill, p2Total)} | ${winRate(p2ScourgeKillWin, p2ScourgeKill)} |');
    buffer.writeln('');

    if (lastState != null) {
      buffer.writeln('## 마지막 경기 로그');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z]',
          LogOwner.away => '[P]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }
    }

    final file = File('zvp_scenario5.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp_scenario5.md 저장 완료');
    print('전적: 이재동 $homeWins - $awayWins 김택용');
    print('Phase 2: 리버$p2ReaverDev 스커지$p2ScourgeKill 미감지$p2Unknown');
  });
}
