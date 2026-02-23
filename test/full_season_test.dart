import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/core/constants/initial_data.dart';

import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/individual_league_service.dart';

/// 한 시즌 전체를 시뮬레이션하는 테스트.
/// GameStateNotifier (Hive 의존) 없이 SaveData를 직접 조작하여
/// 정규시즌 → 개인리그 → 플레이오프 → 시즌종료까지 전 과정을 검증한다.
void main() {
  test('시즌 1 전체 시뮬레이션', () {
    final rand = Random(42); // 고정 시드로 재현 가능
    final ilService = IndividualLeagueService();

    // ============================================================
    // 1. 초기 데이터 생성 (SaveRepository.createNewGame 로직 재현)
    // ============================================================
    final teams = InitialData.createTeams();
    final players = InitialData.createPlayers();
    const playerTeamId = 'kt_rolster';

    final updatedTeams = teams.map((team) {
      if (team.id == playerTeamId) {
        return team.copyWith(isPlayerTeam: true);
      }
      return team;
    }).toList();

    // 시즌맵 랜덤 선정 (7개)
    final allMaps = GameMaps.all;
    final shuffledMapIds = allMaps.map((m) => m.id).toList()..shuffle(rand);
    final seasonMapIds = shuffledMapIds.take(7).toList();

    // 프로리그 일정 생성
    final schedule = _createProleagueSchedule(updatedTeams, rand);

    // 개인리그 대진표 생성
    final individualLeague = ilService.createIndividualLeagueBracket(
      allPlayers: players,
      playerTeamId: playerTeamId,
      seasonNumber: 1,
      previousSeasonBracket: null,
    );

    final season = Season(
      number: 1,
      seasonMapIds: seasonMapIds,
      proleagueSchedule: schedule,
      individualLeague: individualLeague,
    );

    var saveData = SaveData(
      slotNumber: 1,
      playerTeamId: playerTeamId,
      allPlayers: players,
      allTeams: updatedTeams,
      currentSeason: season,
      savedAt: DateTime.now(),
    );

    print('');
    print('════════════════════════════════════════════════════');
    print('  MyStar 시즌 1 전체 시뮬레이션 시작');
    print('  팀 수: ${saveData.allTeams.length}');
    print('  선수 수: ${saveData.allPlayers.length}');
    print('  프로리그 경기 수: ${schedule.length}');
    print('  시즌맵: ${seasonMapIds.length}개');
    print('════════════════════════════════════════════════════');
    print('');

    // ============================================================
    // 2. 정규시즌 (11주 × 경기1 + 경기2 + 개인리그)
    // ============================================================
    for (int week = 0; week < 11; week++) {
      final slot1 = week * 2 + 1;
      final slot2 = week * 2 + 2;

      // Step 0: 경기 1 (해당 슬롯의 모든 매치 시뮬레이션)
      saveData = _simulateAllMatchesInSlot(saveData, slot1, rand);

      // Step 1: 경기 2
      saveData = _simulateAllMatchesInSlot(saveData, slot2, rand);

      // Step 2: 개인리그 진행
      saveData = _advanceIndividualLeague(saveData, week, ilService);

      // 주간 요약
      final completedMatches = saveData.currentSeason.proleagueSchedule
          .where((m) => m.isCompleted)
          .length;
      print('[Week $week] 완료 경기: $completedMatches/${schedule.length}'
          '  |  개인리그 단계: ${_getIndividualLeagueStatus(saveData)}');
    }

    // 정규시즌 검증
    final totalCompleted = saveData.currentSeason.proleagueSchedule
        .where((m) => m.isCompleted)
        .length;
    print('');
    print('────────────────────────────────────────');
    print('  정규시즌 완료: $totalCompleted/${schedule.length} 경기');
    print('────────────────────────────────────────');
    expect(totalCompleted, schedule.length, reason: '모든 정규시즌 경기가 완료되어야 합니다');

    // ============================================================
    // 3. 순위 계산
    // ============================================================
    final standings = _calculateStandings(saveData);
    print('');
    print('┌──────────────────────────────────────────────────────────┐');
    print('│               정규시즌 최종 순위                          │');
    print('├────┬──────────────────────┬────┬────┬──────┬─────────────┤');
    print('│ 순위│ 팀명                │  승│  패│ 승점 │  세트(득-실) │');
    print('├────┼──────────────────────┼────┼────┼──────┼─────────────┤');
    for (int i = 0; i < standings.length; i++) {
      final s = standings[i];
      final team = saveData.getTeamById(s.teamId);
      final name = (team?.name ?? s.teamId).padRight(16);
      print('│ ${(i + 1).toString().padLeft(2)} │ $name │${s.wins.toString().padLeft(3)} │'
          '${s.losses.toString().padLeft(3)} │${s.points.toString().padLeft(5)} │'
          ' ${s.setWins.toString().padLeft(3)}-${s.setLosses.toString().padLeft(3)}    │');
    }
    print('└────┴──────────────────────┴────┴────┴──────┴─────────────┘');

    expect(standings.length, 8, reason: '8팀 순위가 모두 있어야 합니다');
    // 각 팀 14경기 완료 확인
    for (final s in standings) {
      expect(s.wins + s.losses, 14,
          reason: '${s.teamId} 팀이 14경기를 치러야 합니다 (현재 ${s.wins + s.losses})');
    }

    // ============================================================
    // 4. 플레이오프
    // ============================================================
    print('');
    print('════════════════════════════════════════════════════');
    print('  플레이오프 시작');
    print('════════════════════════════════════════════════════');

    // 플레이오프 대진표 생성
    final playoff = PlayoffBracket(
      firstPlaceTeamId: standings[0].teamId,
      secondPlaceTeamId: standings[1].teamId,
      thirdPlaceTeamId: standings[2].teamId,
      fourthPlaceTeamId: standings[3].teamId,
    );

    var updatedSeason = saveData.currentSeason
        .updatePlayoff(playoff)
        .updatePhase(SeasonPhase.playoff34);
    saveData = saveData.updateSeason(updatedSeason);

    String teamName(String id) => saveData.getTeamById(id)?.name ?? id;

    // 4-1. 3/4위전
    print('');
    print('── 3/4위전: ${teamName(playoff.thirdPlaceTeamId)} vs ${teamName(playoff.fourthPlaceTeamId)} ──');
    final result34 = _simulatePlayoffMatch(
      saveData: saveData,
      homeTeamId: playoff.thirdPlaceTeamId,
      awayTeamId: playoff.fourthPlaceTeamId,
      rand: rand,
    );
    updatedSeason = saveData.currentSeason
        .updatePlayoff(saveData.currentSeason.playoff!.copyWith(match34: result34))
        .updatePhase(SeasonPhase.individualSemiFinal);
    saveData = saveData.updateSeason(updatedSeason);
    print('  결과: ${teamName(result34.homeTeamId)} ${result34.homeScore}:${result34.awayScore} ${teamName(result34.awayTeamId)}');
    print('  승자: ${teamName(result34.winnerTeamId!)}');

    // 4-2. 개인리그 4강
    print('');
    print('── 개인리그 4강 ──');
    saveData = _simulateIndividualSemiFinal(saveData, ilService);

    // 4-3. 2/3위전
    final winner34 = saveData.currentSeason.playoff!.winner34!;
    print('');
    print('── 2/3위전: ${teamName(playoff.secondPlaceTeamId)} vs ${teamName(winner34)} ──');
    final result23 = _simulatePlayoffMatch(
      saveData: saveData,
      homeTeamId: playoff.secondPlaceTeamId,
      awayTeamId: winner34,
      rand: rand,
    );
    updatedSeason = saveData.currentSeason
        .updatePlayoff(saveData.currentSeason.playoff!.copyWith(match23: result23))
        .updatePhase(SeasonPhase.individualFinal);
    saveData = saveData.updateSeason(updatedSeason);
    print('  결과: ${teamName(result23.homeTeamId)} ${result23.homeScore}:${result23.awayScore} ${teamName(result23.awayTeamId)}');
    print('  승자: ${teamName(result23.winnerTeamId!)}');

    // 4-4. 개인리그 결승
    print('');
    print('── 개인리그 결승 ──');
    saveData = _simulateIndividualFinal(saveData, ilService);

    // 4-5. 프로리그 결승
    final winner23 = saveData.currentSeason.playoff!.winner23!;
    print('');
    print('══ 프로리그 결승: ${teamName(playoff.firstPlaceTeamId)} vs ${teamName(winner23)} ══');
    final resultFinal = _simulatePlayoffMatch(
      saveData: saveData,
      homeTeamId: playoff.firstPlaceTeamId,
      awayTeamId: winner23,
      rand: rand,
    );
    final updatedPlayoff = saveData.currentSeason.playoff!.copyWith(matchFinal: resultFinal);
    updatedSeason = saveData.currentSeason
        .updatePlayoff(updatedPlayoff)
        .complete(
          championId: updatedPlayoff.champion,
          runnerUpId: updatedPlayoff.runnerUp,
        );
    saveData = saveData.updateSeason(updatedSeason);
    print('  결과: ${teamName(resultFinal.homeTeamId)} ${resultFinal.homeScore}:${resultFinal.awayScore} ${teamName(resultFinal.awayTeamId)}');

    // ============================================================
    // 5. 최종 결과 출력
    // ============================================================
    print('');
    print('════════════════════════════════════════════════════');
    print('  시즌 1 최종 결과');
    print('════════════════════════════════════════════════════');
    print('');
    print('  프로리그 우승: ${teamName(saveData.currentSeason.proleagueChampionId!)}');
    print('  프로리그 준우승: ${teamName(saveData.currentSeason.proleagueRunnerUpId!)}');
    print('');

    final bracket = saveData.currentSeason.individualLeague!;
    if (bracket.championId != null) {
      final champion = saveData.getPlayerById(bracket.championId!);
      final runnerUp = saveData.getPlayerById(bracket.runnerUpId!);
      print('  개인리그 우승: ${champion?.name ?? bracket.championId} (${champion?.race.koreanName})');
      print('  개인리그 준우승: ${runnerUp?.name ?? bracket.runnerUpId} (${runnerUp?.race.koreanName})');
    } else {
      print('  개인리그: 우승자 미결정 (오류!)');
    }

    print('');
    print('── 팀별 자금 현황 ──');
    for (final team in saveData.allTeams) {
      print('  ${team.name.padRight(16)} : ${team.money}만원');
    }

    // ============================================================
    // 6. 팀별 시즌 기록 검증
    // ============================================================
    print('');
    print('── 팀별 시즌 기록 (Team.seasonRecord) ──');
    print('  ${'팀명'.padRight(16)}  승  패  세트승 세트패  승률');
    for (final team in saveData.allTeams) {
      final r = team.seasonRecord;
      final wr = r.winRate;
      print('  ${team.name.padRight(16)} '
          '${r.wins.toString().padLeft(3)} '
          '${r.losses.toString().padLeft(3)} '
          '${r.setWins.toString().padLeft(5)} '
          '${r.setLosses.toString().padLeft(5)}  '
          '${(wr * 100).toStringAsFixed(1)}%');

      // 검증: 각 팀은 14경기를 치러야 함
      expect(r.wins + r.losses, 14,
          reason: '${team.name} seasonRecord 14경기 (현재 ${r.wins + r.losses})');
    }

    // record (통산 기록)도 동일해야 함 (시즌 1이므로)
    print('');
    print('── 팀별 통산 기록 (Team.record) ──');
    print('  ${'팀명'.padRight(16)}  승  패  세트승 세트패');
    for (final team in saveData.allTeams) {
      final r = team.record;
      print('  ${team.name.padRight(16)} '
          '${r.wins.toString().padLeft(3)} '
          '${r.losses.toString().padLeft(3)} '
          '${r.setWins.toString().padLeft(5)} '
          '${r.setLosses.toString().padLeft(5)}');

      expect(r.wins + r.losses, 14,
          reason: '${team.name} record 14경기 (현재 ${r.wins + r.losses})');
      // 시즌1이므로 seasonRecord와 record가 동일해야 함
      expect(r.wins, team.seasonRecord.wins,
          reason: '${team.name} record.wins == seasonRecord.wins');
      expect(r.setWins, team.seasonRecord.setWins,
          reason: '${team.name} record.setWins == seasonRecord.setWins');
    }

    // ============================================================
    // 7. 선수별 경기 이력 검증 (프로리그 + 개인리그)
    // ============================================================
    print('');
    print('── 선수별 경기 이력 (프로리그 + 개인리그) ──');

    // 프로리그에 출전한 선수 ID 및 세트 수 수집
    final proleagueSetCounts = <String, int>{};
    for (final item in saveData.currentSeason.proleagueSchedule) {
      if (!item.isCompleted || item.result == null) continue;
      for (final set in item.result!.sets) {
        proleagueSetCounts[set.homePlayerId] =
            (proleagueSetCounts[set.homePlayerId] ?? 0) + 1;
        proleagueSetCounts[set.awayPlayerId] =
            (proleagueSetCounts[set.awayPlayerId] ?? 0) + 1;
      }
    }

    // 개인리그 세트 수 수집 (PC방 예선 제외)
    final individualSetCounts = <String, int>{};
    final ilBracket = saveData.currentSeason.individualLeague!;

    // 듀얼토너먼트 (Bo1 단판)
    for (final result in ilBracket.dualTournamentResults) {
      individualSetCounts[result.player1Id] =
          (individualSetCounts[result.player1Id] ?? 0) + 1;
      individualSetCounts[result.player2Id] =
          (individualSetCounts[result.player2Id] ?? 0) + 1;
    }

    // 본선 (Bo1 또는 시리즈)
    for (final result in ilBracket.mainTournamentResults) {
      if (result.sets.isEmpty) {
        // Bo1 단판
        individualSetCounts[result.player1Id] =
            (individualSetCounts[result.player1Id] ?? 0) + 1;
        individualSetCounts[result.player2Id] =
            (individualSetCounts[result.player2Id] ?? 0) + 1;
      } else {
        // 시리즈 (각 세트)
        individualSetCounts[result.player1Id] =
            (individualSetCounts[result.player1Id] ?? 0) + result.sets.length;
        individualSetCounts[result.player2Id] =
            (individualSetCounts[result.player2Id] ?? 0) + result.sets.length;
      }
    }

    // 전체 예상 세트 수 합산
    final expectedSetCounts = <String, int>{};
    for (final entry in proleagueSetCounts.entries) {
      expectedSetCounts[entry.key] = (expectedSetCounts[entry.key] ?? 0) + entry.value;
    }
    for (final entry in individualSetCounts.entries) {
      expectedSetCounts[entry.key] = (expectedSetCounts[entry.key] ?? 0) + entry.value;
    }

    // 팀별로 정리하여 출력
    int playersWithRecord = 0;
    int playersWithNoRecord = 0;
    int individualOnlyPlayers = 0;

    for (final team in saveData.allTeams) {
      print('');
      print('  [${team.name}]');
      final teamPlayers = saveData.getTeamPlayers(team.id)
        ..sort((a, b) => (b.record.wins + b.record.losses)
            .compareTo(a.record.wins + a.record.losses));

      for (final player in teamPlayers) {
        final r = player.record;
        final totalGames = r.wins + r.losses;
        final proSets = proleagueSetCounts[player.id] ?? 0;
        final ilSets = individualSetCounts[player.id] ?? 0;

        if (totalGames > 0) {
          playersWithRecord++;
          if (proSets == 0 && ilSets > 0) individualOnlyPlayers++;
          final wr = (r.winRate * 100).toStringAsFixed(1);
          final vsT = '${r.vsTerranWins}-${r.vsTerranLosses}';
          final vsZ = '${r.vsZergWins}-${r.vsZergLosses}';
          final vsP = '${r.vsProtossWins}-${r.vsProtossLosses}';
          final streak = r.maxWinStreak > 0 ? '최대${r.maxWinStreak}연승' : '';
          final opponents = r.allOpponentIds.length;
          final source = proSets > 0 && ilSets > 0
              ? 'PL+IL'
              : proSets > 0
                  ? 'PL'
                  : 'IL';
          print('    ${player.name.padRight(10)} ${player.race.koreanName.padRight(4)} '
              '${r.wins.toString().padLeft(2)}승 ${r.losses.toString().padLeft(2)}패 '
              '($wr%) '
              'vsT:$vsT vsZ:$vsZ vsP:$vsP '
              '$streak '
              '상대${opponents}명 [$source]');

          // 검증: 종족별 승패 합 = 총 승패
          expect(r.vsTerranWins + r.vsZergWins + r.vsProtossWins, r.wins,
              reason: '${player.name} 종족별 승리 합 = 총 승리');
          expect(r.vsTerranLosses + r.vsZergLosses + r.vsProtossLosses, r.losses,
              reason: '${player.name} 종족별 패배 합 = 총 패배');

          // 검증: 상대 선수별 기록 합 = 총 승패
          final vsWinSum = r.vsPlayerWins.values.fold(0, (a, b) => a + b);
          final vsLossSum = r.vsPlayerLosses.values.fold(0, (a, b) => a + b);
          expect(vsWinSum, r.wins,
              reason: '${player.name} 상대별 승리 합($vsWinSum) = 총 승리(${r.wins})');
          expect(vsLossSum, r.losses,
              reason: '${player.name} 상대별 패배 합($vsLossSum) = 총 패배(${r.losses})');

          // 검증: 기록된 경기 수 = 프로리그 세트 + 개인리그 세트
          final expectedSets = expectedSetCounts[player.id] ?? 0;
          expect(totalGames, expectedSets,
              reason: '${player.name} record(${totalGames}경기) = 예상(프로$proSets + 개인$ilSets = $expectedSets)');
        } else {
          final expected = expectedSetCounts[player.id] ?? 0;
          if (expected > 0) {
            print('    ${player.name.padRight(10)} ⚠ 출전(예상$expected경기)했으나 record 없음!');
          }
          playersWithNoRecord++;
        }
      }
    }

    print('');
    print('── 선수 기록 요약 ──');
    print('  프로리그 출전 선수: ${proleagueSetCounts.length}명');
    print('  개인리그(PC방제외) 출전 선수: ${individualSetCounts.length}명');
    print('  기록 있는 선수: $playersWithRecord명 (개인리그 only: $individualOnlyPlayers명)');
    print('  기록 없는 선수: $playersWithNoRecord명 (미출전 포함)');

    // 검증: 출전한 선수는 모두 기록이 있어야 함
    for (final playerId in expectedSetCounts.keys) {
      final player = saveData.getPlayerById(playerId);
      if (player != null) {
        final totalGames = player.record.wins + player.record.losses;
        expect(totalGames, greaterThan(0),
            reason: '출전 선수 ${player.name}(${player.id})에 경기 기록이 있어야 합니다');
      }
    }

    // 검증: 개인리그 출전자 중 프로리그 미출전자도 기록이 있어야 함
    final individualOnlyIds = individualSetCounts.keys
        .where((id) => !proleagueSetCounts.containsKey(id))
        .toList();
    print('  개인리그만 출전한 선수: ${individualOnlyIds.length}명');
    for (final playerId in individualOnlyIds) {
      final player = saveData.getPlayerById(playerId);
      if (player != null) {
        final totalGames = player.record.wins + player.record.losses;
        expect(totalGames, greaterThan(0),
            reason: '개인리그 출전 선수 ${player.name}에 경기 기록이 있어야 합니다');
      }
    }

    // 팀별 세트 승/패 합계 검증 (스케줄 기반 vs Team.seasonRecord)
    print('');
    print('── 팀별 세트 승패 교차 검증 (스케줄 vs seasonRecord) ──');
    for (final team in saveData.allTeams) {
      final standingEntry = standings.firstWhere((s) => s.teamId == team.id);
      final r = team.seasonRecord;
      final match = standingEntry.wins == r.wins &&
          standingEntry.losses == r.losses &&
          standingEntry.setWins == r.setWins &&
          standingEntry.setLosses == r.setLosses;
      print('  ${team.name.padRight(16)} '
          'schedule(${standingEntry.wins}W ${standingEntry.losses}L ${standingEntry.setWins}-${standingEntry.setLosses}set) '
          'vs record(${r.wins}W ${r.losses}L ${r.setWins}-${r.setLosses}set) '
          '${match ? "✓" : "✗ 불일치!"}');
      expect(standingEntry.wins, r.wins,
          reason: '${team.name} 스케줄 승수와 seasonRecord 승수 일치');
      expect(standingEntry.setWins, r.setWins,
          reason: '${team.name} 스케줄 세트승과 seasonRecord 세트승 일치');
    }

    // ============================================================
    // 8. 기본 검증
    // ============================================================
    expect(saveData.currentSeason.isCompleted, true, reason: '시즌이 완료 상태여야 합니다');
    expect(saveData.currentSeason.proleagueChampionId, isNotNull, reason: '프로리그 우승팀이 있어야 합니다');
    expect(saveData.currentSeason.proleagueRunnerUpId, isNotNull, reason: '프로리그 준우승팀이 있어야 합니다');
    expect(saveData.currentSeason.individualLeague?.championId, isNotNull,
        reason: '개인리그 우승자가 있어야 합니다');
    expect(saveData.currentSeason.phase, SeasonPhase.seasonEnd, reason: '시즌 단계가 seasonEnd여야 합니다');

    print('');
    print('════════════════════════════════════════════════════');
    print('  시즌 1 시뮬레이션 완료 - 모든 검증 통과');
    print('════════════════════════════════════════════════════');
  });
}

