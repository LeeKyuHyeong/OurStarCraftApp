import 'dart:math';
import '../../domain/services/match_simulation_service.dart';
import '../../domain/models/models.dart';

// TvZ (49 scenarios - 7T × 7Z, 오프닝 기반 1:1)
// 노배럭더블 (7)
part 'scenarios/tvz/nobar_double_vs_2hatch_mutal.dart';
part 'scenarios/tvz/nobar_double_vs_4pool.dart';
part 'scenarios/tvz/nobar_double_vs_530_mutal.dart';
part 'scenarios/tvz/nobar_double_vs_lurker_defiler.dart';
part 'scenarios/tvz/nobar_double_vs_mutal_lurker.dart';
part 'scenarios/tvz/nobar_double_vs_mutal_ultra.dart';
part 'scenarios/tvz/nobar_double_vs_ultra_hive.dart';
// 배럭더블 (7)
part 'scenarios/tvz/bar_double_vs_2hatch_mutal.dart';
part 'scenarios/tvz/bar_double_vs_4pool.dart';
part 'scenarios/tvz/bar_double_vs_530_mutal.dart';
part 'scenarios/tvz/bar_double_vs_lurker_defiler.dart';
part 'scenarios/tvz/bar_double_vs_mutal_lurker.dart';
part 'scenarios/tvz/bar_double_vs_mutal_ultra.dart';
part 'scenarios/tvz/bar_double_vs_ultra_hive.dart';
// 111 (7)
part 'scenarios/tvz/111_vs_2hatch_mutal.dart';
part 'scenarios/tvz/111_vs_4pool.dart';
part 'scenarios/tvz/111_vs_530_mutal.dart';
part 'scenarios/tvz/111_vs_lurker_defiler.dart';
part 'scenarios/tvz/111_vs_mutal_lurker.dart';
part 'scenarios/tvz/111_vs_mutal_ultra.dart';
part 'scenarios/tvz/111_vs_ultra_hive.dart';
// 2배럭아카데미 (7)
part 'scenarios/tvz/2bar_academy_vs_2hatch_mutal.dart';
part 'scenarios/tvz/2bar_academy_vs_4pool.dart';
part 'scenarios/tvz/2bar_academy_vs_530_mutal.dart';
part 'scenarios/tvz/2bar_academy_vs_lurker_defiler.dart';
part 'scenarios/tvz/2bar_academy_vs_mutal_lurker.dart';
part 'scenarios/tvz/2bar_academy_vs_mutal_ultra.dart';
part 'scenarios/tvz/2bar_academy_vs_ultra_hive.dart';
// 팩토리더블 (7)
part 'scenarios/tvz/fac_double_vs_2hatch_mutal.dart';
part 'scenarios/tvz/fac_double_vs_4pool.dart';
part 'scenarios/tvz/fac_double_vs_530_mutal.dart';
part 'scenarios/tvz/fac_double_vs_lurker_defiler.dart';
part 'scenarios/tvz/fac_double_vs_mutal_lurker.dart';
part 'scenarios/tvz/fac_double_vs_mutal_ultra.dart';
part 'scenarios/tvz/fac_double_vs_ultra_hive.dart';
// 2스타레이스 (7)
part 'scenarios/tvz/2star_vs_2hatch_mutal.dart';
part 'scenarios/tvz/2star_vs_4pool.dart';
part 'scenarios/tvz/2star_vs_530_mutal.dart';
part 'scenarios/tvz/2star_vs_lurker_defiler.dart';
part 'scenarios/tvz/2star_vs_mutal_lurker.dart';
part 'scenarios/tvz/2star_vs_mutal_ultra.dart';
part 'scenarios/tvz/2star_vs_ultra_hive.dart';
// BBS (7)
part 'scenarios/tvz/bbs_vs_2hatch_mutal.dart';
part 'scenarios/tvz/bbs_vs_4pool.dart';
part 'scenarios/tvz/bbs_vs_530_mutal.dart';
part 'scenarios/tvz/bbs_vs_lurker_defiler.dart';
part 'scenarios/tvz/bbs_vs_mutal_lurker.dart';
part 'scenarios/tvz/bbs_vs_mutal_ultra.dart';
part 'scenarios/tvz/bbs_vs_ultra_hive.dart';

