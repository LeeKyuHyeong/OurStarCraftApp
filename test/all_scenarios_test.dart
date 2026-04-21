/// 전 종족전 통합 시나리오 테스트 (3경기 로그 + 1000경기 통계 + 분기 분포)
///
/// 사용법:
///   flutter test test/all_scenarios_test.dart                           # 전체
///   flutter test --name "ZvZ" test/all_scenarios_test.dart              # ZvZ 전체
///   flutter test --name "TvZ" test/all_scenarios_test.dart              # TvZ 전체
///   flutter test --name "ZvZ.*4pool_mirror" test/all_scenarios_test.dart # 특정 시나리오
///   flutter test --name "1000" test/all_scenarios_test.dart             # 전체 1000경기만
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// ── 종족전 설정 ──

class MatchupConfig {
  final String id;            // 'tvt', 'tvz', ...
  final String label;         // 'TvT', 'TvZ', ...
  final Player homePlayer;
  final Player awayPlayer;
  final GameMap map;
  final String homeTag;       // 3경기 로그 owner 태그
  final String awayTag;
  final String homeLabel;     // 1000경기 통계 label
  final String awayLabel;
  final List<_Scenario> scenarios;

  const MatchupConfig({
    required this.id,
    required this.label,
    required this.homePlayer,
    required this.awayPlayer,
    required this.map,
    required this.homeTag,
    required this.awayTag,
    required this.homeLabel,
    required this.awayLabel,
    required this.scenarios,
  });
}

class _Scenario {
  final String homeBuild;
  final String awayBuild;
  final String label;
  const _Scenario(this.homeBuild, this.awayBuild, this.label);
}

Player _player(String id, String name, int raceIndex) => Player(
  id: id, name: name, raceIndex: raceIndex,
  stats: const PlayerStats(
    sense: 700, control: 700, attack: 700, harass: 700,
    strategy: 700, macro: 700, defense: 700, scout: 700,
  ),
  levelValue: 7, condition: 100,
);

const _testMap = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

const _testMapWithMatchup = GameMap(
  id: 'test_fighting_spirit', name: '파이팅 스피릿',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
  matchup: RaceMatchup(tvzTerranWinRate: 50, zvpZergWinRate: 50, pvtProtossWinRate: 50),
);

/// 미러 매치업용 시나리오 생성 (i ≤ j 조합)
List<_Scenario> _mirrorScenarios(List<String> builds, String prefix) {
  final scenarios = <_Scenario>[];
  for (int i = 0; i < builds.length; i++) {
    for (int j = i; j < builds.length; j++) {
      final hLabel = builds[i].replaceFirst('${prefix}_', '');
      final aLabel = builds[j].replaceFirst('${prefix}_', '');
      scenarios.add(_Scenario(
        builds[i], builds[j],
        i == j ? '${hLabel}_mirror' : '${hLabel}_vs_$aLabel',
      ));
    }
  }
  return scenarios;
}

/// 크로스 매치업용 시나리오 생성 (homeBuilds × awayBuilds)
List<_Scenario> _crossScenarios(
  List<String> homeBuilds, List<String> awayBuilds,
  String homePrefix, String awayPrefix,
) {
  final scenarios = <_Scenario>[];
  for (final h in homeBuilds) {
    for (final a in awayBuilds) {
      final hLabel = h.replaceFirst('${homePrefix}_trans_', '').replaceFirst('${homePrefix}_', '');
      final aLabel = a.replaceFirst('${awayPrefix}_trans_', '').replaceFirst('${awayPrefix}_', '');
      scenarios.add(_Scenario(h, a, '${hLabel}_vs_$aLabel'));
    }
  }
  return scenarios;
}

// ── 6개 종족전 설정 ──

