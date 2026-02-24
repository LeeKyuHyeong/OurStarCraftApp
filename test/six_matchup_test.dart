import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final service = MatchSimulationService();

  const testMap = GameMap(
    id: 'test_fighting_spirit',
    name: '파이팅 스피릿',
    rushDistance: 6,
    resources: 5,
    terrainComplexity: 5,
    airAccessibility: 6,
    centerImportance: 5,
  );

  Player makePlayer(String id, String name, int raceIndex) {
    return Player(
      id: id,
      name: name,
      raceIndex: raceIndex,
      stats: const PlayerStats(
        sense: 680,
        control: 700,
        attack: 660,
        harass: 640,
        strategy: 670,
        macro: 690,
        defense: 680,
        scout: 650,
      ),
      levelValue: 7,
      condition: 100,
    );
  }

  Future<void> runMatch({
    required String label,
    required Player home,
    required Player away,
    required String homeRaceLabel,
    required String awayRaceLabel,
  }) async {
    final stream = service.simulateMatchWithLog(
      homePlayer: home,
      awayPlayer: away,
      map: testMap,
      getIntervalMs: () => 0,
    );

    SimulationState? lastState;
    await for (final state in stream) {
      lastState = state;
    }

    if (lastState != null) {
      final winner = lastState.homeWin == true ? homeRaceLabel : awayRaceLabel;
      print('');
      print('### $label 경기결과');
      print('');
      print('> 결과: $winner 승리 | 병력 $homeRaceLabel:${lastState.homeArmy} $awayRaceLabel:${lastState.awayArmy} | 자원 $homeRaceLabel:${lastState.homeResources} $awayRaceLabel:${lastState.awayResources}');
      print('');
      print('```');
      for (final entry in lastState.battleLogEntries) {
        final prefix = switch (entry.owner) {
          LogOwner.home => '[$homeRaceLabel]',
          LogOwner.away => '[$awayRaceLabel]',
          LogOwner.system => '[해설]',
          LogOwner.clash => '[전투]',
        };
        print('$prefix ${entry.text}');
      }
      print('```');
      print('');
    }
  }

  test('TvT 경기', () async {
    await runMatch(
      label: 'TvT',
      home: makePlayer('tvt_home', 'Home', 0),
      away: makePlayer('tvt_away', 'Away', 0),
      homeRaceLabel: 'H',
      awayRaceLabel: 'A',
    );
  });

  test('ZvZ 경기', () async {
    await runMatch(
      label: 'ZvZ',
      home: makePlayer('zvz_home', 'Home', 1),
      away: makePlayer('zvz_away', 'Away', 1),
      homeRaceLabel: 'H',
      awayRaceLabel: 'A',
    );
  });

  test('PvP 경기', () async {
    await runMatch(
      label: 'PvP',
      home: makePlayer('pvp_home', 'Home', 2),
      away: makePlayer('pvp_away', 'Away', 2),
      homeRaceLabel: 'H',
      awayRaceLabel: 'A',
    );
  });

  test('TvZ 경기', () async {
    await runMatch(
      label: 'TvZ',
      home: makePlayer('tvz_home', 'Home', 0),
      away: makePlayer('tvz_away', 'Away', 1),
      homeRaceLabel: 'T',
      awayRaceLabel: 'Z',
    );
  });

  test('ZvP 경기', () async {
    await runMatch(
      label: 'ZvP',
      home: makePlayer('zvp_home', 'Home', 1),
      away: makePlayer('zvp_away', 'Away', 2),
      homeRaceLabel: 'Z',
      awayRaceLabel: 'P',
    );
  });

  test('PvT 경기', () async {
    await runMatch(
      label: 'PvT',
      home: makePlayer('pvt_home', 'Home', 2),
      away: makePlayer('pvt_away', 'Away', 0),
      homeRaceLabel: 'P',
      awayRaceLabel: 'T',
    );
  });
}
