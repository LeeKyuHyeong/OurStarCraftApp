import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('바이오 vs 뮤탈 100경기 통계 → tvz.md', () async {
    final homePlayer = Player(
      id: 'terran_test',
      name: '이영호',
      raceIndex: 0,
      stats: const PlayerStats(
        sense: 680, control: 700, attack: 720, harass: 690,
        strategy: 670, macro: 690, defense: 680, scout: 650,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'zerg_test',
      name: '이제동',
      raceIndex: 1,
      stats: const PlayerStats(
        sense: 690, control: 710, attack: 670, harass: 730,
        strategy: 660, macro: 700, defense: 650, scout: 670,
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

    // Phase 2 분기 추적 (4개)
    int p2TerranPush = 0, p2TerranPushWin = 0;     // A: attack
    int p2ZergMutal = 0, p2ZergMutalWin = 0;       // B: control
    int p2LingAmbush = 0, p2LingAmbushWin = 0;     // C: defense
    int p2ScoutSpire = 0, p2ScoutSpireWin = 0;      // D: scout
    int p2Unknown = 0;

    // Phase 4 분기 추적 (3개)
    int p4TerranTiming = 0, p4TerranTimingWin = 0;  // A: attack
    int p4ZergMacro = 0, p4ZergMacroWin = 0;        // B: macro
    int p4DropRaid = 0, p4DropRaidWin = 0;           // C: strategy
    int p4Unknown = 0;

    // Phase 5 분기 추적 (3개)
    int p5StandardClash = 0, p5StandardClashWin = 0; // A: always
    int p5Defiler = 0, p5DefilerWin = 0;             // B: strategy
    int p5LastDrop = 0, p5LastDropWin = 0;           // C: sense
    int p5Unknown = 0;

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
        forcedHomeBuildId: 'tvz_sk',
        forcedAwayBuildId: 'zvt_2hatch_mutal',
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

      // === Phase 2 판별 ===
      final hasP2A = allText.contains('앞마당으로 전진') ||
          allText.contains('스팀팩 밟고 앞마당');
      final hasP2B = allText.contains('뮤탈리스크 등장') ||
          allText.contains('뮤탈이 떴습니다');
      final hasP2C = allText.contains('저글링이 튀어나옵니다') ||
          allText.contains('저글링 서라운드에 걸렸습니다');
      final hasP2D = allText.contains('스파이어를 발견') ||
          allText.contains('터렛을 미리 건설');

      if (hasP2C) {
        p2LingAmbush++;
        if (won) p2LingAmbushWin++;
      } else if (hasP2D) {
        p2ScoutSpire++;
        if (won) p2ScoutSpireWin++;
      } else if (hasP2A && !hasP2B) {
        p2TerranPush++;
        if (won) p2TerranPushWin++;
      } else if (hasP2B) {
        p2ZergMutal++;
        if (won) p2ZergMutalWin++;
      } else {
        p2Unknown++;
      }

      // === Phase 4 판별 ===
      final hasP4A = allText.contains('사이언스 베슬 합류') ||
          allText.contains('이레디에이트') || allText.contains('이레디!');
      final hasP4B = allText.contains('3번째 해처리') ||
          allText.contains('럴커 변태') || allText.contains('럴커 포진');
      final hasP4C = allText.contains('드랍십에 마린 메딕을 태웁니다') ||
          allText.contains('드랍! 저그 세 번째 해처리');

      if (hasP4C) {
        p4DropRaid++;
        if (won) p4DropRaidWin++;
      } else if (hasP4A && !hasP4B) {
        p4TerranTiming++;
        if (won) p4TerranTimingWin++;
      } else if (hasP4B && !hasP4A) {
        p4ZergMacro++;
        if (won) p4ZergMacroWin++;
      } else if (hasP4A && hasP4B) {
        final idxA = allText.indexOf('사이언스 베슬');
        final idxB = allText.indexOf('3번째 해처리');
        if (idxA >= 0 && (idxB < 0 || idxA < idxB)) {
          p4TerranTiming++;
          if (won) p4TerranTimingWin++;
        } else {
          p4ZergMacro++;
          if (won) p4ZergMacroWin++;
        }
      } else {
        p4Unknown++;
      }

      // === Phase 5 판별 ===
      final hasP5B = allText.contains('디파일러가 전선에 합류') ||
          allText.contains('다크스웜!');
      final hasP5C = allText.contains('최후의 승부수') ||
          allText.contains('드랍 올인');

      if (hasP5B) {
        p5Defiler++;
        if (won) p5DefilerWin++;
      } else if (hasP5C) {
        p5LastDrop++;
        if (won) p5LastDropWin++;
      } else {
        p5StandardClash++;
        if (won) p5StandardClashWin++;
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
    final p2Total = p2TerranPush + p2ZergMutal + p2LingAmbush + p2ScoutSpire;
    final p4Total = p4TerranTiming + p4ZergMacro + p4DropRaid;
    final p5Total = p5StandardClash + p5Defiler + p5LastDrop;

    // tvz.md 작성
    final buffer = StringBuffer();
    buffer.writeln('# TvZ 바이오 vs 뮤탈 - 100경기 통계');
    buffer.writeln('');
    buffer.writeln('- 홈: 이영호 (Terran) | 빌드: tvz_sk');
    buffer.writeln('- 어웨이: 이제동 (Zerg) | 빌드: zvt_2hatch_mutal');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');

    // 종합 전적
    buffer.writeln('## 종합 전적 (${total}경기)');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 | 승률 |');
    buffer.writeln('|------|----|----|------|');
    buffer.writeln('| 이영호 (T) | $homeWins | $awayWins | ${homeWins}% |');
    buffer.writeln('| 이제동 (Z) | $awayWins | $homeWins | ${awayWins}% |');
    buffer.writeln('');
    buffer.writeln('- 평균 병력 차이: ${avgArmyMargin.toStringAsFixed(1)} (양수 = T 유리)');
    buffer.writeln('- 평균 자원 차이: ${avgResourceMargin.toStringAsFixed(1)} (양수 = T 유리)');
    buffer.writeln('');

    // Phase 2 분기 통계
    buffer.writeln('## Phase 2: 초반 접촉 (${p2Total}경기 감지 / 미감지 $p2Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | T 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 마린메딕 앞마당 압박 | attack (T>Z) | $p2TerranPush | ${pct(p2TerranPush, p2Total)} | ${winRate(p2TerranPushWin, p2TerranPush)} |');
    buffer.writeln('| B. 뮤탈 빠른 등장 | control (Z>T) | $p2ZergMutal | ${pct(p2ZergMutal, p2Total)} | ${winRate(p2ZergMutalWin, p2ZergMutal)} |');
    buffer.writeln('| C. 저글링 기습 | defense (Z>T) | $p2LingAmbush | ${pct(p2LingAmbush, p2Total)} | ${winRate(p2LingAmbushWin, p2LingAmbush)} |');
    buffer.writeln('| D. SCV 정찰 스파이어 | scout (T>Z) | $p2ScoutSpire | ${pct(p2ScoutSpire, p2Total)} | ${winRate(p2ScoutSpireWin, p2ScoutSpire)} |');
    buffer.writeln('');

    // Phase 4 분기 통계
    buffer.writeln('## Phase 4: 전환기 (${p4Total}경기 감지 / 미감지 $p4Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | T 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 이레디 타이밍 푸시 | attack (T>Z) | $p4TerranTiming | ${pct(p4TerranTiming, p4Total)} | ${winRate(p4TerranTimingWin, p4TerranTiming)} |');
    buffer.writeln('| B. 매크로 럴커 전환 | macro (Z>T) | $p4ZergMacro | ${pct(p4ZergMacro, p4Total)} | ${winRate(p4ZergMacroWin, p4ZergMacro)} |');
    buffer.writeln('| C. 드랍십 멀티 견제 | strategy (T>Z) | $p4DropRaid | ${pct(p4DropRaid, p4Total)} | ${winRate(p4DropRaidWin, p4DropRaid)} |');
    buffer.writeln('');

    // Phase 5 분기 통계
    buffer.writeln('## Phase 5: 결전 (${p5Total}경기 감지 / 미감지 $p5Unknown)');
    buffer.writeln('');
    buffer.writeln('| 분기 | 조건 스탯 | 발동 | 비율 | T 승률 |');
    buffer.writeln('|------|----------|------|------|--------|');
    buffer.writeln('| A. 정면 대결 | - (항상) | $p5StandardClash | ${pct(p5StandardClash, p5Total)} | ${winRate(p5StandardClashWin, p5StandardClash)} |');
    buffer.writeln('| B. 디파일러 다크스웜 | strategy (Z>T) | $p5Defiler | ${pct(p5Defiler, p5Total)} | ${winRate(p5DefilerWin, p5Defiler)} |');
    buffer.writeln('| C. 최후의 드랍 올인 | sense (T>Z) | $p5LastDrop | ${pct(p5LastDrop, p5Total)} | ${winRate(p5LastDropWin, p5LastDrop)} |');
    buffer.writeln('');

    // 능력치 비교 참고
    buffer.writeln('## 능력치 비교 (분기 선택 기준)');
    buffer.writeln('');
    buffer.writeln('| 스탯 | 이영호 (T) | 이제동 (Z) | 높은 쪽 | 관련 분기 |');
    buffer.writeln('|------|-----------|-----------|---------|----------|');
    buffer.writeln('| attack | 720 | 670 | **T** | P2-A, P4-A |');
    buffer.writeln('| control | 700 | 710 | **Z** | P2-B |');
    buffer.writeln('| defense | 680 | 650 | **T** | P2-C (Z>T이므로 비적격) |');
    buffer.writeln('| scout | 650 | 670 | **Z** | P2-D (T>Z이므로 비적격) |');
    buffer.writeln('| macro | 690 | 700 | **Z** | P4-B |');
    buffer.writeln('| strategy | 670 | 660 | **T** | P4-C, P5-B (Z>T이므로 비적격) |');
    buffer.writeln('| sense | 680 | 690 | **Z** | P5-C (T>Z이므로 비적격) |');
    buffer.writeln('');

    buffer.writeln('---');
    buffer.writeln('');

    // 마지막 경기 로그
    buffer.writeln('## 제100경기 (마지막 경기 전체 로그)');
    buffer.writeln('');

    if (lastState != null) {
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]',
          LogOwner.away => '[Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** T ${lastState.homeArmy} vs Z ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** T ${lastState.homeResources} vs Z ${lastState.awayResources}  ');
      final won = lastState.homeWin == true;
      buffer.writeln('> **결과: ${won ? '이영호 (T) 승리' : '이제동 (Z) 승리'}**');
    }

    final file = File('tvz.md');
    file.writeAsStringSync(buffer.toString());
    print('tvz.md 저장 완료 (${buffer.length} chars)');
    print('');
    print('=== 종합 ===');
    print('전적: 이영호 $homeWins - $awayWins 이제동');
    print('');
    print('=== Phase 2 ($p2Total 감지) ===');
    print('A. 마린메딕 압박: $p2TerranPush (T승 $p2TerranPushWin)');
    print('B. 뮤탈 등장: $p2ZergMutal (T승 $p2ZergMutalWin)');
    print('C. 저글링 기습: $p2LingAmbush (T승 $p2LingAmbushWin)');
    print('D. SCV 정찰: $p2ScoutSpire (T승 $p2ScoutSpireWin)');
    print('미감지: $p2Unknown');
    print('');
    print('=== Phase 4 ($p4Total 감지) ===');
    print('A. 이레디 타이밍: $p4TerranTiming (T승 $p4TerranTimingWin)');
    print('B. 매크로 럴커: $p4ZergMacro (T승 $p4ZergMacroWin)');
    print('C. 드랍십 견제: $p4DropRaid (T승 $p4DropRaidWin)');
    print('미감지: $p4Unknown');
    print('');
    print('=== Phase 5 ($p5Total 감지) ===');
    print('A. 정면 대결: $p5StandardClash (T승 $p5StandardClashWin)');
    print('B. 디파일러: $p5Defiler (T승 $p5DefilerWin)');
    print('C. 최후 드랍: $p5LastDrop (T승 $p5LastDropWin)');
    print('미감지: $p5Unknown');
  });
}
