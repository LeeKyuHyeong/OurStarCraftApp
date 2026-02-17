// TvZ 빌드 매치업별 승률 + 해설 분석
// 실행: flutter test test/build_matchup_test.dart --reporter expanded
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

Player _makePlayer({
  required String name,
  required Race race,
}) {
  return Player(
    id: name,
    name: name,
    raceIndex: race.index,
    stats: const PlayerStats(
      sense: 650, control: 650, attack: 650, harass: 650,
      strategy: 650, macro: 650, defense: 650, scout: 650,
    ),
    levelValue: 5,
    condition: 100,
  );
}

const _standardMap = GameMap(
  id: 'test_standard',
  name: '테스트맵',
  rushDistance: 5,
  resources: 5,
  terrainComplexity: 5,
  airAccessibility: 5,
  centerImportance: 5,
);

// 테란 TvZ 빌드 목록
const _terranBuilds = [
  ('tvz_bunker', '벙커링', 'DEF'),
  ('tvz_2fac_vulture', '2팩벌처', 'AGG'),
  ('tvz_sk', 'SK테란', 'BAL'),
  ('tvz_3fac_goliath', '3팩골리앗', 'DEF'),
  ('tvz_wraith', '레이스견제', 'AGG'),
  ('tvz_mech_drop', '메카닉드랍', 'BAL'),
];

// 저그 ZvT 빌드 목록
const _zergBuilds = [
  ('zvt_3hatch_mutal', '3해처리뮤탈', 'AGG'),
  ('zvt_2hatch_mutal', '투해처리뮤탈', 'BAL'),
  ('zvt_2hatch_lurker', '투해처리럴커', 'DEF'),
  ('zvt_hatch_spore', '해처리스포', 'DEF'),
  ('zvt_1hatch_allin', '원해처리올인', 'CHE'),
];

