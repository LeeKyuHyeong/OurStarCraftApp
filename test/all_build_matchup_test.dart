// 전체 종족전 빌드 매치업별 승률 분석
// 실행: flutter test test/all_build_matchup_test.dart --reporter expanded
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

Player _makePlayer({
  required String name,
  required Race race,
}) {
  return Player(
    id: name,
    name: name,
    raceIndex: race.index,
    stats: const PlayerStats(
      sense: 650, control: 650, attack: 650, harass: 650,
      strategy: 650, macro: 650, defense: 650, scout: 650,
    ),
    levelValue: 5,
    condition: 100,
  );
}

const _standardMap = GameMap(
  id: 'test_standard',
  name: '테스트맵',
  rushDistance: 5,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 5,
  centerImportance: 5,
);

typedef BuildInfo = (String id, String name, String style);

// === TvZ 빌드 목록 ===
const _tvzBuilds = <BuildInfo>[
  ('tvz_bunker', '벙커링', 'CHE'),
  ('tvz_sk', '투배럭아카', 'AGG'),
  ('tvz_3fac_goliath', '5팩골리앗', 'DEF'),
  ('tvz_4rax_enbe', '선엔베', 'AGG'),
  ('tvz_111', '111', 'BAL'),
  ('tvz_valkyrie', '발키리', 'DEF'),
  ('tvz_2star_wraith', '투스타레이스', 'AGG'),
];

const _zvtBuilds = <BuildInfo>[
  ('zvt_4pool', '4풀', 'CHE'),
  ('zvt_9pool', '9풀', 'AGG'),
  ('zvt_9overpool', '9오버풀', 'AGG'),
  ('zvt_12pool', '12풀', 'BAL'),
  ('zvt_12hatch', '12앞', 'BAL'),
  ('zvt_3hatch_nopool', '노풀3해처리', 'DEF'),
  ('zvt_3hatch_mutal', '미친저그', 'AGG'),
  ('zvt_2hatch_mutal', '투해처리뮤탈', 'AGG'),
  ('zvt_2hatch_lurker', '가드라', 'DEF'),
  ('zvt_1hatch_allin', '530뮤탈', 'AGG'),
];

// === ZvT 트랜지션 빌드 ===
const _zvtTransBuilds = <BuildInfo>[
  ('zvt_trans_mutal_ultra', '뮤탈→울트라', 'AGG'),
  ('zvt_trans_2hatch_mutal', '투해처리뮤탈T', 'AGG'),
  ('zvt_trans_lurker_defiler', '가드라→디파일러', 'DEF'),
  ('zvt_trans_530_mutal', '530뮤탈T', 'AGG'),
  ('zvt_trans_mutal_lurker', '뮤탈→럴커', 'BAL'),
  ('zvt_trans_ultra_hive', '울트라→하이브', 'DEF'),
];

// === ZvP 트랜지션 빌드 ===
const _zvpTransBuilds = <BuildInfo>[
  ('zvp_trans_5hatch_hydra', '5히트랜지션', 'AGG'),
  ('zvp_trans_mutal_hydra', '뮤탈→히드라', 'BAL'),
  ('zvp_trans_hive_defiler', '하이브→디파일러', 'DEF'),
  ('zvp_trans_973_hydra', '973히드라T', 'AGG'),
  ('zvp_trans_mukerji', '뮤커지T', 'BAL'),
  ('zvp_trans_yabarwi', '야바위T', 'AGG'),
  ('zvp_trans_hydra_lurker', '히드라→럴커', 'BAL'),
];

// === TvZ 트랜지션 빌드 ===
const _tvzTransBuilds = <BuildInfo>[
  ('tvz_trans_bionic_push', '바이오닉푸시', 'AGG'),
  ('tvz_trans_mech_goliath', '메카닉골리앗', 'DEF'),
  ('tvz_trans_111_balance', '111밸런스', 'BAL'),
  ('tvz_trans_valkyrie', '발키리대공', 'DEF'),
  ('tvz_trans_wraith', '레이스공중', 'AGG'),
  ('tvz_trans_enbe_push', '선엔베푸시', 'AGG'),
];