// ================================================================
//  헬퍼 함수들
// ================================================================

/// 프로리그 일정 생성 (SaveRepository._createProleagueSchedule 복제)
List<ScheduleItem> _createProleagueSchedule(List<Team> teams, Random rng) {
  final schedule = <ScheduleItem>[];
  int matchId = 0;

  final firstHalfMatchups = _generateRoundRobinMatchups(teams, rng);

  final rows = List.generate(11, (i) => i);
  rows.shuffle(rng);
  final matchRows = rows.take(7).toList()..sort();

  // 1차 리그 (홀수 슬롯)
  for (int i = 0; i < firstHalfMatchups.length; i++) {
    final matchup = firstHalfMatchups[i];
    final round = i ~/ 4;
    final slot = matchRows[round] * 2 + 1;

    schedule.add(ScheduleItem(
      matchId: 'match_1_${matchId++}',
      roundNumber: slot,
      homeTeamId: matchup[0],
      awayTeamId: matchup[1],
    ));
  }

  // 2차 리그 (짝수 슬롯, 데칼코마니)
  for (int i = 0; i < firstHalfMatchups.length; i++) {
    final matchup = firstHalfMatchups[i];
    final round = i ~/ 4;
    final firstSlot = matchRows[round] * 2 + 1;
    final secondSlot = 23 - firstSlot;

    schedule.add(ScheduleItem(
      matchId: 'match_1_${matchId++}',
      roundNumber: secondSlot,
      homeTeamId: matchup[1],
      awayTeamId: matchup[0],
    ));
  }

  return schedule;
}

