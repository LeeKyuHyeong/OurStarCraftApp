// PvP 100경기 상세 분석
// 실행: flutter test test/pvp_analysis_test.dart --reporter expanded
import 'dart:math';

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
  id: 'test_fighting_spirit',
  name: '파이팅 스피릿',
  rushDistance: 6,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 6,
  centerImportance: 5,
);

// B+ 균형 스탯
const _balancedStats = PlayerStats(
  sense: 650, control: 650, attack: 650, harass: 650,
  strategy: 650, macro: 650, defense: 650, scout: 650,
);

class GameRecord {
  final bool homeWin;
  final int lineCount;
  final int finalHomeArmy;
  final int finalAwayArmy;
  final int finalHomeRes;
  final int finalAwayRes;
  final List<BattleLogEntry> entries;

  GameRecord({
    required this.homeWin,
    required this.lineCount,
    required this.finalHomeArmy,
    required this.finalAwayArmy,
    required this.finalHomeRes,
    required this.finalAwayRes,
    required this.entries,
  });
}

void main() {
  test('PvP 100경기 상세 분석', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    final records = <GameRecord>[];

    // --- 100경기 시뮬레이션 ---
    for (int i = 0; i < 100; i++) {
      final home = _makePlayer(name: 'Home', race: Race.protoss, stats: _balancedStats);
      final away = _makePlayer(name: 'Away', race: Race.protoss, stats: _balancedStats);

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
        records.add(GameRecord(
          homeWin: lastState.homeWin == true,
          lineCount: lastState.battleLogEntries.length,
          finalHomeArmy: lastState.homeArmy,
          finalAwayArmy: lastState.awayArmy,
          finalHomeRes: lastState.homeResources,
          finalAwayRes: lastState.awayResources,
          entries: lastState.battleLogEntries,
        ));
      }
    }

    // ============================================================
    // 1. 기본 통계
    // ============================================================
    buf.writeln('╔══════════════════════════════════════════╗');
    buf.writeln('║   PvP 100경기 시뮬레이션 분석 보고서     ║');
    buf.writeln('╚══════════════════════════════════════════╝');
    buf.writeln('');

    final totalGames = records.length;
    final homeWins = records.where((r) => r.homeWin).length;
    final awayWins = totalGames - homeWins;
    final avgLines = records.map((r) => r.lineCount).reduce((a, b) => a + b) / totalGames;
    final shortGames = records.where((r) => r.lineCount <= 30).length;
    final midGames = records.where((r) => r.lineCount > 30 && r.lineCount <= 80).length;
    final longGames = records.where((r) => r.lineCount > 80).length;

    buf.writeln('## 1. 기본 통계');
    buf.writeln('');
    buf.writeln('| 항목 | 값 |');
    buf.writeln('|------|-----|');
    buf.writeln('| 총 경기 | $totalGames |');
    buf.writeln('| Home 승리 | $homeWins (${(homeWins / totalGames * 100).toStringAsFixed(1)}%) |');
    buf.writeln('| Away 승리 | $awayWins (${(awayWins / totalGames * 100).toStringAsFixed(1)}%) |');
    buf.writeln('| 평균 줄 수 | ${avgLines.toStringAsFixed(1)} |');
    buf.writeln('| 짧은 경기 (<=30줄) | $shortGames |');
    buf.writeln('| 중간 경기 (31~80줄) | $midGames |');
    buf.writeln('| 긴 경기 (>80줄) | $longGames |');
    buf.writeln('');

    // ============================================================
    // 2. 병력/자원 통계
    // ============================================================
    final avgFinalHomeArmy = records.map((r) => r.finalHomeArmy).reduce((a, b) => a + b) / totalGames;
    final avgFinalAwayArmy = records.map((r) => r.finalAwayArmy).reduce((a, b) => a + b) / totalGames;
    final avgFinalHomeRes = records.map((r) => r.finalHomeRes).reduce((a, b) => a + b) / totalGames;
    final avgFinalAwayRes = records.map((r) => r.finalAwayRes).reduce((a, b) => a + b) / totalGames;

    buf.writeln('## 2. 최종 병력/자원');
    buf.writeln('');
    buf.writeln('| 항목 | Home | Away |');
    buf.writeln('|------|------|------|');
    buf.writeln('| 평균 잔여 병력 | ${avgFinalHomeArmy.toStringAsFixed(1)} | ${avgFinalAwayArmy.toStringAsFixed(1)} |');
    buf.writeln('| 평균 잔여 자원 | ${avgFinalHomeRes.toStringAsFixed(1)} | ${avgFinalAwayRes.toStringAsFixed(1)} |');
    buf.writeln('| 병력 0 패배 | ${records.where((r) => !r.homeWin && r.finalHomeArmy <= 0).length} | ${records.where((r) => r.homeWin && r.finalAwayArmy <= 0).length} |');
    buf.writeln('');

    // ============================================================
    // 3. 이벤트 Owner별 분포
    // ============================================================
    final ownerCounts = <String, int>{};
    int totalEntries = 0;
    for (final r in records) {
      for (final e in r.entries) {
        final key = e.owner.name;
        ownerCounts[key] = (ownerCounts[key] ?? 0) + 1;
        totalEntries++;
      }
    }

    buf.writeln('## 3. 로그 Owner별 분포');
    buf.writeln('');
    buf.writeln('| Owner | 총 이벤트 | 경기당 평균 |');
    buf.writeln('|-------|-----------|-------------|');
    for (final key in ['home', 'away', 'system', 'clash']) {
      final count = ownerCounts[key] ?? 0;
      buf.writeln('| $key | $count | ${(count / totalGames).toStringAsFixed(1)} |');
    }
    buf.writeln('| **합계** | **$totalEntries** | **${(totalEntries / totalGames).toStringAsFixed(1)}** |');
    buf.writeln('');

    // ============================================================
    // 4. 주요 유닛/키워드 등장 빈도
    // ============================================================
    final unitKeywords = [
      '드라군', '질럿', '리버', '셔틀', '다크템플러', '하이템플러',
      '아콘', '옵저버', '커세어', '프로브', '스톰', '스캐럽',
      '캐논', '넥서스', '게이트웨이', '로보틱스',
    ];

    final keywordGameCounts = <String, int>{};
    final keywordTotalCounts = <String, int>{};

    for (final r in records) {
      final seen = <String>{};
      for (final e in r.entries) {
        for (final kw in unitKeywords) {
          if (e.text.contains(kw)) {
            keywordTotalCounts[kw] = (keywordTotalCounts[kw] ?? 0) + 1;
            seen.add(kw);
          }
        }
      }
      for (final kw in seen) {
        keywordGameCounts[kw] = (keywordGameCounts[kw] ?? 0) + 1;
      }
    }

    final sortedKeywords = keywordGameCounts.keys.toList()
      ..sort((a, b) => keywordGameCounts[b]!.compareTo(keywordGameCounts[a]!));

    buf.writeln('## 4. 유닛 키워드 등장 빈도');
    buf.writeln('');
    buf.writeln('| 유닛 | 등장 경기 | 비율 | 총 등장 | 경기당 평균 |');
    buf.writeln('|------|----------|------|---------|-------------|');
    for (final kw in sortedKeywords) {
      final games = keywordGameCounts[kw]!;
      final total = keywordTotalCounts[kw]!;
      buf.writeln('| $kw | $games | ${(games / totalGames * 100).toStringAsFixed(0)}% | $total | ${(total / totalGames).toStringAsFixed(1)} |');
    }
    buf.writeln('');

    // ============================================================
    // 5. 전투 관련 이벤트 텍스트 Top 20
    // ============================================================
    final textCounts = <String, int>{};
    for (final r in records) {
      for (final e in r.entries) {
        if (e.owner == LogOwner.system) continue;
        final normalized = e.text
            .replaceAll('Home', '{H}')
            .replaceAll('Away', '{A}');
        textCounts[normalized] = (textCounts[normalized] ?? 0) + 1;
      }
    }

    final topTexts = textCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    buf.writeln('## 5. 자주 등장하는 이벤트 텍스트 Top 20');
    buf.writeln('');
    buf.writeln('| # | 횟수 | 텍스트 |');
    buf.writeln('|---|------|--------|');
    for (int i = 0; i < min(20, topTexts.length); i++) {
      buf.writeln('| ${i + 1} | ${topTexts[i].value} | ${topTexts[i].key} |');
    }
    buf.writeln('');

    // ============================================================
    // 6. 해설(system) 이벤트 Top 15
    // ============================================================
    final systemTexts = <String, int>{};
    for (final r in records) {
      for (final e in r.entries) {
        if (e.owner != LogOwner.system) continue;
        final normalized = e.text
            .replaceAll('Home', '{H}')
            .replaceAll('Away', '{A}');
        systemTexts[normalized] = (systemTexts[normalized] ?? 0) + 1;
      }
    }

    final topSystem = systemTexts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    buf.writeln('## 6. 해설 이벤트 Top 15');
    buf.writeln('');
    buf.writeln('| # | 횟수 | 텍스트 |');
    buf.writeln('|---|------|--------|');
    for (int i = 0; i < min(15, topSystem.length); i++) {
      buf.writeln('| ${i + 1} | ${topSystem[i].value} | ${topSystem[i].key} |');
    }
    buf.writeln('');

    // ============================================================
    // 7. 금지 패턴 검증
    // ============================================================
    final forbiddenPatterns = [
      '불굴의 정신력',
      '질럿 스피드 연구',
      '경제력 우위',
      '경제 흔들기',
      '공격적 오프닝과 수비적 오프닝의 대결',
      '아비터',
    ];

    final violations = <String>[];
    for (final r in records) {
      for (final e in r.entries) {
        for (final pattern in forbiddenPatterns) {
          if (e.text.contains(pattern)) {
            violations.add('"${e.text}" (패턴: $pattern)');
          }
        }
      }
    }

    buf.writeln('## 7. 금지 패턴 검증');
    buf.writeln('');
    buf.writeln('| 패턴 | 결과 |');
    buf.writeln('|------|------|');
    for (final p in forbiddenPatterns) {
      final found = violations.where((v) => v.contains(p)).length;
      buf.writeln('| $p | ${found == 0 ? "통과" : "**위반 $found건**"} |');
    }
    buf.writeln('');

    if (violations.isNotEmpty) {
      buf.writeln('위반 상세:');
      for (final v in violations.take(10)) {
        buf.writeln('  - $v');
      }
      buf.writeln('');
    }

    // ============================================================
    // 8. 경기 흐름 예시 (1경기 전체 로그)
    // ============================================================
    buf.writeln('## 8. 경기 예시 (마지막 경기 전체 로그)');
    buf.writeln('');
    final sample = records.last;
    buf.writeln('결과: ${sample.homeWin ? "Home 승리" : "Away 승리"} | 병력 H:${sample.finalHomeArmy} A:${sample.finalAwayArmy} | 자원 H:${sample.finalHomeRes} A:${sample.finalAwayRes}');
    buf.writeln('');
    buf.writeln('```');
    for (final e in sample.entries) {
      final prefix = switch (e.owner) {
        LogOwner.home => '[H]',
        LogOwner.away => '[A]',
        LogOwner.system => '[해설]',
        LogOwner.clash => '[전투]',
      };
      buf.writeln('$prefix ${e.text}');
    }
    buf.writeln('```');
    buf.writeln('');

    print(buf.toString());

    // Assertions
    expect(records.length, equals(100));
    expect(violations, isEmpty, reason: '금지 패턴 위반: ${violations.take(3).join(', ')}');
  }, timeout: const Timeout(Duration(minutes: 5)));
}
