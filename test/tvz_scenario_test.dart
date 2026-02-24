import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'package:mystar/core/constants/scenario_scripts.dart';
import 'dart:math';

void main() {
  final homePlayer = Player(
    id: 'terran_test',
    name: '이영호',
    raceIndex: 0, // Terran
    stats: const PlayerStats(
      sense: 680,
      control: 700,
      attack: 720,
      harass: 690,
      strategy: 670,
      macro: 690,
      defense: 680,
      scout: 650,
    ),
    levelValue: 7,
    condition: 100,
  );

  final awayPlayer = Player(
    id: 'zerg_test',
    name: '이제동',
    raceIndex: 1, // Zerg
    stats: const PlayerStats(
      sense: 690,
      control: 710,
      attack: 670,
      harass: 730,
      strategy: 660,
      macro: 700,
      defense: 650,
      scout: 670,
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

  group('시나리오 스크립트 선택', () {
    test('TvZ 바이오 vs 뮤탈 스크립트 매칭', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'TvZ',
        homeBuildType: BuildType.tvzSKTerran,
        awayBuildType: BuildType.zvt2HatchMutal,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNotNull);
      expect(script!.id, 'tvz_bio_vs_mutal');
    });

    test('TvZ 메카닉 vs 럴커 스크립트 매칭', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'TvZ',
        homeBuildType: BuildType.tvz3FactoryGoliath,
        awayBuildType: BuildType.zvt2HatchLurker,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNotNull);
      expect(script!.id, 'tvz_mech_vs_lurker');
    });

    test('TvZ 치즈 vs 스탠다드 스크립트 매칭', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'TvZ',
        homeBuildType: BuildType.tvzBunkerRush,
        awayBuildType: BuildType.zvt12Pool,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNotNull);
      expect(script!.id, 'tvz_cheese_vs_standard');
    });

    test('TvZ 111 vs 매크로 스크립트 매칭', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'TvZ',
        homeBuildType: BuildType.tvz111,
        awayBuildType: BuildType.zvt3HatchNoPool,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNotNull);
      expect(script!.id, 'tvz_111_vs_macro');
    });

    test('ZvT 역방향 매칭 (저그가 홈)', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'ZvT',
        homeBuildType: BuildType.zvt2HatchMutal,
        awayBuildType: BuildType.tvzSKTerran,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNotNull);
      expect(script!.id, 'tvz_bio_vs_mutal');
      // 역방향이므로 reversed = true
      final reversed = ScenarioScriptData.isReversed(
        script: script,
        homeBuildType: BuildType.zvt2HatchMutal,
      );
      expect(reversed, true);
    });

    test('매칭 안되는 빌드 조합은 null', () {
      final script = ScenarioScriptData.selectScript(
        matchup: 'PvZ',
        homeBuildType: BuildType.tvzSKTerran,
        awayBuildType: BuildType.zvt2HatchMutal,
        map: testMap,
        random: Random(42),
      );
      expect(script, isNull);
    });
  });

  group('시나리오 스크립트 시뮬레이션', () {
    test('바이오 vs 뮤탈 - 전체 경기 실행', () async {
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
      expect(lastState.homeWin, isNotNull);
      expect(lastState.battleLogEntries.length, greaterThan(10));

      _printMatchLog('바이오 vs 뮤탈', homePlayer, awayPlayer, testMap, lastState);
    });

    test('메카닉 vs 럴커 - 전체 경기 실행', () async {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_3fac_goliath',
        forcedAwayBuildId: 'zvt_2hatch_lurker',
      );

      SimulationState? lastState;
      await for (final state in stream) {
        lastState = state;
      }

      expect(lastState, isNotNull);
      expect(lastState!.isFinished, true);

      _printMatchLog('메카닉 vs 럴커', homePlayer, awayPlayer, testMap, lastState);
    });

    test('치즈 vs 스탠다드 - 전체 경기 실행', () async {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_bunker',
        forcedAwayBuildId: 'zvt_12pool',
      );

      SimulationState? lastState;
      await for (final state in stream) {
        lastState = state;
      }

      expect(lastState, isNotNull);
      expect(lastState!.isFinished, true);

      _printMatchLog('치즈 vs 스탠다드', homePlayer, awayPlayer, testMap, lastState);
    });

    test('111 vs 매크로 - 전체 경기 실행', () async {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
        forcedHomeBuildId: 'tvz_111',
        forcedAwayBuildId: 'zvt_3hatch_nopool',
      );

      SimulationState? lastState;
      await for (final state in stream) {
        lastState = state;
      }

      expect(lastState, isNotNull);
      expect(lastState!.isFinished, true);

      _printMatchLog('111 vs 매크로', homePlayer, awayPlayer, testMap, lastState);
    });
  });

  group('다양성 검증', () {
    test('같은 빌드 조합 5회 실행 시 로그 다양성', () async {
      final logs = <List<String>>[];

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

        if (lastState != null) {
          logs.add(lastState.battleLogEntries.map((e) => e.text).toList());
        }
      }

      expect(logs.length, 5);

      // 5회 중 최소 2개는 서로 다른 로그여야 함
      final uniqueLogs = logs.map((l) => l.join('|')).toSet();
      print('다양성: ${uniqueLogs.length}/5 고유 로그');
      expect(uniqueLogs.length, greaterThanOrEqualTo(2));
    });
  });

  group('비TvZ 매치업 영향 없음', () {
    test('PvZ 경기는 기존 시스템 사용', () async {
      final protossPlayer = Player(
        id: 'protoss_test',
        name: '김택용',
        raceIndex: 2, // Protoss
        stats: const PlayerStats(
          sense: 680, control: 700, attack: 660, harass: 640,
          strategy: 670, macro: 690, defense: 680, scout: 650,
        ),
        levelValue: 7,
        condition: 100,
      );

      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: protossPlayer,
        awayPlayer: awayPlayer,
        map: testMap,
        getIntervalMs: () => 0,
      );

      SimulationState? lastState;
      await for (final state in stream) {
        lastState = state;
      }

      expect(lastState, isNotNull);
      expect(lastState!.isFinished, true);
    });
  });
}

void _printMatchLog(String title, Player home, Player away, GameMap map, SimulationState state) {
  print('');
  print('========================================');
  print('  시나리오 스크립트: $title');
  print('  ${home.name} (T) vs ${away.name} (Z)');
  print('  맵: ${map.name}');
  print('========================================');
  print('');

  for (final entry in state.battleLogEntries) {
    final prefix = switch (entry.owner) {
      LogOwner.home => '[T]',
      LogOwner.away => '[Z]',
      LogOwner.system => '[해설]',
      LogOwner.clash => '[전투]',
    };
    print('$prefix ${entry.text}');
  }

  print('');
  print('========================================');
  print('  최종 병력: T ${state.homeArmy} vs Z ${state.awayArmy}');
  print('  최종 자원: T ${state.homeResources} vs Z ${state.awayResources}');
  print('  결과: ${state.homeWin == true ? '${home.name} (T) 승리!' : '${away.name} (Z) 승리!'}');
  print('========================================');
}
