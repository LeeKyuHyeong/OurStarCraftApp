// 맵 유형별 TvZ 승률 분석
// 실행: flutter test test/map_tvz_test.dart --reporter expanded
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

Player _makePlayer({
  required String name,
  required Race race,
}) {
  return Player(
    id: name,
    name: name,
    raceIndex: race.index,
    stats: const PlayerStats(
      sense: 650, control: 650, attack: 650, harass: 650,
      strategy: 650, macro: 650, defense: 650, scout: 650,
    ),
    levelValue: 5,
    condition: 100,
  );
}

// 맵 유형별 대표 맵 정의
// rushDistance, resources, terrainComplexity, airAccessibility, centerImportance
// matchup.tvzTerranWinRate 포함

final _mapCategories = <String, List<GameMap>>{
  // 1. 러쉬맵 (rushDistance ≤ 4, centerImportance 높음)
  '러쉬맵': [
    const GameMap(
      id: '투혼', name: '투혼',
      rushDistance: 4, resources: 6, complexity: 4,
      terrainComplexity: 4, airAccessibility: 4, centerImportance: 8,
      matchup: RaceMatchup(tvzTerranWinRate: 55),
    ),
    const GameMap(
      id: '지오메트리', name: '지오메트리',
      rushDistance: 4, resources: 6, complexity: 5,
      terrainComplexity: 5, airAccessibility: 4, centerImportance: 8,
      matchup: RaceMatchup(tvzTerranWinRate: 65),
    ),
    const GameMap(
      id: '콜로세움2', name: '콜로세움2',
      rushDistance: 4, resources: 5, complexity: 6,
      terrainComplexity: 6, airAccessibility: 4, centerImportance: 8,
      matchup: RaceMatchup(tvzTerranWinRate: 57),
    ),
  ],

  // 2. 매크로맵 (rushDistance ≥ 7, resources ≥ 6)
  '매크로맵': [
    const GameMap(
      id: '폭풍의언덕', name: '폭풍의언덕',
      rushDistance: 7, resources: 7, complexity: 4,
      terrainComplexity: 4, airAccessibility: 7, centerImportance: 4,
      matchup: RaceMatchup(tvzTerranWinRate: 65),
    ),
    const GameMap(
      id: '안드로메다', name: '안드로메다',
      rushDistance: 8, resources: 8, complexity: 5,
      terrainComplexity: 5, airAccessibility: 8, centerImportance: 4,
      hasIsland: true,
      matchup: RaceMatchup(tvzTerranWinRate: 42),
    ),
    const GameMap(
      id: '벤젠', name: '벤젠',
      rushDistance: 9, resources: 6, complexity: 5,
      terrainComplexity: 5, airAccessibility: 9, centerImportance: 4,
      matchup: RaceMatchup(tvzTerranWinRate: 48),
    ),
  ],

  // 3. 복잡지형맵 (terrainComplexity ≥ 7)
  '복잡지형': [
    const GameMap(
      id: '트로이', name: '트로이',
      rushDistance: 3, resources: 6, complexity: 9,
      terrainComplexity: 9, airAccessibility: 3, centerImportance: 8,
      matchup: RaceMatchup(tvzTerranWinRate: 48),
    ),
    const GameMap(
      id: '단장의능선', name: '단장의능선',
      rushDistance: 6, resources: 6, complexity: 7,
      terrainComplexity: 7, airAccessibility: 6, centerImportance: 6,
      matchup: RaceMatchup(tvzTerranWinRate: 49),
    ),
    const GameMap(
      id: '신추풍령', name: '신추풍령',
      rushDistance: 6, resources: 6, complexity: 8,
      terrainComplexity: 8, airAccessibility: 6, centerImportance: 6,
      matchup: RaceMatchup(tvzTerranWinRate: 55),
    ),
  ],

  // 4. 공중맵 (airAccessibility ≥ 7)
  '공중맵': [
    const GameMap(
      id: '네오그라운드제로', name: '네오그라운드제로',
      rushDistance: 7, resources: 7, complexity: 4,
      terrainComplexity: 4, airAccessibility: 7, centerImportance: 8,
      matchup: RaceMatchup(tvzTerranWinRate: 55),
    ),
    const GameMap(
      id: '네오제이드', name: '네오제이드',
      rushDistance: 7, resources: 6, complexity: 5,
      terrainComplexity: 5, airAccessibility: 7, centerImportance: 4,
      matchup: RaceMatchup(tvzTerranWinRate: 50),
    ),
    const GameMap(
      id: '블리츠X', name: '블리츠X',
      rushDistance: 8, resources: 6, complexity: 7,
      terrainComplexity: 7, airAccessibility: 8, centerImportance: 4,
      matchup: RaceMatchup(tvzTerranWinRate: 48),
    ),
  ],

  // 5. 섬맵 (hasIsland = true)
  '섬맵': [
    const GameMap(
      id: '몬테크리스토', name: '몬테크리스토',
      rushDistance: 7, resources: 7, complexity: 8,
      terrainComplexity: 8, airAccessibility: 7, centerImportance: 6,
      hasIsland: true,
      matchup: RaceMatchup(tvzTerranWinRate: 45),
    ),
    const GameMap(
      id: '플라즈마', name: '플라즈마',
      rushDistance: 4, resources: 4, complexity: 8,
      terrainComplexity: 8, airAccessibility: 4, centerImportance: 8,
      hasIsland: true,
      matchup: RaceMatchup(tvzTerranWinRate: 60),
    ),
    const GameMap(
      id: '왕의귀환', name: '왕의귀환',
      rushDistance: 6, resources: 7, complexity: 6,
      terrainComplexity: 6, airAccessibility: 6, centerImportance: 6,
      hasIsland: true,
      matchup: RaceMatchup(tvzTerranWinRate: 52),
    ),
  ],

  // 6. 밸런스맵 (중간 수치)
  '밸런스맵': [
    const GameMap(
      id: '파이썬', name: '파이썬',
      rushDistance: 6, resources: 6, complexity: 5,
      terrainComplexity: 5, airAccessibility: 6, centerImportance: 6,
      matchup: RaceMatchup(tvzTerranWinRate: 55),
    ),
    const GameMap(
      id: '네오일렉트릭써킷', name: '네오일렉트릭써킷',
      rushDistance: 6, resources: 6, complexity: 6,
      terrainComplexity: 6, airAccessibility: 6, centerImportance: 6,
      matchup: RaceMatchup(tvzTerranWinRate: 52),
    ),
    const GameMap(
      id: '타우크로스', name: '타우크로스',
      rushDistance: 6, resources: 7, complexity: 3,
      terrainComplexity: 3, airAccessibility: 6, centerImportance: 6,
      matchup: RaceMatchup(tvzTerranWinRate: 50),
    ),
  ],
};

