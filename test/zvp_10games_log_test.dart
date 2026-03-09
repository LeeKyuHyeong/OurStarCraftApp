import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

import 'zvp_verify_helper.dart';

/// ZvP 전 시나리오 10게임 전체 로그 출력 테스트
@Timeout(Duration(minutes: 30))
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final scenarios = <_Scenario>[
    _Scenario(1, '히드라 vs 포지더블', 'zvp_3hatch_hydra', 'pvz_forge_cannon'),
    _Scenario(2, '뮤탈 vs 포지더블', 'zvp_2hatch_mutal', 'pvz_forge_cannon'),
    _Scenario(3, '9풀 vs 포지더블', 'zvp_9pool', 'pvz_forge_cannon'),
    _Scenario(4, '4풀 vs 전진 게이트', 'zvp_4pool', 'pvz_proxy_gate'),
    _Scenario(5, '뮤커지 vs 커세어리버', 'zvp_mukerji', 'pvz_corsair_reaver'),
    _Scenario(6, '디파일러 vs 한방병력', 'zvp_scourge_defiler', 'pvz_forge_cannon'),
    _Scenario(7, '973 히드라 올인', 'zvp_973_hydra', 'pvz_forge_cannon'),
    _Scenario(8, '12앞마당 vs 2게이트', 'zvp_12hatch', 'pvz_2gate_zealot'),
    _Scenario(9, '3해처리 vs 커세어리버', 'zvp_3hatch_nopool', 'pvz_corsair_reaver'),
    _Scenario(10, '히드라럴커 vs 포지더블', 'zvp_trans_hydra_lurker', 'pvz_forge_cannon'),
    _Scenario(11, '올인 vs 포지더블', 'zvp_4pool', 'pvz_forge_cannon'),
  ];

  for (final sc in scenarios) {
    group('ZvP S${sc.num}: ${sc.title}', () {
      final games = <_GameResult>[];

      for (int i = 1; i <= 10; i++) {
        test('경기 $i', () async {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: zEqual,
            awayPlayer: pEqual,
            map: mapBalance,
            getIntervalMs: () => 0,
            forcedHomeBuildId: sc.zBuild,
            forcedAwayBuildId: sc.pBuild,
          );

          SimulationState? state;
          await for (final s in stream) {
            state = s;
          }

          expect(state, isNotNull);
          expect(state!.isFinished, isTrue);

          final logs = state.battleLogEntries.map((e) {
            switch (e.owner) {
              case LogOwner.home:
                return '[홈] ${e.text}';
              case LogOwner.away:
                return '[어웨이] ${e.text}';
              case LogOwner.clash:
                return '[교전] ${e.text}';
              case LogOwner.system:
                return '[해설] ${e.text}';
            }
          }).toList();

          games.add(_GameResult(
            homeWin: state.homeWin == true,
            homeArmy: state.homeArmy,
            awayArmy: state.awayArmy,
            homeRes: state.homeResources,
            awayRes: state.awayResources,
            logs: logs,
          ));
        }, timeout: const Timeout(Duration(minutes: 5)));
      }

      tearDownAll(() {
        final buf = StringBuffer();
        buf.writeln('# ZvP S${sc.num}: ${sc.title}');
        buf.writeln('빌드: ${sc.zBuild} vs ${sc.pBuild}\n');

        for (int i = 0; i < games.length; i++) {
          final g = games[i];
          final winner = g.homeWin ? 'Z 승리' : 'P 승리';
          buf.writeln('## 경기 ${i + 1} ($winner)');
          buf.writeln(
              '최종 병력: Z ${g.homeArmy} / P ${g.awayArmy} | 자원: Z ${g.homeRes} / P ${g.awayRes}');
          buf.writeln('```');
          for (final line in g.logs) {
            buf.writeln(line);
          }
          buf.writeln('```\n');
        }

        final dir = Directory('test/output');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        File('test/output/zvp_s${sc.num}_10games.md')
            .writeAsStringSync(buf.toString());
      });
    });
  }
}

class _Scenario {
  final int num;
  final String title;
  final String zBuild;
  final String pBuild;

  const _Scenario(this.num, this.title, this.zBuild, this.pBuild);
}

class _GameResult {
  final bool homeWin;
  final int homeArmy;
  final int awayArmy;
  final int homeRes;
  final int awayRes;
  final List<String> logs;

  const _GameResult({
    required this.homeWin,
    required this.homeArmy,
    required this.awayArmy,
    required this.homeRes,
    required this.awayRes,
    required this.logs,
  });
}
