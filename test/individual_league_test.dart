// 개인리그 브래킷 테스트
// 실행: flutter test test/individual_league_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/individual_league_service.dart';

/// 테스트용 선수 생성 헬퍼
Player _makePlayer({
  required String id,
  required String name,
  required Race race,
  required int totalStats,
  String? teamId,
  int levelValue = 5,
}) {
  final perStat = totalStats ~/ 8;
  final remainder = totalStats - perStat * 8;
  return Player(
    id: id,
    name: name,
    raceIndex: race.index,
    stats: PlayerStats(
      sense: perStat + remainder,
      control: perStat,
      attack: perStat,
      harass: perStat,
      strategy: perStat,
      macro: perStat,
      defense: perStat,
      scout: perStat,
    ),
    levelValue: levelValue,
    condition: 100,
    teamId: teamId,
  );
}

/// 8개 팀 각 15명 = 120명 선수 + 테스트 팀 ID 생성
({List<Player> players, List<String> teamIds, String playerTeamId}) _createTestData() {
  final teamIds = List.generate(8, (i) => 'team_$i');
  final players = <Player>[];
  final races = [Race.terran, Race.zerg, Race.protoss];

  for (int t = 0; t < 8; t++) {
    for (int p = 0; p < 15; p++) {
      final idx = t * 15 + p;
      // 등급 분포: 팀 0이 가장 높은 선수 보유, 선수 0이 가장 높은 능력치
      final totalStats = 5000 - (idx * 30);
      players.add(_makePlayer(
        id: 'player_${t}_$p',
        name: '선수${t}_$p',
        race: races[idx % 3],
        totalStats: totalStats.clamp(800, 7000),
        teamId: teamIds[t],
      ));
    }
  }

  return (players: players, teamIds: teamIds, playerTeamId: teamIds[0]);
}

