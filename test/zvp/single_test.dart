import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// ============================================================
/// ZvP 1경기 테스트 - 빌드 ID를 바꿔가며 개별 시나리오 확인용
/// ============================================================
void main() {
  // ── 빌드 ID 설정 (여기만 수정) ──
  const homeBuildId = 'zvp_trans_5hatch_hydra';
  const awayBuildId = 'pvz_cannon_rush'; // 목표: P 30~70% 승률

  final homePlayer = Player(
    id: 'zerg_test',
    name: '이재동',
    raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'protoss_test',
    name: '이윤열',
    raceIndex: 2,
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

  test('ZvP 1경기: $homeBuildId vs $awayBuildId', () async {
    final service = MatchSimulationService();
    final stream = service.simulateMatchWithLog(
      homePlayer: homePlayer, awayPlayer: awayPlayer,
      map: testMap, getIntervalMs: () => 0,
      forcedHomeBuildId: homeBuildId,
      forcedAwayBuildId: awayBuildId,
    );

    SimulationState? state;
    await for (final s in stream) { state = s; }

    expect(state, isNotNull);

    final buf = StringBuffer();
    buf.writeln('**빌드**: $homeBuildId vs $awayBuildId');
    buf.writeln('**선수**: ${homePlayer.name}(저그/홈) vs ${awayPlayer.name}(프로토스/어웨이)');
    final winner = state!.homeWin == true ? '홈(${homePlayer.name})' : '어웨이(${awayPlayer.name})';
    buf.writeln('**결과**: $winner 승 | 최종 병력: ${state.homeArmy} vs ${state.awayArmy}');
    buf.writeln();
    buf.writeln('```');
    for (int i = 0; i < state.battleLogEntries.length; i++) {
      final e = state.battleLogEntries[i];
      final ownerTag = e.owner == 'home' ? '[홈]  ' : e.owner == 'away' ? '[어웨이]' : '[해설]';
      buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
    }
    buf.writeln('```');

    final outDir = Directory('test/output/zvp');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/zvp/single_log.md').writeAsStringSync(buf.toString());
    print(buf.toString());
  });
}
