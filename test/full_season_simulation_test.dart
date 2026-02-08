/// 전체 시즌 E2E 통합 시뮬레이션 테스트
///
/// 시즌 1회전 전체 흐름:
///   startNewGame → 정규시즌 28경기(56 ScheduleItem) → 개인리그 → 플레이오프 → 시즌완료 → 다음 시즌
///
/// === 코드 분석 노트 (Phase 2에서 활용) ===
///
/// [GameStateNotifier 사용 전략]
/// GameStateNotifier는 StateNotifier<GameState?>로, SaveRepository(Hive 기반)에 의존.
/// 테스트에서 Hive를 초기화하기 어렵기 때문에 서비스 레벨에서 직접 테스트하는 것이 적합.
/// - SaveData를 직접 생성하여 GameState 래핑
/// - Season, Team, Player 모델을 직접 조작
/// - MatchSimulationService, IndividualLeagueService, PlayoffService를 직접 호출
///
/// [시즌 전체 흐름]
/// 1. 새 게임 생성: SaveRepository.createNewGame() → SaveData
///    - 8팀 (InitialData.createTeams()) + 각 팀 10명
///    - Season(number: 1, proleagueSchedule: 56경기, phase: regularSeason)
///    - 56경기 = 8팀 풀라운드로빈×2 (28매치업×2=56 ScheduleItem)
///
/// 2. 정규시즌 진행: recordMatchResult() 반복
///    - 플레이어 팀 매치: matchSimulationService.simulateMatch()
///    - 다른 팀 매치: _simulateOtherMatchesInRound() 자동 처리
///    - 2경기마다: applyTwoMatchBonus() → 행동력+100, 컨디션+5, AI팀 행동
///    - 개인리그는 별도 시점에 진행 (정규시즌 중간에 PC방 예선 등)
///
/// 3. 정규시즌 완료 → checkAndTransitionToPlayoff()
///    - 모든 56경기 완료 + 개인리그 8강 완료 시 playoffReady로 전환
///
/// 4. 플레이오프 3,4위전: recordPlayoffMatchResult(thirdFourth)
///    - playoff34 단계 → individualSemiFinal 전환
///
/// 5. 개인리그 4강: bracket.simulateMainTournament() 부분 수행
///    - individualSemiFinal → playoff23 전환
///
/// 6. 플레이오프 2,3위전: recordPlayoffMatchResult(secondThird)
///    - playoff23 → individualFinal 전환
///
/// 7. 개인리그 결승
///    - individualFinal → playoffFinal 전환
///
/// 8. 플레이오프 결승: recordPlayoffMatchResult(final_)
///    - playoffFinal → seasonEnd 전환
///    - 우승/준우승 상금 지급 (150만/70만)
///
/// 9. 시즌 완료: completeSeasonAndPrepareNext()
///    - 모든 선수 advanceCareer() (careerSeasons +1)
///    - 노장 은퇴 체크 (30% 확률)
///    - 신인 3~5명 생성 → 부족한 팀에 배분
///    - 무소속 11~12명 생성
///    - 새 시즌 생성: _createNewSeason(seasonNumber + 1)
///    - startNewSeason() → 이전 시즌 히스토리 저장, 팀 리셋
///
/// [일정 구조]
/// - 8팀 서클 메서드: 7라운드×4경기 = 28매치업 (1차)
/// - 2차: 28매치업 홈/어웨이 반전 + 데칼코마니 슬롯 배정
/// - 총 56 ScheduleItem, roundNumber는 슬롯 번호 (1~22)
///
/// [순위 계산]
/// calculateStandings(): 승점(승리×3) → 세트득실 → 상대전적 → 동률
///
/// [개인리그 전체 흐름]
/// IndividualLeagueService:
/// 1. createIndividualLeagueBracket() → 조지명식 8명 + 듀얼 24명 + PC방 예선
/// 2. simulateAllPcBangGroups() → PC방 예선 24조 시뮬
/// 3. simulateDualTournament() → 24명→8명 진출
/// 4. simulateMainTournament() → 8강→4강→결승
///
/// [PlayoffBracket 구조]
/// - firstPlaceTeamId, secondPlaceTeamId, thirdPlaceTeamId, fourthPlaceTeamId
/// - match34, match23, matchFinal (각각 MatchResult?)
/// - 3,4위전 승자 → 2,3위전 → 결승전 (1위 vs 2,3위전 승자)
///

import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';
import 'package:mystar/domain/services/individual_league_service.dart';
import 'package:mystar/domain/services/playoff_service.dart';

// ============================================================
// 테스트 헬퍼 함수
// ============================================================

/// 테스트용 선수 생성
/// totalStats 범위로 등급 결정 (B-~A+ 범위)
Player createTestPlayer({
  required String id,
  required String name,
  required Race race,
  required String teamId,
  int totalStatBase = 3200, // 기본 B+ 등급
  int levelValue = 5,
  int condition = 100,
}) {
  // 8개 스탯에 균등 분배 + 약간 랜덤
  final base = totalStatBase ~/ 8;
  final rng = Random(id.hashCode);
  return Player(
    id: id,
    name: name,
    raceIndex: race.index,
    stats: PlayerStats(
      sense: base + rng.nextInt(60) - 30,
      control: base + rng.nextInt(60) - 30,
      attack: base + rng.nextInt(60) - 30,
      harass: base + rng.nextInt(60) - 30,
      strategy: base + rng.nextInt(60) - 30,
      macro: base + rng.nextInt(60) - 30,
      defense: base + rng.nextInt(60) - 30,
      scout: base + rng.nextInt(60) - 30,
    ),
    levelValue: levelValue,
    condition: condition,
    teamId: teamId,
  );
}

