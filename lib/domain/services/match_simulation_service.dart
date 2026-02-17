import 'dart:async';
import 'dart:math';
import '../models/models.dart';
import '../../core/constants/build_orders.dart';

/// 전투 로그 소유자 타입
enum LogOwner {
  system,  // 시스템 메시지 (경기 시작, 종료 등)
  home,    // 홈 선수 이벤트
  away,    // 어웨이 선수 이벤트
  clash,   // 충돌/전투 이벤트
}

/// 전투 로그 엔트리
class BattleLogEntry {
  final String text;
  final LogOwner owner;

  const BattleLogEntry({
    required this.text,
    this.owner = LogOwner.system,
  });
}

/// 경기 시뮬레이션 상태
class SimulationState {
  final int homeArmy;
  final int awayArmy;
  final int homeResources;
  final int awayResources;
  final List<BattleLogEntry> battleLogEntries;
  final bool isFinished;
  final bool? homeWin;

  const SimulationState({
    this.homeArmy = 80,       // 초기 병력
    this.awayArmy = 80,       // 초기 병력
    this.homeResources = 150, // 초기 자원
    this.awayResources = 150, // 초기 자원
    this.battleLogEntries = const [],
    this.isFinished = false,
    this.homeWin,
  });

  // 하위 호환성을 위한 getter
  List<String> get battleLog => battleLogEntries.map((e) => e.text).toList();

  SimulationState copyWith({
    int? homeArmy,
    int? awayArmy,
    int? homeResources,
    int? awayResources,
    List<BattleLogEntry>? battleLogEntries,
    bool? isFinished,
    bool? homeWin,
  }) {
    return SimulationState(
      homeArmy: homeArmy ?? this.homeArmy,
      awayArmy: awayArmy ?? this.awayArmy,
      homeResources: homeResources ?? this.homeResources,
      awayResources: awayResources ?? this.awayResources,
      battleLogEntries: battleLogEntries ?? this.battleLogEntries,
      isFinished: isFinished ?? this.isFinished,
      homeWin: homeWin ?? this.homeWin,
    );
  }
}

/// 경기 시뮬레이션 서비스 (빌드오더 기반)
class MatchSimulationService {
  final Random _random = Random();

  /// 종족 문자열 변환
  String _getRaceString(Race race) {
    switch (race) {
      case Race.terran:
        return 'T';
      case Race.zerg:
        return 'Z';
      case Race.protoss:
        return 'P';
    }
  }

  /// 선수 능력치 기반 빌드 스타일 결정
  BuildStyle _determineBuildStyle(PlayerStats stats) {
    final attackScore = stats.attack + stats.harass + stats.control;
    final defenseScore = stats.defense + stats.macro + stats.strategy;
    final cheeseScore = stats.attack + stats.sense;

    // 치즈 확률: 공격+감각 기반 (B+ 선수도 ~8-12% 확률로 가능)
    final cheeseProb = ((cheeseScore - 600) / 3000).clamp(0.05, 0.20);
    if (cheeseScore > 900 && _random.nextDouble() < cheeseProb) {
      return BuildStyle.cheese;
    }

    final ratio = attackScore / (defenseScore + 1);
    // 랜덤 노이즈로 밸런스 독점 방지 (±0.15 범위)
    final noise = (_random.nextDouble() - 0.5) * 0.30;
    final adjustedRatio = ratio + noise;
    if (adjustedRatio > 1.08) {
      return BuildStyle.aggressive;
    } else if (adjustedRatio < 0.92) {
      return BuildStyle.defensive;
    } else {
      return BuildStyle.balanced;
    }
  }

  /// PlayerStats → Map<String, int> 변환
  Map<String, int> _statsToMap(PlayerStats stats) {
    return {
      'sense': stats.sense,
      'control': stats.control,
      'attack': stats.attack,
      'harass': stats.harass,
      'strategy': stats.strategy,
      'macro': stats.macro,
      'defense': stats.defense,
      'scout': stats.scout,
    };
  }

  /// 두 선수 간 승률 계산 (homePlayer 기준)
  double calculateWinRate({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
    double homeSnipingBonus = 0,
    double awaySnipingBonus = 0,
  }) {
    // 1. 종족 상성 (맵 기반)
    final raceMatchupBonus = map.matchup.getWinRate(
      homePlayer.race,
      awayPlayer.race,
    );

    // 2. 능력치 비교 (컨디션 적용)
    final homeStats = homePlayer.effectiveStats;
    final awayStats = awayPlayer.effectiveStats;

    // 종족 문자열
    final homeRace = _getRaceString(homePlayer.race);
    final awayRace = _getRaceString(awayPlayer.race);

    // 3. 기본 능력치 비교 (경기 초반 기준으로 전체 평가)
    final homeTotal = homeStats.total + homeCheerfulBonus;
    final awayTotal = awayStats.total + awayCheerfulBonus;

    // 능력치 차이에 따른 승률 보정 (35당 1%, 최대 ±50%)
    final statDiff = homeTotal - awayTotal;
    final statBonus = (statDiff / 35).clamp(-50.0, 50.0);

    // 4. 빌드 스타일 및 세부 빌드 상성 (통합 스코어링)
    final homeBuildOrder = BuildOrderData.getBuildOrder(
      race: homeRace, vsRace: awayRace,
      statValues: _statsToMap(homeStats), map: map,
    );
    final awayBuildOrder = BuildOrderData.getBuildOrder(
      race: awayRace, vsRace: homeRace,
      statValues: _statsToMap(awayStats), map: map,
    );
    final homeBuildType = homeBuildOrder != null ? BuildType.getById(homeBuildOrder.id) : null;
    final awayBuildType = awayBuildOrder != null ? BuildType.getById(awayBuildOrder.id) : null;
    final homeStyle = homeBuildType?.parentStyle ?? _determineBuildStyle(homeStats);
    final awayStyle = awayBuildType?.parentStyle ?? _determineBuildStyle(awayStats);

    double buildBonus = 0;

    // 세부 빌드 타입 상성 (있는 경우)
    if (homeBuildType != null && awayBuildType != null) {
      buildBonus = BuildMatchup.getBuildAdvantage(homeBuildType, awayBuildType);

      // 정찰 성공 보너스 (상대 빌드 읽기)
      buildBonus += BuildMatchup.getScoutBonus(homeStats.scout, awayBuildType);
      buildBonus -= BuildMatchup.getScoutBonus(awayStats.scout, homeBuildType);
    } else {
      // 세부 빌드가 없으면 상위 스타일로 계산
      if (homeStyle == BuildStyle.aggressive && awayStyle == BuildStyle.defensive) {
        buildBonus = 22;
      } else if (homeStyle == BuildStyle.defensive && awayStyle == BuildStyle.aggressive) {
        buildBonus = -22;
      } else if (homeStyle == BuildStyle.cheese && awayStyle == BuildStyle.defensive) {
        buildBonus = 8;
      } else if (homeStyle == BuildStyle.defensive && awayStyle == BuildStyle.cheese) {
        buildBonus = -5;
      }
    }

    // 등급 차이가 크면 빌드 상성 효과 감소
    final gradeDiff = (homeTotal - awayTotal).abs();
    final buildEffectMultiplier = (1.0 - gradeDiff / 14000).clamp(0.5, 1.0);
    buildBonus *= buildEffectMultiplier;

    // 수비력이 높으면 빌드 불리 일부 상쇄
    if (buildBonus < 0) {
      final defenseAdvantage = (homeStats.defense - awayStats.defense) / 150;
      buildBonus += defenseAdvantage.clamp(0.0, 5.0);
    }

    buildBonus = buildBonus.clamp(-40.0, 40.0);

    // 5. 맵 특성 보너스 (세분화된 시스템)
    final mapBonusResult = map.calculateMapBonus(
      homeSense: homeStats.sense,
      homeControl: homeStats.control,
      homeAttack: homeStats.attack,
      homeHarass: homeStats.harass,
      homeStrategy: homeStats.strategy,
      homeMacro: homeStats.macro,
      homeDefense: homeStats.defense,
      homeScout: homeStats.scout,
      awaySense: awayStats.sense,
      awayControl: awayStats.control,
      awayAttack: awayStats.attack,
      awayHarass: awayStats.harass,
      awayStrategy: awayStats.strategy,
      awayMacro: awayStats.macro,
      awayDefense: awayStats.defense,
      awayScout: awayStats.scout,
    );

    final mapBonus = mapBonusResult.netHomeAdvantage;

    // 5-1. 넓은 맵 정찰 보너스 (rushDistance >= 7: 정찰 중요도 증가)
    double scoutMapBonus = 0;
    if (map.rushDistance >= 7) {
      final scoutDiff = homeStats.scout - awayStats.scout;
      scoutMapBonus = (scoutDiff / 100).clamp(-5.0, 5.0);
    }

    // 6. 레벨 차이에 따른 경험 보정 (레벨당 +2%, 최대 ±20%)
    final levelDiff = homePlayer.level.value - awayPlayer.level.value;
    final levelBonus = (levelDiff * 2).clamp(-20, 20);

    // 7. 스나이핑 보정 (성공 시 +20%)
    final snipingBonus = homeSnipingBonus - awaySnipingBonus;

    // 최종 승률 계산
    // TvZ 기본 보정 (+3%) + 맵 종족상성 효과 (증폭률 0.5)
    final raceDeviation = raceMatchupBonus.toDouble() - 50.0;
    final isTvZ = (homePlayer.race == Race.terran && awayPlayer.race == Race.zerg) ||
                  (homePlayer.race == Race.zerg && awayPlayer.race == Race.terran);
    final tvzBase = isTvZ
        ? (homePlayer.race == Race.terran ? 2.5 : -2.5)
        : 0.0;
    final baseWinRate = 50.0 + tvzBase + raceDeviation * 0.35;
    final finalWinRate = (baseWinRate + statBonus + buildBonus + mapBonus + scoutMapBonus + levelBonus + snipingBonus).clamp(3.0, 97.0);

    return finalWinRate / 100;
  }

  /// 경기 시뮬레이션 (텍스트 없이 결과만)
  SetResult simulateMatch({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
    double homeSnipingBonus = 0,
    double awaySnipingBonus = 0,
  }) {
    final winRate = calculateWinRate(
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
      map: map,
      homeCheerfulBonus: homeCheerfulBonus,
      awayCheerfulBonus: awayCheerfulBonus,
      homeSnipingBonus: homeSnipingBonus,
      awaySnipingBonus: awaySnipingBonus,
    );

    final homeWin = _random.nextDouble() < winRate;

    return SetResult(
      mapId: map.id,
      homePlayerId: homePlayer.id,
      awayPlayerId: awayPlayer.id,
      homeWin: homeWin,
    );
  }

