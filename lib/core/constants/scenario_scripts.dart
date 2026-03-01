import 'dart:math';
import '../../domain/services/match_simulation_service.dart';
import '../../domain/models/models.dart';

part 'scenario_tvz.dart';
part 'scenario_pvt.dart';
part 'scenario_zvp.dart';
part 'scenario_tvt.dart';
part 'scenario_zvz.dart';
part 'scenario_pvp.dart';

// ============================================================
// 시나리오 스크립트 데이터 클래스
// ============================================================

/// 맵 조건 필터
class MapRequirement {
  final int? minRushDistance;
  final int? maxRushDistance;
  final int? minAirAccessibility;
  final int? minTerrainComplexity;

  const MapRequirement({
    this.minRushDistance,
    this.maxRushDistance,
    this.minAirAccessibility,
    this.minTerrainComplexity,
  });

  bool matches(GameMap map) {
    if (minRushDistance != null && map.rushDistance < minRushDistance!) return false;
    if (maxRushDistance != null && map.rushDistance > maxRushDistance!) return false;
    if (minAirAccessibility != null && map.airAccessibility < minAirAccessibility!) return false;
    if (minTerrainComplexity != null && map.terrainComplexity < minTerrainComplexity!) return false;
    return true;
  }
}

/// 개별 이벤트
class ScriptEvent {
  final String text;
  final LogOwner owner;
  final int homeArmy;
  final int awayArmy;
  final int homeResource;
  final int awayResource;
  final String? favorsStat;
  final bool decisive;
  final double skipChance;
  final String? altText;
  final String? requiresMapTag; // 'rushShort', 'rushLong', 'airHigh', 'terrainHigh'

  const ScriptEvent({
    required this.text,
    required this.owner,
    this.homeArmy = 0,
    this.awayArmy = 0,
    this.homeResource = 0,
    this.awayResource = 0,
    this.favorsStat,
    this.decisive = false,
    this.skipChance = 0.0,
    this.altText,
    this.requiresMapTag,
  });
}

/// 조건부 분기
class ScriptBranch {
  final String id;
  final String? conditionStat;
  final bool homeStatMustBeHigher;
  final double baseProbability;
  final List<ScriptEvent> events;

  const ScriptBranch({
    required this.id,
    this.conditionStat,
    this.homeStatMustBeHigher = true,
    this.baseProbability = 1.0,
    required this.events,
  });
}

/// 경기 단계 (선형 또는 분기)
class ScriptPhase {
  final String name;
  final int startLine;
  final List<ScriptEvent>? linearEvents;
  final List<ScriptBranch>? branches;
  final int recoveryArmyPerLine;
  final int recoveryResourcePerLine;

  const ScriptPhase({
    required this.name,
    required this.startLine,
    this.linearEvents,
    this.branches,
    this.recoveryArmyPerLine = 0,
    this.recoveryResourcePerLine = 5,
  });
}

/// 시나리오 스크립트 전체
class ScenarioScript {
  final String id;
  final String matchup;
  final List<String> homeBuildIds;
  final List<String> awayBuildIds;
  final String description;
  final List<ScriptPhase> phases;
  final MapRequirement? mapRequirement;

  const ScenarioScript({
    required this.id,
    required this.matchup,
    required this.homeBuildIds,
    required this.awayBuildIds,
    required this.description,
    required this.phases,
    this.mapRequirement,
  });
}

// ============================================================
// 스크립트 선택 로직
// ============================================================

class ScenarioScriptData {
  static ScenarioScript? selectScript({
    required String matchup,
    required BuildType? homeBuildType,
    required BuildType? awayBuildType,
    required GameMap map,
    required Random random,
  }) {
    if (homeBuildType == null || awayBuildType == null) return null;

    final homeId = homeBuildType.id;
    final awayId = awayBuildType.id;

    // 1. 정확한 빌드ID 매칭
    final exactMatches = _allScripts.where((s) =>
      s.matchup == matchup &&
      s.homeBuildIds.contains(homeId) &&
      s.awayBuildIds.contains(awayId) &&
      (s.mapRequirement?.matches(map) ?? true)
    ).toList();

    if (exactMatches.isNotEmpty) {
      return exactMatches[random.nextInt(exactMatches.length)];
    }

    // 2. 역방향 매칭 (ZvT 빌드가 home이고 TvZ가 away인 경우 등)
    final reverseMatchup = _reverseMatchups[matchup];
    if (reverseMatchup != null) {
      final reverseMatches = _allScripts.where((s) =>
        s.matchup == reverseMatchup &&
        s.homeBuildIds.contains(awayId) &&
        s.awayBuildIds.contains(homeId) &&
        (s.mapRequirement?.matches(map) ?? true)
      ).toList();

      if (reverseMatches.isNotEmpty) {
        return reverseMatches[random.nextInt(reverseMatches.length)];
      }
    }

    return null; // 매칭 없으면 기존 시스템 사용
  }