// === TvP 빌드 목록 ===
const _tvpBuilds = <BuildInfo>[
  ('tvp_double', '팩더블', 'DEF'),
  ('tvp_fake_double', '타이밍러쉬', 'AGG'),
  ('tvp_1fac_drop', '투팩찌르기', 'AGG'),
  ('tvp_1fac_gosu', '업테란', 'DEF'),
  ('tvp_rax_double', '배럭더블', 'DEF'),
  ('tvp_5fac_timing', '5팩타이밍', 'AGG'),
  ('tvp_mine_triple', '마인트리플', 'DEF'),
  ('tvp_fd', 'FD테란', 'BAL'),
  ('tvp_11up_8fac', '11업8팩', 'AGG'),
  ('tvp_anti_carrier', '안티캐리어', 'BAL'),
];

const _pvtBuilds = <BuildInfo>[
  ('pvt_proxy_gate', '센터게이트', 'CHE'),
  ('pvt_2gate_zealot', '선질럿', 'AGG'),
  ('pvt_dark_swing', '초패스트다크', 'AGG'),
  ('pvt_1gate_obs', '23넥아비터', 'DEF'),
  ('pvt_proxy_dark', '전진로보', 'AGG'),
  ('pvt_1gate_expand', '19넥', 'BAL'),
  ('pvt_carrier', '생넥캐리어', 'DEF'),
  ('pvt_reaver_shuttle', '리버속셔템', 'BAL'),
];

// === TvP 트랜지션 빌드 ===
const _tvpTransBuilds = <BuildInfo>[
  ('tvp_trans_tank_defense', '탱크수비', 'DEF'),
  ('tvp_trans_timing_push', '타이밍푸시', 'AGG'),
  ('tvp_trans_upgrade', '업그레이드운영', 'BAL'),
  ('tvp_trans_bio_mech', '바이오메카닉', 'BAL'),
  ('tvp_trans_5fac_mass', '5팩물량', 'AGG'),
  ('tvp_trans_anti_carrier', '안티캐리어T', 'BAL'),
];

// === PvT 트랜지션 빌드 ===
const _pvtTransBuilds = <BuildInfo>[
  ('pvt_trans_5gate_push', '5게이트푸시', 'AGG'),
  ('pvt_trans_5gate_arbiter', '5게이트아비터', 'BAL'),
  ('pvt_trans_5gate_carrier', '5게이트캐리어', 'DEF'),
  ('pvt_trans_reaver_push', '셔틀리버푸시', 'AGG'),
  ('pvt_trans_reaver_arbiter', '셔틀리버아비터', 'BAL'),
  ('pvt_trans_reaver_carrier', '셔틀리버캐리어', 'DEF'),
];

// === PvZ 트랜지션 빌드 ===
const _pvzTransBuilds = <BuildInfo>[
  ('pvz_trans_dragoon_push', '드라군푸시', 'AGG'),
  ('pvz_trans_corsair', '커세어운영', 'BAL'),
  ('pvz_trans_archon', '아콘조합', 'BAL'),
  ('pvz_trans_forge_expand', '포지확장', 'DEF'),
];

// === ZvP 빌드 목록 ===
const _zvpBuilds = <BuildInfo>[
  ('zvp_4pool', '4풀', 'CHE'),
  ('zvp_9pool', '9풀', 'AGG'),
  ('zvp_9overpool', '9오버풀', 'AGG'),
  ('zvp_12pool', '12풀', 'BAL'),
  ('zvp_12hatch', '12앞', 'BAL'),
  ('zvp_3hatch_nopool', '노풀3해처리', 'DEF'),
  ('zvp_3hatch_hydra', '5해처리히드라', 'AGG'),
  ('zvp_2hatch_mutal', '5뮤탈', 'BAL'),
  ('zvp_scourge_defiler', '하이브운영', 'DEF'),
  ('zvp_5drone', '9투올인', 'CHE'),
  ('zvp_973_hydra', '973히드라', 'AGG'),
  ('zvp_mukerji', '뮤커지', 'BAL'),
  ('zvp_yabarwi', '야바위', 'AGG'),
];

const _pvzBuilds = <BuildInfo>[
  ('pvz_2gate_zealot', '파워드라군', 'AGG'),
  ('pvz_forge_cannon', '포지더블', 'DEF'),
  ('pvz_corsair_reaver', '선아둔', 'BAL'),
  ('pvz_proxy_gate', '센터게이트', 'CHE'),
  ('pvz_cannon_rush', '캐논러쉬', 'CHE'),
  ('pvz_8gat', '8겟뽕', 'CHE'),
  ('pvz_2star_corsair', '투스타커세어', 'AGG'),
];