  /// 경기 시뮬레이션 (텍스트 로그 포함, 스트림) - 빌드오더 기반
  /// [getIntervalMs] 콜백을 사용하여 배속 변경 시 스트림 재시작 없이 반영 가능
  Stream<SimulationState> simulateMatchWithLog({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    required int Function() getIntervalMs,
    int homeCheerfulBonus = 0,
    int awayCheerfulBonus = 0,
    double homeSnipingBonus = 0,
    double awaySnipingBonus = 0,
    String? homeSnipingPlayerName,
    String? awaySnipingPlayerName,
    String? forcedHomeBuildId,
    String? forcedAwayBuildId,
  }) async* {
    final winRate = calculateWinRate(
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
      map: map,
      homeCheerfulBonus: homeCheerfulBonus,
      awayCheerfulBonus: awayCheerfulBonus,
      homeSnipingBonus: homeSnipingBonus,
      awaySnipingBonus: awaySnipingBonus,
    );

    var state = const SimulationState();
    final homeStats = homePlayer.effectiveStats;
    final awayStats = awayPlayer.effectiveStats;

    // 각 선수의 빌드오더 가져오기
    final homeRace = _getRaceString(homePlayer.race);
    final awayRace = _getRaceString(awayPlayer.race);

    // 강제 빌드가 있으면 빌드 스타일도 빌드에서 결정
    final homeBuild = forcedHomeBuildId != null
        ? BuildOrderData.getBuildOrderById(forcedHomeBuildId)
        : null;
    final awayBuild0 = forcedAwayBuildId != null
        ? BuildOrderData.getBuildOrderById(forcedAwayBuildId)
        : null;

    // 통합 빌드 선택: BuildOrder → BuildType.getById → BuildStyle
    final homeBuildFinal = homeBuild ?? BuildOrderData.getBuildOrder(
      race: homeRace, vsRace: awayRace,
      statValues: _statsToMap(homeStats), map: map,
    );
    final awayBuildFinal = awayBuild0 ?? BuildOrderData.getBuildOrder(
      race: awayRace, vsRace: homeRace,
      statValues: _statsToMap(awayStats), map: map,
    );

    // BuildType은 BuildOrder.id로 조회 (1:1 매핑)
    final homeBuildType = homeBuildFinal != null
        ? BuildType.getById(homeBuildFinal.id)
        : null;
    final awayBuildType = awayBuildFinal != null
        ? BuildType.getById(awayBuildFinal.id)
        : null;

    final homeStyle = homeBuildType?.parentStyle ?? _determineBuildStyle(homeStats);
    final awayStyle = awayBuildType?.parentStyle ?? _determineBuildStyle(awayStats);

    // 빌드 스텝에서 유닛 키워드 추출 (이벤트 필터링용)
    final homeUnitTags = homeBuildFinal != null ? BuildOrderData.extractUnitTags(homeBuildFinal) : <String>{};
    final awayUnitTags = awayBuildFinal != null ? BuildOrderData.extractUnitTags(awayBuildFinal) : <String>{};
    final combinedUnitTags = homeUnitTags.union(awayUnitTags);

    // 빌드가 없으면 기본 시뮬레이션
    if (homeBuildFinal == null || awayBuildFinal == null) {
      yield* _fallbackSimulation(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: map,
        getIntervalMs: getIntervalMs,
        winRate: winRate,
      );
      return;
    }

    // 경기 시작 메시지 (빌드 스타일 스포일 없음)
    final openingEntries = <BattleLogEntry>[
      const BattleLogEntry(text: '마이프로리그, 경기 시작했습니다!', owner: LogOwner.system),
      BattleLogEntry(text: '${map.name}에서 ${homePlayer.name} 선수와 ${awayPlayer.name} 선수가 맞붙습니다.', owner: LogOwner.system),
    ];

    // 스나이핑 성공 텍스트
    if (homeSnipingBonus > 0 && homeSnipingPlayerName != null) {
      openingEntries.add(BattleLogEntry(
        text: "'$homeSnipingPlayerName' 선수 상대를 예상하고 맞춤빌드를 짜온 것 같은데요!",
        owner: LogOwner.home,
      ));
    }
    if (awaySnipingBonus > 0 && awaySnipingPlayerName != null) {
      openingEntries.add(BattleLogEntry(
        text: "'$awaySnipingPlayerName' 선수 상대를 예상하고 맞춤빌드를 짜온 것 같은데요!",
        owner: LogOwner.away,
      ));
    }

    state = state.copyWith(battleLogEntries: openingEntries);
    yield state;
    await Future.delayed(Duration(milliseconds: getIntervalMs()));

    // 빌드 진행 인덱스 (독립 진행)
    int homeIndex = 0;
    int awayIndex = 0;
    int lineCount = 0;
    const maxLines = 200;
    int lastCommentaryLine = -10; // 코멘터리 연속 방지
    final usedTexts = <String, int>{}; // 텍스트 사용 횟수 추적 (같은 텍스트 2회 이상 방지)

    // 충돌 발생 여부
    bool clashOccurred = false;
    int clashStartLine = -1;
    LogOwner lastClashOwner = LogOwner.home; // 클래시 교차 표시용
    int lastClashLine = -10; // 마지막 클래시 이벤트 라인 (빈도 조절용)

    // 빌드 매치업 해설 (초반에 1회 삽입)
    final buildMatchupCommentary = _getBuildMatchupCommentary(
      homeBuildType: homeBuildType,
      awayBuildType: awayBuildType,
      homePlayer: homePlayer,
      awayPlayer: awayPlayer,
    );
    bool buildMatchupCommentaryShown = false;

    // ZvZ 상수 (루프 밖에서 한번만 계산)
    final isZvZ = homePlayer.race == Race.zerg && awayPlayer.race == Race.zerg;
    final isZvZAggressiveVsNonAggressive = isZvZ && (
      (homeStyle == BuildStyle.aggressive && awayStyle != BuildStyle.aggressive) ||
      (awayStyle == BuildStyle.aggressive && homeStyle != BuildStyle.aggressive)
    );

    while (!state.isFinished && lineCount < maxLines) {
      lineCount++;

      // 현재 라인에 해당하는 이벤트 결정 (양측 독립)
      final homeStep = _getNextStep(homeBuildFinal, homeIndex, lineCount);
      final awayStep = _getNextStep(awayBuildFinal, awayIndex, lineCount);

      // 충돌 체크
      if (!clashOccurred && (
          (homeStep?.isClash == true) ||
          (awayStep?.isClash == true) ||
          (isZvZAggressiveVsNonAggressive && lineCount >= 10 && _random.nextDouble() < 0.4) ||
          (isZvZ && lineCount >= 25 && _random.nextDouble() < 0.15) ||
          (lineCount >= 50 && _random.nextDouble() < 0.1)
      )) {
        clashOccurred = true;
        clashStartLine = lineCount;

        if (isZvZ) {
          final avgArmy = ((state.homeArmy + state.awayArmy) / 2).round();
          state = state.copyWith(homeArmy: avgArmy, awayArmy: avgArmy);
        }
      }

      // ========== 클래시 구간 ==========
      if (clashOccurred && lineCount >= clashStartLine) {
        final clashDuration = lineCount - clashStartLine;
        final linesSinceLastClash = lineCount - lastClashLine;

        // 클래시 간격: 초반 2라인, duration 60+ 이후 1라인 (가속)
        // ZvZ는 전용 로직이므로 간격 제한 없음
        final clashInterval = isZvZ ? 1 : (clashDuration >= 60 ? 1 : 2);

        // ===== 회복/포지셔닝 구간 (클래시 사이) =====
        if (linesSinceLastClash < clashInterval) {
          // 매크로 능력치에 따라 회복량 차등
          final homeMacro = homeStats.macro;
          final awayMacro = awayStats.macro;
          final homeRecoveryResource = 10 + (homeMacro / 200).round(); // 12~15
          final awayRecoveryResource = 10 + (awayMacro / 200).round();
          // 소량 병력 보충 (매크로 700+ 시 +2, 아니면 +1)
          final homeRecoveryArmy = homeMacro >= 700 ? 2 : 1;
          final awayRecoveryArmy = awayMacro >= 700 ? 2 : 1;

          // 수치만 적용, 텍스트 출력 없음 (로그에 회복 멘트 미표시)
          state = state.copyWith(
            homeArmy: (state.homeArmy + homeRecoveryArmy).clamp(0, 200),
            awayArmy: (state.awayArmy + awayRecoveryArmy).clamp(0, 200),
            homeResources: (state.homeResources + homeRecoveryResource).clamp(0, 10000),
            awayResources: (state.awayResources + awayRecoveryResource).clamp(0, 10000),
          );

          // 회복 구간에서도 승패 체크 (army 0 등)
          final recoveryResult = _checkWinCondition(state, lineCount);
          if (recoveryResult != null) {
            yield* _emitEnding(
              state: state,
              homeWinOverride: recoveryResult,
              winRate: winRate,
              homePlayer: homePlayer,
              awayPlayer: awayPlayer,
              lineCount: lineCount,
              getIntervalMs: getIntervalMs,
            );
            return;
          }

          continue; // 회복 구간 → 다음 라인으로
        }

        // ===== 클래시 이벤트 발동 =====
        lastClashLine = lineCount;

        String text = '';
        int homeArmyChange = 0;
        int awayArmyChange = 0;
        int homeResourceChange = 0;
        int awayResourceChange = 0;
        bool decisive = false;
        bool? homeWinOverride;

        // ZvZ 빌드 상성 이변 (우선 체크)
        if (isZvZAggressiveVsNonAggressive && lineCount >= 8 && lineCount <= 18) {
          final homeIsAggressive = homeStyle == BuildStyle.aggressive;
          final aggressorStats = homeIsAggressive ? homeStats : awayStats;
          final zvzDefenderStats = homeIsAggressive ? awayStats : homeStats;
          final aggressor = homeIsAggressive ? homePlayer : awayPlayer;
          final defenderStyle = homeIsAggressive ? awayStyle : homeStyle;
          final isAggressorHome = homeIsAggressive;

          final gradeDiff = zvzDefenderStats.total - aggressorStats.total;

          if (gradeDiff > 1000) {
            final baseChance = defenderStyle == BuildStyle.defensive ? 0.006 : 0.004;
            if (_random.nextDouble() < baseChance) {
              decisive = true;
              homeWinOverride = isAggressorHome;
              text = '${aggressor.name} 선수, 선제 저글링 공격 성공! 빌드 승리!';
            }
          }
        }

        if (!decisive) {
          // 클래시 텍스트 중복 방지: 최대 3회 재시도
          _ClashResult? bestResult;
          for (int retry = 0; retry < 3; retry++) {
            final clashResult = _simulateClash(
              homePlayer: homePlayer,
              awayPlayer: awayPlayer,
              homeStats: homeStats,
              awayStats: awayStats,
              homeStyle: homeStyle,
              awayStyle: awayStyle,
              winRate: winRate,
              lineCount: lineCount,
              clashStartLine: clashStartLine,
              currentState: state,
              map: map,
              homeBuildType: homeBuildType,
              awayBuildType: awayBuildType,
              combinedUnitTags: combinedUnitTags,
            );
            // 미사용 텍스트면 바로 채택
            if ((usedTexts[clashResult.text] ?? 0) == 0 || clashResult.decisive) {
              bestResult = clashResult;
              break;
            }
            // 더 적게 사용된 후보 기억
            if (bestResult == null || (usedTexts[clashResult.text] ?? 0) < (usedTexts[bestResult.text] ?? 0)) {
              bestResult = clashResult;
            }
          }
          final clashResult = bestResult!;

          text = clashResult.text;
          homeArmyChange = clashResult.homeArmyChange;
          awayArmyChange = clashResult.awayArmyChange;
          homeResourceChange = clashResult.homeResourceChange;
          awayResourceChange = clashResult.awayResourceChange;
          decisive = clashResult.decisive;
          homeWinOverride = clashResult.homeWinOverride;
          if (text.isNotEmpty) {
            usedTexts[text] = (usedTexts[text] ?? 0) + 1;
          }
        }

        // 클래시 텍스트의 주체 선수 결정 (선수 이름 기반 + 교차 표시)
        LogOwner clashOwner;
        if (text.isNotEmpty) {
          final transformedText = _transformEnding(text);
          final homeNameIdx = transformedText.indexOf(homePlayer.name);
          final awayNameIdx = transformedText.indexOf(awayPlayer.name);
          if (homeNameIdx >= 0 && (awayNameIdx < 0 || homeNameIdx < awayNameIdx)) {
            clashOwner = LogOwner.home;
          } else if (awayNameIdx >= 0 && (homeNameIdx < 0 || awayNameIdx < homeNameIdx)) {
            clashOwner = LogOwner.away;
          } else {
            // 선수 이름 없는 중립 텍스트 → 이전 owner 반대로 교차
            clashOwner = lastClashOwner == LogOwner.home ? LogOwner.away : LogOwner.home;
          }
          lastClashOwner = clashOwner;
        } else {
          clashOwner = LogOwner.clash;
        }

        // 상태 업데이트
        state = state.copyWith(
          homeArmy: (state.homeArmy + homeArmyChange).clamp(0, 200),
          awayArmy: (state.awayArmy + awayArmyChange).clamp(0, 200),
          homeResources: (state.homeResources + homeResourceChange).clamp(0, 10000),
          awayResources: (state.awayResources + awayResourceChange).clamp(0, 10000),
          battleLogEntries: text.isNotEmpty
              ? [...state.battleLogEntries, BattleLogEntry(text: _transformEnding(text), owner: clashOwner)]
              : state.battleLogEntries,
        );

        yield state;
        await Future.delayed(Duration(milliseconds: getIntervalMs()));

        // 결정적 이벤트 → 엔딩
        if (decisive) {
          yield* _emitEnding(
            state: state,
            homeWinOverride: homeWinOverride,
            winRate: winRate,
            homePlayer: homePlayer,
            awayPlayer: awayPlayer,
            lineCount: lineCount,
            getIntervalMs: getIntervalMs,
          );
          return;
        }

        // 승패 체크
        final result = _checkWinCondition(state, lineCount);
        if (result != null) {
          yield* _emitEnding(
            state: state,
            homeWinOverride: result,
            winRate: winRate,
            homePlayer: homePlayer,
            awayPlayer: awayPlayer,
            lineCount: lineCount,
            getIntervalMs: getIntervalMs,
          );
          return;
        }

        continue; // 클래시 구간에서는 빌드 스텝 건너뜀
      }

      // ========== 일반 빌드 진행 (병합 타임라인) ==========
      final newEntries = <BattleLogEntry>[];
      int homeArmyChange = 0;
      int awayArmyChange = 0;
      int homeResourceChange = 0;
      int awayResourceChange = 0;

      // 홈 빌드 스텝
      if (homeStep != null) {
        final text = _transformEnding(homeStep.text.replaceAll('{player}', homePlayer.name));
        newEntries.add(BattleLogEntry(text: text, owner: LogOwner.home));
        homeArmyChange += homeStep.myArmy;
        homeResourceChange += homeStep.myResource;
        awayArmyChange += homeStep.enemyArmy;
        awayResourceChange += homeStep.enemyResource;
        homeIndex++;

        // 인터랙션 이벤트 (상대 반응)
        final interaction = _getInteractionEvent(
          triggerText: homeStep.text,
          triggerRace: homeRace,
          reactorRace: awayRace,
          reactorName: awayPlayer.name,
        );
        if (interaction != null) {
          newEntries.add(BattleLogEntry(text: interaction, owner: LogOwner.away));
        }

        // 빌드 반응 해설 (주요 빌드 선택에 대한 해설자 코멘터리)
        if (lineCount - lastCommentaryLine >= 3) {
          final buildCommentary = _getBuildReactionCommentary(
            buildText: homeStep.text,
            builderName: homePlayer.name,
            opponentName: awayPlayer.name,
            builderRace: homeRace,
            opponentRace: awayRace,
            usedTexts: usedTexts,
          );
          if (buildCommentary != null) {
            newEntries.add(BattleLogEntry(text: buildCommentary, owner: LogOwner.system));
            lastCommentaryLine = lineCount;
            usedTexts[buildCommentary] = (usedTexts[buildCommentary] ?? 0) + 1;
          }
        }
      }

      // 어웨이 빌드 스텝
      if (awayStep != null) {
        final text = _transformEnding(awayStep.text.replaceAll('{player}', awayPlayer.name));
        newEntries.add(BattleLogEntry(text: text, owner: LogOwner.away));
        awayArmyChange += awayStep.myArmy;
        awayResourceChange += awayStep.myResource;
        homeArmyChange += awayStep.enemyArmy;
        homeResourceChange += awayStep.enemyResource;
        awayIndex++;

        // 인터랙션 이벤트 (상대 반응)
        final interaction = _getInteractionEvent(
          triggerText: awayStep.text,
          triggerRace: awayRace,
          reactorRace: homeRace,
          reactorName: homePlayer.name,
        );
        if (interaction != null) {
          newEntries.add(BattleLogEntry(text: interaction, owner: LogOwner.home));
        }

        // 빌드 반응 해설 (주요 빌드 선택에 대한 해설자 코멘터리)
        if (lineCount - lastCommentaryLine >= 3) {
          final buildCommentary = _getBuildReactionCommentary(
            buildText: awayStep.text,
            builderName: awayPlayer.name,
            opponentName: homePlayer.name,
            builderRace: awayRace,
            opponentRace: homeRace,
            usedTexts: usedTexts,
          );
          if (buildCommentary != null) {
            newEntries.add(BattleLogEntry(text: buildCommentary, owner: LogOwner.system));
            lastCommentaryLine = lineCount;
            usedTexts[buildCommentary] = (usedTexts[buildCommentary] ?? 0) + 1;
          }
        }
      }

      // 빌드 매치업 해설 삽입 (초반 1회, 빌드가 드러나는 시점)
      if (!buildMatchupCommentaryShown && buildMatchupCommentary != null &&
          lineCount >= 8 && lineCount <= 20 &&
          lineCount - lastCommentaryLine >= 3) {
        newEntries.add(BattleLogEntry(text: buildMatchupCommentary, owner: LogOwner.system));
        lastCommentaryLine = lineCount;
        usedTexts[buildMatchupCommentary] = (usedTexts[buildMatchupCommentary] ?? 0) + 1;
        buildMatchupCommentaryShown = true;
      }

      // 양측 빌드 스텝 없음 → 코멘터리 또는 중후반 이벤트
      if (homeStep == null && awayStep == null) {
        // 코멘터리 기회 (최소 5라인 간격)
        if (lineCount - lastCommentaryLine >= 5) {
          final commentary = _getCommentary(
            state: state,
            lineCount: lineCount,
            homePlayer: homePlayer,
            awayPlayer: awayPlayer,
            homeStyle: homeStyle,
            awayStyle: awayStyle,
            usedTexts: usedTexts,
          );
          if (commentary != null) {
            newEntries.add(BattleLogEntry(text: commentary, owner: LogOwner.system));
            lastCommentaryLine = lineCount;
            usedTexts[commentary] = (usedTexts[commentary] ?? 0) + 1;
          }
        }

        // 초반(15줄 이전)에서는 midLateEvent 사용 금지 - 아직 병력이 없으므로
        // 중반 이후에도 70% 확률로만 삽입 (빈 줄 허용)
        if (newEntries.isEmpty && lineCount >= 15 && _random.nextDouble() < 0.70) {
          final isHomeTurn = _random.nextBool();
          final player = isHomeTurn ? homePlayer : awayPlayer;
          final currentArmy = isHomeTurn ? state.homeArmy : state.awayArmy;
          final currentResource = isHomeTurn ? state.homeResources : state.awayResources;
          final raceStr = isHomeTurn ? homeRace : awayRace;

          BuildStep? bestStep;
          String bestText = '';
          for (int retry = 0; retry < 5; retry++) {
            final candidate = BuildOrderData.getMidLateEvent(
              lineCount: lineCount,
              currentArmy: currentArmy,
              currentResource: currentResource,
              race: raceStr,
              vsRace: isHomeTurn ? awayRace : homeRace,
              rushDistance: map.rushDistance,
              resources: map.resources,
              terrainComplexity: map.terrainComplexity,
              random: _random,
              availableUnits: isHomeTurn ? homeUnitTags : awayUnitTags,
            );
            final candidateText = _transformEnding(candidate.text.replaceAll('{player}', player.name));
            // 미사용 텍스트 우선
            if ((usedTexts[candidateText] ?? 0) == 0) {
              bestStep = candidate;
              bestText = candidateText;
              break;
            }
            // 가장 적게 사용된 후보 기억
            if (bestStep == null || (usedTexts[candidateText] ?? 0) < (usedTexts[bestText] ?? 0)) {
              bestStep = candidate;
              bestText = candidateText;
            }
          }

          final midLateStep = bestStep!;
          final text = bestText;
          usedTexts[text] = (usedTexts[text] ?? 0) + 1;
          newEntries.add(BattleLogEntry(text: text, owner: isHomeTurn ? LogOwner.home : LogOwner.away));

          if (isHomeTurn) {
            homeArmyChange += midLateStep.myArmy;
            homeResourceChange += midLateStep.myResource;
            awayArmyChange += midLateStep.enemyArmy;
            awayResourceChange += midLateStep.enemyResource;
          } else {
            awayArmyChange += midLateStep.myArmy;
            awayResourceChange += midLateStep.myResource;
            homeArmyChange += midLateStep.enemyArmy;
            homeResourceChange += midLateStep.enemyResource;
          }
        }
      }

      // 상태 업데이트
      state = state.copyWith(
        homeArmy: (state.homeArmy + homeArmyChange).clamp(0, 200),
        awayArmy: (state.awayArmy + awayArmyChange).clamp(0, 200),
        homeResources: (state.homeResources + homeResourceChange).clamp(0, 10000),
        awayResources: (state.awayResources + awayResourceChange).clamp(0, 10000),
        battleLogEntries: newEntries.isNotEmpty
            ? [...state.battleLogEntries, ...newEntries]
            : state.battleLogEntries,
      );

      yield state;
      await Future.delayed(Duration(milliseconds: getIntervalMs()));

      // 승패 체크
      final result = _checkWinCondition(state, lineCount);
      if (result != null) {
        yield* _emitEnding(
          state: state,
          homeWinOverride: result,
          winRate: winRate,
          homePlayer: homePlayer,
          awayPlayer: awayPlayer,
          lineCount: lineCount,
          getIntervalMs: getIntervalMs,
        );
        return;
      }
    }

    // 200줄 강제 판정
    if (!state.isFinished) {
      final homeScore = state.homeArmy + (state.homeResources / 50);
      final awayScore = state.awayArmy + (state.awayResources / 50);
      // 동점이면 winRate 기반 확률 판정 (홈 편향 방지)
      final homeWin = homeScore != awayScore
          ? homeScore > awayScore
          : _random.nextDouble() < winRate;

      yield* _emitEnding(
        state: state,
        homeWinOverride: homeWin,
        winRate: winRate,
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        lineCount: lineCount,
        getIntervalMs: getIntervalMs,
        isLongGame: true,
      );
    }
  }