void main() {
  late IndividualLeagueService service;

  setUp(() {
    service = IndividualLeagueService();
  });

  group('PC방 예선 브래킷', () {
    test('24개 조, 각 조 4명 생성', () {
      final data = _createTestData();
      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
      );

      // 24개 조
      expect(bracket.pcBangGroups.length, 24);

      // 각 조 4명
      for (int i = 0; i < bracket.pcBangGroups.length; i++) {
        expect(bracket.pcBangGroups[i].length, 4,
            reason: '조 $i 의 선수 수가 4명이어야 함');
      }
    });

    test('같은 팀 선수 같은 조 배정 방지 (가능한 범위 내)', () {
      final data = _createTestData();
      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
      );

      // 각 조에서 같은 팀 선수가 2명 이상인 경우를 세기
      int sameTeamConflicts = 0;
      for (final group in bracket.pcBangGroups) {
        final teamCounts = <String?, int>{};
        for (final playerId in group) {
          if (playerId.startsWith('amateur_')) continue;
          final player = data.players.firstWhere(
            (p) => p.id == playerId,
            orElse: () => _makePlayer(
              id: playerId,
              name: 'unknown',
              race: Race.terran,
              totalStats: 800,
            ),
          );
          teamCounts[player.teamId] = (teamCounts[player.teamId] ?? 0) + 1;
        }
        for (final count in teamCounts.values) {
          if (count > 1) sameTeamConflicts++;
        }
      }

      // 완전한 회피가 불가능할 수 있지만, 대부분의 조에서 같은 팀 충돌이 없어야 함
      // 120명 중 32명(시드) 제외 = 88명 → 24조 × 4명 = 96슬롯 중 88명 실제 배정
      // 팀당 최대 ~11명 PC방 → 24조 분산이므로 충돌 매우 적어야 함
      expect(sameTeamConflicts, lessThan(5),
          reason: '같은 팀 선수 충돌이 최소화되어야 함');
    });

    test('PC방 예선에서 제외된 선수는 시드 배정된 선수', () {
      final data = _createTestData();
      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
      );

      final pcBangPlayerIds = bracket.pcBangGroups.expand((g) => g).toSet();
      final seededPlayerIds = {
        ...bracket.mainTournamentSeeds,
        ...bracket.dualTournamentSeeds,
      };

      // PC방 예선 선수와 시드 선수가 겹치지 않음
      final overlap = pcBangPlayerIds.intersection(seededPlayerIds);
      // amateur_ 제외
      final realOverlap = overlap.where((id) => !id.startsWith('amateur_')).toSet();
      expect(realOverlap, isEmpty,
          reason: 'PC방 예선 선수와 시드 선수가 겹치면 안 됨');
    });
  });

  group('듀얼토너먼트', () {
    test('12개 조, 시드 2명 + 빈 슬롯 2명 구성', () {
      final data = _createTestData();
      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
      );

      // 듀얼토너먼트 12개 조
      expect(bracket.dualTournamentGroups.length, 12);

      // 각 조 4명 (시드 2 + null 2)
      for (int i = 0; i < bracket.dualTournamentGroups.length; i++) {
        expect(bracket.dualTournamentGroups[i].length, 4,
            reason: '듀얼토너먼트 조 $i 의 슬롯 수가 4여야 함');

        // 시드 2명 (인덱스 0, 1)이 non-null
        expect(bracket.dualTournamentGroups[i][0], isNotNull,
            reason: '조 $i 의 1시드가 배정되어야 함');
        expect(bracket.dualTournamentGroups[i][1], isNotNull,
            reason: '조 $i 의 2시드가 배정되어야 함');

        // 나머지 2슬롯은 PC방 예선 승자용 (null)
        expect(bracket.dualTournamentGroups[i][2], isNull,
            reason: '조 $i 의 3번 슬롯은 PC방 예선 승자 대기');
        expect(bracket.dualTournamentGroups[i][3], isNull,
            reason: '조 $i 의 4번 슬롯은 PC방 예선 승자 대기');
      }

      // 듀얼토너먼트 시드 24명
      expect(bracket.dualTournamentSeeds.length, 24);
    });
  });

  group('조지명식 (본선)', () {
    test('8개 조, 시드 1명 + 빈 슬롯 3명 구성', () {
      final data = _createTestData();
      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
      );

      // 본선 8개 조
      expect(bracket.mainTournamentGroups.length, 8);

      // 각 조 4명 (시드 1 + null 3)
      for (int i = 0; i < bracket.mainTournamentGroups.length; i++) {
        expect(bracket.mainTournamentGroups[i].length, 4,
            reason: '본선 조 $i 의 슬롯 수가 4여야 함');

        // 시드 1명 (인덱스 0)이 non-null
        expect(bracket.mainTournamentGroups[i][0], isNotNull,
            reason: '조 $i 의 시드가 배정되어야 함');
      }

      // 본선 시드 8명
      expect(bracket.mainTournamentSeeds.length, 8);
    });
  });

  group('전시즌 시드 반영', () {
    test('이전 시즌 8강 진출자가 mainTournamentSeeds에 반영됨', () {
      final data = _createTestData();

      // 이전 시즌 개인리그 결과 생성 (top8Players 설정)
      final prevTop8 = data.players.take(8).map((p) => p.id).toList();
      final previousBracket = IndividualLeagueBracket(
        seasonNumber: 0,
        top8Players: prevTop8,
        mainTournamentResults: [], // 빈 결과 (16강/32강 패자 없음)
      );

      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
        previousSeasonBracket: previousBracket,
      );

      // mainTournamentSeeds가 이전 시즌 top8과 일치
      expect(bracket.mainTournamentSeeds.length, 8);
      for (final seedId in prevTop8) {
        expect(bracket.mainTournamentSeeds.contains(seedId), isTrue,
            reason: '이전 시즌 8강 진출자 $seedId 가 본선 시드에 포함되어야 함');
      }
    });

    test('이전 시즌 선수가 은퇴/이적하면 등급순으로 대체', () {
      final data = _createTestData();

      // 이전 시즌 top8 중 일부를 없는 ID로 설정 (은퇴/이적 시뮬레이션)
      final prevTop8 = [
        'player_0_0',
        'player_0_1',
        'retired_player_1', // 존재하지 않음
        'retired_player_2', // 존재하지 않음
        'player_1_0',
        'player_1_1',
        'player_1_2',
        'player_2_0',
      ];
      final previousBracket = IndividualLeagueBracket(
        seasonNumber: 0,
        top8Players: prevTop8,
      );

      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
        previousSeasonBracket: previousBracket,
      );

      // 8명이 시드로 배정됨 (은퇴자는 등급순 대체)
      expect(bracket.mainTournamentSeeds.length, 8);

      // 존재하는 이전 시즌 시드는 포함
      expect(bracket.mainTournamentSeeds.contains('player_0_0'), isTrue);
      expect(bracket.mainTournamentSeeds.contains('player_0_1'), isTrue);
      expect(bracket.mainTournamentSeeds.contains('player_1_0'), isTrue);

      // 은퇴한 선수는 포함되지 않음
      expect(bracket.mainTournamentSeeds.contains('retired_player_1'), isFalse);
      expect(bracket.mainTournamentSeeds.contains('retired_player_2'), isFalse);
    });

    test('첫 시즌(이전 시즌 없음)은 등급순 배정', () {
      final data = _createTestData();

      final bracket = service.createIndividualLeagueBracket(
        allPlayers: data.players,
        playerTeamId: data.playerTeamId,
        seasonNumber: 1,
        previousSeasonBracket: null,
      );

      // 시드 8명이 등급 상위 8명인지 확인
      final sortedPlayers = List<Player>.from(data.players)
        ..sort((a, b) {
          final gradeCompare = b.grade.index - a.grade.index;
          if (gradeCompare != 0) return gradeCompare;
          return b.totalStats - a.totalStats;
        });
      final expectedTop8 = sortedPlayers.take(8).map((p) => p.id).toSet();

      final actualSeeds = bracket.mainTournamentSeeds.toSet();
      expect(actualSeeds, equals(expectedTop8),
          reason: '첫 시즌은 등급 상위 8명이 본선 시드');
    });
  });
}
