import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('히드라 압박 vs 포지더블 100경기 통계 → zvp.md', () async {
    final homePlayer = Player(
      id: 'zerg_test',
      name: '이제동',
      raceIndex: 1,
      stats: const PlayerStats(
        sense: 700, control: 710, attack: 690, harass: 720,
        strategy: 680, macro: 710, defense: 680, scout: 690,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'protoss_test',
      name: '김택용',
      raceIndex: 2,
      stats: const PlayerStats(
        sense: 690, control: 700, attack: 680, harass: 700,
        strategy: 710, macro: 690, defense: 720, scout: 680,
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

    int homeWins = 0;
    int awayWins = 0;

    // Phase 2 분기 추적 (3개: hydra_push_result)
    int p2HydraPushSuccess = 0, p2HydraPushSuccessWin = 0;       // A: attack (Z>P)
    int p2CorsairOverlordHunt = 0, p2CorsairOverlordHuntWin = 0; // B: harass (P>Z)
    int p2CannonDefenseHold = 0, p2CannonDefenseHoldWin = 0;     // C: defense (P>Z)
    int p2Unknown = 0;

    // Phase 4 분기 추적 (2개: late_game)
    int p4ZergHiveTech = 0, p4ZergHiveTechWin = 0;       // A: macro (Z>P)
    int p4ProtossDeathball = 0, p4ProtossDeathballWin = 0; // B: strategy (P>Z)
    int p4Unknown = 0;

    // 마진 추적
    final homeArmyMargins = <int>[];
    final homeResourceMargins = <int>[];

    SimulationState? lastState;

    for (int i = 0; i < 100; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvp_12hatch',
        forcedAwayBuildId: 'pvz_forge_cannon',
      );

      SimulationState? state;
      await for (final s in stream) {
        state = s;
      }
      lastState = state;

      if (state == null) continue;

      final won = state.homeWin == true;
      if (won) {
        homeWins++;
      } else {
        awayWins++;
      }

      homeArmyMargins.add(state.homeArmy - state.awayArmy);
      homeResourceMargins.add(state.homeResources - state.awayResources);

      // 로그 텍스트에서 분기 판별
      final allText = state.battleLogEntries.map((e) => e.text).join(' ');

      // === Phase 2 판별 (hydra_push_result) ===
      // Branch A: hydra_push_success - 히드라가 앞마당 돌파
      final hasP2A = allText.contains('히드라 편대가 프로토스 앞마당을 두드립니다') ||
          allText.contains('포토캐논이 무너지고') ||
          allText.contains('히드라가 앞마당 진입');
      // Branch B: corsair_overlord_hunt - 커세어 오버로드 연속 격추
      final hasP2B = allText.contains('커세어 3기가 오버로드를 연속 격추') ||
          allText.contains('오버로드가 줄줄이 떨어집니다') ||
          allText.contains('서플라이가 막혀서 히드라를 추가 못 뽑습니다');
      // Branch C: cannon_defense_hold - 캐논 수비 성공
      final hasP2C = allText.contains('포토캐논 추가 건설') ||
          allText.contains('캐논 라인이 촘촘합니다') ||
          allText.contains('히드라가 캐논+질럿에 막힙니다');

      if (hasP2A && !hasP2B && !hasP2C) {
        p2HydraPushSuccess++;
        if (won) p2HydraPushSuccessWin++;
      } else if (hasP2B && !hasP2A && !hasP2C) {
        p2CorsairOverlordHunt++;
        if (won) p2CorsairOverlordHuntWin++;
      } else if (hasP2C && !hasP2A && !hasP2B) {
        p2CannonDefenseHold++;
        if (won) p2CannonDefenseHoldWin++;
      } else if (hasP2A) {
        p2HydraPushSuccess++;
        if (won) p2HydraPushSuccessWin++;
      } else if (hasP2B) {
        p2CorsairOverlordHunt++;
        if (won) p2CorsairOverlordHuntWin++;
      } else if (hasP2C) {
        p2CannonDefenseHold++;
        if (won) p2CannonDefenseHoldWin++;
      } else {
        p2Unknown++;
      }

      // === Phase 4 판별 (late_game) ===
      // Branch A: zerg_hive_tech - 하이브+디파일러+울트라
      final hasP4A = allText.contains('하이브 완성') ||
          allText.contains('디파일러 플레이그') ||
          allText.contains('울트라리스크까지 합류');
      // Branch B: protoss_deathball - 한방 병력
      final hasP4B = allText.contains('한방 병력 완성') ||
          allText.contains('드라군 질럿 하이 템플러 옵저버') ||
          allText.contains('셔틀에 하이 템플러를 태워서 견제');

      if (hasP4A && !hasP4B) {
        p4ZergHiveTech++;
        if (won) p4ZergHiveTechWin++;
      } else if (hasP4B && !hasP4A) {
        p4ProtossDeathball++;
        if (won) p4ProtossDeathballWin++;
      } else if (hasP4A && hasP4B) {
        // 둘 다 감지되면 먼저 나온 쪽으로 판별
        final idxA = allText.indexOf('하이브 완성');
        final idxB = allText.indexOf('한방 병력 완성');
        final idxA2 = allText.indexOf('디파일러 플레이그');
        final idxB2 = allText.indexOf('드라군 질럿 하이 템플러 옵저버');
        final firstA = [idxA, idxA2].where((i) => i >= 0).fold(999999, (a, b) => a < b ? a : b);
        final firstB = [idxB, idxB2].where((i) => i >= 0).fold(999999, (a, b) => a < b ? a : b);
        if (firstA <= firstB) {
          p4ZergHiveTech++;
          if (won) p4ZergHiveTechWin++;
        } else {
          p4ProtossDeathball++;
          if (won) p4ProtossDeathballWin++;
        }
      } else {
        p4Unknown++;
      }
    }

    // 통계 계산
    final avgArmyMargin = homeArmyMargins.isEmpty ? 0 :
        homeArmyMargins.reduce((a, b) => a + b) / homeArmyMargins.length;
    final avgResourceMargin = homeResourceMargins.isEmpty ? 0 :
        homeResourceMargins.reduce((a, b) => a + b) / homeResourceMargins.length;

    // 유틸 함수
    String winRate(int wins, int total) =>
        total > 0 ? '${(wins / total * 100).toStringAsFixed(1)}%' : '-';
    String pct(int count, int total) =>
        total > 0 ? '${(count / total * 100).toStringAsFixed(1)}%' : '-';

    final total = homeWins + awayWins;
    final p2Total = p2HydraPushSuccess + p2CorsairOverlordHunt + p2CannonDefenseHold;
    final p4Total = p4ZergHiveTech + p4ProtossDeathball;

    // zvp.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# ZvP 히드라 압박 vs 포지더블 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 이제동 (Zerg) | 빌드: zvp_12hatch');
    buffer.writeln('- 어웨이: 김택용 (Protoss) | 빌드: pvz_forge_cannon');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('- 시나리오: zvp_hydra_vs_forge (히드라 압박 vs 포지더블 국룰전)');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이제동 (Z) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 김택용 (P) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = Z 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = Z 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 히드라 압박 결과 (${p2Total}경기 감지 / 미감지 $p2Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 히드라 압박 성공 | attack (Z>P) | $p2HydraPushSuccess | ${pct(p2HydraPushSuccess, p2Total)} | ${winRate(p2HydraPushSuccessWin, p2HydraPushSuccess)} |');
    buffer.writeln('| B. 커세어 오버로드 사냥 | harass (P>Z) | $p2CorsairOverlordHunt | ${pct(p2CorsairOverlordHunt, p2Total)} | ${winRate(p2CorsairOverlordHuntWin, p2CorsairOverlordHunt)} |');
    buffer.writeln('| C. 캐논 수비 성공 | defense (P>Z) | $p2CannonDefenseHold | ${pct(p2CannonDefenseHold, p2Total)} | ${winRate(p2CannonDefenseHoldWin, p2CannonDefenseHold)} |');
    buffer.writeln('');

    // Phase 4 분기 통계
    buffer.writeln('## Phase 4: 후반 전환 (${p4Total}경기 감지 / 미감지 $p4Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | Z 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 저그 하이브 테크 | macro (Z>P) | $p4ZergHiveTech | ${pct(p4ZergHiveTech, p4Total)} | ${winRate(p4ZergHiveTechWin, p4ZergHiveTech)} |');
    buffer.writeln('| B. 프로토스 한방 병력 | strategy (P>Z) | $p4ProtossDeathball | ${pct(p4ProtossDeathball, p4Total)} | ${winRate(p4ProtossDeathballWin, p4ProtossDeathball)} |');
    buffer.writeln('');

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 이제동 (Z) | 김택용 (P) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| attack | 690 | 680 | **Z** | P2-A (Z>P) |');
    buffer.writeln('| harass | 720 | 700 | **Z** | P2-B (P>Z이므로 비적격) |');
    buffer.writeln('| defense | 680 | 720 | **P** | P2-C (P>Z) |');
    buffer.writeln('| macro | 710 | 690 | **Z** | P4-A (Z>P) |');
    buffer.writeln('| strategy | 680 | 710 | **P** | P4-B (P>Z) |');
    buffer.writeln('| control | 710 | 700 | **Z** | - |');
    buffer.writeln('| sense | 700 | 690 | **Z** | - |');
    buffer.writeln('| scout | 690 | 680 | **Z** | - |');
    buffer.writeln('');

    buffer.writeln('---');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 제100경기 (마지막 경기 전체 로그)');
    buffer.writeln('');

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
      buffer.writeln('> **병력** Z ${lastState.homeArmy} vs P ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** Z ${lastState.homeResources} vs P ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '이제동 (Z) 승리' : '김택용 (P) 승리'}**');
    }

    final file = File('zvp.md');
    file.writeAsStringSync(buffer.toString());
    print('zvp.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 이제동 $homeWins - $awayWins 김택용');
    print('');
    print('=== Phase 2 ($p2Total 감지) ===');
    print('A. 히드라 압박 성공: $p2HydraPushSuccess (Z승 $p2HydraPushSuccessWin)');
    print('B. 커세어 오버로드 사냥: $p2CorsairOverlordHunt (Z승 $p2CorsairOverlordHuntWin)');
    print('C. 캐논 수비 성공: $p2CannonDefenseHold (Z승 $p2CannonDefenseHoldWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 4 ($p4Total 감지) ===');
    print('A. 저그 하이브 테크: $p4ZergHiveTech (Z승 $p4ZergHiveTechWin)');
    print('B. 프로토스 한방 병력: $p4ProtossDeathball (Z승 $p4ProtossDeathballWin)');
    print('미감지: $p4Unknown');
  });
}