/// 테스트용 8개 팀 생성 (각 팀 10명)
/// 반환: (teams, allPlayers)
(List<Team>, List<Player>) createTestTeamsAndPlayers() {
  final races = [Race.terran, Race.zerg, Race.protoss];
  final teamConfigs = [
    ('team_kt', 'KT 롤스터', 'KT', 0xFF1428A0),
    ('team_samsung', '삼성전자 칸', 'SAM', 0xFF0047AB),
    ('team_stx', 'STX SouL', 'STX', 0xFFFF6B00),
    ('team_skt', 'SK텔레콤 T1', 'SKT', 0xFFE60012),
    ('team_woongjin', '웅진 스타즈', 'WJS', 0xFF006400),
    ('team_cj', 'CJ 엔투스', 'CJ', 0xFFFF0000),
    ('team_airforce', '공군 ACE', 'ACE', 0xFF808080),
    ('team_8th', '제8게임단', 'T8', 0xFF9400D3),
  ];

  final teams = <Team>[];
  final allPlayers = <Player>[];

  for (var i = 0; i < teamConfigs.length; i++) {
    final (teamId, teamName, shortName, color) = teamConfigs[i];
    final playerIds = <String>[];

    // 각 팀 10명 (에이스 1명 + 서브 에이스 2명 + 일반 7명)
    for (var j = 0; j < 10; j++) {
      final playerId = '${teamId}_p$j';
      playerIds.add(playerId);

      final race = races[(i * 3 + j) % 3];
      int statBase;
      if (j == 0) {
        statBase = 4400 + (i * 50); // 에이스: A+ (4400~4750)
      } else if (j < 3) {
        statBase = 3600 + (j * 100); // 서브: A- (3600~3800)
      } else {
        statBase = 2800 + (j * 30); // 일반: B ~ B+ (2800~3070)
      }

      allPlayers.add(createTestPlayer(
        id: playerId,
        name: '선수_${shortName}_$j',
        race: race,
        teamId: teamId,
        totalStatBase: statBase,
        levelValue: j < 3 ? 7 : 4,
      ));
    }

    teams.add(Team(
      id: teamId,
      name: teamName,
      shortName: shortName,
      colorValue: color,
      playerIds: playerIds,
      acePlayerId: playerIds[0],
      money: 100,
      actionPoints: 300,
      isPlayerTeam: i == 0, // KT가 플레이어 팀
    ));
  }

  return (teams, allPlayers);
}

/// 테스트용 시즌 생성 (8팀 풀 라운드로빈 ×2 = 56경기)
Season createTestSeason({int seasonNumber = 1, required List<Team> teams}) {
  final rng = Random(42);

  // 시즌맵 7개 선정
  final allMapIds = GameMaps.all.map((m) => m.id).toList();
  final shuffledMaps = List<String>.from(allMapIds)..shuffle(rng);
  final seasonMaps = shuffledMaps.take(7).toList();

  // 서클 메서드로 풀 라운드 로빈 대진 생성
  final teamIds = teams.map((t) => t.id).toList()..shuffle(rng);
  final n = teamIds.length;
  final firstHalfMatchups = <List<String>>[];

  for (int round = 0; round < n - 1; round++) {
    for (int i = 0; i < n ~/ 2; i++) {
      final home = i == 0 ? teamIds[0] : teamIds[(round + i) % (n - 1) + 1];
      final away = teamIds[(round + n - 1 - i) % (n - 1) + 1];
      if (i == 0) {
        firstHalfMatchups.add([teamIds[0], away]);
      } else {
        firstHalfMatchups.add([home, away]);
      }
    }
  }

  // 11행 중 7행 선택
  final rows = List.generate(11, (i) => i)..shuffle(rng);
  final matchRows = rows.take(7).toList()..sort();

  final schedule = <ScheduleItem>[];
  int matchId = 0;

  // 1차 리그
  for (int i = 0; i < firstHalfMatchups.length; i++) {
    final matchup = firstHalfMatchups[i];
    final round = i ~/ 4;
    final slot = matchRows[round] * 2 + 1;
    schedule.add(ScheduleItem(
      matchId: 'match_${seasonNumber}_${matchId++}',
      roundNumber: slot,
      homeTeamId: matchup[0],
      awayTeamId: matchup[1],
    ));
  }

  // 2차 리그 (홈/어웨이 반전, 데칼코마니)
  for (int i = 0; i < firstHalfMatchups.length; i++) {
    final matchup = firstHalfMatchups[i];
    final round = i ~/ 4;
    final firstSlot = matchRows[round] * 2 + 1;
    final secondSlot = 23 - firstSlot;
    schedule.add(ScheduleItem(
      matchId: 'match_${seasonNumber}_${matchId++}',
      roundNumber: secondSlot,
      homeTeamId: matchup[1],
      awayTeamId: matchup[0],
    ));
  }

  return Season(
    number: seasonNumber,
    seasonMapIds: seasonMaps,
    proleagueSchedule: schedule,
    currentMatchIndex: 0,
    matchesSinceLastBonus: 0,
    phaseIndex: SeasonPhase.regularSeason.index,
  );
}

