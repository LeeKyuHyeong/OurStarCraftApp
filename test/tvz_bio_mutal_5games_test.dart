import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  test('바이오 vs 뮤탈 5경기 결과 → tvz.md', () async {
    final homePlayer = Player(
      id: 'terran_test',
      name: '이영호',
      raceIndex: 0,
      stats: const PlayerStats(
        sense: 680, control: 700, attack: 720, harass: 690,
        strategy: 670, macro: 690, defense: 680, scout: 650,
      ),
      levelValue: 7,
      condition: 100,
    );

    final awayPlayer = Player(
      id: 'zerg_test',
      name: '이제동',
      raceIndex: 1,
      stats: const PlayerStats(
        sense: 690, control: 710, attack: 670, harass: 730,
        strategy: 660, macro: 700, defense: 650, scout: 670,
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

    final buffer = StringBuffer();
    buffer.writeln('# TvZ 바이오 vs 뮤탈 - 5경기 전체 로그');
    buffer.writeln('');
    buffer.writeln('- 홈: 이영호 (Terran) | 빌드: tvz_sk');
    buffer.writeln('- 어웨이: 이제동 (Zerg) | 빌드: zvt_2hatch_mutal');
    buffer.writeln('- 맵: 파이팅 스피릿');
    buffer.writeln('');

    int homeWins = 0;
    int awayWins = 0;

    for (int i = 0; i < 5; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_sk',
        forcedAwayBuildId: 'zvt_2hatch_mutal',
      );

      SimulationState? lastState;
      await for (final state in stream) {
        lastState = state;
      }

      expect(lastState, isNotNull);
      expect(lastState!.isFinished, true);

      final won = lastState.homeWin == true;
      if (won) {
        homeWins++;
      } else {
        awayWins++;
      }

      buffer.writeln('---');
      buffer.writeln('');
      buffer.writeln('## 제${i + 1}경기');
      buffer.writeln('');

      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[T]',
          LogOwner.away => '[Z]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        buffer.writeln('$prefix ${entry.text}');
      }

      buffer.writeln('');
      buffer.writeln('> **병력** T ${lastState.homeArmy} vs Z ${lastState.awayArmy}  ');
      buffer.writeln('> **자원** T ${lastState.homeResources} vs Z ${lastState.awayResources}  ');
      buffer.writeln('> **결과: ${won ? '이영호 (T) 승리' : '이제동 (Z) 승리'}**');
      buffer.writeln('');
    }

    buffer.writeln('---');
    buffer.writeln('');
    buffer.writeln('## 종합 전적');
    buffer.writeln('');
    buffer.writeln('| 선수 | 승 | 패 |');
    buffer.writeln('|------|----|----|');
    buffer.writeln('| 이영호 (T) | $homeWins | $awayWins |');
    buffer.writeln('| 이제동 (Z) | $awayWins | $homeWins |');

    final file = File('tvz.md');
    file.writeAsStringSync(buffer.toString());
    print('tvz.md 저장 완료 (${buffer.length} chars)');
    print('전적: 이영호 $homeWins - $awayWins 이제동');
  });
}
