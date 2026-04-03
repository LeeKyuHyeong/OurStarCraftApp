import 'dart:io';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// ============================================================
/// 시즌 전체 테스트 - 모든 종족전 자연 빌드 선택으로 시뮬레이션
/// 시나리오 폴백 발동 여부 + 크래시 없는지 검증
/// ============================================================
void main() {
  // 종족별 선수 생성 (다양한 능력치)
  Player makePlayer(String id, String name, int raceIndex, {
    int sense = 650, int control = 650, int attack = 650, int harass = 650,
    int strategy = 650, int macro = 650, int defense = 650, int scout = 650,
    int level = 5, int condition = 90,
  }) {
    return Player(
      id: id, name: name, raceIndex: raceIndex,
      stats: PlayerStats(
        sense: sense, control: control, attack: attack, harass: harass,
        strategy: strategy, macro: macro, defense: defense, scout: scout,
      ),
      levelValue: level, condition: condition,
    );
  }

  // 테란 선수 4명
  final terrans = [
    makePlayer('t1', '이영호', 0, attack: 750, control: 720, level: 8),
    makePlayer('t2', '임요환', 0, harass: 730, strategy: 710, level: 7),
    makePlayer('t3', '박명수', 0, defense: 700, macro: 720, level: 6),
    makePlayer('t4', '최연성', 0, sense: 680, scout: 700, level: 5),
  ];

  // 프로토스 선수 4명
  final protoss = [
    makePlayer('p1', '박정석', 1, strategy: 740, macro: 720, level: 8),
    makePlayer('p2', '김택용', 1, control: 750, attack: 710, level: 7),
    makePlayer('p3', '송병구', 1, defense: 720, sense: 700, level: 6),
    makePlayer('p4', '김정우', 1, harass: 710, scout: 690, level: 5),
  ];

  // 저그 선수 4명
  final zerg = [
    makePlayer('z1', '이제동', 2, macro: 750, attack: 730, level: 8),
    makePlayer('z2', '박성준', 2, control: 720, harass: 740, level: 7),
    makePlayer('z3', '김명운', 2, defense: 710, strategy: 700, level: 6),
    makePlayer('z4', '변형태', 2, sense: 700, scout: 710, level: 5),
  ];

  // 맵 풀 (다양한 특성)
  const maps = [
    GameMap(id: 'map1', name: '파이팅 스피릿', rushDistance: 6, resources: 5, terrainComplexity: 5, airAccessibility: 6, centerImportance: 5),
    GameMap(id: 'map2', name: '로스트 템플', rushDistance: 4, resources: 6, terrainComplexity: 7, airAccessibility: 5, centerImportance: 6),
    GameMap(id: 'map3', name: '써킷 브레이커', rushDistance: 7, resources: 6, terrainComplexity: 4, airAccessibility: 7, centerImportance: 4),
    GameMap(id: 'map4', name: '달팽이', rushDistance: 8, resources: 7, terrainComplexity: 6, airAccessibility: 4, centerImportance: 3),
    GameMap(id: 'map5', name: '네오 문글레이드', rushDistance: 5, resources: 5, terrainComplexity: 6, airAccessibility: 6, centerImportance: 5),
  ];

  final random = Random(42);

  // 매치업별 통계
  final matchupStats = <String, Map<String, int>>{};
  final errors = <String>[];
  final fallbacks = <String>[];

  /// 1경기 시뮬레이션
  Future<Map<String, dynamic>?> runMatch(Player home, Player away, GameMap map) async {
    final service = MatchSimulationService();
    try {
      final stream = service.simulateMatchWithLog(
        homePlayer: home, awayPlayer: away,
        map: map, getIntervalMs: () => 0,
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }

      if (state == null) {
        errors.add('NULL state: ${home.name}(${home.race}) vs ${away.name}(${away.race})');
        return null;
      }

      // 로그에서 시나리오 폴백 감지 (시나리오 없으면 빌드오더 텍스트만 나옴)
      final logTexts = state.battleLogEntries.map((e) => e.text).toList();
      final hasScenarioMarkers = logTexts.any((t) =>
        t.contains('{home}') || t.contains('{away}') // 미치환 플레이스홀더 = 버그
      );

      if (hasScenarioMarkers) {
        fallbacks.add('플레이스홀더 미치환: ${home.name} vs ${away.name}');
      }

      return {
        'homeWin': state.homeWin == true,
        'homeArmy': state.homeArmy,
        'awayArmy': state.awayArmy,
        'logCount': state.battleLogEntries.length,
      };
    } catch (e, st) {
      errors.add('CRASH: ${home.name}(${home.race}) vs ${away.name}(${away.race}): $e\n$st');
      return null;
    }
  }

  String matchupKey(Player home, Player away) {
    return '${home.race.code}v${away.race.code}';
  }

  test('시즌 전체 시뮬레이션 (프로리그 + 개인리그 규모)', () async {
    final buf = StringBuffer();
    buf.writeln('# 시즌 전체 테스트 리포트\n');

    int totalMatches = 0;
    int totalSuccess = 0;

    // ── 프로리그: 팀 대전 시뮬레이션 (28라운드 × 7세트 = ~196경기) ──
    // 간소화: 모든 종족전 조합을 고르게 분배
    final allPlayers = [...terrans, ...protoss, ...zerg];

    // 종족전별 매치 생성 (각 종족전 ~30경기씩)
    final matchups = <List<Player>>[];

    // TvT
    for (var i = 0; i < terrans.length; i++) {
      for (var j = i; j < terrans.length; j++) {
        for (var k = 0; k < 3; k++) {
          matchups.add([terrans[i], terrans[j]]);
        }
      }
    }
    // TvZ
    for (var t in terrans) {
      for (var z in zerg) {
        for (var k = 0; k < 2; k++) {
          matchups.add([t, z]);
        }
      }
    }
    // TvP (= PvT reversed)
    for (var t in terrans) {
      for (var p in protoss) {
        for (var k = 0; k < 2; k++) {
          matchups.add([t, p]);
        }
      }
    }
    // PvP
    for (var i = 0; i < protoss.length; i++) {
      for (var j = i; j < protoss.length; j++) {
        for (var k = 0; k < 3; k++) {
          matchups.add([protoss[i], protoss[j]]);
        }
      }
    }
    // ZvP
    for (var z in zerg) {
      for (var p in protoss) {
        for (var k = 0; k < 2; k++) {
          matchups.add([z, p]);
        }
      }
    }
    // ZvZ
    for (var i = 0; i < zerg.length; i++) {
      for (var j = i; j < zerg.length; j++) {
        for (var k = 0; k < 3; k++) {
          matchups.add([zerg[i], zerg[j]]);
        }
      }
    }

    // 셔플
    matchups.shuffle(random);

    buf.writeln('## 경기 수: ${matchups.length}\n');

    for (final pair in matchups) {
      final map = maps[random.nextInt(maps.length)];
      final home = pair[0];
      final away = pair[1];
      final key = matchupKey(home, away);

      matchupStats.putIfAbsent(key, () => {'total': 0, 'homeWin': 0, 'awayWin': 0});

      totalMatches++;
      final result = await runMatch(home, away, map);

      if (result != null) {
        totalSuccess++;
        matchupStats[key]!['total'] = matchupStats[key]!['total']! + 1;
        if (result['homeWin'] as bool) {
          matchupStats[key]!['homeWin'] = matchupStats[key]!['homeWin']! + 1;
        } else {
          matchupStats[key]!['awayWin'] = matchupStats[key]!['awayWin']! + 1;
        }
      }
    }

    // ── 리포트 작성 ──
    buf.writeln('## 종족전별 결과\n');
    buf.writeln('| 종족전 | 경기 수 | Home 승 | Away 승 | Home 승률 |');
    buf.writeln('|--------|---------|---------|---------|----------|');
    for (final entry in matchupStats.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
      final k = entry.key;
      final v = entry.value;
      final total = v['total']!;
      final homeW = v['homeWin']!;
      final awayW = v['awayWin']!;
      final rate = total > 0 ? (homeW / total * 100).toStringAsFixed(1) : '-';
      buf.writeln('| $k | $total | $homeW | $awayW | $rate% |');
    }

    buf.writeln('\n## 요약\n');
    buf.writeln('- 총 경기: $totalMatches');
    buf.writeln('- 성공: $totalSuccess');
    buf.writeln('- 에러: ${errors.length}');
    buf.writeln('- 폴백/미치환: ${fallbacks.length}');

    if (errors.isNotEmpty) {
      buf.writeln('\n## 에러 목록\n');
      for (final e in errors) {
        buf.writeln('- $e');
      }
    }

    if (fallbacks.isNotEmpty) {
      buf.writeln('\n## 폴백/미치환 목록\n');
      for (final f in fallbacks) {
        buf.writeln('- $f');
      }
    }

    // 파일 출력
    final outDir = Directory('test/output');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/season_full_report.md').writeAsStringSync(buf.toString());

    print(buf.toString());

    // 검증
    expect(errors, isEmpty, reason: '시뮬레이션 크래시 없어야 함');
    expect(fallbacks, isEmpty, reason: '플레이스홀더 미치환 없어야 함');
    expect(totalSuccess, equals(totalMatches), reason: '모든 경기 성공해야 함');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
