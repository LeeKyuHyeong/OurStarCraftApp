import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

import 'pvt_verify_helper.dart';

/// PvT 전 시나리오 10게임 전체 로그 출력 테스트
@Timeout(Duration(minutes: 30))
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final scenarios = <_Scenario>[
    _Scenario(1, '드라군 확장 vs 팩더블', 'pvt_1gate_expand', 'tvp_double'),
    _Scenario(2, '리버 셔틀 vs 타이밍', 'pvt_reaver_shuttle', 'tvp_fake_double'),
    _Scenario(3, '다크 기습 vs 스탠다드', 'pvt_dark_swing', 'tvp_double'),
    _Scenario(4, '질럿 러시 vs 스탠다드', 'pvt_proxy_gate', 'tvp_double'),
    _Scenario(5, '캐리어 vs 안티', 'pvt_carrier', 'tvp_anti_carrier'),
    _Scenario(6, '5게이트 푸시 vs 팩더블', 'pvt_trans_5gate_push', 'tvp_double'),
    _Scenario(7, '질럿 vs BBS', 'pvt_proxy_gate', 'tvp_bbs'),
    _Scenario(8, '리버 vs BBS', 'pvt_reaver_shuttle', 'tvp_bbs'),
    _Scenario(9, '확장 vs 마인트리플', 'pvt_1gate_expand', 'tvp_mine_triple'),
    _Scenario(10, '11업 8팩 vs 확장', 'pvt_1gate_expand', 'tvp_11up_8fac'),
    _Scenario(11, 'FD테란 vs 프로토스', 'pvt_1gate_expand', 'tvp_fd'),
  ];

  for (final sc in scenarios) {
    group('PvT S${sc.num}: ${sc.title}', () {
      final games = <_GameResult>[];

      for (int i = 1; i <= 10; i++) {
        test('경기 $i', () async {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: pEqual,
            awayPlayer: tEqual,
            map: mapBalance,
            getIntervalMs: () => 0,
            forcedHomeBuildId: sc.pBuild,
            forcedAwayBuildId: sc.tBuild,
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
        buf.writeln('# PvT S${sc.num}: ${sc.title}');
        buf.writeln('빌드: ${sc.pBuild} vs ${sc.tBuild}\n');

        for (int i = 0; i < games.length; i++) {
          final g = games[i];
          final winner = g.homeWin ? 'P 승리' : 'T 승리';
          buf.writeln('## 경기 ${i + 1} ($winner)');
          buf.writeln(
              '최종 병력: P ${g.homeArmy} / T ${g.awayArmy} | 자원: P ${g.homeRes} / T ${g.awayRes}');
          buf.writeln('```');
          for (final line in g.logs) {
            buf.writeln(line);
          }
          buf.writeln('```\n');
        }

        final dir = Directory('test/output');
        if (!dir.existsSync()) dir.createSync(recursive: true);
        File('test/output/pvt_s${sc.num}_10games.md')
            .writeAsStringSync(buf.toString());
      });
    });
  }
}

class _Scenario {
  final int num;
  final String title;
  final String pBuild;
  final String tBuild;

  const _Scenario(this.num, this.title, this.pBuild, this.tBuild);
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
