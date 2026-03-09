import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

import 'tvz_verify_helper.dart';

@Timeout(Duration(minutes: 30))
void main() {
  final scenarios = [
    _Scenario(1, 'tvz_sk', 'zvt_2hatch_mutal', '바이오 vs 뮤탈'),
    _Scenario(2, 'tvz_3fac_goliath', 'zvt_2hatch_lurker', '메카닉 vs 럴커'),
    _Scenario(3, 'tvz_bunker', 'zvt_12pool', '벙커 vs 스탠다드'),
    _Scenario(4, 'tvz_111', 'zvt_3hatch_nopool', '111 vs 3해처리'),
    _Scenario(5, 'tvz_2star_wraith', 'zvt_2hatch_mutal', '레이스 vs 뮤탈'),
    _Scenario(6, 'tvz_bunker', 'zvt_4pool', '벙커 vs 4풀'),
    _Scenario(7, 'tvz_sk', 'zvt_9pool', '스탠다드 vs 9풀'),
    _Scenario(8, 'tvz_valkyrie', 'zvt_2hatch_mutal', '발키리 vs 뮤탈'),
    _Scenario(9, 'tvz_sk', 'zvt_3hatch_nopool', '배럭더블 vs 3해처리'),
    _Scenario(10, 'tvz_sk', 'zvt_1hatch_allin', '스탠다드 vs 원해처리 올인'),
    _Scenario(11, 'tvz_3fac_goliath', 'zvt_trans_ultra_hive', '메카닉 vs 하이브'),
  ];

  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (final sc in scenarios) {
    test('TvZ S${sc.number}: ${sc.title} (10 games)', () async {
      final buf = StringBuffer();
      buf.writeln('# TvZ S${sc.number}: ${sc.title}');
      buf.writeln('빌드: ${sc.tBuild} vs ${sc.zBuild}');
      buf.writeln();

      for (int g = 1; g <= 10; g++) {
        final service = MatchSimulationService();
        final stream = service.simulateMatchWithLog(
          homePlayer: tEqual,
          awayPlayer: zEqual,
          map: mapBalance,
          getIntervalMs: () => 0,
          forcedHomeBuildId: sc.tBuild,
          forcedAwayBuildId: sc.zBuild,
        );

        SimulationState? state;
        await for (final s in stream) {
          state = s;
        }

        final winner = state!.homeWin == true ? 'T 승리' : 'Z 승리';
        buf.writeln('## 경기 $g ($winner)');
        buf.writeln(
          '최종 병력: T ${state.homeArmy} / Z ${state.awayArmy} '
          '| 자원: T ${state.homeResources} / Z ${state.awayResources}',
        );
        buf.writeln('```');
        for (final entry in state.battleLogEntries) {
          final tag = _ownerTag(entry.owner);
          buf.writeln('$tag ${entry.text}');
        }
        buf.writeln('```');
        buf.writeln();
      }

      File('test/output/tvz_s${sc.number}_10games.md')
          .writeAsStringSync(buf.toString());
    });
  }
}

String _ownerTag(LogOwner owner) {
  switch (owner) {
    case LogOwner.home:
      return '[홈]';
    case LogOwner.away:
      return '[어웨이]';
    case LogOwner.clash:
      return '[교전]';
    case LogOwner.system:
      return '[해설]';
  }
}

class _Scenario {
  final int number;
  final String tBuild;
  final String zBuild;
  final String title;
  const _Scenario(this.number, this.tBuild, this.zBuild, this.title);
}
