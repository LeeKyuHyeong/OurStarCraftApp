// 전 종족전 통합 1경기 테스트 - 빌드 ID를 바꿔가며 개별 시나리오 확인용
//
// 사용법:
//   flutter test --name "TvT" test/single_test.dart
//   flutter test --name "TvZ" test/single_test.dart
//   flutter test --name "PvT" test/single_test.dart
//   flutter test --name "PvP" test/single_test.dart
//   flutter test --name "ZvP" test/single_test.dart
//   flutter test --name "ZvZ" test/single_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

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

// ── 공통 ──

Player _player(String id, String name, int raceIndex) => Player(
  id: id, name: name, raceIndex: raceIndex,
  stats: const PlayerStats(
    sense: 700, control: 700, attack: 700, harass: 700,
    strategy: 700, macro: 700, defense: 700, scout: 700,
  ),
  levelValue: 7, condition: 100,
);

const _testMap = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

const _raceNames = ['테란', '저그', '프로토스'];

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
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('terran_away', '임요환', 0),
    homeBuildId: _tvtHome, awayBuildId: _tvtAway,
  ),
  _SingleConfig(
    matchup: 'TvZ', outputDir: 'tvz',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('zerg_away', '이재동', 1),
    homeBuildId: _tvzHome, awayBuildId: _tvzAway,
  ),
  _SingleConfig(
    matchup: 'PvT', outputDir: 'pvt',
    homePlayer: _player('protoss_home', '이윤열', 2),
    awayPlayer: _player('terran_away', '이영호', 0),
    homeBuildId: _pvtHome, awayBuildId: _pvtAway,
  ),
  _SingleConfig(
    matchup: 'PvP', outputDir: 'pvp',
    homePlayer: _player('protoss_home', '이윤열', 2),
    awayPlayer: _player('protoss_away', '김택용', 2),
    homeBuildId: _pvpHome, awayBuildId: _pvpAway,
  ),
  _SingleConfig(
    matchup: 'ZvP', outputDir: 'zvp',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('protoss_away', '이윤열', 2),
    homeBuildId: _zvpHome, awayBuildId: _zvpAway,
  ),
  _SingleConfig(
    matchup: 'ZvZ', outputDir: 'zvz',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('zerg_away', '박성준', 1),
    homeBuildId: _zvzHome, awayBuildId: _zvzAway,
  ),
];

void main() {
  for (final config in _configs) {
    test('${config.matchup} 1경기: ${config.homeBuildId} vs ${config.awayBuildId}', () async {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: config.homePlayer, awayPlayer: config.awayPlayer,
        map: _testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: config.homeBuildId,
        forcedAwayBuildId: config.awayBuildId,
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }

      expect(state, isNotNull);

      final homeRace = _raceNames[config.homePlayer.raceIndex];
      final awayRace = _raceNames[config.awayPlayer.raceIndex];

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

      final outDir = Directory('test/output/${config.outputDir}');
      if (!outDir.existsSync()) outDir.createSync(recursive: true);
      File('test/output/${config.outputDir}/single_log.md').writeAsStringSync(buf.toString());
      print(buf.toString());
    });
  }
}
