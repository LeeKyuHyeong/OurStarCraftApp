// 클래시 이벤트 분석 스크립트
// 각 종족전별 이벤트 풀 구성 + 가중치 선택 시뮬레이션
// 실행: flutter test test/clash_analysis_test.dart --reporter expanded
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/core/constants/build_orders.dart';
import 'package:mystar/domain/models/models.dart';

// MatchSimulationService._selectWeightedEvent 로직 복제
int _getStatValue(PlayerStats stats, String? statName) {
  switch (statName) {
    case 'sense':
      return stats.sense;
    case 'control':
      return stats.control;
    case 'attack':
      return stats.attack;
    case 'harass':
      return stats.harass;
    case 'strategy':
      return stats.strategy;
    case 'macro':
      return stats.macro;
    case 'defense':
      return stats.defense;
    case 'scout':
      return stats.scout;
    default:
      return 500;
  }
}

ClashEvent _selectWeightedEvent({
  required List<ClashEvent> events,
  required PlayerStats attackerStats,
  required PlayerStats defenderStats,
  required GamePhase gamePhase,
  required String matchup,
  required Random random,
}) {
  if (events.isEmpty) throw StateError('Events list cannot be empty');

  final weightedEvents = <MapEntry<ClashEvent, double>>[];

  for (final event in events) {
    double weight = 1.0;
    if (event.favorsStat != null) {
      final isDefenderFavored = event.attackerArmy < event.defenderArmy;
      final relevantStats = isDefenderFavored ? defenderStats : attackerStats;
      final stat = _getStatValue(relevantStats, event.favorsStat);
      if (stat > 600) {
        weight *= 1.0 + (stat - 600) / 800;
      } else if (stat < 500) {
        weight *= 0.7 + (stat / 1000);
      }
      final phaseWeight = StatWeights.getCombinedWeight(
          event.favorsStat!, gamePhase, matchup);
      weight *= (0.5 + phaseWeight / 2);
    }
    weightedEvents.add(MapEntry(event, weight.clamp(0.3, 2.0)));
  }

  // 과다선택 방지: 개별 이벤트가 전체의 4.5%를 넘지 않도록 캡핑
  final preTotalWeight =
      weightedEvents.fold<double>(0, (sum, e) => sum + e.value);
  final maxWeight = preTotalWeight * 0.045;
  for (int i = 0; i < weightedEvents.length; i++) {
    if (weightedEvents[i].value > maxWeight) {
      weightedEvents[i] = MapEntry(weightedEvents[i].key, maxWeight);
    }
  }

  final totalWeight =
      weightedEvents.fold<double>(0, (sum, e) => sum + e.value);
  var randomValue = random.nextDouble() * totalWeight;
  for (final entry in weightedEvents) {
    randomValue -= entry.value;
    if (randomValue <= 0) return entry.key;
  }
  return weightedEvents.last.key;
}

// 이벤트의 가중치 계산 (확률 분석용)
double _calcWeight({
  required ClashEvent event,
  required PlayerStats attackerStats,
  required PlayerStats defenderStats,
  required GamePhase gamePhase,
  required String matchup,
}) {
  double weight = 1.0;
  if (event.favorsStat != null) {
    final isDefenderFavored = event.attackerArmy < event.defenderArmy;
    final relevantStats = isDefenderFavored ? defenderStats : attackerStats;
    final stat = _getStatValue(relevantStats, event.favorsStat);
    if (stat > 600) {
      weight *= 1.0 + (stat - 600) / 800;
    } else if (stat < 500) {
      weight *= 0.7 + (stat / 1000);
    }
    final phaseWeight = StatWeights.getCombinedWeight(
        event.favorsStat!, gamePhase, matchup);
    weight *= (0.5 + phaseWeight / 2);
  }
  return weight.clamp(0.3, 2.0);
}