/// 풀 라운드 로빈 대진 생성 (서클 메서드)
List<List<String>> _generateRoundRobinMatchups(List<Team> teams, Random rng) {
  final matchups = <List<String>>[];
  final teamIds = teams.map((t) => t.id).toList()..shuffle(rng);
  final n = teamIds.length;

  for (int round = 0; round < n - 1; round++) {
    for (int i = 0; i < n ~/ 2; i++) {
      final home = i == 0 ? teamIds[0] : teamIds[(round + i) % (n - 1) + 1];
      final away = teamIds[(round + n - 1 - i) % (n - 1) + 1];
      if (i == 0) {
        matchups.add([teamIds[0], away]);
      } else {
        matchups.add([home, away]);
      }
    }
  }

  return matchups;
}

/// 해당 슬롯의 모든 경기를 시뮬레이션 (game_provider._simulateNormalMatch 로직)
SaveData _simulateAllMatchesInSlot(SaveData saveData, int slotNumber, Random rand) {
  final season = saveData.currentSeason;
  final schedule = season.proleagueSchedule;

  for (int i = 0; i < schedule.length; i++) {
    final match = schedule[i];
    if (match.roundNumber != slotNumber) continue;
    if (match.isCompleted) continue;

    final homeTeam = saveData.getTeamById(match.homeTeamId);
    final awayTeam = saveData.getTeamById(match.awayTeamId);
    if (homeTeam == null || awayTeam == null) continue;

    final homePlayers = List<Player>.from(saveData.getTeamPlayers(match.homeTeamId))
      ..sort((a, b) => b.stats.total.compareTo(a.stats.total));
    final awayPlayers = List<Player>.from(saveData.getTeamPlayers(match.awayTeamId))
      ..sort((a, b) => b.stats.total.compareTo(a.stats.total));

    if (homePlayers.isEmpty || awayPlayers.isEmpty) continue;

    // 7전 4선승 시뮬레이션
    final List<SetResult> sets = [];
    final updatedPlayersList = <Player>[];
    int homeScore = 0;
    int awayScore = 0;
    int setIndex = 0;

    while (homeScore < 4 && awayScore < 4) {
      final homePlayer = homePlayers[setIndex % homePlayers.length];
      final awayPlayer = awayPlayers[setIndex % awayPlayers.length];

      final homeStrength = homePlayer.stats.applyCondition(homePlayer.displayCondition).total.toDouble();
      final awayStrength = awayPlayer.stats.applyCondition(awayPlayer.displayCondition).total.toDouble();
      final totalStrength = homeStrength + awayStrength;
      final homeWinProb = totalStrength > 0 ? homeStrength / totalStrength : 0.5;

      final homeWin = rand.nextDouble() < homeWinProb;

      if (homeWin) {
        homeScore++;
      } else {
        awayScore++;
      }

      sets.add(SetResult(
        mapId: 'map_$setIndex',
        homePlayerId: homePlayer.id,
        awayPlayerId: awayPlayer.id,
        homeWin: homeWin,
      ));

      // 선수 성장/컨디션 적용
      final updatedHome = homePlayer.applyMatchResult(
        isWin: homeWin,
        opponentGrade: awayPlayer.grade,
        opponentRace: awayPlayer.race,
        opponentId: awayPlayer.id,
      );
      final updatedAway = awayPlayer.applyMatchResult(
        isWin: !homeWin,
        opponentGrade: homePlayer.grade,
        opponentRace: homePlayer.race,
        opponentId: homePlayer.id,
      );
      updatedPlayersList.addAll([updatedHome, updatedAway]);

      setIndex++;
    }

    // 매치 결과 기록
    final matchResult = MatchResult(
      id: match.matchId,
      homeTeamId: match.homeTeamId,
      awayTeamId: match.awayTeamId,
      sets: sets,
      isCompleted: true,
      seasonNumber: season.number,
      roundNumber: match.roundNumber,
    );

    var updatedSeason = saveData.currentSeason.updateMatchResult(i, matchResult);

    // 팀 전적 업데이트
    final winnerIsHome = homeScore > awayScore;
    var updatedHomeTeam = homeTeam.applyMatchResult(
      isWin: winnerIsHome,
      ourSets: homeScore,
      opponentSets: awayScore,
    );
    var updatedAwayTeam = awayTeam.applyMatchResult(
      isWin: !winnerIsHome,
      ourSets: awayScore,
      opponentSets: homeScore,
    );

    saveData = saveData
        .updateSeason(updatedSeason)
        .updateTeam(updatedHomeTeam)
        .updateTeam(updatedAwayTeam)
        .updatePlayers(updatedPlayersList);
  }

  return saveData;
}