/// 테스트용 SaveData 생성
SaveData createTestSaveData() {
  final (teams, allPlayers) = createTestTeamsAndPlayers();
  final season = createTestSeason(teams: teams);

  return SaveData(
    slotNumber: 1,
    playerTeamId: 'team_kt',
    allPlayers: allPlayers,
    allTeams: teams,
    currentSeason: season,
    savedAt: DateTime.now(),
  );
}

/// 모든 정규시즌 경기 시뮬레이션 (서비스 레벨)
/// 반환: 업데이트된 SaveData
SaveData simulateFullRegularSeason(SaveData saveData) {
  final matchService = MatchSimulationService();
  final rand = Random(123);
  var data = saveData;

  final schedule = data.currentSeason.proleagueSchedule;
  for (int idx = 0; idx < schedule.length; idx++) {
    final match = schedule[idx];
    if (match.isCompleted) continue;

    final homeTeam = data.getTeamById(match.homeTeamId);
    final awayTeam = data.getTeamById(match.awayTeamId);
    if (homeTeam == null || awayTeam == null) continue;

    final homePlayers = data.getTeamPlayers(match.homeTeamId)
      ..sort((a, b) => b.stats.total.compareTo(a.stats.total));
    final awayPlayers = data.getTeamPlayers(match.awayTeamId)
      ..sort((a, b) => b.stats.total.compareTo(a.stats.total));

    if (homePlayers.isEmpty || awayPlayers.isEmpty) continue;

    // 7전4선승 시뮬레이션
    final sets = <SetResult>[];
    int homeScore = 0;
    int awayScore = 0;
    int setIndex = 0;

    while (homeScore < 4 && awayScore < 4) {
      final homePlayer = homePlayers[setIndex % homePlayers.length];
      final awayPlayer = awayPlayers[setIndex % awayPlayers.length];

      final homeStrength = homePlayer.stats.applyCondition(homePlayer.displayCondition).total.toDouble();
      final awayStrength = awayPlayer.stats.applyCondition(awayPlayer.displayCondition).total.toDouble();
      final total = homeStrength + awayStrength;
      final homeWinProb = total > 0 ? homeStrength / total : 0.5;
      final homeWin = rand.nextDouble() < homeWinProb;

      if (homeWin) homeScore++; else awayScore++;

      sets.add(SetResult(
        mapId: 'map_$setIndex',
        homePlayerId: homePlayer.id,
        awayPlayerId: awayPlayer.id,
        homeWin: homeWin,
      ));
      setIndex++;
    }

    // 결과 기록
    final matchResult = MatchResult(
      id: match.matchId,
      homeTeamId: match.homeTeamId,
      awayTeamId: match.awayTeamId,
      sets: sets,
      isCompleted: true,
      seasonNumber: data.currentSeason.number,
      roundNumber: match.roundNumber,
    );

    var updatedSeason = data.currentSeason.updateMatchResult(idx, matchResult);

    // 팀 전적 업데이트
    final homeWin = homeScore > awayScore;
    var updatedHome = homeTeam.applyMatchResult(
      isWin: homeWin,
      ourSets: homeScore,
      opponentSets: awayScore,
    );
    var updatedAway = awayTeam.applyMatchResult(
      isWin: !homeWin,
      ourSets: awayScore,
      opponentSets: homeScore,
    );

    data = data
        .updateSeason(updatedSeason)
        .updateTeam(updatedHome)
        .updateTeam(updatedAway);
  }

  return data;
}

/// 플레이오프 전체 시뮬레이션 (서비스 레벨)
/// 반환: (업데이트된 SaveData, PlayoffBracket)
(SaveData, PlayoffBracket) simulateFullPlayoff(
  SaveData saveData,
  List<TeamStanding> standings,
) {
  var data = saveData;
  final rand = Random(456);

  // 플레이오프 대진표 생성
  var playoff = PlayoffBracket(
    firstPlaceTeamId: standings[0].teamId,
    secondPlaceTeamId: standings[1].teamId,
    thirdPlaceTeamId: standings[2].teamId,
    fourthPlaceTeamId: standings[3].teamId,
  );

  // 3,4위전
  final match34Result = _simulatePlayoffMatch(
    data, playoff.thirdPlaceTeamId, playoff.fourthPlaceTeamId, rand,
  );
  playoff = playoff.copyWith(match34: match34Result);

  // 2,3위전 (2위 vs 3,4위전 승자)
  final match23Result = _simulatePlayoffMatch(
    data, playoff.secondPlaceTeamId, playoff.winner34!, rand,
  );
  playoff = playoff.copyWith(match23: match23Result);

  // 결승 (1위 vs 2,3위전 승자)
  final matchFinalResult = _simulatePlayoffMatch(
    data, playoff.firstPlaceTeamId, playoff.winner23!, rand,
  );
  playoff = playoff.copyWith(matchFinal: matchFinalResult);

  // 시즌 업데이트
  var updatedSeason = data.currentSeason
      .updatePlayoff(playoff)
      .updatePhase(SeasonPhase.seasonEnd)
      .complete(
        championId: playoff.champion,
        runnerUpId: playoff.runnerUp,
      );

  data = data.updateSeason(updatedSeason);

  return (data, playoff);
}

