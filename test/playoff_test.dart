// 플레이오프 시스템 테스트
// 실행: flutter test test/playoff_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/playoff_service.dart';

/// 테스트용 ScheduleItem 생성 (완료된 경기)
ScheduleItem _completedMatch({
  required String homeTeamId,
  required String awayTeamId,
  required int homeScore,
  required int awayScore,
  int roundNumber = 1,
}) {
  final sets = <SetResult>[];
  for (int i = 0; i < homeScore; i++) {
    sets.add(SetResult(
      mapId: 'map_$i',
      homePlayerId: 'hp_$i',
      awayPlayerId: 'ap_$i',
      homeWin: true,
    ));
  }
  for (int i = 0; i < awayScore; i++) {
    sets.add(SetResult(
      mapId: 'map_${homeScore + i}',
      homePlayerId: 'hp_${homeScore + i}',
      awayPlayerId: 'ap_${homeScore + i}',
      homeWin: false,
    ));
  }

  return ScheduleItem(
    matchId: 'match_${homeTeamId}_vs_$awayTeamId',
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    roundNumber: roundNumber,
    isCompleted: true,
    result: MatchResult(
      id: 'match_${homeTeamId}_vs_$awayTeamId',
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      sets: sets,
      isCompleted: true,
    ),
  );
}

/// 테스트용 MatchResult 생성
MatchResult _makeMatchResult({
  required String homeTeamId,
  required String awayTeamId,
  required int homeScore,
  required int awayScore,
}) {
  final sets = <SetResult>[];
  for (int i = 0; i < homeScore; i++) {
    sets.add(SetResult(
      mapId: 'map_$i',
      homePlayerId: 'hp_$i',
      awayPlayerId: 'ap_$i',
      homeWin: true,
    ));
  }
  for (int i = 0; i < awayScore; i++) {
    sets.add(SetResult(
      mapId: 'map_${homeScore + i}',
      homePlayerId: 'hp_${homeScore + i}',
      awayPlayerId: 'ap_${homeScore + i}',
      homeWin: false,
    ));
  }

  return MatchResult(
    id: 'playoff_${homeTeamId}_vs_$awayTeamId',
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    sets: sets,
    isCompleted: true,
  );
}

