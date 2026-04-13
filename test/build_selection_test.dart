// 전 종족전 빌드 선택 비율 통합 테스트
//
// 맵 조건 6가지 × 선수 조합 4가지 × 1000경기 = 빌드 분포 통계
// 비미러 종족전은 오프닝+트랜지션 조합이므로 빌드 이름/스타일로 분류
//
// 사용법:
//   flutter test test/build_selection_test.dart                        # 전체
//   flutter test --name "ZvZ" test/build_selection_test.dart           # 종족전 필터
//   flutter test --name "TvZ" test/build_selection_test.dart
//   flutter test --name "러쉬거리 짧은 맵" test/build_selection_test.dart  # 맵 조건 필터
//   flutter test --name "공격적 vs 수비적" test/build_selection_test.dart  # 선수 필터

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/core/constants/build_orders.dart';
import 'package:mystar/domain/models/models.dart';

// ── 설정 ──

const _gamesPerCondition = 1000;

// ── 종족전 정의 ──

class _MatchupConfig {
  final String label;       // 'TvT', 'TvZ', ...
  final String race;        // 'T', 'Z', 'P'
  final String vsRace;      // 'T', 'Z', 'P'
  final String outputDir;   // 'tvt', 'tvz', ...

  const _MatchupConfig(this.label, this.race, this.vsRace, this.outputDir);
}

const _matchups = [
  _MatchupConfig('TvT', 'T', 'T', 'tvt'),
  _MatchupConfig('TvZ', 'T', 'Z', 'tvz'),
  _MatchupConfig('TvP', 'T', 'P', 'tvp'),
  _MatchupConfig('ZvT', 'Z', 'T', 'zvt'),
  _MatchupConfig('ZvP', 'Z', 'P', 'zvp'),
  _MatchupConfig('ZvZ', 'Z', 'Z', 'zvz'),
  _MatchupConfig('PvT', 'P', 'T', 'pvt'),
  _MatchupConfig('PvZ', 'P', 'Z', 'pvz'),
  _MatchupConfig('PvP', 'P', 'P', 'pvp'),
];

// ── 맵 정의 ──

const _testMaps = {
  '러쉬거리 짧은 맵': GameMap(
    id: 'short_rush', name: '러쉬거리 짧은 맵',
    rushDistance: 2, resources: 5, complexity: 5,
    terrainComplexity: 5, airAccessibility: 7, centerImportance: 8,
  ),
  '러쉬거리 긴 맵': GameMap(
    id: 'long_rush', name: '러쉬거리 긴 맵',
    rushDistance: 9, resources: 5, complexity: 5,
    terrainComplexity: 5, airAccessibility: 4, centerImportance: 3,
  ),
  '자원 많은 맵': GameMap(
    id: 'rich_resource', name: '자원 많은 맵',
    rushDistance: 5, resources: 9, complexity: 5,
    expansionCount: 5, terrainComplexity: 5, airAccessibility: 5,
    centerImportance: 5,
  ),
  '자원 적은 맵': GameMap(
    id: 'poor_resource', name: '자원 적은 맵',
    rushDistance: 5, resources: 2, complexity: 5,
    expansionCount: 3, terrainComplexity: 5, airAccessibility: 5,
    centerImportance: 5,
  ),
  '복잡도 높은 맵': GameMap(
    id: 'high_complexity', name: '복잡도 높은 맵',
    rushDistance: 5, resources: 5, complexity: 9,
    terrainComplexity: 9, airAccessibility: 5, centerImportance: 5,
  ),
  '복잡도 낮은 맵': GameMap(
    id: 'low_complexity', name: '복잡도 낮은 맵',
    rushDistance: 5, resources: 5, complexity: 2,
    terrainComplexity: 2, airAccessibility: 5, centerImportance: 5,
  ),
};

const _neutralMap = GameMap(
  id: 'neutral', name: '기본 맵',
  rushDistance: 5, resources: 5, complexity: 5,
  terrainComplexity: 5, airAccessibility: 5, centerImportance: 5,
);

