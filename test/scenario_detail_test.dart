// 시나리오 상세 검증 테스트 - 매 이벤트마다 병력/자원 추이를 추적하여 비정상 감지
//
// 사용법:
//   flutter test --name "Detail TvT" test/scenario_detail_test.dart
//   flutter test --name "Detail TvZ" test/scenario_detail_test.dart
//   flutter test --name "Detail PvT" test/scenario_detail_test.dart
//   flutter test --name "Detail PvP" test/scenario_detail_test.dart
//   flutter test --name "Detail ZvP" test/scenario_detail_test.dart
//   flutter test --name "Detail ZvZ" test/scenario_detail_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// ── 빌드 ID 설정 (여기만 수정) ──

const _tvtHome = 'tvt_1fac_1star';
const _tvtAway = 'tvt_1fac_2star';

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

// ── 경기 수 ──
const _gameCount = 10;

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

class _DetailConfig {
  final String matchup;
  final String outputDir;
  final Player homePlayer;
  final Player awayPlayer;
  final String homeBuildId;
  final String awayBuildId;

  const _DetailConfig({
    required this.matchup,
    required this.outputDir,
    required this.homePlayer,
    required this.awayPlayer,
    required this.homeBuildId,
    required this.awayBuildId,
  });
}

final _configs = <_DetailConfig>[
  _DetailConfig(
    matchup: 'TvT', outputDir: 'tvt',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('terran_away', '임요환', 0),
    homeBuildId: _tvtHome, awayBuildId: _tvtAway,
  ),
  _DetailConfig(
    matchup: 'TvZ', outputDir: 'tvz',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('zerg_away', '이재동', 1),
    homeBuildId: _tvzHome, awayBuildId: _tvzAway,
  ),
  _DetailConfig(
    matchup: 'PvT', outputDir: 'pvt',
    homePlayer: _player('protoss_home', '이윤열', 2),
    awayPlayer: _player('terran_away', '이영호', 0),
    homeBuildId: _pvtHome, awayBuildId: _pvtAway,
  ),
  _DetailConfig(
    matchup: 'PvP', outputDir: 'pvp',
    homePlayer: _player('protoss_home', '이윤열', 2),
    awayPlayer: _player('protoss_away', '김택용', 2),
    homeBuildId: _pvpHome, awayBuildId: _pvpAway,
  ),
  _DetailConfig(
    matchup: 'ZvP', outputDir: 'zvp',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('protoss_away', '이윤열', 2),
    homeBuildId: _zvpHome, awayBuildId: _zvpAway,
  ),
  _DetailConfig(
    matchup: 'ZvZ', outputDir: 'zvz',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('zerg_away', '박성준', 1),
    homeBuildId: _zvzHome, awayBuildId: _zvzAway,
  ),
];

// ── 경고 타입 ──

enum WarnType {
  clampArmy,       // army가 0으로 클램핑됨 (감소분 > 현재값)
  clampResource,   // resource가 0으로 클램핑됨
  armyZeroAlive,   // army 0인데 게임 계속 진행 (3이벤트 이상)
  winnerLessArmy,  // 승자 최종 army < 패자
}

class Warning {
  final WarnType type;
  final int gameIndex;
  final int eventIndex;
  final String detail;
  bool get isError => type == WarnType.armyZeroAlive || type == WarnType.winnerLessArmy;

  const Warning(this.type, this.gameIndex, this.eventIndex, this.detail);

  String get label => isError ? 'ERROR' : 'WARN';
  String get code => type.name;
}

