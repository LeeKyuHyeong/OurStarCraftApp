import 'package:hive/hive.dart';
import 'match.dart';

part 'season.g.dart';

/// 시즌 정보
@HiveType(typeId: 17)
class Season {
  @HiveField(0)
  final int number; // 시즌 번호

  @HiveField(1)
  final List<String> seasonMapIds; // 시즌맵 ID 목록 (12개 중 랜덤 선정)

  @HiveField(2)
  final List<ScheduleItem> proleagueSchedule; // 프로리그 일정

  @HiveField(3)
  final int currentMatchIndex; // 현재 경기 인덱스

  @HiveField(4)
  final int matchesSinceLastBonus; // 마지막 보너스(행동력+100) 후 경기 수

  @HiveField(5)
  final IndividualLeagueBracket? individualLeague;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final String? proleagueChampionId; // 프로리그 우승팀 ID

  @HiveField(8)
  final String? proleagueRunnerUpId; // 프로리그 준우승팀 ID

  const Season({
    required this.number,
    this.seasonMapIds = const [],
    this.proleagueSchedule = const [],
    this.currentMatchIndex = 0,
    this.matchesSinceLastBonus = 0,
    this.individualLeague,
    this.isCompleted = false,
    this.proleagueChampionId,
    this.proleagueRunnerUpId,
  });

  ScheduleItem? get currentMatch =>
      currentMatchIndex < proleagueSchedule.length
          ? proleagueSchedule[currentMatchIndex]
          : null;

  bool get hasNextMatch => currentMatchIndex < proleagueSchedule.length;

  /// 다음 경기로 이동
  Season advanceMatch() {
    final newMatchesSinceLastBonus = matchesSinceLastBonus + 1;
    final giveBonus = newMatchesSinceLastBonus >= 2;

    return Season(
      number: number,
      seasonMapIds: seasonMapIds,
      proleagueSchedule: proleagueSchedule,
      currentMatchIndex: currentMatchIndex + 1,
      matchesSinceLastBonus: giveBonus ? 0 : newMatchesSinceLastBonus,
      individualLeague: individualLeague,
      isCompleted: isCompleted,
      proleagueChampionId: proleagueChampionId,
      proleagueRunnerUpId: proleagueRunnerUpId,
    );
  }

  /// 2경기 완료 보너스 필요 여부
  bool get shouldGiveBonus => matchesSinceLastBonus >= 2;

  /// 경기 결과 업데이트
  Season updateMatchResult(int matchIndex, MatchResult result) {
    final newSchedule = List<ScheduleItem>.from(proleagueSchedule);
    newSchedule[matchIndex] = newSchedule[matchIndex].complete(result);

    return Season(
      number: number,
      seasonMapIds: seasonMapIds,
      proleagueSchedule: newSchedule,
      currentMatchIndex: currentMatchIndex,
      matchesSinceLastBonus: matchesSinceLastBonus,
      individualLeague: individualLeague,
      isCompleted: isCompleted,
      proleagueChampionId: proleagueChampionId,
      proleagueRunnerUpId: proleagueRunnerUpId,
    );
  }

  /// 개인리그 업데이트
  Season updateIndividualLeague(IndividualLeagueBracket bracket) {
    return Season(
      number: number,
      seasonMapIds: seasonMapIds,
      proleagueSchedule: proleagueSchedule,
      currentMatchIndex: currentMatchIndex,
      matchesSinceLastBonus: matchesSinceLastBonus,
      individualLeague: bracket,
      isCompleted: isCompleted,
      proleagueChampionId: proleagueChampionId,
      proleagueRunnerUpId: proleagueRunnerUpId,
    );
  }

  /// 시즌 완료
  Season complete({String? championId, String? runnerUpId}) {
    return Season(
      number: number,
      seasonMapIds: seasonMapIds,
      proleagueSchedule: proleagueSchedule,
      currentMatchIndex: currentMatchIndex,
      matchesSinceLastBonus: matchesSinceLastBonus,
      individualLeague: individualLeague,
      isCompleted: true,
      proleagueChampionId: championId,
      proleagueRunnerUpId: runnerUpId,
    );
  }
}

/// 팀 순위 정보
@HiveType(typeId: 18)
class TeamStanding {
  @HiveField(0)
  final String teamId;

  @HiveField(1)
  final int wins;

  @HiveField(2)
  final int losses;

  @HiveField(3)
  final int setWins;

  @HiveField(4)
  final int setLosses;

  @HiveField(5)
  final int points; // 승점 (승리 당 3점)

  const TeamStanding({
    required this.teamId,
    this.wins = 0,
    this.losses = 0,
    this.setWins = 0,
    this.setLosses = 0,
    this.points = 0,
  });

  double get winRate => wins + losses > 0 ? wins / (wins + losses) : 0.0;
  int get setDiff => setWins - setLosses;

  TeamStanding addResult({
    required bool isWin,
    required int ourSets,
    required int opponentSets,
  }) {
    return TeamStanding(
      teamId: teamId,
      wins: wins + (isWin ? 1 : 0),
      losses: losses + (isWin ? 0 : 1),
      setWins: setWins + ourSets,
      setLosses: setLosses + opponentSets,
      points: points + (isWin ? 3 : 0),
    );
  }

  /// 순위 비교 (내림차순)
  int compareTo(TeamStanding other) {
    // 1. 승점
    if (points != other.points) return other.points - points;
    // 2. 세트 득실
    if (setDiff != other.setDiff) return other.setDiff - setDiff;
    // 3. 승률
    if (winRate != other.winRate) {
      return other.winRate > winRate ? 1 : -1;
    }
    return 0;
  }
}

/// 시즌 히스토리 (통계용)
@HiveType(typeId: 19)
class SeasonHistory {
  @HiveField(0)
  final int seasonNumber;

  @HiveField(1)
  final String? proleagueChampionId;

  @HiveField(2)
  final String? proleagueRunnerUpId;

  @HiveField(3)
  final String? individualChampionId;

  @HiveField(4)
  final String? individualRunnerUpId;

  @HiveField(5)
  final List<TeamStanding> finalStandings;

  @HiveField(6)
  final String? mvpPlayerId; // 시즌 MVP

  const SeasonHistory({
    required this.seasonNumber,
    this.proleagueChampionId,
    this.proleagueRunnerUpId,
    this.individualChampionId,
    this.individualRunnerUpId,
    this.finalStandings = const [],
    this.mvpPlayerId,
  });
}
