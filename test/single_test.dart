// 전 종족전 통합 1경기 테스트 - 빌드 ID를 바꿔가며 개별 시나리오 확인용
//
// 사용법:
//   flutter test --name "TvT" test/single_test.dart
//   flutter test --name "TvZ" test/single_test.dart
//   flutter test --name "PvT" test/single_test.dart
//   flutter test --name "PvP" test/single_test.dart
//   flutter test --name "ZvP" test/single_test.dart
//   flutter test --name "ZvZ" test/single_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'helpers/test_helpers.dart';

// ── 빌드 ID 설정 (여기만 수정) ──

const _tvtHome = 'tvt_1fac_1star';
const _tvtAway = 'tvt_1fac_1star';

const _tvzHome = 'tvz_sk';
const _tvzAway = 'zvt_2hatch_mutal';

const _pvtHome = 'pvt_dark_swing';
const _pvtAway = 'tvp_bbs';

const _pvpHome = 'pvp_2gate_dragoon';
const _pvpAway = 'pvp_1gate_robo';

const _zvpHome = 'zvp_trans_5hatch_hydra';
const _zvpAway = 'pvz_cannon_rush';

const _zvzHome = 'zvz_9pool_speed';
const _zvzAway = 'zvz_9pool_speed';

class _SingleConfig {
  final String matchup;
  final String outputDir;
  final Player homePlayer;
  final Player awayPlayer;
  final String homeBuildId;
  final String awayBuildId;

  const _SingleConfig({
    required this.matchup,
    required this.outputDir,
    required this.homePlayer,
    required this.awayPlayer,
    required this.homeBuildId,
    required this.awayBuildId,
  });
}

final _configs = <_SingleConfig>[
  _SingleConfig(
    matchup: 'TvT', outputDir: 'tvt',
    homePlayer: createTestPlayer('terran_home', '이영호', 0),
    awayPlayer: createTestPlayer('terran_away', '임요환', 0),
    homeBuildId: _tvtHome, awayBuildId: _tvtAway,
  ),
  _SingleConfig(
    matchup: 'TvZ', outputDir: 'tvz',
    homePlayer: createTestPlayer('terran_home', '이영호', 0),
    awayPlayer: createTestPlayer('zerg_away', '이재동', 1),
    homeBuildId: _tvzHome, awayBuildId: _tvzAway,
  ),
  _SingleConfig(
    matchup: 'PvT', outputDir: 'pvt',
    homePlayer: createTestPlayer('protoss_home', '이윤열', 2),
    awayPlayer: createTestPlayer('terran_away', '이영호', 0),
    homeBuildId: _pvtHome, awayBuildId: _pvtAway,
  ),
  _SingleConfig(
    matchup: 'PvP', outputDir: 'pvp',
    homePlayer: createTestPlayer('protoss_home', '이윤열', 2),
    awayPlayer: createTestPlayer('protoss_away', '김택용', 2),
    homeBuildId: _pvpHome, awayBuildId: _pvpAway,
  ),
  _SingleConfig(
    matchup: 'ZvP', outputDir: 'zvp',
    homePlayer: createTestPlayer('zerg_home', '이재동', 1),
    awayPlayer: createTestPlayer('protoss_away', '이윤열', 2),
    homeBuildId: _zvpHome, awayBuildId: _zvpAway,
  ),
  _SingleConfig(
    matchup: 'ZvZ', outputDir: 'zvz',
    homePlayer: createTestPlayer('zerg_home', '이재동', 1),
    awayPlayer: createTestPlayer('zerg_away', '박성준', 1),
    homeBuildId: _zvzHome, awayBuildId: _zvzAway,
  ),
];

void main() {
  for (final config in _configs) {
    test('${config.matchup} 1경기: ${config.homeBuildId} vs ${config.awayBuildId}', () async {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: config.homePlayer, awayPlayer: config.awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: config.homeBuildId,
        forcedAwayBuildId: config.awayBuildId,
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }

      expect(state, isNotNull);

      final homeRace = raceNames[config.homePlayer.raceIndex];
      final awayRace = raceNames[config.awayPlayer.raceIndex];

      final buf = StringBuffer();
      buf.writeln('**빌드**: ${config.homeBuildId} vs ${config.awayBuildId}');
      buf.writeln('**선수**: ${config.homePlayer.name}($homeRace/홈) vs ${config.awayPlayer.name}($awayRace/어웨이)');
      final winner = state!.homeWin == true
          ? '홈(${config.homePlayer.name})'
          : '어웨이(${config.awayPlayer.name})';
      buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}');
      buf.writeln();
      buf.writeln('```');
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == LogOwner.home ? '[홈]  ' : e.owner == LogOwner.away ? '[어웨이]' : '[해설]';
        buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
      }
      buf.writeln('```');

      writeTestOutput('test/output/${config.outputDir}', 'single_log.md', buf.toString());
      print(buf.toString());
    });
  }
}
