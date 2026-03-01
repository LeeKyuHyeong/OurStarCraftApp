import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의 (ZvZ 미러 - 양쪽 모두 저그)
// =========================================================

/// 동급 저그 1 (~700)
final homeEqual = Player(
  id: 'z1_equal', name: '이재동', raceIndex: 1,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 저그 2 (~700)
final awayEqual = Player(
  id: 'z2_equal', name: '박성준', raceIndex: 1,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// A급 저그 1 (~780)
final homeAGrade = Player(
  id: 'z1_a', name: '이재동A', raceIndex: 1,
  stats: const PlayerStats(
    sense: 780, control: 790, attack: 770, harass: 780,
    strategy: 760, macro: 800, defense: 770, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// A급 저그 2 (~780)
final awayAGrade = Player(
  id: 'z2_a', name: '박성준A', raceIndex: 1,
  stats: const PlayerStats(
    sense: 770, control: 780, attack: 790, harass: 760,
    strategy: 800, macro: 770, defense: 780, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// S급 저그 1 (~850)
final homeSGrade = Player(
  id: 'z1_s', name: '이재동S', raceIndex: 1,
  stats: const PlayerStats(
    sense: 850, control: 860, attack: 840, harass: 850,
    strategy: 830, macro: 870, defense: 840, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S급 저그 2 (~850)
final awaySGrade = Player(
  id: 'z2_s', name: '박성준S', raceIndex: 1,
  stats: const PlayerStats(
    sense: 840, control: 850, attack: 860, harass: 830,
    strategy: 870, macro: 840, defense: 850, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S+ 저그 1 (~920)
final homeSPlus = Player(
  id: 'z1_splus', name: '이재동S+', raceIndex: 1,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// S+ 저그 2 (~920)
final awaySPlus = Player(
  id: 'z2_splus', name: '박성준S+', raceIndex: 1,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 저그 1 (~650)
final homeBGrade = Player(
  id: 'z1_b', name: '이재동B', raceIndex: 1,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// B급 저그 2 (~650)
final awayBGrade = Player(
  id: 'z2_b', name: '박성준B', raceIndex: 1,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// 공격 특화 저그 1 (attack/harass/control 높음)
final homeAttack = Player(
  id: 'z1_atk', name: '이재동ATK', raceIndex: 1,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 공격 특화 저그 2 (attack/harass/control 높음)
final awayAttack = Player(
  id: 'z2_atk', name: '박성준ATK', raceIndex: 1,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 저그 1 (defense/strategy/macro 높음)
final homeDefense = Player(
  id: 'z1_def', name: '이재동DEF', raceIndex: 1,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 저그 2 (defense/strategy/macro 높음)
final awayDefense = Player(
  id: 'z2_def', name: '박성준DEF', raceIndex: 1,
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
// 홈/어웨이 반전 포함 배치 실행 (미러: player1/player2)
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

  // 역방향: player2=홈, player1=어웨이
  final rev = await runBatch(
    home: player2, away: player1, map: map,
    homeBuild: build2, awayBuild: build1, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합 (역방향에서는 away가 player1이므로 awayWins이 player1 승)
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

// S1: 9풀 vs 9오버풀
List<BranchDetector> s1Phase2() => [
  BranchDetector('9풀 공격 성공', ['저글링이 입구를 뚫었습니다', '드론까지 노립니다', '추가 저글링 합류! 상대 드론을 초토화']),
  BranchDetector('9오버풀 수비 성공', ['언덕에서 저글링을 효과적으로 막아', '좁은 입구에서 잘 막습니다', '드론 한 기 차이가 벌어지기']),
];
List<BranchDetector> s1Phase4() => [
  BranchDetector('뮤탈 선점 견제', ['뮤탈리스크가 먼저 나왔습니다', '뮤탈 선점! 드론을 물어', '뮤탈이 스포어를 피하면서']),
  BranchDetector('스커지 대응', ['스커지를 뽑으면서 뮤탈에 대비', '스커지 자폭! 뮤탈 2기를 잡아', '스커지가 뮤탈에 돌진']),
];

// S2: 12앞마당 vs 9풀
List<BranchDetector> s2Phase2() => [
  BranchDetector('앞마당 파괴', ['저글링이 드론을 뚫습니다', '앞마당 해처리가 부서지고', '앞마당이 무너집니다']),
  BranchDetector('수비 성공', ['성큰이 완성됩니다! 저글링을 잡아', '성큰 완성! 저글링이 녹습니다', '드론으로 협공! 완벽한 수비', '드론으로 협공! 수비 성공']),
];
List<BranchDetector> s2Phase4() => [
  BranchDetector('12앞 자원 역전', ['앞마당 자원 덕분에 뮤탈 수를 따라잡', '자원 우위! 뮤탈 물량으로 역전', '뮤탈로 반격! 상대 드론을 견제']),
  BranchDetector('9풀 뮤탈 선점', ['뮤탈 수 차이로 공중전을 압도', '뮤탈로 드론을 계속 물어뜯', '뮤탈 견제 이어갑니다']),
];

// S3: 4풀 vs 12앞마당
List<BranchDetector> s3Phase2() => [
  BranchDetector('4풀 파괴', ['저글링이 드론을 물어뜯습니다! 앞마당도 파괴', '저글링이 모든 걸 파괴', '드론이 전멸하고 있습니다']),
  BranchDetector('드론 수비', ['드론을 뭉쳐서 저글링과 교전', '드론 컨트롤! 저글링을 잡아', '스포닝풀이 완성됩니다! 저글링으로 반격']),
];
List<BranchDetector> s3Phase4() => [
  BranchDetector('4풀 마지막 돌진', ['남은 저글링으로 마지막 돌진', '4풀의 마지막 공격이 상대 자원줄을 끊']),
  BranchDetector('12앞 물량 역전', ['물량으로 밀어붙입니다! 4풀 선수가 버틸 수 없', '4풀 올인 실패의 대가']),
];

// S4: 3해처리 미러
List<BranchDetector> s4Phase2() => [
  BranchDetector('홈 뮤탈 컨트롤', ['뮤탈 편대 컨트롤이 좋습니다! 상대 뮤탈을 낚', '뮤탈 컨트롤 차이! 상대 뮤탈을 격파', '드론을 물어뜯으면서 압박']),
  BranchDetector('어웨이 뮤탈 컨트롤', ['뮤탈 편대 컨트롤이 좋습니다! 상대 뮤탈을 낚', '뮤탈 컨트롤 차이! 상대 뮤탈을 격파']),
];
List<BranchDetector> s4Phase4() => [
  BranchDetector('홈 뮤탈 결전', ['뮤탈 집중 공격! 상대 뮤탈이 떨어집니다', '남은 뮤탈로 드론을 견제합니다']),
  BranchDetector('어웨이 뮤탈 결전', ['뮤탈 집중 공격! 상대 뮤탈이 떨어집니다']),
];

// S5: 4풀 vs 9풀
List<BranchDetector> s5Phase2() => [
  BranchDetector('4풀 드론 피해', ['저글링이 드론을 물어뜯습니다! 피해가 큽니다', '저글링이 드론을 잡습니다', '드론 피해가 컸습니다']),
  BranchDetector('9풀 빠른 대응', ['저글링이 빠르게 나옵니다! 드론과 함께 방어', '저글링+드론 협공! 4풀을 잡아', '발업 연구까지! 저글링 교전에서 우위']),
];
List<BranchDetector> s5Phase4() => [
  BranchDetector('4풀 필사 공격', ['남은 저글링을 모아서 필사의 공격', '4풀의 끈질긴 압박이 결실']),
  BranchDetector('9풀 물량 역전', ['발업 저글링이 본진을 덮칩니다', '4풀이 9풀을 상대로는 타이밍이 빠듯']),
];

// S6: 4풀 vs 3해처리
List<BranchDetector> s6Phase2() => [
  BranchDetector('4풀 대성공', ['저글링이 드론을 물어뜯습니다! 앞마당도 공격', '저글링이 드론을 초토화', '추가 저글링 합류! 3해처리의 빈 진영을 파괴']),
  BranchDetector('드론 수비', ['드론을 뭉쳐서 저글링과 교전! 필사적인 수비', '드론 컨트롤! 저글링을 하나씩 잡아', '스포닝풀이 뒤늦게 완성됩니다! 저글링 생산 시작']),
];
List<BranchDetector> s6Phase4() => [
  BranchDetector('4풀 마지막 러시', ['마지막 저글링으로 상대 드론 라인을 급습', '4풀의 집요한 러시가 3해처리의 자원줄을 끊']),
  BranchDetector('3해처리 물량', ['3해처리의 물량이 쏟아집니다! 4풀이 버틸 수 없', '4풀 올인이 3해처리를 못 잡으면']),
];

// S7: 9풀 미러
List<BranchDetector> s7Phase2() => [
  BranchDetector('홈 저글링 컨트롤', ['저글링 컨트롤이 좋습니다! 상대 저글링을 잡아', '저글링 컨트롤 차이! 상대를 압도', '상대 진영으로 진격! 드론을 노립니다']),
  BranchDetector('어웨이 저글링 컨트롤', ['저글링 컨트롤이 좋습니다! 상대 저글링을 잡아', '저글링 컨트롤 차이! 상대를 압도']),
];
List<BranchDetector> s7Phase4() => [
  BranchDetector('홈 뮤탈 견제', ['뮤탈이 먼저 나왔습니다! 상대 드론을 노립니다', '뮤탈이 스포어를 피하면서 견제']),
  BranchDetector('어웨이 뮤탈 견제', ['뮤탈이 먼저 나왔습니다! 상대 드론을 노립니다', '뮤탈이 스포어를 피하면서 견제']),
];

// S8: 12풀 vs 3해처리
List<BranchDetector> s8Phase2() => [
  BranchDetector('저글링 드론 피해', ['저글링이 드론을 물어뜯습니다! 앞마당 드론이 녹', '저글링 돌파! 드론을 잡습니다', '추가 저글링 합류! 앞마당 해처리까지 위협']),
  BranchDetector('3해처리 수비', ['드론 컨트롤로 저글링을 막아냅니다', '드론+저글링 합류! 수비 성공', '앞마당 드론이 살아남으면서 자원 우위']),
];
List<BranchDetector> s8Phase4() => [
  BranchDetector('뮤탈 견제', ['뮤탈이 먼저 나왔습니다! 드론을 노립니다', '뮤탈이 스포어를 피하며 견제', '뮤탈 선점! 3해처리의 드론을 노립니다']),
  BranchDetector('3해처리 뮤탈 물량', ['뮤탈이 쏟아집니다! 3해처리의 자원이 빛나는 순간', '뮤탈 물량! 자원 차이가 드러납니다', '뮤탈로 드론을 견제합니다! 자원 격차가 더 벌어']),
];

// S9: 9오버풀 미러
List<BranchDetector> s9Phase2() => [
  BranchDetector('홈 저글링 견제', ['저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전', '드론 2기를 잡고 빠집니다', '깔끔한 견제! 드론 피해를 주고 빠집니다']),
  BranchDetector('어웨이 저글링 견제', ['저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전', '드론 2기를 잡고 빠집니다']),
];
List<BranchDetector> s9Phase4() => [
  BranchDetector('홈 뮤탈 승리', ['뮤탈 집중 사격! 상대 뮤탈을 노립니다', '뮤탈 컨트롤! 효율적인 교환']),
  BranchDetector('어웨이 뮤탈 승리', ['스커지로 뮤탈을 격추합니다! 동반 추락', '스커지 자폭! 뮤탈을 잡습니다']),
];
