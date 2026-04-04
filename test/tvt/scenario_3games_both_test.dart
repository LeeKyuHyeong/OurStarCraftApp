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

  Future<void> run3Games(String buildId, String label) async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    final buildName = buildId.replaceFirst('tvt_', '');
    buf.writeln('# TvT ${buildName}_mirror 3경기 로그');
    buf.writeln();
    buf.writeln('**빌드**: $buildId vs $buildId');
    buf.writeln('**선수**: ${homePlayer.name}(홈) vs ${awayPlayer.name}(어웨이) | 동일 능력치 700');
    buf.writeln();

    int homeWins = 0;
    for (int game = 1; game <= 3; game++) {
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: buildId, forcedAwayBuildId: buildId,
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
    final outPath = 'test/output/tvt/${buildName}_mirror_3games.md';
    File(outPath).writeAsStringSync(buf.toString());
    print(buf.toString());
    print('저장: $outPath');
  }

  test('1bar_double_mirror 3경기', () async {
    await run3Games('tvt_1bar_double', '1bar_double');
  });

  test('1fac_double_mirror 3경기', () async {
    await run3Games('tvt_1fac_double', '1fac_double');
  });

  test('2fac_push_mirror 3경기', () async {
    await run3Games('tvt_2fac_push', '2fac_push');
  });
}