// TvT (36 scenarios - 8 mirrors + 28 cross matchups)
// 미러 (8)
part 'scenarios/tvt/bbs_mirror.dart';
part 'scenarios/tvt/1bar_double_mirror.dart';
part 'scenarios/tvt/1fac_double_mirror.dart';
part 'scenarios/tvt/1fac_1star_mirror.dart';
part 'scenarios/tvt/2fac_push_mirror.dart';
part 'scenarios/tvt/2star_mirror.dart';
part 'scenarios/tvt/nobar_double_mirror.dart';
part 'scenarios/tvt/fd_rush_mirror.dart';
// BBS 크로스 (6)
part 'scenarios/tvt/bbs_vs_1bar_double.dart';
part 'scenarios/tvt/bbs_vs_1fac_double.dart';
part 'scenarios/tvt/bbs_vs_1fac_1star.dart';
part 'scenarios/tvt/bbs_vs_2fac_push.dart';
part 'scenarios/tvt/bbs_vs_2star.dart';
part 'scenarios/tvt/bbs_vs_nobar_double.dart';
// 원팩원스타 크로스 (5)
part 'scenarios/tvt/1fac_1star_vs_2fac_push.dart';
part 'scenarios/tvt/1fac_1star_vs_2star.dart';
part 'scenarios/tvt/1fac_1star_vs_1bar_double.dart';
part 'scenarios/tvt/1fac_1star_vs_1fac_double.dart';
part 'scenarios/tvt/1fac_1star_vs_nobar_double.dart';
// 투팩 크로스 (4)
part 'scenarios/tvt/1bar_double_vs_2fac_push.dart';
part 'scenarios/tvt/2fac_push_vs_1fac_double.dart';
part 'scenarios/tvt/2star_vs_2fac_push.dart';
part 'scenarios/tvt/2fac_push_vs_nobar_double.dart';
// 투스타 크로스 (3)
part 'scenarios/tvt/2star_vs_1bar_double.dart';
part 'scenarios/tvt/2star_vs_1fac_double.dart';
part 'scenarios/tvt/2star_vs_nobar_double.dart';
// 확장형 크로스 (3)
part 'scenarios/tvt/1bar_double_vs_1fac_double.dart';
part 'scenarios/tvt/nobar_double_vs_1bar_double.dart';
part 'scenarios/tvt/1fac_double_vs_nobar_double.dart';
// FD러쉬 크로스 (7)
part 'scenarios/tvt/fd_rush_vs_bbs.dart';
part 'scenarios/tvt/fd_rush_vs_1fac_1star.dart';
part 'scenarios/tvt/fd_rush_vs_2fac_push.dart';
part 'scenarios/tvt/fd_rush_vs_2star.dart';
part 'scenarios/tvt/fd_rush_vs_1bar_double.dart';
part 'scenarios/tvt/fd_rush_vs_1fac_double.dart';
part 'scenarios/tvt/fd_rush_vs_nobar_double.dart';

// PvT (54 scenarios - 9P × 6T, 모두 1:1)
// 센터 게이트 (6)
part 'scenarios/pvt/proxy_gate_vs_bbs.dart';
part 'scenarios/pvt/proxy_gate_vs_tank_defense.dart';
part 'scenarios/pvt/proxy_gate_vs_timing_push.dart';
part 'scenarios/pvt/proxy_gate_vs_upgrade.dart';
part 'scenarios/pvt/proxy_gate_vs_bio_mech.dart';
part 'scenarios/pvt/proxy_gate_vs_anti_carrier.dart';
// 초패스트다크 (6)
part 'scenarios/pvt/dark_swing_vs_bbs.dart';
part 'scenarios/pvt/dark_swing_vs_tank_defense.dart';
part 'scenarios/pvt/dark_swing_vs_timing_push.dart';
part 'scenarios/pvt/dark_swing_vs_upgrade.dart';
part 'scenarios/pvt/dark_swing_vs_bio_mech.dart';
part 'scenarios/pvt/dark_swing_vs_anti_carrier.dart';
// 선질럿 (6)
part 'scenarios/pvt/2gate_open_vs_bbs.dart';
part 'scenarios/pvt/2gate_open_vs_tank_defense.dart';
part 'scenarios/pvt/2gate_open_vs_timing_push.dart';
part 'scenarios/pvt/2gate_open_vs_upgrade.dart';
part 'scenarios/pvt/2gate_open_vs_bio_mech.dart';
part 'scenarios/pvt/2gate_open_vs_anti_carrier.dart';
// 5게이트 푸시 (6)
part 'scenarios/pvt/5gate_push_vs_bbs.dart';
part 'scenarios/pvt/5gate_push_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_push_vs_timing_push.dart';
part 'scenarios/pvt/5gate_push_vs_upgrade.dart';
part 'scenarios/pvt/5gate_push_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_push_vs_anti_carrier.dart';
// 5게이트 아비터 (6)
part 'scenarios/pvt/5gate_arbiter_vs_bbs.dart';
part 'scenarios/pvt/5gate_arbiter_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_arbiter_vs_timing_push.dart';
part 'scenarios/pvt/5gate_arbiter_vs_upgrade.dart';
part 'scenarios/pvt/5gate_arbiter_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_arbiter_vs_anti_carrier.dart';
// 5게이트 캐리어 (6)
part 'scenarios/pvt/5gate_carrier_vs_bbs.dart';
part 'scenarios/pvt/5gate_carrier_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_carrier_vs_timing_push.dart';
part 'scenarios/pvt/5gate_carrier_vs_upgrade.dart';
part 'scenarios/pvt/5gate_carrier_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_carrier_vs_anti_carrier.dart';
// 셔틀리버 푸시 (6)
part 'scenarios/pvt/reaver_push_vs_bbs.dart';
part 'scenarios/pvt/reaver_push_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_push_vs_timing_push.dart';
part 'scenarios/pvt/reaver_push_vs_upgrade.dart';
part 'scenarios/pvt/reaver_push_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_push_vs_anti_carrier.dart';
// 셔틀리버 아비터 (6)
part 'scenarios/pvt/reaver_arbiter_vs_bbs.dart';
part 'scenarios/pvt/reaver_arbiter_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_arbiter_vs_timing_push.dart';
part 'scenarios/pvt/reaver_arbiter_vs_upgrade.dart';
part 'scenarios/pvt/reaver_arbiter_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_arbiter_vs_anti_carrier.dart';
// 셔틀리버 캐리어 (6)
part 'scenarios/pvt/reaver_carrier_vs_bbs.dart';
part 'scenarios/pvt/reaver_carrier_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_carrier_vs_timing_push.dart';
part 'scenarios/pvt/reaver_carrier_vs_upgrade.dart';
part 'scenarios/pvt/reaver_carrier_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_carrier_vs_anti_carrier.dart';

