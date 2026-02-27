import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

final pvpHome = Player(
  id: 'protoss_home',
  name: '홍진호',
  raceIndex: 2,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 680,
    strategy: 720, macro: 700, defense: 690, scout: 710,
  ),
  levelValue: 7,
  condition: 100,
);

final pvpAway = Player(
  id: 'protoss_away',
  name: '이제동',
  raceIndex: 2,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 700,
    strategy: 680, macro: 690, defense: 700, scout: 680,
  ),
  levelValue: 7,
  condition: 100,
);

const pvpMap = GameMap(
  id: 'test_fighting_spirit',
  name: '파이팅 스피릿',
  rushDistance: 6,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 6,
  centerImportance: 5,
);

String _wr(int w, int t) =>
    t > 0 ? '${(w / t * 100).toStringAsFixed(1)}%' : '-';

Future<void> runPvpScenario({
  required int scenNum,
  required String scenId,
  required String desc,
  required String homeBuild,
  required String awayBuild,
  required Map<String, Map<String, List<String>>> phases,
}) async {
  int homeWins = 0, awayWins = 0;
  final armyM = <int>[];
  final resM = <int>[];
  final uniqueTexts = <String>{};
  SimulationState? lastState;

  // 분기별 카운트
  final pCnt = <String, Map<String, int>>{};
  final pWin = <String, Map<String, int>>{};
  final pUnk = <String, int>{};

  for (final p in phases.keys) {
    pCnt[p] = {};
    pWin[p] = {};
    pUnk[p] = 0;
    for (final b in phases[p]!.keys) {
      pCnt[p]![b] = 0;
      pWin[p]![b] = 0;
    }
  }

  for (int i = 0; i < 500; i++) {
    final svc = MatchSimulationService();
    final stream = svc.simulateMatchWithLog(
      homePlayer: pvpHome,
      awayPlayer: pvpAway,
      map: pvpMap,
      getIntervalMs: () => 0,
      forcedHomeBuildId: homeBuild,
      forcedAwayBuildId: awayBuild,
    );
    SimulationState? st;
    await for (final s in stream) {
      st = s;
    }
    if (st == null) continue;
    lastState = st;

    final won = st.homeWin == true;
    if (won) {
      homeWins++;
    } else {
      awayWins++;
    }
    armyM.add(st.homeArmy - st.awayArmy);
    resM.add(st.homeResources - st.awayResources);
    for (final e in st.battleLogEntries) {
      uniqueTexts.add(e.text);
    }

    final all = st.battleLogEntries.map((e) => e.text).join(' ');
    for (final p in phases.keys) {
      bool found = false;
      for (final b in phases[p]!.keys) {
        if (phases[p]![b]!.any((t) => all.contains(t))) {
          pCnt[p]![b] = pCnt[p]![b]! + 1;
          if (won) pWin[p]![b] = pWin[p]![b]! + 1;
          found = true;
          break;
        }
      }
      if (!found) pUnk[p] = pUnk[p]! + 1;
    }
  }

  final total = homeWins + awayWins;
  final avgA = armyM.isEmpty
      ? 0.0
      : armyM.reduce((a, b) => a + b) / armyM.length;
  final avgR = resM.isEmpty
      ? 0.0
      : resM.reduce((a, b) => a + b) / resM.length;

  final buf = StringBuffer();
  buf.writeln('# PvP S$scenNum: $desc - 500경기');
  buf.writeln(
      '- 홈: 홍진호 (P) $homeBuild | 어웨이: 이제동 (P) $awayBuild');
  buf.writeln('- 시나리오: $scenId');
  buf.writeln('');
  buf.writeln('## 종합 ($total경기)');
  buf.writeln('| 선수 | 승 | 패 | 승률 |');
  buf.writeln('|------|----|----|------|');
  buf.writeln(
      '| 홍진호 (홈) | $homeWins | $awayWins | ${_wr(homeWins, total)} |');
  buf.writeln(
      '| 이제동 (어웨이) | $awayWins | $homeWins | ${_wr(awayWins, total)} |');
  buf.writeln(
      '- 평균 병력차: ${avgA.toStringAsFixed(1)} | 평균 자원차: ${avgR.toStringAsFixed(1)}');
  buf.writeln('- 고유 로그 수: ${uniqueTexts.length}');
  buf.writeln('');

  for (final p in phases.keys) {
    final pt = pCnt[p]!.values.fold(0, (a, b) => a + b);
    buf.writeln('## $p ($pt감지 / 미감지 ${pUnk[p]})');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    for (final b in phases[p]!.keys) {
      final c = pCnt[p]![b]!;
      buf.writeln(
          '| $b | $c | ${_wr(c, pt)} | ${_wr(pWin[p]![b]!, c)} |');
    }
    buf.writeln('');
  }

  // 마지막 경기 로그
  if (lastState != null) {
    buf.writeln('## 마지막 경기 로그');
    buf.writeln(
        '- 결과: ${lastState.homeWin == true ? "홈 승" : "어웨이 승"}');
    buf.writeln(
        '- 최종 병력: 홈 ${lastState.homeArmy} / 어웨이 ${lastState.awayArmy}');
    buf.writeln(
        '- 최종 자원: 홈 ${lastState.homeResources} / 어웨이 ${lastState.awayResources}');
    buf.writeln('');
    buf.writeln('```');
    for (final e in lastState.battleLogEntries) {
      final px = e.owner == LogOwner.system
          ? '[시스템]'
          : e.owner == LogOwner.home
              ? '[홈]'
              : '[어웨이]';
      buf.writeln('$px ${e.text}');
    }
    buf.writeln('```');
  }

  final dir = Directory('test/output/pvp');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  File('test/output/pvp/pvp_scen$scenNum.md')
      .writeAsStringSync(buf.toString());
  print(
      'pvp_scen$scenNum.md 저장 | 홈 $homeWins - $awayWins 어웨이 | 고유로그 ${uniqueTexts.length}');
}
