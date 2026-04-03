import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// TvT 전체 시나리오 1경기씩 로그 생성
void main() {
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

  final scenarios = [
    {'home': 'tvt_1bar_double', 'away': 'tvt_2fac_push', 'name': '배럭더블 vs 투팩벌처'},
    {'home': 'tvt_bbs', 'away': 'tvt_1bar_double', 'name': 'BBS vs 노배럭더블'},
    {'home': 'tvt_2star', 'away': 'tvt_1bar_double', 'name': '레이스 vs 배럭더블'},
    {'home': 'tvt_5fac', 'away': 'tvt_1fac_double', 'name': '5팩 vs 마인트리플'},
    {'home': 'tvt_bbs', 'away': 'tvt_2fac_push', 'name': 'BBS vs 테크빌드'},
    {'home': 'tvt_1fac_1star', 'away': 'tvt_2star', 'name': '공격적 빌드 대결'},
    {'home': 'tvt_1bar_double', 'away': 'tvt_1fac_double', 'name': '배럭더블 vs 원팩익스팬드'},
    {'home': 'tvt_1fac_1star', 'away': 'tvt_5fac', 'name': '원팩푸시 vs 5팩'},
    {'home': 'tvt_2fac_push', 'away': 'tvt_1fac_double', 'name': '투팩벌처 vs 원팩익스팬드'},
    {'home': 'tvt_bbs', 'away': 'tvt_bbs', 'name': 'BBS 미러'},
    {'home': 'tvt_1bar_double', 'away': 'tvt_1bar_double', 'name': '배럭더블 미러'},
    {'home': 'tvt_2fac_push', 'away': 'tvt_2fac_push', 'name': '투팩벌처 미러'},
    {'home': 'tvt_2star', 'away': 'tvt_2star', 'name': '레이스 미러'},
    {'home': 'tvt_1fac_1star', 'away': 'tvt_1fac_1star', 'name': '원팩푸시 미러'},
    {'home': 'tvt_5fac', 'away': 'tvt_5fac', 'name': '5팩 미러'},
    {'home': 'tvt_1fac_double', 'away': 'tvt_1fac_double', 'name': '원팩익스팬드 미러'},
  ];

  test('TvT 전체 시나리오 1경기 로그', () async {
    final buf = StringBuffer();

    for (final scenario in scenarios) {
      final homeBuild = scenario['home']!;
      final awayBuild = scenario['away']!;
      final scenarioName = scenario['name']!;

      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild,
        forcedAwayBuildId: awayBuild,
      );

      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;

      final winner = state.homeWin == true
          ? '홈(${homePlayer.name})'
          : '어웨이(${awayPlayer.name})';

      buf.writeln('### $scenarioName');
      buf.writeln('**빌드**: $homeBuild vs $awayBuild');
      buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}');
      buf.writeln();
      buf.writeln('```');
      for (int i = 0; i < state.battleLogEntries.length; i++) {
        final e = state.battleLogEntries[i];
        final ownerTag = e.owner == 'home'
            ? '[홈]  '
            : e.owner == 'away'
                ? '[어웨이]'
                : '[해설]';
        buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
      }
      buf.writeln('```');
      buf.writeln();
    }

    final outDir = Directory('test/output/tvt');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/tvt/all_single_logs.md').writeAsStringSync(buf.toString());
    print('16개 시나리오 1경기 로그 → test/output/tvt/all_single_logs.md');
  });
}