final _configs = <MatchupConfig>[
  // TvT (9빌드, 45시나리오)
  MatchupConfig(
    id: 'tvt', label: 'TvT',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('terran_away', '임요환', 0),
    map: _testMap,
    homeTag: '[홈]  ', awayTag: '[어웨이]',
    homeLabel: '홈', awayLabel: '어웨이',
    scenarios: _mirrorScenarios([
      'tvt_bbs', 'tvt_1fac_1star', 'tvt_2fac_push',
      'tvt_2star', 'tvt_1bar_double', 'tvt_1fac_double',
      'tvt_nobar_double', 'tvt_fd_rush',
    ], 'tvt'),
  ),

  // TvZ (7T × 7Z = 49시나리오)
  MatchupConfig(
    id: 'tvz', label: 'TvZ',
    homePlayer: _player('terran_home', '이영호', 0),
    awayPlayer: _player('zerg_away', '이재동', 1),
    map: _testMapWithMatchup,
    homeTag: '[T]  ', awayTag: '[Z]  ',
    homeLabel: 'T', awayLabel: 'Z',
    scenarios: _crossScenarios(
      ['tvz_nobar_double', 'tvz_bar_double', 'tvz_111', 'tvz_2bar_academy',
       'tvz_fac_double', 'tvz_2star', 'tvz_bbs'],
      ['zvt_trans_2hatch_mutal', 'zvt_4pool', 'zvt_trans_530_mutal',
       'zvt_trans_lurker_defiler', 'zvt_trans_mutal_lurker',
       'zvt_trans_mutal_ultra', 'zvt_trans_ultra_hive'],
      'tvz', 'zvt',
    ),
  ),

  // PvT (9P × 7T = 63시나리오)
  MatchupConfig(
    id: 'pvt', label: 'PvT',
    homePlayer: _player('protoss_home', '김택용', 2),
    awayPlayer: _player('terran_away', '이영호', 0),
    map: _testMap,
    homeTag: '[홈]  ', awayTag: '[어웨이]',
    homeLabel: '홈', awayLabel: '어웨이',
    scenarios: _crossScenarios(
      ['pvt_2gate_open', 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier',
       'pvt_trans_5gate_push', 'pvt_dark_swing', 'pvt_proxy_gate',
       'pvt_trans_reaver_arbiter', 'pvt_trans_reaver_carrier', 'pvt_trans_reaver_push'],
      ['tvp_bbs', 'tvp_trans_tank_defense', 'tvp_trans_timing_push',
       'tvp_trans_anti_carrier', 'tvp_trans_bio_mech',
       'tvp_trans_upgrade'],
      'pvt', 'tvp',
    ),
  ),

  // PvP (8빌드, 36시나리오)
  MatchupConfig(
    id: 'pvp', label: 'PvP',
    homePlayer: _player('protoss_home', '홍진호', 2),
    awayPlayer: _player('protoss_away', '이제동', 2),
    map: _testMap,
    homeTag: '[홈]  ', awayTag: '[어웨이]',
    homeLabel: '홈', awayLabel: '어웨이',
    scenarios: _mirrorScenarios([
      'pvp_2gate_dragoon', 'pvp_1gate_multi', 'pvp_1gate_robo',
      'pvp_4gate_dragoon', 'pvp_2gate_reaver', 'pvp_3gate_speedzealot',
      'pvp_dark_allin', 'pvp_zealot_rush',
    ], 'pvp'),
  ),

  // ZvP (9Z × 7P = 63시나리오)
  MatchupConfig(
    id: 'zvp', label: 'ZvP',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('protoss_away', '김택용', 2),
    map: _testMap,
    homeTag: '[홈]  ', awayTag: '[어웨이]',
    homeLabel: '홈', awayLabel: '어웨이',
    scenarios: _crossScenarios(
      ['zvp_4pool', 'zvp_5drone', 'zvp_trans_5hatch_hydra',
       'zvp_trans_973_hydra', 'zvp_trans_hive_defiler', 'zvp_trans_hydra_lurker',
       'zvp_trans_mukerji', 'zvp_trans_mutal_hydra', 'zvp_trans_yabarwi'],
      ['pvz_cannon_rush', 'pvz_trans_corsair', 'pvz_2star_corsair',
       'pvz_trans_archon', 'pvz_trans_forge_expand', 'pvz_trans_dragoon_push',
       'pvz_proxy_gate'],
      'zvp', 'pvz',
    ),
  ),

  // ZvZ (6빌드, 21시나리오)
  MatchupConfig(
    id: 'zvz', label: 'ZvZ',
    homePlayer: _player('zerg_home', '이재동', 1),
    awayPlayer: _player('zerg_away', '박성준', 1),
    map: _testMap,
    homeTag: '[홈]  ', awayTag: '[어웨이]',
    homeLabel: '홈', awayLabel: '어웨이',
    scenarios: _mirrorScenarios([
      'zvz_4pool', 'zvz_9pool_speed', 'zvz_9pool_lair', 'zvz_9overpool',
      'zvz_12pool', 'zvz_12hatch',
    ], 'zvz'),
  ),
];

