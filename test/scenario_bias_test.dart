import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

/// ============================================================
/// 특정 시나리오(빌드 조합) 반전 편향 테스트
/// 빌드 ID를 고정하여 정방향/역방향 각 N경기 → 승률 차이 ±5%p 이내
/// ============================================================
///
/// 사용법: SCENARIOS 리스트에 검증할 {matchup, homeBuild, awayBuild, races} 추가
/// 실행: flutter test --name "1fac_1star_vs_2fac_push" test/scenario_bias_test.dart
void main() {
  const int gamesPerDirection = 300;
  const double maxBias = 5.0;

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

  const testMap = GameMap(
    id: 'test_map', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  // 검증 대상 시나리오 목록
  final scenarios = <Map<String, dynamic>>[
    {
      'label': '1fac_1star_vs_2fac_push',
      'homeRace': 0, // Terran
      'awayRace': 0, // Terran
      'homeBuild': 'tvt_1fac_1star',
      'awayBuild': 'tvt_2fac_push',
    },
    {
      'label': '1fac_1star_vs_2star',
      'homeRace': 0,
      'awayRace': 0,
      'homeBuild': 'tvt_1fac_1star',
      'awayBuild': 'tvt_2star',
    },
  ];

  Future<int> runBatch({
    required Player home, required Player away,
    required String homeBuildId, required String awayBuildId,
    required int count,
  }) async {
    int homeWins = 0;
    for (int i = 0; i < count; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: home, awayPlayer: away,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuildId,
        forcedAwayBuildId: awayBuildId,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWins++;
    }
    return homeWins;
  }

  final buf = StringBuffer();
  buf.writeln('# 시나리오별 반전 편향 테스트 (각 방향 ${gamesPerDirection}경기)\n');
  buf.writeln('| 시나리오 | 정방향 홈승률 | 역방향 홈승률 | 정방향 홈=P1승률 | 역방향 P1승률 | 차이 | 판정 |');
  buf.writeln('|----------|--------------|--------------|----------------|--------------|------|------|');

  final failures = <String>[];

  for (final s in scenarios) {
    final label = s['label'] as String;
    final homeBuild = s['homeBuild'] as String;
    final awayBuild = s['awayBuild'] as String;
    final p1 = makePlayer('p1', 'P1', s['homeRace'] as int);
    final p2 = makePlayer('p2', 'P2', s['awayRace'] as int);

    test(label, () async {
      // 정방향: P1=홈(homeBuild), P2=어웨이(awayBuild)
      final fwdHomeWins = await runBatch(
        home: p1, away: p2,
        homeBuildId: homeBuild, awayBuildId: awayBuild,
        count: gamesPerDirection,
      );
      final fwdHomeRate = fwdHomeWins / gamesPerDirection * 100;

      // 역방향: P2=홈(awayBuild), P1=어웨이(homeBuild) → P1은 여전히 homeBuild 사용
      final revHomeWins = await runBatch(
        home: p2, away: p1,
        homeBuildId: awayBuild, awayBuildId: homeBuild,
        count: gamesPerDirection,
      );
      // 역방향에서 P1 승률 = (N - home승수) / N
      final revP1Rate = (gamesPerDirection - revHomeWins) / gamesPerDirection * 100;

      final bias = (fwdHomeRate - revP1Rate).abs();
      final pass = bias <= maxBias;

      final revHomeRate = revHomeWins / gamesPerDirection * 100;
      buf.writeln('| $label | ${fwdHomeRate.toStringAsFixed(1)}% | ${revHomeRate.toStringAsFixed(1)}% | ${fwdHomeRate.toStringAsFixed(1)}% | ${revP1Rate.toStringAsFixed(1)}% | ${bias.toStringAsFixed(1)}%p | ${pass ? "PASS" : "**FAIL**"} |');

      if (!pass) {
        failures.add('$label: 정방향 홈승률 ${fwdHomeRate.toStringAsFixed(1)}% vs 역방향 P1승률 ${revP1Rate.toStringAsFixed(1)}% (차이 ${bias.toStringAsFixed(1)}%p)');
      }

      print('$label: 정방향 홈=${fwdHomeRate.toStringAsFixed(1)}% / 역방향 P1=${revP1Rate.toStringAsFixed(1)}% / 차이=${bias.toStringAsFixed(1)}%p ${pass ? "PASS" : "FAIL"}');

      expect(bias, lessThanOrEqualTo(maxBias),
        reason: '$label 반전 편향 ${bias.toStringAsFixed(1)}%p > 허용 ${maxBias}%p');
    });
  }

  tearDownAll(() {
    if (failures.isNotEmpty) {
      buf.writeln('\n## FAIL 항목\n');
      for (final f in failures) {
        buf.writeln('- $f');
      }
    } else {
      buf.writeln('\n**전 시나리오 PASS**');
    }

    final outDir = Directory('test/output');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/scenario_bias_report.md').writeAsStringSync(buf.toString());
    print('\n${buf.toString()}');
  });
}
