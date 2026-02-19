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
  ('pvt_2gate_zealot', '선질럿', 'AGG'),
  ('pvt_dark_swing', '다크드랍', 'CHE'),
  ('pvt_1gate_obs', '23넥아비터', 'DEF'),
  ('pvt_proxy_dark', '전진로보', 'AGG'),
  ('pvt_1gate_expand', '19넥', 'BAL'),
  ('pvt_carrier', '생넥캐리어', 'DEF'),
  ('pvt_reaver_shuttle', '리버속셔템', 'BAL'),
];

// === ZvP 빌드 목록 ===
const _zvpBuilds = <BuildInfo>[
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
  ('pvz_proxy_gate', '센터99겟', 'CHE'),
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
  ('zvz_9pool', '9레어', 'AGG'),
  ('zvz_12hatch', '12앞마당', 'DEF'),
  ('zvz_overpool', '오버풀', 'BAL'),
  ('zvz_12pool', '12풀', 'BAL'),
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
