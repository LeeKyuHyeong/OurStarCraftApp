import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'tvt_verify_helper.dart';

/// 시나리오 정보
class _Scenario {
  final int num;
  final String build1;
  final String build2;
  final String title;
  const _Scenario(this.num, this.build1, this.build2, this.title);
}

const _scenarios = [
  _Scenario(1, 'tvt_cc_first', 'tvt_2fac_vulture', '배럭더블 vs 팩더블'),
  _Scenario(2, 'tvt_bbs', 'tvt_cc_first', 'BBS vs 노배럭더블'),
  _Scenario(3, 'tvt_wraith_cloak', 'tvt_cc_first', '레이스 vs 배럭더블'),
  _Scenario(4, 'tvt_5fac', 'tvt_1fac_expand', '5팩 vs 마인트리플'),
  _Scenario(5, 'tvt_bbs', 'tvt_wraith_cloak', 'BBS vs 테크'),
  _Scenario(6, 'tvt_1fac_push', 'tvt_wraith_cloak', '공격적 빌드 대결'),
  _Scenario(7, 'tvt_cc_first', 'tvt_1fac_expand', '배럭더블 vs 원팩확장'),
  _Scenario(8, 'tvt_2fac_vulture', 'tvt_1fac_expand', '투팩벌처 vs 원팩확장'),
  _Scenario(9, 'tvt_1fac_push', 'tvt_5fac', '원팩원스타 vs 5팩'),
  _Scenario(10, 'tvt_bbs', 'tvt_bbs', 'BBS 미러'),
  _Scenario(11, 'tvt_1fac_push', 'tvt_1fac_push', '원팩원스타 미러'),
  _Scenario(12, 'tvt_wraith_cloak', 'tvt_wraith_cloak', '레이스 미러'),
  _Scenario(13, 'tvt_5fac', 'tvt_5fac', '5팩 미러'),
  _Scenario(14, 'tvt_cc_first', 'tvt_cc_first', '배럭더블 미러'),
  _Scenario(15, 'tvt_2fac_vulture', 'tvt_2fac_vulture', '투팩벌처 미러'),
  _Scenario(16, 'tvt_1fac_expand', 'tvt_1fac_expand', '원팩확장 미러'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (final scenario in _scenarios) {
    group('TvT S${scenario.num}: ${scenario.title}', () {
      test('10경기 로그 출력', () async {
        final buf = StringBuffer();
        buf.writeln('# TvT S${scenario.num}: ${scenario.title}');
        buf.writeln('빌드: ${scenario.build1} vs ${scenario.build2}');
        buf.writeln('');

        for (int i = 1; i <= 10; i++) {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: homeEqual,
            awayPlayer: awayEqual,
            map: mapBalance,
            getIntervalMs: () => 0,
            forcedHomeBuildId: scenario.build1,
            forcedAwayBuildId: scenario.build2,
          );

          SimulationState? state;
          await for (final s in stream) {
            state = s;
          }

          if (state == null) {
            buf.writeln('## 경기 $i (실패)');
            buf.writeln('');
            continue;
          }

          final winner = state.homeWin == true ? '홈 승리' : '어웨이 승리';
          buf.writeln('## 경기 $i ($winner)');
          buf.writeln(
            '최종 병력: 홈 ${state.homeArmy} / 어웨이 ${state.awayArmy} '
            '| 자원: 홈 ${state.homeResources} / 어웨이 ${state.awayResources}',
          );
          buf.writeln('```');
          for (final entry in state.battleLogEntries) {
            final tag = switch (entry.owner) {
              LogOwner.home => '[홈]',
              LogOwner.away => '[어웨이]',
              LogOwner.clash => '[교전]',
              LogOwner.system => '[해설]',
            };
            buf.writeln('$tag ${entry.text}');
          }
          buf.writeln('```');
          buf.writeln('');
        }

        final file = File('test/output/tvt_s${scenario.num}_10games.md');
        file.writeAsStringSync(buf.toString());
        print('Written: ${file.path}');
      });
    });
  }
}
