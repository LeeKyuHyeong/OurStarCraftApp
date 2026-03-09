import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의 (TvT - 양쪽 모두 테란, raceIndex 0)
// =========================================================

/// 동급 테란1 (~700)
final homeEqual = Player(
  id: 't1_equal', name: '이영호', raceIndex: 0,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 테란2 (~700)
final awayEqual = Player(
  id: 't2_equal', name: '이윤열', raceIndex: 0,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// S+ 테란1 (~920)
final homeSPlus = Player(
  id: 't1_splus', name: '이영호S', raceIndex: 0,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 테란2 (~650)
final awayBGrade = Player(
  id: 't2_b', name: '이윤열B', raceIndex: 0,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// 공격 특화 테란1 (attack/harass/control 높음)
final homeAttack = Player(
  id: 't1_atk', name: '이영호ATK', raceIndex: 0,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 테란2 (defense/strategy/macro 높음)
final awayDefense = Player(
  id: 't2_def', name: '이윤열DEF', raceIndex: 0,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// S+ 테란2 (~920)
final awaySPlus = Player(
  id: 't2_splus', name: '이윤열S', raceIndex: 0,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 테란1 (~650)
final homeBGrade = Player(
  id: 't1_b', name: '이영호B', raceIndex: 0,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// A급 테란1 (~780)
final homeAGrade = Player(
  id: 't1_a', name: '이영호A', raceIndex: 0,
  stats: const PlayerStats(
    sense: 780, control: 790, attack: 770, harass: 780,
    strategy: 760, macro: 800, defense: 770, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// A급 테란2 (~780)
final awayAGrade = Player(
  id: 't2_a', name: '이윤열A', raceIndex: 0,
  stats: const PlayerStats(
    sense: 770, control: 780, attack: 790, harass: 760,
    strategy: 800, macro: 770, defense: 780, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// S급 테란1 (~850)
final homeSGrade = Player(
  id: 't1_s', name: '이영호S0', raceIndex: 0,
  stats: const PlayerStats(
    sense: 850, control: 860, attack: 840, harass: 850,
    strategy: 830, macro: 870, defense: 840, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S급 테란2 (~850)
final awaySGrade = Player(
  id: 't2_s', name: '이윤열S0', raceIndex: 0,
  stats: const PlayerStats(
    sense: 840, control: 850, attack: 860, harass: 830,
    strategy: 870, macro: 840, defense: 850, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// 공격 특화 테란2 (attack/harass/control 높음)
final awayAttack = Player(
  id: 't2_atk', name: '이윤열ATK', raceIndex: 0,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 테란1 (defense/strategy/macro 높음)
final homeDefense = Player(
  id: 't1_def', name: '이영호DEF', raceIndex: 0,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

// =========================================================
// 맵 정의
// =========================================================

const mapBalance = GameMap(
  id: 'test_balance', name: '밸런스맵',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

const mapOdelo = GameMap(
  id: 'test_odelo', name: '오델로',
  rushDistance: 5, resources: 6, terrainComplexity: 4,
  airAccessibility: 5, centerImportance: 6,
  matchup: RaceMatchup(
    tvzTerranWinRate: 65,
    zvpZergWinRate: 55,
    pvtProtossWinRate: 35,
  ),
);

const mapLuna = GameMap(
  id: 'test_luna', name: '루나',
  rushDistance: 7, resources: 7, terrainComplexity: 6,
  airAccessibility: 7, centerImportance: 4,
  matchup: RaceMatchup(
    tvzTerranWinRate: 42,
    zvpZergWinRate: 60,
    pvtProtossWinRate: 60,
  ),
);

const mapTuhon = GameMap(
  id: 'test_tuhon', name: '투혼',
  rushDistance: 4, resources: 4, terrainComplexity: 3,
  airAccessibility: 5, centerImportance: 7,
  matchup: RaceMatchup(
    tvzTerranWinRate: 55,
    zvpZergWinRate: 48,
    pvtProtossWinRate: 45,
  ),
);

// =========================================================
// 분기 감지기
// =========================================================

class BranchDetector {
  final String name;
  final List<String> patterns;
  int count = 0;
  int wins = 0;

  BranchDetector(this.name, this.patterns);

  bool detect(String text) => patterns.any((p) => text.contains(p));

  String winRate(int total) {
    if (count == 0) return '-';
    return '${(wins / count * 100).toStringAsFixed(1)}%';
  }

  String pct(int total) {
    if (total == 0) return '-';
    return '${(count / total * 100).toStringAsFixed(1)}%';
  }
}

// =========================================================
// 시나리오 설정
// =========================================================

class ScenarioConfig {
  final String id;
  final String name;
  final String build1;
  final String build2;
  final List<BranchDetector> Function() phase2Branches;
  final List<BranchDetector> Function()? phase4Branches;

  const ScenarioConfig({
    required this.id,
    required this.name,
    required this.build1,
    required this.build2,
    required this.phase2Branches,
    this.phase4Branches,
  });
}

// =========================================================
// 배치 실행 결과
// =========================================================

class BatchResult {
  int homeWins = 0;
  int awayWins = 0;
  final List<int> armyMargins = [];
  final List<int> resourceMargins = [];
  List<BranchDetector> phase2 = [];
  List<BranchDetector> phase4 = [];
  int p2Unknown = 0;
  int p4Unknown = 0;
  List<String> lastGameLog = [];
  bool? lastGameHomeWin;

  int get total => homeWins + awayWins;
  double get homeWinRate => total > 0 ? homeWins / total * 100 : 0;
  double get avgArmy => armyMargins.isEmpty ? 0 :
      armyMargins.reduce((a, b) => a + b) / armyMargins.length;
  double get avgResource => resourceMargins.isEmpty ? 0 :
      resourceMargins.reduce((a, b) => a + b) / resourceMargins.length;
}

// =========================================================
// 시뮬레이션 배치 실행
// =========================================================

Future<BatchResult> runBatch({
  required Player home,
  required Player away,
  required GameMap map,
  required String homeBuild,
  required String awayBuild,
  required int count,
  required List<BranchDetector> Function() makeBranches2,
  List<BranchDetector> Function()? makeBranches4,
}) async {
  final result = BatchResult();
  result.phase2 = makeBranches2();
  if (makeBranches4 != null) result.phase4 = makeBranches4!();

  for (int i = 0; i < count; i++) {
    final service = MatchSimulationService();
    final stream = service.simulateMatchWithLog(
      homePlayer: home, awayPlayer: away,
      map: map, getIntervalMs: () => 0,
      forcedHomeBuildId: homeBuild,
      forcedAwayBuildId: awayBuild,
    );

    SimulationState? state;
    await for (final s in stream) { state = s; }
    if (state == null) continue;

    final won = state.homeWin == true;
    if (won) result.homeWins++; else result.awayWins++;

    result.armyMargins.add(state.homeArmy - state.awayArmy);
    result.resourceMargins.add(state.homeResources - state.awayResources);

    // 마지막 경기 로그 캡처
    if (i == count - 1) {
      result.lastGameLog = state.battleLogEntries.map((e) {
        switch (e.owner) {
          case LogOwner.home: return '[홈] ${e.text}';
          case LogOwner.away: return '[어웨이] ${e.text}';
          case LogOwner.clash: return '[교전] ${e.text}';
          case LogOwner.system: return '[해설] ${e.text}';
        }
      }).toList();
      result.lastGameHomeWin = won;
    }

    final allText = state.battleLogEntries.map((e) => e.text).join(' ');

    // Phase 2 감지
    bool detected = false;
    for (final b in result.phase2) {
      if (b.detect(allText)) {
        b.count++;
        if (won) b.wins++;
        detected = true;
        break;
      }
    }
    if (!detected) result.p2Unknown++;

    // Phase 4 감지
    if (result.phase4.isNotEmpty) {
      detected = false;
      for (final b in result.phase4) {
        if (b.detect(allText)) {
          b.count++;
          if (won) b.wins++;
          detected = true;
          break;
        }
      }
      if (!detected) result.p4Unknown++;
    }
  }

  return result;
}

// =========================================================
// 홈/어웨이 반전 포함 배치 실행 (미러: player1/player2 기준)
// =========================================================

Future<BatchResult> runBatchBiDir({
  required Player player1,
  required Player player2,
  required GameMap map,
  required String build1,
  required String build2,
  required int countPerDir,
  required List<BranchDetector> Function() makeBranches2,
  List<BranchDetector> Function()? makeBranches4,
}) async {
  // 정방향: player1=홈 with build1, player2=어웨이 with build2
  final fwd = await runBatch(
    home: player1, away: player2, map: map,
    homeBuild: build1, awayBuild: build2, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 역방향: player2=홈 with build2, player1=어웨이 with build1
  final rev = await runBatch(
    home: player2, away: player1, map: map,
    homeBuild: build2, awayBuild: build1, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합: homeWins = player1 승 = build1 측 승
  final combined = BatchResult();
  combined.homeWins = fwd.homeWins + rev.awayWins; // player1 승
  combined.awayWins = fwd.awayWins + rev.homeWins; // player2 승
  combined.armyMargins.addAll(fwd.armyMargins);
  combined.armyMargins.addAll(rev.armyMargins.map((m) => -m));
  combined.resourceMargins.addAll(fwd.resourceMargins);
  combined.resourceMargins.addAll(rev.resourceMargins.map((m) => -m));

  // 분기는 양방향 합산
  combined.phase2 = fwd.phase2;
  combined.phase4 = fwd.phase4;
  for (int i = 0; i < rev.phase2.length && i < combined.phase2.length; i++) {
    combined.phase2[i].count += rev.phase2[i].count;
    combined.phase2[i].wins += rev.phase2[i].wins;
  }
  for (int i = 0; i < rev.phase4.length && i < combined.phase4.length; i++) {
    combined.phase4[i].count += rev.phase4[i].count;
    combined.phase4[i].wins += rev.phase4[i].wins;
  }
  combined.p2Unknown = fwd.p2Unknown + rev.p2Unknown;
  combined.p4Unknown = fwd.p4Unknown + rev.p4Unknown;

  // 마지막 경기 로그 (정방향에서 가져옴)
  combined.lastGameLog = fwd.lastGameLog;
  combined.lastGameHomeWin = fwd.lastGameHomeWin;

  return combined;
}

// =========================================================
// 리포트 생성
// =========================================================

String pctStr(int n, int total) =>
    total > 0 ? '${(n / total * 100).toStringAsFixed(1)}%' : '-';

String generateReport({
  required String title,
  required String config,
  required BatchResult result,
  String phaseName2 = 'Phase 2',
  String? phaseName4,
}) {
  final buf = StringBuffer();
  buf.writeln('### $title ($config)');
  buf.writeln('| 항목 | 값 |');
  buf.writeln('|------|-----|');
  buf.writeln('| 전적 | 홈 ${result.homeWins} - ${result.awayWins} 어웨이 (${result.total}게임) |');
  buf.writeln('| 홈승률 | ${result.homeWinRate.toStringAsFixed(1)}% |');
  buf.writeln('| 평균 병력차 | ${result.avgArmy.toStringAsFixed(1)} |');
  buf.writeln('| 평균 자원차 | ${result.avgResource.toStringAsFixed(1)} |');
  buf.writeln('');

  if (result.phase2.isNotEmpty) {
    final p2Total = result.phase2.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**$phaseName2** (${p2Total}감지 / ${result.p2Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    for (final b in result.phase2) {
      buf.writeln('| ${b.name} | ${b.count} | ${b.pct(p2Total)} | ${b.winRate(b.count)} |');
    }
    buf.writeln('');
  }

  if (result.phase4.isNotEmpty) {
    final p4Total = result.phase4.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**${phaseName4 ?? 'Phase 4'}** (${p4Total}감지 / ${result.p4Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 |');
    buf.writeln('|------|------|------|--------|');
    for (final b in result.phase4) {
      buf.writeln('| ${b.name} | ${b.count} | ${b.pct(p4Total)} | ${b.winRate(b.count)} |');
    }
    buf.writeln('');
  }

  return buf.toString();
}

/// 모든 설정의 결과를 포함하는 통합 리포트
String generateFullReport({
  required String title,
  required Map<String, BatchResult> results,
  String phaseName2 = 'Phase 2',
  String? phaseName4,
}) {
  final buf = StringBuffer();
  buf.writeln('# $title\n');

  // 종합 요약 테이블
  buf.writeln('## 종합 결과\n');
  buf.writeln('| 설정 | 게임수 | 홈승 | 어웨이승 | 홈승률 | 병력차 | 자원차 |');
  buf.writeln('|------|--------|------|----------|--------|--------|--------|');
  for (final e in results.entries) {
    final r = e.value;
    buf.writeln('| ${e.key} | ${r.total} | ${r.homeWins} | ${r.awayWins} '
        '| ${r.homeWinRate.toStringAsFixed(1)}% '
        '| ${r.avgArmy.toStringAsFixed(1)} '
        '| ${r.avgResource.toStringAsFixed(1)} |');
  }
  buf.writeln('');

  // 분기 분석 (동급 300게임 데이터 사용)
  final mainResult = results.entries
      .where((e) => e.key.contains('동급'))
      .map((e) => e.value)
      .firstOrNull;
  if (mainResult == null) return buf.toString();

  if (mainResult.phase2.isNotEmpty) {
    final p2Total = mainResult.phase2.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('## $phaseName2 분기 분석 (동급 기준)\n');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 | 미감지 |');
    buf.writeln('|------|------|------|--------|--------|');
    for (final b in mainResult.phase2) {
      buf.writeln('| ${b.name} | ${b.count} '
          '| ${b.pct(p2Total)} | ${b.winRate(b.count)} '
          '| - |');
    }
    buf.writeln('| 미감지 | ${mainResult.p2Unknown} '
        '| ${pctStr(mainResult.p2Unknown, mainResult.total)} | - | - |');
    buf.writeln('');
  }

  if (mainResult.phase4.isNotEmpty) {
    final p4Total = mainResult.phase4.fold<int>(0, (s, b) => s + b.count);
    final p4Name = phaseName4 ?? 'Phase 4';
    buf.writeln('## $p4Name 분기 분석 (동급 기준)\n');
    buf.writeln('| 분기 | 발동 | 비율 | 홈승률 | 미감지 |');
    buf.writeln('|------|------|------|--------|--------|');
    for (final b in mainResult.phase4) {
      buf.writeln('| ${b.name} | ${b.count} '
          '| ${b.pct(p4Total)} | ${b.winRate(b.count)} '
          '| - |');
    }
    buf.writeln('| 미감지 | ${mainResult.p4Unknown} '
        '| ${pctStr(mainResult.p4Unknown, mainResult.total)} | - | - |');
    buf.writeln('');
  }

  // 맵별 비교 (홈승률 높은순 정렬)
  final mapResults = results.entries
      .where((e) => e.key.contains('맵'))
      .toList()
    ..sort((a, b) => b.value.homeWinRate.compareTo(a.value.homeWinRate));
  if (mapResults.isNotEmpty) {
    buf.writeln('## 맵별 비교 (홈승률 높은순)\n');
    buf.writeln('| 맵 | 게임수 | 홈승률 |');
    buf.writeln('|----|--------|--------|');
    final allMaps = <MapEntry<String, BatchResult>>[];
    final equal = results.entries.where((e) => e.key.contains('동급'));
    for (final e in equal) {
      allMaps.add(MapEntry('밸런스맵', e.value));
    }
    allMaps.addAll(mapResults);
    allMaps.sort((a, b) => b.value.homeWinRate.compareTo(a.value.homeWinRate));
    for (final e in allMaps) {
      buf.writeln('| ${e.key} | ${e.value.total} | ${e.value.homeWinRate.toStringAsFixed(1)}% |');
    }
    buf.writeln('');
  }

  // 마지막 경기 로그 (동급 결과에서 가져오기)
  if (mainResult.lastGameLog.isNotEmpty) {
    final winner = mainResult.lastGameHomeWin == true ? '홈 승리' : '어웨이 승리';
    buf.writeln('## 마지막 경기 로그 ($winner)\n');
    buf.writeln('```');
    for (final line in mainResult.lastGameLog) {
      buf.writeln(line);
    }
    buf.writeln('```');
    buf.writeln('');
  }

  return buf.toString();
}

// =========================================================
// 시나리오별 분기 정의
// =========================================================

// S1: 배럭더블 vs 팩토리더블 (tvt_rax_double_vs_fac_double)
List<BranchDetector> s1Phase2() => [
  BranchDetector('홈 벌처 우세', ['벌처 컨트롤이 좋습니다', '벌처 컨트롤 차이', '벌처로 상대 SCV 라인을 괴롭']),
  BranchDetector('어웨이 벌처 우세', ['속도 차이로 상대 벌처를 따라잡', '상대 벌처를 잡아냅니다', '벌처 견제! 상대 일꾼을 공격']),
];
List<BranchDetector> s1Phase4() => [
  BranchDetector('드랍 성공', ['드랍십 출격', '탱크를 내립니다', '멀티포인트 공격', '드랍+정면']),
  BranchDetector('정면 돌파', ['탱크+골리앗 라인을 밀어냅니다', '유지하던 라인을 파괴합니다', '라인이 밀립니다']),
];

// S2: BBS vs 노배럭 더블 (tvt_bbs_vs_double)
List<BranchDetector> s2Phase2() => [
  BranchDetector('마린 끊김', ['마린을 끊습니다', '마린이 벙커에 못 들어', 'BBS 완전 차단']),
  BranchDetector('벙커 성공', ['SCV를 제거하지 못합니다', '벙커 완성', '커맨드를 끝내 파괴']),
];

// S3: 레이스 vs 배럭더블 (tvt_wraith_vs_rax_double)
List<BranchDetector> s3Phase2() => [
  BranchDetector('클로킹 대학살', ['디텍이 없어요', '패배 직결', 'SCV 피해가 큽니다']),
  BranchDetector('견제 방어', ['나눠 짓습니다', '골리앗 생산 시작', '레이스를 잡아냅니다', '드랍십이 빠릅니다']),
];
List<BranchDetector> s3Phase4() => [
  BranchDetector('드랍십 전환', ['드랍십 전환', '드랍십으로 뒤쪽', '드랍십으로 전환', '드랍 견제']),
  BranchDetector('물량 압도', ['물량 차이가 벌어집니다', '투자 회수가 안 됩니다', '물량이 쌓입니다']),
];

// S4: 5팩 vs 마인트리플 (tvt_5fac_vs_mine_triple)
List<BranchDetector> s4Phase2() => [
  BranchDetector('타이밍 돌파', ['마인 지대를 뚫습니다', '수비 라인이 밀리', '5팩 물량으로 밀어']),
  BranchDetector('마인 수비', ['마인에 벌처가 터집', '마인 폭발', '트리플 확장의 자원 우위']),
];

// S5: BBS vs 테크 (tvt_bbs_vs_tech)
List<BranchDetector> s5Phase2() => [
  BranchDetector('테크 방어', ['팩토리 유닛이 가동', '팩토리 유닛으로 마린 격퇴', '테크 차이가 결정적']),
  BranchDetector('BBS 압도', ['벙커 완성! 마린 화력', '테크를 앞질렀', '팩토리 유닛이 너무 늦어']),
];

// S6: 공격적 빌드 대결 (tvt_aggressive_mirror)
List<BranchDetector> s6Phase2() => [
  BranchDetector('홈 타이밍', ['탱크 시즈! 상대 병력을 포격', '탱크+골리앗으로 밀어붙입니다', '타이밍 공격 성공']),
  BranchDetector('어웨이 역습', ['병력이 더 빠르게 모입니다', '역습 성공', '탱크+골리앗으로 추격']),
];

// S7: 배럭더블 vs 원팩확장 (tvt_cc_first_vs_1fac_expand)
List<BranchDetector> s7Phase2() => [
  BranchDetector('압박 성공', ['SCV를 잡습니다', '앞마당 가동이 늦어', '앞마당 이득을 살려']),
  BranchDetector('수비 성공', ['마인+벙커로 견제를 막아', '트리플 확장입니다', '수비 성공']),
];
List<BranchDetector> s7Phase4() => [
  BranchDetector('탱크 밀기', ['벌처로 상대 후방을 견제', '정면 탱크 라인도 전진', '조기 확장 이득']),
  BranchDetector('자원 역전', ['확장 기지들의 자원 우위', '물량 차이가 있습니다', '드랍십으로 상대 확장기지를 습격']),
];

// S8: 투팩벌처 vs 원팩확장 (tvt_2fac_vs_1fac_expand)
List<BranchDetector> s8Phase2() => [
  BranchDetector('벌처 견제 성공', ['마인을 피해 돌아서', 'SCV 피해가 큽니다', '견제 대성공']),
  BranchDetector('마인 수비', ['마인에 벌처가 터집니다', '투팩 투자가 아까운', '수비 성공']),
];
List<BranchDetector> s8Phase4() => [
  BranchDetector('홈 주도권', ['드랍십으로 상대 확장기지 뒤', '정면에서도 탱크 라인을 밀어', '드랍+정면 동시 공격']),
  BranchDetector('어웨이 물량', ['확장 기지들이 풀가동', '물량을 따라잡기 어렵', '물량으로 밀어붙입니다']),
];

// S9: 원팩원스타 vs 5팩 (tvt_1fac_push_vs_5fac)
List<BranchDetector> s9Phase2() => [
  BranchDetector('선제 돌파', ['상대 팩토리 라인을 향해 돌진', '팩토리가 파괴됩니다', '드랍십으로 후방 기습']),
  BranchDetector('5팩 물량', ['5팩토리에서 탱크+벌처가 쏟아', '숫자를 감당할 수 없습니다', '물량 앞에 소수정예가 한계']),
];

// S10: BBS 미러 (tvt_bbs_mirror)
List<BranchDetector> s10Phase2() => [
  BranchDetector('홈 벙커 선점', ['벙커 완성! 마린이 먼저 들어갑', '벙커가 아직 짓는 중', '벙커 선점 차이']),
  BranchDetector('어웨이 벙커 선점', ['벙커 완성! 마린이 먼저 들어갑', '벙커가 늦습니다', '한 발 빠른 완성이 승부']),
  BranchDetector('양쪽 벙커 교착', ['양쪽 벙커가 거의 동시에', '추가 마린으로 상대 벙커를 공격', '양쪽 벙커 교착']),
];

// S11: 원팩원스타 미러 (tvt_1fac_push_mirror)
List<BranchDetector> s11Phase2() => [
  BranchDetector('홈 탱크 우위', ['벌처 시야로 상대 탱크 위치를 포착', '시야 싸움에서 앞섭니다', '탱크 차이를 살려 라인을 밀어']),
  BranchDetector('어웨이 탱크 우위', ['벌처 시야 확보! 상대 탱크를 먼저 포착', '시야 싸움 승리', '탱크 차이로 라인을 밀어']),
];

// S12: 레이스 미러 (tvt_wraith_mirror)
List<BranchDetector> s12Phase2() => [
  BranchDetector('홈 클로킹 먼저', ['클로킹 완성! 레이스가 투명해집니다', '디텍이 늦습니다! SCV가 녹고', '클로킹 레이스로 SCV를 학살']),
  BranchDetector('어웨이 클로킹 먼저', ['클로킹 완성! 레이스가 상대 진영에 침투', '디텍이 없습니다! SCV가 쓰러지', '클로킹 레이스로 SCV 학살']),
  BranchDetector('양쪽 클로킹 동시', ['양쪽 클로킹이 거의 동시에', '보이지 않는 전투', '클로킹 레이스 대 클로킹 레이스']),
];

// S13: 5팩 미러 (tvt_5fac_mirror)
List<BranchDetector> s13Phase2() => [
  BranchDetector('홈 시야 우위', ['벌처로 시야를 잡았습니다', '시즈 탱크 선제 포격', '시야 싸움에서 앞선 쪽']),
  BranchDetector('어웨이 시야 우위', ['마인으로 상대 벌처를 잡습니다', '탱크를 우회시켜 측면에서 포격', '측면 포격으로 탱크 라인이 무너']),
];

// S14: 배럭더블 미러 (tvt_cc_first_mirror)
List<BranchDetector> s14Phase2() => [
  BranchDetector('홈 벌처 우세', ['벌처 컨트롤이 좋습니다', '마인 매설로 맵 컨트롤', '벌처로 상대 앞마당 SCV를 괴롭']),
  BranchDetector('어웨이 벌처 우세', ['빠른 속업으로 상대 벌처를 따라잡', '마인 매설로 맵 컨트롤', '상대 앞마당으로 침투']),
  BranchDetector('벌처 교착', ['양측 벌처가 비등합니다', '벌처전은 무승부', '시즈 탱크 대치로 넘어']),
];
List<BranchDetector> s14Phase4() => [
  BranchDetector('홈 드랍 성공', ['드랍십 출격! 상대 확장기지에 탱크를 내립', '확장기지 SCV가 큰 피해', '정면에서도 탱크 라인을 전진']),
  BranchDetector('어웨이 드랍 성공', ['드랍십으로 상대 본진을 기습', '본진 생산시설이 위협', '상대가 흔들리는 사이 정면']),
  BranchDetector('정면 교전', ['드랍 없이 정면 승부', '탱크 라인을 밀어올립니다', '골리앗 화력으로 맞섭니다']),
];

// S15: 투팩벌처 미러 (tvt_2fac_vulture_mirror)
List<BranchDetector> s15Phase2() => [
  BranchDetector('홈 벌처 컨트롤 승', ['벌처 컨트롤이 한 수 위', '마인 매설로 맵 전체를 장악', 'SCV에 피해를 입힙니다']),
  BranchDetector('어웨이 벌처 컨트롤 승', ['속업 타이밍이 더 빠릅니다', 'SCV 대량 학살', '마인 매설로 맵 장악']),
];

// S16: 원팩확장 미러 (tvt_1fac_expand_mirror)
List<BranchDetector> s16Phase2() => [
  BranchDetector('홈 트리플 먼저', ['세 번째 확장을 올립니다! 트리플 커맨드', '트리플이 늦습니다', '세 번째 확장이 가동됩니다']),
  BranchDetector('어웨이 트리플 먼저', ['세 번째 확장을 올립니다! 빠른 트리플', '트리플이 늦었습니다', '세 번째 확장이 풀가동']),
  BranchDetector('동시 트리플', ['양측 거의 동시에 세 번째', '동등한 자원 경쟁', '동시 트리플']),
];
List<BranchDetector> s16Phase4() => [
  BranchDetector('홈 드랍 성공', ['드랍십 출격! 상대 확장기지에 탱크를 투하', '골리앗을 돌리지만 이미 늦었', '드랍 성공! 자원 격차']),
  BranchDetector('어웨이 드랍 성공', ['드랍십으로 상대 본진을 기습', '본진 피해! 팩토리가 타격', '본진 기습 성공']),
];
