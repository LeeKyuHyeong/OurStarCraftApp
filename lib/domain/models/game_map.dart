import 'package:hive/hive.dart';
import 'enums.dart';

part 'game_map.g.dart';

/// 종족 상성 (특정 맵에서의 종족간 승률)
@HiveType(typeId: 9)
class RaceMatchup {
  @HiveField(0)
  final int tvzTerranWinRate; // TvZ에서 테란 승률 (0-100)

  @HiveField(1)
  final int zvpZergWinRate; // ZvP에서 저그 승률 (0-100)

  @HiveField(2)
  final int pvtProtossWinRate; // PvT에서 프로토스 승률 (0-100)

  const RaceMatchup({
    this.tvzTerranWinRate = 50,
    this.zvpZergWinRate = 50,
    this.pvtProtossWinRate = 50,
  });

  /// 두 종족 간 상성 계산 (player1의 승률 반환)
  int getWinRate(Race player1Race, Race player2Race) {
    if (player1Race == player2Race) return 50; // 동족전

    if (player1Race == Race.terran && player2Race == Race.zerg) {
      return tvzTerranWinRate;
    }
    if (player1Race == Race.zerg && player2Race == Race.terran) {
      return 100 - tvzTerranWinRate;
    }

    if (player1Race == Race.zerg && player2Race == Race.protoss) {
      return zvpZergWinRate;
    }
    if (player1Race == Race.protoss && player2Race == Race.zerg) {
      return 100 - zvpZergWinRate;
    }

    if (player1Race == Race.protoss && player2Race == Race.terran) {
      return pvtProtossWinRate;
    }
    if (player1Race == Race.terran && player2Race == Race.protoss) {
      return 100 - pvtProtossWinRate;
    }

    return 50;
  }
}

/// 게임 맵 정의
@HiveType(typeId: 10)
class GameMap {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int rushDistance; // 러시거리 (1-10)

  @HiveField(3)
  final int resources; // 자원 (1-10)

  @HiveField(4)
  final int complexity; // 복잡도 (1-10)

  @HiveField(5)
  final RaceMatchup matchup;

  const GameMap({
    required this.id,
    required this.name,
    this.rushDistance = 5,
    this.resources = 5,
    this.complexity = 5,
    this.matchup = const RaceMatchup(),
  });

  /// 러시거리가 짧을수록 공격형 유리
  bool get favorsAggressive => rushDistance <= 4;

  /// 자원이 많을수록 운영형 유리
  bool get favorsMacro => resources >= 7;

  /// 복잡도가 높을수록 전략형 유리
  bool get favorsStrategic => complexity >= 7;
}

/// 기본 맵 목록 (2010 프로리그 시즌맵 기반)
class GameMaps {
  static const neoElectricCircuit = GameMap(
    id: 'neo_electric_circuit',
    name: '네오 일렉트릭써킷',
    rushDistance: 6,
    resources: 6,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 55,
      zvpZergWinRate: 50,
      pvtProtossWinRate: 50,
    ),
  );

  static const iccupOutlier = GameMap(
    id: 'iccup_outlier',
    name: '아웃라이어',
    rushDistance: 5,
    resources: 5,
    complexity: 6,
    matchup: RaceMatchup(
      tvzTerranWinRate: 50,
      zvpZergWinRate: 55,
      pvtProtossWinRate: 45,
    ),
  );

  static const chainReaction = GameMap(
    id: 'chain_reaction',
    name: '체인리액션',
    rushDistance: 7,
    resources: 7,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 45,
      zvpZergWinRate: 50,
      pvtProtossWinRate: 55,
    ),
  );

  static const neoJade = GameMap(
    id: 'neo_jade',
    name: '네오제이드',
    rushDistance: 4,
    resources: 5,
    complexity: 4,
    matchup: RaceMatchup(
      tvzTerranWinRate: 60,
      zvpZergWinRate: 45,
      pvtProtossWinRate: 50,
    ),
  );

  static const circuitBreaker = GameMap(
    id: 'circuit_breaker',
    name: '써킷브레이커',
    rushDistance: 6,
    resources: 6,
    complexity: 6,
    matchup: RaceMatchup(
      tvzTerranWinRate: 50,
      zvpZergWinRate: 50,
      pvtProtossWinRate: 50,
    ),
  );

  static const newSniperRidge = GameMap(
    id: 'new_sniper_ridge',
    name: '신저격능선',
    rushDistance: 5,
    resources: 5,
    complexity: 7,
    matchup: RaceMatchup(
      tvzTerranWinRate: 55,
      zvpZergWinRate: 45,
      pvtProtossWinRate: 55,
    ),
  );

  static const groundZero = GameMap(
    id: 'ground_zero',
    name: '그라운드제로',
    rushDistance: 8,
    resources: 8,
    complexity: 4,
    matchup: RaceMatchup(
      tvzTerranWinRate: 40,
      zvpZergWinRate: 60,
      pvtProtossWinRate: 50,
    ),
  );

  static const neoBitway = GameMap(
    id: 'neo_bit_way',
    name: '네오 비트 웨이',
    rushDistance: 5,
    resources: 6,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 55,
      zvpZergWinRate: 50,
      pvtProtossWinRate: 45,
    ),
  );

  static const destination = GameMap(
    id: 'destination',
    name: '데스티네이션',
    rushDistance: 7,
    resources: 7,
    complexity: 6,
    matchup: RaceMatchup(
      tvzTerranWinRate: 45,
      zvpZergWinRate: 55,
      pvtProtossWinRate: 50,
    ),
  );

  static const fightingSpirit = GameMap(
    id: 'fighting_spirit',
    name: '투혼',
    rushDistance: 5,
    resources: 5,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 50,
      zvpZergWinRate: 50,
      pvtProtossWinRate: 50,
    ),
  );

  static const matchPoint = GameMap(
    id: 'match_point',
    name: '매치포인트',
    rushDistance: 4,
    resources: 4,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 60,
      zvpZergWinRate: 40,
      pvtProtossWinRate: 55,
    ),
  );

  static const python = GameMap(
    id: 'python',
    name: '파이썬',
    rushDistance: 6,
    resources: 6,
    complexity: 5,
    matchup: RaceMatchup(
      tvzTerranWinRate: 50,
      zvpZergWinRate: 55,
      pvtProtossWinRate: 50,
    ),
  );

  static List<GameMap> get all => [
    neoElectricCircuit,
    iccupOutlier,
    chainReaction,
    neoJade,
    circuitBreaker,
    newSniperRidge,
    groundZero,
    neoBitway,
    destination,
    fightingSpirit,
    matchPoint,
    python,
  ];

  static GameMap? getById(String id) {
    return all.cast<GameMap?>().firstWhere(
      (m) => m?.id == id,
      orElse: () => null,
    );
  }
}
