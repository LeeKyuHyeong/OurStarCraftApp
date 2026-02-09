// ZvP 65:35 맵에서 C+ 저그 vs A+ 프토 승률 테스트 (100경기)
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'package:mystar/core/constants/map_data.dart';

void main() {
  final service = MatchSimulationService();

  // ZvP=65인 맵 1개 선택
  final mapData = allMaps.firstWhere((m) => m.zvp == 65);
  final map = mapData.toGameMap();

  // C+ 저그 (능력치 합 ~2200, 각 275)
  final zerg = Player(
    id: 'zerg_c_plus',
    name: 'C+저그',
    raceIndex: Race.zerg.index,
    stats: const PlayerStats(
      sense: 275, control: 275, attack: 275, harass: 275,
      strategy: 275, macro: 275, defense: 275, scout: 275,
    ),
    levelValue: 3,
    condition: 100,
  );

  // A+ 프토 (능력치 합 ~4600, 각 575)
  final protoss = Player(
    id: 'protoss_a_plus',
    name: 'A+프토',
    raceIndex: Race.protoss.index,
    stats: const PlayerStats(
      sense: 575, control: 575, attack: 575, harass: 575,
      strategy: 575, macro: 575, defense: 575, scout: 575,
    ),
    levelValue: 5,
    condition: 100,
  );

  test('ZvP 65:35 맵 - C+ 저그 vs A+ 프토 100경기', () {
    final calcWinRate = service.calculateWinRate(
      homePlayer: zerg,
      awayPlayer: protoss,
      map: map,
    );

    print('========================================');
    print('맵: ${mapData.name} (ZvP 저그승률: ${mapData.zvp}%)');
    print('맵 특성: rushDist=${mapData.rushDistance} res=${mapData.resources} comp=${mapData.complexity}');
    print('맵 설명: ${mapData.description}');
    print('========================================');
    print('C+ 저그 (능력치합: ${zerg.stats.total}, 등급: ${zerg.stats.grade.display})');
    print('A+ 프토 (능력치합: ${protoss.stats.total}, 등급: ${protoss.stats.grade.display})');
    print('능력치 차이: ${protoss.stats.total - zerg.stats.total}pt');
    print('');
    print('계산 승률 (저그 기준): ${(calcWinRate * 100).toStringAsFixed(1)}%');
    print('');

    int zergWins = 0;
    final results = <String>[];
    for (int i = 0; i < 100; i++) {
      final result = service.simulateMatch(
        homePlayer: zerg,
        awayPlayer: protoss,
        map: map,
      );
      if (result.homeWin) {
        zergWins++;
        results.add('Z');
      } else {
        results.add('P');
      }
    }

    print('========================================');
    print('100경기 시뮬레이션 결과');
    print('========================================');
    print('저그 승: $zergWins회');
    print('프토 승: ${100 - zergWins}회');
    print('저그 승률: ${zergWins.toDouble().toStringAsFixed(1)}%');
    print('');
    print('경기별 결과 (Z=저그승, P=프토승):');
    for (int i = 0; i < 100; i += 20) {
      final end = (i + 20).clamp(0, 100);
      final chunk = results.sublist(i, end).join(' ');
      print('  ${(i + 1).toString().padLeft(3)}-${end.toString().padLeft(3)}: $chunk');
    }

    print('');
    print('--- 보정 요소 분석 ---');
    print('맵 종족상성: +${((mapData.zvp - 50) * 1.5).toStringAsFixed(1)}%p (65→72.5 기반)');
    print('능력치 차이: -${((protoss.stats.total - zerg.stats.total) / 35).toStringAsFixed(1)}%p');
    print('레벨 차이: ${(zerg.level.value - protoss.level.value) * 2}%p');
  });
}
