// 클래시 빈도/비율 검증 테스트
// 실제 경기 시뮬레이션을 돌려서 빌드 vs 클래시 vs 회복 라인 비율 분석
// 실행: flutter test test/clash_ratio_test.dart --reporter expanded
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// 테스트용 선수 생성
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

// 표준맵
const _standardMap = GameMap(
  id: 'test_standard',
  name: '테스트맵',
  rushDistance: 5,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 5,
  centerImportance: 5,
);

// 러시맵
const _rushMap = GameMap(
  id: 'test_rush',
  name: '러시맵',
  rushDistance: 3,
  resources: 4,
  terrainComplexity: 3,
  airAccessibility: 3,
  centerImportance: 7,
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

// 경기 로그에서 클래시/회복/빌드 라인 분류
class MatchAnalysis {
  int totalLines = 0;
  int buildLines = 0;
  int clashLines = 0;
  int recoveryLines = 0;
  int systemLines = 0;
  bool homeWin = false;
  int finalHomeArmy = 0;
  int finalAwayArmy = 0;

  double get clashRatio => totalLines > 0 ? clashLines / totalLines * 100 : 0;
  double get buildRatio => totalLines > 0 ? buildLines / totalLines * 100 : 0;
  double get recoveryRatio => totalLines > 0 ? recoveryLines / totalLines * 100 : 0;
}

// 회복 텍스트 판별
bool _isRecoveryText(String text) {
  const recoveryKeywords = [
    '병력 보충', '소강상태', '재정비', '전열을 가다듬',
    '병력 재편성', '숨 돌리며', '물량을 보충',
    '멀티에서 자원', '다음 교전을 준비',
  ];
  return recoveryKeywords.any((kw) => text.contains(kw));
}

// 시스템 텍스트 판별
bool _isSystemText(String text) {
  return text.contains('경기 시작') ||
      text.contains('맞붙습니다') ||
      text.contains('GG를 선언') ||
      text.contains('승리!') ||
      text.contains('빌드오더를') ||
      text.contains('해설') ||
      text.contains('마이프로리그') ||
      text.contains('저격 효과');
}

Future<MatchAnalysis> _runSingleMatch({
  required Player home,
  required Player away,
  required GameMap map,
}) async {
  final service = MatchSimulationService();
  final analysis = MatchAnalysis();

  final stream = service.simulateMatchWithLog(
    homePlayer: home,
    awayPlayer: away,
    map: map,
    getIntervalMs: () => 0, // 즉시 진행
  );

  SimulationState? lastState;
  await for (final state in stream) {
    lastState = state;
  }

  if (lastState != null) {
    analysis.homeWin = lastState.homeWin ?? false;
    analysis.finalHomeArmy = lastState.homeArmy;
    analysis.finalAwayArmy = lastState.awayArmy;

    for (final entry in lastState.battleLogEntries) {
      analysis.totalLines++;
      if (_isSystemText(entry.text)) {
        analysis.systemLines++;
      } else if (_isRecoveryText(entry.text)) {
        analysis.recoveryLines++;
      } else if (entry.owner == LogOwner.clash ||
          entry.text.contains('충돌') ||
          entry.text.contains('공격') ||
          entry.text.contains('전투') ||
          entry.text.contains('저격') ||
          entry.text.contains('컨트롤') ||
          entry.text.contains('역전') ||
          entry.text.contains('드랍') ||
          entry.text.contains('푸시') ||
          entry.text.contains('초토화') ||
          entry.text.contains('싸움') ||
          entry.text.contains('방어') ||
          entry.text.contains('GG')) {
        analysis.clashLines++;
      } else {
        analysis.buildLines++;
      }
    }
  }

  return analysis;
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

  test('전 종족전 클래시 비율 분석 (각 20회)', () async {
    final buffer = StringBuffer();
    buffer.writeln('=== 클래시 빈도 분석 (clashInterval=3, duration≥60 가속) ===\n');

    for (final (label, homeRace, awayRace) in matchups) {
      final configs = [
        ('BAL_vs_BAL', _balancedStats, _balancedStats),
        ('AGG_vs_DEF', _aggroStats, _defStats),
        ('DEF_vs_AGG', _defStats, _aggroStats),
      ];

      buffer.writeln('[$label]');

      for (final (configLabel, homeStats, awayStats) in configs) {
        int totalBuild = 0, totalClash = 0, totalRecovery = 0, totalSystem = 0, totalAll = 0;
        int homeWins = 0;
        const runs = 20;

        for (int i = 0; i < runs; i++) {
          final home = _makePlayer(name: 'Home', race: homeRace, stats: homeStats);
          final away = _makePlayer(name: 'Away', race: awayRace, stats: awayStats);

          final analysis = await _runSingleMatch(
            home: home, away: away, map: _standardMap,
          );

          totalBuild += analysis.buildLines;
          totalClash += analysis.clashLines;
          totalRecovery += analysis.recoveryLines;
          totalSystem += analysis.systemLines;
          totalAll += analysis.totalLines;
          if (analysis.homeWin) homeWins++;
        }

        final avgTotal = totalAll / runs;
        final clashPct = totalAll > 0 ? totalClash / totalAll * 100 : 0;
        final buildPct = totalAll > 0 ? totalBuild / totalAll * 100 : 0;
        final recoveryPct = totalAll > 0 ? totalRecovery / totalAll * 100 : 0;
        final winPct = homeWins / runs * 100;

        buffer.writeln('  $configLabel: 평균 ${avgTotal.toStringAsFixed(0)}줄 | '
            '빌드 ${buildPct.toStringAsFixed(1)}% | '
            '클래시 ${clashPct.toStringAsFixed(1)}% | '
            '회복 ${recoveryPct.toStringAsFixed(1)}% | '
            '승률 ${winPct.toStringAsFixed(0)}%');
      }
      buffer.writeln('');
    }

    print(buffer.toString());
  });

  // 여러 종족전 상세 로그
  final detailMatchups = [
    ('TvZ', '이영호', Race.terran, '이제동', Race.zerg),
    ('PvT', '김택용', Race.protoss, '이영호', Race.terran),
    ('ZvP', '이제동', Race.zerg, '김택용', Race.protoss),
    ('TvT', '이영호', Race.terran, '최연성', Race.terran),
    ('PvP', '김택용', Race.protoss, '박성균', Race.protoss),
  ];

  for (final (label, homeName, homeRace, awayName, awayRace) in detailMatchups) {
    test('상세 로그: $label ($homeName vs $awayName)', () async {
      final home = _makePlayer(name: homeName, race: homeRace, stats: _balancedStats);
      final away = _makePlayer(name: awayName, race: awayRace, stats: _balancedStats);

      final service = MatchSimulationService();
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
        print('\n=== $label 상세 로그 (${lastState.battleLogEntries.length}줄) ===');
        print('최종 Army: Home=${lastState.homeArmy} Away=${lastState.awayArmy}');
        print('승자: ${lastState.homeWin == true ? homeName : awayName}\n');

        for (int i = 0; i < lastState.battleLogEntries.length; i++) {
          final entry = lastState.battleLogEntries[i];
          String tag;
          if (entry.owner == LogOwner.system) {
            tag = '[해설]';
          } else if (entry.owner == LogOwner.home) {
            tag = '[홈]';
          } else if (entry.owner == LogOwner.away) {
            tag = '[어웨이]';
          } else {
            tag = '[${entry.owner.name}]';
          }
          print('${(i + 1).toString().padLeft(3)}. $tag ${entry.text}');
        }
      }
    });
  }
}