void main() {
  test('맵 유형별 TvZ 승률 분석 (각 200회)', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('=== 맵 유형별 TvZ 승률 분석 (200회) ===\n');

    const runs = 200;

    // 카테고리별 합산
    final catWins = <String, int>{};
    final catGames = <String, int>{};

    for (final entry in _mapCategories.entries) {
      final category = entry.key;
      final maps = entry.value;
      buf.writeln('[$category]');

      int catTotalWins = 0;
      int catTotalGames = 0;

      for (final map in maps) {
        int tWins = 0;
        int totalLines = 0;
        int shortGames = 0;  // ≤30줄
        int longGames = 0;   // ≥70줄

        for (int i = 0; i < runs; i++) {
          final home = _makePlayer(name: 'Terran', race: Race.terran);
          final away = _makePlayer(name: 'Zerg', race: Race.zerg);

          final stream = service.simulateMatchWithLog(
            homePlayer: home,
            awayPlayer: away,
            map: map,
            getIntervalMs: () => 0,
          );

          SimulationState? last;
          await for (final state in stream) {
            last = state;
          }

          if (last != null) {
            if (last.homeWin == true) tWins++;
            totalLines += last.battleLogEntries.length;
            if (last.battleLogEntries.length <= 30) shortGames++;
            if (last.battleLogEntries.length >= 70) longGames++;
          }
        }

        final winRate = (tWins / runs * 100).toStringAsFixed(1);
        final avgLines = (totalLines / runs).toStringAsFixed(1);
        buf.writeln('  ${map.name.padRight(12)} T $winRate% | '
            '평균${avgLines}줄 | 짧음$shortGames 긴$longGames | '
            'rd=${map.rushDistance} res=${map.resources} '
            'tc=${map.terrainComplexity} air=${map.airAccessibility} '
            'ci=${map.centerImportance} '
            'tvz=${map.matchup.tvzTerranWinRate}');

        catTotalWins += tWins;
        catTotalGames += runs;
      }

      final catRate = (catTotalWins / catTotalGames * 100).toStringAsFixed(1);
      buf.writeln('  → $category 평균: T $catRate% '
          '(${catTotalWins}승/${catTotalGames}경기)');
      buf.writeln('');

      catWins[category] = catTotalWins;
      catGames[category] = catTotalGames;
    }

    // 카테고리 비교 요약
    buf.writeln('=== 맵 유형별 요약 ===');
    for (final cat in _mapCategories.keys) {
      final wr = (catWins[cat]! / catGames[cat]! * 100).toStringAsFixed(1);
      buf.writeln('  ${cat.padRight(8)} T $wr% (${catWins[cat]}/${catGames[cat]})');
    }

    buf.writeln('\n※ BAL 스탯 650 올 | 빌드 자동선택');
    print(buf.toString());
  }, timeout: const Timeout(Duration(minutes: 30)));
}