/// 개인리그 주차별 진행
SaveData _advanceIndividualLeague(
  SaveData saveData,
  int week,
  IndividualLeagueService ilService,
) {
  var bracket = saveData.currentSeason.individualLeague;
  if (bracket == null) return saveData;

  final playerMap = {for (var p in saveData.allPlayers) p.id: p};

  switch (week) {
    case 1: // PC방 예선
      bracket = ilService.simulateAllPcBangGroups(
        bracket: bracket,
        playerMap: playerMap,
      );
      break;
    case 2: // 듀얼토너먼트 라운드 1
      bracket = ilService.simulateDualTournamentRound(
        bracket: bracket,
        playerMap: playerMap,
        round: 1,
      );
      break;
    case 3: // 듀얼토너먼트 라운드 2
      bracket = ilService.simulateDualTournamentRound(
        bracket: bracket,
        playerMap: playerMap,
        round: 2,
      );
      break;
    case 4: // 듀얼토너먼트 라운드 3
      bracket = ilService.simulateDualTournamentRound(
        bracket: bracket,
        playerMap: playerMap,
        round: 3,
      );
      break;
    case 5: // 조지명식 (듀얼토너먼트 통과자를 본선 8개 조에 배정)
      bracket = _performGroupDraw(bracket, playerMap);
      break;
    case 6: // 32강 전반
      bracket = ilService.simulateRound32Half(
        bracket: bracket,
        playerMap: playerMap,
        half: 1,
      );
      break;
    case 7: // 32강 후반
      bracket = ilService.simulateRound32Half(
        bracket: bracket,
        playerMap: playerMap,
        half: 2,
      );
      break;
    case 8: // 16강 전반
      bracket = ilService.simulateRound16Half(
        bracket: bracket,
        playerMap: playerMap,
        half: 1,
        playerTeamId: saveData.playerTeamId,
      );
      break;
    case 9: // 16강 후반
      bracket = ilService.simulateRound16Half(
        bracket: bracket,
        playerMap: playerMap,
        half: 2,
        playerTeamId: saveData.playerTeamId,
      );
      break;
    case 10: // 8강
      bracket = ilService.simulateQuarterFinalHalf(
        bracket: bracket,
        playerMap: playerMap,
        half: 1,
        playerTeamId: saveData.playerTeamId,
      );
      bracket = ilService.simulateQuarterFinalHalf(
        bracket: bracket,
        playerMap: playerMap,
        half: 2,
        playerTeamId: saveData.playerTeamId,
      );
      break;
  }

  final updatedSeason = saveData.currentSeason.updateIndividualLeague(bracket);
  return saveData.updateSeason(updatedSeason).updatePlayers(playerMap.values.toList());
}