  // ==================== 엔딩 시스템 ====================

  /// 엔딩 emit (GG + 코멘터리 + 승리 선언)
  Stream<SimulationState> _emitEnding({
    required SimulationState state,
    required bool? homeWinOverride,
    required double winRate,
    required Player homePlayer,
    required Player awayPlayer,
    required int lineCount,
    required int Function() getIntervalMs,
    bool isLongGame = false,
  }) async* {
    final isHomeWinner = homeWinOverride ?? (_random.nextDouble() < winRate);
    final winner = isHomeWinner ? homePlayer : awayPlayer;
    final loser = isHomeWinner ? awayPlayer : homePlayer;

    final endingCommentary = _getEndingCommentary(
      winner: winner,
      state: state,
      lineCount: lineCount,
      isLongGame: isLongGame,
    );

    state = state.copyWith(
      isFinished: true,
      homeWin: isHomeWinner,
      battleLogEntries: [
        ...state.battleLogEntries,
        BattleLogEntry(
          text: isLongGame
              ? '접전 끝에 ${loser.name} 선수가 GG를 선언합니다.'
              : '${loser.name} 선수, GG를 선언합니다.',
          owner: isHomeWinner ? LogOwner.away : LogOwner.home,
        ),
        BattleLogEntry(text: endingCommentary, owner: LogOwner.system),
        BattleLogEntry(text: '${winner.name} 선수 승리!', owner: LogOwner.system),
      ],
    );
    yield state;
  }

  /// 엔딩 코멘터리 (게임 상황에 따라)
  String _getEndingCommentary({
    required Player winner,
    required SimulationState state,
    required int lineCount,
    bool isLongGame = false,
  }) {
    if (isLongGame) {
      final longGameTexts = [
        '정말 긴 접전이었습니다! ${winner.name} 선수가 끝까지 버텨냈네요.',
        '양측 모두 포기하지 않은 명경기였습니다!',
        '장기전에서 ${winner.name} 선수의 운영이 빛났습니다.',
      ];
      return longGameTexts[_random.nextInt(longGameTexts.length)];
    }

    // 빠른 승리 (40줄 이하)
    if (lineCount <= 40) {
      final quickTexts = [
        '${winner.name} 선수, 초반부터 압도적이었습니다!',
        '빠른 경기! ${winner.name} 선수가 일찍 승기를 잡았네요.',
        '${winner.name} 선수, 초반 운영이 완벽했습니다!',
      ];
      return quickTexts[_random.nextInt(quickTexts.length)];
    }

    // 접전 (병력 차 적음)
    final armyDiff = (state.homeArmy - state.awayArmy).abs();
    if (armyDiff < 20) {
      final closeTexts = [
        '정말 아슬아슬한 경기였습니다!',
        '어느 쪽이 이겨도 이상하지 않은 접전이었네요!',
        '한 끗 차이의 승부! ${winner.name} 선수가 가져갑니다!',
      ];
      return closeTexts[_random.nextInt(closeTexts.length)];
    }

    // 일반적 마무리
    final normalTexts = [
      '${winner.name} 선수는 역시 끝낼 수 있을 때 끝내버리죠.',
      '${winner.name} 선수, 깔끔한 마무리입니다!',
      '${winner.name} 선수의 경기 운영이 한 수 위였습니다.',
      '대단한 경기력! ${winner.name} 선수 승리 가져갑니다.',
    ];
    return normalTexts[_random.nextInt(normalTexts.length)];
  }

  // ==================== 인터랙션 이벤트 시스템 ====================

  /// 인터랙션 규칙 (트리거-반응 매칭)
  static final List<_InteractionRule> _interactionRules = [
    // 프로토스 → 테란 반응
    _InteractionRule(triggerPattern: RegExp(r'질럿'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor}, 마린으로 질럿 잡아내고.',
      '{reactor} 선수 벙커 뒤에서 질럿 상대합니다.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'다크템플러|다크'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor} 선수 컴샛 스테이션 올립니다!',
      '{reactor} 선수 스캔으로 다크 잡아내구요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'캐리어|모선'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor} 선수 골리앗도 나왔구요.',
      '{reactor} 선수 발키리 생산 서두릅니다.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'리버'), triggerRace: 'P', reactorRace: '*', reactions: [
      '{reactor} 선수 리버 주의하면서 운영합니다.',
      '{reactor} 선수 리버 견제에 대비하고.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'옵저버|정찰'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor} 선수 터렛으로 옵저버 대비하구요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'아비터'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor} 선수 사이언스 베슬 급히 뽑습니다!',
      '{reactor} 선수 EMP 준비하네요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'하이템플러|스톰|사이오닉'), triggerRace: 'P', reactorRace: 'T', reactions: [
      '{reactor} 선수 EMP 준비! 하이템플러 대비하구요.',
      '{reactor} 선수 병력 분산 시킵니다.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'질럿|드라군'), triggerRace: 'P', reactorRace: 'Z', reactions: [
      '{reactor} 선수 저글링으로 견제 나갑니다.',
      '{reactor} 선수 성큰 올려서 방어 준비!',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'캐리어|모선'), triggerRace: 'P', reactorRace: 'Z', reactions: [
      '{reactor} 선수 스커지 서둘러 모읍니다!',
      '{reactor} 선수 히드라리스크로 대공 준비!',
    ]),

    // 저그 → 테란 반응
    _InteractionRule(triggerPattern: RegExp(r'저글링.*러쉬|저글링.*공격|선풀'), triggerRace: 'Z', reactorRace: 'T', reactions: [
      '{reactor}, 벙커로 저글링 막아냅니다!',
      '{reactor} 선수 마린 모아서 방어!',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'스파이어|뮤탈'), triggerRace: 'Z', reactorRace: 'T', reactions: [
      '{reactor} 선수 터렛 올리구요.',
      '{reactor} 선수 발키리 생산합니다.',
      '{reactor} 선수 미사일 터렛 건설!',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'럴커'), triggerRace: 'Z', reactorRace: 'T', reactions: [
      '{reactor} 선수 사이언스 베슬 서두릅니다.',
      '{reactor} 선수 디텍터 확보에 주력하네요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'디파일러|플레이그'), triggerRace: 'Z', reactorRace: 'T', reactions: [
      '{reactor} 선수 이레디에이트 준비하구요.',
      '{reactor} 선수 사이언스 베슬 컨트롤이 중요하겠네요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'히드라'), triggerRace: 'Z', reactorRace: 'P', reactions: [
      '{reactor} 선수 하이템플러 사이오닉 스톰 준비!',
      '{reactor} 선수 리버 견제 나가구요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'뮤탈'), triggerRace: 'Z', reactorRace: 'P', reactions: [
      '{reactor} 선수 코르세어 생산!',
      '{reactor} 선수 드라군으로 방어 준비합니다.',
    ]),

    // 테란 → 프로토스 반응
    _InteractionRule(triggerPattern: RegExp(r'시즈탱크|탱크'), triggerRace: 'T', reactorRace: 'P', reactions: [
      '{reactor} 선수 드라군으로 탱크 상대하구요.',
      '{reactor} 선수 셔틀 리버로 탱크 처리 노립니다.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'벌처|벌쳐'), triggerRace: 'T', reactorRace: 'P', reactions: [
      '{reactor} 선수 드라군으로 벌처 대응합니다.',
      '{reactor} 선수 질럿으로 벌처 잡아내고.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'레이스'), triggerRace: 'T', reactorRace: 'P', reactions: [
      '{reactor} 선수 드라군 생산량 늘립니다.',
      '{reactor} 선수 옵저버로 클로킹 레이스 잡아내고.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'배틀크루저|전투순양함'), triggerRace: 'T', reactorRace: 'P', reactions: [
      '{reactor} 선수 아비터 리콜 준비합니다!',
      '{reactor} 선수 드라군 대량으로 모읍니다.',
    ]),

    // 테란 → 저그 반응
    _InteractionRule(triggerPattern: RegExp(r'시즈탱크|탱크'), triggerRace: 'T', reactorRace: 'Z', reactions: [
      '{reactor} 선수 저글링 런바이 노리구요.',
      '{reactor} 선수 가디언으로 탱크 처리 노립니다.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'벌처|벌쳐'), triggerRace: 'T', reactorRace: 'Z', reactions: [
      '{reactor} 선수 저글링으로 벌처 대응합니다.',
      '{reactor} 선수 성큰 세워서 방어하네요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'레이스'), triggerRace: 'T', reactorRace: 'Z', reactions: [
      '{reactor} 선수 스커지 생산합니다.',
      '{reactor} 선수 뮤탈리스크로 대응 나가구요.',
    ]),

