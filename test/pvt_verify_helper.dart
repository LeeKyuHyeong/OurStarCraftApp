import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의
// =========================================================

/// 동급 프로토스 (~700)
final pEqual = Player(
  id: 'p_equal', name: '김택용', raceIndex: 2,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 테란 (~700)
final tEqual = Player(
  id: 't_equal', name: '이영호', raceIndex: 0,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// A급 프로토스 (~780)
final pAGrade = Player(
  id: 'p_a', name: '김택용A', raceIndex: 2,
  stats: const PlayerStats(
    sense: 770, control: 780, attack: 790, harass: 760,
    strategy: 800, macro: 770, defense: 780, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// A급 테란 (~780)
final tAGrade = Player(
  id: 't_a', name: '이영호A', raceIndex: 0,
  stats: const PlayerStats(
    sense: 780, control: 790, attack: 770, harass: 780,
    strategy: 760, macro: 800, defense: 770, scout: 790,
  ),
  levelValue: 8, condition: 100,
);

/// S급 프로토스 (~850)
final pSGrade = Player(
  id: 'p_s', name: '김택용S0', raceIndex: 2,
  stats: const PlayerStats(
    sense: 840, control: 850, attack: 860, harass: 830,
    strategy: 870, macro: 840, defense: 850, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S급 테란 (~850)
final tSGrade = Player(
  id: 't_s', name: '이영호S0', raceIndex: 0,
  stats: const PlayerStats(
    sense: 850, control: 860, attack: 840, harass: 850,
    strategy: 830, macro: 870, defense: 840, scout: 860,
  ),
  levelValue: 9, condition: 100,
);

/// S+ 프로토스 (~920)
final pSPlus = Player(
  id: 'p_splus', name: '김택용S', raceIndex: 2,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// S+ 테란 (~920)
final tSPlus = Player(
  id: 't_splus', name: '이영호S', raceIndex: 0,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 프로토스 (~650)
final pBGrade = Player(
  id: 'p_b', name: '김택용B', raceIndex: 2,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// B급 테란 (~650)
final tBGrade = Player(
  id: 't_b', name: '이영호B', raceIndex: 0,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// 공격 특화 프로토스 (attack/harass/control 높음)
final pAttack = Player(
  id: 'p_atk', name: '김택용ATK', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 프로토스 (defense/strategy/macro 높음)
final pDefense = Player(
  id: 'p_def', name: '김택용DEF', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 공격 특화 테란 (attack/harass/control 높음)
final tAttack = Player(
  id: 't_atk', name: '이영호ATK', raceIndex: 0,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 테란 (defense/strategy/macro 높음)
final tDefense = Player(
  id: 't_def', name: '이영호DEF', raceIndex: 0,
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
  final String homeBuild;
  final String awayBuild;
  final List<BranchDetector> Function() phase2Branches;
  final List<BranchDetector> Function()? phase4Branches;

  const ScenarioConfig({
    required this.id,
    required this.name,
    required this.homeBuild,
    required this.awayBuild,
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
// 홈/어웨이 반전 포함 배치 실행 (300게임 = 150+150)
// =========================================================

Future<BatchResult> runBatchBiDir({
  required Player pPlayer,
  required Player tPlayer,
  required GameMap map,
  required String pBuild,
  required String tBuild,
  required int countPerDir,
  required List<BranchDetector> Function() makeBranches2,
  List<BranchDetector> Function()? makeBranches4,
}) async {
  // 정방향: 프로토스=홈
  final fwd = await runBatch(
    home: pPlayer, away: tPlayer, map: map,
    homeBuild: pBuild, awayBuild: tBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 역방향: 테란=홈, 프로토스=어웨이
  final rev = await runBatch(
    home: tPlayer, away: pPlayer, map: map,
    homeBuild: tBuild, awayBuild: pBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합 (역방향에서는 away가 프로토스이므로 awayWins이 프로토스승)
  final combined = BatchResult();
  combined.homeWins = fwd.homeWins + rev.awayWins; // 프로토스 승
  combined.awayWins = fwd.awayWins + rev.homeWins; // 테란 승
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
  buf.writeln('| 전적 | P ${result.homeWins} - ${result.awayWins} T (${result.total}게임) |');
  buf.writeln('| P 승률 | ${result.homeWinRate.toStringAsFixed(1)}% |');
  buf.writeln('| 평균 병력차 | ${result.avgArmy.toStringAsFixed(1)} |');
  buf.writeln('| 평균 자원차 | ${result.avgResource.toStringAsFixed(1)} |');
  buf.writeln('');

  if (result.phase2.isNotEmpty) {
    final p2Total = result.phase2.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**$phaseName2** (${p2Total}감지 / ${result.p2Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
    for (final b in result.phase2) {
      buf.writeln('| ${b.name} | ${b.count} | ${b.pct(p2Total)} | ${b.winRate(b.count)} |');
    }
    buf.writeln('');
  }

  if (result.phase4.isNotEmpty) {
    final p4Total = result.phase4.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**${phaseName4 ?? 'Phase 4'}** (${p4Total}감지 / ${result.p4Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | P승률 |');
    buf.writeln('|------|------|------|-------|');
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
  buf.writeln('| 설정 | 게임수 | P승 | T승 | P승률 | 병력차 | 자원차 |');
  buf.writeln('|------|--------|-----|-----|-------|--------|--------|');
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
    buf.writeln('| 분기 | 발동 | 비율 | P승률 | 미감지 |');
    buf.writeln('|------|------|------|-------|--------|');
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
    buf.writeln('| 분기 | 발동 | 비율 | P승률 | 미감지 |');
    buf.writeln('|------|------|------|-------|--------|');
    for (final b in mainResult.phase4) {
      buf.writeln('| ${b.name} | ${b.count} '
          '| ${b.pct(p4Total)} | ${b.winRate(b.count)} '
          '| - |');
    }
    buf.writeln('| 미감지 | ${mainResult.p4Unknown} '
        '| ${pctStr(mainResult.p4Unknown, mainResult.total)} | - | - |');
    buf.writeln('');
  }

  // 맵별 비교 (P승률 높은 순 정렬)
  final mapResults = results.entries
      .where((e) => e.key.contains('맵'))
      .toList()
    ..sort((a, b) => b.value.homeWinRate.compareTo(a.value.homeWinRate));
  if (mapResults.isNotEmpty) {
    buf.writeln('## 맵별 비교 (P승률 높은순)\n');
    buf.writeln('| 맵 | 게임수 | P승률 |');
    buf.writeln('|----|--------|-------|');
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

// S1: 드라군 확장 vs 팩더블
List<BranchDetector> s1Phase2() => [
  BranchDetector('드라군 압박', ['드라군 편대가 전진', '사업 완료된 드라군', '드라군 화력이 탱크 라인을']),
  BranchDetector('벌처 견제', ['벌처가 프로토스 멀티로 돌진', '프로브가 마인에', '벌처 견제가 판을 흔들고']),
  BranchDetector('옵저버 정찰', ['옵저버가 전장을 정찰', '마인 위치가 보입니다', '마인 위치를 완벽히 파악', '마인이 무력화']),
];
List<BranchDetector> s1Phase4() => [
  BranchDetector('아비터', ['아비터 트리뷰널 건설', '아비터 등장', '리콜! 테란 본진', '리콜 투하']),
  BranchDetector('탱크 푸시', ['시즈 탱크 5기 이상', '대규모 푸시', '시즈 모드! 프로토스 앞마당', '탱크 화력이 프로토스 전선을']),
];

// S2: 리버 셔틀 vs 타이밍 러시
List<BranchDetector> s2Phase2() => [
  BranchDetector('리버 성공', ['SCV 5기가 한 번에', '스캐럽 대박', '셔틀이 리버를 태우고 빠집니다', '셔틀 컨트롤! 리버를 살려냅니다']),
  BranchDetector('셔틀 격추', ['터렛과 골리앗이 셔틀을 포착', '셔틀 격추! 리버가 땅에', '셔틀 폭사! 프로토스에게 치명적']),
];
List<BranchDetector> s2Phase4() => [
  BranchDetector('스톰 마무리', ['하이 템플러 합류! 사이오닉 스톰', '스톰 투하! 바이오닉', '마린이 스톰에 녹아내립니다', '스톰이 결정적']),
  BranchDetector('테란 물량', ['5팩토리 풀가동', '팩토리 5개에서 물량', '대규모 시즈 라인', '테란 물량이 프로토스를 압도']),
];

// S3: 다크 템플러 vs 스탠다드
List<BranchDetector> s3Phase2() => [
  BranchDetector('다크 성공', ['다크 템플러가 SCV를 베기', '다크 성공! SCV가 줄줄이', '디텍이 없습니다', '다크 한 기가 SCV를 10기', '다크 템플러가 대활약']),
  BranchDetector('다크 실패', ['스캔! 다크 템플러 위치가', '컴샛으로 다크를 포착', '마린이 다크 템플러를 집중 사격', '다크를 잡아냅니다', '다크 전략이 간파']),
];

// S4: 센터 게이트 질럿 러시 vs 스탠다드
List<BranchDetector> s4Phase2() => [
  BranchDetector('러시 성공', ['질럿이 SCV를 베기 시작', '벙커가 완성되지 않았어요', '추가 질럿 합류! 테란 본진이 초토화', '질럿 러시가 성공적! 테란이 무너지고']),
  BranchDetector('수비 성공', ['벙커 완성! 마린이 들어갑니다', '질럿이 벙커에 막힙니다', 'SCV 수리까지', '질럿 러시가 막혔습니다! 프로토스가 위기']),
];

// S5: 캐리어 vs 안티 캐리어
List<BranchDetector> s5Phase2() => [
  BranchDetector('캐리어 지배', ['캐리어 3기! 인터셉터가 쏟아져', '캐리어 편대! 인터셉터가 비처럼', '골리앗이 캐리어를 노리지만 인터셉터에 막힙니다', '스톰+캐리어', '캐리어가 전장을 지배']),
  BranchDetector('골리앗 카운터', ['골리앗 편대가 캐리어를 집중 포화', '골리앗 집중 사격! 캐리어가 흔들', '캐리어 1기가 격추', '안티 캐리어 전략이 효과']),
];

// S6: 5게이트 푸시 vs 팩더블
List<BranchDetector> s6Phase2() => [
  BranchDetector('드라군 압도', ['드라군 물량으로 탱크 라인을 밀어냅니다', '드라군이 탱크를 녹입니다', '앞마당 진입! 테란 앞마당이 무너집니다', '5게이트 타이밍 공격 성공']),
  BranchDetector('테란 수비', ['시즈 탱크 시즈 모드! 드라군이 녹기', '탱크 포격! 드라군이 한 방에', '벌처 측면 기동', '타이밍 공격이 막혔습니다']),
];

// S7: 질럿 vs BBS (치즈 vs 치즈)
List<BranchDetector> s7Phase2() => [
  BranchDetector('질럿 압도', ['질럿이 마린에 달라붙습니다', '질럿 컨트롤! 마린을 순식간에 정리', '질럿이 마린을 제압했습니다']),
  BranchDetector('벙커 수비', ['벙커 완성! 마린이 들어갑니다', '질럿이 벙커에 막힙니다', '벙커가 질럿을 막아냈습니다']),
];

// S8: 리버 셔틀 vs BBS
List<BranchDetector> s8Phase2() => [
  BranchDetector('BBS 수비 성공', ['프로브까지 동원해서 벙커 건설을 저지', '프로브 컨트롤! SCV를 끊어냅니다', '리버 생산 완료! 셔틀에 탑승', 'BBS를 막고 리버 역습']),
  BranchDetector('BBS 돌파', ['벙커링 성공! 프로토스 앞마당이 위험', '마린이 프로브를 쓸어버립니다', 'BBS가 프로토스를 무너뜨리고']),
];

// S9: 확장 vs 마인 트리플
List<BranchDetector> s9Phase2() => [
  BranchDetector('옵저버 마인 제거', ['옵저버 출격! 마인 위치를 밝혀', '옵저버 정찰! 마인이 다 보입니다', '드라군이 마인을 하나씩 처리', '마인 방어선이 뚫리고']),
  BranchDetector('마인 피해', ['드라군이 전진하는데 마인에 걸립니다', '드라군이 마인에 터집니다', '벌처가 마인 위치로 유인']),
];
List<BranchDetector> s9Phase4() => [
  BranchDetector('스톰 돌파', ['하이 템플러 합류! 사이오닉 스톰', '스톰 투하! 테란 병력이 녹아내립니다', '스톰이 결정적! 트리플 체제를 무너뜨립니다']),
  BranchDetector('테란 화력', ['시즈 탱크 집중 포격! 드라군이 한 방에', '탱크 포격! 드라군 편대가 무너집니다', '트리플 자원의 화력이 프로토스를 압도']),
];

// S10: 11업 8팩 vs 드라군 확장
List<BranchDetector> s10Phase2() => [
  BranchDetector('프로토스 먼저 압박', ['사업 완료 드라군 편대가 전진', '드라군 푸시! 탱크가 모이기 전에', '드라군이 테란 앞마당을 압박']),
  BranchDetector('테란 업그레이드 전진', ['메카닉 업그레이드 완료! 화력이 올라갑니다', '8팩토리에서 탱크 벌처가 쏟아져', '8팩 가동! 물량이 끝없이 나옵니다']),
];
List<BranchDetector> s10Phase4() => [
  BranchDetector('스톰 승리', ['사이오닉 스톰! 메카닉 사이로 떨어집니다', '스톰 투하! 벌처가 녹아내립니다', '스톰이 결정적! 프로토스가 밀어냅니다']),
  BranchDetector('탱크 화력 승리', ['시즈 탱크 일제 포격! 드라군이 부서집니다', '업그레이드된 탱크 화력! 드라군이 견디지 못합니다', '업그레이드된 화력이 결정적']),
];

// S11: FD테란 vs 프로토스
List<BranchDetector> s11Phase2() => [
  BranchDetector('벌처 견제 성공', ['벌처가 프로토스 멀티로 돌진! 마인 투하', '벌처 기동! 프로브가 마인에 당합니다', '벌처 견제가 프로토스 내정을 흔들고']),
  BranchDetector('드라군 방어', ['드라군이 벌처를 잡아냅니다', '드라군으로 벌처를 격퇴', '프로토스가 벌처 견제를 막아내며']),
];
List<BranchDetector> s11Phase4() => [
  BranchDetector('아비터 리콜', ['아비터 트리뷰널 건설', '아비터 등장! 리콜로 테란 본진', '리콜 투하! 테란 본진이 위험', '아비터 리콜이 판을 뒤집습니다']),
  BranchDetector('테란 FD 푸시', ['사이언스 퍼실리티 건설! 사이언스 베슬', '시즈 탱크 라인 전진! 베슬과 함께', 'EMP! 프로토스 실드가 사라집니다', 'FD테란의 화력이 프로토스를 밀어붙입니다']),
];