/// 조지명식: 듀얼토너먼트 통과자를 본선 8개 조에 스네이크 드래프트로 배정
/// (앱에서는 group_draw_screen.dart에서 UI로 수행)
IndividualLeagueBracket _performGroupDraw(
  IndividualLeagueBracket bracket,
  Map<String, Player> playerMap,
) {
  // 듀얼토너먼트 결과에서 진출자 추출 (12개 조 × 2명 = 24명)
  final results = bracket.dualTournamentResults;
  final dualQualifiers = <String>[];
  for (var gi = 0; gi < 12; gi++) {
    final groupStart = gi * 5;
    if (results.length >= groupStart + 5) {
      dualQualifiers.add(results[groupStart + 2].winnerId); // 승자전 승자
      dualQualifiers.add(results[groupStart + 4].winnerId); // 최종전 승자
    }
  }

  // 기존 그룹 복사 (각 조 [시드, null, null, null])
  final groups = bracket.mainTournamentGroups
      .map((g) => List<String?>.from(g))
      .toList();

  // 시드 선수 제외
  final seededIds = groups
      .map((g) => g.isNotEmpty && g[0] != null ? g[0]! : '')
      .where((id) => id.isNotEmpty)
      .toSet();
  final available = dualQualifiers
      .where((id) => !seededIds.contains(id))
      .toList();

  // 스네이크 드래프트 3라운드 (앱의 group_draw_screen 로직 재현)
  var pickIndex = 0;
  for (var round = 1; round <= 3; round++) {
    final groupOrder = (round % 2 == 1)
        ? List.generate(8, (i) => i)
        : List.generate(8, (i) => 7 - i);
    final targetSlot = round; // 1=2시드, 2=3시드, 3=4시드

    for (var groupIdx in groupOrder) {
      if (pickIndex < available.length) {
        groups[groupIdx][targetSlot] = available[pickIndex++];
      }
    }
  }

  return bracket.copyWith(
    mainTournamentGroups: groups,
    mainTournamentPlayers: groups.expand((g) => g.whereType<String>()).toList(),
  );
}

