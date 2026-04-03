import 'dart:math';
import '../../domain/services/match_simulation_service.dart';
import '../../domain/models/models.dart';

// TvZ (56 scenarios - 8T × 7Z, 모두 1:1)
// 벙커 (7)
part 'scenarios/tvz/bunker_vs_4pool.dart';
part 'scenarios/tvz/bunker_vs_mutal_ultra.dart';
part 'scenarios/tvz/bunker_vs_2hatch_mutal.dart';
part 'scenarios/tvz/bunker_vs_lurker_defiler.dart';
part 'scenarios/tvz/bunker_vs_530_mutal.dart';
part 'scenarios/tvz/bunker_vs_mutal_lurker.dart';
part 'scenarios/tvz/bunker_vs_ultra_hive.dart';
// 선엔베 (7)
part 'scenarios/tvz/4bar_enbe_vs_4pool.dart';
part 'scenarios/tvz/4bar_enbe_vs_mutal_ultra.dart';
part 'scenarios/tvz/4bar_enbe_vs_2hatch_mutal.dart';
part 'scenarios/tvz/4bar_enbe_vs_lurker_defiler.dart';
part 'scenarios/tvz/4bar_enbe_vs_530_mutal.dart';
part 'scenarios/tvz/4bar_enbe_vs_mutal_lurker.dart';
part 'scenarios/tvz/4bar_enbe_vs_ultra_hive.dart';
// 바이오닉 푸시 (7)
part 'scenarios/tvz/bionic_push_vs_4pool.dart';
part 'scenarios/tvz/bionic_push_vs_mutal_ultra.dart';
part 'scenarios/tvz/bionic_push_vs_2hatch_mutal.dart';
part 'scenarios/tvz/bionic_push_vs_lurker_defiler.dart';
part 'scenarios/tvz/bionic_push_vs_530_mutal.dart';
part 'scenarios/tvz/bionic_push_vs_mutal_lurker.dart';
part 'scenarios/tvz/bionic_push_vs_ultra_hive.dart';
// 메카닉 골리앗 (7)
part 'scenarios/tvz/mech_goliath_vs_4pool.dart';
part 'scenarios/tvz/mech_goliath_vs_mutal_ultra.dart';
part 'scenarios/tvz/mech_goliath_vs_2hatch_mutal.dart';
part 'scenarios/tvz/mech_goliath_vs_lurker_defiler.dart';
part 'scenarios/tvz/mech_goliath_vs_530_mutal.dart';
part 'scenarios/tvz/mech_goliath_vs_mutal_lurker.dart';
part 'scenarios/tvz/mech_goliath_vs_ultra_hive.dart';
// 111 밸런스 (7)
part 'scenarios/tvz/111_balance_vs_4pool.dart';
part 'scenarios/tvz/111_balance_vs_mutal_ultra.dart';
part 'scenarios/tvz/111_balance_vs_2hatch_mutal.dart';
part 'scenarios/tvz/111_balance_vs_lurker_defiler.dart';
part 'scenarios/tvz/111_balance_vs_530_mutal.dart';
part 'scenarios/tvz/111_balance_vs_mutal_lurker.dart';
part 'scenarios/tvz/111_balance_vs_ultra_hive.dart';
// 발키리 (7)
part 'scenarios/tvz/valkyrie_vs_4pool.dart';
part 'scenarios/tvz/valkyrie_vs_mutal_ultra.dart';
part 'scenarios/tvz/valkyrie_vs_2hatch_mutal.dart';
part 'scenarios/tvz/valkyrie_vs_lurker_defiler.dart';
part 'scenarios/tvz/valkyrie_vs_530_mutal.dart';
part 'scenarios/tvz/valkyrie_vs_mutal_lurker.dart';
part 'scenarios/tvz/valkyrie_vs_ultra_hive.dart';
// 레이스 (7)
part 'scenarios/tvz/wraith_vs_4pool.dart';
part 'scenarios/tvz/wraith_vs_mutal_ultra.dart';
part 'scenarios/tvz/wraith_vs_2hatch_mutal.dart';
part 'scenarios/tvz/wraith_vs_lurker_defiler.dart';
part 'scenarios/tvz/wraith_vs_530_mutal.dart';
part 'scenarios/tvz/wraith_vs_mutal_lurker.dart';
part 'scenarios/tvz/wraith_vs_ultra_hive.dart';
// 선엔베 푸시 (7)
part 'scenarios/tvz/enbe_push_vs_4pool.dart';
part 'scenarios/tvz/enbe_push_vs_mutal_ultra.dart';
part 'scenarios/tvz/enbe_push_vs_2hatch_mutal.dart';
part 'scenarios/tvz/enbe_push_vs_lurker_defiler.dart';
part 'scenarios/tvz/enbe_push_vs_530_mutal.dart';
part 'scenarios/tvz/enbe_push_vs_mutal_lurker.dart';
part 'scenarios/tvz/enbe_push_vs_ultra_hive.dart';

