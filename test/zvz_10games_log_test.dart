import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

import 'zvz_verify_helper.dart';

/// ZvZ 전 시나리오 10게임 전체 로그 출력 테스트
@Timeout(Duration(minutes: 30))
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final scenarios = <_Scenario>[
    _Scenario(1, '9풀 vs 9오버풀', 'zvz_9pool', 'zvz_9overpool'),
    _Scenario(2, '12앞마당 vs 9풀', 'zvz_12hatch', 'zvz_9pool'),
    _Scenario(3, '4풀 vs 12앞마당', 'zvz_pool_first', 'zvz_12hatch'),
    _Scenario(4, '3해처리 미러', 'zvz_3hatch_nopool', 'zvz_3hatch_nopool'),
    _Scenario(5, '4풀 vs 9풀', 'zvz_pool_first', 'zvz_9pool'),
    _Scenario(6, '4풀 vs 3해처리', 'zvz_pool_first', 'zvz_3hatch_nopool'),
    _Scenario(7, '9풀 미러', 'zvz_9pool', 'zvz_9pool'),
    _Scenario(8, '12풀 vs 3해처리', 'zvz_12pool', 'zvz_3hatch_nopool'),
    _Scenario(9, '9오버풀 미러', 'zvz_9overpool', 'zvz_9overpool'),
  ];

  for (final sc in scenarios) {
    group('ZvZ S${sc.num}: ${sc.title}', () {
      final games = <_GameResult>[];

      for (int i = 1; i <= 10; i++) {
        test('경기 $i', () async {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: homeEqual,
            awayPlayer: awayEqual,
            map: mapBalance,
            getIntervalMs: () => 0,
            forcedHomeBuildId: sc.build1,
            forcedAwayBuildId: sc.build2,
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
        buf.writeln('# ZvZ S${sc.num}: ${sc.title}');
        buf.writeln('빌드: ${sc.build1} vs ${sc.build2}\n');

        for (int i = 0; i < games.length; i++) {
          final g = games[i];
          final winner = g.homeWin ? '홈 승리' : '어웨이 승리';
          buf.writeln('## 경기 ${i + 1} ($winner)');
          buf.writeln(
              '최종 병력: 홈 ${g.homeArmy} / 어웨이 ${g.awayArmy} | 자원: 홈 ${g.homeRes} / 어웨이 ${g.awayRes}');
          buf.writeln('```');
          for (final line in g.logs) {
            buf.writeln(line);
          }
          buf.writeln('```\n');
        }

        final dir = Directory('test/output');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        File('test/output/zvz_s${sc.num}_10games.md')
            .writeAsStringSync(buf.toString());
      });
    });
  }
}

class _Scenario {
  final int num;
  final String title;
  final String build1;
  final String build2;

  const _Scenario(this.num, this.title, this.build1, this.build2);
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