/// 개인리그 4강 시뮬레이션
SaveData _simulateIndividualSemiFinal(SaveData saveData, IndividualLeagueService ilService) {
  var bracket = saveData.currentSeason.individualLeague;
  if (bracket == null) return saveData;

  final playerMap = {for (var p in saveData.allPlayers) p.id: p};
  bracket = ilService.simulateSemiFinal(
    bracket: bracket,
    playerMap: playerMap,
    playerTeamId: saveData.playerTeamId,
  );

  final advancers = ilService.getSemiFinalAdvancers(bracket);
  for (int i = 0; i < advancers.length; i++) {
    final player = saveData.getPlayerById(advancers[i]);
    print('  결승 진출: ${player?.name ?? advancers[i]}');
  }

  final updatedSeason = saveData.currentSeason.updateIndividualLeague(bracket);
  return saveData.updateSeason(updatedSeason).updatePlayers(playerMap.values.toList());
}

/// 개인리그 결승 시뮬레이션
SaveData _simulateIndividualFinal(SaveData saveData, IndividualLeagueService ilService) {
  var bracket = saveData.currentSeason.individualLeague;
  if (bracket == null) return saveData;

  final playerMap = {for (var p in saveData.allPlayers) p.id: p};
  bracket = ilService.simulateFinal(
    bracket: bracket,
    playerMap: playerMap,
    playerTeamId: saveData.playerTeamId,
  );

  if (bracket.championId != null) {
    final champion = saveData.getPlayerById(bracket.championId!);
    final runnerUp = saveData.getPlayerById(bracket.runnerUpId!);
    print('  우승: ${champion?.name ?? bracket.championId}');
    print('  준우승: ${runnerUp?.name ?? bracket.runnerUpId}');
  }

  final updatedSeason = saveData.currentSeason.updateIndividualLeague(bracket);
  return saveData.updateSeason(updatedSeason).updatePlayers(playerMap.values.toList());
}