// PvP (36 scenarios - 8 mirrors + 28 cross, 모두 1:1)
// 미러 (8)
part 'scenarios/pvp/dragoon_nexus_mirror.dart';
part 'scenarios/pvp/dark_mirror.dart';
part 'scenarios/pvp/1gate_robo_mirror.dart';
part 'scenarios/pvp/zealot_rush_mirror.dart';
part 'scenarios/pvp/4gate_dragoon_mirror.dart';
part 'scenarios/pvp/1gate_multi_mirror.dart';
part 'scenarios/pvp/2gate_reaver_mirror.dart';
part 'scenarios/pvp/3gate_speedzealot_mirror.dart';
// 기존 1:1 크로스 (2)
part 'scenarios/pvp/dragoon_vs_nogate.dart';
part 'scenarios/pvp/4gate_vs_multi.dart';
// 2gate_dragoon 크로스 (6)
part 'scenarios/pvp/dark_vs_2gate_dragoon.dart';
part 'scenarios/pvp/1gate_robo_vs_2gate_dragoon.dart';
part 'scenarios/pvp/2gate_reaver_vs_2gate_dragoon.dart';
part 'scenarios/pvp/zealot_rush_vs_2gate_dragoon.dart';
part 'scenarios/pvp/3gate_speedzealot_vs_2gate_dragoon.dart';
part 'scenarios/pvp/2gate_dragoon_vs_4gate_dragoon.dart';
// dark 크로스 (6)
part 'scenarios/pvp/dark_vs_1gate_robo.dart';
part 'scenarios/pvp/dark_vs_zealot_rush_single.dart';
part 'scenarios/pvp/dark_vs_4gate_dragoon.dart';
part 'scenarios/pvp/dark_vs_1gate_multi.dart';
part 'scenarios/pvp/dark_vs_2gate_reaver.dart';
part 'scenarios/pvp/dark_vs_3gate_speedzealot.dart';
// robo/reaver 크로스 (4)
part 'scenarios/pvp/1gate_robo_vs_4gate_dragoon.dart';
part 'scenarios/pvp/1gate_robo_vs_1gate_multi.dart';
part 'scenarios/pvp/1gate_robo_vs_2gate_reaver.dart';
part 'scenarios/pvp/2gate_reaver_vs_3gate_speedzealot.dart';
// zealot/speedzealot 크로스 (6)
part 'scenarios/pvp/zealot_rush_vs_1gate_robo.dart';
part 'scenarios/pvp/zealot_rush_vs_4gate_dragoon.dart';
part 'scenarios/pvp/zealot_rush_vs_1gate_multi.dart';
part 'scenarios/pvp/zealot_rush_vs_2gate_reaver.dart';
part 'scenarios/pvp/zealot_rush_vs_3gate_speedzealot.dart';
part 'scenarios/pvp/3gate_speedzealot_vs_1gate_robo.dart';
// multi/reaver/4gate 크로스 (4)
part 'scenarios/pvp/1gate_multi_vs_2gate_reaver.dart';
part 'scenarios/pvp/1gate_multi_vs_3gate_speedzealot.dart';
part 'scenarios/pvp/4gate_dragoon_vs_3gate_speedzealot.dart';
part 'scenarios/pvp/2gate_reaver_vs_4gate_dragoon.dart';