// === TvT 빌드 목록 ===
const _tvtBuilds = <BuildInfo>[
  ('tvt_1fac_push', '원팩원스타', 'AGG'),
  ('tvt_wraith_cloak', '투스타레이스', 'AGG'),
  ('tvt_cc_first', '배럭더블', 'DEF'),
  ('tvt_2fac_vulture', '투팩벌처', 'AGG'),
  ('tvt_1fac_expand', '원팩확장', 'DEF'),
  ('tvt_5fac', '5팩토리', 'AGG'),
];

// === ZvZ 빌드 목록 ===
const _zvzBuilds = <BuildInfo>[
  ('zvz_pool_first', '4풀', 'CHE'),
  ('zvz_9pool', '9풀', 'AGG'),
  ('zvz_9overpool', '9오버풀', 'AGG'),
  ('zvz_12pool', '12풀', 'BAL'),
  ('zvz_12hatch', '12앞', 'BAL'),
  ('zvz_3hatch_nopool', '노풀3해처리', 'DEF'),
];

// === PvP 빌드 목록 ===
const _pvpBuilds = <BuildInfo>[
  ('pvp_2gate_dragoon', '옵3겟', 'BAL'),
  ('pvp_dark_allin', '다크더블', 'CHE'),
  ('pvp_1gate_robo', '1게이트리버', 'DEF'),
  ('pvp_zealot_rush', '센터99겟', 'CHE'),
  ('pvp_4gate_dragoon', '3겟드라군', 'CHE'),
  ('pvp_1gate_multi', '원겟멀티', 'DEF'),
  ('pvp_2gate_reaver', '투겟리버', 'AGG'),
  ('pvp_3gate_speedzealot', '스피드질럿', 'AGG'),
];

/// 매치업 테스트 실행 (Home builds vs Away builds)
Future<void> _runMatchupTest({
  required MatchSimulationService service,
  required List<BuildInfo> homeBuilds,
  required List<BuildInfo> awayBuilds,
  required Race homeRace,
  required Race awayRace,
  required String label,
  required int runs,
}) async {
  final buf = StringBuffer();
  buf.writeln('=== $label 빌드 매치업별 승률 (${runs}회) ===\n');

  // 헤더
  final homeLabel = homeRace == awayRace ? 'H' : homeRace.name[0].toUpperCase();
  final awayLabel = homeRace == awayRace ? 'A' : awayRace.name[0].toUpperCase();

  buf.write('$homeLabel \\ $awayLabel'.padRight(14));
  for (final (_, aName, aStyle) in awayBuilds) {
    buf.write('$aName($aStyle)'.padRight(16));
  }
  buf.write('평균'.padRight(8));
  buf.writeln();
  buf.writeln('-' * (14 + awayBuilds.length * 16 + 8));

  int grandTotal = 0;
  int grandHomeWins = 0;

  for (final (hId, hName, hStyle) in homeBuilds) {
    buf.write('$hName($hStyle)'.padRight(14));
    int rowWins = 0;
    int rowGames = 0;

    for (final (aId, _, _) in awayBuilds) {
      int hWins = 0;

      for (int i = 0; i < runs; i++) {
        final home = _makePlayer(name: 'Home', race: homeRace);
        final away = _makePlayer(name: 'Away', race: awayRace);

        final stream = service.simulateMatchWithLog(
          homePlayer: home,
          awayPlayer: away,
          map: _standardMap,
          getIntervalMs: () => 0,
          forcedHomeBuildId: hId,
          forcedAwayBuildId: aId,
        );

        SimulationState? last;
        await for (final state in stream) {
          last = state;
        }
        if (last?.homeWin == true) hWins++;
      }

      final winRate = (hWins / runs * 100).toStringAsFixed(0);
      buf.write('$homeLabel ${winRate.padLeft(3)}%'.padRight(16));
      rowWins += hWins;
      rowGames += runs;
    }

    final rowAvg = (rowWins / rowGames * 100).toStringAsFixed(0);
    buf.write('$homeLabel ${rowAvg.padLeft(3)}%');
    buf.writeln();
    grandTotal += rowGames;
    grandHomeWins += rowWins;
  }

  buf.writeln('-' * (14 + awayBuilds.length * 16 + 8));

  // 열 평균 (어웨이 빌드별)
  buf.write('열평균'.padRight(14));
  for (int aIdx = 0; aIdx < awayBuilds.length; aIdx++) {
    int colWins = 0;
    int colGames = 0;
    for (int hIdx = 0; hIdx < homeBuilds.length; hIdx++) {
      // 재계산 없이 전체 평균에서 추정 (생략 - 이미 그랜드에 포함)
    }
    buf.write(''.padRight(16));
  }
  buf.writeln();

  final grandAvg = (grandHomeWins / grandTotal * 100).toStringAsFixed(1);
  buf.writeln('전체 평균: $homeLabel $grandAvg% (${grandHomeWins}승 / ${grandTotal}경기)');

  print(buf.toString());
}

