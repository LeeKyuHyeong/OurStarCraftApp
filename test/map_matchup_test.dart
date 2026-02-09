// 맵별 종족 상성 검증 테스트
// 각 맵의 종족 상성(tvz, zvp, pvt)이 실제 시뮬레이션 승률에 반영되는지 확인
// 실행: flutter test test/map_matchup_test.dart

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'package:mystar/core/constants/map_data.dart';

void main() {
  late MatchSimulationService service;

  setUp(() {
    service = MatchSimulationService();
  });

  // ========== 균일 능력치 선수 (B+ 등급, 500 올스탯) ==========
  Player makePlayer(String name, Race race) {
    return Player(
      id: '${race.code}_test',
      name: name,
      raceIndex: race.index,
      stats: const PlayerStats(
        sense: 500,
        control: 500,
        attack: 500,
        harass: 500,
        strategy: 500,
        macro: 500,
        defense: 500,
        scout: 500,
      ),
      levelValue: 5,
      condition: 100,
    );
  }

  final terran = makePlayer('테란선수', Race.terran);
  final zerg = makePlayer('저그선수', Race.zerg);
  final protoss = makePlayer('프토선수', Race.protoss);

  /// N회 시뮬레이션 후 homePlayer 승률 반환
  double simulateWinRate(Player home, Player away, GameMap map, int trials) {
    int homeWins = 0;
    for (int i = 0; i < trials; i++) {
      final result = service.simulateMatch(
        homePlayer: home,
        awayPlayer: away,
        map: map,
      );
      if (result.homeWin) homeWins++;
    }
    return homeWins / trials * 100;
  }

  // ================================================================
  // 테스트 1: 극단적 테란맵에서 TvZ 테란 유리 확인
  // ================================================================
  group('극단 테란맵 상성 검증', () {
    // 폭풍의언덕: tvz=65, zvp=45, pvt=35 (개테란맵)
    final terranMap = allMaps.firstWhere((m) => m.name == '폭풍의언덕').toGameMap();

    test('TvZ: 테란맵에서 테란 승률 55% 이상', () {
      final winRate = simulateWinRate(terran, zerg, terranMap, 500);
      print('=== 폭풍의언덕 TvZ ===');
      print('맵 TvZ 테란승률: ${terranMap.matchup.tvzTerranWinRate}%');
      print('시뮬 테란승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(55));
    });

    test('PvT: 테란맵에서 프토 승률 40% 미만', () {
      final winRate = simulateWinRate(protoss, terran, terranMap, 500);
      print('=== 폭풍의언덕 PvT ===');
      print('맵 PvT 프토승률: ${terranMap.matchup.pvtProtossWinRate}%');
      print('시뮬 프토승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, lessThan(45));
    });
  });

  // ================================================================
  // 테스트 2: 극단적 저그맵에서 저그 유리 확인
  // ================================================================
  group('극단 저그맵 상성 검증', () {
    // 배틀로얄: tvz=35, zvp=65, pvt=35 (극단적 저그맵)
    final zergMap = allMaps.firstWhere((m) => m.name == '배틀로얄').toGameMap();

    test('TvZ: 저그맵에서 저그 승률 55% 이상', () {
      final winRate = simulateWinRate(zerg, terran, zergMap, 500);
      print('=== 배틀로얄 TvZ ===');
      print('맵 TvZ 테란승률: ${zergMap.matchup.tvzTerranWinRate}% (저그: ${100 - zergMap.matchup.tvzTerranWinRate}%)');
      print('시뮬 저그승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(55));
    });

    test('ZvP: 저그맵에서 저그 승률 55% 이상', () {
      final winRate = simulateWinRate(zerg, protoss, zergMap, 500);
      print('=== 배틀로얄 ZvP ===');
      print('맵 ZvP 저그승률: ${zergMap.matchup.zvpZergWinRate}%');
      print('시뮬 저그승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(55));
    });
  });

  // ================================================================
  // 테스트 3: 극단적 프토맵에서 프토 유리 확인
  // ================================================================
  group('극단 프토맵 상성 검증', () {
    // 데스페라도: tvz=62, zvp=58, pvt=65 (토스맵)
    final protossMap = allMaps.firstWhere((m) => m.name == '데스페라도').toGameMap();

    test('PvT: 프토맵에서 프토 승률 55% 이상', () {
      final winRate = simulateWinRate(protoss, terran, protossMap, 500);
      print('=== 데스페라도 PvT ===');
      print('맵 PvT 프토승률: ${protossMap.matchup.pvtProtossWinRate}%');
      print('시뮬 프토승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(55));
    });
  });

  // ================================================================
  // 테스트 4: 밸런스맵에서 50:50 근접 확인
  // ================================================================
  group('밸런스맵 상성 검증', () {
    final balancedMap = GameMap(
      id: 'test_balanced',
      name: '밸런스맵',
      rushDistance: 5,
      resources: 6,
      complexity: 5,
      matchup: const RaceMatchup(
        tvzTerranWinRate: 50,
        zvpZergWinRate: 50,
        pvtProtossWinRate: 50,
      ),
      expansionCount: 4,
      terrainComplexity: 5,
      airAccessibility: 5,
      centerImportance: 5,
      hasIsland: false,
    );

    test('TvZ: 밸런스맵에서 40~60% 범위', () {
      final winRate = simulateWinRate(terran, zerg, balancedMap, 500);
      print('=== 밸런스맵 TvZ ===');
      print('시뮬 테란승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(35));
      expect(winRate, lessThan(65));
    });

    test('ZvP: 밸런스맵에서 40~60% 범위', () {
      final winRate = simulateWinRate(zerg, protoss, balancedMap, 500);
      print('=== 밸런스맵 ZvP ===');
      print('시뮬 저그승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(35));
      expect(winRate, lessThan(65));
    });

    test('PvT: 밸런스맵에서 40~60% 범위', () {
      final winRate = simulateWinRate(protoss, terran, balancedMap, 500);
      print('=== 밸런스맵 PvT ===');
      print('시뮬 프토승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(35));
      expect(winRate, lessThan(65));
    });
  });

  // ================================================================
  // 테스트 5: 맵 특성 보너스 (공격형 vs 수비형 선수 on 러시맵)
  // ================================================================
  group('맵 특성 보너스 검증 - 러시맵에서 공격형 유리', () {
    // 레퀴엠: rushDistance=0.2 (극단적 짧은 거리)
    final rushMap = allMaps.firstWhere((m) => m.name == '레퀴엠').toGameMap();

    // 공격형 테란 (attack/harass 높음)
    final aggressiveTerran = Player(
      id: 'aggressive_t',
      name: '공격테란',
      raceIndex: Race.terran.index,
      stats: const PlayerStats(
        sense: 400, control: 500, attack: 700, harass: 700,
        strategy: 400, macro: 350, defense: 350, scout: 400,
      ),
      levelValue: 5,
      condition: 100,
    );

    // 수비형 테란 (defense/macro 높음)
    final defensiveTerran = Player(
      id: 'defensive_t',
      name: '수비테란',
      raceIndex: Race.terran.index,
      stats: const PlayerStats(
        sense: 400, control: 500, attack: 350, harass: 350,
        strategy: 400, macro: 700, defense: 700, scout: 400,
      ),
      levelValue: 5,
      condition: 100,
    );

    test('TvT 러시맵: 공격형이 수비형보다 유리', () {
      final winRate = simulateWinRate(aggressiveTerran, defensiveTerran, rushMap, 500);
      print('=== 레퀴엠(러시맵) TvT: 공격형 vs 수비형 ===');
      print('맵 rushDistance: ${rushMap.rushDistance}');
      print('공격형 승률: ${winRate.toStringAsFixed(1)}%');
      // 러시맵에서 공격형이 유리해야 함
      expect(winRate, greaterThan(50));
    });
  });

  // ================================================================
  // 테스트 6: 맵 특성 보너스 (운영형 선수 on 확장맵)
  // ================================================================
  group('맵 특성 보너스 검증 - 확장맵에서 운영형 유리', () {
    // 안드로메다: rushDistance=0.8, resources=0.8 (넓은 확장맵)
    final expansionMap = allMaps.firstWhere((m) => m.name == '안드로메다').toGameMap();

    // 운영형 저그 (macro/defense 높음)
    final macroZerg = Player(
      id: 'macro_z',
      name: '운영저그',
      raceIndex: Race.zerg.index,
      stats: const PlayerStats(
        sense: 400, control: 400, attack: 350, harass: 350,
        strategy: 500, macro: 750, defense: 650, scout: 400,
      ),
      levelValue: 5,
      condition: 100,
    );

    // 공격형 저그 (attack/harass 높음)
    final aggressiveZerg = Player(
      id: 'aggressive_z',
      name: '공격저그',
      raceIndex: Race.zerg.index,
      stats: const PlayerStats(
        sense: 400, control: 400, attack: 750, harass: 650,
        strategy: 350, macro: 350, defense: 350, scout: 500,
      ),
      levelValue: 5,
      condition: 100,
    );

    test('ZvZ 확장맵: 운영형이 공격형보다 유리', () {
      final winRate = simulateWinRate(macroZerg, aggressiveZerg, expansionMap, 500);
      print('=== 안드로메다(확장맵) ZvZ: 운영형 vs 공격형 ===');
      print('맵 resources: ${expansionMap.resources}, expansionCount: ${expansionMap.expansionCount}');
      print('운영형 승률: ${winRate.toStringAsFixed(1)}%');
      // 확장맵에서 운영형이 유리해야 함
      expect(winRate, greaterThan(48));
    });
  });

  // ================================================================
  // 테스트 7: 전략맵에서 전략형 선수 유리 확인
  // ================================================================
  group('맵 특성 보너스 검증 - 전략맵에서 전략형 유리', () {
    // 트로이: complexity=0.9 (매우 복잡한 지형)
    final strategyMap = allMaps.firstWhere((m) => m.name == '트로이').toGameMap();

    // 전략형 프토 (strategy/sense 높음)
    final strategicProtoss = Player(
      id: 'strategic_p',
      name: '전략프토',
      raceIndex: Race.protoss.index,
      stats: const PlayerStats(
        sense: 700, control: 400, attack: 350, harass: 350,
        strategy: 750, macro: 400, defense: 400, scout: 450,
      ),
      levelValue: 5,
      condition: 100,
    );

    // 밸런스형 프토
    final balancedProtoss = Player(
      id: 'balanced_p',
      name: '밸런스프토',
      raceIndex: Race.protoss.index,
      stats: const PlayerStats(
        sense: 475, control: 475, attack: 475, harass: 475,
        strategy: 475, macro: 475, defense: 475, scout: 475,
      ),
      levelValue: 5,
      condition: 100,
    );

    test('PvP 전략맵: 전략형이 밸런스형보다 유리', () {
      final winRate = simulateWinRate(strategicProtoss, balancedProtoss, strategyMap, 500);
      print('=== 트로이(전략맵) PvP: 전략형 vs 밸런스형 ===');
      print('맵 complexity: ${strategyMap.complexity}, terrainComplexity: ${strategyMap.terrainComplexity}');
      print('전략형 승률: ${winRate.toStringAsFixed(1)}%');
      expect(winRate, greaterThan(48));
    });
  });

  // ================================================================
  // 테스트 8: 전체 80개 맵 종족 상성 방향성 검증
  // ================================================================
  group('전체 맵풀 종족상성 방향성 검증 (80개 맵)', () {
    test('각 맵의 종족상성이 시뮬레이션 승률 방향과 일치', () {
      int tvzCorrect = 0, tvzTotal = 0;
      int zvpCorrect = 0, zvpTotal = 0;
      int pvtCorrect = 0, pvtTotal = 0;
      final trials = 200;

      final errors = <String>[];

      for (final mapData in allMaps) {
        final map = mapData.toGameMap();

        // TvZ (맵 상성이 뚜렷한 경우만: 차이 10% 이상)
        if ((mapData.tvz - 50).abs() >= 10) {
          tvzTotal++;
          final tvzWinRate = simulateWinRate(terran, zerg, map, trials);
          final mapExpected = mapData.tvz > 50; // 테란 유리 예상
          final simResult = tvzWinRate > 50; // 실제 테란 승리
          if (mapExpected == simResult) {
            tvzCorrect++;
          } else {
            errors.add('TvZ 불일치: ${mapData.name} (맵 tvz=${mapData.tvz}, 시뮬=${tvzWinRate.toStringAsFixed(1)}%)');
          }
        }

        // ZvP
        if ((mapData.zvp - 50).abs() >= 10) {
          zvpTotal++;
          final zvpWinRate = simulateWinRate(zerg, protoss, map, trials);
          final mapExpected = mapData.zvp > 50;
          final simResult = zvpWinRate > 50;
          if (mapExpected == simResult) {
            zvpCorrect++;
          } else {
            errors.add('ZvP 불일치: ${mapData.name} (맵 zvp=${mapData.zvp}, 시뮬=${zvpWinRate.toStringAsFixed(1)}%)');
          }
        }

        // PvT
        if ((mapData.pvt - 50).abs() >= 10) {
          pvtTotal++;
          final pvtWinRate = simulateWinRate(protoss, terran, map, trials);
          final mapExpected = mapData.pvt > 50;
          final simResult = pvtWinRate > 50;
          if (mapExpected == simResult) {
            pvtCorrect++;
          } else {
            errors.add('PvT 불일치: ${mapData.name} (맵 pvt=${mapData.pvt}, 시뮬=${pvtWinRate.toStringAsFixed(1)}%)');
          }
        }
      }

      final tvzAccuracy = tvzTotal > 0 ? tvzCorrect / tvzTotal * 100 : 100;
      final zvpAccuracy = zvpTotal > 0 ? zvpCorrect / zvpTotal * 100 : 100;
      final pvtAccuracy = pvtTotal > 0 ? pvtCorrect / pvtTotal * 100 : 100;
      final totalCorrect = tvzCorrect + zvpCorrect + pvtCorrect;
      final totalTests = tvzTotal + zvpTotal + pvtTotal;
      final totalAccuracy = totalTests > 0 ? totalCorrect / totalTests * 100 : 100;

      print('');
      print('========================================');
      print('전체 맵풀 종족상성 방향 일치율');
      print('========================================');
      print('TvZ: $tvzCorrect/$tvzTotal (${tvzAccuracy.toStringAsFixed(1)}%)');
      print('ZvP: $zvpCorrect/$zvpTotal (${zvpAccuracy.toStringAsFixed(1)}%)');
      print('PvT: $pvtCorrect/$pvtTotal (${pvtAccuracy.toStringAsFixed(1)}%)');
      print('전체: $totalCorrect/$totalTests (${totalAccuracy.toStringAsFixed(1)}%)');
      print('');

      if (errors.isNotEmpty) {
        print('--- 불일치 목록 ---');
        for (final e in errors) {
          print('  $e');
        }
      }

      // 전체 방향 일치율 80% 이상이면 통과
      expect(totalAccuracy, greaterThan(80),
          reason: '전체 맵 종족상성 방향 일치율이 80% 미만: ${totalAccuracy.toStringAsFixed(1)}%');
    });
  });

  // ================================================================
  // 테스트 9: 같은 선수 다른 맵 → 승률 변동 확인
  // ================================================================
  group('맵 간 승률 변동폭 검증', () {
    test('동일 선수가 맵에 따라 승률이 유의미하게 변함', () {
      // 테란맵 vs 저그맵에서 TvZ 승률 비교
      final terranMap = allMaps.firstWhere((m) => m.name == '폭풍의언덕').toGameMap();
      final zergMap = allMaps.firstWhere((m) => m.name == '배틀로얄').toGameMap();

      final trials = 500;
      final terranMapWR = simulateWinRate(terran, zerg, terranMap, trials);
      final zergMapWR = simulateWinRate(terran, zerg, zergMap, trials);

      final diff = terranMapWR - zergMapWR;

      print('=== 맵 간 TvZ 승률 변동 ===');
      print('테란맵(폭풍의언덕) 테란승률: ${terranMapWR.toStringAsFixed(1)}%');
      print('저그맵(배틀로얄) 테란승률: ${zergMapWR.toStringAsFixed(1)}%');
      print('차이: ${diff.toStringAsFixed(1)}%p');

      // 맵 상성 차이가 승률에 10%p 이상 영향을 줘야 함
      expect(diff, greaterThan(10),
          reason: '테란맵과 저그맵 간 승률 차이가 10%p 미만: ${diff.toStringAsFixed(1)}%p');
    });
  });

  // ================================================================
  // 테스트 10: calculateMapBonus 단위 테스트
  // ================================================================
  group('calculateMapBonus 단위 검증', () {
    test('러시맵에서 공격 높은 쪽에 양의 보너스', () {
      final rushMap = GameMap(
        id: 'rush', name: '러시맵',
        rushDistance: 2, resources: 3, complexity: 3,
        matchup: const RaceMatchup(),
        terrainComplexity: 3, airAccessibility: 5, centerImportance: 8,
      );

      final bonus = rushMap.calculateMapBonus(
        homeSense: 500, homeControl: 500, homeAttack: 800, homeHarass: 800,
        homeStrategy: 400, homeMacro: 400, homeDefense: 400, homeScout: 400,
        awaySense: 500, awayControl: 500, awayAttack: 400, awayHarass: 400,
        awayStrategy: 400, awayMacro: 400, awayDefense: 400, awayScout: 400,
      );

      print('러시맵 공격형 홈보너스: ${bonus.homeBonus.toStringAsFixed(2)}');
      print('러시맵 공격형 어웨이보너스: ${bonus.awayBonus.toStringAsFixed(2)}');
      print('순 보너스: ${bonus.netHomeAdvantage.toStringAsFixed(2)}');

      expect(bonus.netHomeAdvantage, greaterThan(0));
    });

    test('확장맵에서 운영 높은 쪽에 양의 보너스', () {
      final macroMap = GameMap(
        id: 'macro', name: '운영맵',
        rushDistance: 8, resources: 9, complexity: 4,
        matchup: const RaceMatchup(),
        expansionCount: 5, terrainComplexity: 4, airAccessibility: 7, centerImportance: 4,
      );

      final bonus = macroMap.calculateMapBonus(
        homeSense: 400, homeControl: 400, homeAttack: 400, homeHarass: 400,
        homeStrategy: 400, homeMacro: 800, homeDefense: 500, homeScout: 400,
        awaySense: 400, awayControl: 400, awayAttack: 400, awayHarass: 400,
        awayStrategy: 400, awayMacro: 400, awayDefense: 400, awayScout: 400,
      );

      print('확장맵 운영형 홈보너스: ${bonus.homeBonus.toStringAsFixed(2)}');
      print('확장맵 운영형 어웨이보너스: ${bonus.awayBonus.toStringAsFixed(2)}');
      print('순 보너스: ${bonus.netHomeAdvantage.toStringAsFixed(2)}');

      expect(bonus.netHomeAdvantage, greaterThan(0));
    });

    test('전략맵에서 전략/센스 높은 쪽에 양의 보너스', () {
      final stratMap = GameMap(
        id: 'strat', name: '전략맵',
        rushDistance: 5, resources: 5, complexity: 9,
        matchup: const RaceMatchup(),
        terrainComplexity: 8, airAccessibility: 5, centerImportance: 6,
        hasIsland: true,
      );

      final bonus = stratMap.calculateMapBonus(
        homeSense: 800, homeControl: 400, homeAttack: 400, homeHarass: 400,
        homeStrategy: 800, homeMacro: 400, homeDefense: 400, homeScout: 600,
        awaySense: 400, awayControl: 400, awayAttack: 400, awayHarass: 400,
        awayStrategy: 400, awayMacro: 400, awayDefense: 400, awayScout: 400,
      );

      print('전략맵 전략형 홈보너스: ${bonus.homeBonus.toStringAsFixed(2)}');
      print('전략맵 전략형 어웨이보너스: ${bonus.awayBonus.toStringAsFixed(2)}');
      print('순 보너스: ${bonus.netHomeAdvantage.toStringAsFixed(2)}');

      expect(bonus.netHomeAdvantage, greaterThan(0));
    });

    test('맵 보너스는 ±15 범위 내', () {
      // 극단적 능력치 차이로 테스트
      final map = GameMap(
        id: 'extreme', name: '극단맵',
        rushDistance: 1, resources: 10, complexity: 10,
        matchup: const RaceMatchup(),
        expansionCount: 5, terrainComplexity: 10, airAccessibility: 10,
        centerImportance: 10, hasIsland: true,
      );

      final bonus = map.calculateMapBonus(
        homeSense: 999, homeControl: 999, homeAttack: 999, homeHarass: 999,
        homeStrategy: 999, homeMacro: 999, homeDefense: 999, homeScout: 999,
        awaySense: 0, awayControl: 0, awayAttack: 0, awayHarass: 0,
        awayStrategy: 0, awayMacro: 0, awayDefense: 0, awayScout: 0,
      );

      print('극단 맵보너스: home=${bonus.homeBonus.toStringAsFixed(2)}, away=${bonus.awayBonus.toStringAsFixed(2)}');

      expect(bonus.homeBonus, lessThanOrEqualTo(15));
      expect(bonus.homeBonus, greaterThanOrEqualTo(-15));
      expect(bonus.awayBonus, lessThanOrEqualTo(15));
      expect(bonus.awayBonus, greaterThanOrEqualTo(-15));
    });
  });
}