void main() {
  for (final config in _configs) {
    test('Detail ${config.matchup}: ${config.homeBuildId} vs ${config.awayBuildId}', () async {
      final service = MatchSimulationService();
      final allWarnings = <Warning>[];
      final gameBuf = StringBuffer();

      final homeRace = _raceNames[config.homePlayer.raceIndex];
      final awayRace = _raceNames[config.awayPlayer.raceIndex];

      gameBuf.writeln('# ${config.matchup} 상세 검증: ${config.homeBuildId} vs ${config.awayBuildId}');
      gameBuf.writeln();
      gameBuf.writeln('- 홈: ${config.homePlayer.name}($homeRace) / 어웨이: ${config.awayPlayer.name}($awayRace)');
      gameBuf.writeln('- 경기 수: $_gameCount');
      gameBuf.writeln();

      for (int g = 0; g < _gameCount; g++) {
        final stream = service.simulateMatchWithLog(
          homePlayer: config.homePlayer, awayPlayer: config.awayPlayer,
          map: _testMap, getIntervalMs: () => 0,
          forcedHomeBuildId: config.homeBuildId,
          forcedAwayBuildId: config.awayBuildId,
        );

        final states = <SimulationState>[];
        await for (final s in stream) {
          states.add(s);
        }

        if (states.isEmpty) continue;

        final gameWarnings = <Warning>[];

        // 엔딩 보간 구간 식별 (마지막 3이벤트: 결정타/GG/승리선언)
        // GG 텍스트로 역추적하여 보간 시작점 찾기
        int endingStartIndex = states.length;
        for (int i = states.length - 1; i >= 0 && i >= states.length - 4; i--) {
          if (i < states[i].battleLogEntries.length) {
            final text = states[i].battleLogEntries[i].text;
            if (text.contains('GG를 선언') || text.contains('승리!')) {
              endingStartIndex = i;
            }
          }
        }
        // 보간 시작 = GG 1줄 전 (결정타)
        if (endingStartIndex > 0) endingStartIndex = endingStartIndex - 1;
        // 최소 마지막 3이벤트는 엔딩으로 간주
        endingStartIndex = endingStartIndex.clamp(0, states.length - 3);

        // 보간 전 마지막 시나리오 state (검증 기준)
        final preEndingState = endingStartIndex > 0 ? states[endingStartIndex - 1] : states.last;

        // 이벤트 추이 표
        gameBuf.writeln('## 경기 ${g + 1}');

        final finalState = states.last;
        final winner = finalState.homeWin == true ? '홈' : '어웨이';
        gameBuf.writeln('결과: **$winner 승** | 보간 전 병력: ${preEndingState.homeArmy} vs ${preEndingState.awayArmy} | 보간 전 자원: ${preEndingState.homeResources} vs ${preEndingState.awayResources}');
        gameBuf.writeln();
        gameBuf.writeln('| # | hArmy | Δ | aArmy | Δ | hRes | Δ | aRes | Δ | 소유 | 텍스트 | 경고 |');
        gameBuf.writeln('|---|-------|---|-------|---|------|---|------|---|------|--------|------|');

        int homeZeroCount = 0;
        int awayZeroCount = 0;
        bool homeEverHadArmy = false;
        bool awayEverHadArmy = false;

        for (int i = 0; i < states.length; i++) {
          final cur = states[i];
          final prev = i > 0 ? states[i - 1] : null;
          final isEnding = i >= endingStartIndex;

          final dHA = prev != null ? cur.homeArmy - prev.homeArmy : cur.homeArmy;
          final dAA = prev != null ? cur.awayArmy - prev.awayArmy : cur.awayArmy;
          final dHR = prev != null ? cur.homeResources - prev.homeResources : cur.homeResources;
          final dAR = prev != null ? cur.awayResources - prev.awayResources : cur.awayResources;

          // 경고 체크 (엔딩 보간 구간은 스킵)
          final eventWarns = <String>[];

          if (!isEnding) {
            // CLAMP_ARMY: 현재값 대비 감소분이 더 커서 0이 됨
            if (prev != null && cur.homeArmy == 0 && prev.homeArmy > 0 && dHA < 0) {
              final w = Warning(WarnType.clampArmy, g, i, '홈 army ${prev.homeArmy}→0 (Δ$dHA)');
              gameWarnings.add(w);
              eventWarns.add('CLAMP_ARMY(홈)');
            }
            if (prev != null && cur.awayArmy == 0 && prev.awayArmy > 0 && dAA < 0) {
              final w = Warning(WarnType.clampArmy, g, i, '어웨이 army ${prev.awayArmy}→0 (Δ$dAA)');
              gameWarnings.add(w);
              eventWarns.add('CLAMP_ARMY(어웨이)');
            }

            // CLAMP_RESOURCE
            if (prev != null && cur.homeResources == 0 && prev.homeResources > 0 && dHR < 0) {
              final w = Warning(WarnType.clampResource, g, i, '홈 res ${prev.homeResources}→0 (Δ$dHR)');
              gameWarnings.add(w);
              eventWarns.add('CLAMP_RES(홈)');
            }
            if (prev != null && cur.awayResources == 0 && prev.awayResources > 0 && dAR < 0) {
              final w = Warning(WarnType.clampResource, g, i, '어웨이 res ${prev.awayResources}→0 (Δ$dAR)');
              gameWarnings.add(w);
              eventWarns.add('CLAMP_RES(어웨이)');
            }

            // ARMY_ZERO_ALIVE: army 0이 3이벤트 이상 지속 (한번이라도 army>0이었던 이후에만 체크)
            if (cur.homeArmy == 0 && homeEverHadArmy) {
              homeZeroCount++;
            } else {
              if (cur.homeArmy > 0) homeEverHadArmy = true;
              homeZeroCount = 0;
            }
            if (cur.awayArmy == 0 && awayEverHadArmy) {
              awayZeroCount++;
            } else {
              if (cur.awayArmy > 0) awayEverHadArmy = true;
              awayZeroCount = 0;
            }
            if (homeZeroCount == 3) {
              final w = Warning(WarnType.armyZeroAlive, g, i, '홈 army 0이 3이벤트 연속 지속');
              gameWarnings.add(w);
              eventWarns.add('ARMY_ZERO(홈)');
            }
            if (awayZeroCount == 3) {
              final w = Warning(WarnType.armyZeroAlive, g, i, '어웨이 army 0이 3이벤트 연속 지속');
              gameWarnings.add(w);
              eventWarns.add('ARMY_ZERO(어웨이)');
            }
          }

          // 로그 텍스트
          final logText = i < cur.battleLogEntries.length
              ? cur.battleLogEntries[i].text
              : (cur.battleLogEntries.isNotEmpty ? cur.battleLogEntries.last.text : '');
          final logOwner = i < cur.battleLogEntries.length
              ? cur.battleLogEntries[i].owner
              : null;
          final ownerTag = logOwner == LogOwner.home ? '홈' : logOwner == LogOwner.away ? '어웨이' : '해설';

          // 델타 표시
          String fmtDelta(int d) => d == 0 ? '.' : (d > 0 ? '+$d' : '$d');

          final warnStr = eventWarns.isEmpty ? '' : (isEnding ? '(엔딩)' : eventWarns.join(', '));
          final truncText = logText.length > 40 ? '${logText.substring(0, 40)}…' : logText;

          gameBuf.writeln('| ${i + 1} | ${cur.homeArmy} | ${fmtDelta(dHA)} | ${cur.awayArmy} | ${fmtDelta(dAA)} | ${cur.homeResources} | ${fmtDelta(dHR)} | ${cur.awayResources} | ${fmtDelta(dAR)} | $ownerTag | $truncText | $warnStr |');
        }

        // WINNER_LESS_ARMY — 보간 전 state 기준으로 검증
        if (finalState.homeWin == true && preEndingState.homeArmy < preEndingState.awayArmy) {
          gameWarnings.add(Warning(WarnType.winnerLessArmy, g, endingStartIndex,
              '홈 승리인데 보간 전 병력 ${preEndingState.homeArmy} < ${preEndingState.awayArmy}'));
        }
        if (finalState.homeWin == false && preEndingState.awayArmy < preEndingState.homeArmy) {
          gameWarnings.add(Warning(WarnType.winnerLessArmy, g, endingStartIndex,
              '어웨이 승리인데 보간 전 병력 ${preEndingState.awayArmy} < ${preEndingState.homeArmy}'));
        }

        if (gameWarnings.isNotEmpty) {
          gameBuf.writeln();
          gameBuf.writeln('**경고 ${gameWarnings.length}건:**');
          for (final w in gameWarnings) {
            gameBuf.writeln('- [${w.label}] ${w.code}: ${w.detail}');
          }
        }
        gameBuf.writeln();

        allWarnings.addAll(gameWarnings);
      }

      // 전체 요약
      gameBuf.writeln('---');
      gameBuf.writeln('## 전체 요약');
      gameBuf.writeln();

      final errors = allWarnings.where((w) => w.isError).toList();
      final warnings = allWarnings.where((w) => !w.isError).toList();

      gameBuf.writeln('- 총 경기: $_gameCount');
      gameBuf.writeln('- ERROR: ${errors.length}건');
      gameBuf.writeln('- WARNING: ${warnings.length}건');

      if (allWarnings.isNotEmpty) {
        // 타입별 집계
        final countByType = <WarnType, int>{};
        for (final w in allWarnings) {
          countByType[w.type] = (countByType[w.type] ?? 0) + 1;
        }
        gameBuf.writeln();
        gameBuf.writeln('| 코드 | 횟수 | 심각도 |');
        gameBuf.writeln('|------|------|--------|');
        for (final entry in countByType.entries) {
          final severity = (entry.key == WarnType.armyZeroAlive || entry.key == WarnType.winnerLessArmy)
              ? 'error' : 'warning';
          gameBuf.writeln('| ${entry.key.name} | ${entry.value} | $severity |');
        }

        gameBuf.writeln();
        gameBuf.writeln('### 상세');
        for (final w in allWarnings) {
          gameBuf.writeln('- [경기${w.gameIndex + 1} #${w.eventIndex + 1}] [${w.label}] ${w.code}: ${w.detail}');
        }
      } else {
        gameBuf.writeln();
        gameBuf.writeln('모든 검증 통과!');
      }

      // 파일 출력
      final outDir = Directory('test/output/${config.outputDir}');
      if (!outDir.existsSync()) outDir.createSync(recursive: true);
      File('test/output/${config.outputDir}/detail_log.md').writeAsStringSync(gameBuf.toString());
      print(gameBuf.toString());

      // error가 있으면 테스트 실패
      if (errors.isNotEmpty) {
        fail('${errors.length}건의 ERROR 발견 — test/output/${config.outputDir}/detail_log.md 참조');
      }
    });
  }
}