// ZvP (63 scenarios - 9Z × 7P, 모두 1:1)
// 4풀 (7)
part 'scenarios/zvp/4pool_vs_proxy_gate.dart';
part 'scenarios/zvp/4pool_vs_cannon_rush.dart';
part 'scenarios/zvp/4pool_vs_2star_corsair.dart';
part 'scenarios/zvp/4pool_vs_dragoon_push.dart';
part 'scenarios/zvp/4pool_vs_corsair.dart';
part 'scenarios/zvp/4pool_vs_archon.dart';
part 'scenarios/zvp/4pool_vs_forge_expand.dart';
// 5드론 (7)
part 'scenarios/zvp/5drone_vs_proxy_gate.dart';
part 'scenarios/zvp/5drone_vs_cannon_rush.dart';
part 'scenarios/zvp/5drone_vs_2star_corsair.dart';
part 'scenarios/zvp/5drone_vs_dragoon_push.dart';
part 'scenarios/zvp/5drone_vs_corsair.dart';
part 'scenarios/zvp/5drone_vs_archon.dart';
part 'scenarios/zvp/5drone_vs_forge_expand.dart';
// 5해처리 히드라 (7)
part 'scenarios/zvp/5hatch_hydra_vs_proxy_gate.dart';
part 'scenarios/zvp/5hatch_hydra_vs_cannon_rush.dart';
part 'scenarios/zvp/5hatch_hydra_vs_2star_corsair.dart';
part 'scenarios/zvp/5hatch_hydra_vs_dragoon_push.dart';
part 'scenarios/zvp/5hatch_hydra_vs_corsair.dart';
part 'scenarios/zvp/5hatch_hydra_vs_archon.dart';
part 'scenarios/zvp/5hatch_hydra_vs_forge_expand.dart';
// 뮤탈 히드라 (7)
part 'scenarios/zvp/mutal_hydra_vs_proxy_gate.dart';
part 'scenarios/zvp/mutal_hydra_vs_cannon_rush.dart';
part 'scenarios/zvp/mutal_hydra_vs_2star_corsair.dart';
part 'scenarios/zvp/mutal_hydra_vs_dragoon_push.dart';
part 'scenarios/zvp/mutal_hydra_vs_corsair.dart';
part 'scenarios/zvp/mutal_hydra_vs_archon.dart';
part 'scenarios/zvp/mutal_hydra_vs_forge_expand.dart';
// 하이브 디파일러 (7)
part 'scenarios/zvp/hive_defiler_vs_proxy_gate.dart';
part 'scenarios/zvp/hive_defiler_vs_cannon_rush.dart';
part 'scenarios/zvp/hive_defiler_vs_2star_corsair.dart';
part 'scenarios/zvp/hive_defiler_vs_dragoon_push.dart';
part 'scenarios/zvp/hive_defiler_vs_corsair.dart';
part 'scenarios/zvp/hive_defiler_vs_archon.dart';
part 'scenarios/zvp/hive_defiler_vs_forge_expand.dart';
// 973 히드라 (7)
part 'scenarios/zvp/973_hydra_vs_proxy_gate.dart';
part 'scenarios/zvp/973_hydra_vs_cannon_rush.dart';
part 'scenarios/zvp/973_hydra_vs_2star_corsair.dart';
part 'scenarios/zvp/973_hydra_vs_dragoon_push.dart';
part 'scenarios/zvp/973_hydra_vs_corsair.dart';
part 'scenarios/zvp/973_hydra_vs_archon.dart';
part 'scenarios/zvp/973_hydra_vs_forge_expand.dart';
// 뮤커지 (7)
part 'scenarios/zvp/mukerji_vs_proxy_gate.dart';
part 'scenarios/zvp/mukerji_vs_cannon_rush.dart';
part 'scenarios/zvp/mukerji_vs_2star_corsair.dart';
part 'scenarios/zvp/mukerji_vs_dragoon_push.dart';
part 'scenarios/zvp/mukerji_vs_corsair.dart';
part 'scenarios/zvp/mukerji_vs_archon.dart';
part 'scenarios/zvp/mukerji_vs_forge_expand.dart';
// 야바위 (7)
part 'scenarios/zvp/yabarwi_vs_proxy_gate.dart';
part 'scenarios/zvp/yabarwi_vs_cannon_rush.dart';
part 'scenarios/zvp/yabarwi_vs_2star_corsair.dart';
part 'scenarios/zvp/yabarwi_vs_dragoon_push.dart';
part 'scenarios/zvp/yabarwi_vs_corsair.dart';
part 'scenarios/zvp/yabarwi_vs_archon.dart';
part 'scenarios/zvp/yabarwi_vs_forge_expand.dart';
// 히드라 럴커 (7)
part 'scenarios/zvp/hydra_lurker_vs_proxy_gate.dart';
part 'scenarios/zvp/hydra_lurker_vs_cannon_rush.dart';
part 'scenarios/zvp/hydra_lurker_vs_2star_corsair.dart';
part 'scenarios/zvp/hydra_lurker_vs_dragoon_push.dart';
part 'scenarios/zvp/hydra_lurker_vs_corsair.dart';
part 'scenarios/zvp/hydra_lurker_vs_archon.dart';
part 'scenarios/zvp/hydra_lurker_vs_forge_expand.dart';

