import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('TvT 배럭더블 vs 팩더블 100경기 통계 → tvt.md', () async {
    final homePlayer = Player(
      id: 'terran_home',
      name: '이영호',
      raceIndex: 0,
      stats: const PlayerStats(
        sense: 700, control: 710, attack: 690, harass: 680,
        strategy: 700, macro: 690, defense: 700, scout: 680,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'terran_away',
      name: '임요환',
      raceIndex: 0,
      stats: const PlayerStats(
        sense: 690, control: 700, attack: 710, harass: 690,
        strategy: 680, macro: 700, defense: 680, scout: 700,
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

    // Phase 2 (vulture_clash) 분기 추적 (2개)
    int p2HomeVultureWin = 0, p2HomeVultureWinWin = 0;   // A: home vulture 우세
    int p2AwayVultureWin = 0, p2AwayVultureWinWin = 0;   // B: away vulture 우세
    int p2Unknown = 0;

    // Phase 4 (drop_transition) 분기 추적 (2개)
    int p4DropSuccess = 0, p4DropSuccessWin = 0;          // A: 드랍 성공
    int p4FrontalBreak = 0, p4FrontalBreakWin = 0;        // B: 정면 돌파
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
        forcedHomeBuildId: 'tvt_cc_first',
        forcedAwayBuildId: 'tvt_2fac_vulture',
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

      // === Phase 2 판별 (vulture_clash) ===
      // home_vulture_win: "벌처 컨트롤이 좋습니다" / "벌처 피해가 큽니다"
      // away_vulture_win: "벌처 속업이 먼저 완료" / "마인 매설로 맵 컨트롤"
      final hasP2A = allText.contains('벌처 컨트롤이 좋습니다') ||
          allText.contains('벌처 컨트롤 차이') ||
          allText.contains('벌처 피해가 큽니다');
      final hasP2B = allText.contains('벌처 속업이 먼저 완료') ||
          allText.contains('벌처 속업 타이밍') ||
          allText.contains('마인 매설로 맵 컨트롤');

      if (hasP2A && !hasP2B) {
        p2HomeVultureWin++;
        if (won) p2HomeVultureWinWin++;
      } else if (hasP2B && !hasP2A) {
        p2AwayVultureWin++;
        if (won) p2AwayVultureWinWin++;
      } else if (hasP2A && hasP2B) {
        // 양쪽 다 감지 → 먼저 나온 쪽으로 분류
        final idxA = allText.indexOf('벌처 컨트롤이 좋습니다');
        final idxB = allText.indexOf('벌처 속업이 먼저 완료');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p2HomeVultureWin++;
          if (won) p2HomeVultureWinWin++;
        } else {
          p2AwayVultureWin++;
          if (won) p2AwayVultureWinWin++;
        }
      } else {
        p2Unknown++;
      }

      // === Phase 4 판별 (drop_transition) ===
      // drop_success: "드랍십 출격" / "멀티가 박살나고" / "멀티포인트 공격"
      // frontal_break: "탱크 라인을 밀어냅니다" / "시즈 포격! 상대 탱크 라인을 뚫습니다" / "탱크 라인이 뚫렸습니다"
      final hasP4A = allText.contains('드랍십 출격') ||
          allText.contains('멀티가 박살나고') ||
          allText.contains('멀티포인트 공격') ||
          allText.contains('탱크 드랍! 상대 멀티');
      final hasP4B = allText.contains('탱크 라인을 밀어냅니다') ||
          allText.contains('상대 탱크 라인을 뚫습니다') ||
          allText.contains('탱크 라인이 뚫렸습니다') ||
          allText.contains('탱크 화력! 상대 라인이 무너집니다');

      if (hasP4A && !hasP4B) {
        p4DropSuccess++;
        if (won) p4DropSuccessWin++;
      } else if (hasP4B && !hasP4A) {
        p4FrontalBreak++;
        if (won) p4FrontalBreakWin++;
      } else if (hasP4A && hasP4B) {
        final idxA = allText.indexOf('드랍십 출격');
        final idxB = allText.indexOf('탱크 라인을 밀어냅니다');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p4DropSuccess++;
          if (won) p4DropSuccessWin++;
        } else {
          p4FrontalBreak++;
          if (won) p4FrontalBreakWin++;
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
    final p2Total = p2HomeVultureWin + p2AwayVultureWin;
    final p4Total = p4DropSuccess + p4FrontalBreak;

    // tvt.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# TvT 배럭더블 vs 팩더블 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 이영호 (Terran) | 빌드: tvt_cc_first');
    buffer.writeln('- 어웨이: 임요환 (Terran) | 빌드: tvt_2fac_vulture');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('- 시나리오: tvt_rax_double_vs_fac_double (배럭 더블 vs 팩토리 더블)');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이영호 (T-H) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 임요환 (T-A) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = 홈 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 벌처 교전 (vulture_clash) (${p2Total}경기 감지 / 미감지 $p2Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | ID | 조건 스탯 | 발동 | 비율 | 홈(이영호) 승률 |');
    buffer.writeln('|------|----|----------|------|------|----------------|');
    buffer.writeln('| A. 홈 벌처 우세 | home_vulture_win | control (H>A) | $p2HomeVultureWin | ${pct(p2HomeVultureWin, p2Total)} | ${winRate(p2HomeVultureWinWin, p2HomeVultureWin)} |');
    buffer.writeln('| B. 어웨이 벌처 우세 | away_vulture_win | control (A>H) | $p2AwayVultureWin | ${pct(p2AwayVultureWin, p2Total)} | ${winRate(p2AwayVultureWinWin, p2AwayVultureWin)} |');
    buffer.writeln('');

    // Phase 4 분기 통계
    buffer.writeln('## Phase 4: 드랍/전환 (drop_transition) (${p4Total}경기 감지 / 미감지 $p4Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | ID | 조건 스탯 | 발동 | 비율 | 홈(이영호) 승률 |');
    buffer.writeln('|------|----|----------|------|------|----------------|');
    buffer.writeln('| A. 드랍 성공 | drop_success | strategy (H>A) | $p4DropSuccess | ${pct(p4DropSuccess, p4Total)} | ${winRate(p4DropSuccessWin, p4DropSuccess)} |');
    buffer.writeln('| B. 정면 돌파 | frontal_break | attack (A>H) | $p4FrontalBreak | ${pct(p4FrontalBreak, p4Total)} | ${winRate(p4FrontalBreakWin, p4FrontalBreak)} |');
    buffer.writeln('');

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 이영호 (H) | 임요환 (A) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| sense | 700 | 690 | **H** | - |');
    buffer.writeln('| control | 710 | 700 | **H** | P2 (H>A → 홈벌처 우세) |');
    buffer.writeln('| attack | 690 | 710 | **A** | P4-B (A>H → 정면 돌파) |');
    buffer.writeln('| harass | 680 | 690 | **A** | - |');
    buffer.writeln('| strategy | 700 | 680 | **H** | P4-A (H>A → 드랍 성공) |');
    buffer.writeln('| macro | 690 | 700 | **A** | - |');
    buffer.writeln('| defense | 700 | 680 | **H** | - |');
    buffer.writeln('| scout | 680 | 700 | **A** | - |');
    buffer.writeln('');

    buffer.writeln('---');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 제100경기 (마지막 경기 전체 로그)');
    buffer.writeln('');

    if (lastState != null) {
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T-H]',
          LogOwner.away => '[T-A]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** H ${lastState.homeArmy} vs A ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** H ${lastState.homeResources} vs A ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '이영호 (T-H) 승리' : '임요환 (T-A) 승리'}**');
    }

    final file = File('tvt.md');
    file.writeAsStringSync(buffer.toString());
    print('tvt.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 이영호 $homeWins - $awayWins 임요환');
    print('');
    print('=== Phase 2: 벌처 교전 ($p2Total 감지) ===');
    print('A. 홈 벌처 우세: $p2HomeVultureWin (홈승 $p2HomeVultureWinWin)');
    print('B. 어웨이 벌처 우세: $p2AwayVultureWin (홈승 $p2AwayVultureWinWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 4: 드랍/전환 ($p4Total 감지) ===');
    print('A. 드랍 성공: $p4DropSuccess (홈승 $p4DropSuccessWin)');
    print('B. 정면 돌파: $p4FrontalBreak (홈승 $p4FrontalBreakWin)');
    print('미감지: $p4Unknown');
  });
}
