// 테스트 공통 헬퍼 — 선수/맵/시나리오 생성 + 출력 유틸리티
//
// 모든 테스트 파일이 공유하는 설정을 한곳에 정의한다.
import 'dart:io';
import 'package:mystar/domain/models/models.dart';

// ── 선수 생성 ──

/// 동일 능력치(700) 테스트 선수 생성
Player createTestPlayer(String id, String name, int raceIndex) => Player(
  id: id, name: name, raceIndex: raceIndex,
  stats: const PlayerStats(
    sense: 700, control: 700, attack: 700, harass: 700,
    strategy: 700, macro: 700, defense: 700, scout: 700,
  ),
  levelValue: 7, condition: 100,
);

// ── 맵 ──

const testMap = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

const testMapWithMatchup = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
  matchup: RaceMatchup(tvzTerranWinRate: 50, zvpZergWinRate: 50, pvtProtossWinRate: 50),
);

// ── 상수 ──

const raceNames = ['테란', '저그', '프로토스'];

// ── 시나리오 정의 ──

/// 빌드 조합 시나리오 (all_scenarios, calibration, bias 테스트 공용)
class Scenario {
  final String homeBuild;
  final String awayBuild;
  final String label;
  const Scenario(this.homeBuild, this.awayBuild, this.label);
}

/// 미러 매치업용 시나리오 (i ≤ j 삼각형 조합)
List<Scenario> mirrorScenarios(List<String> builds, String prefix) {
  final scenarios = <Scenario>[];
  for (int i = 0; i < builds.length; i++) {
    for (int j = i; j < builds.length; j++) {
      final hLabel = builds[i].replaceFirst('${prefix}_', '');
      final aLabel = builds[j].replaceFirst('${prefix}_', '');
      scenarios.add(Scenario(
        builds[i], builds[j],
        i == j ? '${hLabel}_mirror' : '${hLabel}_vs_$aLabel',
      ));
    }
  }
  return scenarios;
}

/// 크로스 매치업용 시나리오 (homeBuilds × awayBuilds)
List<Scenario> crossScenarios(
  List<String> homeBuilds, List<String> awayBuilds,
  String homePrefix, String awayPrefix,
) {
  final scenarios = <Scenario>[];
  for (final h in homeBuilds) {
    for (final a in awayBuilds) {
      final hLabel = h.replaceFirst('${homePrefix}_trans_', '').replaceFirst('${homePrefix}_', '');
      final aLabel = a.replaceFirst('${awayPrefix}_trans_', '').replaceFirst('${awayPrefix}_', '');
      scenarios.add(Scenario(h, a, '${hLabel}_vs_$aLabel'));
    }
  }
  return scenarios;
}

// ── 빌드 ID 리스트 (종족전별 전체 매트릭스 기준) ──

const tvtBuilds = [
  'tvt_bbs', 'tvt_1fac_1star', 'tvt_2fac_push',
  'tvt_2star', 'tvt_1bar_double', 'tvt_1fac_double',
  'tvt_nobar_double', 'tvt_fd_rush',
];

const tvzTerranBuilds = [
  'tvz_nobar_double', 'tvz_bar_double', 'tvz_111', 'tvz_2bar_academy',
  'tvz_fac_double', 'tvz_2star', 'tvz_bbs',
];

const tvzZergBuilds = [
  'zvt_trans_2hatch_mutal', 'zvt_4pool', 'zvt_trans_530_mutal',
  'zvt_trans_lurker_defiler', 'zvt_trans_mutal_lurker',
  'zvt_trans_mutal_ultra', 'zvt_trans_ultra_hive',
];

const pvtProtossBuilds = [
  'pvt_2gate_open', 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier',
  'pvt_trans_5gate_push', 'pvt_dark_swing', 'pvt_proxy_gate',
  'pvt_trans_reaver_arbiter', 'pvt_trans_reaver_carrier', 'pvt_trans_reaver_push',
];

const pvtTerranBuilds = [
  'tvp_bbs', 'tvp_trans_tank_defense', 'tvp_trans_timing_push',
  'tvp_trans_anti_carrier', 'tvp_trans_bio_mech',
  'tvp_trans_upgrade',
];

const pvpBuilds = [
  'pvp_2gate_dragoon', 'pvp_1gate_multi', 'pvp_1gate_robo',
  'pvp_4gate_dragoon', 'pvp_2gate_reaver', 'pvp_3gate_speedzealot',
  'pvp_dark_allin', 'pvp_zealot_rush',
];

const zvpZergBuilds = [
  'zvp_4pool', 'zvp_5drone', 'zvp_trans_5hatch_hydra',
  'zvp_trans_973_hydra', 'zvp_trans_hive_defiler', 'zvp_trans_hydra_lurker',
  'zvp_trans_mukerji', 'zvp_trans_mutal_hydra', 'zvp_trans_yabarwi',
];

const zvpProtossBuilds = [
  'pvz_cannon_rush', 'pvz_trans_corsair', 'pvz_2star_corsair',
  'pvz_trans_archon', 'pvz_trans_forge_expand', 'pvz_trans_dragoon_push',
  'pvz_proxy_gate',
];

const zvzBuilds = [
  'zvz_4pool', 'zvz_9pool_speed', 'zvz_9pool_lair', 'zvz_9overpool',
  'zvz_12pool', 'zvz_12hatch',
];

// ── 출력 유틸리티 ──

/// 출력 디렉토리 생성 + 파일 쓰기
void writeTestOutput(String dirPath, String fileName, String content) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) dir.createSync(recursive: true);
  File('$dirPath/$fileName').writeAsStringSync(content);
}