// ZvZ (21 scenarios - 6 mirrors + 15 cross, 모두 1:1)
// 미러 (6)
part 'scenarios/zvz/4pool_mirror.dart';
part 'scenarios/zvz/9pool_speed_mirror.dart';
part 'scenarios/zvz/9pool_lair_mirror.dart';
part 'scenarios/zvz/9overpool_mirror.dart';
part 'scenarios/zvz/12pool_mirror.dart';
part 'scenarios/zvz/12hatch_mirror.dart';
// 4pool 크로스 (5)
part 'scenarios/zvz/4pool_vs_9pool_speed.dart';
part 'scenarios/zvz/4pool_vs_9pool_lair.dart';
part 'scenarios/zvz/4pool_vs_9overpool.dart';
part 'scenarios/zvz/4pool_vs_12pool.dart';
part 'scenarios/zvz/4pool_vs_12hatch.dart';
// 9pool_speed 크로스 (4)
part 'scenarios/zvz/9pool_speed_vs_9pool_lair.dart';
part 'scenarios/zvz/9pool_speed_vs_9overpool.dart';
part 'scenarios/zvz/9pool_speed_vs_12pool.dart';
part 'scenarios/zvz/9pool_speed_vs_12hatch.dart';
// 9pool_lair 크로스 (3)
part 'scenarios/zvz/9pool_lair_vs_9overpool.dart';
part 'scenarios/zvz/9pool_lair_vs_12pool.dart';
part 'scenarios/zvz/9pool_lair_vs_12hatch.dart';
// 9overpool 크로스 (2)
part 'scenarios/zvz/9overpool_vs_12pool.dart';
part 'scenarios/zvz/9overpool_vs_12hatch.dart';
// 12hatch/12pool 크로스 (1)
part 'scenarios/zvz/12hatch_vs_12pool.dart';

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
  final bool decisive;
  final double skipChance;
  final String? altText;
  final String? requiresMapTag; // 'rushShort', 'rushLong', 'airHigh', 'terrainHigh'
  final bool homeExpansion; // true면 홈 확장 (앞마당/추가 확장) → 홈 recovery 증가
  final bool awayExpansion; // true면 어웨이 확장 → 어웨이 recovery 증가

  const ScriptEvent({
    required this.text,
    required this.owner,
    this.homeArmy = 0,
    this.awayArmy = 0,
    this.homeResource = 0,
    this.awayResource = 0,
    this.decisive = false,
    this.skipChance = 0.0,
    this.altText,
    this.requiresMapTag,
    this.homeExpansion = false,
    this.awayExpansion = false,
  });
}

/// 조건부 분기
class ScriptBranch {
  final String id;

  /// 분기 한국어 설명 (통계 리포트용)
  final String? description;

  final String? conditionStat;
  final bool homeStatMustBeHigher;
  final double baseProbability;
  final List<ScriptEvent> events;

  /// 빌드 ID 기반 분기 조건 (트랜지션 분기용)
  /// 설정 시 해당 빌드 ID와 매칭되는 경우에만 이 분기가 후보에 포함됨
  final List<String>? conditionHomeBuildIds;
  final List<String>? conditionAwayBuildIds;

  /// 분기 체인 조건: 이전 Phase들에서 선택된 분기 ID 중 이 리스트의 모든 항목이 존재해야 후보에 포함
  /// 미설정(null/빈 리스트) → 체인 조건 없음 (기존 동작 유지)
  final List<String>? conditionPriorBranchIds;

  const ScriptBranch({
    required this.id,
    this.description,
    this.conditionStat,
    this.homeStatMustBeHigher = true,
    this.baseProbability = 1.0,
    required this.events,
    this.conditionHomeBuildIds,
    this.conditionAwayBuildIds,
    this.conditionPriorBranchIds,
  });
}

/// 경기 단계 (선형 또는 분기)
class ScriptPhase {
  final String name;
  final int? startLine;
  final List<ScriptEvent>? linearEvents;
  final List<ScriptBranch>? branches;
  final int recoveryArmyPerLine;
  final int recoveryResourcePerLine;

