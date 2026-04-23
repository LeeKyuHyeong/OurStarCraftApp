// 홈/어웨이 편향 통합 테스트
//
// 1) 종족전 전체 편향 (빌드 랜덤): 동일 능력치 → 정방향/역방향 각 N경기 → ±5%p 이내
// 2) 특정 시나리오 반전 편향 (빌드 고정): 빌드 ID 고정 → 정방향/역방향 각 N경기 → ±5%p 이내
//
// 사용법:
//   flutter test test/bias_test.dart                                     # 전체
//   flutter test --name "TvT" test/bias_test.dart                       # 종족전 필터
//   flutter test --name "1fac_1star_vs_2fac_push" test/bias_test.dart   # 시나리오 필터
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'helpers/test_helpers.dart';

void main() {
  const int gamesPerDirection = 1000;
  const double maxBias = 5.0; // ±5%p

  /// N경기 돌려서 home 승수 반환
  Future<int> runBatch({
    required Player home, required Player away,
    String? homeBuildId, String? awayBuildId,
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

  // ══════════════════════════════════════════════════════════════
  // 1) 종족전 전체 홈/어웨이 편향 (빌드 랜덤)
  // ══════════════════════════════════════════════════════════════

  final matchups = <String, List<Player>>{
    'TvT': [createTestPlayer('t1', '테란A', 0), createTestPlayer('t2', '테란B', 0)],
    'TvZ': [createTestPlayer('t1', '테란A', 0), createTestPlayer('z1', '저그A', 1)],
    'TvP': [createTestPlayer('t1', '테란A', 0), createTestPlayer('p1', '프로토스A', 2)],
    'PvP': [createTestPlayer('p1', '프로토스A', 2), createTestPlayer('p2', '프로토스B', 2)],
    'ZvP': [createTestPlayer('z1', '저그A', 1), createTestPlayer('p1', '프로토스A', 2)],
    'ZvZ': [createTestPlayer('z1', '저그A', 1), createTestPlayer('z2', '저그B', 1)],
  };

  final matchupBuf = StringBuffer();
  matchupBuf.writeln('# 홈/어웨이 편향 테스트 (각 방향 ${gamesPerDirection}경기)\n');
  matchupBuf.writeln('| 종족전 | 정방향 P1홈승률 | 역방향 P1홈승률 | P1 총승률(정) | P1 총승률(역) | 차이 | 판정 |');
  matchupBuf.writeln('|--------|---------------|---------------|-------------|-------------|------|------|');

  final matchupFailures = <String>[];

  for (final entry in matchups.entries) {
    final name = entry.key;
    final p1 = entry.value[0];
    final p2 = entry.value[1];

    test('$name 홈/어웨이 편향 검증 (${gamesPerDirection}경기 x 2방향)', () async {
      final forwardHomeWins = await runBatch(home: p1, away: p2, count: gamesPerDirection);
      final forwardP1WinRate = forwardHomeWins / gamesPerDirection * 100;

      final reverseHomeWins = await runBatch(home: p2, away: p1, count: gamesPerDirection);
      final reverseP1WinRate = (gamesPerDirection - reverseHomeWins) / gamesPerDirection * 100;

      final bias = (forwardP1WinRate - reverseP1WinRate).abs();
      final pass = bias <= maxBias;

      matchupBuf.writeln('| $name | ${forwardP1WinRate.toStringAsFixed(1)}% | ${(100 - reverseP1WinRate).toStringAsFixed(1)}% | ${forwardP1WinRate.toStringAsFixed(1)}% | ${reverseP1WinRate.toStringAsFixed(1)}% | ${bias.toStringAsFixed(1)}%p | ${pass ? "PASS" : "**FAIL**"} |');

      if (!pass) {
        matchupFailures.add('$name: 정방향 ${forwardP1WinRate.toStringAsFixed(1)}% vs 역방향 ${reverseP1WinRate.toStringAsFixed(1)}% (차이 ${bias.toStringAsFixed(1)}%p > ${maxBias}%p)');
      }

      print('$name: 정방향 P1승률=${forwardP1WinRate.toStringAsFixed(1)}%, 역방향 P1승률=${reverseP1WinRate.toStringAsFixed(1)}%, 차이=${bias.toStringAsFixed(1)}%p ${pass ? "PASS" : "FAIL"}');

      expect(bias, lessThanOrEqualTo(maxBias),
        reason: '$name 홈/어웨이 편향 ${bias.toStringAsFixed(1)}%p > 허용 ${maxBias}%p');
    });
  }

  // ══════════════════════════════════════════════════════════════
  // 2) 특정 시나리오 반전 편향 (빌드 고정)
  // ══════════════════════════════════════════════════════════════

  final scenarios = <Map<String, dynamic>>[
    {
      'label': '1fac_1star_vs_2fac_push',
      'homeRace': 0, 'awayRace': 0,
      'homeBuild': 'tvt_1fac_1star',
      'awayBuild': 'tvt_2fac_push',
    },
    {
      'label': '1fac_1star_vs_2star',
      'homeRace': 0, 'awayRace': 0,
      'homeBuild': 'tvt_1fac_1star',
      'awayBuild': 'tvt_2star',
    },
    {
      'label': '1fac_1star_vs_1bar_double',
      'homeRace': 0, 'awayRace': 0,
      'homeBuild': 'tvt_1fac_1star',
      'awayBuild': 'tvt_1bar_double',
    },
  ];

  final scenarioBuf = StringBuffer();
  scenarioBuf.writeln('# 시나리오별 반전 편향 테스트 (각 방향 ${gamesPerDirection}경기)\n');
  scenarioBuf.writeln('| 시나리오 | 정방향 홈승률 | 역방향 홈승률 | 정방향 홈=P1승률 | 역방향 P1승률 | 차이 | 판정 |');
  scenarioBuf.writeln('|----------|--------------|--------------|----------------|--------------|------|------|');

  final scenarioFailures = <String>[];

  for (final s in scenarios) {
    final label = s['label'] as String;
    final homeBuild = s['homeBuild'] as String;
    final awayBuild = s['awayBuild'] as String;
    final p1 = createTestPlayer('p1', 'P1', s['homeRace'] as int);
    final p2 = createTestPlayer('p2', 'P2', s['awayRace'] as int);

    test(label, () async {
      final fwdHomeWins = await runBatch(
        home: p1, away: p2,
        homeBuildId: homeBuild, awayBuildId: awayBuild,
        count: gamesPerDirection,
      );
      final fwdHomeRate = fwdHomeWins / gamesPerDirection * 100;

      final revHomeWins = await runBatch(
        home: p2, away: p1,
        homeBuildId: awayBuild, awayBuildId: homeBuild,
        count: gamesPerDirection,
      );
      final revP1Rate = (gamesPerDirection - revHomeWins) / gamesPerDirection * 100;

      final bias = (fwdHomeRate - revP1Rate).abs();
      final pass = bias <= maxBias;

      final revHomeRate = revHomeWins / gamesPerDirection * 100;
      scenarioBuf.writeln('| $label | ${fwdHomeRate.toStringAsFixed(1)}% | ${revHomeRate.toStringAsFixed(1)}% | ${fwdHomeRate.toStringAsFixed(1)}% | ${revP1Rate.toStringAsFixed(1)}% | ${bias.toStringAsFixed(1)}%p | ${pass ? "PASS" : "**FAIL**"} |');

      if (!pass) {
        scenarioFailures.add('$label: 정방향 홈승률 ${fwdHomeRate.toStringAsFixed(1)}% vs 역방향 P1승률 ${revP1Rate.toStringAsFixed(1)}% (차이 ${bias.toStringAsFixed(1)}%p)');
      }

      print('$label: 정방향 홈=${fwdHomeRate.toStringAsFixed(1)}% / 역방향 P1=${revP1Rate.toStringAsFixed(1)}% / 차이=${bias.toStringAsFixed(1)}%p ${pass ? "PASS" : "FAIL"}');

      expect(bias, lessThanOrEqualTo(maxBias),
        reason: '$label 반전 편향 ${bias.toStringAsFixed(1)}%p > 허용 ${maxBias}%p');
    });
  }

  // ── 리포트 저장 ──

  tearDownAll(() {
    if (matchupFailures.isNotEmpty) {
      matchupBuf.writeln('\n## FAIL 항목\n');
      for (final f in matchupFailures) {
        matchupBuf.writeln('- $f');
      }
    } else {
      matchupBuf.writeln('\n**전 종족전 PASS**');
    }
    writeTestOutput('test/output', 'home_away_bias_report.md', matchupBuf.toString());

    if (scenarioFailures.isNotEmpty) {
      scenarioBuf.writeln('\n## FAIL 항목\n');
      for (final f in scenarioFailures) {
        scenarioBuf.writeln('- $f');
      }
    } else {
      scenarioBuf.writeln('\n**전 시나리오 PASS**');
    }
    writeTestOutput('test/output', 'scenario_bias_report.md', scenarioBuf.toString());

    print('\n${matchupBuf.toString()}');
    print('\n${scenarioBuf.toString()}');
  });
}
