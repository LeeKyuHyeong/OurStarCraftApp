import 'dart:async';
import 'dart:math';
import '../models/models.dart';

/// 경기 시뮬레이션 상태
class SimulationState {
  final int homeArmy;
  final int awayArmy;
  final int homeResources;
  final int awayResources;
  final List<String> battleLog;
  final bool isFinished;
  final bool? homeWin;

  const SimulationState({
    this.homeArmy = 4,
    this.awayArmy = 4,
    this.homeResources = 50,
    this.awayResources = 50,
    this.battleLog = const [],
    this.isFinished = false,
    this.homeWin,
  });

  SimulationState copyWith({
    int? homeArmy,
    int? awayArmy,
    int? homeResources,
    int? awayResources,
    List<String>? battleLog,
    bool? isFinished,
    bool? homeWin,
  }) {
    return SimulationState(
      homeArmy: homeArmy ?? this.homeArmy,
      awayArmy: awayArmy ?? this.awayArmy,
      homeResources: homeResources ?? this.homeResources,
      awayResources: awayResources ?? this.awayResources,
      battleLog: battleLog ?? this.battleLog,
      isFinished: isFinished ?? this.isFinished,
      homeWin: homeWin ?? this.homeWin,
    );
  }
}

/// 경기 시뮬레이션 서비스
class MatchSimulationService {
  final Random _random = Random();

  /// 두 선수 간 승률 계산 (homePlayer 기준)
  double calculateWinRate({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
  }) {
    // 1. 종족 상성 (맵 기반)
    final raceMatchupBonus = map.matchup.getWinRate(
      homePlayer.race,
      awayPlayer.race,
    );

    // 2. 능력치 비교
    final homeStats = homePlayer.effectiveStats;
    final awayStats = awayPlayer.effectiveStats;

    final homeTotal = homeStats.total + homeCheerfulBonus;
    final awayTotal = awayStats.total + awayCheerfulBonus;

    // 능력치 차이에 따른 승률 보정
    final statDiff = homeTotal - awayTotal;
    final statBonus = (statDiff / 100).clamp(-30, 30); // 최대 ±30%

    // 3. 맵 특성 보너스
    double mapBonus = 0;

    // 러시거리가 짧으면 공격력 유리
    if (map.favorsAggressive) {
      final homeAttack = homeStats.attack + homeStats.harass;
      final awayAttack = awayStats.attack + awayStats.harass;
      mapBonus += (homeAttack - awayAttack) / 200;
    }

    // 자원이 많으면 물량 유리
    if (map.favorsMacro) {
      final homeMacro = homeStats.macro + homeStats.defense;
      final awayMacro = awayStats.macro + awayStats.defense;
      mapBonus += (homeMacro - awayMacro) / 200;
    }

    // 복잡도가 높으면 전략 유리
    if (map.favorsStrategic) {
      final homeStrategy = homeStats.strategy + homeStats.sense;
      final awayStrategy = awayStats.strategy + awayStats.sense;
      mapBonus += (homeStrategy - awayStrategy) / 200;
    }

    mapBonus = mapBonus.clamp(-10, 10); // 최대 ±10%

    // 최종 승률 계산
    final baseWinRate = raceMatchupBonus.toDouble();
    final finalWinRate = (baseWinRate + statBonus + mapBonus).clamp(10, 90);

    return finalWinRate / 100;
  }

  /// 경기 시뮬레이션 (텍스트 없이 결과만)
  SetResult simulateMatch({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
  }) {
    final winRate = calculateWinRate(
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
      map: map,
      homeCheerfulBonus: homeCheerfulBonus,
      awayCheerfulBonus: awayCheerfulBonus,
    );

    final homeWin = _random.nextDouble() < winRate;

    return SetResult(
      mapId: map.id,
      homePlayerId: homePlayer.id,
      awayPlayerId: awayPlayer.id,
      homeWin: homeWin,
    );
  }