/// 미러 매치업 테스트 (같은 빌드 풀에서 Home vs Away)
Future<void> _runMirrorTest({
  required MatchSimulationService service,
  required List<BuildInfo> builds,
  required Race race,
  required String label,
  required int runs,
}) async {
  await _runMatchupTest(
    service: service,
    homeBuilds: builds,
    awayBuilds: builds,
    homeRace: race,
    awayRace: race,
    label: label,
    runs: runs,
  );
}

void main() {
  const runs = 100; // 100회 × 매치업수

  test('TvZ 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _tvzBuilds,
      awayBuilds: _zvtBuilds,
      homeRace: Race.terran,
      awayRace: Race.zerg,
      label: 'TvZ (7T × 10Z)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('ZvT 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _zvtBuilds,
      awayBuilds: _tvzBuilds,
      homeRace: Race.zerg,
      awayRace: Race.terran,
      label: 'ZvT (10Z × 7T)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('ZvT 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _zvtTransBuilds,
      awayBuilds: _tvzBuilds,
      homeRace: Race.zerg,
      awayRace: Race.terran,
      label: 'ZvT 트랜지션 (6Z × 7T)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('ZvP 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _zvpTransBuilds,
      awayBuilds: _pvzBuilds,
      homeRace: Race.zerg,
      awayRace: Race.protoss,
      label: 'ZvP 트랜지션 (7Z × 7P)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('TvP 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _tvpBuilds,
      awayBuilds: _pvtBuilds,
      homeRace: Race.terran,
      awayRace: Race.protoss,
      label: 'TvP (10T × 7P)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('PvT 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _pvtBuilds,
      awayBuilds: _tvpBuilds,
      homeRace: Race.protoss,
      awayRace: Race.terran,
      label: 'PvT (7P × 10T)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('ZvP 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _zvpBuilds,
      awayBuilds: _pvzBuilds,
      homeRace: Race.zerg,
      awayRace: Race.protoss,
      label: 'ZvP (7Z × 7P)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('PvZ 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _pvzBuilds,
      awayBuilds: _zvpBuilds,
      homeRace: Race.protoss,
      awayRace: Race.zerg,
      label: 'PvZ (7P × 7Z)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('TvZ 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _tvzTransBuilds,
      awayBuilds: _zvtBuilds,
      homeRace: Race.terran,
      awayRace: Race.zerg,
      label: 'TvZ 트랜지션 (6T × 10Z)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('TvP 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _tvpTransBuilds,
      awayBuilds: _pvtBuilds,
      homeRace: Race.terran,
      awayRace: Race.protoss,
      label: 'TvP 트랜지션 (6T × 7P)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('PvT 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _pvtTransBuilds,
      awayBuilds: _tvpBuilds,
      homeRace: Race.protoss,
      awayRace: Race.terran,
      label: 'PvT 트랜지션 (6P × 10T)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('PvZ 트랜지션 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMatchupTest(
      service: service,
      homeBuilds: _pvzTransBuilds,
      awayBuilds: _zvpBuilds,
      homeRace: Race.protoss,
      awayRace: Race.zerg,
      label: 'PvZ 트랜지션 (4P × 13Z)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('TvT 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMirrorTest(
      service: service,
      builds: _tvtBuilds,
      race: Race.terran,
      label: 'TvT (6×6)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('ZvZ 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMirrorTest(
      service: service,
      builds: _zvzBuilds,
      race: Race.zerg,
      label: 'ZvZ (5×5)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('PvP 빌드 매치업별 승률', () async {
    final service = MatchSimulationService();
    await _runMirrorTest(
      service: service,
      builds: _pvpBuilds,
      race: Race.protoss,
      label: 'PvP (8×8)',
      runs: runs,
    );
  }, timeout: const Timeout(Duration(minutes: 30)));
}
