import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('PvP 드라군 넥서스 미러 100경기 통계 → pvp.md', () async {
    final homePlayer = Player(
      id: 'protoss_home',
      name: '김택용',
      raceIndex: 2,
      stats: const PlayerStats(
        sense: 700, control: 710, attack: 690, harass: 720,
        strategy: 700, macro: 680, defense: 690, scout: 680,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'protoss_away',
      name: '홍진호',
      raceIndex: 2,
      stats: const PlayerStats(
        sense: 690, control: 700, attack: 700, harass: 680,
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

    // Phase 2 (tech_choice) 분기 추적 (2개)
    int p2RoboVsDark = 0, p2RoboVsDarkWin = 0;     // A: home_robo_away_dark (strategy, home>)
    int p2DoubleRobo = 0, p2DoubleRoboWin = 0;       // B: double_robo (macro, home>)
    int p2Unknown = 0;

    // Phase 3 (shuttle_reaver_battle) 분기 추적 (2개)
    int p3ReaverSuccess = 0, p3ReaverSuccessWin = 0;   // A: reaver_success (harass, home>)
    int p3ShuttleShot = 0, p3ShuttleShotWin = 0;       // B: shuttle_shot_down (defense, away>)
    int p3Unknown = 0;

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
        forcedHomeBuildId: 'pvp_2gate_dragoon',
        forcedAwayBuildId: 'pvp_2gate_dragoon',
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

      // === Phase 2 판별 (tech_choice) ===
      // Branch A (home_robo_away_dark): "시타델 오브 아둔" or "다크 템플러가 잠입"
      // Branch B (double_robo): "셔틀 리버 경쟁" or "양측 셔틀 리버가 교차"
      final hasP2A = allText.contains('시타델 오브 아둔') ||
          allText.contains('다크 템플러가 잠입');
      final hasP2B = allText.contains('셔틀 리버 경쟁') ||
          allText.contains('양측 셔틀 리버가 교차');

      if (hasP2A && !hasP2B) {
        p2RoboVsDark++;
        if (won) p2RoboVsDarkWin++;
      } else if (hasP2B && !hasP2A) {
        p2DoubleRobo++;
        if (won) p2DoubleRoboWin++;
      } else if (hasP2A && hasP2B) {
        // Both detected - use first occurrence
        final idxA = allText.indexOf('시타델 오브 아둔');
        final idxB = allText.indexOf('셔틀 리버 경쟁');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p2RoboVsDark++;
          if (won) p2RoboVsDarkWin++;
        } else {
          p2DoubleRobo++;
          if (won) p2DoubleRoboWin++;
        }
      } else {
        p2Unknown++;
      }

      // === Phase 3 판별 (shuttle_reaver_battle) ===
      // Branch A (reaver_success): "프로브 라인에 리버를 내립니다" or "리버 견제가 성공"
      // Branch B (shuttle_shot_down): "셔틀을 집중 사격" or "셔틀이 떨어집니다" or "셔틀 격추"
      final hasP3A = allText.contains('프로브 라인에 리버를 내립니다') ||
          allText.contains('리버 견제가 성공') ||
          allText.contains('리버 투하');
      final hasP3B = allText.contains('셔틀을 집중 사격') ||
          allText.contains('셔틀이 떨어집니다') ||
          allText.contains('셔틀 격추') ||
          allText.contains('셔틀 폭사');

      if (hasP3A && !hasP3B) {
        p3ReaverSuccess++;
        if (won) p3ReaverSuccessWin++;
      } else if (hasP3B && !hasP3A) {
        p3ShuttleShot++;
        if (won) p3ShuttleShotWin++;
      } else if (hasP3A && hasP3B) {
        final idxA = allText.indexOf('프로브 라인에 리버를 내립니다');
        final idxAalt = allText.indexOf('리버 투하');
        final idxAmin = (idxA >= 0 && idxAalt >= 0)
            ? (idxA < idxAalt ? idxA : idxAalt)
            : (idxA >= 0 ? idxA : idxAalt);
        final idxB = allText.indexOf('셔틀을 집중 사격');
        final idxBalt = allText.indexOf('셔틀 격추');
        final idxBmin = (idxB >= 0 && idxBalt >= 0)
            ? (idxB < idxBalt ? idxB : idxBalt)
            : (idxB >= 0 ? idxB : idxBalt);
        if (idxAmin >= 0 && (idxBmin < 0 || idxAmin < idxBmin)) {
          p3ReaverSuccess++;
          if (won) p3ReaverSuccessWin++;
        } else {
          p3ShuttleShot++;
          if (won) p3ShuttleShotWin++;
        }
      } else {
        p3Unknown++;
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
    final p2Total = p2RoboVsDark + p2DoubleRobo;
    final p3Total = p3ReaverSuccess + p3ShuttleShot;

    // pvp.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# PvP 드라군 넥서스 미러 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 김택용 (Protoss) | 빌드: pvp_2gate_dragoon');
    buffer.writeln('- 어웨이: 홍진호 (Protoss) | 빌드: pvp_2gate_dragoon');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('- 시나리오: pvp_dragoon_nexus_mirror (원겟 드라군 넥서스 미러)');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 김택용 (P-H) | $homeWins | $awayWins | ${winRate(homeWins, total)} |');
    buffer.writeln('| 홍진호 (P-A) | $awayWins | $homeWins | ${winRate(awayWins, total)} |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = Home 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = Home 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 테크 분기 (${p2Total}경기 감지 / 미감지 $p2Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | ID | 조건 스탯 | 발동 | 비율 | Home 승률 |');
    buffer.writeln('|------|----|----------|------|------|-----------|');
    buffer.writeln('| A. 로보 vs 다크 | home_robo_away_dark | strategy (H>) | $p2RoboVsDark | ${pct(p2RoboVsDark, p2Total)} | ${winRate(p2RoboVsDarkWin, p2RoboVsDark)} |');
    buffer.writeln('| B. 양쪽 로보 | double_robo | macro (H>) | $p2DoubleRobo | ${pct(p2DoubleRobo, p2Total)} | ${winRate(p2DoubleRoboWin, p2DoubleRobo)} |');
    buffer.writeln('');

    // Phase 3 분기 통계
    buffer.writeln('## Phase 3: 셔틀 리버 교전 (${p3Total}경기 감지 / 미감지 $p3Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | ID | 조건 스탯 | 발동 | 비율 | Home 승률 |');
    buffer.writeln('|------|----|----------|------|------|-----------|');
    buffer.writeln('| A. 리버 견제 성공 | reaver_success | harass (H>) | $p3ReaverSuccess | ${pct(p3ReaverSuccess, p3Total)} | ${winRate(p3ReaverSuccessWin, p3ReaverSuccess)} |');
    buffer.writeln('| B. 셔틀 격추 | shuttle_shot_down | defense (A>) | $p3ShuttleShot | ${pct(p3ShuttleShot, p3Total)} | ${winRate(p3ShuttleShotWin, p3ShuttleShot)} |');
    buffer.writeln('');

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 김택용 (H) | 홍진호 (A) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| sense | 700 | 690 | **H** | - |');
    buffer.writeln('| control | 710 | 700 | **H** | - |');
    buffer.writeln('| attack | 690 | 700 | **A** | - |');
    buffer.writeln('| harass | 720 | 680 | **H** | P3-A (H>) |');
    buffer.writeln('| strategy | 700 | 690 | **H** | P2-A (H>) |');
    buffer.writeln('| macro | 680 | 710 | **A** | P2-B (H>) → A 불리 |');
    buffer.writeln('| defense | 690 | 700 | **A** | P3-B (A>) |');
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
          LogOwner.home => '[P-H]',
          LogOwner.away => '[P-A]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** H ${lastState.homeArmy} vs A ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** H ${lastState.homeResources} vs A ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '김택용 (P-H) 승리' : '홍진호 (P-A) 승리'}**');
    }

    final file = File('pvp.md');
    file.writeAsStringSync(buffer.toString());
    print('pvp.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 김택용 $homeWins - $awayWins 홍진호');
    print('');
    print('=== Phase 2: 테크 분기 ($p2Total 감지) ===');
    print('A. 로보 vs 다크: $p2RoboVsDark (H승 $p2RoboVsDarkWin)');
    print('B. 양쪽 로보: $p2DoubleRobo (H승 $p2DoubleRoboWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 3: 셔틀 리버 ($p3Total 감지) ===');
    print('A. 리버 성공: $p3ReaverSuccess (H승 $p3ReaverSuccessWin)');
    print('B. 셔틀 격추: $p3ShuttleShot (H승 $p3ShuttleShotWin)');
    print('미감지: $p3Unknown');
  });
}