  /// 스크립트에서 home/away가 반전되어 있는지 체크
  static bool isReversed({
    required ScenarioScript script,
    required BuildType? homeBuildType,
  }) {
    if (homeBuildType == null) return false;
    return !script.homeBuildIds.contains(homeBuildType.id);
  }

  // ============================================================
  // 전체 스크립트 목록 (종족별 파일에서 정의)
  // ============================================================

  static const Map<String, String> _reverseMatchups = {
    'TvZ': 'ZvT', 'ZvT': 'TvZ',
    'TvP': 'PvT', 'PvT': 'TvP',
    'ZvP': 'PvZ', 'PvZ': 'ZvP',
    // 미러 매치업은 역방향이 자기 자신
    'TvT': 'TvT', 'ZvZ': 'ZvZ', 'PvP': 'PvP',
  };

  static const List<ScenarioScript> _allScripts = [
    // TvZ (scenario_tvz.dart)
    _tvzBioVsMutal,
    _tvzMechVsLurker,
    _tvzCheeseVsStandard,
    _tvz111VsMacro,
    _tvzWraithVsMutal,
    _tvzCheeseVsCheese,
    _tvz9poolVsStandard,
    _tvzValkyrieVsMutal,
    _tvzDoubleVs3Hatch,
    _tvzStandardVs1HatchAllin,
    _tvzMechVsHive,
    // PvT (scenario_pvt.dart)
    _pvtDragoonExpandVsFactory,
    _pvtReaverVsTiming,
    _pvtDarkVsStandard,
    _pvtCheeseVsStandard,
    _pvtCarrierVsAnti,
    _pvt5gatePush,
    _pvtCheeseVsCheese,
    _pvtReaverVsBbs,
    _pvtMineTriple,
    _pvt11up8facVsExpand,
    _pvtFdTerran,
    // ZvP (scenario_zvp.dart)
    _zvpHydraVsForge,
    _zvpMutalVsForge,
    _zvp9poolVsForge,
    _zvpCheeseVsCheese,
    _zvpMukerjiVsCorsairReaver,
    _zvpScourgeDefiler,
    _zvp973HydraRush,
    _zvpStandardVs2Gate,
    _zvp3HatchVsCorsairReaver,
    _zvpHydraLurkerVsForge,
    _zvpCheeseVsForge,
    // TvT (scenario_tvt.dart)
    _tvtRaxDoubleVsFacDouble,
    _tvtBbsVsDouble,
    _tvtWraithVsRaxDouble,
    _tvt5facVsMineTriple,
    _tvtBbsVsTech,
    _tvtAggressiveMirror,
    _tvtCcFirstVs1facExpand,
    _tvtTwofacVs1facExpand,
    _tvt1facPushVs5fac,
    _tvtBbsMirror,
    _tvt1facPushMirror,
    _tvtWraithMirror,
    _tvt5facMirror,
    _tvtCcFirstMirror,
    _tvt2facVultureMirror,
    _tvt1facExpandMirror,
    // ZvZ (scenario_zvz.dart)
    _zvz9poolVs9overpool,
    _zvz12hatchVs9pool,
    _zvz4poolVs12hatch,
    _zvz3hatchMirror,
    _zvz4poolVs9pool,
    _zvz4poolVs3hatch,
    _zvz9poolMirror,
    _zvz12poolVs3hatch,
    _zvz9overpoolMirror,
    // PvP (scenario_pvp.dart)
    _pvpDragoonNexusMirror,
    _pvpDragoonVsNogate,
    _pvpRoboVs2gateDragoon,
    _pvpDarkVsDragoon,
    _pvpZealotRush,
    _pvpDarkVsZealotRush,
    _pvpRoboMirror,
    _pvp4gateVsMulti,
    _pvpZealotRushVsReaver,
    _pvpDarkMirror,
  ];
}
