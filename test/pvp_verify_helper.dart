import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의 (양쪽 모두 프로토스)
// =========================================================

/// 동급 프로토스 1 (~700)
final homeEqual = Player(
  id: 'p1_equal', name: '김택용', raceIndex: 2,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 프로토스 2 (~700)
final awayEqual = Player(
  id: 'p2_equal', name: '송병구', raceIndex: 2,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// A급 프로토스 1 (~780)
final homeAGrade = Player(
  id: 'p1_a', name: '김택용A', raceIndex: 2,
  stats: const PlayerStats(
    sense: 770, control: 780, attack: 790, harass: 760,
    strategy: 800, macro: 770, defense: 780, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// S급 프로토스 1 (~850)
final homeSGrade = Player(
  id: 'p1_s', name: '김택용S0', raceIndex: 2,
  stats: const PlayerStats(
    sense: 840, control: 850, attack: 860, harass: 830,
    strategy: 870, macro: 840, defense: 850, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S+ 프로토스 1 (~920)
final homeSPlus = Player(
  id: 'p1_splus', name: '김택용S', raceIndex: 2,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 프로토스 1 (~650)
final homeBGrade = Player(
  id: 'p1_b', name: '김택용B', raceIndex: 2,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// 공격 특화 프로토스 1 (attack/harass/control 높음)
final homeAttack = Player(
  id: 'p1_atk', name: '김택용ATK', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 프로토스 1 (defense/strategy/macro 높음)
final homeDefense = Player(
  id: 'p1_def', name: '김택용DEF', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// A급 프로토스 2 (~780)
final awayAGrade = Player(
  id: 'p2_a', name: '송병구A', raceIndex: 2,
  stats: const PlayerStats(
    sense: 780, control: 790, attack: 770, harass: 780,
    strategy: 760, macro: 800, defense: 770, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// S급 프로토스 2 (~850)
final awaySGrade = Player(
  id: 'p2_s', name: '송병구S0', raceIndex: 2,
  stats: const PlayerStats(
    sense: 850, control: 860, attack: 840, harass: 850,
    strategy: 830, macro: 870, defense: 840, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S+ 프로토스 2 (~920)
final awaySPlus = Player(
  id: 'p2_splus', name: '송병구S', raceIndex: 2,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 프로토스 2 (~650)
final awayBGrade = Player(
  id: 'p2_b', name: '송병구B', raceIndex: 2,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// 공격 특화 프로토스 2 (attack/harass/control 높음)
final awayAttack = Player(
  id: 'p2_atk', name: '송병구ATK', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 프로토스 2 (defense/strategy/macro 높음)
final awayDefense = Player(
  id: 'p2_def', name: '송병구DEF', raceIndex: 2,
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
// 홈/어웨이 반전 포함 배치 실행 (미러: 300게임 = 150+150)
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
  // 정방향: player1=홈
  final fwd = await runBatch(
    home: player1, away: player2, map: map,
    homeBuild: build1, awayBuild: build2, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 역방향: player2=홈
  final rev = await runBatch(
    home: player2, away: player1, map: map,
    homeBuild: build2, awayBuild: build1, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합 (홈 관점 = player1 관점)
  final combined = BatchResult();
  combined.homeWins = fwd.homeWins + rev.awayWins; // player1 승
  combined.awayWins = fwd.awayWins + rev.homeWins; // player2 승
  combined.armyMargins.addAll(fwd.armyMargins);
  combined.armyMargins.addAll(rev.armyMargins.map((m) => -m));
  combined.resourceMargins.addAll(fwd.resourceMargins);
  combined.resourceMargins.addAll(rev.resourceMargins.map((m) => -m));

  // 분기 합산
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

  // 맵별 비교 (홈승률 높은 순 정렬)
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

  return buf.toString();
}

// =========================================================
// 시나리오별 분기 정의
// =========================================================

// S1: 드라군 넥서스 미러
List<BranchDetector> s1Phase2() => [
  BranchDetector('로보+다크', ['로보틱스 건설! 리버를 준비', '아둔 건설! 질럿 발업', '다크 템플러가 잠입합니다', '다크 테크! 기습을 노리는']),
  BranchDetector('양쪽 로보', ['셔틀 리버 경쟁', '양측 셔틀 리버가 교차', '서로 견제합니다']),
];
List<BranchDetector> s1Phase3() => [
  BranchDetector('리버 성공', ['셔틀이 상대 프로브 라인에 리버를 내립니다', '리버 투하! 프로브가 날아갑니다', '셔틀이 리버를 태우고 안전하게 빠집니다', '리버 견제가 성공']),
  BranchDetector('셔틀 격추', ['드라군이 셔틀을 집중 사격합니다! 격추', '드라군 집중! 셔틀이 격추', '셔틀이 떨어집니다! 리버가 고립', '셔틀 격추! PvP에서']),
];

// S2: 드라군 vs 노겟넥서스
List<BranchDetector> s2Phase2() => [
  BranchDetector('질럿 피해', ['질럿이 프로브 3기를 잡습니다', '질럿 컨트롤! 프로브 피해가', '노겟 넥서스의 이점이 줄어듭니다', '노겟 넥서스를 흔듭니다', '질럿 견제 성공']),
  BranchDetector('프로브 방어', ['프로브와 질럿의 협공으로 적 질럿을 잡아냅니다', '프로브 컨트롤! 질럿을 잡습니다', '질럿을 잃었습니다! 견제 실패', '넥서스의 자원이 빛을 발합니다', '자원 이점을 병력으로 전환', '프로브 수비 성공']),
];

// S3: 로보리버 vs 투겟드라군
List<BranchDetector> s3Phase2() => [
  BranchDetector('드라군 압도', ['드라군 물량이 리버 나오기 전에 밀어냅니다', '드라군이 압도합니다! 수가 너무 많아요', '리버를 잡아냅니다! 드라군 집중 사격', '드라군 물량 차이가 결정적']),
  BranchDetector('리버 역전', ['리버 스캐럽! 드라군 2기가 한 번에', '스캐럽 명중! 드라군이 터집니다', '셔틀 리버 컨트롤! 내렸다 태웠다', '리버 화력이 드라군 물량을 압도']),
];

// S4: 다크 올인 vs 드라군
List<BranchDetector> s4Phase2() => [
  BranchDetector('다크 학살', ['다크가 프로브를 베기 시작합니다! 옵저버가 없어요', '다크 성공! 프로브가 몰살', '디텍이 없습니다! 로보틱스를 짓지 않았어요', '다크가 프로브를 전멸', '다크 올인 대성공']),
  BranchDetector('다크 차단', ['옵저버가 다크를 포착', '옵저버 있습니다! 다크가 보여요', '드라군이 다크를 집중 사격! 격파', '다크를 잡아냅니다', '다크 올인이 막혔습니다']),
];

// S5: 질럿러시 vs 스탠다드
List<BranchDetector> s5Phase2() => [
  BranchDetector('러시 성공', ['질럿이 프로브를 잡습니다! 수적 우위', '질럿이 프로브를 베어냅니다', '추가 질럿까지 합류! 상대 본진 초토화', '질럿 러시 성공! 프로토스가 무너지고']),
  BranchDetector('수비 성공', ['질럿과 프로브로 협공! 적 질럿을 잡아냅니다', '완벽한 수비! 질럿 러시를 막습니다', '질럿이 녹고 있습니다! 러시 실패', '질럿 러시가 막혔습니다! 테크 차이']),
];

// S6: 다크 vs 질럿러시
List<BranchDetector> s6Phase2() => [
  BranchDetector('질럿 돌파', ['질럿이 게이트웨이를 부수고 들어갑니다', '질럿이 건물을 부수기 시작합니다', '추가 질럿 합류! 템플러 아카이브도 위험', '질럿 러시가 다크보다 빨랐습니다']),
  BranchDetector('다크 역전', ['다크 템플러가 나옵니다! 질럿 러시를 버텨냈습니다', '다크 등장! 보이지 않는 반격', '다크가 질럿을 베기 시작합니다! 디텍이 없어요', '다크 템플러가 판을 뒤집습니다']),
];

// S7: 로보틱스 미러
List<BranchDetector> s7Phase2() => [
  BranchDetector('홈 리버 우세', ['리버가 프로브 라인에 착지! 스캐럽', '리버 투하! 프로브가 날아갑니다', '셔틀은 잃었지만 프로브 피해를 더 많이 줬습니다', '리버 교환이 끝났습니다! 프로브 피해 차이']),
  BranchDetector('어웨이 리버 우세', ['리버가 프로브 라인에 투하! 스캐럽 명중', '리버 투하! 프로브가 쓸려갑니다', '프로브 피해를 더 많이 입혔습니다! 자원 이점', '리버 견제 교환! 프로브 피해가 핵심']),
];
List<BranchDetector> s7Phase4() => [
  BranchDetector('홈 스톰', ['스톰! 상대 드라군이 녹습니다', '스톰! 드라군 편대가 증발']),
  BranchDetector('어웨이 스톰', ['맞스톰! 하지만 이미 병력 차이가 벌어졌습니다']),
];

// S8: 4게이트 vs 원겟멀티
List<BranchDetector> s8Phase2() => [
  BranchDetector('드라군 타이밍', ['드라군 물량으로 상대 앞마당을 밀어냅니다', '드라군이 밀려옵니다! 수가 너무 많아요', '앞마당 넥서스를 공격합니다! 확장을 무너뜨립니다', '4게이트 타이밍! 멀티가 자리잡기 전에']),
  BranchDetector('멀티 수비', ['드라군과 질럿으로 앞마당을 지켜냅니다', '수비 성공! 드라군을 잡아냅니다', '게이트웨이가 추가로 돌아갑니다! 멀티 자원이 빛을 발합니다', '병력이 쏟아져 나옵니다! 멀티의 힘']),
];

// S9: 질럿러시 vs 로보리버
List<BranchDetector> s9Phase2() => [
  BranchDetector('질럿 선제', ['질럿이 프로브를 잡습니다! 리버가 아직이에요', '질럿이 프로브를 베어냅니다', '추가 질럿 합류! 로보틱스까지 위협', '질럿 러시 성공! 리버가 나오기 전에']),
  BranchDetector('리버 역전', ['질럿과 프로브로 버팁니다! 리버가 곧', '수비! 리버만 나오면', '리버가 나왔습니다! 스캐럽! 질럿이 터집니다', '리버가 판을 뒤집습니다! 질럿으로는 리버를']),
];

// S10: 다크 미러
List<BranchDetector> s10Phase2() => [
  BranchDetector('홈 다크 우세', ['다크가 프로브 라인에 도착! 학살', '다크 성공! 프로브가 몰살', '다크 컨트롤! 프로브를 더 많이 잡았습니다', '다크 교환! 프로브 피해 차이가 승부를']),
  BranchDetector('어웨이 다크 우세', ['다크가 프로브를 베기 시작합니다! 큰 피해', '다크 대성공! 프로브가 녹습니다', '다크 컨트롤! 더 많은 프로브를 잡습니다', '다크 교환에서 밀렸습니다! 프로브 차이']),
];
List<BranchDetector> s10Phase4() => [
  BranchDetector('홈 복구 우세', ['프로브를 먼저 복구! 자원이 돌아옵니다', '일꾼 복구가 빠릅니다', '다크 교환 이후 복구전에서 앞섭니다']),
  BranchDetector('어웨이 복구 우세', ['프로브를 먼저 복구! 자원이 돌아옵니다', '일꾼 복구가 빠릅니다', '다크 교환 이후 복구전에서 앞섭니다']),
];