void main() {
  late PlayoffService service;

  final teamIds = ['team_A', 'team_B', 'team_C', 'team_D',
                   'team_E', 'team_F', 'team_G', 'team_H'];

  setUp(() {
    service = PlayoffService();
  });

  group('플레이오프 브래킷', () {
    test('1위~4위 정확한 배치', () {
      // 8팀 정규 시즌 결과 생성: team_A가 1위, team_B가 2위 등
      // 간단하게 team_A가 team_B~H에 모두 승리 등
      final schedule = <ScheduleItem>[
        // team_A: 7승 0패
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_B', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_C', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_D', homeScore: 4, awayScore: 3),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_E', homeScore: 4, awayScore: 0),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_F', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_G', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_H', homeScore: 4, awayScore: 1),
        // team_B: 6승 1패
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_C', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_D', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_E', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_F', homeScore: 4, awayScore: 0),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_G', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_H', homeScore: 4, awayScore: 2),
        // team_C: 5승 2패
        _completedMatch(homeTeamId: 'team_C', awayTeamId: 'team_D', homeScore: 4, awayScore: 3),
        _completedMatch(homeTeamId: 'team_C', awayTeamId: 'team_E', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_C', awayTeamId: 'team_F', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_C', awayTeamId: 'team_G', homeScore: 4, awayScore: 0),
        _completedMatch(homeTeamId: 'team_C', awayTeamId: 'team_H', homeScore: 4, awayScore: 1),
        // team_D: 4승 3패
        _completedMatch(homeTeamId: 'team_D', awayTeamId: 'team_E', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_D', awayTeamId: 'team_F', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_D', awayTeamId: 'team_G', homeScore: 4, awayScore: 3),
        _completedMatch(homeTeamId: 'team_D', awayTeamId: 'team_H', homeScore: 4, awayScore: 0),
        // team_E: 3승 4패
        _completedMatch(homeTeamId: 'team_E', awayTeamId: 'team_F', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_E', awayTeamId: 'team_G', homeScore: 4, awayScore: 2),
        _completedMatch(homeTeamId: 'team_E', awayTeamId: 'team_H', homeScore: 4, awayScore: 3),
        // team_F: 2승 5패
        _completedMatch(homeTeamId: 'team_F', awayTeamId: 'team_G', homeScore: 4, awayScore: 1),
        _completedMatch(homeTeamId: 'team_F', awayTeamId: 'team_H', homeScore: 4, awayScore: 2),
        // team_G: 1승 6패
        _completedMatch(homeTeamId: 'team_G', awayTeamId: 'team_H', homeScore: 4, awayScore: 3),
        // team_H: 0승 7패
      ];

      final standings = service.calculateStandings(schedule, teamIds);

      // 순위 확인
      expect(standings.length, 8);
      expect(standings[0].teamId, 'team_A', reason: '1위는 team_A');
      expect(standings[1].teamId, 'team_B', reason: '2위는 team_B');
      expect(standings[2].teamId, 'team_C', reason: '3위는 team_C');
      expect(standings[3].teamId, 'team_D', reason: '4위는 team_D');

      // 플레이오프 브래킷 생성
      final bracket = service.createPlayoffBracket(standings);

      expect(bracket.firstPlaceTeamId, 'team_A');
      expect(bracket.secondPlaceTeamId, 'team_B');
      expect(bracket.thirdPlaceTeamId, 'team_C');
      expect(bracket.fourthPlaceTeamId, 'team_D');
    });

    test('승점 동률 시 세트 득실로 순위 결정', () {
      // team_A와 team_B 모두 1승 0패 (3점)
      // team_A: 세트 4-3 (득실 +1)
      // team_B: 세트 4-1 (득실 +3)
      // → team_B가 상위
      final schedule = <ScheduleItem>[
        _completedMatch(homeTeamId: 'team_A', awayTeamId: 'team_C', homeScore: 4, awayScore: 3),
        _completedMatch(homeTeamId: 'team_B', awayTeamId: 'team_D', homeScore: 4, awayScore: 1),
      ];

      final standings = service.calculateStandings(
        schedule,
        ['team_A', 'team_B', 'team_C', 'team_D'],
      );

      // team_B가 세트 득실이 높아서 1위
      expect(standings[0].teamId, 'team_B');
      expect(standings[1].teamId, 'team_A');
    });
  });

  group('페이즈 전환', () {
    test('playoff34 -> individualSemiFinal -> playoff23 -> individualFinal -> playoffFinal -> seasonEnd', () {
      // 초기 시즌: regularSeason
      var season = const Season(
        number: 1,
        phaseIndex: 0, // regularSeason
      );

      // regularSeason -> playoffReady (정규 시즌 완료 시)
      // playoffReady -> playoff34
      season = season.updatePhase(SeasonPhase.playoff34);
      expect(season.phase, SeasonPhase.playoff34);

      // 3,4위전 결과 추가
      final match34Result = _makeMatchResult(
        homeTeamId: 'team_C',
        awayTeamId: 'team_D',
        homeScore: 4,
        awayScore: 2,
      );
      final playoff = PlayoffBracket(
        firstPlaceTeamId: 'team_A',
        secondPlaceTeamId: 'team_B',
        thirdPlaceTeamId: 'team_C',
        fourthPlaceTeamId: 'team_D',
        match34: match34Result,
      );
      season = season.updatePlayoff(playoff);

      // playoff34 -> individualSemiFinal
      final nextPhase1 = service.getNextPhase(season);
      expect(nextPhase1, SeasonPhase.individualSemiFinal);

      season = season.updatePhase(SeasonPhase.individualSemiFinal);

      // 개인리그 4강 2경기 완료 설정
      final semiFinal1 = IndividualMatchResult(
        id: 'sf1',
        player1Id: 'p1',
        player2Id: 'p2',
        winnerId: 'p1',
        mapId: 'map1',
        stageIndex: IndividualLeagueStage.semiFinal.index,
      );
      final semiFinal2 = IndividualMatchResult(
        id: 'sf2',
        player1Id: 'p3',
        player2Id: 'p4',
        winnerId: 'p3',
        mapId: 'map2',
        stageIndex: IndividualLeagueStage.semiFinal.index,
      );
      final individualLeague = IndividualLeagueBracket(
        seasonNumber: 1,
        mainTournamentResults: [semiFinal1, semiFinal2],
      );
      season = season.updateIndividualLeague(individualLeague);

      // individualSemiFinal -> playoff23
      final nextPhase2 = service.getNextPhase(season);
      expect(nextPhase2, SeasonPhase.playoff23);

      season = season.updatePhase(SeasonPhase.playoff23);

      // 2,3위전 결과 추가 (2위 vs 3,4위전 승자)
      final match23Result = _makeMatchResult(
        homeTeamId: 'team_B',
        awayTeamId: 'team_C',
        homeScore: 4,
        awayScore: 3,
      );
      final updatedPlayoff = playoff.copyWith(match23: match23Result);
      season = season.updatePlayoff(updatedPlayoff);

      // playoff23 -> individualFinal
      final nextPhase3 = service.getNextPhase(season);
      expect(nextPhase3, SeasonPhase.individualFinal);

      season = season.updatePhase(SeasonPhase.individualFinal);

      // 개인리그 결승 완료 설정
      final finalMatch = IndividualMatchResult(
        id: 'final',
        player1Id: 'p1',
        player2Id: 'p3',
        winnerId: 'p1',
        mapId: 'map3',
        stageIndex: IndividualLeagueStage.final_.index,
      );
      final updatedIndividual = individualLeague.copyWith(
        mainTournamentResults: [...individualLeague.mainTournamentResults, finalMatch],
        championId: 'p1',
        runnerUpId: 'p3',
      );
      season = season.updateIndividualLeague(updatedIndividual);

      // individualFinal -> playoffFinal
      final nextPhase4 = service.getNextPhase(season);
      expect(nextPhase4, SeasonPhase.playoffFinal);

      season = season.updatePhase(SeasonPhase.playoffFinal);

      // 결승전 결과 추가 (1위 vs 2,3위전 승자)
      final matchFinalResult = _makeMatchResult(
        homeTeamId: 'team_A',
        awayTeamId: 'team_B',
        homeScore: 4,
        awayScore: 1,
      );
      final finalPlayoff = updatedPlayoff.copyWith(matchFinal: matchFinalResult);
      season = season.updatePlayoff(finalPlayoff);

      // playoffFinal -> seasonEnd
      final nextPhase5 = service.getNextPhase(season);
      expect(nextPhase5, SeasonPhase.seasonEnd);
    });
  });

  group('1위 bye 규칙', () {
    test('1위는 결승 직행, 3/4위전 승자가 2위와 대결', () {
      final bracket = PlayoffBracket(
        firstPlaceTeamId: 'team_A',
        secondPlaceTeamId: 'team_B',
        thirdPlaceTeamId: 'team_C',
        fourthPlaceTeamId: 'team_D',
      );

      // 첫 번째 매치: 3,4위전
      expect(bracket.currentMatch, PlayoffMatchType.thirdFourth);
      final teams34 = bracket.nextMatchTeams;
      expect(teams34, isNotNull);
      expect(teams34!.$1, 'team_C', reason: '3위가 홈');
      expect(teams34.$2, 'team_D', reason: '4위가 원정');

      // 3,4위전 결과: team_C 승리
      final result34 = _makeMatchResult(
        homeTeamId: 'team_C',
        awayTeamId: 'team_D',
        homeScore: 4,
        awayScore: 2,
      );
      final afterMatch34 = bracket.copyWith(match34: result34);

      // 두 번째 매치: 2,3위전 (2위 vs 3,4위전 승자)
      expect(afterMatch34.currentMatch, PlayoffMatchType.secondThird);
      expect(afterMatch34.winner34, 'team_C');
      final teams23 = afterMatch34.nextMatchTeams;
      expect(teams23, isNotNull);
      expect(teams23!.$1, 'team_B', reason: '2위가 홈');
      expect(teams23.$2, 'team_C', reason: '3,4위전 승자가 원정');

      // 2,3위전 결과: team_B 승리
      final result23 = _makeMatchResult(
        homeTeamId: 'team_B',
        awayTeamId: 'team_C',
        homeScore: 4,
        awayScore: 3,
      );
      final afterMatch23 = afterMatch34.copyWith(match23: result23);

      // 세 번째 매치: 결승 (1위 vs 2,3위전 승자)
      expect(afterMatch23.currentMatch, PlayoffMatchType.final_);
      expect(afterMatch23.winner23, 'team_B');
      final teamsFinal = afterMatch23.nextMatchTeams;
      expect(teamsFinal, isNotNull);
      expect(teamsFinal!.$1, 'team_A', reason: '1위가 홈 (bye 직행)');
      expect(teamsFinal.$2, 'team_B', reason: '2,3위전 승자가 원정');

      // 결승전 결과: team_A 우승
      final resultFinal = _makeMatchResult(
        homeTeamId: 'team_A',
        awayTeamId: 'team_B',
        homeScore: 4,
        awayScore: 1,
      );
      final afterFinal = afterMatch23.copyWith(matchFinal: resultFinal);

      // 모든 경기 완료
      expect(afterFinal.currentMatch, isNull);
      expect(afterFinal.champion, 'team_A');
      expect(afterFinal.runnerUp, 'team_B');
    });

    test('4위가 3,4위전 승리 -> 2위 대결 -> 결승에서 1위와 대결', () {
      final bracket = PlayoffBracket(
        firstPlaceTeamId: 'team_A',
        secondPlaceTeamId: 'team_B',
        thirdPlaceTeamId: 'team_C',
        fourthPlaceTeamId: 'team_D',
      );

      // 3,4위전: team_D 승리 (4위 역전)
      final result34 = _makeMatchResult(
        homeTeamId: 'team_C',
        awayTeamId: 'team_D',
        homeScore: 3,
        awayScore: 4,
      );
      var updated = bracket.copyWith(match34: result34);
      expect(updated.winner34, 'team_D');

      // 2,3위전: team_D 승리 (4위 돌풍)
      final result23 = _makeMatchResult(
        homeTeamId: 'team_B',
        awayTeamId: 'team_D',
        homeScore: 2,
        awayScore: 4,
      );
      updated = updated.copyWith(match23: result23);
      expect(updated.winner23, 'team_D');

      // 결승: 1위 team_A vs 4위 team_D
      final teamsFinal = updated.nextMatchTeams;
      expect(teamsFinal!.$1, 'team_A');
      expect(teamsFinal.$2, 'team_D');

      // 결승: team_D 우승 (파란 만장)
      final resultFinal = _makeMatchResult(
        homeTeamId: 'team_A',
        awayTeamId: 'team_D',
        homeScore: 3,
        awayScore: 4,
      );
      updated = updated.copyWith(matchFinal: resultFinal);

      expect(updated.champion, 'team_D');
      expect(updated.runnerUp, 'team_A');
    });
  });

  group('PlayoffService 유틸리티', () {
    test('플레이오프 진행 상황 추적', () {
      var bracket = PlayoffBracket(
        firstPlaceTeamId: 'team_A',
        secondPlaceTeamId: 'team_B',
        thirdPlaceTeamId: 'team_C',
        fourthPlaceTeamId: 'team_D',
      );

      var progress = service.getPlayoffProgress(bracket);
      expect(progress.completedMatchCount, 0);
      expect(progress.isCompleted, isFalse);

      // 3,4위전 완료
      bracket = bracket.copyWith(
        match34: _makeMatchResult(
          homeTeamId: 'team_C',
          awayTeamId: 'team_D',
          homeScore: 4,
          awayScore: 2,
        ),
      );
      progress = service.getPlayoffProgress(bracket);
      expect(progress.completedMatchCount, 1);
      expect(progress.winner34, 'team_C');

      // 2,3위전 완료
      bracket = bracket.copyWith(
        match23: _makeMatchResult(
          homeTeamId: 'team_B',
          awayTeamId: 'team_C',
          homeScore: 4,
          awayScore: 1,
        ),
      );
      progress = service.getPlayoffProgress(bracket);
      expect(progress.completedMatchCount, 2);
      expect(progress.winner23, 'team_B');

      // 결승 완료
      bracket = bracket.copyWith(
        matchFinal: _makeMatchResult(
          homeTeamId: 'team_A',
          awayTeamId: 'team_B',
          homeScore: 4,
          awayScore: 3,
        ),
      );
      progress = service.getPlayoffProgress(bracket);
      expect(progress.completedMatchCount, 3);
      expect(progress.isCompleted, isTrue);
      expect(progress.champion, 'team_A');
    });

    test('updatePlayoffMatch 정확히 동작', () {
      final bracket = PlayoffBracket(
        firstPlaceTeamId: 'team_A',
        secondPlaceTeamId: 'team_B',
        thirdPlaceTeamId: 'team_C',
        fourthPlaceTeamId: 'team_D',
      );

      final result34 = _makeMatchResult(
        homeTeamId: 'team_C',
        awayTeamId: 'team_D',
        homeScore: 4,
        awayScore: 0,
      );

      final updated = service.updatePlayoffMatch(
        bracket,
        PlayoffMatchType.thirdFourth,
        result34,
      );

      expect(updated.match34, isNotNull);
      expect(updated.match34!.homeTeamId, 'team_C');
      expect(updated.match23, isNull);
      expect(updated.matchFinal, isNull);
    });
  });
}
