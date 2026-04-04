/// TvT 전체 45개 시나리오 3경기 로그 + 1000경기 통계
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final homePlayer = Player(
    id: 'terran_home', name: '이영호', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  final awayPlayer = Player(
    id: 'terran_away', name: '임요환', raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(
    id: 'test_fighting_spirit', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  const builds = [
    'tvt_bbs', 'tvt_1fac_1star', 'tvt_2fac_push', 'tvt_5fac',
    'tvt_2star', 'tvt_1bar_double', 'tvt_1fac_double',
    'tvt_nobar_double', 'tvt_fd_rush',
  ];

  // 45개 시나리오
  final scenarios = <Map<String, String>>[];
  for (int i = 0; i < builds.length; i++) {
    for (int j = i; j < builds.length; j++) {
      scenarios.add({
        'home': builds[i], 'away': builds[j],
        'label': i == j
            ? '${builds[i].replaceFirst("tvt_", "")}_mirror'
            : '${builds[i].replaceFirst("tvt_", "")}_vs_${builds[j].replaceFirst("tvt_", "")}',
      });
    }
  }

  Future<void> run3Games(String homeBuild, String awayBuild, String label) async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('# TvT $label 3경기 로그');
    buf.writeln();
    buf.writeln('**빌드**: $homeBuild vs $awayBuild');
    buf.writeln('**선수**: ${homePlayer.name}(홈) vs ${awayPlayer.name}(어웨이) | 동일 능력치 700');
    buf.writeln();

    int homeWins = 0;
    for (int game = 1; game <= 3; game++) {
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      final isHomeWin = state!.homeWin == true;
      if (isHomeWin) homeWins++;
      final winner = isHomeWin ? '홈(${homePlayer.name})' : '어웨이(${awayPlayer.name})';
      buf.writeln('---');
      buf.writeln('## Game $game | $winner 승 | 병력: ${state.homeArmy} vs ${state.awayArmy}');
      buf.writeln();
      buf.writeln('```');
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == LogOwner.home ? '[홈]  ' : e.owner == LogOwner.away ? '[어웨이]' : '[해설]';
        buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
      }
      buf.writeln('```');
      buf.writeln();
    }
    buf.writeln('---');
    buf.writeln('## 종합: 홈 $homeWins승 / 어웨이 ${3 - homeWins}승');

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/${label}_3games.md').writeAsStringSync(buf.toString());
  }

  Future<void> run1000Stats(String homeBuild, String awayBuild, String label) async {
    int homeWins = 0;
    const totalGames = 1000;
    int earlyEnd = 0, midEnd = 0, lateEnd = 0;
    List<int> logLengths = [];
    List<int> homeFinalArmy = [], awayFinalArmy = [];
    Set<String> uniqueTexts = {};

    for (int i = 0; i < totalGames; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      if (state.homeWin == true) homeWins++;
      final logLen = state.battleLogEntries.length;
      logLengths.add(logLen);
      homeFinalArmy.add(state.homeArmy);
      awayFinalArmy.add(state.awayArmy);
      uniqueTexts.add(state.battleLogEntries.map((e) => e.text).join('\n'));
      if (logLen <= 28) earlyEnd++;
      else if (logLen <= 42) midEnd++;
      else lateEnd++;
    }

    final homeWinRate = (homeWins / totalGames * 100).toStringAsFixed(1);
    final avgLogLen = (logLengths.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);
    final avgHomeArmy = (homeFinalArmy.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);
    final avgAwayArmy = (awayFinalArmy.reduce((a, b) => a + b) / totalGames).toStringAsFixed(1);

    final buf = StringBuffer();
    buf.writeln('# TvT $label 1000경기 통계');
    buf.writeln();
    buf.writeln('| 항목 | 값 |');
    buf.writeln('|------|-----|');
    buf.writeln('| 총 경기 | $totalGames |');
    buf.writeln('| 홈 승률 | $homeWinRate% ($homeWins승) |');
    buf.writeln('| 어웨이 승률 | ${(100 - double.parse(homeWinRate)).toStringAsFixed(1)}% (${totalGames - homeWins}승) |');
    buf.writeln('| 평균 로그 길이 | $avgLogLen줄 |');
    buf.writeln('| 평균 최종 병력 | 홈 $avgHomeArmy / 어웨이 $avgAwayArmy |');
    buf.writeln('| 고유 로그 수 | ${uniqueTexts.length} / $totalGames |');
    buf.writeln();
    buf.writeln('## 종료 시점 분포');
    buf.writeln();
    buf.writeln('| 시점 | 경기 수 | 비율 |');
    buf.writeln('|------|---------|------|');
    buf.writeln('| 초반 (~28줄) | $earlyEnd | ${(earlyEnd / totalGames * 100).toStringAsFixed(1)}% |');
    buf.writeln('| 중반 (29~42줄) | $midEnd | ${(midEnd / totalGames * 100).toStringAsFixed(1)}% |');
    buf.writeln('| 후반 (43줄~) | $lateEnd | ${(lateEnd / totalGames * 100).toStringAsFixed(1)}% |');

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/${label}_1000stats.md').writeAsStringSync(buf.toString());
    print('$label: 승률 $homeWinRate% | 초${(earlyEnd/10).toStringAsFixed(0)} 중${(midEnd/10).toStringAsFixed(0)} 후${(lateEnd/10).toStringAsFixed(0)} | 고유${uniqueTexts.length}');
  }

  // ── 그룹 A: 미러 9개 ──
  for (final s in scenarios.where((s) => s['home'] == s['away'])) {
    final label = s['label']!;
    test('$label 3경기', () => run3Games(s['home']!, s['away']!, label));
    test('$label 1000경기', () => run1000Stats(s['home']!, s['away']!, label),
        timeout: const Timeout(Duration(minutes: 30)));
  }

  // ── 그룹 B: 크로스 36개 ──
  for (final s in scenarios.where((s) => s['home'] != s['away'])) {
    final label = s['label']!;
    test('$label 3경기', () => run3Games(s['home']!, s['away']!, label));
    test('$label 1000경기', () => run1000Stats(s['home']!, s['away']!, label),
        timeout: const Timeout(Duration(minutes: 30)));
  }
}
