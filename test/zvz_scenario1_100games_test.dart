import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('ZvZ 9풀 vs 9오버풀 100경기 통계 → zvz.md', () async {
    final homePlayer = Player(
      id: 'zerg_home',
      name: '이제동',
      raceIndex: 1,
      stats: const PlayerStats(
        sense: 700, control: 710, attack: 690, harass: 720,
        strategy: 680, macro: 700, defense: 690, scout: 680,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'zerg_away',
      name: '박성준',
      raceIndex: 1,
      stats: const PlayerStats(
        sense: 690, control: 700, attack: 680, harass: 700,
        strategy: 690, macro: 710, defense: 700, scout: 690,
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

    // Phase 2 (ling_result) 분기 추적 (2개)
    int p2AttackerBreaks = 0, p2AttackerBreaksWin = 0;   // A: 9풀 공격 성공
    int p2DefenderHolds = 0, p2DefenderHoldsWin = 0;     // B: 9오버풀 수비 성공
    int p2Unknown = 0;

    // Phase 4 (mutal_battle) 분기 추적 (2개)
    int p4FastMutal = 0, p4FastMutalWin = 0;             // A: 뮤탈 선점 드론 견제
    int p4ScourgeDefense = 0, p4ScourgeDefenseWin = 0;   // B: 스커지 대응
    int p4Unknown = 0;
    int p4EndedEarly = 0; // Phase 2에서 decisive로 경기 종료 (Phase 4 미도달)

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
        forcedHomeBuildId: 'zvz_9pool',
        forcedAwayBuildId: 'zvz_9overpool',
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

      // === Phase 2 (ling_result) 판별 ===
      // Branch A (attacker_breaks_through): text + altText 모두 감지
      //   - text: '입구를 뚫었습니다' / altText: '저글링 돌파'
      //   - text: '드론 피해가 큽니다' (no altText)
      //   - text: '추가 저글링 합류' (no altText)
      //   - text: '9풀 공격이 성공' (system, skipChance=0.3)
      // Branch B (defender_holds): text + altText 모두 감지
      //   - text: '언덕에서 저글링을 효과적으로' / altText: '저글링 컨트롤'
      //   - text: '뚫지 못 했습니다' (no altText)
      //   - text: '드론 한 기 차이가 벌어지기' / altText: '드론 한 기 차이'
      //   - text: '9오버풀의 드론 이점' (system, skipChance=0.3)
      final hasP2A = allText.contains('입구를 뚫었습니다') ||
          allText.contains('저글링 돌파') ||
          allText.contains('드론을 물어뜯') ||
          allText.contains('드론 피해가 큽니다') ||
          allText.contains('추가 저글링 합류') ||
          allText.contains('상대 드론을 초토화') ||
          allText.contains('9풀 공격이 성공');
      final hasP2B = allText.contains('언덕에서 저글링을 효과적으로') ||
          allText.contains('저글링 컨트롤') ||
          allText.contains('좁은 입구에서 잘 막습니다') ||
          allText.contains('뚫지 못 했습니다') ||
          allText.contains('드론 한 기 차이') ||
          allText.contains('9오버풀의 드론 이점');

      bool isP2A = false;
      if (hasP2A && !hasP2B) {
        p2AttackerBreaks++;
        if (won) p2AttackerBreaksWin++;
        isP2A = true;
      } else if (hasP2B && !hasP2A) {
        p2DefenderHolds++;
        if (won) p2DefenderHoldsWin++;
      } else if (hasP2A && hasP2B) {
        // 둘 다 감지된 경우: Branch A 핵심 키워드 중 가장 빠른 위치
        final aIndices = <int>[
          allText.indexOf('입구를 뚫었습니다'),
          allText.indexOf('저글링 돌파'),
          allText.indexOf('드론 피해가 큽니다'),
        ].where((i) => i >= 0);
        final bIndices = <int>[
          allText.indexOf('언덕에서 저글링을 효과적으로'),
          allText.indexOf('저글링 컨트롤'),
          allText.indexOf('뚫지 못 했습니다'),
        ].where((i) => i >= 0);
        final firstA = aIndices.isNotEmpty ? aIndices.reduce((a, b) => a < b ? a : b) : 999999;
        final firstB = bIndices.isNotEmpty ? bIndices.reduce((a, b) => a < b ? a : b) : 999999;
        if (firstA <= firstB) {
          p2AttackerBreaks++;
          if (won) p2AttackerBreaksWin++;
          isP2A = true;
        } else {
          p2DefenderHolds++;
          if (won) p2DefenderHoldsWin++;
        }
      } else {
        p2Unknown++;
      }

      // === Phase 4 (mutal_battle) 판별 ===
      // Phase 2 Branch A has decisive: true → 경기가 Phase 4에 도달하지 못할 수 있음
      // Phase 3 (spire_race) 텍스트 존재 여부로 Phase 4 도달 판단
      final reachedPhase3 = allText.contains('스파이어') || allText.contains('성큰 콜로니');

      if (!reachedPhase3) {
        // Phase 2에서 경기 종료 (decisive) → Phase 4 미도달
        p4EndedEarly++;
      } else {
        // Phase 4에 도달한 경기에서 분기 판별
        // Branch A (fast_mutal_harass): text + altText 모두 감지
        //   - text: '뮤탈리스크가 먼저 나왔습니다' / altText: '뮤탈 선점! 드론을 물어뜯'
        //   - text: '스포어 건설' / altText: '스포어 올립니다'
        //   - text: '스포어를 피하면서' / altText: '스포어를 회피하면서'
        //   - text: '뮤탈 선점이 빛나고' (system, skipChance=0.2)
        // Branch B (scourge_defense): text + altText 모두 감지
        //   - text: '스커지를 뽑으면서' / altText: '스커지 생산'
        //   - text: '스커지 자폭! 뮤탈 2기를 잡아냅니다' / altText: '스커지가 뮤탈에 돌진'
        //   - text: '뮤탈을 잃었습니다! 스커지가 효과적' / altText: '뮤탈 손실! 스커지에 당했'
        //   - text: '스커지 대응이 빛났습니다' (system, skipChance=0.2)
        final hasP4A = allText.contains('뮤탈리스크가 먼저 나왔습니다') ||
            allText.contains('뮤탈 선점') ||
            allText.contains('스포어를 피하면서') ||
            allText.contains('스포어를 회피하면서');
        final hasP4B = allText.contains('스커지를 뽑으면서') ||
            allText.contains('스커지 생산') ||
            allText.contains('스커지 자폭! 뮤탈 2기를 잡아냅니다') ||
            allText.contains('스커지가 뮤탈에 돌진') ||
            allText.contains('뮤탈을 잃었습니다') ||
            allText.contains('뮤탈 손실') ||
            allText.contains('스커지에 당했') ||
            allText.contains('스커지 대응이 빛났습니다');

        if (hasP4A && !hasP4B) {
          p4FastMutal++;
          if (won) p4FastMutalWin++;
        } else if (hasP4B && !hasP4A) {
          p4ScourgeDefense++;
          if (won) p4ScourgeDefenseWin++;
        } else if (hasP4A && hasP4B) {
          final aIndices = <int>[
            allText.indexOf('뮤탈리스크가 먼저 나왔습니다'),
            allText.indexOf('스포어를 피하면서'),
            allText.indexOf('스포어를 회피하면서'),
          ].where((i) => i >= 0);
          final bIndices = <int>[
            allText.indexOf('스커지를 뽑으면서'),
            allText.indexOf('스커지 생산'),
            allText.indexOf('뮤탈을 잃었습니다'),
          ].where((i) => i >= 0);
          final firstA = aIndices.isNotEmpty ? aIndices.reduce((a, b) => a < b ? a : b) : 999999;
          final firstB = bIndices.isNotEmpty ? bIndices.reduce((a, b) => a < b ? a : b) : 999999;
          if (firstA <= firstB) {
            p4FastMutal++;
            if (won) p4FastMutalWin++;
          } else {
            p4ScourgeDefense++;
            if (won) p4ScourgeDefenseWin++;
          }
        } else {
          p4Unknown++;
        }
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
    final p2Total = p2AttackerBreaks + p2DefenderHolds;
    final p4Reached = p4FastMutal + p4ScourgeDefense + p4Unknown;
    final p4Total = p4FastMutal + p4ScourgeDefense;

    // 감지율 계산
    final p2DetectionRate = p2Total > 0 ? (p2Total / (p2Total + p2Unknown) * 100).toStringAsFixed(1) : '-';
    final p4DetectionRate = p4Reached > 0 ? (p4Total / p4Reached * 100).toStringAsFixed(1) : '-';

    // zvz.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# ZvZ 9풀 vs 9오버풀 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 이제동 (Zerg) | 빌드: zvz_9pool');
    buffer.writeln('- 어웨이: 박성준 (Zerg) | 빌드: zvz_9overpool');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이제동 (Z-H) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 박성준 (Z-A) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 저글링 교전 결과 (감지율 $p2DetectionRate% | ${p2Total}/${p2Total + p2Unknown} 감지)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|----------|------|------|---------|');
    buffer.writeln('| A. 9풀 공격 성공 (attacker_breaks_through) | attack (H>A) | $p2AttackerBreaks | ${pct(p2AttackerBreaks, p2Total)} | ${winRate(p2AttackerBreaksWin, p2AttackerBreaks)} |');
    buffer.writeln('| B. 9오버풀 수비 성공 (defender_holds) | defense (A>H) | $p2DefenderHolds | ${pct(p2DefenderHolds, p2Total)} | ${winRate(p2DefenderHoldsWin, p2DefenderHolds)} |');
    buffer.writeln('');
    if (p2Unknown > 0) {
      buffer.writeln('> **경고**: Phase 2 미감지 ${p2Unknown}경기');
      buffer.writeln('');
    }

    // Phase 4 분기 통계
    buffer.writeln('## Phase 4: 뮤탈 교전 (감지율 $p4DetectionRate% | ${p4Total}/${p4Reached} 감지, $p4EndedEarly경기 조기종료)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | 홈 승률 |');
    buffer.writeln('|------|----------|------|------|---------|');
    buffer.writeln('| A. 뮤탈 선점 드론 견제 (fast_mutal_harass) | harass (H>A) | $p4FastMutal | ${pct(p4FastMutal, p4Total)} | ${winRate(p4FastMutalWin, p4FastMutal)} |');
    buffer.writeln('| B. 스커지 대응 (scourge_defense) | defense (A>H) | $p4ScourgeDefense | ${pct(p4ScourgeDefense, p4Total)} | ${winRate(p4ScourgeDefenseWin, p4ScourgeDefense)} |');
    buffer.writeln('');
    if (p4EndedEarly > 0) {
      buffer.writeln('> Phase 2에서 decisive로 조기 종료된 $p4EndedEarly경기는 Phase 4 미도달');
      buffer.writeln('');
    }
    if (p4Unknown > 0) {
      buffer.writeln('> **경고**: Phase 4 도달했지만 미감지 ${p4Unknown}경기');
      buffer.writeln('');
    }

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 이제동 (H) | 박성준 (A) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| sense | 700 | 690 | **H** | - |');
    buffer.writeln('| control | 710 | 700 | **H** | - |');
    buffer.writeln('| attack | 690 | 680 | **H** | P2-A (H>A) |');
    buffer.writeln('| harass | 720 | 700 | **H** | P4-A (H>A) |');
    buffer.writeln('| strategy | 680 | 690 | **A** | - |');
    buffer.writeln('| macro | 700 | 710 | **A** | - |');
    buffer.writeln('| defense | 690 | 700 | **A** | P2-B (A>H), P4-B (A>H) |');
    buffer.writeln('| scout | 680 | 690 | **A** | - |');
    buffer.writeln('');

    buffer.writeln('---');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 제100경기 (마지막 경기 전체 로그)');
    buffer.writeln('');

    if (lastState != null) {
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[Z-H]',
          LogOwner.away => '[Z-A]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** H ${lastState.homeArmy} vs A ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** H ${lastState.homeResources} vs A ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '이제동 (홈) 승리' : '박성준 (어웨이) 승리'}**');
    }

    final file = File('zvz.md');
    file.writeAsStringSync(buffer.toString());
    print('zvz.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 이제동 $homeWins - $awayWins 박성준');
    print('');
    print('=== Phase 2: 저글링 교전 결과 (감지율 $p2DetectionRate%) ===');
    print('A. 9풀 공격 성공: $p2AttackerBreaks (홈승 $p2AttackerBreaksWin)');
    print('B. 9오버풀 수비 성공: $p2DefenderHolds (홈승 $p2DefenderHoldsWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 4: 뮤탈 교전 (감지율 $p4DetectionRate% | 도달 $p4Reached, 조기종료 $p4EndedEarly) ===');
    print('A. 뮤탈 선점: $p4FastMutal (홈승 $p4FastMutalWin)');
    print('B. 스커지 대응: $p4ScourgeDefense (홈승 $p4ScourgeDefenseWin)');
    print('미감지(도달했지만): $p4Unknown');
  });
}