/// 플레이오프 단일 매치 시뮬레이션 헬퍼
MatchResult _simulatePlayoffMatch(
  SaveData data, String homeTeamId, String awayTeamId, Random rand,
) {
  final sets = <SetResult>[];
  int homeScore = 0;
  int awayScore = 0;
  int setIndex = 0;

  final homePlayers = data.getTeamPlayers(homeTeamId)
    ..sort((a, b) => b.stats.total.compareTo(a.stats.total));
  final awayPlayers = data.getTeamPlayers(awayTeamId)
    ..sort((a, b) => b.stats.total.compareTo(a.stats.total));

  while (homeScore < 4 && awayScore < 4 && homePlayers.isNotEmpty && awayPlayers.isNotEmpty) {
    final hp = homePlayers[setIndex % homePlayers.length];
    final ap = awayPlayers[setIndex % awayPlayers.length];
    final homeStr = hp.stats.total.toDouble();
    final awayStr = ap.stats.total.toDouble();
    final homeWin = rand.nextDouble() < (homeStr / (homeStr + awayStr));

    if (homeWin) homeScore++; else awayScore++;

    sets.add(SetResult(
      mapId: 'playoff_map_$setIndex',
      homePlayerId: hp.id,
      awayPlayerId: ap.id,
      homeWin: homeWin,
    ));
    setIndex++;
  }

  return MatchResult(
    id: 'playoff_${homeTeamId}_$awayTeamId',
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    sets: sets,
    isCompleted: true,
  );
}

/// 순위 계산 (PlayoffService 또는 직접)
List<TeamStanding> calculateStandings(SaveData data) {
  final playoffService = PlayoffService();
  return playoffService.calculateStandings(
    data.currentSeason.proleagueSchedule,
    data.allTeams.map((t) => t.id).toList(),
  );
}

/// 개인리그 전체 시뮬레이션 헬퍼
IndividualLeagueBracket simulateFullIndividualLeague(SaveData data) {
  final service = IndividualLeagueService();
  final playerMap = {for (var p in data.allPlayers) p.id: p};

  // 1. 브래킷 생성
  var bracket = service.createIndividualLeagueBracket(
    allPlayers: data.allPlayers,
    playerTeamId: data.playerTeamId,
    seasonNumber: data.currentSeason.number,
  );

  // 2. PC방 예선
  bracket = service.simulateAllPcBangGroups(
    bracket: bracket,
    playerMap: playerMap,
  );

  // 3. 듀얼토너먼트
  bracket = service.simulateDualTournament(
    bracket: bracket,
    playerMap: playerMap,
  );

  // 4. 본선 (8강~결승)
  bracket = service.simulateMainTournament(
    bracket: bracket,
    playerMap: playerMap,
  );

  return bracket;
}

// ============================================================
// 테스트
// ============================================================