void main() {
  for (final config in _configs) {
    group(config.label, () {
      Future<void> run3Games(_Scenario s) async {
        final service = MatchSimulationService();
        final buf = StringBuffer();
        buf.writeln('# ${config.label} ${s.label} 3경기 로그');
        buf.writeln();
        buf.writeln('**빌드**: ${s.homeBuild} vs ${s.awayBuild}');
        buf.writeln('**선수**: ${config.homePlayer.name}(홈) vs ${config.awayPlayer.name}(어웨이) | 동일 능력치 700');
        buf.writeln();

        int homeWins = 0;
        for (int game = 1; game <= 3; game++) {
          final stream = service.simulateMatchWithLog(
            homePlayer: config.homePlayer, awayPlayer: config.awayPlayer,
            map: config.map, getIntervalMs: () => 0,
            forcedHomeBuildId: s.homeBuild, forcedAwayBuildId: s.awayBuild,
          );
          SimulationState? state;
          await for (final st in stream) { state = st; }
          final isHomeWin = state!.homeWin == true;
          if (isHomeWin) homeWins++;
          final winner = isHomeWin
              ? '홈(${config.homePlayer.name})'
              : '어웨이(${config.awayPlayer.name})';
          buf.writeln('---');
          buf.writeln('## Game $game | $winner 승 | 병력: ${state.homeArmy} vs ${state.awayArmy}');
          if (state.selectedBranchIds.isNotEmpty) {
            buf.writeln();
            buf.writeln('**분기 체인**: ${state.selectedBranchIds.join(" → ")}');
          }
          buf.writeln();
          buf.writeln('```');
          for (int i = 0; i < state.battleLogEntries.length; i++) {
            final e = state.battleLogEntries[i];
            final ownerTag = e.owner == LogOwner.home
                ? config.homeTag
                : e.owner == LogOwner.away
                    ? config.awayTag
                    : '[해설]';
            buf.writeln('${(i + 1).toString().padLeft(2)}. $ownerTag ${e.text}');
          }
          buf.writeln('```');
          buf.writeln();
        }
        buf.writeln('---');
        buf.writeln('## 종합: ${config.homeLabel} $homeWins승 / ${config.awayLabel} ${3 - homeWins}승');

        final outDir = Directory('test/output/${config.id}');
        if (!outDir.existsSync()) outDir.createSync(recursive: true);
        File('test/output/${config.id}/${s.label}_3games.md').writeAsStringSync(buf.toString());
      }

      Future<void> run1000Stats(_Scenario s) async {
        const totalGames = 1000;

        // 정방향 (homeBuild=홈, awayBuild=어웨이)
        int fwdHomeWins = 0;
        int earlyEnd = 0, midEnd = 0, lateEnd = 0;
        int endDecisive = 0, endArmy = 0, endMaxLines = 0;
        int resOver1000Count = 0;
        int homeMaxRes = 0, awayMaxRes = 0;
        Set<String> uniqueTexts = {};
        final branchCounts = <String, int>{};
        final branchDescMap = <String, String>{};

        for (int i = 0; i < totalGames; i++) {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: config.homePlayer, awayPlayer: config.awayPlayer,
            map: config.map, getIntervalMs: () => 0,
            forcedHomeBuildId: s.homeBuild, forcedAwayBuildId: s.awayBuild,
          );
          SimulationState? state;
          await for (final st in stream) { state = st; }
          if (state == null) continue;
          if (state.homeWin == true) fwdHomeWins++;
          final logLen = state.battleLogEntries.length;
          if (state.homeResources > homeMaxRes) homeMaxRes = state.homeResources;
          if (state.awayResources > awayMaxRes) awayMaxRes = state.awayResources;
          if (state.homeResources > 1000 || state.awayResources > 1000) resOver1000Count++;
          uniqueTexts.add(state.battleLogEntries.map((e) => e.text).join('\n'));
          if (logLen <= 28) earlyEnd++;
          else if (logLen <= 42) midEnd++;
          else lateEnd++;
          switch (state.endReason) {
            case 'decisive': endDecisive++; break;
            case 'army': endArmy++; break;
            case 'maxLines': endMaxLines++; break;
          }
          for (final bid in state.selectedBranchIds) {
            branchCounts[bid] = (branchCounts[bid] ?? 0) + 1;
          }
          state.branchDescriptions.forEach((id, desc) {
            branchDescMap[id] = desc;
          });
        }

        // 역방향 (빌드 스왑: awayBuild=홈, homeBuild=어웨이)
        int revHomeWins = 0;
        for (int i = 0; i < totalGames; i++) {
          final service = MatchSimulationService();
          final stream = service.simulateMatchWithLog(
            homePlayer: config.awayPlayer, awayPlayer: config.homePlayer,
            map: config.map, getIntervalMs: () => 0,
            forcedHomeBuildId: s.awayBuild, forcedAwayBuildId: s.homeBuild,
          );
          SimulationState? state;
          await for (final st in stream) { state = st; }
          if (state?.homeWin == true) revHomeWins++;
        }

        final fwdHomeRate = fwdHomeWins / totalGames * 100;
        final revP1Rate = (totalGames - revHomeWins) / totalGames * 100;
        final bias = (fwdHomeRate - revP1Rate).abs();
        final resOver1000Pct = (resOver1000Count / totalGames * 100).toStringAsFixed(1);

        final buf = StringBuffer();
        buf.writeln('# ${config.label} ${s.label} 1000경기 통계');
        buf.writeln();
        buf.writeln('| 항목 | 값 |');
        buf.writeln('|------|-----|');
        buf.writeln('| 총 경기 | $totalGames |');
        buf.writeln('| ${config.homeLabel} 승률 (정방향) | ${fwdHomeRate.toStringAsFixed(1)}% ($fwdHomeWins승) |');
        buf.writeln('| ${config.awayLabel} 승률 (정방향) | ${(100 - fwdHomeRate).toStringAsFixed(1)}% (${totalGames - fwdHomeWins}승) |');
        buf.writeln('| 역방향 P1 승률 | ${revP1Rate.toStringAsFixed(1)}% |');
        buf.writeln('| 반전 편향 | ${bias.toStringAsFixed(1)}%p |');
        buf.writeln('| 최대 자원 | ${config.homeLabel} $homeMaxRes / ${config.awayLabel} $awayMaxRes |');
        buf.writeln('| 자원 1000 초과 경기 | $resOver1000Count ($resOver1000Pct%) |');
        buf.writeln('| 고유 로그 수 | ${uniqueTexts.length} / $totalGames |');
        buf.writeln();
        buf.writeln('## 종료 원인 분포');
        buf.writeln();
        buf.writeln('| 종료 원인 | 경기 수 | 비율 |');
        buf.writeln('|-----------|---------|------|');
        buf.writeln('| decisive (시나리오) | $endDecisive | ${(endDecisive / totalGames * 100).toStringAsFixed(1)}% |');
        buf.writeln('| army (병력 판정) | $endArmy | ${(endArmy / totalGames * 100).toStringAsFixed(1)}% |');
        buf.writeln('| maxLines (200줄) | $endMaxLines | ${(endMaxLines / totalGames * 100).toStringAsFixed(1)}% |');
        buf.writeln();
        buf.writeln('## 종료 시점 분포');
        buf.writeln();
        buf.writeln('| 시점 | 경기 수 | 비율 |');
        buf.writeln('|------|---------|------|');
        buf.writeln('| 초반 (~28줄) | $earlyEnd | ${(earlyEnd / totalGames * 100).toStringAsFixed(1)}% |');
        buf.writeln('| 중반 (29~42줄) | $midEnd | ${(midEnd / totalGames * 100).toStringAsFixed(1)}% |');
        buf.writeln('| 후반 (43줄~) | $lateEnd | ${(lateEnd / totalGames * 100).toStringAsFixed(1)}% |');

        if (branchCounts.isNotEmpty) {
          buf.writeln();
          buf.writeln('## 분기 분포');
          buf.writeln();
          buf.writeln('| 분기 ID | 분기 설명 | 발동 | 비율 |');
          buf.writeln('|---------|----------|------|------|');
          final sorted = branchCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          for (final e in sorted) {
            final desc = branchDescMap[e.key] ?? '';
            buf.writeln('| ${e.key} | $desc | ${e.value} | ${(e.value / totalGames * 100).toStringAsFixed(1)}% |');
          }
        }

        final outDir = Directory('test/output/${config.id}');
        if (!outDir.existsSync()) outDir.createSync(recursive: true);
        File('test/output/${config.id}/${s.label}_1000stats.md').writeAsStringSync(buf.toString());
        print('${config.label} ${s.label}: 승률${fwdHomeRate.toStringAsFixed(1)}% 반전${bias.toStringAsFixed(1)}%p | decisive${(endDecisive / 10).toStringAsFixed(0)} army${(endArmy / 10).toStringAsFixed(0)} max${(endMaxLines / 10).toStringAsFixed(0)} | 고유${uniqueTexts.length} | >1000:$resOver1000Count');
      }

      for (final s in config.scenarios) {
        test('${s.label} 3경기', () => run3Games(s));
        test('${s.label} 1000경기', () => run1000Stats(s),
            timeout: const Timeout(Duration(minutes: 30)));
      }
    });
  }
}
