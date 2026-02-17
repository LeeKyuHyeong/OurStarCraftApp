// 종족전별 승률 정밀 분석 (100회 × 3스타일)
// 승패 원인 추적: army=0, 결정적이벤트, 병력격차, 타임아웃
// 실행: flutter test test/winrate_analysis_test.dart --reporter expanded
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

Player _makePlayer({
  required String name,
  required Race race,
  required PlayerStats stats,
}) {
  return Player(
    id: name,
    name: name,
    raceIndex: race.index,
    stats: stats,
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

// B+ 균형 스탯
const _balancedStats = PlayerStats(
  sense: 650, control: 650, attack: 650, harass: 650,
  strategy: 650, macro: 650, defense: 650, scout: 650,
);

// 공격형 스탯
const _aggroStats = PlayerStats(
  sense: 550, control: 750, attack: 800, harass: 700,
  strategy: 600, macro: 500, defense: 450, scout: 500,
);

// 수비형 스탯
const _defStats = PlayerStats(
  sense: 600, control: 600, attack: 450, harass: 500,
  strategy: 700, macro: 800, defense: 750, scout: 550,
);

class WinDetail {
  int homeWins = 0;
  int awayWins = 0;
  int totalGames = 0;
  int totalLines = 0;
  int homeArmyZero = 0;   // home army=0으로 패배
  int awayArmyZero = 0;   // away army=0으로 패배
  int decisiveHome = 0;    // 결정적 이벤트로 home 승리
  int decisiveAway = 0;    // 결정적 이벤트로 away 승리
  int shortGames = 0;      // 30줄 이하 게임
  int longGames = 0;       // 80줄 이상 게임

  // 최종 army 누적
  int totalFinalHomeArmy = 0;
  int totalFinalAwayArmy = 0;

  double get homeWinRate => totalGames > 0 ? homeWins / totalGames * 100 : 0;
  double get avgLines => totalGames > 0 ? totalLines / totalGames : 0;
  double get avgFinalHomeArmy => totalGames > 0 ? totalFinalHomeArmy / totalGames : 0;
  double get avgFinalAwayArmy => totalGames > 0 ? totalFinalAwayArmy / totalGames : 0;
}

Future<void> _analyzeMatchup({
  required String label,
  required Race homeRace,
  required Race awayRace,
  required PlayerStats homeStats,
  required PlayerStats awayStats,
  required String styleLabel,
  required StringBuffer buf,
  int runs = 100,
}) async {
  final detail = WinDetail();
  final service = MatchSimulationService();

  for (int i = 0; i < runs; i++) {
    final home = _makePlayer(name: 'Home', race: homeRace, stats: homeStats);
    final away = _makePlayer(name: 'Away', race: awayRace, stats: awayStats);

    final stream = service.simulateMatchWithLog(
      homePlayer: home,
      awayPlayer: away,
      map: _standardMap,
      getIntervalMs: () => 0,
    );

    SimulationState? lastState;
    await for (final state in stream) {
      lastState = state;
    }

    if (lastState != null) {
      detail.totalGames++;
      detail.totalLines += lastState.battleLogEntries.length;
      detail.totalFinalHomeArmy += lastState.homeArmy;
      detail.totalFinalAwayArmy += lastState.awayArmy;

      final lines = lastState.battleLogEntries.length;
      if (lines <= 30) detail.shortGames++;
      if (lines >= 80) detail.longGames++;

      if (lastState.homeWin == true) {
        detail.homeWins++;
        if (lastState.awayArmy <= 0) detail.awayArmyZero++;
      } else {
        detail.awayWins++;
        if (lastState.homeArmy <= 0) detail.homeArmyZero++;
      }

      // 결정적 이벤트 감지 (GG 직전에 결정적 텍스트)
      final entries = lastState.battleLogEntries;
      for (int j = entries.length - 1; j >= 0 && j >= entries.length - 5; j--) {
        final text = entries[j].text;
        if (text.contains('상대 본진 초토화') ||
            text.contains('빌드 승리') ||
            text.contains('기습 성공')) {
          if (lastState.homeWin == true) {
            detail.decisiveHome++;
          } else {
            detail.decisiveAway++;
          }
          break;
        }
      }
    }
  }

  buf.writeln('  $styleLabel (${runs}회):');
  buf.writeln('    승률: Home ${detail.homeWinRate.toStringAsFixed(1)}% (${detail.homeWins}승 ${detail.awayWins}패)');
  buf.writeln('    평균줄: ${detail.avgLines.toStringAsFixed(1)} | 짧은경기(≤30): ${detail.shortGames} | 긴경기(≥80): ${detail.longGames}');
  buf.writeln('    패배원인: Home army=0: ${detail.homeArmyZero} | Away army=0: ${detail.awayArmyZero}');
  buf.writeln('    결정적이벤트: Home승 ${detail.decisiveHome} | Away승 ${detail.decisiveAway}');
  buf.writeln('    평균잔여army: Home ${detail.avgFinalHomeArmy.toStringAsFixed(1)} | Away ${detail.avgFinalAwayArmy.toStringAsFixed(1)}');
  buf.writeln('');
}

void main() {
  final matchups = [
    ('TvZ', Race.terran, Race.zerg),
    ('ZvT', Race.zerg, Race.terran),
    ('TvP', Race.terran, Race.protoss),
    ('PvT', Race.protoss, Race.terran),
    ('ZvP', Race.zerg, Race.protoss),
    ('PvZ', Race.protoss, Race.zerg),
    ('TvT', Race.terran, Race.terran),
    ('ZvZ', Race.zerg, Race.zerg),
    ('PvP', Race.protoss, Race.protoss),
  ];

  test('전 종족전 승률 정밀 분석 (각 200회)', () async {
    final buf = StringBuffer();
    buf.writeln('=== 종족전 승률 정밀 분석 (200회 × 3스타일) ===\n');

    for (final (label, homeRace, awayRace) in matchups) {
      buf.writeln('[$label] (Home=${homeRace.name} vs Away=${awayRace.name})');

      final configs = [
        ('BAL_vs_BAL', _balancedStats, _balancedStats),
        ('AGG_vs_DEF', _aggroStats, _defStats),
        ('DEF_vs_AGG', _defStats, _aggroStats),
      ];

      for (final (styleLabel, homeStats, awayStats) in configs) {
        await _analyzeMatchup(
          label: label,
          homeRace: homeRace,
          awayRace: awayRace,
          homeStats: homeStats,
          awayStats: awayStats,
          styleLabel: styleLabel,
          buf: buf,
          runs: 200,
        );
      }
      buf.writeln('---');
    }

    print(buf.toString());
  }, timeout: const Timeout(Duration(minutes: 10)));
}