void main() {
  group('시즌 1회전 통합', () {
    test('새 게임 데이터 구조가 올바르게 생성된다', () {
      // TODO: Phase 2
      // - SaveData 생성 후 8팀, 80명 선수 확인
      // - Season number == 1
      // - proleagueSchedule.length == 56
      // - 모든 팀이 14경기(홈 7, 어웨이 7) 배정되었는지 확인
      // - 시즌맵 7개 선정 확인
      // - phase == SeasonPhase.regularSeason
      final data = createTestSaveData();

      expect(data.allTeams.length, 8);
      expect(data.allPlayers.length, 80);
      expect(data.currentSeason.number, 1);
      expect(data.currentSeason.proleagueSchedule.length, 56);
      expect(data.currentSeason.phase, SeasonPhase.regularSeason);
      expect(data.currentSeason.seasonMapIds.length, 7);

      // 각 팀 14경기 (홈 7 + 어웨이 7)
      for (final team in data.allTeams) {
        final homeCount = data.currentSeason.proleagueSchedule
            .where((s) => s.homeTeamId == team.id).length;
        final awayCount = data.currentSeason.proleagueSchedule
            .where((s) => s.awayTeamId == team.id).length;
        expect(homeCount + awayCount, 14,
            reason: '${team.shortName} should have 14 matches');
      }
    });

    test('정규시즌 56경기 전부 완료된다', () {
      // TODO: Phase 2
      // - simulateFullRegularSeason() 실행
      // - 모든 56경기 isCompleted == true
      // - 각 팀 wins + losses == 14
      // - 총 승리 수 == 총 패배 수 == 56
      // - 모든 세트 결과가 4-x 또는 x-4 형태
      final data = createTestSaveData();
      final afterSeason = simulateFullRegularSeason(data);

      final schedule = afterSeason.currentSeason.proleagueSchedule;
      expect(schedule.every((s) => s.isCompleted), isTrue);

      int totalWins = 0;
      int totalLosses = 0;
      for (final team in afterSeason.allTeams) {
        final record = team.seasonRecord;
        expect(record.wins + record.losses, 14,
            reason: '${team.shortName} should have 14 total matches');
        totalWins += record.wins;
        totalLosses += record.losses;
      }
      expect(totalWins, 56, reason: 'Total wins should equal 56 matches');
      expect(totalLosses, 56, reason: 'Total losses should equal 56 matches');

      // 모든 매치 결과가 유효한 세트 점수인지 확인 (4-x 형태)
      for (final item in schedule) {
        final result = item.result!;
        final homeScore = result.homeScore;
        final awayScore = result.awayScore;
        expect(homeScore >= 4 || awayScore >= 4, isTrue,
            reason: 'Winner must have 4 sets');
        expect(homeScore + awayScore >= 4 && homeScore + awayScore <= 7, isTrue,
            reason: 'Total sets should be 4-7');
      }
    });

    test('순위 계산이 올바르다', () {
      // TODO: Phase 2
      // - 정규시즌 완료 후 calculateStandings()
      // - 8팀 순위 반환
      // - 승점 내림차순 정렬
      // - 모든 팀의 wins + losses == 14
      // - 총 승점 == 총 승리 수 × 3
      final data = createTestSaveData();
      final afterSeason = simulateFullRegularSeason(data);
      final standings = calculateStandings(afterSeason);

      expect(standings.length, 8);

      // 내림차순 정렬 확인
      for (int i = 0; i < standings.length - 1; i++) {
        expect(standings[i].points >= standings[i + 1].points, isTrue,
            reason: 'Standings should be sorted by points descending');
      }

      // 승점 합계 = 승리 수 × 3
      int totalPoints = standings.fold(0, (sum, s) => sum + s.points);
      int totalWins = standings.fold(0, (sum, s) => sum + s.wins);
      expect(totalPoints, totalWins * 3);
    });

    test('플레이오프가 올바르게 진행된다', () {
      // TODO: Phase 2
      // - 상위 4팀으로 PlayoffBracket 생성
      // - 3,4위전 → 2,3위전 → 결승 순서
      // - 각 매치 결과의 homeTeamId/awayTeamId가 올바른지 확인
      // - champion과 runnerUp이 결정되는지 확인
      final data = createTestSaveData();
      final afterSeason = simulateFullRegularSeason(data);
      final standings = calculateStandings(afterSeason);

      final (afterPlayoff, playoff) = simulateFullPlayoff(afterSeason, standings);

      // 3,4위전 결과 확인
      expect(playoff.match34, isNotNull);
      expect(playoff.match34!.isCompleted, isTrue);
      expect(
        {playoff.match34!.homeTeamId, playoff.match34!.awayTeamId},
        {standings[2].teamId, standings[3].teamId},
      );

      // 2,3위전 결과 확인
      expect(playoff.match23, isNotNull);
      expect(playoff.match23!.isCompleted, isTrue);
      expect(playoff.match23!.homeTeamId, standings[1].teamId);

      // 결승 결과 확인
      expect(playoff.matchFinal, isNotNull);
      expect(playoff.matchFinal!.isCompleted, isTrue);
      expect(playoff.matchFinal!.homeTeamId, standings[0].teamId);

      // 우승/준우승 결정 확인
      expect(playoff.champion, isNotNull);
      expect(playoff.runnerUp, isNotNull);
      expect(playoff.champion != playoff.runnerUp, isTrue);

      // 시즌 완료 상태 확인
      expect(afterPlayoff.currentSeason.phase, SeasonPhase.seasonEnd);
      expect(afterPlayoff.currentSeason.isCompleted, isTrue);
    });

    test('개인리그가 올바르게 진행된다', () {
      // TODO: Phase 2
      // - IndividualLeagueBracket 생성
      // - PC방 예선: 24조, 각 조 4명, 우승자 24명
      // - 듀얼토너먼트: 24명→8명 진출
      // - 본선: 8강→4강→결승
      // - championId, runnerUpId, top8Players 확인
      final data = createTestSaveData();
      final bracket = simulateFullIndividualLeague(data);

      // PC방 예선 조 편성 확인
      expect(bracket.pcBangGroups.length, 24);
      for (final group in bracket.pcBangGroups) {
        expect(group.length, 4, reason: 'Each PC bang group should have 4 players');
      }

      // PC방 결과 존재 확인
      expect(bracket.pcBangResults.isNotEmpty, isTrue);

      // 듀얼토너먼트 결과 확인
      expect(bracket.dualTournamentResults.isNotEmpty, isTrue);

      // 본선 진출자 확인
      expect(bracket.mainTournamentPlayers.length, 8);

      // 8강 결과 확인 (4경기)
      final quarterFinals = bracket.mainTournamentResults
          .where((r) => r.stage == IndividualLeagueStage.quarterFinal);
      expect(quarterFinals.length, 4);

      // 4강 결과 확인 (2경기)
      final semiFinals = bracket.mainTournamentResults
          .where((r) => r.stage == IndividualLeagueStage.semiFinal);
      expect(semiFinals.length, 2);

      // 결승 결과 확인 (1경기)
      final finals = bracket.mainTournamentResults
          .where((r) => r.stage == IndividualLeagueStage.final_);
      expect(finals.length, 1);

      // 우승자/준우승자 결정 확인
      expect(bracket.championId, isNotNull);
      expect(bracket.runnerUpId, isNotNull);
      expect(bracket.championId != bracket.runnerUpId, isTrue);

      // top8 순위 확인
      expect(bracket.top8Players.length, 8);
      expect(bracket.top8Players[0], bracket.championId);
      expect(bracket.top8Players[1], bracket.runnerUpId);
    });

    test('시즌 전체 흐름 (정규시즌→플레이오프→시즌완료)이 일관된다', () {
      // TODO: Phase 2
      // - 전체 시즌 흐름을 순서대로 진행
      // - 각 단계의 phase 전환 확인
      // - 최종 상태 검증
      final data = createTestSaveData();

      // 1. 정규시즌
      var current = simulateFullRegularSeason(data);
      expect(current.currentSeason.proleagueSchedule.every((s) => s.isCompleted), isTrue);

      // 2. 개인리그
      final bracket = simulateFullIndividualLeague(current);
      current = current.updateSeason(
        current.currentSeason.updateIndividualLeague(bracket),
      );
      expect(current.currentSeason.individualLeague?.championId, isNotNull);

      // 3. 플레이오프
      final standings = calculateStandings(current);
      final (afterPlayoff, playoff) = simulateFullPlayoff(current, standings);
      current = afterPlayoff;

      expect(current.currentSeason.isCompleted, isTrue);
      expect(current.currentSeason.phase, SeasonPhase.seasonEnd);
      expect(current.currentSeason.playoff?.champion, isNotNull);
    });
  });

  group('2시즌 연속', () {
    test('시즌 완료 후 새 시즌이 올바르게 생성된다', () {
      // TODO: Phase 2
      // - 1시즌 완료
      // - startNewSeason() 호출
      // - 새 시즌 number == 2
      // - 새 일정 56경기 생성
      // - 이전 시즌 히스토리 저장
      // - 팀 seasonRecord 리셋 확인
      // - 행동력 0 리셋 확인
      final data = createTestSaveData();
      var current = simulateFullRegularSeason(data);

      // 개인리그 시뮬
      final bracket = simulateFullIndividualLeague(current);
      current = current.updateSeason(
        current.currentSeason.updateIndividualLeague(bracket),
      );

      // 플레이오프
      final standings = calculateStandings(current);
      final (afterPlayoff, _) = simulateFullPlayoff(current, standings);
      current = afterPlayoff;

      // 새 시즌 생성
      final newSeason = createTestSeason(seasonNumber: 2, teams: current.allTeams);
      final history = SeasonHistory(
        seasonNumber: current.currentSeason.number,
        proleagueChampionId: current.currentSeason.proleagueChampionId,
        proleagueRunnerUpId: current.currentSeason.proleagueRunnerUpId,
        individualChampionId: current.currentSeason.individualLeague?.championId,
        individualRunnerUpId: current.currentSeason.individualLeague?.runnerUpId,
      );

      final newTeams = current.allTeams.map((t) => t.resetForNewSeason()).toList();
      current = current.copyWith(
        currentSeason: newSeason,
        seasonHistories: [...current.seasonHistories, history],
        allTeams: newTeams,
        previousSeasonIndividualLeague: current.currentSeason.individualLeague,
      );

      // 검증
      expect(current.currentSeason.number, 2);
      expect(current.currentSeason.proleagueSchedule.length, 56);
      expect(current.currentSeason.phase, SeasonPhase.regularSeason);
      expect(current.seasonHistories.length, 1);
      expect(current.seasonHistories[0].seasonNumber, 1);

      // 팀 리셋 확인
      for (final team in current.allTeams) {
        expect(team.seasonRecord.wins, 0);
        expect(team.seasonRecord.losses, 0);
        expect(team.actionPoints, 0);
      }
    });

    test('이전 시즌 개인리그 시드가 다음 시즌에 반영된다', () {
      // TODO: Phase 2
      // - 1시즌 개인리그 top8Players 저장
      // - 2시즌 createIndividualLeagueBracket()에 previousSeasonBracket 전달
      // - mainTournamentSeeds에 이전 시즌 top8이 포함되는지 확인
      final data = createTestSaveData();
      var current = simulateFullRegularSeason(data);

      // 1시즌 개인리그
      final bracket1 = simulateFullIndividualLeague(current);
      current = current.updateSeason(
        current.currentSeason.updateIndividualLeague(bracket1),
      );

      final top8Season1 = bracket1.top8Players;
      expect(top8Season1.length, 8);

      // 2시즌 개인리그 브래킷 생성 (이전 시즌 반영)
      final service = IndividualLeagueService();
      final bracket2 = service.createIndividualLeagueBracket(
        allPlayers: current.allPlayers,
        playerTeamId: current.playerTeamId,
        seasonNumber: 2,
        previousSeasonBracket: bracket1,
      );

      // 이전 시즌 top8이 mainTournamentSeeds에 포함
      for (final playerId in top8Season1) {
        // 아마추어가 아닌 실제 선수만 확인
        if (!playerId.startsWith('amateur_')) {
          final player = current.allPlayers.cast<Player?>().firstWhere(
            (p) => p?.id == playerId, orElse: () => null,
          );
          if (player != null) {
            expect(bracket2.mainTournamentSeeds.contains(playerId), isTrue,
                reason: '$playerId (prev top8) should be in mainTournamentSeeds');
          }
        }
      }
    });
  });

  group('데이터 일관성', () {
    test('선수 전적이 시즌 경기 수와 일치한다', () {
      // TODO: Phase 2
      // - 정규시즌 완료 후 각 팀의 세트 승패 합 ==
      //   해당 팀이 출전한 경기의 세트 합
      // - 팀 wins + losses == 14
      final data = createTestSaveData();
      final afterSeason = simulateFullRegularSeason(data);

      for (final team in afterSeason.allTeams) {
        final record = team.seasonRecord;
        expect(record.wins + record.losses, 14,
            reason: '${team.shortName}: wins(${record.wins}) + losses(${record.losses}) should be 14');

        // 세트 합산 검증
        int expectedSetWins = 0;
        int expectedSetLosses = 0;
        for (final item in afterSeason.currentSeason.proleagueSchedule) {
          if (!item.isCompleted || item.result == null) continue;
          final r = item.result!;
          if (r.homeTeamId == team.id) {
            expectedSetWins += r.homeScore;
            expectedSetLosses += r.awayScore;
          } else if (r.awayTeamId == team.id) {
            expectedSetWins += r.awayScore;
            expectedSetLosses += r.homeScore;
          }
        }
        expect(record.setWins, expectedSetWins,
            reason: '${team.shortName}: set wins mismatch');
        expect(record.setLosses, expectedSetLosses,
            reason: '${team.shortName}: set losses mismatch');
      }
    });

    test('팀 자원이 음수가 되지 않는다', () {
      // TODO: Phase 2
      // - 시즌 진행 후 모든 팀 money >= 0
      // - 모든 팀 actionPoints >= 0
      final data = createTestSaveData();
      final afterSeason = simulateFullRegularSeason(data);

      for (final team in afterSeason.allTeams) {
        expect(team.money >= 0, isTrue,
            reason: '${team.shortName}: money should not be negative');
        expect(team.actionPoints >= 0, isTrue,
            reason: '${team.shortName}: actionPoints should not be negative');
      }
    });

    test('모든 선수가 팀에 올바르게 소속되어 있다', () {
      // TODO: Phase 2
      // - 각 팀의 playerIds에 있는 선수가 실제로 allPlayers에 존재
      // - 해당 선수의 teamId가 팀 id와 일치
      final data = createTestSaveData();

      for (final team in data.allTeams) {
        for (final playerId in team.playerIds) {
          final player = data.getPlayerById(playerId);
          expect(player, isNotNull,
              reason: 'Player $playerId should exist in allPlayers');
          expect(player!.teamId, team.id,
              reason: 'Player $playerId teamId should match ${team.id}');
        }
      }
    });

    test('일정에 중복 매치업이 없다 (같은 방향)', () {
      // TODO: Phase 2
      // - 1차 리그: 동일 (home, away) 쌍이 중복되지 않음
      // - 2차 리그: 동일 (home, away) 쌍이 중복되지 않음
      // - 1차와 2차 사이에는 홈/어웨이 반전으로 중복 허용
      final data = createTestSaveData();
      final schedule = data.currentSeason.proleagueSchedule;
      final half = schedule.length ~/ 2;

      // 1차 리그 중복 체크
      final firstHalf = schedule.sublist(0, half);
      final firstPairs = firstHalf.map((s) => '${s.homeTeamId}-${s.awayTeamId}').toSet();
      expect(firstPairs.length, half,
          reason: 'First half should have no duplicate matchups');

      // 2차 리그 중복 체크
      final secondHalf = schedule.sublist(half);
      final secondPairs = secondHalf.map((s) => '${s.homeTeamId}-${s.awayTeamId}').toSet();
      expect(secondPairs.length, half,
          reason: 'Second half should have no duplicate matchups');
    });
  });

  group('경계값', () {
    test('8팀 동률 시나리오에서 순위가 결정된다', () {
      // TODO: Phase 2
      // - 모든 팀이 7승 7패인 스케줄 생성 (의도적)
      // - 세트 득실 또는 상대전적으로 구분되는지 확인
      // - standings.length == 8 (모두 순위 배정)
      final data = createTestSaveData();

      // 모든 경기를 4-3 (홈 승)으로 설정하면
      // 각 팀 홈 7승, 어웨이 7패 → 7승 7패 동률
      final schedule = data.currentSeason.proleagueSchedule;
      var updatedSeason = data.currentSeason;
      var updatedData = data;

      for (int i = 0; i < schedule.length; i++) {
        final item = schedule[i];
        final result = MatchResult(
          id: item.matchId,
          homeTeamId: item.homeTeamId,
          awayTeamId: item.awayTeamId,
          sets: [
            SetResult(mapId: 'm0', homePlayerId: 'h0', awayPlayerId: 'a0', homeWin: true),
            SetResult(mapId: 'm1', homePlayerId: 'h1', awayPlayerId: 'a1', homeWin: true),
            SetResult(mapId: 'm2', homePlayerId: 'h2', awayPlayerId: 'a2', homeWin: true),
            SetResult(mapId: 'm3', homePlayerId: 'h3', awayPlayerId: 'a3', homeWin: false),
            SetResult(mapId: 'm4', homePlayerId: 'h4', awayPlayerId: 'a4', homeWin: false),
            SetResult(mapId: 'm5', homePlayerId: 'h5', awayPlayerId: 'a5', homeWin: false),
            SetResult(mapId: 'm6', homePlayerId: 'h6', awayPlayerId: 'a6', homeWin: true),
          ],
          isCompleted: true,
        );
        updatedSeason = updatedSeason.updateMatchResult(i, result);
      }

      updatedData = updatedData.updateSeason(updatedSeason);
      final standings = calculateStandings(updatedData);

      expect(standings.length, 8);
      // 모든 팀 7승 7패 확인
      for (final s in standings) {
        expect(s.wins, 7, reason: '${s.teamId}: wins should be 7');
        expect(s.losses, 7, reason: '${s.teamId}: losses should be 7');
      }
    });

    test('한 팀이 전승할 때 1위가 된다', () {
      // TODO: Phase 2
      // - team_kt를 모든 경기 승리하도록 결과 설정
      // - standings[0].teamId == 'team_kt'
      final data = createTestSaveData();
      final schedule = data.currentSeason.proleagueSchedule;
      var updatedSeason = data.currentSeason;

      for (int i = 0; i < schedule.length; i++) {
        final item = schedule[i];
        final ktIsHome = item.homeTeamId == 'team_kt';
        final ktIsAway = item.awayTeamId == 'team_kt';

        // KT 경기: KT가 4-0 승리
        // 다른 팀 경기: 홈팀 4-3 승리
        final List<SetResult> sets;
        if (ktIsHome) {
          sets = List.generate(4, (j) => SetResult(
            mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: true,
          ));
        } else if (ktIsAway) {
          sets = List.generate(4, (j) => SetResult(
            mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: false,
          ));
        } else {
          sets = [
            ...List.generate(4, (j) => SetResult(
              mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: true,
            )),
            ...List.generate(3, (j) => SetResult(
              mapId: 'map_${4 + j}', homePlayerId: 'h${4 + j}', awayPlayerId: 'a${4 + j}', homeWin: false,
            )),
          ];
        }

        final result = MatchResult(
          id: item.matchId,
          homeTeamId: item.homeTeamId,
          awayTeamId: item.awayTeamId,
          sets: sets,
          isCompleted: true,
        );
        updatedSeason = updatedSeason.updateMatchResult(i, result);
      }

      final updatedData = data.updateSeason(updatedSeason);
      // 팀 전적도 수동 업데이트
      var teams = updatedData.allTeams.toList();
      final ktIdx = teams.indexWhere((t) => t.id == 'team_kt');
      // KT 14경기 중 모두 승리 세팅
      // (실제 팀 전적은 recordMatchResult에서 업데이트하지만 여기선 직접)

      final standings = calculateStandings(updatedData);

      // KT가 14전 14승이므로 승점 42점으로 1위
      final ktStanding = standings.firstWhere((s) => s.teamId == 'team_kt');
      expect(ktStanding.wins, 14);
      expect(ktStanding.losses, 0);
      expect(standings[0].teamId, 'team_kt',
          reason: 'KT with 14 wins should be first place');
    });

    test('한 팀이 전패할 때 8위가 된다', () {
      // TODO: Phase 2
      // - team_8th를 모든 경기 패배하도록 결과 설정
      // - standings[7].teamId == 'team_8th'
      final data = createTestSaveData();
      final schedule = data.currentSeason.proleagueSchedule;
      var updatedSeason = data.currentSeason;

      for (int i = 0; i < schedule.length; i++) {
        final item = schedule[i];
        final t8IsHome = item.homeTeamId == 'team_8th';
        final t8IsAway = item.awayTeamId == 'team_8th';

        // T8 경기: T8이 0-4 패배
        // 다른 팀 경기: 홈팀 4-3 승리
        final List<SetResult> sets;
        if (t8IsHome) {
          sets = List.generate(4, (j) => SetResult(
            mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: false,
          ));
        } else if (t8IsAway) {
          sets = List.generate(4, (j) => SetResult(
            mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: true,
          ));
        } else {
          sets = [
            ...List.generate(4, (j) => SetResult(
              mapId: 'map_$j', homePlayerId: 'h$j', awayPlayerId: 'a$j', homeWin: true,
            )),
            ...List.generate(3, (j) => SetResult(
              mapId: 'map_${4 + j}', homePlayerId: 'h${4 + j}', awayPlayerId: 'a${4 + j}', homeWin: false,
            )),
          ];
        }

        final result = MatchResult(
          id: item.matchId,
          homeTeamId: item.homeTeamId,
          awayTeamId: item.awayTeamId,
          sets: sets,
          isCompleted: true,
        );
        updatedSeason = updatedSeason.updateMatchResult(i, result);
      }

      final updatedData = data.updateSeason(updatedSeason);
      final standings = calculateStandings(updatedData);

      // T8이 14전 14패이므로 승점 0점으로 최하위
      final t8Standing = standings.firstWhere((s) => s.teamId == 'team_8th');
      expect(t8Standing.wins, 0);
      expect(t8Standing.losses, 14);
      expect(standings.last.teamId, 'team_8th',
          reason: 'Team 8 with 0 wins should be last place');
    });
  });
}
