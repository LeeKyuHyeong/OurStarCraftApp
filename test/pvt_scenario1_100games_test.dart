import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('PvT 드라군 확장 vs 팩더블 100경기 통계 → pvt.md', () async {
    final homePlayer = Player(
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

    final awayPlayer = Player(
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

    // Phase 2 (mid_contact) 분기 추적 (3개)
    int p2DragoonPush = 0, p2DragoonPushWin = 0;      // A: attack (home>away)
    int p2VultureHarass = 0, p2VultureHarassWin = 0;   // B: harass (away>home)
    int p2ObserverScout = 0, p2ObserverScoutWin = 0;   // C: scout (home>away)
    int p2Unknown = 0;

    // Phase 4 (late_transition) 분기 추적 (2개)
    int p4Arbiter = 0, p4ArbiterWin = 0;               // A: strategy (home>away)
    int p4TankPush = 0, p4TankPushWin = 0;             // B: attack (away>home)
    int p4Unknown = 0;

    // 승리 마진 추적
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
        forcedHomeBuildId: 'pvt_1gate_expand',
        forcedAwayBuildId: 'tvp_double',
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

      // === Phase 2 판별 (mid_contact) ===
      // A: 드라군 압박 - "드라군 편대가 전진" or "사업 완료된 드라군"
      final hasP2A = allText.contains('드라군 편대가 전진') ||
          allText.contains('사업 완료된 드라군') ||
          allText.contains('드라군 화력이 탱크 라인을');
      // B: 벌처 견제 - "벌처가 프로토스 멀티로 돌진" or "프로브가 마인에"
      final hasP2B = allText.contains('벌처가 프로토스 멀티로 돌진') ||
          allText.contains('프로브가 마인에') ||
          allText.contains('벌처 견제가 판을 흔들고');
      // C: 옵저버 정찰 - "옵저버가 전장을 정찰" or "마인 위치가 보입니다"
      final hasP2C = allText.contains('옵저버가 전장을 정찰') ||
          allText.contains('마인 위치가 보입니다') ||
          allText.contains('마인 위치를 완벽히 파악') ||
          allText.contains('마인이 무력화');

      if (hasP2C) {
        p2ObserverScout++;
        if (won) p2ObserverScoutWin++;
      } else if (hasP2A) {
        p2DragoonPush++;
        if (won) p2DragoonPushWin++;
      } else if (hasP2B) {
        p2VultureHarass++;
        if (won) p2VultureHarassWin++;
      } else {
        p2Unknown++;
      }

      // === Phase 4 판별 (late_transition) ===
      // A: 아비터 - "아비터 트리뷰널 건설" or "리콜! 테란 본진" or "아비터 등장"
      final hasP4A = allText.contains('아비터 트리뷰널 건설') ||
          allText.contains('아비터 등장') ||
          allText.contains('리콜! 테란 본진') ||
          allText.contains('리콜 투하') ||
          allText.contains('아비터 리콜이 판을');
      // B: 탱크 푸시 - "시즈 탱크 5기 이상" or "대규모 푸시" or "시즈 모드! 프로토스 앞마당"
      final hasP4B = allText.contains('시즈 탱크 5기 이상') ||
          allText.contains('대규모 푸시') ||
          allText.contains('시즈 모드! 프로토스 앞마당') ||
          allText.contains('탱크 화력이 프로토스 전선을');

      if (hasP4A && !hasP4B) {
        p4Arbiter++;
        if (won) p4ArbiterWin++;
      } else if (hasP4B && !hasP4A) {
        p4TankPush++;
        if (won) p4TankPushWin++;
      } else if (hasP4A && hasP4B) {
        // 둘 다 감지되면 먼저 나온 쪽으로
        final idxA = allText.indexOf('아비터');
        final idxB = allText.indexOf('시즈 탱크 5기');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p4Arbiter++;
          if (won) p4ArbiterWin++;
        } else {
          p4TankPush++;
          if (won) p4TankPushWin++;
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
    final p2Total = p2DragoonPush + p2VultureHarass + p2ObserverScout;
    final p4Total = p4Arbiter + p4TankPush;

    // pvt.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# PvT 드라군 확장 vs 팩더블 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 홍진호 (Protoss) | 빌드: pvt_1gate_expand');
    buffer.writeln('- 어웨이: 이영호 (Terran) | 빌드: tvp_double');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('- 시나리오: pvt_dragoon_expand_vs_factory');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 홍진호 (P) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 이영호 (T) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = P 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = P 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 중반 접촉 (${p2Total}경기 감지 / 미감지 $p2Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | P 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 드라군 압박 | attack (P>T) | $p2DragoonPush | ${pct(p2DragoonPush, p2Total)} | ${winRate(p2DragoonPushWin, p2DragoonPush)} |');
    buffer.writeln('| B. 벌처 견제 | harass (T>P) | $p2VultureHarass | ${pct(p2VultureHarass, p2Total)} | ${winRate(p2VultureHarassWin, p2VultureHarass)} |');
    buffer.writeln('| C. 옵저버 정찰 | scout (P>T) | $p2ObserverScout | ${pct(p2ObserverScout, p2Total)} | ${winRate(p2ObserverScoutWin, p2ObserverScout)} |');
    buffer.writeln('');

    // Phase 4 분기 통계
    buffer.writeln('## Phase 4: 후반 전환 (${p4Total}경기 감지 / 미감지 $p4Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | P 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 아비터 리콜 | strategy (P>T) | $p4Arbiter | ${pct(p4Arbiter, p4Total)} | ${winRate(p4ArbiterWin, p4Arbiter)} |');
    buffer.writeln('| B. 탱크 푸시 | attack (T>P) | $p4TankPush | ${pct(p4TankPush, p4Total)} | ${winRate(p4TankPushWin, p4TankPush)} |');
    buffer.writeln('');

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 홍진호 (P) | 이영호 (T) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| sense | 700 | 690 | **P** | - |');
    buffer.writeln('| control | 710 | 700 | **P** | - |');
    buffer.writeln('| attack | 690 | 710 | **T** | P2-A (P>T이므로 비적격), P4-B |');
    buffer.writeln('| harass | 680 | 700 | **T** | P2-B |');
    buffer.writeln('| strategy | 720 | 680 | **P** | P4-A |');
    buffer.writeln('| macro | 700 | 690 | **P** | - |');
    buffer.writeln('| defense | 690 | 700 | **T** | - |');
    buffer.writeln('| scout | 710 | 680 | **P** | P2-C |');
    buffer.writeln('');

    buffer.writeln('---');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 제100경기 (마지막 경기 전체 로그)');
    buffer.writeln('');

    if (lastState != null) {
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[P]',
          LogOwner.away => '[T]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** P ${lastState.homeArmy} vs T ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** P ${lastState.homeResources} vs T ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '홍진호 (P) 승리' : '이영호 (T) 승리'}**');
    }

    final file = File('pvt.md');
    file.writeAsStringSync(buffer.toString());
    print('pvt.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 홍진호 $homeWins - $awayWins 이영호');
    print('');
    print('=== Phase 2 ($p2Total 감지) ===');
    print('A. 드라군 압박: $p2DragoonPush (P승 $p2DragoonPushWin)');
    print('B. 벌처 견제: $p2VultureHarass (P승 $p2VultureHarassWin)');
    print('C. 옵저버 정찰: $p2ObserverScout (P승 $p2ObserverScoutWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 4 ($p4Total 감지) ===');
    print('A. 아비터 리콜: $p4Arbiter (P승 $p4ArbiterWin)');
    print('B. 탱크 푸시: $p4TankPush (P승 $p4TankPushWin)');
    print('미감지: $p4Unknown');
  });
}