// ── 선수 스탯 프로필 ──

Map<String, int> _aggressiveStats() => {
  'sense': 600, 'control': 800, 'attack': 850, 'harass': 750,
  'strategy': 500, 'macro': 450, 'defense': 400, 'scout': 700,
};

Map<String, int> _defensiveStats() => {
  'sense': 600, 'control': 600, 'attack': 450, 'harass': 500,
  'strategy': 700, 'macro': 850, 'defense': 800, 'scout': 600,
};

Map<String, int> _balancedStats() => {
  'sense': 700, 'control': 700, 'attack': 700, 'harass': 700,
  'strategy': 700, 'macro': 700, 'defense': 700, 'scout': 700,
};

// ── 빌드 선택 결과 ──

class _BuildResult {
  final String id;
  final String name;
  final BuildStyle style;

  _BuildResult(this.id, this.name, this.style);
}

// ── N회 빌드 선택 실행 ──

List<_BuildResult> _runSelection(
  String race, String vsRace,
  Map<String, int> statValues, GameMap map, int count,
) {
  final results = <_BuildResult>[];
  for (var i = 0; i < count; i++) {
    final build = BuildOrderData.getBuildOrder(
      race: race, vsRace: vsRace,
      statValues: statValues, map: map,
    );
    if (build != null) {
      results.add(_BuildResult(build.id, build.name, build.style));
    }
  }
  return results;
}

// ── 스타일별 집계 ──

Map<String, int> _countByStyle(List<_BuildResult> results) {
  final counts = <String, int>{};
  for (final r in results) {
    final label = r.style.name;
    counts[label] = (counts[label] ?? 0) + 1;
  }
  return counts;
}

// ── 빌드명별 집계 ──

Map<String, int> _countByName(List<_BuildResult> results) {
  final counts = <String, int>{};
  for (final r in results) {
    counts[r.name] = (counts[r.name] ?? 0) + 1;
  }
  return counts;
}

// ── 포맷 (빌드명 기준) ──

String _formatByName(Map<String, int> counts, int total) {
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final buf = StringBuffer();
  for (final e in sorted) {
    final pct = (e.value / total * 100).toStringAsFixed(1);
    final bar = '█' * (e.value * 40 ~/ total);
    buf.writeln('  ${e.key.padRight(24)} ${pct.padLeft(5)}% (${'${e.value}'.padLeft(4)}) $bar');
  }
  return buf.toString();
}

// ── 포맷 (스타일 기준) ──

String _formatByStyle(Map<String, int> counts, int total) {
  final order = ['cheese', 'aggressive', 'balanced', 'defensive'];
  final labels = {
    'cheese': '🧀 치즈', 'aggressive': '⚔️ 공격',
    'balanced': '⚖️ 밸런스', 'defensive': '🛡️ 수비',
  };
  final buf = StringBuffer();
  for (final style in order) {
    final count = counts[style] ?? 0;
    if (count == 0) continue;
    final pct = (count / total * 100).toStringAsFixed(1);
    final bar = '█' * (count * 30 ~/ total);
    buf.writeln('  ${labels[style]!.padRight(14)} ${pct.padLeft(5)}% (${'$count'.padLeft(4)}) $bar');
  }
  return buf.toString();
}

// ── 공격형 스타일 카운트 ──

int _aggressiveCount(Map<String, int> styleCounts) {
  return (styleCounts['cheese'] ?? 0) + (styleCounts['aggressive'] ?? 0);
}

int _defensiveCount(Map<String, int> styleCounts) {
  return (styleCounts['balanced'] ?? 0) + (styleCounts['defensive'] ?? 0);
}

// ════════════════════════════════════════════════════════════════
// 테스트
// ════════════════════════════════════════════════════════════════

