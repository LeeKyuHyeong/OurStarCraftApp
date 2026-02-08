// 스나이핑/레벨 보정 테스트
// 실행: flutter test test/sniping_level_test.dart

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
    resources: 5,
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

  // 동일 능력치 테란 두 명 (레벨만 다를 수 있음)
  Player makeTerran({
    required String id,
    required String name,
    required int levelValue,
    int statValue = 500,
    int? experience,
  }) {
    return Player(
      id: id,
      name: name,
      raceIndex: Race.terran.index,
      stats: PlayerStats(
        sense: statValue,
        control: statValue,
        attack: statValue,
        harass: statValue,
        strategy: statValue,
        macro: statValue,
        defense: statValue,
        scout: statValue,
      ),
      levelValue: levelValue,
      condition: 100,
      experience: experience,
    );
  }

  setUp(() {
    service = MatchSimulationService();
  });

  group('스나이핑 보정 테스트', () {
    test('homeSnipingBonus=20 시 승률 약 +20% 상승', () {
      final playerA = makeTerran(id: 'a', name: 'A', levelValue: 5);
      final playerB = makeTerran(id: 'b', name: 'B', levelValue: 5);

      // 스나이핑 없이 기준 승률 측정
      double baseSum = 0;
      for (int i = 0; i < 200; i++) {
        baseSum += service.calculateWinRate(
          homePlayer: playerA,
          awayPlayer: playerB,
          map: balancedMap,
        );
      }
      final baseAvg = baseSum / 200;

      // 스나이핑 +20 적용
      double snipedSum = 0;
      for (int i = 0; i < 200; i++) {
        snipedSum += service.calculateWinRate(
          homePlayer: playerA,
          awayPlayer: playerB,
          map: balancedMap,
          homeSnipingBonus: 20,
        );
      }
      final snipedAvg = snipedSum / 200;

      final diff = snipedAvg - baseAvg;
      print('스나이핑 보정: 기준 ${(baseAvg * 100).toStringAsFixed(1)}% → 스나이핑 ${(snipedAvg * 100).toStringAsFixed(1)}% (차이: ${(diff * 100).toStringAsFixed(1)}%)');

      // 스나이핑 +20은 20%p 상승이므로, 실제 차이가 15~25%p 범위
      expect(diff, greaterThanOrEqualTo(0.10));
      expect(diff, lessThanOrEqualTo(0.30));
    });

    test('awaySnipingBonus=20 시 홈 승률 약 -20% 하락', () {
      final playerA = makeTerran(id: 'a', name: 'A', levelValue: 5);
      final playerB = makeTerran(id: 'b', name: 'B', levelValue: 5);

      double baseSum = 0;
      for (int i = 0; i < 200; i++) {
        baseSum += service.calculateWinRate(
          homePlayer: playerA,
          awayPlayer: playerB,
          map: balancedMap,
        );
      }
      final baseAvg = baseSum / 200;

      double snipedSum = 0;
      for (int i = 0; i < 200; i++) {
        snipedSum += service.calculateWinRate(
          homePlayer: playerA,
          awayPlayer: playerB,
          map: balancedMap,
          awaySnipingBonus: 20,
        );
      }
      final snipedAvg = snipedSum / 200;

      final diff = baseAvg - snipedAvg;
      print('어웨이 스나이핑: 기준 ${(baseAvg * 100).toStringAsFixed(1)}% → 어웨이스나이핑 ${(snipedAvg * 100).toStringAsFixed(1)}% (차이: ${(diff * 100).toStringAsFixed(1)}%)');

      expect(diff, greaterThanOrEqualTo(0.10));
      expect(diff, lessThanOrEqualTo(0.30));
    });
  });

  group('레벨 보정 테스트', () {
    test('레벨15 vs 레벨5 → 약 +20% 보정', () {
      // 레벨15: experience >= 45000
      final highLevel = makeTerran(
        id: 'high',
        name: '고레벨',
        levelValue: 5,
        experience: 45000, // 레벨 15
      );
      // 레벨5: experience >= 1800
      final lowLevel = makeTerran(
        id: 'low',
        name: '저레벨',
        levelValue: 5,
        experience: 1800, // 레벨 5
      );

      // 레벨 확인
      expect(highLevel.level.value, 15);
      expect(lowLevel.level.value, 5);

      // 기준: 동일 레벨
      final sameLevel = makeTerran(
        id: 'same',
        name: '동레벨',
        levelValue: 5,
        experience: 1800,
      );

      double baseSum = 0;
      for (int i = 0; i < 200; i++) {
        baseSum += service.calculateWinRate(
          homePlayer: sameLevel,
          awayPlayer: lowLevel.copyWith(id: 'low2', name: '저레벨2'),
          map: balancedMap,
        );
      }
      final baseAvg = baseSum / 200;

      double levelSum = 0;
      for (int i = 0; i < 200; i++) {
        levelSum += service.calculateWinRate(
          homePlayer: highLevel,
          awayPlayer: lowLevel,
          map: balancedMap,
        );
      }
      final levelAvg = levelSum / 200;

      final diff = levelAvg - baseAvg;
      print('레벨 보정: 동레벨 ${(baseAvg * 100).toStringAsFixed(1)}% → 레벨15vs5 ${(levelAvg * 100).toStringAsFixed(1)}% (차이: ${(diff * 100).toStringAsFixed(1)}%)');

      // 레벨 차이 10 → 20%p 보정, 실제는 빌드 상성 등 노이즈 포함하므로 넓은 범위
      expect(diff, greaterThanOrEqualTo(0.10));
      expect(diff, lessThanOrEqualTo(0.30));
    });

    test('레벨당 +2% 보정 확인 (레벨10 vs 레벨5)', () {
      final level10 = makeTerran(
        id: 'lv10',
        name: '레벨10',
        levelValue: 5,
        experience: 12000, // 레벨 10
      );
      final level5 = makeTerran(
        id: 'lv5',
        name: '레벨5',
        levelValue: 5,
        experience: 1800, // 레벨 5
      );

      expect(level10.level.value, 10);
      expect(level5.level.value, 5);

      // 레벨5 vs 레벨5 기준
      double baseSum = 0;
      for (int i = 0; i < 200; i++) {
        baseSum += service.calculateWinRate(
          homePlayer: level5,
          awayPlayer: level5.copyWith(id: 'lv5_2', name: '레벨5b'),
          map: balancedMap,
        );
      }
      final baseAvg = baseSum / 200;

      // 레벨10 vs 레벨5
      double levelSum = 0;
      for (int i = 0; i < 200; i++) {
        levelSum += service.calculateWinRate(
          homePlayer: level10,
          awayPlayer: level5,
          map: balancedMap,
        );
      }
      final levelAvg = levelSum / 200;

      final diff = levelAvg - baseAvg;
      print('레벨10vs5 보정: 기준 ${(baseAvg * 100).toStringAsFixed(1)}% → 레벨10vs5 ${(levelAvg * 100).toStringAsFixed(1)}% (차이: ${(diff * 100).toStringAsFixed(1)}%)');

      // 레벨 차이 5 → 10%p 보정 기대, 빌드 노이즈 포함 넓은 범위
      expect(diff, greaterThanOrEqualTo(0.04));
      expect(diff, lessThanOrEqualTo(0.20));
    });
  });

  group('복합 보정 테스트', () {
    test('스나이핑 + 레벨 + 맵 보정 동시 적용 시 clamp(3%, 97%)', () {
      // 모든 보정을 극대화: 높은 레벨 + 스나이핑 + 높은 능력치
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
        experience: 180000, // 레벨 20
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

      // 스나이핑까지 추가하여 극단 보정
      for (int i = 0; i < 100; i++) {
        final wr = service.calculateWinRate(
          homePlayer: godPlayer,
          awayPlayer: weakPlayer,
          map: balancedMap,
          homeSnipingBonus: 20,
        );
        // clamp(3%, 97%) 확인
        expect(wr, greaterThanOrEqualTo(0.03));
        expect(wr, lessThanOrEqualTo(0.97));
      }
      print('극대 보정 (신 + 스나이핑20 vs 약자): clamp 3~97% 확인 완료');
    });

    test('반대 극단: 최약 + 불리 보정 시에도 clamp(3%, 97%)', () {
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

      // 약자 홈, 신 원정 + 원정 스나이핑
      for (int i = 0; i < 100; i++) {
        final wr = service.calculateWinRate(
          homePlayer: weakPlayer,
          awayPlayer: godPlayer,
          map: balancedMap,
          awaySnipingBonus: 20,
        );
        expect(wr, greaterThanOrEqualTo(0.03));
        expect(wr, lessThanOrEqualTo(0.97));
      }
      print('반대 극단 (약자 vs 신 + 어웨이스나이핑20): clamp 3~97% 확인 완료');
    });

    test('simulateMatch도 복합 보정 반영', () {
      // 높은 레벨 + 스나이핑으로 100회 시뮬레이션
      final highLevel = makeTerran(
        id: 'high',
        name: '고레벨',
        levelValue: 5,
        experience: 45000, // 레벨 15
      );
      final lowLevel = makeTerran(
        id: 'low',
        name: '저레벨',
        levelValue: 5,
        experience: 1800, // 레벨 5
      );

      int homeWins = 0;
      for (int i = 0; i < 100; i++) {
        final result = service.simulateMatch(
          homePlayer: highLevel,
          awayPlayer: lowLevel,
          map: balancedMap,
          homeSnipingBonus: 20,
        );
        if (result.homeWin) homeWins++;
      }
      final winRate = homeWins / 100.0;
      print('simulateMatch 복합(레벨15+스나이핑20 vs 레벨5): $homeWins승/100 (${(winRate * 100).toStringAsFixed(1)}%)');

      // 레벨+20% + 스나이핑+20% → 대략 90% 근처 기대 (clamp로 최대 97%)
      expect(winRate, greaterThanOrEqualTo(0.60));
    });
  });
}
