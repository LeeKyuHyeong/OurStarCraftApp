// 6개 종족전 밸런스 테스트 (각 100회 시뮬레이션)
// 실행: flutter test test/full_balance_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  late MatchSimulationService service;

  // 균형 맵 (50/50/50)
  final balancedMap = GameMap(
    id: 'test_balanced',
    name: '밸런스맵',
    rushDistance: 5,
    resources: 6,
    complexity: 6,
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

  // ========== B+ 동급 선수들 (능력치 합 ~4000) ==========

  // 밸런스형 테란 B+
  final terranBPlus = Player(
    id: 'terran_b_plus',
    name: '테란선수',
    raceIndex: Race.terran.index,
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

  // 밸런스형 저그 B+
  final zergBPlus = Player(
    id: 'zerg_b_plus',
    name: '저그선수',
    raceIndex: Race.zerg.index,
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

  // 밸런스형 프로토스 B+
  final protossBPlus = Player(
    id: 'protoss_b_plus',
    name: '프토선수',
    raceIndex: Race.protoss.index,
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

  // ========== S급 선수 (능력치 합 ~6000) ==========

  final terranSGrade = Player(
    id: 'terran_s',
    name: 'S테란',
    raceIndex: Race.terran.index,
    stats: const PlayerStats(
      sense: 750,
      control: 750,
      attack: 750,
      harass: 750,
      strategy: 750,
      macro: 750,
      defense: 750,
      scout: 750,
    ),
    levelValue: 8,
    condition: 100,
  );

  // ========== C급 선수 (능력치 합 ~2800) ==========

  final terranCGrade = Player(
    id: 'terran_c',
    name: 'C테란',
    raceIndex: Race.terran.index,
    stats: const PlayerStats(
      sense: 350,
      control: 350,
      attack: 350,
      harass: 350,
      strategy: 350,
      macro: 350,
      defense: 350,
      scout: 350,
    ),
    levelValue: 3,
    condition: 100,
  );

  final zergCGrade = Player(
    id: 'zerg_c',
    name: 'C저그',
    raceIndex: Race.zerg.index,
    stats: const PlayerStats(
      sense: 350,
      control: 350,
      attack: 350,
      harass: 350,
      strategy: 350,
      macro: 350,
      defense: 350,
      scout: 350,
    ),
    levelValue: 3,
    condition: 100,
  );

  // ========== 공격형 선수 (B+, 공격 치우침) ==========

  final attackTerran = Player(
    id: 'attack_terran',
    name: '공격테란',
    raceIndex: Race.terran.index,
    stats: const PlayerStats(
      sense: 650,
      control: 700,
      attack: 750,
      harass: 700,
      strategy: 350,
      macro: 300,
      defense: 300,
      scout: 450,
    ),
    levelValue: 5,
    condition: 100,
  );

  // ========== 운영형 선수 (B+, 수비 치우침) ==========

  final defenseTerran = Player(
    id: 'defense_terran',
    name: '운영테란',
    raceIndex: Race.terran.index,
    stats: const PlayerStats(
      sense: 450,
      control: 400,
      attack: 300,
      harass: 350,
      strategy: 700,
      macro: 750,
      defense: 750,
      scout: 500,
    ),
    levelValue: 5,
    condition: 100,
  );

  setUp(() {
    service = MatchSimulationService();
  });

  // 유틸: N회 시뮬레이션 후 홈 승수 반환
  int runSimulations(Player home, Player away, GameMap map, int count) {
    int homeWins = 0;
    for (int i = 0; i < count; i++) {
      final result = service.simulateMatch(
        homePlayer: home,
        awayPlayer: away,
        map: map,
      );
      if (result.homeWin) homeWins++;
    }
    return homeWins;
  }

  group('동급 승률 테스트 (B+ vs B+, 100회)', () {
    test('TvZ 동급 승률 35~65% 범위', () {
      final wins = runSimulations(terranBPlus, zergBPlus, balancedMap, 100);
      final winRate = wins / 100.0;
      print('TvZ 동급: 테란 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });

    test('TvP 동급 승률 35~65% 범위', () {
      final wins = runSimulations(terranBPlus, protossBPlus, balancedMap, 100);
      final winRate = wins / 100.0;
      print('TvP 동급: 테란 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });

    test('TvT 동급 승률 35~65% 범위', () {
      final terranBPlus2 = terranBPlus.copyWith(
        id: 'terran_b_plus_2',
        name: '테란선수2',
      );
      final wins = runSimulations(terranBPlus, terranBPlus2, balancedMap, 100);
      final winRate = wins / 100.0;
      print('TvT 동급: 테란1 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });

    test('ZvP 동급 승률 35~65% 범위', () {
      final wins = runSimulations(zergBPlus, protossBPlus, balancedMap, 100);
      final winRate = wins / 100.0;
      print('ZvP 동급: 저그 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });

    test('ZvZ 동급 승률 35~65% 범위', () {
      final zergBPlus2 = zergBPlus.copyWith(
        id: 'zerg_b_plus_2',
        name: '저그선수2',
      );
      final wins = runSimulations(zergBPlus, zergBPlus2, balancedMap, 100);
      final winRate = wins / 100.0;
      print('ZvZ 동급: 저그1 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });

    test('PvP 동급 승률 35~65% 범위', () {
      final protossBPlus2 = protossBPlus.copyWith(
        id: 'protoss_b_plus_2',
        name: '프토선수2',
      );
      final wins = runSimulations(protossBPlus, protossBPlus2, balancedMap, 100);
      final winRate = wins / 100.0;
      print('PvP 동급: 프토1 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.35));
      expect(winRate, lessThanOrEqualTo(0.65));
    });
  });

  group('등급 차이 테스트 (S급 vs C급, 100회)', () {
    test('S테란 vs C테란: S급 70%+ 우세', () {
      final wins = runSimulations(terranSGrade, terranCGrade, balancedMap, 100);
      final winRate = wins / 100.0;
      print('S테란 vs C테란: S급 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.70));
    });

    test('S테란 vs C저그: S급 70%+ 우세', () {
      final wins = runSimulations(terranSGrade, zergCGrade, balancedMap, 100);
      final winRate = wins / 100.0;
      print('S테란 vs C저그: S급 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.70));
    });

    test('등급 차이 방향 일관성: C급 < S급', () {
      // C급이 홈이어도 S급이 더 많이 이겨야 함
      final wins = runSimulations(terranCGrade, terranSGrade, balancedMap, 100);
      final winRate = wins / 100.0;
      print('C테란(홈) vs S테란(원정): C급 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, lessThanOrEqualTo(0.30));
    });
  });

  group('빌드 스타일 상성 테스트 (100회)', () {
    test('공격형 vs 운영형 TvT: 극단 편향 없이 양쪽 승리', () {
      final wins = runSimulations(attackTerran, defenseTerran, balancedMap, 100);
      final winRate = wins / 100.0;
      print('공격형 vs 운영형 TvT: 공격형 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      // 극단적 편향(90%+ 또는 10%-) 아닌지 확인
      expect(winRate, greaterThanOrEqualTo(0.15));
      expect(winRate, lessThanOrEqualTo(0.85));
    });

    test('운영형 vs 공격형 TvT: 극단 편향 없이 양쪽 승리', () {
      final wins = runSimulations(defenseTerran, attackTerran, balancedMap, 100);
      final winRate = wins / 100.0;
      print('운영형 vs 공격형 TvT: 운영형 $wins승 / 100경기 (${(winRate * 100).toStringAsFixed(1)}%)');
      expect(winRate, greaterThanOrEqualTo(0.15));
      expect(winRate, lessThanOrEqualTo(0.85));
    });
  });

  group('calculateWinRate 직접 검증', () {
    test('완전 동일 선수 미러매치 → 약 50%', () {
      // 100회 호출하여 평균이 45~55% 범위인지 확인
      double sum = 0;
      for (int i = 0; i < 100; i++) {
        sum += service.calculateWinRate(
          homePlayer: terranBPlus,
          awayPlayer: terranBPlus.copyWith(id: 'mirror', name: 'mirror'),
          map: balancedMap,
        );
      }
      final avgWinRate = sum / 100;
      print('미러매치 평균 calculateWinRate: ${(avgWinRate * 100).toStringAsFixed(1)}%');
      expect(avgWinRate, greaterThanOrEqualTo(0.40));
      expect(avgWinRate, lessThanOrEqualTo(0.60));
    });

    test('S급 vs C급 calculateWinRate → 70%+', () {
      double sum = 0;
      for (int i = 0; i < 100; i++) {
        sum += service.calculateWinRate(
          homePlayer: terranSGrade,
          awayPlayer: terranCGrade,
          map: balancedMap,
        );
      }
      final avgWinRate = sum / 100;
      print('S급 vs C급 평균 calculateWinRate: ${(avgWinRate * 100).toStringAsFixed(1)}%');
      expect(avgWinRate, greaterThanOrEqualTo(0.70));
    });

    test('winRate clamp 3~97% 범위', () {
      // 극단적 능력치 차이로도 3~97% 범위 내
      final godPlayer = Player(
        id: 'god',
        name: '신',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 999, control: 999, attack: 999, harass: 999,
          strategy: 999, macro: 999, defense: 999, scout: 999,
        ),
        levelValue: 10,
        condition: 100,
        experience: 180000,
      );
      final weakPlayer = Player(
        id: 'weak',
        name: '약자',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 1, control: 1, attack: 1, harass: 1,
          strategy: 1, macro: 1, defense: 1, scout: 1,
        ),
        levelValue: 1,
        condition: 100,
      );

      for (int i = 0; i < 50; i++) {
        final wr = service.calculateWinRate(
          homePlayer: godPlayer,
          awayPlayer: weakPlayer,
          map: balancedMap,
        );
        expect(wr, greaterThanOrEqualTo(0.03));
        expect(wr, lessThanOrEqualTo(0.97));
      }
    });
  });
}