// 종족전 분석 결과를 파일로 출력
void analyzeMatchup(String matchup, StringBuffer output) {
  final attackerRace = matchup[0]; // T, Z, P
  final defenderRace = matchup[2]; // T, Z, P

  // B+ 등급 균형 스탯 (각 650)
  const balancedStats = PlayerStats(
    sense: 650, control: 650, attack: 650, harass: 650,
    strategy: 650, macro: 650, defense: 650, scout: 650,
  );

  // 공격형 선수 (공격 계열 강화)
  const aggroStats = PlayerStats(
    sense: 550, control: 750, attack: 800, harass: 700,
    strategy: 600, macro: 500, defense: 450, scout: 500,
  );

  // 수비형 선수 (수비 계열 강화)
  const defStats = PlayerStats(
    sense: 600, control: 600, attack: 450, harass: 500,
    strategy: 700, macro: 800, defense: 750, scout: 550,
  );

  final phases = [GamePhase.early, GamePhase.mid, GamePhase.late];

  // 스타일 조합: (공격자 스타일, 수비자 스타일, 공격자 스탯, 수비자 스탯, 라벨)
  final styleConfigs = [
    (BuildStyle.aggressive, BuildStyle.defensive, aggroStats, defStats, 'AGG_vs_DEF'),
    (BuildStyle.defensive, BuildStyle.aggressive, defStats, aggroStats, 'DEF_vs_AGG'),
    (BuildStyle.aggressive, BuildStyle.aggressive, aggroStats, aggroStats, 'AGG_vs_AGG'),
    (BuildStyle.balanced, BuildStyle.balanced, balancedStats, balancedStats, 'BAL_vs_BAL'),
    (BuildStyle.cheese, BuildStyle.defensive, aggroStats, defStats, 'CHEESE_vs_DEF'),
  ];

  // 3가지 맵 (러시맵, 표준맵, 매크로맵)
  final maps = [
    (3, 4, 3, 3, 5, false, 'Rush'),      // 좁은 러시맵
    (5, 5, 5, 5, 5, false, 'Standard'),   // 표준맵
    (8, 8, 7, 7, 3, false, 'Macro'),      // 넓은 매크로맵
  ];

  final random = Random(42); // 시드 고정 (재현 가능)

  output.writeln('==========================================================');
  output.writeln('  MATCHUP: $matchup ($attackerRace vs $defenderRace)');
  output.writeln('==========================================================\n');

  // ===== 1. 이벤트 풀 전체 분석 =====
  output.writeln('## 1. 이벤트 풀 구성 (Phase × Style × Map)');
  output.writeln('');

  for (final phase in phases) {
    for (final (atkStyle, defStyle, atkStats, defStatsProfile, styleLabel) in styleConfigs) {
      for (final (rd, res, tc, aa, ci, island, mapLabel) in maps) {
        final events = BuildOrderData.getClashEvents(
          atkStyle, defStyle,
          attackerRace: attackerRace,
          defenderRace: defenderRace,
          rushDistance: rd,
          resources: res,
          terrainComplexity: tc,
          airAccessibility: aa,
          centerImportance: ci,
          hasIsland: island,
          attackerAttack: atkStats.attack,
          attackerHarass: atkStats.harass,
          attackerControl: atkStats.control,
          attackerStrategy: atkStats.strategy,
          attackerMacro: atkStats.macro,
          attackerSense: atkStats.sense,
          defenderDefense: defStatsProfile.defense,
          defenderStrategy: defStatsProfile.strategy,
          defenderMacro: defStatsProfile.macro,
          defenderControl: defStatsProfile.control,
          defenderSense: defStatsProfile.sense,
          gamePhase: phase,
          attackerArmySize: 80,
          defenderArmySize: 80,
        );

        output.writeln('### ${phase.name} | $styleLabel | $mapLabel맵 (rd=$rd) | 이벤트 ${events.length}개');

        if (events.isEmpty) {
          output.writeln('  ⚠️ 이벤트 풀 비어있음!\n');
          continue;
        }

        // 가중치 분석 (확률 분포)
        double totalWeight = 0;
        final eventWeights = <MapEntry<ClashEvent, double>>[];
        for (final e in events) {
          final w = _calcWeight(
            event: e,
            attackerStats: atkStats,
            defenderStats: defStatsProfile,
            gamePhase: phase,
            matchup: matchup,
          );
          eventWeights.add(MapEntry(e, w));
          totalWeight += w;
        }

        // 확률순 정렬
        eventWeights.sort((a, b) => b.value.compareTo(a.value));

        // 실제 선택 시뮬레이션 (1000회)
        final selectionCount = <String, int>{};
        for (var i = 0; i < 1000; i++) {
          final selected = _selectWeightedEvent(
            events: events,
            attackerStats: atkStats,
            defenderStats: defStatsProfile,
            gamePhase: phase,
            matchup: matchup,
            random: random,
          );
          selectionCount[selected.text] = (selectionCount[selected.text] ?? 0) + 1;
        }

        // 평균 피해량
        double totalAtkDmg = 0, totalDefDmg = 0;
        int totalAtkRes = 0, totalDefRes = 0;
        int decisiveCount = 0;
        final favorsStatDist = <String, int>{};

        for (final entry in selectionCount.entries) {
          final e = events.firstWhere((ev) => ev.text == entry.key);
          totalAtkDmg += e.attackerArmy * entry.value;
          totalDefDmg += e.defenderArmy * entry.value;
          totalAtkRes += e.attackerResource * entry.value;
          totalDefRes += e.defenderResource * entry.value;
          if (e.decisive) decisiveCount += entry.value;
          if (e.favorsStat != null) {
            favorsStatDist[e.favorsStat!] =
                (favorsStatDist[e.favorsStat!] ?? 0) + entry.value;
          }
        }

        output.writeln('  총 가중치합: ${totalWeight.toStringAsFixed(2)} | 이론적 확률 범위: ${(1/events.length*100).toStringAsFixed(1)}% 균등');
        output.writeln('  공격자 평균피해: ${(totalAtkDmg/1000).toStringAsFixed(2)} | 수비자 평균피해: ${(totalDefDmg/1000).toStringAsFixed(2)} | 차이: ${((totalDefDmg-totalAtkDmg)/1000).toStringAsFixed(2)} (양수=공격자유리)');
        output.writeln('  공격자 평균자원: ${(totalAtkRes/1000).toStringAsFixed(2)} | 수비자 평균자원: ${(totalDefRes/1000).toStringAsFixed(2)}');
        output.writeln('  결정적 이벤트 선택: ${(decisiveCount/10).toStringAsFixed(1)}%');

        // favorsStat 분포
        if (favorsStatDist.isNotEmpty) {
          final sortedStats = favorsStatDist.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final statStr = sortedStats
              .map((e) => '${e.key}:${(e.value/10).toStringAsFixed(1)}%')
              .join(', ');
          output.writeln('  favorsStat 분포: $statStr');
        }

        // 선택 빈도 TOP 15 (실제 시뮬레이션 기반)
        final sortedSelections = selectionCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        output.writeln('  --- 선택 빈도 TOP 15 (1000회 시뮬) ---');
        for (var i = 0; i < sortedSelections.length && i < 15; i++) {
          final text = sortedSelections[i].key;
          final count = sortedSelections[i].value;
          final e = events.firstWhere((ev) => ev.text == text);
          final prob = (count / 10).toStringAsFixed(1);
          output.writeln('    ${(i + 1).toString().padLeft(2)}. [$prob%] atk:${e.attackerArmy.toString().padLeft(4)} def:${e.defenderArmy.toString().padLeft(4)} ${e.decisive ? "★결정적" : ""} favor:${(e.favorsStat ?? "-").padRight(8)} "$text"');
        }

        // 선택되지 않은 이벤트 (죽은 이벤트)
        final deadEvents = events.where((e) => !selectionCount.containsKey(e.text)).toList();
        if (deadEvents.isNotEmpty) {
          output.writeln('  --- 미선택 이벤트 (${deadEvents.length}개) ---');
          for (final e in deadEvents) {
            final w = _calcWeight(
              event: e,
              attackerStats: atkStats,
              defenderStats: defStatsProfile,
              gamePhase: phase,
              matchup: matchup,
            );
            output.writeln('    [가중치 ${w.toStringAsFixed(2)}] favor:${(e.favorsStat ?? "-").padRight(8)} "${e.text}"');
          }
        }

        output.writeln('');
      }
    }
  }

  // ===== 2. 전체 이벤트 목록 (유니크) =====
  output.writeln('## 2. $matchup 전용 이벤트 전체 목록');
  output.writeln('');

  // 모든 설정에서 등장하는 이벤트 수집
  final allEvents = <String, ClashEvent>{};
  for (final phase in phases) {
    for (final (atkStyle, defStyle, _, _, _) in styleConfigs) {
      for (final (rd, res, tc, aa, ci, island, _) in maps) {
        final events = BuildOrderData.getClashEvents(
          atkStyle, defStyle,
          attackerRace: attackerRace,
          defenderRace: defenderRace,
          rushDistance: rd,
          resources: res,
          terrainComplexity: tc,
          airAccessibility: aa,
          centerImportance: ci,
          hasIsland: island,
          attackerAttack: 650,
          attackerHarass: 650,
          attackerControl: 650,
          attackerStrategy: 650,
          attackerMacro: 650,
          attackerSense: 650,
          defenderDefense: 650,
          defenderStrategy: 650,
          defenderMacro: 650,
          defenderControl: 650,
          defenderSense: 650,
          gamePhase: phase,
          attackerArmySize: 80,
          defenderArmySize: 80,
        );
        for (final e in events) {
          allEvents[e.text] = e;
        }
      }
    }
  }

  // 피해량별 정렬
  final sortedAll = allEvents.values.toList()
    ..sort((a, b) {
      final aNet = a.defenderArmy - a.attackerArmy;
      final bNet = b.defenderArmy - b.attackerArmy;
      return bNet.compareTo(aNet); // 공격자 유리한 순
    });

  output.writeln('  총 유니크 이벤트: ${sortedAll.length}개');
  output.writeln('');

  for (var i = 0; i < sortedAll.length; i++) {
    final e = sortedAll[i];
    final net = e.defenderArmy - e.attackerArmy;
    String balance;
    if (net > 5) {
      balance = '공격자 유리(+$net)';
    } else if (net < -5) {
      balance = '수비자 유리($net)';
    } else {
      balance = '균형($net)';
    }
    output.writeln('  ${(i + 1).toString().padLeft(3)}. atk:${e.attackerArmy.toString().padLeft(4)} def:${e.defenderArmy.toString().padLeft(4)} res_atk:${e.attackerResource.toString().padLeft(4)} res_def:${e.defenderResource.toString().padLeft(4)} ${e.decisive ? "★결정적 " : "         "} favor:${(e.favorsStat ?? "-").padRight(8)} [$balance] "${e.text}"');
  }

  output.writeln('\n');
}

void main() {
  final matchups = ['TvZ', 'ZvT', 'TvP', 'PvT', 'ZvP', 'PvZ', 'TvT', 'ZvZ', 'PvP'];

  test('클래시 이벤트 종합 분석', () {
    final outputDir = Directory('test/output');
    if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

    for (final matchup in matchups) {
      final buffer = StringBuffer();
      analyzeMatchup(matchup, buffer);

      // 파일 출력
      final file = File('test/output/clash_$matchup.txt');
      file.writeAsStringSync(buffer.toString());
      print('✓ $matchup 분석 완료 → ${file.path}');
    }

    // 요약 출력
    print('\n전체 분석 완료. test/output/ 디렉토리 확인');
  });
}
