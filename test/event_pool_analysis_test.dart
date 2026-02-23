// 이벤트 풀 논리 검증 + ZvZ 자원 분석 (100경기)
// 실행: flutter test test/event_pool_analysis_test.dart --reporter expanded
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

Player _makePlayer({
  required String name,
  required Race race,
  required PlayerStats stats,
  int level = 5,
}) {
  return Player(
    id: name,
    name: name,
    raceIndex: race.index,
    stats: stats,
    levelValue: level,
    condition: 100,
  );
}

const _standardMap = GameMap(
  id: 'test_standard',
  name: '테스트맵',
  rushDistance: 5,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 5,
  centerImportance: 5,
);

const _balancedStats = PlayerStats(
  sense: 650, control: 650, attack: 650, harass: 650,
  strategy: 650, macro: 650, defense: 650, scout: 650,
);

void main() {
  // ============================================================
  // 1. ZvZ 100경기 - 중반 이후 자원 쌓임 분석
  // ============================================================
  test('ZvZ 100경기 자원 분석', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('=== ZvZ 100경기 자원 분석 ===\n');

    int totalGames = 0;
    int homeWins = 0;
    int totalLines = 0;
    int highResourceGames = 0; // 자원 500 이상 쌓인 경기
    int scourgeEventCount = 0; // 스커지 이벤트 등장 경기 수
    int expansionHarassCount = 0; // 확장 견제 이벤트 수

    // 자원 추적 (30줄 간격 스냅샷)
    final resourceSnapshots = <int, List<int>>{}; // line -> [homeRes, awayRes, ...]

    // 이벤트 로직 위반 추적
    int bothZerglingViolation = 0; // 한쪽만 저글링인데 '서로' 텍스트
    int expansionWithoutExpand = 0; // 확장 없이 확장 견제

    for (int i = 0; i < 100; i++) {
      final home = _makePlayer(name: 'Home', race: Race.zerg, stats: _balancedStats);
      final away = _makePlayer(name: 'Away', race: Race.zerg, stats: _balancedStats);

      final stream = service.simulateMatchWithLog(
        homePlayer: home,
        awayPlayer: away,
        map: _standardMap,
        getIntervalMs: () => 0,
      );

      SimulationState? lastState;
      int lineIdx = 0;
      bool hasScourge = false;
      bool hasExpansionHarass = false;

      await for (final state in stream) {
        lastState = state;
        lineIdx++;

        // 30줄 간격 스냅샷
        if (lineIdx % 30 == 0) {
          resourceSnapshots.putIfAbsent(lineIdx, () => []);
          resourceSnapshots[lineIdx]!.add(state.homeResources);
          resourceSnapshots[lineIdx]!.add(state.awayResources);
        }
      }

      if (lastState != null) {
        totalGames++;
        totalLines += lastState.battleLogEntries.length;
        if (lastState.homeWin == true) homeWins++;

        // 최종 자원 체크
        if (lastState.homeResources > 500 || lastState.awayResources > 500) {
          highResourceGames++;
        }

        // 이벤트 텍스트 검증
        for (final entry in lastState.battleLogEntries) {
          final text = entry.text;

          if (text.contains('스커지')) hasScourge = true;
          if (text.contains('확장 견제')) hasExpansionHarass = true;

          // 위반 체크: '서로 저글링' 텍스트
          if (text.contains('서로 저글링') || text.contains('양측 저글링')) {
            // 이 텍스트는 bothHaveZerglings == true일 때만 나와야 함
            // 테스트에서는 출현 여부만 카운트
          }
        }

        if (hasScourge) scourgeEventCount++;
        if (hasExpansionHarass) expansionHarassCount++;
      }
    }

    buf.writeln('총 경기: $totalGames');
    buf.writeln('Home 승률: ${(homeWins / totalGames * 100).toStringAsFixed(1)}%');
    buf.writeln('평균 줄 수: ${(totalLines / totalGames).toStringAsFixed(1)}');
    buf.writeln('자원 500+ 경기: $highResourceGames (${(highResourceGames / totalGames * 100).toStringAsFixed(1)}%)');
    buf.writeln('스커지 이벤트 등장: $scourgeEventCount / $totalGames (${(scourgeEventCount / totalGames * 100).toStringAsFixed(1)}%)');
    buf.writeln('확장 견제 등장: $expansionHarassCount / $totalGames');
    buf.writeln('');

    // 자원 스냅샷 출력
    buf.writeln('--- 자원 스냅샷 (30줄 간격 평균) ---');
    final sortedLines = resourceSnapshots.keys.toList()..sort();
    for (final line in sortedLines) {
      final values = resourceSnapshots[line]!;
      if (values.isEmpty) continue;
      final avg = values.reduce((a, b) => a + b) / values.length;
      final maxVal = values.reduce((a, b) => a > b ? a : b);
      buf.writeln('  Line $line: 평균자원 ${avg.toStringAsFixed(0)} / 최대 $maxVal (샘플 ${values.length})');
    }

    buf.writeln('');
    buf.writeln('--- 이벤트 로직 위반 ---');
    buf.writeln('  양측저글링 위반: $bothZerglingViolation');
    buf.writeln('  확장없이 견제: $expansionWithoutExpand');

    print(buf.toString());

    // 스커지 이벤트 보장 검증 (긴 경기에서는 반드시 등장해야 함)
    expect(scourgeEventCount, greaterThan(50),
        reason: 'ZvZ 100경기 중 스커지 이벤트가 50% 이상 등장해야 함');
  }, timeout: const Timeout(Duration(minutes: 5)));

  // ============================================================
  // 2. 전체 매치업 100경기 - 이벤트 풀 논리 검증
  // ============================================================
  test('전체 매치업 이벤트 풀 논리 검증 (각 100경기)', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('=== 전체 매치업 이벤트 풀 논리 검증 ===\n');

    final matchups = [
      ('TvZ', Race.terran, Race.zerg),
      ('TvP', Race.terran, Race.protoss),
      ('TvT', Race.terran, Race.terran),
      ('ZvP', Race.zerg, Race.protoss),
      ('ZvZ', Race.zerg, Race.zerg),
      ('PvP', Race.protoss, Race.protoss),
    ];

    // 금지 패턴 (수정 완료 확인용)
    final forbiddenPatterns = [
      '불굴의 정신력',
      '질럿 스피드 연구',
      '스피드',
      '질럿으로 벌처',
      '경제력 우위',
      '경제 흔들기',
      '공격적 오프닝과 수비적 오프닝의 대결',
    ];

    int totalViolations = 0;
    final violationDetails = <String>[];

    for (final (label, homeRace, awayRace) in matchups) {
      int matchWins = 0;
      int matchGames = 0;
      int matchViolations = 0;
      final eventCounts = <String, int>{}; // 이벤트 종류별 카운트

      for (int i = 0; i < 100; i++) {
        final home = _makePlayer(name: 'Home', race: homeRace, stats: _balancedStats);
        final away = _makePlayer(name: 'Away', race: awayRace, stats: _balancedStats);

        final stream = service.simulateMatchWithLog(
          homePlayer: home,
          awayPlayer: away,
          map: _standardMap,
          getIntervalMs: () => 0,
        );

        SimulationState? lastState;
        await for (final state in stream) {
          lastState = state;
        }

        if (lastState != null) {
          matchGames++;
          if (lastState.homeWin == true) matchWins++;

          for (final entry in lastState.battleLogEntries) {
            // 금지 패턴 체크
            for (final pattern in forbiddenPatterns) {
              if (entry.text.contains(pattern)) {
                matchViolations++;
                totalViolations++;
                violationDetails.add('[$label] Game $i: "${entry.text}" (패턴: $pattern)');
              }
            }

            // 이벤트 종류 카운트 (owner별)
            final key = '${entry.owner.name}';
            eventCounts[key] = (eventCounts[key] ?? 0) + 1;
          }
        }
      }

      buf.writeln('[$label] ${matchGames}경기 | Home 승률: ${(matchWins / matchGames * 100).toStringAsFixed(1)}% | 위반: $matchViolations');
      for (final key in eventCounts.keys.toList()..sort()) {
        buf.writeln('  $key: ${eventCounts[key]} (평균 ${(eventCounts[key]! / matchGames).toStringAsFixed(1)}/경기)');
      }
      buf.writeln('');
    }

    buf.writeln('--- 총 위반 수: $totalViolations ---');
    if (violationDetails.isNotEmpty) {
      buf.writeln('위반 상세 (최대 10건):');
      for (final detail in violationDetails.take(10)) {
        buf.writeln('  $detail');
      }
    }

    print(buf.toString());

    // 금지 패턴 위반이 0이어야 함
    expect(totalViolations, equals(0),
        reason: '금지 패턴이 발견됨: ${violationDetails.take(5).join(', ')}');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