    // 범용 반응
    _InteractionRule(triggerPattern: RegExp(r'드랍|수송'), triggerRace: '*', reactorRace: '*', reactions: [
      '{reactor}, 드랍 읽었습니다! 본진 수비!',
      '{reactor} 선수 드랍 대비하며 병력 배치!',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'확장|멀티|앞마당'), triggerRace: '*', reactorRace: '*', reactions: [
      '{reactor} 선수도 확장 서두르네요.',
      '{reactor} 선수 견제 나갈 타이밍인데요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'업그레이드|업그'), triggerRace: '*', reactorRace: '*', reactions: [
      '{reactor} 선수도 업그레이드 챙기구요.',
    ]),
    _InteractionRule(triggerPattern: RegExp(r'정찰|스카우트'), triggerRace: '*', reactorRace: '*', reactions: [
      '{reactor} 선수 정찰 들어옵니다.',
    ]),
  ];

  /// 인터랙션 이벤트 생성 (30-50% 확률)
  String? _getInteractionEvent({
    required String triggerText,
    required String triggerRace,
    required String reactorRace,
    required String reactorName,
  }) {
    if (_random.nextDouble() > 0.40) return null; // 60% 확률로 스킵

    for (final rule in _interactionRules) {
      if (!rule.triggerPattern.hasMatch(triggerText)) continue;
      if (rule.triggerRace != '*' && rule.triggerRace != triggerRace) continue;
      if (rule.reactorRace != '*' && rule.reactorRace != reactorRace) continue;

      final reaction = rule.reactions[_random.nextInt(rule.reactions.length)];
      return reaction.replaceAll('{reactor}', reactorName);
    }
    return null;
  }

  // ==================== 코멘터리 시스템 ====================

  /// 상황에 따른 코멘터리 (빈 라인에서만 삽입, 중복 필터링)
  String? _getCommentary({
    required SimulationState state,
    required int lineCount,
    required Player homePlayer,
    required Player awayPlayer,
    BuildStyle? homeStyle,
    BuildStyle? awayStyle,
    Map<String, int>? usedTexts,
  }) {
    // 50% 확률로 코멘터리 스킵 (너무 자주 나오지 않게)
    if (_random.nextDouble() > 0.50) return null;

    final armyDiff = (state.homeArmy - state.awayArmy).abs();
    final resourceDiff = (state.homeResources - state.awayResources).abs();
    final leading = state.homeArmy > state.awayArmy ? homePlayer : awayPlayer;
    final trailing = state.homeArmy > state.awayArmy ? awayPlayer : homePlayer;

    // 후보 텍스트 선택 헬퍼 (이미 사용된 텍스트 제외)
    String? pickUnused(List<String> texts) {
      if (usedTexts == null) return texts[_random.nextInt(texts.length)];
      final unused = texts.where((t) => (usedTexts[t] ?? 0) == 0).toList();
      if (unused.isNotEmpty) return unused[_random.nextInt(unused.length)];
      // 모두 사용됨 → 가장 적게 사용된 것 선택
      texts.sort((a, b) => (usedTexts[a] ?? 0).compareTo(usedTexts[b] ?? 0));
      return texts.first;
    }

    // 치즈/올인 상황 코멘터리 (초반)
    final hasCheese = homeStyle == BuildStyle.cheese || awayStyle == BuildStyle.cheese;
    if (hasCheese && lineCount <= 20) {
      final cheesePlayer = homeStyle == BuildStyle.cheese ? homePlayer : awayPlayer;
      final defender = homeStyle == BuildStyle.cheese ? awayPlayer : homePlayer;
      final texts = [
        '올인 공격입니다! ${defender.name} 선수가 버틸 수 있을까요!',
        '${cheesePlayer.name} 선수, 승부수를 던졌습니다!',
        '초반 올인! 이 공격이 실패하면 돌아올 수 없습니다!',
        '숨막히는 긴장감! 양 선수 한 치의 실수도 허용되지 않습니다!',
        '${defender.name} 선수의 초반 수비가 관건입니다!',
        '이 러쉬를 막아내면 ${defender.name} 선수가 유리해집니다.',
      ];
      return pickUnused(texts);
    }

    // 치즈 실패 후 코멘터리 (line > 20, 치즈 빌드)
    if (hasCheese && lineCount > 20) {
      final cheesePlayer = homeStyle == BuildStyle.cheese ? homePlayer : awayPlayer;
      final defender = homeStyle == BuildStyle.cheese ? awayPlayer : homePlayer;
      final texts = [
        '올인이 막혔습니다! ${cheesePlayer.name} 선수 이대로면 힘들어요.',
        '초반 공격이 실패했고, ${defender.name} 선수가 유리한 상황입니다.',
        '${cheesePlayer.name} 선수, 경제적으로 뒤처지고 있습니다.',
        '올인 실패 후 갈 곳이 없는 ${cheesePlayer.name} 선수입니다.',
      ];
      return pickUnused(texts);
    }

    // 공격형 vs 수비형 매치업 코멘터리
    if (lineCount > 15 && lineCount <= 40) {
      final homeIsAgg = homeStyle == BuildStyle.aggressive;
      final awayIsAgg = awayStyle == BuildStyle.aggressive;
      final homeIsDef = homeStyle == BuildStyle.defensive;
      final awayIsDef = awayStyle == BuildStyle.defensive;

      if ((homeIsAgg && awayIsDef) || (awayIsAgg && homeIsDef)) {
        final aggPlayer = homeIsAgg ? homePlayer : awayPlayer;
        final defPlayer = homeIsAgg ? awayPlayer : homePlayer;
        if (_random.nextDouble() < 0.3) {
          final texts = [
            '${aggPlayer.name} 선수의 공격 타이밍이 다가오고 있습니다!',
            '${defPlayer.name} 선수, 수비 태세를 잘 갖추고 있는데요.',
            '공격과 수비의 대결! 이 타이밍이 중요합니다!',
            '${aggPlayer.name} 선수가 먼저 움직이느냐가 관건이겠네요.',
          ];
          return pickUnused(texts);
        }
      }
    }

    // 병력 차이 크면
    if (armyDiff > 40) {
      final texts = [
        '병력 차이가 벌어지고 있습니다... 이거 위험한데요?',
        '${leading.name} 선수 병력이 압도적이구요!',
        '${trailing.name} 선수 이대로면 힘들어집니다.',
        '병력 격차가 점점 커지고 있습니다!',
        '${trailing.name} 선수, 병력 보충이 시급해 보입니다.',
        '${leading.name} 선수의 병력이 눈에 띄게 많아졌네요.',
        '이 병력 차이를 어떻게 극복할 수 있을까요?',
      ];
      return pickUnused(texts);
    }

    // 자원 차이 크면
    if (resourceDiff > 200) {
      final rLeading = state.homeResources > state.awayResources ? homePlayer : awayPlayer;
      final rTrailing = state.homeResources > state.awayResources ? awayPlayer : homePlayer;
      final texts = [
        '자원 차이가 크구요, 이대로라면 후반이 어려워집니다.',
        '${rLeading.name} 선수가 경제적으로 크게 앞서고 있네요.',
        '경제력 차이가 나기 시작합니다.',
        '${rTrailing.name} 선수, 자원이 부족한 상황입니다.',
        '멀티 운영 차이가 경제력 격차로 이어지고 있네요.',
        '이 경제력 차이가 후반에 큰 영향을 미칠 겁니다.',
      ];
      return pickUnused(texts);
    }

    // 비슷한 병력 (빌드 구간 - 전투 아닌 운영 상황)
    if (armyDiff < 10 && lineCount > 30) {
      final texts = [
        '양 선수 비슷한 운영력을 보여주고 있습니다.',
        '양측 모두 안정적으로 물량을 쌓아가고 있네요.',
        '서로 빈틈을 노리고 있는 모습이에요.',
        '누가 먼저 움직이느냐... 이 눈치싸움이 관건입니다.',
        '운영력 대결이 계속되고 있습니다.',
        '양 선수 서로를 견제하며 운영 중입니다.',
        '조심스러운 움직임... 언제 터질지 모릅니다.',
        '양측 최대한 손실을 줄이며 운영합니다.',
        '맵 전체에 정적이 흐릅니다.',
        '양 선수 물량 축적 중입니다.',
        '누가 먼저 움직일 것인가... 눈치 싸움입니다.',
        '양 선수 신중하게 운영 중입니다.',
      ];
      return pickUnused(texts);
    }

    // 초반 (10줄 이하)
    if (lineCount <= 10) {
      final texts = [
        '양측 건물 올리면서 초반 운영 시작합니다.',
        '경기 초반, 양 선수 빌드 준비에 들어갑니다.',
        '아직 초반이라 탐색전이 이어지고 있네요.',
        '초반 빌드가 진행되고 있습니다.',
        '양 선수 각자의 전략을 준비하고 있네요.',
        '아직은 조용한 초반입니다.',
      ];
      return pickUnused(texts);
    }

    // 중반 (20~60줄)
    if (lineCount > 20 && lineCount <= 60) {
      final texts = [
        '경기가 점점 흥미로워지고 있습니다.',
        '중반 운영이 이번 경기의 관건이 되겠네요.',
        '테크 전환을 노리고 있는 것 같은데요!',
        '양측 모두 경제를 챙기면서 운영하고 있습니다.',
        '이 타이밍에 누가 먼저 움직이느냐가 관건입니다.',
        '중반 싸움이 본격적으로 시작됩니다!',
        '슬슬 본격적인 전투가 시작될 것 같은데요.',
        '양 선수 모두 테크업에 집중하고 있네요.',
        '앞마당 타이밍이 경기를 좌우할 수 있습니다.',
        '중반 운영에서 누가 앞서느냐가 관건이네요.',
      ];
      return pickUnused(texts);
    }

    // 후반 (60줄 이후)
    if (lineCount > 60) {
      final texts = [
        '후반이 길어지고 있습니다. 멘탈 싸움이죠.',
        '양쪽 다 최대 병력으로 한번 크게 붙어야 될 것 같은데요.',
        '후반 운영 능력이 시험받는 시간입니다.',
        '경기가 장기전으로 가고 있네요!',
        '이쯤에서 한번 큰 전투가 날 것 같습니다.',
        '자원이 고갈되기 전에 승부를 내야 합니다.',
        '후반 체력 싸움! 집중력이 관건이에요.',
        '길어지는 후반, 누가 더 버티느냐의 싸움입니다.',
      ];
      return pickUnused(texts);
    }

    return null;
  }

  // ==================== 빌드 매치업 해설 시스템 ====================

  /// 양측 빌드 조합에 따른 해설 (초반 1회)
  /// 빌드가 크게 갈렸을 때, 구체적 빌드명을 언급하는 해설
  String? _getBuildMatchupCommentary({
    required BuildType? homeBuildType,
    required BuildType? awayBuildType,
    required Player homePlayer,
    required Player awayPlayer,
  }) {
    if (homeBuildType == null || awayBuildType == null) return null;

    // ── 1. 특정 빌드쌍 해설 (양방향 검색) ──
    final specific = _findSpecificMatchupTexts(
      homeBuildType, awayBuildType,
      homePlayer.name, awayPlayer.name,
    );
    if (specific != null && specific.isNotEmpty) {
      return specific[_random.nextInt(specific.length)];
    }

    // ── 2. 스타일 기반 범용 해설 (빌드가 갈렸을 때) ──
    final generic = _getGenericMatchupTexts(
      homeBuildType, awayBuildType,
      homePlayer, awayPlayer,
    );
    if (generic != null && generic.isNotEmpty) {
      return generic[_random.nextInt(generic.length)];
    }

    return null;
  }

  /// 특정 빌드쌍 해설 검색
  /// 공격자/수비자 관점 템플릿: {atk}=공격측 선수, {def}=수비측 선수,
  /// {atkBuild}=공격측 빌드명, {defBuild}=수비측 빌드명
  List<String>? _findSpecificMatchupTexts(
    BuildType home, BuildType away,
    String homeName, String awayName,
  ) {
    for (final rule in _buildMatchupRules) {
      // 정방향: home=attacker, away=defender
      if (rule.attackerIds.contains(home.id) && rule.defenderIds.contains(away.id)) {
        return rule.texts.map((t) => t
          .replaceAll('{atk}', homeName)
          .replaceAll('{def}', awayName)
          .replaceAll('{atkBuild}', home.koreanName)
          .replaceAll('{defBuild}', away.koreanName)
        ).toList();
      }
      // 역방향: away=attacker, home=defender
      if (rule.attackerIds.contains(away.id) && rule.defenderIds.contains(home.id)) {
        return rule.texts.map((t) => t
          .replaceAll('{atk}', awayName)
          .replaceAll('{def}', homeName)
          .replaceAll('{atkBuild}', away.koreanName)
          .replaceAll('{defBuild}', home.koreanName)
        ).toList();
      }
    }
    return null;
  }

  /// 스타일 기반 범용 해설
  List<String>? _getGenericMatchupTexts(
    BuildType home, BuildType away,
    Player homePlayer, Player awayPlayer,
  ) {
    final homeStyle = home.parentStyle;
    final awayStyle = away.parentStyle;
    final homeName = home.koreanName;
    final awayName = away.koreanName;
    final hp = homePlayer.name;
    final ap = awayPlayer.name;

    // 치즈 vs 수비형
    if (homeStyle == BuildStyle.cheese && awayStyle == BuildStyle.defensive) {
      return [
        '빌드가 갈렸습니다! $hp 선수 $homeName인데 $ap 선수가 피해없이 막을 수 있을까요?',
        '$hp 선수 $homeName! $ap 선수 $awayName으로 가고 있는데 막아낼 수 있을지!',
      ];
    }
    if (awayStyle == BuildStyle.cheese && homeStyle == BuildStyle.defensive) {
      return [
        '빌드가 갈렸습니다! $ap 선수 $awayName인데 $hp 선수가 피해없이 막을 수 있을까요?',
        '$ap 선수 $awayName! $hp 선수 $homeName으로 가고 있는데 막아낼 수 있을지!',
      ];
    }

    // 공격형 vs 수비형
    if (homeStyle == BuildStyle.aggressive && awayStyle == BuildStyle.defensive) {
      return [
        '빌드가 갈렸는데요! $hp 선수 $homeName, $ap 선수는 $awayName! 이 공격을 버텨낼 수 있을까요!',
        '$homeName vs $awayName! 공격과 수비의 대결, 타이밍이 관건입니다!',
      ];
    }
    if (awayStyle == BuildStyle.aggressive && homeStyle == BuildStyle.defensive) {
      return [
        '빌드가 갈렸는데요! $ap 선수 $awayName, $hp 선수는 $homeName! 이 공격을 버텨낼 수 있을까요!',
        '$awayName vs $homeName! 공격과 수비의 대결, 타이밍이 관건입니다!',
      ];
    }

    // 치즈 vs 공격형 (양쪽 다 공격적)
    if ((homeStyle == BuildStyle.cheese && awayStyle == BuildStyle.aggressive) ||
        (awayStyle == BuildStyle.cheese && homeStyle == BuildStyle.aggressive)) {
      return [
        '양 선수 모두 공격적인 선택! $homeName vs $awayName, 불꽃 튀는 경기가 예상됩니다!',
        '$hp 선수 $homeName! $ap 선수도 $awayName으로 맞불을 놓습니다!',
      ];
    }

    // 공격 vs 공격
    if (homeStyle == BuildStyle.aggressive && awayStyle == BuildStyle.aggressive) {
      return [
        '양 선수 모두 공격적입니다! $homeName vs $awayName, 초반부터 피 튀기는 싸움!',
        '공격 빌드 맞대결! $hp 선수 $homeName, $ap 선수 $awayName!',
      ];
    }

    // 상성 차이가 큰 경우 (±15 이상)
    final adv = BuildMatchup.getBuildAdvantage(home, away);
    if (adv.abs() >= 15) {
      final favored = adv > 0 ? hp : ap;
      final favoredBuild = adv > 0 ? homeName : awayName;
      final underdogBuild = adv > 0 ? awayName : homeName;
      return [
        '빌드가 많이 갈렸는데요! $favoredBuild이 $underdogBuild 상대로 유리한 상황!',
        '$favoredBuild vs $underdogBuild! $favored 선수에게 유리한 빌드 매치업인데요!',
      ];
    }

    return null;
  }

  /// 특정 빌드쌍 해설 규칙 테이블
  /// attackerIds: 공격/올인/주도권 측 빌드 ID 목록
  /// defenderIds: 수비/확장/당하는 측 빌드 ID 목록
  static final List<_BuildMatchupRule> _buildMatchupRules = [
    // ==================== TvZ / ZvT ====================

    // 저그 올인 vs 테란 확장 (원해처리올인 vs BBS/5팩골리앗/투배럭아카)
    const _BuildMatchupRule(
      attackerIds: {'zvt_1hatch_allin'},
      defenderIds: {'tvz_bunker', 'tvz_3fac_goliath', 'tvz_sk', 'tvz_mech_drop'},
      texts: [
        '빌드가 갈렸습니다! {atk} 선수 {atkBuild}인데, {def} 선수가 피해없이 막을 수 있을까요?',
        '{atk} 선수 올인입니다! {def} 선수 {defBuild}로 가고 있는데 큰 피해 없이 넘길 수 있을지!',
        '{atkBuild}! {atk} 선수 승부수를 던졌는데요, {def} 선수가 큰 피해를 줄 수 있을까요?',
        '{atk} 선수 초반부터 몰아붙입니다! {def} 선수 {defBuild}인데 수비가 관건이겠네요!',
      ],
    ),

    // 테란 공격 vs 저그 확장 (2팩벌처/레이스견제 vs 미친저그/투해처리뮤탈/투해처리럴커)
    const _BuildMatchupRule(
      attackerIds: {'tvz_2fac_vulture', 'tvz_wraith'},
      defenderIds: {'zvt_3hatch_mutal', 'zvt_2hatch_mutal', 'zvt_2hatch_lurker'},
      texts: [
        '빌드가 갈렸는데요! {atk} 선수 {atkBuild}, {def} 선수는 {defBuild}! 이 공격을 버텨낼 수 있을까요!',
        '{atk} 선수가 {atkBuild}으로 왔습니다! {def} 선수 {defBuild}인데 초반 견제가 관건이겠네요!',
        '{atkBuild} vs {defBuild}! {def} 선수 확장을 지킬 수 있을까요?',
        '{atk} 선수 공격적인 선택! {def} 선수 {defBuild}로 배를 불리고 있는데 이 견제를 막아야 합니다!',
      ],
    ),

    // 저그 확장 vs 테란 확장 (양쪽 운영, 긴 경기 예고)
    const _BuildMatchupRule(
      attackerIds: {'zvt_3hatch_mutal', 'zvt_2hatch_mutal', 'zvt_2hatch_lurker', 'zvt_hatch_spore'},
      defenderIds: {'tvz_bunker', 'tvz_3fac_goliath', 'tvz_sk', 'tvz_mech_drop'},
      // 미친저그도 운영 빌드 카테고리에 포함 (럴커 스킵하지만 멀티 운영은 함)
      texts: [
        '양 선수 모두 운영 체제! {atkBuild} vs {defBuild}, 긴 싸움이 예상됩니다!',
        '양측 다 확장하며 배를 불리고 있습니다! 중후반 싸움이 관건이겠네요.',
      ],
    ),

    // ==================== TvP / PvT ====================

    // 프로토스 치즈 vs 테란 확장 (다크스윙/프록시다크 vs 팩더블/업테란) 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvt_proxy_dark', 'pvt_dark_swing'},
      defenderIds: {'tvp_double', 'tvp_1fac_gosu'},
      texts: [
        '빌드가 크게 갈렸습니다! {atk} 선수 {atkBuild}! {def} 선수가 읽고 대비할 수 있을까요?',
        '{atkBuild}입니다! {def} 선수 {defBuild}로 가고 있는데, 디텍터 준비가 됐을지!',
        '{atk} 선수 기습적인 선택! {def} 선수 확장 가는 상황에서 막아낼 수 있을까요!',
      ],
    ),

    // 투게이트 질럿 압박 vs 테란 확장 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvt_2gate_zealot'},
      defenderIds: {'tvp_double', 'tvp_1fac_gosu'},
      texts: [
        '빌드가 갈렸는데요! {atk} 선수 {atkBuild}, {def} 선수는 {defBuild}! 이 압박을 버텨야 합니다!',
        '{atkBuild} 타이밍! {def} 선수 확장 갔는데, 벙커가 제때 올라올 수 있을까요!',
        '{atk} 선수 초반부터 밀어붙입니다! {def} 선수 {defBuild}인데 수비가 급하겠네요!',
      ],
    ),

    // 페이크더블 vs 프로토스 확장 극단적
    const _BuildMatchupRule(
      attackerIds: {'tvp_fake_double'},
      defenderIds: {'pvt_1gate_obs', 'pvt_1gate_expand'},
      texts: [
        '{atk} 선수 {atkBuild}입니다! {def} 선수가 속을 수 있을까요?',
        '더블인 줄 알았는데 {atkBuild}! {def} 선수 {defBuild}인데 이걸 읽었느냐가 관건!',
        '{atk} 선수 교묘한 선택! {def} 선수 안심하고 확장 갔다가 큰일 날 수 있습니다!',
      ],
    ),

    // 양쪽 확장 (팩더블/업테란/원팩드랍 vs 23넥서스/19넥서스) 장기전
    const _BuildMatchupRule(
      attackerIds: {'tvp_double', 'tvp_1fac_gosu', 'tvp_1fac_drop'},
      defenderIds: {'pvt_1gate_obs', 'pvt_1gate_expand'},
      texts: [
        '양 선수 모두 안정적인 운영! {atkBuild} vs {defBuild}, 중후반 싸움이 될 것 같습니다.',
        '양쪽 다 확장하며 경기를 풀어갑니다. 긴 호흡의 경기가 예상됩니다!',
        '{atkBuild} vs {defBuild}! 양 선수 운영으로 가면서 후반 한타가 관건이겠네요.',
      ],
    ),

    // ==================== TvT ====================

    // 프록시배럭 vs 확장/밸런스 극단적
    const _BuildMatchupRule(
      attackerIds: {'tvt_proxy'},
      defenderIds: {'tvt_cc_first', 'tvt_2rax', 'tvt_vulture_harass'},
      texts: [
        '{atk} 선수 {atkBuild}! {def} 선수가 스카웃할 수 있을까요?',
        '프록시입니다! {def} 선수 {defBuild}로 가는데, 이 기습을 막지 못하면 큰일입니다!',
        '{atkBuild} vs {defBuild}! {def} 선수 스카우팅이 관건입니다!',
      ],
    ),

    // 공격형 vs 원배럭확장 극단적
    const _BuildMatchupRule(
      attackerIds: {'tvt_1fac_push', 'tvt_2fac', 'tvt_wraith_cloak'},
      defenderIds: {'tvt_cc_first'},
      texts: [
        '빌드가 갈렸습니다! {atk} 선수 {atkBuild}, {def} 선수는 {defBuild}! 이 공격을 넘겨야 합니다!',
        '{atkBuild} vs {defBuild}! {def} 선수 확장 갔는데 이 타이밍을 버텨낼 수 있을지!',
        '{atk} 선수 공격적입니다! {def} 선수 원배럭 확장인데, 수비가 급하겠네요!',
      ],
    ),

    // 양쪽 공격 (원팩선공/투팩/클로킹레이스) 극단적
    const _BuildMatchupRule(
      attackerIds: {'tvt_1fac_push', 'tvt_2fac', 'tvt_wraith_cloak'},
      defenderIds: {'tvt_1fac_push', 'tvt_2fac', 'tvt_wraith_cloak'},
      texts: [
        '양 선수 모두 공격적! {atkBuild} vs {defBuild}, 초반부터 불꽃 튀는 싸움!',
        '양쪽 다 공격 빌드입니다! 누가 먼저 유리한 포지션을 잡느냐가 관건!',
        '{atkBuild} vs {defBuild}! 치열한 메카닉 전쟁이 예상됩니다!',
      ],
    ),

    // 양쪽 안정 (투배럭/벌처견제/원배럭확장) 장기전
    const _BuildMatchupRule(
      attackerIds: {'tvt_2rax', 'tvt_vulture_harass', 'tvt_cc_first'},
      defenderIds: {'tvt_2rax', 'tvt_vulture_harass', 'tvt_cc_first'},
      texts: [
        '양 선수 모두 안정적인 운영! 탱크라인 싸움이 관건인 장기전이 될 것 같습니다.',
        '{atkBuild} vs {defBuild}! 양쪽 다 안정적으로 가면서 후반을 노립니다.',
        '양 선수 운영 체제! 시즈탱크 포지션 싸움이 승부를 가를 것 같습니다.',
      ],
    ),

    // ==================== ZvP / PvZ ====================

    // 5드론 저글링 vs 프로토스 극단적
    const _BuildMatchupRule(
      attackerIds: {'zvp_5drone'},
      defenderIds: {'pvz_forge_cannon', 'pvz_nexus_first', 'pvz_corsair_reaver', 'pvz_2gate_zealot'},
      texts: [
        '{atk} 선수 {atkBuild}! {def} 선수가 피해없이 막을 수 있을까요?',
        '올인입니다! {atk} 선수 {atkBuild}! {def} 선수 {defBuild}인데 큰 피해 없이 넘겨야 합니다!',
        '{atkBuild}! 초반 승부수인데, {def} 선수가 읽고 대비했을지!',
      ],
    ),

    // 프록시게이트 vs 저그 확장 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvz_proxy_gate'},
      defenderIds: {'zvp_3hatch_hydra', 'zvp_2hatch_mutal', 'zvp_scourge_defiler', 'zvp_973_hydra'},
      texts: [
        '{atk} 선수 {atkBuild}! {def} 선수가 스카우팅할 수 있을까요!',
        '프록시입니다! {def} 선수 {defBuild}로 가고 있는데, 이걸 막지 못하면!',
        '{atkBuild}! {atk} 선수 승부수를 던졌는데, {def} 선수 저글링 타이밍이 관건!',
      ],
    ),

    // 저그 타이밍 vs 프로토스 확장 (5해처리히드라/973히드라 vs 포지더블/넥서스퍼스트) 극단적
    const _BuildMatchupRule(
      attackerIds: {'zvp_3hatch_hydra', 'zvp_973_hydra'},
      defenderIds: {'pvz_forge_cannon', 'pvz_nexus_first'},
      texts: [
        '빌드가 갈렸는데요! {atk} 선수 {atkBuild}, {def} 선수는 {defBuild}! 이 타이밍을 버텨야 합니다!',
        '{atkBuild} 타이밍! {def} 선수 확장 갔는데, 캐논과 질럿으로 막을 수 있을까요!',
        '{atk} 선수 물량으로 밀어붙입니다! {def} 선수 {defBuild}인데 방어선 구축이 관건!',
      ],
    ),

    // 프로토스 공격 vs 저그 확장 (투게이트질럿/커세어리버 vs 확장형 저그) 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvz_2gate_zealot', 'pvz_corsair_reaver'},
      defenderIds: {'zvp_3hatch_hydra', 'zvp_scourge_defiler', 'zvp_2hatch_mutal'},
      texts: [
        '빌드가 갈렸습니다! {atk} 선수 {atkBuild}인데, {def} 선수 확장 가는 상황!',
        '{atkBuild} vs {defBuild}! {atk} 선수가 초반에 유리한 포지션을 잡을 수 있을지!',
        '{atk} 선수 공격적인 선택! {def} 선수 {defBuild}인데, 이 압박을 견뎌야 합니다!',
      ],
    ),

    // 양쪽 운영 (스커지디파일러/투해처리뮤탈 vs 포지더블/넥서스퍼스트) 장기전
    const _BuildMatchupRule(
      attackerIds: {'zvp_scourge_defiler', 'zvp_2hatch_mutal'},
      defenderIds: {'pvz_forge_cannon', 'pvz_nexus_first'},
      texts: [
        '양 선수 모두 운영 체제! {atkBuild} vs {defBuild}, 긴 싸움이 예상됩니다!',
        '양쪽 다 안정적으로 경기를 풀어갑니다. 중후반 대군 싸움이 관건이겠네요.',
        '{atkBuild} vs {defBuild}! 서로 배를 불리면서 후반을 노립니다.',
      ],
    ),

    // ==================== ZvZ ====================

    // 올인/치즈 vs 확장 (익스트랙터트릭/스피드링올인 vs 12해처리/3해처리히드라/오버풀) 극단적
    const _BuildMatchupRule(
      attackerIds: {'zvz_extractor', 'zvz_speedling'},
      defenderIds: {'zvz_12hatch', 'zvz_3hatch_hydra', 'zvz_overpool'},
      texts: [
        '빌드가 크게 갈렸습니다! {atk} 선수 {atkBuild}! {def} 선수가 막을 수 있을까요?',
        '{atkBuild}입니다! {def} 선수 {defBuild}인데, 이 러쉬를 버텨내야 합니다!',
        '{atk} 선수 초반 승부수! {def} 선수 확장인데, 저글링 싸움이 관건!',
      ],
    ),

    // 선풀/9풀 vs 12해처리 극단적
    const _BuildMatchupRule(
      attackerIds: {'zvz_pool_first', 'zvz_9pool'},
      defenderIds: {'zvz_12hatch'},
      texts: [
        '빌드가 갈렸는데요! {atk} 선수 {atkBuild}, {def} 선수 {defBuild}! 초반 러쉬를 막아야 합니다!',
        '{atkBuild} vs {defBuild}! {def} 선수에게 불리한 빌드 매치업인데 버텨낼 수 있을지!',
        '{atk} 선수 빠른 풀! {def} 선수 해처리 퍼스트인데, 저글링 타이밍이 관건입니다!',
      ],
    ),

    // 양쪽 러시 (선풀/9풀/스피드링올인) 극단적
    const _BuildMatchupRule(
      attackerIds: {'zvz_pool_first', 'zvz_9pool', 'zvz_speedling'},
      defenderIds: {'zvz_pool_first', 'zvz_9pool', 'zvz_speedling'},
      texts: [
        '양 선수 모두 빠른 풀! 초반부터 저글링 싸움이 벌어집니다!',
        '양쪽 다 공격적! {atkBuild} vs {defBuild}, 컨트롤 싸움이 승부를 가릅니다!',
        '양 선수 풀 빌드 대결! 한 마리 차이로 승부가 갈릴 수 있습니다!',
      ],
    ),

    // 양쪽 운영 (12해처리/오버풀/3해처리히드라) 장기전
    const _BuildMatchupRule(
      attackerIds: {'zvz_12hatch', 'zvz_overpool', 'zvz_3hatch_hydra'},
      defenderIds: {'zvz_12hatch', 'zvz_overpool', 'zvz_3hatch_hydra'},
      texts: [
        '양 선수 모두 안정적인 운영! 뮤탈 싸움이 관건인 중후반전이 예상됩니다.',
        '{atkBuild} vs {defBuild}! 양쪽 다 확장하며 긴 경기를 준비합니다.',
        '양 선수 운영 체제! 공중 장악전이 승부를 가를 것 같습니다.',
      ],
    ),

    // ==================== PvP ====================

    // 치즈 vs 수비/밸런스 (다크올인/캐논러시/4게이트 vs 기어리버/투게이트드라군) 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvp_dark_allin', 'pvp_cannon_rush', 'pvp_4gate_dragoon'},
      defenderIds: {'pvp_1gate_robo', 'pvp_2gate_dragoon'},
      texts: [
        '빌드가 크게 갈렸습니다! {atk} 선수 {atkBuild}! {def} 선수가 막아낼 수 있을까요?',
        '{atkBuild}입니다! {def} 선수 {defBuild}인데, 이 공격을 넘겨야 합니다!',
        '{atk} 선수 승부수! {def} 선수 {defBuild}로 가고 있는데 대비가 됐을지!',
      ],
    ),

    // 공격 vs 수비 (리버드랍/질럿러시 vs 기어리버) 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvp_reaver_drop', 'pvp_zealot_rush'},
      defenderIds: {'pvp_1gate_robo'},
      texts: [
        '빌드가 갈렸는데요! {atk} 선수 {atkBuild}, {def} 선수는 {defBuild}! 이 공격을 막아야 합니다!',
        '{atkBuild} vs {defBuild}! {def} 선수가 리버로 방어에 성공할 수 있을지!',
        '{atk} 선수 공격적인 선택! {def} 선수 기어리버인데, 수비가 관건이겠네요!',
      ],
    ),

    // 양쪽 공격 (리버드랍/질럿러시/다크올인/4게이트/캐논러시) 극단적
    const _BuildMatchupRule(
      attackerIds: {'pvp_reaver_drop', 'pvp_zealot_rush', 'pvp_dark_allin', 'pvp_4gate_dragoon', 'pvp_cannon_rush'},
      defenderIds: {'pvp_reaver_drop', 'pvp_zealot_rush', 'pvp_dark_allin', 'pvp_4gate_dragoon', 'pvp_cannon_rush'},
      texts: [
        '양 선수 모두 공격적! {atkBuild} vs {defBuild}, 초반부터 폭풍 같은 경기!',
        '양쪽 다 올인에 가까운 선택! 누가 먼저 상대를 무너뜨리느냐의 싸움!',
        '{atkBuild} vs {defBuild}! PvP다운 불꽃 튀는 경기가 예상됩니다!',
      ],
    ),

    // 양쪽 안정 (투게이트드라군/기어리버) 장기전
    const _BuildMatchupRule(
      attackerIds: {'pvp_2gate_dragoon', 'pvp_1gate_robo'},
      defenderIds: {'pvp_2gate_dragoon', 'pvp_1gate_robo'},
      texts: [
        '양 선수 모두 안정적인 운영! 드라군 라인전이 관건인 장기전이 예상됩니다.',
        '{atkBuild} vs {defBuild}! 양쪽 다 안정적으로 가면서 리버 테크를 노립니다.',
        '양 선수 운영 체제! 확장과 테크 경쟁이 승부를 가를 것 같습니다.',
      ],
    ),
  ];

  /// 빌드 매치업 해설 규칙 데이터 클래스
  // (클래스 정의는 파일 하단에)

  // ==================== 빌드 반응 해설 시스템 ====================

  /// 빌드 반응 해설 규칙 (빌드 키워드 → 해설자 코멘터리)
  static final List<_BuildReactionRule> _buildReactionRules = [
    // 다크템플러 관련
    _BuildReactionRule(
      pattern: RegExp(r'다크템플러|다크|DT'),
      reactions: [
        '{opponent} 선수가 눈치채고 잘 막아 낼 수 있을까요!',
        '다크템플러입니다! {opponent} 선수 디텍터 준비는 됐을까요?',
        '은밀한 다크 투입! 이걸 읽었느냐가 관건입니다!',
        '다크가 나옵니다! {opponent} 선수 대비가 됐을지 궁금하네요.',
      ],
    ),
    // 럴커 관련
    _BuildReactionRule(
      pattern: RegExp(r'럴커'),
      reactions: [
        '럴커입니다! {opponent} 선수 디텍터가 있을까요?',
        '럴커 등장! 이걸로 전세가 뒤집힐 수 있습니다!',
        '럴커가 나왔는데요, {opponent} 선수 대응이 관건이겠네요!',
      ],
    ),
    // 러쉬/올인 관련
    _BuildReactionRule(
      pattern: RegExp(r'러쉬|공격|올인|돌격|질럿.*러쉬|저글링.*러쉬'),
      reactions: [
        '공격적인 선택입니다! {opponent} 선수가 버틸 수 있을까요!',
        '이 타이밍 러쉬를 막아낼 수 있을지가 관건입니다!',
        '과감한 선택! {opponent} 선수 수비 준비가 됐을까요?',
      ],
    ),
    // 드랍 관련
    _BuildReactionRule(
      pattern: RegExp(r'드랍|수송|셔틀'),
      reactions: [
        '드랍을 노리고 있습니다! {opponent} 선수가 읽을 수 있을까요?',
        '기습 드랍 준비! 이걸 읽느냐가 승부의 관건!',
        '드랍 타이밍인데요, {opponent} 선수 본진 수비가 관건입니다!',
      ],
    ),
    // 캐리어/모선 관련
    _BuildReactionRule(
      pattern: RegExp(r'캐리어|모선'),
      reactions: [
        '캐리어 전환! {opponent} 선수 대공 준비가 급해졌습니다!',
        '대함선 테크입니다! 이걸로 후반을 노리는 건가요?',
        '캐리어가 뜹니다! {opponent} 선수에겐 시간이 촉박해요!',
      ],
    ),
    // 아비터 관련
    _BuildReactionRule(
      pattern: RegExp(r'아비터'),
      reactions: [
        '아비터입니다! 리콜이 나오면 상황이 뒤집힐 수 있어요!',
        '아비터 테크! {opponent} 선수 EMP 준비가 급합니다!',
        '아비터가 나왔네요! 이 한방이 경기를 결정지을 수 있습니다!',
      ],
    ),
    // 하이템플러/스톰 관련
    _BuildReactionRule(
      pattern: RegExp(r'하이템플러|사이오닉|스톰'),
      reactions: [
        '하이템플러! 사이오닉 스톰 한 방이면 상황이 바뀝니다!',
        '스톰 테크입니다! {opponent} 선수 병력 분산이 관건이에요!',
        '하이템플러가 합류했습니다! 이 한 수가 클 수 있어요!',
      ],
    ),
    // 뮤탈리스크 관련
    _BuildReactionRule(
      pattern: RegExp(r'뮤탈리스크|뮤탈|스파이어'),
      reactions: [
        '뮤탈리스크! 공중 장악에 나섭니다!',
        '뮤탈이 뜹니다! {opponent} 선수 대공 준비가 됐을까요?',
        '스파이어 올렸습니다! 뮤탈 견제가 시작되겠네요!',
      ],
    ),
    // 배틀크루저 관련
    _BuildReactionRule(
      pattern: RegExp(r'배틀크루저|전투순양함'),
      reactions: [
        '배틀크루저입니다! 최종 병기가 나왔네요!',
        '배틀크루저 전환! {opponent} 선수가 막을 수 있을까요?',
      ],
    ),
    // 시즈탱크 관련
    _BuildReactionRule(
      pattern: RegExp(r'시즈.*모드|시즈탱크|탱크.*시즈'),
      reactions: [
        '시즈모드! 이 라인을 뚫을 수 있을까요!',
        '탱크가 자리 잡았습니다! 이 진지를 돌파해야 합니다!',
      ],
    ),
    // 핵/뉴클리어 관련
    _BuildReactionRule(
      pattern: RegExp(r'핵|뉴클리어|뉴크'),
      reactions: [
        '핵입니다!! 이걸 잡아내야 합니다!',
        '뉴클리어 준비! 이 한 방이면 끝날 수도 있어요!',
      ],
    ),
    // 리버 관련
    _BuildReactionRule(
      pattern: RegExp(r'리버'),
      reactions: [
        '리버가 나옵니다! 스캐럽 한 방이 무서운데요!',
        '리버 투입! {opponent} 선수 일꾼 관리가 관건이에요!',
      ],
    ),
    // 디파일러 관련
    _BuildReactionRule(
      pattern: RegExp(r'디파일러|플레이그|다크스웜'),
      reactions: [
        '디파일러! 이 마법 한 방이 전세를 뒤집을 수 있습니다!',
        '디파일러 합류! {opponent} 선수에게 큰 위협이 될 수 있어요!',
      ],
    ),
    // 가디언 관련
    _BuildReactionRule(
      pattern: RegExp(r'가디언'),
      reactions: [
        '가디언이 뜹니다! 지상 병력으로는 상대가 안 되는데요!',
        '가디언 전환! {opponent} 선수 대공 준비가 시급합니다!',
      ],
    ),
    // 레이스 관련
    _BuildReactionRule(
      pattern: RegExp(r'레이스'),
      reactions: [
        '레이스! 클로킹 견제가 시작되겠네요!',
        '레이스 투입! {opponent} 선수 디텍터가 준비됐을까요?',
      ],
    ),
    // 확장/멀티 관련
    _BuildReactionRule(
      pattern: RegExp(r'확장|멀티|앞마당|서드'),
      reactions: [
        '확장을 올립니다! 이 타이밍이 안전할까요?',
        '과감한 확장! {opponent} 선수가 이 틈을 노릴 수 있을텐데요!',
        '멀티 타이밍인데요, 견제가 들어오면 위험할 수 있습니다!',
      ],
    ),
  ];

  /// 빌드 반응 해설 생성 (25% 확률, 주요 빌드에만 반응)
  String? _getBuildReactionCommentary({
    required String buildText,
    required String builderName,
    required String opponentName,
    required String builderRace,
    required String opponentRace,
    Map<String, int>? usedTexts,
  }) {
    if (_random.nextDouble() > 0.25) return null; // 75% 스킵

    for (final rule in _buildReactionRules) {
      if (!rule.pattern.hasMatch(buildText)) continue;

      // 후보 텍스트 중 미사용 우선 선택
      final candidates = rule.reactions
          .map((r) => r.replaceAll('{builder}', builderName).replaceAll('{opponent}', opponentName))
          .toList();

      if (usedTexts != null) {
        final unused = candidates.where((t) => (usedTexts[t] ?? 0) == 0).toList();
        if (unused.isNotEmpty) return unused[_random.nextInt(unused.length)];
        // 모두 사용 → 가장 적게 사용된 것
        candidates.sort((a, b) => (usedTexts[a] ?? 0).compareTo(usedTexts[b] ?? 0));
        return candidates.first;
      }
      return candidates[_random.nextInt(candidates.length)];
    }
    return null;
  }

  // ==================== 어미 변환 시스템 ====================

  /// 빌드 스텝 텍스트 어미를 방송 해설 톤으로 변환 (30-40% 확률)
  String _transformEnding(String text) {
    if (_random.nextDouble() > 0.35) return text; // 65% 확률로 원본 유지

    // "~합니다." → 다양한 어미
    if (text.endsWith('합니다.')) {
      final endings = ['하구요.', '하죠.', '하네요.', '합니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    if (text.endsWith('합니다!')) {
      final endings = ['하죠!!', '하는데요!', '합니다!', '하네요!'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    // "~입니다." → 다양한 어미
    if (text.endsWith('입니다.')) {
      final endings = ['이구요.', '이죠.', '이네요.', '입니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    // "~했습니다." → 다양한 어미
    if (text.endsWith('했습니다.')) {
      final endings = ['했구요.', '했죠.', '했네요.', '했습니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 5)}$ending';
    }
    if (text.endsWith('했습니다!')) {
      final endings = ['했죠!!', '했는데요!', '했습니다!', '했네요!'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 5)}$ending';
    }
    // "~됩니다." → 다양한 어미
    if (text.endsWith('됩니다.')) {
      final endings = ['되구요.', '되죠.', '되네요.', '됩니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    // "~습니다." → 다양한 어미 (일반)
    if (text.endsWith('습니다.')) {
      final endings = ['구요.', '죠.', '네요.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    if (text.endsWith('습니다!')) {
      final endings = ['죠!!', '는데요!', '네요!'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 4)}$ending';
    }
    // "~건설!" → "~건설하구요."
    if (text.endsWith('건설!')) {
      final endings = ['건설하구요.', '건설!', '건설합니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 3)}$ending';
    }
    // "~생산!" → "~생산하구요."
    if (text.endsWith('생산!')) {
      final endings = ['생산하구요.', '생산!', '생산합니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 3)}$ending';
    }
    // "~시작!" → "~시작하구요."
    if (text.endsWith('시작!')) {
      final endings = ['시작하구요.', '시작!', '시작합니다.'];
      final ending = endings[_random.nextInt(endings.length)];
      return '${text.substring(0, text.length - 3)}$ending';
    }

    return text;
  }

  /// 현재 라인에 맞는 다음 스텝 가져오기
  BuildStep? _getNextStep(BuildOrder build, int currentIndex, int lineCount) {
    if (currentIndex >= build.steps.length) return null;

    final step = build.steps[currentIndex];
    // 현재 라인이 스텝의 라인과 같거나 지났으면 실행
    if (lineCount >= step.line) {
      return step;
    }
    return null;
  }

  /// 충돌 시뮬레이션
  _ClashResult _simulateClash({
    required Player homePlayer,
    required Player awayPlayer,
    required PlayerStats homeStats,
    required PlayerStats awayStats,
    required BuildStyle homeStyle,
    required BuildStyle awayStyle,
    required double winRate,
    required int lineCount,
    required int clashStartLine,
    required SimulationState currentState,
    GameMap? map,
    BuildType? homeBuildType,
    BuildType? awayBuildType,
    Set<String>? combinedUnitTags,
  }) {
    final clashDuration = lineCount - clashStartLine;
    final isZvZ = homePlayer.race == Race.zerg && awayPlayer.race == Race.zerg;

    // 현재 경기 단계 결정
    final gamePhase = GamePhase.fromLineCount(lineCount);
    final homeRaceStr = _getRaceString(homePlayer.race);
    final awayRaceStr = _getRaceString(awayPlayer.race);
    final matchup = '${homeRaceStr}v$awayRaceStr';

    // 단계별 가중치 적용된 능력치 계산
    final homeWeightedTotal = StatWeights.getWeightedTotal(
      sense: homeStats.sense,
      control: homeStats.control,
      attack: homeStats.attack,
      harass: homeStats.harass,
      strategy: homeStats.strategy,
      macro: homeStats.macro,
      defense: homeStats.defense,
      scout: homeStats.scout,
      phase: gamePhase,
      matchup: matchup,
    );

    final awayWeightedTotal = StatWeights.getWeightedTotal(
      sense: awayStats.sense,
      control: awayStats.control,
      attack: awayStats.attack,
      harass: awayStats.harass,
      strategy: awayStats.strategy,
      macro: awayStats.macro,
      defense: awayStats.defense,
      scout: awayStats.scout,
      phase: gamePhase,
      matchup: '${awayRaceStr}v$homeRaceStr',
    );

    // 우세한 쪽 결정 (가중치 적용된 능력치 + 공격성향)
    // 매 충돌마다 결정하여 홈/어웨이 편향 방지
    // 공격형 스타일이라도 매 이벤트마다 반드시 공격자가 되지는 않음
    // (수비형도 역습/반격/주도권 전환 가능)
    final homeAttackPower = homeStats.attack + homeStats.harass;
    final awayAttackPower = awayStats.attack + awayStats.harass;
    final homeIsAggressiveStyle = homeStyle == BuildStyle.aggressive || homeStyle == BuildStyle.cheese;
    final awayIsAggressiveStyle = awayStyle == BuildStyle.aggressive || awayStyle == BuildStyle.cheese;
    final bool isHomeAttacker;
    if (homeIsAggressiveStyle && !awayIsAggressiveStyle) {
      // 공격형 vs 비공격형: 70% 확률로 공격자 (30%는 역습/반격)
      isHomeAttacker = _random.nextDouble() < 0.70;
    } else if (awayIsAggressiveStyle && !homeIsAggressiveStyle) {
      isHomeAttacker = _random.nextDouble() >= 0.70; // away가 70% attacker
    } else {
      // 같은 스타일이면: 공격력 차이로 결정, 비슷하면 매번 랜덤
      final powerDiff = homeAttackPower - awayAttackPower;
      if (powerDiff > 50) {
        isHomeAttacker = _random.nextDouble() < 0.65; // 약간 유리
      } else if (powerDiff < -50) {
        isHomeAttacker = _random.nextDouble() >= 0.65;
      } else {
        isHomeAttacker = _random.nextBool(); // 매 충돌마다 랜덤
      }
    }

    // 충돌 이벤트 풀 (매치업별 종족 정보 + 맵 특성 + 능력치 전달)
    final attackerStats = isHomeAttacker ? homeStats : awayStats;
    final defenderStats = isHomeAttacker ? awayStats : homeStats;
    final attackerStyle = isHomeAttacker ? homeStyle : awayStyle;
    final defenderStyle = isHomeAttacker ? awayStyle : homeStyle;
    final events = BuildOrderData.getClashEvents(
      attackerStyle,
      defenderStyle,
      attackerRace: isHomeAttacker ? homeRaceStr : awayRaceStr,
      defenderRace: isHomeAttacker ? awayRaceStr : homeRaceStr,
      rushDistance: map?.rushDistance,
      resources: map?.resources,
      terrainComplexity: map?.terrainComplexity,
      airAccessibility: map?.airAccessibility,
      centerImportance: map?.centerImportance,
      hasIsland: map?.hasIsland,
      attackerAttack: attackerStats.attack,
      attackerHarass: attackerStats.harass,
      attackerControl: attackerStats.control,
      attackerStrategy: attackerStats.strategy,
      attackerMacro: attackerStats.macro,
      attackerSense: attackerStats.sense,
      defenderDefense: defenderStats.defense,
      defenderStrategy: defenderStats.strategy,
      defenderMacro: defenderStats.macro,
      defenderControl: defenderStats.control,
      defenderSense: defenderStats.sense,
      attackerBuildType: isHomeAttacker ? homeBuildType : awayBuildType,
      defenderBuildType: isHomeAttacker ? awayBuildType : homeBuildType,
      availableUnits: combinedUnitTags,
      gamePhase: gamePhase,
      attackerArmySize: isHomeAttacker ? currentState.homeArmy : currentState.awayArmy,
      defenderArmySize: isHomeAttacker ? currentState.awayArmy : currentState.homeArmy,
    );

    // 가중치 기반 이벤트 선택
    final event = _selectWeightedEvent(
      events: events,
      attackerStats: attackerStats,
      defenderStats: defenderStats,
      gamePhase: gamePhase,
      matchup: matchup,
    );

    // 텍스트 변환
    final attacker = isHomeAttacker ? homePlayer : awayPlayer;
    final defender = isHomeAttacker ? awayPlayer : homePlayer;
    var text = event.text
        .replaceAll('{attacker}', attacker.name)
        .replaceAll('{defender}', defender.name);

    // 병력/자원 변화 계산
    int homeArmyChange = isHomeAttacker ? event.attackerArmy : event.defenderArmy;
    int awayArmyChange = isHomeAttacker ? event.defenderArmy : event.attackerArmy;
    int homeResourceChange = isHomeAttacker ? event.attackerResource : event.defenderResource;
    int awayResourceChange = isHomeAttacker ? event.defenderResource : event.attackerResource;

    // 능력치에 따른 보정 (가중치 적용 + 차이가 클수록 더 큰 보정)
    if (event.favorsStat != null) {
      // 해당 능력치의 가중치 적용
      final statWeight = StatWeights.getCombinedWeight(event.favorsStat!, gamePhase, matchup);
      final homeStat = (_getStatValue(homeStats, event.favorsStat) * statWeight).round();
      final awayStat = (_getStatValue(awayStats, event.favorsStat) * statWeight).round();
      final statDiff = (homeStat - awayStat).abs();
      final modifier = 1.0 + (statDiff / 800).clamp(0.0, 0.3); // 최대 1.3배 (기존 500/0.5 → 800/0.3)

      if (homeStat > awayStat) {
        homeArmyChange = (homeArmyChange * (2 - modifier)).round();
        awayArmyChange = (awayArmyChange * modifier).round();
      } else if (awayStat > homeStat) {
        homeArmyChange = (homeArmyChange * modifier).round();
        awayArmyChange = (awayArmyChange * (2 - modifier)).round();
      }
    }

    // 경기 단계별 추가 보정 (병력 손실에 반영)
    final weightedDiff = homeWeightedTotal - awayWeightedTotal;
    final phaseBonus = (weightedDiff / 1500).clamp(-3.0, 3.0); // 단계별 ±3 보정 (기존 1000/5.0)

    // phaseBonus 적용: 우세한 쪽은 피해 감소, 열세 쪽은 피해 증가
    if (phaseBonus > 0) {
      homeArmyChange = (homeArmyChange * (1.0 - phaseBonus / 25)).round(); // 피해 최대 12% 감소 (기존 25%)
      awayArmyChange = (awayArmyChange * (1.0 + phaseBonus / 25)).round(); // 피해 최대 12% 증가
    } else if (phaseBonus < 0) {
      homeArmyChange = (homeArmyChange * (1.0 - phaseBonus / 25)).round();
      awayArmyChange = (awayArmyChange * (1.0 + phaseBonus / 25)).round();
    }

    // 종족 상성 보정 (클래시 데미지)
    // 1) TvZ 구조적 보정: 테란의 시즈모드/벙커 전투 이점 (+6%)
    // 2) 맵별 종족 상성: tvz 설정값 기반 (증폭률 0.5)
    if (!isZvZ) {
      final raceBonus = map?.matchup.getWinRate(homePlayer.race, awayPlayer.race) ?? 50;

      // TvZ 기본 보정 (53% 기준: 시뮬 엔진의 구조적 Z우위 상쇄)
      double baseRaceFactor = 0;
      final isTvZ = (homePlayer.race == Race.terran && awayPlayer.race == Race.zerg) ||
                    (homePlayer.race == Race.zerg && awayPlayer.race == Race.terran);
      if (isTvZ) {
        baseRaceFactor = homePlayer.race == Race.terran ? 0.025 : -0.025;
      }

      // 맵별 종족 상성 (증폭률 0.35, 극단값 clamp ±0.10)
      final mapRaceFactor = (raceBonus - 50) / 100 * 0.35;
      final totalFactor = (baseRaceFactor + mapRaceFactor).clamp(-0.10, 0.10);

      if (totalFactor != 0) {
        homeArmyChange = (homeArmyChange * (1.0 - totalFactor)).round();
        awayArmyChange = (awayArmyChange * (1.0 + totalFactor)).round();
      }
    }

    // 공격형 타이밍 보너스: 클래시 초반(15줄 이내)에서 공격형이 공격자일 때 데미지 강화
    // 수비형의 경제력이 발동하기 전 타이밍 공격의 위력을 반영
    if (clashDuration <= 15) {
      final attackerIsAggressive = isHomeAttacker
          ? (homeStyle == BuildStyle.aggressive || homeStyle == BuildStyle.cheese)
          : (awayStyle == BuildStyle.aggressive || awayStyle == BuildStyle.cheese);
      final defenderIsDefensive = isHomeAttacker
          ? (awayStyle == BuildStyle.defensive)
          : (homeStyle == BuildStyle.defensive);
      if (attackerIsAggressive && defenderIsDefensive) {
        // 공격형 공격자의 피해 20% 감소, 수비형 수비자의 피해 15% 증가
        if (isHomeAttacker) {
          homeArmyChange = (homeArmyChange * 0.80).round();
          awayArmyChange = (awayArmyChange * 1.15).round();
        } else {
          awayArmyChange = (awayArmyChange * 0.80).round();
          homeArmyChange = (homeArmyChange * 1.15).round();
        }
      }
    }

    // ========== 저그전 특별 규칙 (ZvZ) ==========
    // ZvZ에서는 이벤트 기반 데미지를 완전히 대체하여 ZvZ 전용 데미지만 적용
    if (isZvZ) {
      // 이벤트 기반 데미지 완전 리셋 (ZvZ 전용 로직으로 대체)
      homeArmyChange = 0;
      awayArmyChange = 0;
      homeResourceChange = 0;
      awayResourceChange = 0;

      final homeControl = homeStats.control;
      final awayControl = awayStats.control;
      final homeTotal = homeStats.total;
      final awayTotal = awayStats.total;

      // 초반 저글링 싸움 (clashDuration 0~20)
      if (clashDuration <= 20) {
        // 컨트롤 차이 (저글링 컨트롤)
        final controlDiff = (homeControl - awayControl).toDouble();

        // 공격력 차이 (저글링 물량/공격 타이밍)
        final attackDiff = (homeStats.attack - awayStats.attack) * 0.2;

        // 수비력이 높으면 저글링 방어 성공 (선링 막기)
        final homeDefAdv = (homeStats.defense - awayStats.defense) / 300;
        final awayDefAdv = (awayStats.defense - homeStats.defense) / 300;

        // 빌드 스타일에 따른 초반 우위
        double buildAdvantage = 0;
        if (homeStyle == BuildStyle.aggressive && awayStyle == BuildStyle.defensive) {
          buildAdvantage = 50;
        } else if (homeStyle == BuildStyle.defensive && awayStyle == BuildStyle.aggressive) {
          buildAdvantage = -50;
        } else if (homeStyle == BuildStyle.cheese && awayStyle == BuildStyle.defensive) {
          buildAdvantage = 25;
        } else if (homeStyle == BuildStyle.defensive && awayStyle == BuildStyle.cheese) {
          buildAdvantage = -25;
        }

        // 총합: 컨트롤 + 공격력 + 빌드상성 - 수비력 보정
        // 양수 = 홈 유리, 음수 = 어웨이 유리
        final defenseCounter = (awayStats.defense - homeStats.defense) * 0.3;
        final totalDiff = controlDiff + attackDiff + buildAdvantage - defenseCounter;

        // 60% 확률로 전투, 40% 포지셔닝
        if (_random.nextDouble() < 0.6) {
          if (totalDiff > 120) {
            final winTexts = [
              '${homePlayer.name} 선수, 저글링 컨트롤 압도!',
              '${homePlayer.name}, 저글링 서라운드 성공! 상대 병력 녹습니다!',
              '${homePlayer.name} 선수 저글링 포지셔닝이 한 수 위!',
            ];
            text = winTexts[_random.nextInt(winTexts.length)];
            final damage = (2 + (homeTotal - awayTotal) / 3000).clamp(1, 3).round();
            awayArmyChange -= damage;
            homeArmyChange -= 1;
          } else if (totalDiff < -120) {
            final winTexts = [
              '${awayPlayer.name} 선수, 저글링 컨트롤 압도!',
              '${awayPlayer.name}, 저글링 서라운드 성공! 상대 병력 녹습니다!',
              '${awayPlayer.name} 선수 저글링 포지셔닝이 한 수 위!',
            ];
            text = winTexts[_random.nextInt(winTexts.length)];
            final damage = (2 + (awayTotal - homeTotal) / 3000).clamp(1, 3).round();
            homeArmyChange -= damage;
            awayArmyChange -= 1;
          } else {
            // 비슷한 경우 - 양쪽 소량 피해
            final evenTexts = [
              '치열한 저글링 싸움! 서로 물고 물립니다!',
              '저글링 컨트롤 대결! 양 선수 팽팽합니다!',
              '양측 저글링이 맞물리며 소모전!',
              '서로 저글링을 주고받는 치열한 접전!',
              '저글링 교전! 아슬아슬한 수 싸움!',
            ];
            text = evenTexts[_random.nextInt(evenTexts.length)];
            const baseDamage = 2;
            homeArmyChange -= (baseDamage - homeDefAdv * 0.3).clamp(1, 3).round();
            awayArmyChange -= (baseDamage - awayDefAdv * 0.3).clamp(1, 3).round();
          }
        } else {
          // 비전투 이벤트 - 소규모 교전으로 양쪽 동일 피해
          final zlingTexts = [
            '${homePlayer.name}, 상대 확장 견제!',
            '${awayPlayer.name}, 상대 확장 견제!',
            '${homePlayer.name} 선수 언덕에서 유리한 교전!',
            '${awayPlayer.name} 선수 언덕에서 유리한 교전!',
            '${homePlayer.name} 선수 국지전 승리!',
            '${awayPlayer.name} 선수 국지전 승리!',
            '${homePlayer.name}, 드론 견제로 상대 경제 흔들기!',
            '${awayPlayer.name}, 드론 견제로 상대 경제 흔들기!',
            '${homePlayer.name} 선수, 성큰 올리며 방어 태세!',
            '${awayPlayer.name} 선수, 성큰 올리며 방어 태세!',
            '${homePlayer.name}, 오버로드로 상대 빌드 정찰!',
            '${awayPlayer.name}, 오버로드로 상대 빌드 정찰!',
          ];
          text = zlingTexts[_random.nextInt(zlingTexts.length)];
          // 소규모 교전: 양쪽 동일 피해
          final minorDamage = _random.nextInt(2) + 1;
          homeArmyChange -= minorDamage;
          awayArmyChange -= minorDamage;
        }
      }

      // 중반 과도기 (clashDuration 21~29): 저글링전에서 뮤탈전으로 전환
      if (clashDuration >= 21 && clashDuration <= 29) {
        final transitionTexts = [
          '${homePlayer.name} 선수, 스파이어 건설 시작!',
          '${awayPlayer.name} 선수, 스파이어 건설 시작!',
          '양측 모두 뮤탈리스크 전환을 노리고 있습니다!',
          '${homePlayer.name} 선수, 가스 확보에 집중!',
          '${awayPlayer.name} 선수, 멀티 해처리 건설!',
          '뮤탈리스크 등장이 임박합니다!',
          '${homePlayer.name}, 레어 테크 올리며 뮤탈 준비!',
          '${awayPlayer.name}, 레어 테크 올리며 뮤탈 준비!',
          '저글링전이 소강상태... 이제 공중전 준비입니다.',
          '가스 싸움이 중요해지는 시점이네요!',
          '${homePlayer.name} 선수, 해처리 추가하며 물량 준비!',
          '${awayPlayer.name} 선수, 해처리 추가하며 물량 준비!',
        ];
        text = transitionTexts[_random.nextInt(transitionTexts.length)];
        // 전환기: 경제 성장, 소량 피해
        // 수비형은 멀티 운영으로 경제적 보상
        final homeIsDef = homeStyle == BuildStyle.defensive || homeStyle == BuildStyle.balanced;
        final awayIsDef = awayStyle == BuildStyle.defensive || awayStyle == BuildStyle.balanced;
        homeResourceChange += _random.nextInt(30) + 10 + (homeIsDef ? 8 : 0);
        awayResourceChange += _random.nextInt(30) + 10 + (awayIsDef ? 8 : 0);
        // 수비형은 병력 보충도 소폭 유리 (해처리 추가 효과)
        homeArmyChange -= _random.nextInt(2) - (homeIsDef ? 1 : 0);
        awayArmyChange -= _random.nextInt(2) - (awayIsDef ? 1 : 0);
      }

      // 뮤탈전 (clashDuration 30 이후)
      if (clashDuration >= 30) {
        // 매크로 능력치 차이 반영: 수비/운영형이 뮤탈 물량에서 유리
        final homeMacroAdv = homeStyle == BuildStyle.defensive || homeStyle == BuildStyle.balanced
            ? homeStats.macro * 0.10 : 0.0;
        final awayMacroAdv = awayStyle == BuildStyle.defensive || awayStyle == BuildStyle.balanced
            ? awayStats.macro * 0.10 : 0.0;
        final effectiveControlDiff = (homeControl - awayControl) +
                                     (homeTotal - awayTotal) / 7 +
                                     homeMacroAdv - awayMacroAdv;
        if (_random.nextDouble() < 0.35) { // 35% 확률로 뮤탈 매직
          if (effectiveControlDiff > 100) {
            final winTexts = [
              '${homePlayer.name} 선수, 뮤탈 매직 작렬!',
              '${homePlayer.name}, 뮤탈 스택으로 상대 편대 박살!',
              '${homePlayer.name} 선수 뮤탈 컨트롤이 압도적입니다!',
            ];
            text = winTexts[_random.nextInt(winTexts.length)];
            final damage = (6 + (homeTotal - awayTotal) / 1500).clamp(4, 12).round();
            awayArmyChange -= damage;
            homeArmyChange -= 2;
          } else if (effectiveControlDiff < -100) {
            final winTexts = [
              '${awayPlayer.name} 선수, 뮤탈 매직 작렬!',
              '${awayPlayer.name}, 뮤탈 스택으로 상대 편대 박살!',
              '${awayPlayer.name} 선수 뮤탈 컨트롤이 압도적입니다!',
            ];
            text = winTexts[_random.nextInt(winTexts.length)];
            final damage = (6 + (awayTotal - homeTotal) / 1500).clamp(4, 12).round();
            homeArmyChange -= damage;
            awayArmyChange -= 2;
          } else {
            final evenTexts = [
              '양측 뮤탈리스크 공중전! 팽팽한 접전!',
              '뮤탈 대 뮤탈! 치열한 공중 싸움!',
              '뮤탈리스크 편대가 엉키며 혼전!',
              '뮤탈 스택 대결! 컨트롤로 승부합니다!',
            ];
            text = evenTexts[_random.nextInt(evenTexts.length)];
            final mutalDamage = _random.nextInt(4) + 3;
            homeArmyChange -= mutalDamage;
            awayArmyChange -= mutalDamage;
          }
        } else {
          // 뮤탈 견제/일꾼 사냥
          final isHomeHarass = _random.nextBool();
          final harasser = isHomeHarass ? homePlayer : awayPlayer;
          final victim = isHomeHarass ? awayPlayer : homePlayer;
          final harassTexts = [
            '${harasser.name} 선수, 뮤탈리스크로 일꾼 사냥!',
            '${harasser.name} 선수, 오버로드 사냥 성공!',
            '${harasser.name} 선수, 뮤탈리스크 히트앤런!',
            '${harasser.name}, 뮤탈로 ${victim.name} 본진 견제!',
            '${harasser.name} 선수, 스커지로 상대 뮤탈 요격!',
            '${harasser.name}, 멀티 해처리 드론 사냥!',
          ];
          text = harassTexts[_random.nextInt(harassTexts.length)];
          // 견제: 자원 피해 위주
          if (isHomeHarass) {
            awayResourceChange -= _random.nextInt(40) + 10;
          } else {
            homeResourceChange -= _random.nextInt(40) + 10;
          }
          // 뮤탈 교전 소규모 피해
          homeArmyChange -= _random.nextInt(2) + 1;
          awayArmyChange -= _random.nextInt(2) + 1;
        }
      }
    }

    // ========== 빠른 승리 (치즈/러쉬) ==========
    bool decisive = false;
    bool? homeWinOverride; // 이변 시 승자 강제 지정

    // ZvZ 빌드 상성 이변은 메인 루프에서 우선 처리 (여기서는 생략)

    // 치즈 빌드 + 초반 (20줄 이내) = 빠른 결정 확률
    if (!decisive && (homeStyle == BuildStyle.cheese || awayStyle == BuildStyle.cheese) && lineCount <= 20) {
      final cheesePlayer = homeStyle == BuildStyle.cheese ? homePlayer : awayPlayer;
      final cheeseStats = homeStyle == BuildStyle.cheese ? homeStats : awayStats;
      final cheeseDefenderStats = homeStyle == BuildStyle.cheese ? awayStats : homeStats;
      final cheeseDefenderStyle = homeStyle == BuildStyle.cheese ? awayStyle : homeStyle;

      // 공격력 vs 수비력 비교
      final attackPower = cheeseStats.attack + cheeseStats.sense;
      final defensePower = cheeseDefenderStats.defense + cheeseDefenderStats.scout;

      // 기본 성공률 4% per tick (이전: 15%)
      double baseRate = 0.04;

      // 수비 스타일에 따른 방어 보정
      if (cheeseDefenderStyle == BuildStyle.defensive) {
        baseRate *= 0.3; // DEF: 치즈 70% 감소 (하드카운터)
      } else if (cheeseDefenderStyle == BuildStyle.balanced) {
        baseRate *= 0.6; // BAL: 치즈 40% 감소
      }
      // AGG/CHE: 보정 없음 (취약)

      final statModifier = (attackPower - defensePower) / 1500;
      final cheeseSuccessRate = (baseRate + statModifier).clamp(0.01, 0.12);

      if (_random.nextDouble() < cheeseSuccessRate) {
        decisive = true;
        homeWinOverride = homeStyle == BuildStyle.cheese; // 치즈 성공한 쪽 승리
        text = '${cheesePlayer.name} 선수, 기습 성공! 상대 본진 초토화!';
      }
    }

    // 치즈 실패 페널티 - 올인 후 경제 열세로 병력 감소 가속
    if (!decisive && (homeStyle == BuildStyle.cheese || awayStyle == BuildStyle.cheese) && lineCount > 20) {
      final isHomeCheese = homeStyle == BuildStyle.cheese;
      // 치즈 플레이어는 line 20 이후 매 틱마다 병력 감소 (경제 없음)
      final penalty = _random.nextInt(3) + 2; // 2~4 감소
      if (isHomeCheese) {
        homeArmyChange -= penalty;
      } else {
        awayArmyChange -= penalty;
      }
    }

    // 공격형 빌드 + 공격력 높음 + 초반 (35줄 이내)
    if (!decisive && lineCount <= 35) {
      final homeIsAggressive = homeStyle == BuildStyle.aggressive && homeStats.attack >= 700;
      final awayIsAggressive = awayStyle == BuildStyle.aggressive && awayStats.attack >= 700;

      if (homeIsAggressive || awayIsAggressive) {
        // 양쪽 모두 공격형이면 랜덤으로 aggressor 선택
        final bool isHomeAggressor;
        if (homeIsAggressive && awayIsAggressive) {
          isHomeAggressor = _random.nextBool();
        } else {
          isHomeAggressor = homeIsAggressive;
        }
        final aggressor = isHomeAggressor ? homePlayer : awayPlayer;
        final aggressorStats = isHomeAggressor ? homeStats : awayStats;
        final defenderStats = isHomeAggressor ? awayStats : homeStats;

        // 공격력이 수비력보다 200 이상 높으면 빠른 GG
        if (aggressorStats.attack > defenderStats.defense + 200) {
          final rushSuccessRate = 0.12 + (aggressorStats.attack - defenderStats.defense) / 3000;
          if (_random.nextDouble() < rushSuccessRate.clamp(0.05, 0.25)) {
            decisive = true;
            homeWinOverride = isHomeAggressor; // 러시 성공한 쪽 승리
            text = '${aggressor.name} 선수, 압도적인 공격! 상대 무너집니다!';
          }
        }
      }
    }

    // ========== 역전 이벤트 (열세에서 한방) ==========
    final armyRatio = currentState.homeArmy / (currentState.awayArmy + 1);
    final isHomeUnderdog = armyRatio < 0.5; // 기준 강화: 0.6 → 0.5
    final isAwayUnderdog = armyRatio > 2.0;  // 기준 강화: 1.67 → 2.0

    if (!decisive && (isHomeUnderdog || isAwayUnderdog)) {
      final underdog = isHomeUnderdog ? homePlayer : awayPlayer;
      final underdogStats = isHomeUnderdog ? homeStats : awayStats;
      final favoredStats = isHomeUnderdog ? awayStats : homeStats;

      // 역전 확률: 전략/센스가 높으면 증가, 컨트롤이 높으면 증가
      final comebackChance = (
        (underdogStats.strategy - favoredStats.strategy) / 1000 +
        (underdogStats.sense - favoredStats.sense) / 1000 +
        (underdogStats.control - favoredStats.control) / 1500 +
        0.03  // 기본 3%
      ).clamp(0.01, 0.12);

      if (_random.nextDouble() < comebackChance) {
        decisive = true;
        homeWinOverride = isHomeUnderdog; // underdog가 역전 승리
        // 역전 텍스트 선택
        final comebackTexts = [
          '${underdog.name} 선수, 불리한 상황에서 기적같은 역전!',
          '${underdog.name} 선수, 읽기 싸움 승리! 카운터 빌드 적중!',
          '대단합니다! ${underdog.name} 선수, 물량 열세를 뒤집습니다!',
          '${underdog.name} 선수, 환상적인 한방 드랍으로 역전!',
          '숨막히는 역전극! ${underdog.name} 선수 승리!',
        ];
        text = comebackTexts[_random.nextInt(comebackTexts.length)];

        // 역전 시 병력 변화 (열세였던 쪽 유리)
        if (isHomeUnderdog) {
          homeArmyChange = 0;
          awayArmyChange = -20;
        } else {
          homeArmyChange = -20;
          awayArmyChange = 0;
        }
      }
    }

    // 일반 결정적 이벤트 확률 (후반)
    // 3단계 독립 체크 → 턴당 복합 확률:
    //   clashDuration 31~50: 6% (단일 체크)
    //   clashDuration 51~80: 1-(0.94×0.88) ≈ 17.3% (2개 체크)
    //   clashDuration 81+:  1-(0.94×0.88×0.80) ≈ 33.8% (3개 체크)
    // 경기 길어질수록 결정적 이벤트 확률 급상승 → 무한 경기 방지
    if (!decisive) {
      bool armyBasedWinner() {
        if (currentState.homeArmy > currentState.awayArmy) return true;
        if (currentState.awayArmy > currentState.homeArmy) return false;
        return _random.nextBool(); // 동일하면 랜덤
      }
      if (clashDuration > 30 && _random.nextDouble() < 0.06) {
        decisive = true;
        homeWinOverride = armyBasedWinner();
      }
      if (!decisive && clashDuration > 50 && _random.nextDouble() < 0.12) {
        decisive = true;
        homeWinOverride = armyBasedWinner();
      }
      if (!decisive && clashDuration > 80 && _random.nextDouble() < 0.20) {
        decisive = true;
        homeWinOverride = armyBasedWinner();
      }
    }

    // 병력 격차가 매우 크면 결정적 이벤트 (역전 기회 지나면)
    if (!decisive && (armyRatio > 2.5 || armyRatio < 0.4)) {
      decisive = true;
      homeWinOverride = armyRatio > 2.5; // 병력 우세한 쪽이 승리
      text = armyRatio > 2.5
          ? '${homePlayer.name} 선수 상대 본진 초토화!'
          : '${awayPlayer.name} 선수 상대 본진 초토화!';
    }

    return _ClashResult(
      text: text,
      homeArmyChange: homeArmyChange,
      awayArmyChange: awayArmyChange,
      homeResourceChange: homeResourceChange,
      awayResourceChange: awayResourceChange,
      decisive: decisive,
      homeWinOverride: homeWinOverride,
    );
  }

  /// 능력치 값 가져오기
  int _getStatValue(PlayerStats stats, String? statName) {
    if (statName == null) return 500;
    switch (statName) {
      case 'sense':
        return stats.sense;
      case 'control':
        return stats.control;
      case 'attack':
        return stats.attack;
      case 'harass':
        return stats.harass;
      case 'strategy':
        return stats.strategy;
      case 'macro':
        return stats.macro;
      case 'defense':
        return stats.defense;
      case 'scout':
        return stats.scout;
      default:
        return 500;
    }
  }

  /// 승패 조건 체크
  bool? _checkWinCondition(SimulationState state, int lineCount) {
    // 병력 0 이하 = 패배
    if (state.homeArmy <= 0) return false;
    if (state.awayArmy <= 0) return true;

    // 병력 격차 승리 조건 (최소 50줄 이후에만 체크)
    if (lineCount >= 50) {
      // 병력 5:1 격차 + 상대 병력 20 이하
      if (state.homeArmy >= state.awayArmy * 5 && state.awayArmy <= 20) {
        return true;
      }
      if (state.awayArmy >= state.homeArmy * 5 && state.homeArmy <= 20) {
        return false;
      }
    }

    // 후반전 (100줄 이후) 압도적 격차
    if (lineCount >= 100) {
      // 병력 3:1 격차 + 자원 2:1 격차
      final homeScore = state.homeArmy + state.homeResources / 10;
      final awayScore = state.awayArmy + state.awayResources / 10;

      if (homeScore >= awayScore * 3) return true;
      if (awayScore >= homeScore * 3) return false;
    }

    return null;
  }

  /// 폴백 시뮬레이션 (빌드가 없을 때)
  Stream<SimulationState> _fallbackSimulation({
    required Player homePlayer,
    required Player awayPlayer,
    required GameMap map,
    required int Function() getIntervalMs,
    required double winRate,
  }) async* {
    var state = const SimulationState();

    // 경기 시작 메시지
    state = state.copyWith(
      battleLogEntries: [
        const BattleLogEntry(text: '마이프로리그, 경기 시작했습니다!', owner: LogOwner.system),
        BattleLogEntry(text: '${map.name}에서 ${homePlayer.name} 선수와 ${awayPlayer.name} 선수가 맞붙습니다.', owner: LogOwner.system),
      ],
    );
    yield state;
    await Future.delayed(Duration(milliseconds: getIntervalMs()));

    int lineCount = 0;
    const maxLines = 200;

    final homeRace = _getRaceString(homePlayer.race);
    final awayRace = _getRaceString(awayPlayer.race);

    while (!state.isFinished && lineCount < maxLines) {
      lineCount++;

      // 이벤트 생성 (중후반 이벤트 풀 사용)
      final isHomeEvent = _random.nextDouble() < (winRate > 0.5 ? 0.55 : 0.45);
      final player = isHomeEvent ? homePlayer : awayPlayer;
      final currentArmy = isHomeEvent ? state.homeArmy : state.awayArmy;
      final currentResource = isHomeEvent ? state.homeResources : state.awayResources;
      final raceStr = isHomeEvent ? homeRace : awayRace;

      String text;
      int homeArmyChange = 0;
      int awayArmyChange = 0;
      int homeResourceChange = 0;
      int awayResourceChange = 0;

      // 중후반 이벤트 풀에서 선택
      final midLateStep = BuildOrderData.getMidLateEvent(
        lineCount: lineCount,
        currentArmy: currentArmy,
        currentResource: currentResource,
        race: raceStr,
        vsRace: isHomeEvent ? awayRace : homeRace,
      );

      text = midLateStep.text.replaceAll('{player}', player.name);

      if (isHomeEvent) {
        homeArmyChange = midLateStep.myArmy;
        homeResourceChange = midLateStep.myResource;
        awayArmyChange = midLateStep.enemyArmy;
        awayResourceChange = midLateStep.enemyResource;
      } else {
        awayArmyChange = midLateStep.myArmy;
        awayResourceChange = midLateStep.myResource;
        homeArmyChange = midLateStep.enemyArmy;
        homeResourceChange = midLateStep.enemyResource;
      }

      state = state.copyWith(
        homeArmy: (state.homeArmy + homeArmyChange).clamp(0, 200),
        awayArmy: (state.awayArmy + awayArmyChange).clamp(0, 200),
        homeResources: (state.homeResources + homeResourceChange).clamp(0, 10000),
        awayResources: (state.awayResources + awayResourceChange).clamp(0, 10000),
        battleLogEntries: [...state.battleLogEntries, BattleLogEntry(text: text, owner: isHomeEvent ? LogOwner.home : LogOwner.away)],
      );

      yield state;
      await Future.delayed(Duration(milliseconds: getIntervalMs()));

      // 승패 체크
      final result = _checkWinCondition(state, lineCount);
      if (result != null) {
        final winner = result ? homePlayer : awayPlayer;
        final loser = result ? awayPlayer : homePlayer;

        state = state.copyWith(
          isFinished: true,
          homeWin: result,
          battleLogEntries: [
            ...state.battleLogEntries,
            BattleLogEntry(text: '${loser.name} 선수, GG를 선언합니다.', owner: result ? LogOwner.away : LogOwner.home),
            BattleLogEntry(text: '${winner.name} 선수 승리!', owner: LogOwner.system),
          ],
        );
        yield state;
        return;
      }
    }

    // 강제 판정
    if (!state.isFinished) {
      final homeWin = _random.nextDouble() < winRate;
      final winner = homeWin ? homePlayer : awayPlayer;
      final loser = homeWin ? awayPlayer : homePlayer;

      state = state.copyWith(
        isFinished: true,
        homeWin: homeWin,
        battleLogEntries: [
          ...state.battleLogEntries,
          BattleLogEntry(text: '${loser.name} 선수, GG를 선언합니다.', owner: homeWin ? LogOwner.away : LogOwner.home),
          BattleLogEntry(text: '${winner.name} 선수 승리!', owner: LogOwner.system),
        ],
      );
      yield state;
    }
  }

  /// 가중치 기반 이벤트 선택
  /// favorsStat이 있는 이벤트는 해당 능력치가 높을수록 발생 확률 증가
  ClashEvent _selectWeightedEvent({
    required List<ClashEvent> events,
    required PlayerStats attackerStats,
    required PlayerStats defenderStats,
    required GamePhase gamePhase,
    required String matchup,
  }) {
    if (events.isEmpty) {
      throw StateError('Events list cannot be empty');
    }

    final weightedEvents = <MapEntry<ClashEvent, double>>[];

    for (final event in events) {
      double weight = 1.0;

      // favorsStat 기반 가중치 (해당 능력치 높으면 발생 확률 증가)
      if (event.favorsStat != null) {
        // 이벤트가 수비자 유리인지 확인 (공격자 피해가 더 크면 수비자 유리)
        final isDefenderFavored = event.attackerArmy < event.defenderArmy;
        final relevantStats = isDefenderFavored ? defenderStats : attackerStats;
        final stat = _getStatValue(relevantStats, event.favorsStat);
        // 능력치 600 기준, 높을수록 가중치 증가 (최대 1.5배)
        if (stat > 600) {
          weight *= 1.0 + (stat - 600) / 800; // 800에서 1.5배
        } else if (stat < 500) {
          weight *= 0.7 + (stat / 1000); // 낮으면 감소
        }

        // 경기 단계별 가중치 추가 적용
        final phaseWeight = StatWeights.getCombinedWeight(event.favorsStat!, gamePhase, matchup);
        weight *= (0.5 + phaseWeight / 2); // 단계별 가중치 영향 (0.5 ~ 1.0)
      }

      weightedEvents.add(MapEntry(event, weight.clamp(0.3, 2.0)));
    }

    // 과다선택 방지: 개별 이벤트가 전체의 4.5%를 넘지 않도록 캡핑
    final totalWeight = weightedEvents.fold<double>(0, (sum, e) => sum + e.value);
    final maxWeight = totalWeight * 0.045;
    for (int i = 0; i < weightedEvents.length; i++) {
      if (weightedEvents[i].value > maxWeight) {
        weightedEvents[i] = MapEntry(weightedEvents[i].key, maxWeight);
      }
    }

    // 가중치 기반 랜덤 선택
    return _weightedRandomSelect(weightedEvents);
  }

  /// 가중치 기반 랜덤 선택
  ClashEvent _weightedRandomSelect(List<MapEntry<ClashEvent, double>> weightedEvents) {
    final totalWeight = weightedEvents.fold<double>(0, (sum, e) => sum + e.value);
    var randomValue = _random.nextDouble() * totalWeight;

    for (final entry in weightedEvents) {
      randomValue -= entry.value;
      if (randomValue <= 0) {
        return entry.key;
      }
    }

    // 폴백 (마지막 이벤트 반환)
    return weightedEvents.last.key;
  }
}

class _ClashResult {
  final String text;
  final int homeArmyChange;
  final int awayArmyChange;
  final int homeResourceChange;
  final int awayResourceChange;
  final bool decisive;
  final bool? homeWinOverride; // 이변 시 승자 강제 지정 (null이면 winRate 사용)

  const _ClashResult({
    required this.text,
    required this.homeArmyChange,
    required this.awayArmyChange,
    required this.homeResourceChange,
    required this.awayResourceChange,
    required this.decisive,
    this.homeWinOverride,
  });
}

/// 인터랙션 규칙 (트리거-반응 매칭)
class _InteractionRule {
  final RegExp triggerPattern;
  final String triggerRace; // T/Z/P/* (트리거 종족)
  final String reactorRace; // T/Z/P/* (반응 종족)
  final List<String> reactions; // {reactor} 플레이스홀더

  const _InteractionRule({
    required this.triggerPattern,
    required this.triggerRace,
    required this.reactorRace,
    required this.reactions,
  });
}

/// 빌드 반응 해설 규칙 (빌드 키워드 → 해설자 코멘터리)
class _BuildReactionRule {
  final RegExp pattern;
  final List<String> reactions; // {builder}, {opponent} 플레이스홀더

  const _BuildReactionRule({
    required this.pattern,
    required this.reactions,
  });
}

/// 빌드 매치업 해설 규칙 (특정 빌드쌍 → 해설)
class _BuildMatchupRule {
  final Set<String> attackerIds; // 공격/주도권 측 빌드 ID 집합
  final Set<String> defenderIds; // 수비/확장 측 빌드 ID 집합
  final List<String> texts; // {atk}, {def}, {atkBuild}, {defBuild} 플레이스홀더

  const _BuildMatchupRule({
    required this.attackerIds,
    required this.defenderIds,
    required this.texts,
  });
}