/// 플레이오프 매치 시뮬레이션 (7전4선승)
MatchResult _simulatePlayoffMatch({
  required SaveData saveData,
  required String homeTeamId,
  required String awayTeamId,
  required Random rand,
}) {
  final homePlayers = List<Player>.from(saveData.getTeamPlayers(homeTeamId))
    ..sort((a, b) => b.stats.total.compareTo(a.stats.total));
  final awayPlayers = List<Player>.from(saveData.getTeamPlayers(awayTeamId))
    ..sort((a, b) => b.stats.total.compareTo(a.stats.total));

  final List<SetResult> sets = [];
  int homeScore = 0;
  int awayScore = 0;
  int setIndex = 0;

  while (homeScore < 4 && awayScore < 4) {
    final homePlayer = homePlayers[setIndex % homePlayers.length];
    final awayPlayer = awayPlayers[setIndex % awayPlayers.length];

    final homeStrength = homePlayer.stats.applyCondition(homePlayer.displayCondition).total.toDouble();
    final awayStrength = awayPlayer.stats.applyCondition(awayPlayer.displayCondition).total.toDouble();
    final totalStrength = homeStrength + awayStrength;
    final homeWinProb = totalStrength > 0 ? homeStrength / totalStrength : 0.5;

    final homeWin = rand.nextDouble() < homeWinProb;

    if (homeWin) {
      homeScore++;
    } else {
      awayScore++;
    }

    sets.add(SetResult(
      mapId: 'map_$setIndex',
      homePlayerId: homePlayer.id,
      awayPlayerId: awayPlayer.id,
      homeWin: homeWin,
    ));
    setIndex++;
  }

  return MatchResult(
    id: 'playoff_${homeTeamId}_vs_$awayTeamId',
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    sets: sets,
    isCompleted: true,
    seasonNumber: 1,
    roundNumber: 0,
  );
}