  const ScriptPhase({
    required this.name,
    this.startLine,
    this.linearEvents,
    this.branches,
    this.recoveryArmyPerLine = 0,
    this.recoveryResourcePerLine = 50,
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
  /// decisive 분기 선택 확률 가중치 (기본 1.0)
  /// > 1.0: decisive 종료 비율 증가, < 1.0: 감소
  final double decisiveWeight;

  const ScenarioScript({
    required this.id,
    required this.matchup,
    required this.homeBuildIds,
    required this.awayBuildIds,
    required this.description,
    required this.phases,
    this.mapRequirement,
    this.decisiveWeight = 1.0,
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
      return exactMatches.first;
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
        return reverseMatches.first;
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
    // TvZ (scenarios/tvz/) - 49 scenarios (7T × 7Z, 오프닝 기반)
    // 노배럭더블 (7)
    _tvzNobarDoubleVs2hatchMutal, _tvzNobarDoubleVs4pool, _tvzNobarDoubleVs530Mutal,
    _tvzNobarDoubleVsLurkerDefiler, _tvzNobarDoubleVsMutalLurker, _tvzNobarDoubleVsMutalUltra, _tvzNobarDoubleVsUltraHive,
    // 배럭더블 (7)
    _tvzBarDoubleVs2hatchMutal, _tvzBarDoubleVs4pool, _tvzBarDoubleVs530Mutal,
    _tvzBarDoubleVsLurkerDefiler, _tvzBarDoubleVsMutalLurker, _tvzBarDoubleVsMutalUltra, _tvzBarDoubleVsUltraHive,
    // 111 (7)
    _tvz111Vs2hatchMutal, _tvz111Vs4pool, _tvz111Vs530Mutal,
    _tvz111VsLurkerDefiler, _tvz111VsMutalLurker, _tvz111VsMutalUltra, _tvz111VsUltraHive,
    // 2배럭아카데미 (7)
    _tvz2barAcademyVs2hatchMutal, _tvz2barAcademyVs4pool, _tvz2barAcademyVs530Mutal,
    _tvz2barAcademyVsLurkerDefiler, _tvz2barAcademyVsMutalLurker, _tvz2barAcademyVsMutalUltra, _tvz2barAcademyVsUltraHive,
    // 팩토리더블 (7)
    _tvzFacDoubleVs2hatchMutal, _tvzFacDoubleVs4pool, _tvzFacDoubleVs530Mutal,
    _tvzFacDoubleVsLurkerDefiler, _tvzFacDoubleVsMutalLurker, _tvzFacDoubleVsMutalUltra, _tvzFacDoubleVsUltraHive,
    // 2스타레이스 (7)
    _tvz2starVs2hatchMutal, _tvz2starVs4pool, _tvz2starVs530Mutal,
    _tvz2starVsLurkerDefiler, _tvz2starVsMutalLurker, _tvz2starVsMutalUltra, _tvz2starVsUltraHive,
    // BBS (7)
    _tvzBbsVs2hatchMutal, _tvzBbsVs4pool, _tvzBbsVs530Mutal,
    _tvzBbsVsLurkerDefiler, _tvzBbsVsMutalLurker, _tvzBbsVsMutalUltra, _tvzBbsVsUltraHive,
    // TvT (scenarios/tvt/) - 36 scenarios (8 mirrors + 28 cross)
    // 미러 (8)
    _tvtBbsMirror,
    _tvt1barDoubleMirror,
    _tvt1facDoubleMirror,
    _tvt1fac1starMirror,
    _tvt2facPushMirror,
    _tvt2starMirror,
    _tvtNobarDoubleMirror,
    _tvtFdRushMirror,
    // BBS 크로스 (6)
    _tvtBbsVs1barDouble,
    _tvtBbsVs1facDouble,
    _tvtBbsVs1fac1star,
    _tvtBbsVs2facPush,
    _tvtBbsVs2star,
    _tvtBbsVsNobarDouble,
    // 원팩원스타 크로스 (5)
    _tvt1fac1starVs2facPush,
    _tvt1fac1starVs2star,
    _tvt1fac1starVs1barDouble,
    _tvt1fac1starVs1facDouble,
    _tvt1fac1starVsNobarDouble,
    // 투팩 크로스 (4)
    _tvt1barDoubleVs2facPush,
    _tvt2facPushVs1facDouble,
    _tvt2starVs2facPush,
    _tvt2facPushVsNobarDouble,
    // 투스타 크로스 (3)
    _tvt2starVs1barDouble,
    _tvt2starVs1facDouble,
    _tvt2starVsNobarDouble,
    // 확장형 크로스 (3)
    _tvt1barDoubleVs1facDouble,
    _tvtNobarDoubleVs1barDouble,
    _tvt1facDoubleVsNobarDouble,
    // FD러쉬 크로스 (7)
    _tvtFdRushVsBbs,
    _tvtFdRushVs1fac1star,
    _tvtFdRushVs2facPush,
    _tvtFdRushVs2star,
    _tvtFdRushVs1barDouble,
    _tvtFdRushVs1facDouble,
    _tvtFdRushVsNobarDouble,
    // PvT (scenarios/pvt/) - 54 scenarios (9P × 6T)
    // 센터 게이트 (6)
    _pvtProxyGateVsBbs, _pvtProxyGateVsTankDefense, _pvtProxyGateVsTimingPush,
    _pvtProxyGateVsUpgrade, _pvtProxyGateVsBioMech, _pvtProxyGateVsAntiCarrier,
    // 초패스트다크 (6)
    _pvtDarkSwingVsBbs, _pvtDarkSwingVsTankDefense, _pvtDarkSwingVsTimingPush,
    _pvtDarkSwingVsUpgrade, _pvtDarkSwingVsBioMech, _pvtDarkSwingVsAntiCarrier,
    // 선질럿 (6)
    _pvt2gateOpenVsBbs, _pvt2gateOpenVsTankDefense, _pvt2gateOpenVsTimingPush,
    _pvt2gateOpenVsUpgrade, _pvt2gateOpenVsBioMech, _pvt2gateOpenVsAntiCarrier,
    // 5게이트 푸시 (6)
    _pvt5gatePushVsBbs, _pvt5gatePushVsTankDefense, _pvt5gatePushVsTimingPush,
    _pvt5gatePushVsUpgrade, _pvt5gatePushVsBioMech, _pvt5gatePushVsAntiCarrier,
    // 5게이트 아비터 (6)
    _pvt5gateArbiterVsBbs, _pvt5gateArbiterVsTankDefense, _pvt5gateArbiterVsTimingPush,
    _pvt5gateArbiterVsUpgrade, _pvt5gateArbiterVsBioMech, _pvt5gateArbiterVsAntiCarrier,
    // 5게이트 캐리어 (6)
    _pvt5gateCarrierVsBbs, _pvt5gateCarrierVsTankDefense, _pvt5gateCarrierVsTimingPush,
    _pvt5gateCarrierVsUpgrade, _pvt5gateCarrierVsBioMech, _pvt5gateCarrierVsAntiCarrier,
    // 셔틀리버 푸시 (6)
    _pvtReaverPushVsBbs, _pvtReaverPushVsTankDefense, _pvtReaverPushVsTimingPush,
    _pvtReaverPushVsUpgrade, _pvtReaverPushVsBioMech, _pvtReaverPushVsAntiCarrier,
    // 셔틀리버 아비터 (6)
    _pvtReaverArbiterVsBbs, _pvtReaverArbiterVsTankDefense, _pvtReaverArbiterVsTimingPush,
    _pvtReaverArbiterVsUpgrade, _pvtReaverArbiterVsBioMech, _pvtReaverArbiterVsAntiCarrier,
    // 셔틀리버 캐리어 (6)
    _pvtReaverCarrierVsBbs, _pvtReaverCarrierVsTankDefense, _pvtReaverCarrierVsTimingPush,
    _pvtReaverCarrierVsUpgrade, _pvtReaverCarrierVsBioMech, _pvtReaverCarrierVsAntiCarrier,
    // PvP (scenarios/pvp/) - 36 scenarios (8 mirrors + 28 cross)
    // 미러 (8)
    _pvpDragoonNexusMirror,
    _pvpDarkMirror,
    _pvp1gateRoboMirror,
    _pvpZealotRushMirror,
    _pvp4gateDragoonMirror,
    _pvp1gateMultiMirror,
    _pvp2gateReaverMirror,
    _pvp3gateSpeedzealotMirror,
    // 기존 1:1 크로스 (2)
    _pvpDragoonVsNogate,
    _pvp4gateVsMulti,
    // 2gate_dragoon 크로스 (6)
    _pvpDarkVs2gateDragoon,
    _pvp1gateRoboVs2gateDragoon,
    _pvp2gateReaverVs2gateDragoon,
    _pvpZealotRushVs2gateDragoon,
    _pvp3gateSpeedzealotVs2gateDragoon,
    _pvp2gateDragoonVs4gateDragoon,
    // dark 크로스 (6)
    _pvpDarkVs1gateRobo,
    _pvpDarkVsZealotRushSingle,
    _pvpDarkVs4gateDragoon,
    _pvpDarkVs1gateMulti,
    _pvpDarkVs2gateReaver,
    _pvpDarkVs3gateSpeedzealot,
    // robo/reaver 크로스 (4)
    _pvp1gateRoboVs4gateDragoon,
    _pvp1gateRoboVs1gateMulti,
    _pvp1gateRoboVs2gateReaver,
    _pvp2gateReaverVs3gateSpeedzealot,
    // zealot/speedzealot 크로스 (6)
    _pvpZealotRushVs1gateRobo,
    _pvpZealotRushVs4gateDragoon,
    _pvpZealotRushVs1gateMulti,
    _pvpZealotRushVs2gateReaver,
    _pvpZealotRushVs3gateSpeedzealot,
    _pvp3gateSpeedzealotVs1gateRobo,
    // multi/reaver/4gate 크로스 (4)
    _pvp1gateMultiVs2gateReaver,
    _pvp1gateMultiVs3gateSpeedzealot,
    _pvp4gateDragoonVs3gateSpeedzealot,
    _pvp2gateReaverVs4gateDragoon,
    // ZvP (scenarios/zvp/) - 63 scenarios (9Z × 7P)
    // 4풀 (7)
    _zvp4poolVsProxyGate, _zvp4poolVsCannonRush, _zvp4poolVs2starCorsair,
    _zvp4poolVsDragoonPush, _zvp4poolVsCorsair, _zvp4poolVsArchon, _zvp4poolVsForgeExpand,
    // 5드론 (7)
    _zvp5droneVsProxyGate, _zvp5droneVsCannonRush, _zvp5droneVs2starCorsair,
    _zvp5droneVsDragoonPush, _zvp5droneVsCorsair, _zvp5droneVsArchon, _zvp5droneVsForgeExpand,
    // 5해처리 히드라 (7)
    _zvp5hatchHydraVsProxyGate, _zvp5hatchHydraVsCannonRush, _zvp5hatchHydraVs2starCorsair,
    _zvp5hatchHydraVsDragoonPush, _zvp5hatchHydraVsCorsair, _zvp5hatchHydraVsArchon, _zvp5hatchHydraVsForgeExpand,
    // 뮤탈 히드라 (7)
    _zvpMutalHydraVsProxyGate, _zvpMutalHydraVsCannonRush, _zvpMutalHydraVs2starCorsair,
    _zvpMutalHydraVsDragoonPush, _zvpMutalHydraVsCorsair, _zvpMutalHydraVsArchon, _zvpMutalHydraVsForgeExpand,
    // 하이브 디파일러 (7)
    _zvpHiveDefilerVsProxyGate, _zvpHiveDefilerVsCannonRush, _zvpHiveDefilerVs2starCorsair,
    _zvpHiveDefilerVsDragoonPush, _zvpHiveDefilerVsCorsair, _zvpHiveDefilerVsArchon, _zvpHiveDefilerVsForgeExpand,
    // 973 히드라 (7)
    _zvp973HydraVsProxyGate, _zvp973HydraVsCannonRush, _zvp973HydraVs2starCorsair,
    _zvp973HydraVsDragoonPush, _zvp973HydraVsCorsair, _zvp973HydraVsArchon, _zvp973HydraVsForgeExpand,
    // 뮤커지 (7)
    _zvpMukerjiVsProxyGate, _zvpMukerjiVsCannonRush, _zvpMukerjiVs2starCorsair,
    _zvpMukerjiVsDragoonPush, _zvpMukerjiVsCorsair, _zvpMukerjiVsArchon, _zvpMukerjiVsForgeExpand,
    // 야바위 (7)
    _zvpYabarwiVsProxyGate, _zvpYabarwiVsCannonRush, _zvpYabarwiVs2starCorsair,
    _zvpYabarwiVsDragoonPush, _zvpYabarwiVsCorsair, _zvpYabarwiVsArchon, _zvpYabarwiVsForgeExpand,
    // 히드라 럴커 (7)
    _zvpHydraLurkerVsProxyGate, _zvpHydraLurkerVsCannonRush, _zvpHydraLurkerVs2starCorsair,
    _zvpHydraLurkerVsDragoonPush, _zvpHydraLurkerVsCorsair, _zvpHydraLurkerVsArchon, _zvpHydraLurkerVsForgeExpand,
    // ZvZ (scenarios/zvz/) - 21 scenarios (6 mirrors + 15 cross)
    // 미러 (6)
    _zvz4PoolMirror,
    _zvz9poolSpeedMirror,
    _zvz9poolLairMirror,
    _zvz9overpoolMirror,
    _zvz12poolMirror,
    _zvz12hatchMirror,
    // 4pool 크로스 (5)
    _zvz4PoolVs9poolSpeed,
    _zvz4PoolVs9poolLair,
    _zvz4PoolVs9overpool,
    _zvz4PoolVs12pool,
    _zvz4PoolVs12hatch,
    // 9pool_speed 크로스 (4)
    _zvz9poolSpeedVs9poolLair,
    _zvz9poolSpeedVs9overpool,
    _zvz9poolSpeedVs12pool,
    _zvz9poolSpeedVs12hatch,
    // 9pool_lair 크로스 (3)
    _zvz9poolLairVs9overpool,
    _zvz9poolLairVs12pool,
    _zvz9poolLairVs12hatch,
    // 9overpool 크로스 (2)
    _zvz9overpoolVs12pool,
    _zvz9overpoolVs12hatch,
    // 12hatch/12pool 크로스 (1)
    _zvz12hatchVs12pool,
  ];
}