  /// 경기 시뮬레이션 (텍스트 로그 포함, 스트림)
  Stream<SimulationState> simulateMatchWithLog({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    required int intervalMs,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
  }) async* {
    final winRate = calculateWinRate(
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
      map: map,
      homeCheerfulBonus: homeCheerfulBonus,
      awayCheerfulBonus: awayCheerfulBonus,
    );

    var state = const SimulationState();
    final homeStats = homePlayer.effectiveStats;
    final awayStats = awayPlayer.effectiveStats;

    // 경기 시작 메시지
    state = state.copyWith(
      battleLog: [
        '마이프로리그, 경기 시작했습니다!',
        '${map.name}에서 ${homePlayer.name} 선수와 ${awayPlayer.name} 선수가 맞붙습니다.',
      ],
    );
    yield state;
    await Future.delayed(Duration(milliseconds: intervalMs));

    int lineCount = 0;
    const maxLines = 200;

    while (!state.isFinished && lineCount < maxLines) {
      lineCount++;

      // 이벤트 생성
      final event = _generateEvent(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        homeStats: homeStats,
        awayStats: awayStats,
        winRate: winRate,
        currentState: state,
      );

      // 상태 업데이트
      state = state.copyWith(
        homeArmy: (state.homeArmy + event.homeArmyChange).clamp(0, 200),
        awayArmy: (state.awayArmy + event.awayArmyChange).clamp(0, 200),
        homeResources: (state.homeResources + event.homeResourceChange).clamp(0, 10000),
        awayResources: (state.awayResources + event.awayResourceChange).clamp(0, 10000),
        battleLog: [...state.battleLog, event.text],
      );

      yield state;
      await Future.delayed(Duration(milliseconds: intervalMs));

      // 승패 체크
      final result = _checkWinCondition(state, lineCount);
      if (result != null) {
        final winner = result ? homePlayer : awayPlayer;
        final loser = result ? awayPlayer : homePlayer;

        state = state.copyWith(
          isFinished: true,
          homeWin: result,
          battleLog: [
            ...state.battleLog,
            '${loser.name} 선수, GG를 선언합니다.',
            '${winner.name} 선수 승리!',
          ],
        );
        yield state;
        return;
      }
    }

    // 200줄 강제 판정
    if (!state.isFinished) {
      final homeScore = state.homeArmy + (state.homeResources / 50);
      final awayScore = state.awayArmy + (state.awayResources / 50);
      final homeWin = homeScore >= awayScore;

      final winner = homeWin ? homePlayer : awayPlayer;
      final loser = homeWin ? awayPlayer : homePlayer;

      state = state.copyWith(
        isFinished: true,
        homeWin: homeWin,
        battleLog: [
          ...state.battleLog,
          '접전 끝에 ${loser.name} 선수가 GG를 선언합니다.',
          '${winner.name} 선수가 승리를 거머쥡니다!',
        ],
      );
      yield state;
    }
  }

  /// 승패 조건 체크
  bool? _checkWinCondition(SimulationState state, int lineCount) {
    // 병력 격차 승리 (4:1)
    if (state.homeArmy >= state.awayArmy * 4 && state.awayArmy > 0) {
      return true;
    }
    if (state.awayArmy >= state.homeArmy * 4 && state.homeArmy > 0) {
      return false;
    }

    // 병력 0
    if (state.homeArmy <= 0) return false;
    if (state.awayArmy <= 0) return true;

    return null;
  }

  /// 이벤트 생성
  _BattleEvent _generateEvent({
    required Player homePlayer,
    required Player awayPlayer,
    required PlayerStats homeStats,
    required PlayerStats awayStats,
    required double winRate,
    required SimulationState currentState,
  }) {
    // 유리한 쪽이 이벤트 발동 확률 높음
    final homeAdvantage = winRate > 0.5;
    final eventForHome = _random.nextDouble() < (homeAdvantage ? 0.6 : 0.4);

    final player = eventForHome ? homePlayer : awayPlayer;
    final opponent = eventForHome ? awayPlayer : homePlayer;
    final stats = eventForHome ? homeStats : awayStats;
    final oppStats = eventForHome ? awayStats : homeStats;

    // 이벤트 타입 결정 (능력치 기반)
    final eventType = _selectEventType(stats, oppStats, currentState);

    return _createEvent(
      eventType: eventType,
      player: player,
      opponent: opponent,
      isHomeEvent: eventForHome,
      stats: stats,
      oppStats: oppStats,
    );
  }

  /// 이벤트 타입 선택
  _EventType _selectEventType(
    PlayerStats stats,
    PlayerStats oppStats,
    SimulationState state,
  ) {
    final weights = <_EventType, double>{
      _EventType.attack: stats.attack / 500.0,
      _EventType.harass: stats.harass / 500.0,
      _EventType.defense: stats.defense / 500.0,
      _EventType.macro: stats.macro / 500.0,
      _EventType.control: stats.control / 500.0,
      _EventType.strategy: stats.strategy / 500.0,
      _EventType.scout: stats.scout / 500.0,
      _EventType.battle: 0.5, // 기본 전투
    };

    final total = weights.values.reduce((a, b) => a + b);
    var roll = _random.nextDouble() * total;

    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }

    return _EventType.battle;
  }

  /// 이벤트 생성
  _BattleEvent _createEvent({
    required _EventType eventType,
    required Player player,
    required Player opponent,
    required bool isHomeEvent,
    required PlayerStats stats,
    required PlayerStats oppStats,
  }) {
    final sign = isHomeEvent ? 1 : -1;
    String text;
    int homeArmyChange = 0;
    int awayArmyChange = 0;
    int homeResourceChange = 0;
    int awayResourceChange = 0;

    switch (eventType) {
      case _EventType.attack:
        final templates = [
          '${player.name} 선수 공격! 상대 병력 타격!',
          '${player.name} 선수 러쉬 시도합니다!',
          '${player.name} 선수 올인 플레이!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          awayArmyChange = -_random.nextInt(15) - 5;
          homeArmyChange = -_random.nextInt(8);
        } else {
          homeArmyChange = -_random.nextInt(15) - 5;
          awayArmyChange = -_random.nextInt(8);
        }

      case _EventType.harass:
        final templates = [
          '${player.name} 선수 견제 성공!',
          '${player.name} 선수 드랍십으로 일꾼 학살!',
          '${player.name} 선수 멀티태스킹 좋습니다!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          awayResourceChange = -_random.nextInt(20) - 10;
          awayArmyChange = -_random.nextInt(5);
        } else {
          homeResourceChange = -_random.nextInt(20) - 10;
          homeArmyChange = -_random.nextInt(5);
        }

      case _EventType.defense:
        final templates = [
          '${player.name} 선수 완벽한 수비!',
          '${player.name} 선수 상대 공격 막아냅니다!',
          '${player.name} 선수 견고한 방어선!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          homeArmyChange = _random.nextInt(5) + 2;
        } else {
          awayArmyChange = _random.nextInt(5) + 2;
        }

      case _EventType.macro:
        final templates = [
          '${player.name} 선수 멀티 확장 성공!',
          '${player.name} 선수 물량 생산 좋습니다!',
          '${player.name} 선수 자원 관리 훌륭합니다!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          homeResourceChange = _random.nextInt(30) + 10;
          homeArmyChange = _random.nextInt(10) + 5;
        } else {
          awayResourceChange = _random.nextInt(30) + 10;
          awayArmyChange = _random.nextInt(10) + 5;
        }

      case _EventType.control:
        final templates = [
          '${player.name} 선수 환상적인 컨트롤!',
          '${player.name} 선수 믿을 수 없는 마이크로!',
          '${player.name} 선수 완벽한 포커싱!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          awayArmyChange = -_random.nextInt(12) - 3;
          homeArmyChange = -_random.nextInt(3);
        } else {
          homeArmyChange = -_random.nextInt(12) - 3;
          awayArmyChange = -_random.nextInt(3);
        }

      case _EventType.strategy:
        final templates = [
          '${player.name} 선수 기발한 전략!',
          '${player.name} 선수 상대 빌드 완벽히 읽었습니다!',
          '${player.name} 선수 타이밍 공격 성공!',
        ];
        text = templates[_random.nextInt(templates.length)];
        if (isHomeEvent) {
          awayArmyChange = -_random.nextInt(10) - 5;
          awayResourceChange = -_random.nextInt(15) - 5;
        } else {
          homeArmyChange = -_random.nextInt(10) - 5;
          homeResourceChange = -_random.nextInt(15) - 5;
        }

      case _EventType.scout:
        final templates = [
          '${player.name} 선수 정찰로 상대 빌드 파악!',
          '${player.name} 선수 옵저버로 시야 확보!',
          '${player.name} 선수 상대 움직임 포착!',
        ];
        text = templates[_random.nextInt(templates.length)];
        // 정찰은 직접 효과는 없지만 다음 이벤트에 유리
        if (isHomeEvent) {
          homeArmyChange = _random.nextInt(3) + 1;
        } else {
          awayArmyChange = _random.nextInt(3) + 1;
        }

      case _EventType.battle:
        final templates = [
          '양측 병력이 충돌합니다!',
          '치열한 교전 중입니다!',
          '대규모 전투가 벌어집니다!',
          '팽팽한 접전이 이어집니다!',
        ];
        text = templates[_random.nextInt(templates.length)];
        homeArmyChange = -_random.nextInt(8) - 2;
        awayArmyChange = -_random.nextInt(8) - 2;
    }

    return _BattleEvent(
      text: text,
      homeArmyChange: homeArmyChange,
      awayArmyChange: awayArmyChange,
      homeResourceChange: homeResourceChange,
      awayResourceChange: awayResourceChange,
    );
  }
}

enum _EventType {
  attack,
  harass,
  defense,
  macro,
  control,
  strategy,
  scout,
  battle,
}

class _BattleEvent {
  final String text;
  final int homeArmyChange;
  final int awayArmyChange;
  final int homeResourceChange;
  final int awayResourceChange;

  const _BattleEvent({
    required this.text,
    required this.homeArmyChange,
    required this.awayArmyChange,
    required this.homeResourceChange,
    required this.awayResourceChange,
  });
}