/// 순위 계산 (game_provider.calculateStandings 로직)
List<TeamStanding> _calculateStandings(SaveData saveData) {
  final standings = <String, TeamStanding>{};

  for (final team in saveData.allTeams) {
    standings[team.id] = TeamStanding(teamId: team.id);
  }

  for (final item in saveData.currentSeason.proleagueSchedule) {
    if (!item.isCompleted || item.result == null) continue;

    final result = item.result!;
    standings[result.homeTeamId] = standings[result.homeTeamId]!.addResult(
      isWin: result.isHomeWin,
      ourSets: result.homeScore,
      opponentSets: result.awayScore,
    );
    standings[result.awayTeamId] = standings[result.awayTeamId]!.addResult(
      isWin: result.isAwayWin,
      ourSets: result.awayScore,
      opponentSets: result.homeScore,
    );
  }

  // 상대전적 계산
  final headToHead = <String, Map<String, (int, int)>>{};
  for (final item in saveData.currentSeason.proleagueSchedule) {
    if (!item.isCompleted || item.result == null) continue;
    final result = item.result!;
    final home = result.homeTeamId;
    final away = result.awayTeamId;
    final homeWin = result.isHomeWin;

    headToHead.putIfAbsent(home, () => {});
    final (hw, hl) = headToHead[home]![away] ?? (0, 0);
    headToHead[home]![away] = homeWin ? (hw + 1, hl) : (hw, hl + 1);

    headToHead.putIfAbsent(away, () => {});
    final (aw, al) = headToHead[away]![home] ?? (0, 0);
    headToHead[away]![home] = homeWin ? (aw, al + 1) : (aw + 1, al);
  }

  final sorted = standings.values.toList()
    ..sort((a, b) {
      if (a.points != b.points) return b.points - a.points;
      if (a.setDiff != b.setDiff) return b.setDiff - a.setDiff;
      final aVsB = headToHead[a.teamId]?[b.teamId];
      if (aVsB != null) {
        final (aWins, aLosses) = aVsB;
        if (aWins != aLosses) return aWins > aLosses ? -1 : 1;
      }
      return 0;
    });

  return sorted;
}

/// 개인리그 현재 상태 문자열
String _getIndividualLeagueStatus(SaveData saveData) {
  final bracket = saveData.currentSeason.individualLeague;
  if (bracket == null) return '없음';
  if (bracket.championId != null) return '완료 (우승: ${bracket.championId})';

  final mainResults = bracket.mainTournamentResults.length;
  if (mainResults > 0) return '본선 진행중 (결과 $mainResults건)';

  final dualResults = bracket.dualTournamentResults.length;
  if (dualResults > 0) return '듀얼토너먼트 (결과 $dualResults건)';

  final pcBangResults = bracket.pcBangResults.length;
  if (pcBangResults > 0) return 'PC방 예선 완료 (${bracket.dualTournamentPlayers.length}명 진출)';

  return '대기';
}