// TvT (28 scenarios - 7 mirrors + 21 cross matchups)
// 미러 (7)
part 'scenarios/tvt/bbs_mirror.dart';
part 'scenarios/tvt/1bar_double_mirror.dart';
part 'scenarios/tvt/1fac_double_mirror.dart';
part 'scenarios/tvt/1fac_1star_mirror.dart';
part 'scenarios/tvt/2fac_push_mirror.dart';
part 'scenarios/tvt/5fac_mirror.dart';
part 'scenarios/tvt/2star_mirror.dart';
// 기존 1:1 크로스 (4)
part 'scenarios/tvt/1bar_double_vs_2fac_push.dart';
part 'scenarios/tvt/1bar_double_vs_1fac_double.dart';
part 'scenarios/tvt/2fac_push_vs_1fac_double.dart';
part 'scenarios/tvt/1fac_1star_vs_5fac.dart';
// BBS 크로스 (6)
part 'scenarios/tvt/bbs_vs_1bar_double.dart';
part 'scenarios/tvt/bbs_vs_1fac_double.dart';
part 'scenarios/tvt/bbs_vs_1fac_1star.dart';
part 'scenarios/tvt/bbs_vs_2fac_push.dart';
part 'scenarios/tvt/bbs_vs_5fac.dart';
part 'scenarios/tvt/bbs_vs_2star.dart';
// 5팩/원팩원스타 vs 확장 (4)
part 'scenarios/tvt/5fac_vs_1bar_double.dart';
part 'scenarios/tvt/5fac_vs_1fac_double.dart';
part 'scenarios/tvt/1fac_1star_vs_1bar_double.dart';
part 'scenarios/tvt/1fac_1star_vs_1fac_double.dart';
// 공격 빌드 크로스 (4)
part 'scenarios/tvt/1fac_1star_vs_2star.dart';
part 'scenarios/tvt/1fac_1star_vs_2fac_push.dart';
part 'scenarios/tvt/5fac_vs_2star.dart';
part 'scenarios/tvt/5fac_vs_2fac_push.dart';
// 레이스 크로스 (3)
part 'scenarios/tvt/2star_vs_1bar_double.dart';
part 'scenarios/tvt/2star_vs_2fac_push.dart';
part 'scenarios/tvt/2star_vs_1fac_double.dart';
// 노배럭더블 크로스 (8)
part 'scenarios/tvt/nobar_double_mirror.dart';
part 'scenarios/tvt/nobar_double_vs_1bar_double.dart';
part 'scenarios/tvt/bbs_vs_nobar_double.dart';
part 'scenarios/tvt/1fac_1star_vs_nobar_double.dart';
part 'scenarios/tvt/2star_vs_nobar_double.dart';
part 'scenarios/tvt/2fac_push_vs_nobar_double.dart';
part 'scenarios/tvt/5fac_vs_nobar_double.dart';
part 'scenarios/tvt/1fac_double_vs_nobar_double.dart';

