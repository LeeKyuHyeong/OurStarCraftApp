import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// ============================================================
/// TvT 시나리오 보정용 3경기 로그 - 빌드 ID를 바꿔가며 사용
/// 출력: test/output/tvt/{homeBuild}_vs_{awayBuild}_3games.md
/// ============================================================
void main() {
  // ── 빌드 ID 설정 (여기만 수정) ──
  const homeBuildId = 'tvt_1fac_double';
  const awayBuildId = 'tvt_1fac_double';

  final homePlayer = Player(
    id: 'terran_home',
    name: '이영호',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'terran_away',
    name: '임요환',
    raceIndex: 0,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  const testMap = GameMap(
    id: 'test_fighting_spirit',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  // 파일명 생성: mirror면 {build}_mirror, 크로스면 {home}_vs_{away}
  final fileName = homeBuildId == awayBuildId
      ? '${homeBuildId.replaceFirst('tvt_', '')}_mirror'
      : '${homeBuildId.replaceFirst('tvt_', '')}_vs_${awayBuildId.replaceFirst('tvt_', '')}';

  test('TvT 3경기 로그: $homeBuildId vs $awayBuildId', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('# TvT $fileName 3경기 로그');
    buf.writeln();
    buf.writeln('**빌드**: $homeBuildId vs $awayBuildId');
    buf.writeln('**선수**: ${homePlayer.name}(홈) vs ${awayPlayer.name}(어웨이) | 동일 능력치 700');
    buf.writeln();

    int homeWins = 0;

    for (int game = 1; game <= 3; game++) {
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuildId,
        forcedAwayBuildId: awayBuildId,
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
    final outPath = 'test/output/tvt/${fileName}_3games.md';
    File(outPath).writeAsStringSync(buf.toString());
    print(buf.toString());
    print('저장: $outPath');
  });
}
