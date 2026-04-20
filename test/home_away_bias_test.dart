import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// ============================================================
/// 홈/어웨이 편향 테스트
/// 동일 능력치 선수 → 정방향 N경기 + 역방향 N경기 → 승률 차이 ±5%p 이내
/// ============================================================
void main() {
  const int gamesPerDirection = 1000;
  const double maxBias = 5.0; // ±5%p

  // 종족별 동일 능력치 선수
  Player makePlayer(String id, String name, int raceIndex) {
    return Player(
      id: id, name: name, raceIndex: raceIndex,
      stats: const PlayerStats(
        sense: 700, control: 700, attack: 700, harass: 700,
        strategy: 700, macro: 700, defense: 700, scout: 700,
      ),
      levelValue: 7, condition: 100,
    );
  }

  final playerT1 = makePlayer('t1', '테란A', 0);
  final playerT2 = makePlayer('t2', '테란B', 0);
  final playerP1 = makePlayer('p1', '프로토스A', 1);
  final playerP2 = makePlayer('p2', '프로토스B', 1);
  final playerZ1 = makePlayer('z1', '저그A', 2);
  final playerZ2 = makePlayer('z2', '저그B', 2);

  const testMap = GameMap(
    id: 'test_map', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  /// N경기 돌려서 home 승수 반환
  Future<int> runBatch(Player home, Player away, int count) async {
    int homeWins = 0;
    for (int i = 0; i < count; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: home, awayPlayer: away,
        map: testMap, getIntervalMs: () => 0,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWins++;
    }
    return homeWins;
  }

  // 테스트할 매치업 목록
  final matchups = <String, List<Player>>{
    'TvT': [playerT1, playerT2],
    'TvZ': [playerT1, playerZ1],
    'TvP': [playerT1, playerP1],
    'PvP': [playerP1, playerP2],
    'ZvP': [playerZ1, playerP1],
    'ZvZ': [playerZ1, playerZ2],
  };

  final buf = StringBuffer();
  buf.writeln('# 홈/어웨이 편향 테스트 (각 방향 ${gamesPerDirection}경기)\n');
  buf.writeln('| 종족전 | 정방향 P1홈승률 | 역방향 P1홈승률 | P1 총승률(정) | P1 총승률(역) | 차이 | 판정 |');
  buf.writeln('|--------|---------------|---------------|-------------|-------------|------|------|');

  final failures = <String>[];

  for (final entry in matchups.entries) {
    final name = entry.key;
    final p1 = entry.value[0];
    final p2 = entry.value[1];

    test('$name 홈/어웨이 편향 검증 (${gamesPerDirection}경기 × 2방향)', () async {
      // 정방향: P1=홈, P2=어웨이
      final forwardHomeWins = await runBatch(p1, p2, gamesPerDirection);
      final forwardP1WinRate = forwardHomeWins / gamesPerDirection * 100;

      // 역방향: P2=홈, P1=어웨이
      final reverseHomeWins = await runBatch(p2, p1, gamesPerDirection);
      final reverseP1WinRate = (gamesPerDirection - reverseHomeWins) / gamesPerDirection * 100;

      final bias = (forwardP1WinRate - reverseP1WinRate).abs();
      final pass = bias <= maxBias;

      buf.writeln('| $name | ${forwardP1WinRate.toStringAsFixed(1)}% | ${(100 - reverseP1WinRate).toStringAsFixed(1)}% | ${forwardP1WinRate.toStringAsFixed(1)}% | ${reverseP1WinRate.toStringAsFixed(1)}% | ${bias.toStringAsFixed(1)}%p | ${pass ? "PASS" : "**FAIL**"} |');

      if (!pass) {
        failures.add('$name: 정방향 ${forwardP1WinRate.toStringAsFixed(1)}% vs 역방향 ${reverseP1WinRate.toStringAsFixed(1)}% (차이 ${bias.toStringAsFixed(1)}%p > ${maxBias}%p)');
      }

      print('$name: 정방향 P1승률=${forwardP1WinRate.toStringAsFixed(1)}%, 역방향 P1승률=${reverseP1WinRate.toStringAsFixed(1)}%, 차이=${bias.toStringAsFixed(1)}%p ${pass ? "PASS" : "FAIL"}');

      expect(bias, lessThanOrEqualTo(maxBias),
        reason: '$name 홈/어웨이 편향 ${bias.toStringAsFixed(1)}%p > 허용 ${maxBias}%p');
    });
  }

  tearDownAll(() {
    if (failures.isNotEmpty) {
      buf.writeln('\n## FAIL 항목\n');
      for (final f in failures) {
        buf.writeln('- $f');
      }
    } else {
      buf.writeln('\n**전 종족전 PASS**');
    }

    final outDir = Directory('test/output');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/home_away_bias_report.md').writeAsStringSync(buf.toString());
    print('\n${buf.toString()}');
  });
}