// PvT (63 scenarios - 9P × 7T, 모두 1:1)
// 센터 게이트 (7)
part 'scenarios/pvt/proxy_gate_vs_bbs.dart';
part 'scenarios/pvt/proxy_gate_vs_tank_defense.dart';
part 'scenarios/pvt/proxy_gate_vs_timing_push.dart';
part 'scenarios/pvt/proxy_gate_vs_upgrade.dart';
part 'scenarios/pvt/proxy_gate_vs_bio_mech.dart';
part 'scenarios/pvt/proxy_gate_vs_5fac_mass.dart';
part 'scenarios/pvt/proxy_gate_vs_anti_carrier.dart';
// 초패스트다크 (7)
part 'scenarios/pvt/dark_swing_vs_bbs.dart';
part 'scenarios/pvt/dark_swing_vs_tank_defense.dart';
part 'scenarios/pvt/dark_swing_vs_timing_push.dart';
part 'scenarios/pvt/dark_swing_vs_upgrade.dart';
part 'scenarios/pvt/dark_swing_vs_bio_mech.dart';
part 'scenarios/pvt/dark_swing_vs_5fac_mass.dart';
part 'scenarios/pvt/dark_swing_vs_anti_carrier.dart';
// 선질럿 (7)
part 'scenarios/pvt/2gate_open_vs_bbs.dart';
part 'scenarios/pvt/2gate_open_vs_tank_defense.dart';
part 'scenarios/pvt/2gate_open_vs_timing_push.dart';
part 'scenarios/pvt/2gate_open_vs_upgrade.dart';
part 'scenarios/pvt/2gate_open_vs_bio_mech.dart';
part 'scenarios/pvt/2gate_open_vs_5fac_mass.dart';
part 'scenarios/pvt/2gate_open_vs_anti_carrier.dart';
// 5게이트 푸시 (7)
part 'scenarios/pvt/5gate_push_vs_bbs.dart';
part 'scenarios/pvt/5gate_push_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_push_vs_timing_push.dart';
part 'scenarios/pvt/5gate_push_vs_upgrade.dart';
part 'scenarios/pvt/5gate_push_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_push_vs_5fac_mass.dart';
part 'scenarios/pvt/5gate_push_vs_anti_carrier.dart';
// 5게이트 아비터 (7)
part 'scenarios/pvt/5gate_arbiter_vs_bbs.dart';
part 'scenarios/pvt/5gate_arbiter_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_arbiter_vs_timing_push.dart';
part 'scenarios/pvt/5gate_arbiter_vs_upgrade.dart';
part 'scenarios/pvt/5gate_arbiter_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_arbiter_vs_5fac_mass.dart';
part 'scenarios/pvt/5gate_arbiter_vs_anti_carrier.dart';
// 5게이트 캐리어 (7)
part 'scenarios/pvt/5gate_carrier_vs_bbs.dart';
part 'scenarios/pvt/5gate_carrier_vs_tank_defense.dart';
part 'scenarios/pvt/5gate_carrier_vs_timing_push.dart';
part 'scenarios/pvt/5gate_carrier_vs_upgrade.dart';
part 'scenarios/pvt/5gate_carrier_vs_bio_mech.dart';
part 'scenarios/pvt/5gate_carrier_vs_5fac_mass.dart';
part 'scenarios/pvt/5gate_carrier_vs_anti_carrier.dart';
// 셔틀리버 푸시 (7)
part 'scenarios/pvt/reaver_push_vs_bbs.dart';
part 'scenarios/pvt/reaver_push_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_push_vs_timing_push.dart';
part 'scenarios/pvt/reaver_push_vs_upgrade.dart';
part 'scenarios/pvt/reaver_push_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_push_vs_5fac_mass.dart';
part 'scenarios/pvt/reaver_push_vs_anti_carrier.dart';
// 셔틀리버 아비터 (7)
part 'scenarios/pvt/reaver_arbiter_vs_bbs.dart';
part 'scenarios/pvt/reaver_arbiter_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_arbiter_vs_timing_push.dart';
part 'scenarios/pvt/reaver_arbiter_vs_upgrade.dart';
part 'scenarios/pvt/reaver_arbiter_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_arbiter_vs_5fac_mass.dart';
part 'scenarios/pvt/reaver_arbiter_vs_anti_carrier.dart';
// 셔틀리버 캐리어 (7)
part 'scenarios/pvt/reaver_carrier_vs_bbs.dart';
part 'scenarios/pvt/reaver_carrier_vs_tank_defense.dart';
part 'scenarios/pvt/reaver_carrier_vs_timing_push.dart';
part 'scenarios/pvt/reaver_carrier_vs_upgrade.dart';
part 'scenarios/pvt/reaver_carrier_vs_bio_mech.dart';
part 'scenarios/pvt/reaver_carrier_vs_5fac_mass.dart';
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
part 'scenarios/zvz/pool_first_mirror.dart';
part 'scenarios/zvz/9pool_mirror_single.dart';
part 'scenarios/zvz/12hatch_mirror.dart';
part 'scenarios/zvz/9overpool_mirror.dart';
part 'scenarios/zvz/12pool_mirror.dart';
part 'scenarios/zvz/3hatch_nopool_mirror.dart';
// 기존 1:1 크로스 (2)
part 'scenarios/zvz/9pool_vs_9overpool.dart';
part 'scenarios/zvz/4pool_vs_3hatch.dart';
// pool_first 크로스 (4)
part 'scenarios/zvz/pool_first_vs_9pool.dart';
part 'scenarios/zvz/pool_first_vs_9overpool.dart';
part 'scenarios/zvz/pool_first_vs_12hatch.dart';
part 'scenarios/zvz/pool_first_vs_12pool.dart';
// 9pool 크로스 (3)
part 'scenarios/zvz/9pool_vs_12hatch.dart';
part 'scenarios/zvz/9pool_vs_12pool.dart';
part 'scenarios/zvz/9pool_vs_3hatch_nopool.dart';
// 9overpool 크로스 (3)
part 'scenarios/zvz/9overpool_vs_12hatch.dart';
part 'scenarios/zvz/9overpool_vs_12pool.dart';
part 'scenarios/zvz/9overpool_vs_3hatch_nopool.dart';
// 12hatch/12pool 크로스 (3)
part 'scenarios/zvz/12hatch_vs_12pool.dart';
part 'scenarios/zvz/12hatch_vs_3hatch_nopool.dart';
part 'scenarios/zvz/12pool_vs_3hatch_nopool.dart';

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

  /// 빌드 ID 기반 분기 조건 (트랜지션 분기용)
  /// 설정 시 해당 빌드 ID와 매칭되는 경우에만 이 분기가 후보에 포함됨
  final List<String>? conditionHomeBuildIds;
  final List<String>? conditionAwayBuildIds;

  const ScriptBranch({
    required this.id,
    this.conditionStat,
    this.homeStatMustBeHigher = true,
    this.baseProbability = 1.0,
    required this.events,
    this.conditionHomeBuildIds,
    this.conditionAwayBuildIds,
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
    // TvZ (scenarios/tvz/) - 56 scenarios (8T × 7Z)
    // 벙커 (7)
    _tvzBunkerVs4pool, _tvzBunkerVsMutalUltra, _tvzBunkerVs2hatchMutal,
    _tvzBunkerVsLurkerDefiler, _tvzBunkerVs530Mutal, _tvzBunkerVsMutalLurker, _tvzBunkerVsUltraHive,
    // 선엔베 (7)
    _tvz4barEnbeVs4pool, _tvz4barEnbeVsMutalUltra, _tvz4barEnbeVs2hatchMutal,
    _tvz4barEnbeVsLurkerDefiler, _tvz4barEnbeVs530Mutal, _tvz4barEnbeVsMutalLurker, _tvz4barEnbeVsUltraHive,
    // 바이오닉 푸시 (7)
    _tvzBionicPushVs4pool, _tvzBionicPushVsMutalUltra, _tvzBionicPushVs2hatchMutal,
    _tvzBionicPushVsLurkerDefiler, _tvzBionicPushVs530Mutal, _tvzBionicPushVsMutalLurker, _tvzBionicPushVsUltraHive,
    // 메카닉 골리앗 (7)
    _tvzMechGoliathVs4pool, _tvzMechGoliathVsMutalUltra, _tvzMechGoliathVs2hatchMutal,
    _tvzMechGoliathVsLurkerDefiler, _tvzMechGoliathVs530Mutal, _tvzMechGoliathVsMutalLurker, _tvzMechGoliathVsUltraHive,
    // 111 밸런스 (7)
    _tvz111BalanceVs4pool, _tvz111BalanceVsMutalUltra, _tvz111BalanceVs2hatchMutal,
    _tvz111BalanceVsLurkerDefiler, _tvz111BalanceVs530Mutal, _tvz111BalanceVsMutalLurker, _tvz111BalanceVsUltraHive,
    // 발키리 (7)
    _tvzValkyrieVs4pool, _tvzValkyrieVsMutalUltra, _tvzValkyrieVs2hatchMutal,
    _tvzValkyrieVsLurkerDefiler, _tvzValkyrieVs530Mutal, _tvzValkyrieVsMutalLurker, _tvzValkyrieVsUltraHive,
    // 레이스 (7)
    _tvzWraithVs4pool, _tvzWraithVsMutalUltra, _tvzWraithVs2hatchMutal,
    _tvzWraithVsLurkerDefiler, _tvzWraithVs530Mutal, _tvzWraithVsMutalLurker, _tvzWraithVsUltraHive,
    // 선엔베 푸시 (7)
    _tvzEnbePushVs4pool, _tvzEnbePushVsMutalUltra, _tvzEnbePushVs2hatchMutal,
    _tvzEnbePushVsLurkerDefiler, _tvzEnbePushVs530Mutal, _tvzEnbePushVsMutalLurker, _tvzEnbePushVsUltraHive,
    // TvT (scenarios/tvt/) - 36 scenarios
    // 미러 (8)
    _tvtBbsMirror,
    _tvt1barDoubleMirror,
    _tvtNobarDoubleMirror,
    _tvt1facDoubleMirror,
    _tvt1fac1starMirror,
    _tvt2facPushMirror,
    _tvt5facMirror,
    _tvt2starMirror,
    // 기존 1:1 크로스 (4)
    _tvt1barDoubleVs2facPush,
    _tvt1barDoubleVs1facDouble,
    _tvt2facPushVs1facDouble,
    _tvt1fac1starVs5fac,
    // BBS 크로스 (7)
    _tvtBbsVs1barDouble,
    _tvtBbsVsNobarDouble,
    _tvtBbsVs1facDouble,
    _tvtBbsVs1fac1star,
    _tvtBbsVs2facPush,
    _tvtBbsVs5fac,
    _tvtBbsVs2star,
    // 5팩/원팩원스타 vs 확장 (4)
    _tvt5facVs1barDouble,
    _tvt5facVs1facDouble,
    _tvt1fac1starVs1barDouble,
    _tvt1fac1starVs1facDouble,
    // 공격 빌드 크로스 (4)
    _tvt1fac1starVs2star,
    _tvt1fac1starVs2facPush,
    _tvt5facVs2star,
    _tvt5facVs2facPush,
    // 레이스 크로스 (3)
    _tvt2starVs1barDouble,
    _tvt2starVs2facPush,
    _tvt2starVs1facDouble,
    // 노배럭더블 크로스 (6)
    _tvtNobarDoubleVs1barDouble,
    _tvt1fac1starVsNobarDouble,
    _tvt2starVsNobarDouble,
    _tvt2facPushVsNobarDouble,
    _tvt5facVsNobarDouble,
    _tvt1facDoubleVsNobarDouble,
    // PvT (scenarios/pvt/) - 63 scenarios (9P × 7T)
    // 센터 게이트 (7)
    _pvtProxyGateVsBbs, _pvtProxyGateVsTankDefense, _pvtProxyGateVsTimingPush,
    _pvtProxyGateVsUpgrade, _pvtProxyGateVsBioMech, _pvtProxyGateVs5facMass, _pvtProxyGateVsAntiCarrier,
    // 초패스트다크 (7)
    _pvtDarkSwingVsBbs, _pvtDarkSwingVsTankDefense, _pvtDarkSwingVsTimingPush,
    _pvtDarkSwingVsUpgrade, _pvtDarkSwingVsBioMech, _pvtDarkSwingVs5facMass, _pvtDarkSwingVsAntiCarrier,
    // 선질럿 (7)
    _pvt2gateOpenVsBbs, _pvt2gateOpenVsTankDefense, _pvt2gateOpenVsTimingPush,
    _pvt2gateOpenVsUpgrade, _pvt2gateOpenVsBioMech, _pvt2gateOpenVs5facMass, _pvt2gateOpenVsAntiCarrier,
    // 5게이트 푸시 (7)
    _pvt5gatePushVsBbs, _pvt5gatePushVsTankDefense, _pvt5gatePushVsTimingPush,
    _pvt5gatePushVsUpgrade, _pvt5gatePushVsBioMech, _pvt5gatePushVs5facMass, _pvt5gatePushVsAntiCarrier,
    // 5게이트 아비터 (7)
    _pvt5gateArbiterVsBbs, _pvt5gateArbiterVsTankDefense, _pvt5gateArbiterVsTimingPush,
    _pvt5gateArbiterVsUpgrade, _pvt5gateArbiterVsBioMech, _pvt5gateArbiterVs5facMass, _pvt5gateArbiterVsAntiCarrier,
    // 5게이트 캐리어 (7)
    _pvt5gateCarrierVsBbs, _pvt5gateCarrierVsTankDefense, _pvt5gateCarrierVsTimingPush,
    _pvt5gateCarrierVsUpgrade, _pvt5gateCarrierVsBioMech, _pvt5gateCarrierVs5facMass, _pvt5gateCarrierVsAntiCarrier,
    // 셔틀리버 푸시 (7)
    _pvtReaverPushVsBbs, _pvtReaverPushVsTankDefense, _pvtReaverPushVsTimingPush,
    _pvtReaverPushVsUpgrade, _pvtReaverPushVsBioMech, _pvtReaverPushVs5facMass, _pvtReaverPushVsAntiCarrier,
    // 셔틀리버 아비터 (7)
    _pvtReaverArbiterVsBbs, _pvtReaverArbiterVsTankDefense, _pvtReaverArbiterVsTimingPush,
    _pvtReaverArbiterVsUpgrade, _pvtReaverArbiterVsBioMech, _pvtReaverArbiterVs5facMass, _pvtReaverArbiterVsAntiCarrier,
    // 셔틀리버 캐리어 (7)
    _pvtReaverCarrierVsBbs, _pvtReaverCarrierVsTankDefense, _pvtReaverCarrierVsTimingPush,
    _pvtReaverCarrierVsUpgrade, _pvtReaverCarrierVsBioMech, _pvtReaverCarrierVs5facMass, _pvtReaverCarrierVsAntiCarrier,
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
    _zvzPoolFirstMirror,
    _zvz9poolMirrorSingle,
    _zvz12hatchMirror,
    _zvz9overpoolMirror,
    _zvz12poolMirror,
    _zvz3hatchNopoolMirror,
    // 기존 1:1 크로스 (2)
    _zvz9poolVs9overpool,
    _zvz4poolVs3hatch,
    // pool_first 크로스 (4)
    _zvzPoolFirstVs9pool,
    _zvzPoolFirstVs9overpool,
    _zvzPoolFirstVs12hatch,
    _zvzPoolFirstVs12pool,
    // 9pool 크로스 (3)
    _zvz9poolVs12hatch,
    _zvz9poolVs12pool,
    _zvz9poolVs3hatchNopool,
    // 9overpool 크로스 (3)
    _zvz9overpoolVs12hatch,
    _zvz9overpoolVs12pool,
    _zvz9overpoolVs3hatchNopool,
    // 12hatch/12pool 크로스 (3)
    _zvz12hatchVs12pool,
    _zvz12hatchVs3hatchNopool,
    _zvz12poolVs3hatchNopool,
  ];
}