void main() {
  final reportBuf = StringBuffer();

  for (final mu in _matchups) {
    reportBuf.writeln('# ${mu.label} 빌드 선택 비율 분석');
    reportBuf.writeln('경기 수: $_gamesPerCondition / 조건\n');

    // ── 1. 맵별 테스트 (밸런스 선수) ──
    group('${mu.label} 맵별 빌드 선택', () {
      for (final mapEntry in _testMaps.entries) {
        test('${mapEntry.key}', () {
          final results = _runSelection(
            mu.race, mu.vsRace, _balancedStats(), mapEntry.value, _gamesPerCondition,
          );
          final byName = _countByName(results);
          final byStyle = _countByStyle(results);
          final total = results.length;

          final header = '## 맵: ${mapEntry.key}';
          final mapVal = mapEntry.value;
          final mapInfo = '  rush=${mapVal.rushDistance} res=${mapVal.resources} '
              'complex=${mapVal.complexity} terrain=${mapVal.terrainComplexity} '
              'air=${mapVal.airAccessibility} center=${mapVal.centerImportance}';

          reportBuf.writeln(header);
          reportBuf.writeln(mapInfo);
          reportBuf.writeln('스타일 분포:');
          reportBuf.writeln(_formatByStyle(byStyle, total));
          reportBuf.writeln('빌드 분포:');
          reportBuf.writeln(_formatByName(byName, total));

          // ignore: avoid_print
          print('\n$header');
          // ignore: avoid_print
          print(mapInfo);
          // ignore: avoid_print
          print('스타일:');
          // ignore: avoid_print
          print(_formatByStyle(byStyle, total));
          // ignore: avoid_print
          print('빌드:');
          // ignore: avoid_print
          print(_formatByName(byName, total));
        });
      }
    });

    // ── 2. 선수 조합별 테스트 (기본 맵) ──
    group('${mu.label} 선수 조합별 빌드 선택', () {
      final profiles = {
        '공격적 vs 수비적': (_aggressiveStats(), _defensiveStats()),
        '공격적 vs 공격적': (_aggressiveStats(), _aggressiveStats()),
        '수비적 vs 수비적': (_defensiveStats(), _defensiveStats()),
        '밸런스 (동일 능력치)': (_balancedStats(), _balancedStats()),
      };

      for (final entry in profiles.entries) {
        test('${entry.key}', () {
          final (homeStats, awayStats) = entry.value;
          final homeResults = _runSelection(
            mu.race, mu.vsRace, homeStats, _neutralMap, _gamesPerCondition,
          );
          final awayResults = _runSelection(
            mu.race, mu.vsRace, awayStats, _neutralMap, _gamesPerCondition,
          );

          final homeByName = _countByName(homeResults);
          final awayByName = _countByName(awayResults);
          final homeByStyle = _countByStyle(homeResults);
          final awayByStyle = _countByStyle(awayResults);

          final labels = entry.key.split(' vs ');
          final homeLabel = labels.first;
          final awayLabel = labels.length > 1 ? labels.last : labels.first;

          reportBuf.writeln('## 선수: ${entry.key}');
          reportBuf.writeln('### Home ($homeLabel)');
          reportBuf.writeln(_formatByStyle(homeByStyle, homeResults.length));
          reportBuf.writeln(_formatByName(homeByName, homeResults.length));
          reportBuf.writeln('### Away ($awayLabel)');
          reportBuf.writeln(_formatByStyle(awayByStyle, awayResults.length));
          reportBuf.writeln(_formatByName(awayByName, awayResults.length));

          // ignore: avoid_print
          print('\n## 선수: ${entry.key}');
          // ignore: avoid_print
          print('Home ($homeLabel) 스타일:');
          // ignore: avoid_print
          print(_formatByStyle(homeByStyle, homeResults.length));
          // ignore: avoid_print
          print('Home ($homeLabel) 빌드:');
          // ignore: avoid_print
          print(_formatByName(homeByName, homeResults.length));
          // ignore: avoid_print
          print('Away ($awayLabel) 스타일:');
          // ignore: avoid_print
          print(_formatByStyle(awayByStyle, awayResults.length));
          // ignore: avoid_print
          print('Away ($awayLabel) 빌드:');
          // ignore: avoid_print
          print(_formatByName(awayByName, awayResults.length));
        });
      }
    });

    // ── 3. 교차 검증: 러쉬거리 × 공격적 선수 ──
    group('${mu.label} 교차 검증', () {
      test('공격적 선수: 짧은 맵 vs 긴 맵', () {
        final stats = _aggressiveStats();
        final shortResults = _runSelection(
          mu.race, mu.vsRace, stats, _testMaps['러쉬거리 짧은 맵']!, _gamesPerCondition,
        );
        final longResults = _runSelection(
          mu.race, mu.vsRace, stats, _testMaps['러쉬거리 긴 맵']!, _gamesPerCondition,
        );

        final shortStyle = _countByStyle(shortResults);
        final longStyle = _countByStyle(longResults);

        final shortAggr = _aggressiveCount(shortStyle);
        final longAggr = _aggressiveCount(longStyle);

        reportBuf.writeln('## 교차: 공격적 선수 × 러쉬거리');
        reportBuf.writeln('짧은 맵 공격빌드: $shortAggr / ${shortResults.length}');
        reportBuf.writeln('긴 맵 공격빌드: $longAggr / ${longResults.length}');
        reportBuf.writeln('');

        // ignore: avoid_print
        print('\n## 교차: 공격적 선수 × 러쉬거리');
        // ignore: avoid_print
        print('짧은 맵 공격빌드: $shortAggr / ${shortResults.length}');
        // ignore: avoid_print
        print('긴 맵 공격빌드: $longAggr / ${longResults.length}');

        expect(shortAggr, greaterThan(longAggr),
            reason: '${mu.label}: 짧은 맵에서 공격 빌드 선택률이 더 높아야 함');
      });

      test('수비적 선수: 자원 많은 맵 vs 적은 맵', () {
        final stats = _defensiveStats();
        final richResults = _runSelection(
          mu.race, mu.vsRace, stats, _testMaps['자원 많은 맵']!, _gamesPerCondition,
        );
        final poorResults = _runSelection(
          mu.race, mu.vsRace, stats, _testMaps['자원 적은 맵']!, _gamesPerCondition,
        );

        final richStyle = _countByStyle(richResults);
        final poorStyle = _countByStyle(poorResults);

        final richDef = _defensiveCount(richStyle);
        final poorDef = _defensiveCount(poorStyle);

        reportBuf.writeln('## 교차: 수비적 선수 × 자원량');
        reportBuf.writeln('자원 많은 맵 수비빌드: $richDef / ${richResults.length}');
        reportBuf.writeln('자원 적은 맵 수비빌드: $poorDef / ${poorResults.length}');
        reportBuf.writeln('');

        // ignore: avoid_print
        print('\n## 교차: 수비적 선수 × 자원량');
        // ignore: avoid_print
        print('자원 많은 맵 수비빌드: $richDef / ${richResults.length}');
        // ignore: avoid_print
        print('자원 적은 맵 수비빌드: $poorDef / ${poorResults.length}');

        // 통계적 오차 허용 (1000경기 기준 ±3%p)
        final margin = (_gamesPerCondition * 0.03).round();
        expect(richDef + margin, greaterThanOrEqualTo(poorDef),
            reason: '${mu.label}: 자원 많은 맵에서 수비/밸런스 빌드가 유의미하게 낮으면 안 됨');
      });
    });

    reportBuf.writeln('\n---\n');
  }

  // ── 리포트 저장 ──
  tearDownAll(() {
    final outputDir = Directory('test/output/build_selection');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    File('test/output/build_selection/report.md')
        .writeAsStringSync(reportBuf.toString());
    // ignore: avoid_print
    print('\n✅ 리포트 저장: test/output/build_selection/report.md');
  });
}