void main() {
  // 1. 빌드 매치업별 승률 (각 200회)
  test('TvZ 빌드 매치업별 승률 (30 매치업 × 200회)', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('=== TvZ 빌드 매치업별 승률 (200회) ===\n');

    // 헤더
    buf.write('T \\ Z'.padRight(16));
    for (final (_, zName, zStyle) in _zergBuilds) {
      buf.write('$zName($zStyle)'.padRight(18));
    }
    buf.write('평균'.padRight(8));
    buf.writeln();
    buf.writeln('-' * 114);

    int grandTotal = 0;
    int grandTWins = 0;

    // 스타일별 합산
    final styleWins = <String, int>{};
    final styleGames = <String, int>{};

    for (final (tId, tName, tStyle) in _terranBuilds) {
      buf.write('$tName($tStyle)'.padRight(16));
      int rowWins = 0;
      int rowGames = 0;

      for (final (zId, _, zStyle) in _zergBuilds) {
        int tWins = 0;
        const runs = 200;

        for (int i = 0; i < runs; i++) {
          final home = _makePlayer(name: 'Terran', race: Race.terran);
          final away = _makePlayer(name: 'Zerg', race: Race.zerg);

          final stream = service.simulateMatchWithLog(
            homePlayer: home,
            awayPlayer: away,
            map: _standardMap,
            getIntervalMs: () => 0,
            forcedHomeBuildId: tId,
            forcedAwayBuildId: zId,
          );

          SimulationState? last;
          await for (final state in stream) {
            last = state;
          }
          if (last?.homeWin == true) tWins++;
        }

        final winRate = (tWins / runs * 100).toStringAsFixed(0);
        buf.write('T ${winRate.padLeft(3)}%'.padRight(18));
        rowWins += tWins;
        rowGames += runs;

        // 스타일 매치업 집계
        final key = '$tStyle vs $zStyle';
        styleWins[key] = (styleWins[key] ?? 0) + tWins;
        styleGames[key] = (styleGames[key] ?? 0) + runs;
      }

      final rowAvg = (rowWins / rowGames * 100).toStringAsFixed(0);
      buf.write('T ${rowAvg.padLeft(3)}%');
      buf.writeln();
      grandTotal += rowGames;
      grandTWins += rowWins;
    }

    buf.writeln('-' * 114);
    final grandAvg = (grandTWins / grandTotal * 100).toStringAsFixed(1);
    buf.writeln('전체 평균: T $grandAvg% (${grandTWins}승 / ${grandTotal}경기)\n');

    // 스타일 매치업 요약
    buf.writeln('=== 스타일 매치업 요약 ===');
    final styleOrder = ['AGG vs AGG', 'AGG vs BAL', 'AGG vs DEF', 'AGG vs CHE',
                        'BAL vs AGG', 'BAL vs BAL', 'BAL vs DEF', 'BAL vs CHE',
                        'DEF vs AGG', 'DEF vs BAL', 'DEF vs DEF', 'DEF vs CHE'];
    for (final key in styleOrder) {
      if (styleGames.containsKey(key)) {
        final wr = (styleWins[key]! / styleGames[key]! * 100).toStringAsFixed(1);
        buf.writeln('  $key: T $wr% (${styleWins[key]}/${styleGames[key]})');
      }
    }

    buf.writeln('\n※ T %% = 테란 승률 (BAL 스탯 650 올)');
    print(buf.toString());
  }, timeout: const Timeout(Duration(minutes: 30)));

  // 2. 이벤트풀 및 해설 확률 분석
  test('TvZ 이벤트풀 및 해설 확률 분석', () async {
    final service = MatchSimulationService();
    final buf = StringBuffer();
    buf.writeln('=== TvZ 이벤트풀 및 해설 확률 분석 ===\n');

    // 대표 매치업 3개 선택
    final matchups = [
      ('tvz_bunker', 'zvt_3hatch_mutal', '벙커링(DEF) vs 3뮤탈(AGG)'),
      ('tvz_sk', 'zvt_2hatch_mutal', 'SK테란(BAL) vs 2뮤탈(BAL)'),
      ('tvz_2fac_vulture', 'zvt_1hatch_allin', '2팩벌처(AGG) vs 올인(CHE)'),
    ];

    for (final (tId, zId, label) in matchups) {
      buf.writeln('[$label] (100회 분석)');

      final commentaryCount = <String, int>{};  // [해설] 텍스트 빈도
      final homeEventCount = <String, int>{};    // [T] 클래시/이벤트 텍스트 빈도
      final awayEventCount = <String, int>{};    // [Z] 클래시/이벤트 텍스트 빈도
      int totalLines = 0;
      int totalCommentary = 0;
      int totalHomeEvents = 0;
      int totalAwayEvents = 0;
      int totalGames = 0;
      int tWins = 0;
      int shortGames = 0;   // ≤25줄
      int mediumGames = 0;  // 26~60줄
      int longGames = 0;    // >60줄
      int decisiveWins = 0;

      for (int i = 0; i < 100; i++) {
        final home = _makePlayer(name: 'T', race: Race.terran);
        final away = _makePlayer(name: 'Z', race: Race.zerg);

        final stream = service.simulateMatchWithLog(
          homePlayer: home,
          awayPlayer: away,
          map: _standardMap,
          getIntervalMs: () => 0,
          forcedHomeBuildId: tId,
          forcedAwayBuildId: zId,
        );

        SimulationState? last;
        await for (final state in stream) {
          last = state;
        }

        if (last != null) {
          totalGames++;
          if (last.homeWin == true) tWins++;
          final entries = last.battleLogEntries;
          totalLines += entries.length;

          if (entries.length <= 25) shortGames++;
          else if (entries.length <= 60) mediumGames++;
          else longGames++;

          for (final e in entries) {
            final text = e.text;
            if (e.owner == LogOwner.system) {
              // 오프닝(마이프로리그~) 제외
              if (!text.contains('마이프로리그') && !text.contains('맞붙습니다') && !text.contains('승리!') && !text.contains('GG')) {
                commentaryCount[text] = (commentaryCount[text] ?? 0) + 1;
                totalCommentary++;
              }
            } else if (e.owner == LogOwner.home) {
              // 빌드 스텝 제외 (빌드 스텝은 '{player}' 패턴의 변환)
              if (!text.startsWith('T ') && !text.startsWith('T,') && !text.contains('GG')) {
                homeEventCount[text] = (homeEventCount[text] ?? 0) + 1;
                totalHomeEvents++;
              }
            } else if (e.owner == LogOwner.away) {
              if (!text.startsWith('Z ') && !text.startsWith('Z,') && !text.contains('GG')) {
                awayEventCount[text] = (awayEventCount[text] ?? 0) + 1;
                totalAwayEvents++;
              }
            }

            // 결정적 이벤트 감지
            if (text.contains('초토화') || text.contains('빌드 승리') || text.contains('기습 성공')) {
              decisiveWins++;
            }
          }
        }
      }

      final avgLines = totalLines / totalGames;
      buf.writeln('  승률: T ${(tWins / totalGames * 100).toStringAsFixed(0)}% | 평균줄: ${avgLines.toStringAsFixed(1)}');
      buf.writeln('  경기길이: 짧음(≤25) $shortGames | 중간(26~60) $mediumGames | 긴(>60) $longGames');
      buf.writeln('  결정적이벤트: $decisiveWins회');
      buf.writeln('  해설 총 ${totalCommentary}회 (게임당 ${(totalCommentary / totalGames).toStringAsFixed(1)}회)');
      buf.writeln('  T이벤트 총 ${totalHomeEvents}회 | Z이벤트 총 ${totalAwayEvents}회');

      // 해설 Top 15
      buf.writeln('\n  [해설 멘트 Top 15]');
      final sortedComm = commentaryCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (int i = 0; i < sortedComm.length && i < 15; i++) {
        final e = sortedComm[i];
        final pct = (e.value / totalCommentary * 100).toStringAsFixed(1);
        buf.writeln('    ${(i + 1).toString().padLeft(2)}. [${e.value}회/${pct}%] ${e.key}');
      }

      // T 클래시 이벤트 Top 10
      buf.writeln('\n  [T 클래시/인터랙션 이벤트 Top 10]');
      final sortedHome = homeEventCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (int i = 0; i < sortedHome.length && i < 10; i++) {
        final e = sortedHome[i];
        buf.writeln('    ${(i + 1).toString().padLeft(2)}. [${e.value}회] ${e.key}');
      }

      // Z 클래시 이벤트 Top 10
      buf.writeln('\n  [Z 클래시/인터랙션 이벤트 Top 10]');
      final sortedAway = awayEventCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (int i = 0; i < sortedAway.length && i < 10; i++) {
        final e = sortedAway[i];
        buf.writeln('    ${(i + 1).toString().padLeft(2)}. [${e.value}회] ${e.key}');
      }

      // 유니크 이벤트 수
      buf.writeln('\n  유니크 해설: ${commentaryCount.length}종 | T이벤트: ${homeEventCount.length}종 | Z이벤트: ${awayEventCount.length}종');
      buf.writeln('---\n');
    }

    print(buf.toString());
  }, timeout: const Timeout(Duration(minutes: 15)));
}
