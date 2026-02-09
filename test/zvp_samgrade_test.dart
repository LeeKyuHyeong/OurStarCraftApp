// ZvP 65:35 맵 동급 테스트 (2x 증폭 확인)
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'package:mystar/core/constants/map_data.dart';

void main() {
  test('동급(B+) ZvP=65 맵 100경기', () {
    final service = MatchSimulationService();
    final mapData = allMaps.firstWhere((m) => m.zvp == 65);
    final map = mapData.toGameMap();

    final zerg = Player(
      id: 'z', name: 'B+저그', raceIndex: Race.zerg.index,
      stats: const PlayerStats(
        sense: 500, control: 500, attack: 500, harass: 500,
        strategy: 500, macro: 500, defense: 500, scout: 500,
      ), levelValue: 5, condition: 100,
    );
    final protoss = Player(
      id: 'p', name: 'B+프토', raceIndex: Race.protoss.index,
      stats: const PlayerStats(
        sense: 500, control: 500, attack: 500, harass: 500,
        strategy: 500, macro: 500, defense: 500, scout: 500,
      ), levelValue: 5, condition: 100,
    );

    final calc = service.calculateWinRate(homePlayer: zerg, awayPlayer: protoss, map: map);
    int zWins = 0;
    for (int i = 0; i < 100; i++) {
      if (service.simulateMatch(homePlayer: zerg, awayPlayer: protoss, map: map).homeWin) zWins++;
    }

    print('맵: ${mapData.name} (ZvP=${mapData.zvp})');
    print('동급 B+ 계산 승률: ${(calc * 100).toStringAsFixed(1)}%');
    print('동급 B+ 시뮬 결과: 저그 $zWins승 (${zWins}%)');
  });
}
