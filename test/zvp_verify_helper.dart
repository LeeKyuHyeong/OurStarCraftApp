import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의
// =========================================================

/// 동급 저그 (~700)
final zEqual = Player(
  id: 'z_equal', name: '이재동', raceIndex: 1,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 프로토스 (~700)
final pEqual = Player(
  id: 'p_equal', name: '김택용', raceIndex: 2,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// S+ 저그 (~920)
final zSPlus = Player(
  id: 'z_splus', name: '이재동S', raceIndex: 1,
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

/// 공격 특화 저그 (attack/harass/control 높음)
final zAttack = Player(
  id: 'z_atk', name: '이재동ATK', raceIndex: 1,
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

/// S+ 프로토스 (~920)
final pSPlus = Player(
  id: 'p_splus', name: '김택용S', raceIndex: 2,
  stats: const PlayerStats(
    sense: 920, control: 930, attack: 910, harass: 920,
    strategy: 900, macro: 940, defense: 910, scout: 930,
  ),
  levelValue: 10, condition: 100,
);

/// B급 저그 (~650)
final zBGrade = Player(
  id: 'z_b', name: '이재동B', raceIndex: 1,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
);

/// A급 저그 (~780)
final zAGrade = Player(
  id: 'z_a', name: '이재동A', raceIndex: 1,
  stats: const PlayerStats(
    sense: 780, control: 790, attack: 770, harass: 780,
    strategy: 760, macro: 800, defense: 770, scout: 790,
  ),
  levelValue: 8, condition: 100,
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

/// S급 저그 (~850)
final zSGrade = Player(
  id: 'z_s', name: '이재동S0', raceIndex: 1,
  stats: const PlayerStats(
    sense: 850, control: 860, attack: 840, harass: 850,
    strategy: 830, macro: 870, defense: 840, scout: 860,
  ),
  levelValue: 9, condition: 100,
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

/// 공격 특화 프로토스 (attack/harass/control 높음)
final pAttack = Player(
  id: 'p_atk', name: '김택용ATK', raceIndex: 2,
  stats: const PlayerStats(
    sense: 650, control: 780, attack: 800, harass: 790,
    strategy: 620, macro: 650, defense: 600, scout: 650,
  ),
  levelValue: 7, condition: 100,
);

/// 수비 특화 저그 (defense/strategy/macro 높음)
final zDefense = Player(
  id: 'z_def', name: '이재동DEF', raceIndex: 1,
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
    tvzTerranWinRate: 65, // TvZ 65
    zvpZergWinRate: 55,   // ZvP 55 (저그유리)
    pvtProtossWinRate: 35, // PvT 35
  ),
);

const mapLuna = GameMap(
  id: 'test_luna', name: '루나',
  rushDistance: 7, resources: 7, terrainComplexity: 6,
  airAccessibility: 7, centerImportance: 4,
  matchup: RaceMatchup(
    tvzTerranWinRate: 42, // TvZ 42
    zvpZergWinRate: 60,   // ZvP 60 (저그유리)
    pvtProtossWinRate: 60, // PvT 60
  ),
);

const mapTuhon = GameMap(
  id: 'test_tuhon', name: '투혼',
  rushDistance: 4, resources: 4, terrainComplexity: 3,
  airAccessibility: 5, centerImportance: 7,
  matchup: RaceMatchup(
    tvzTerranWinRate: 55, // TvZ 55
    zvpZergWinRate: 48,   // ZvP 48 (토스유리)
    pvtProtossWinRate: 45, // PvT 45
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
        break; // 첫 번째 매치만
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
  required Player zPlayer,
  required Player pPlayer,
  required GameMap map,
  required String zBuild,
  required String pBuild,
  required int countPerDir,
  required List<BranchDetector> Function() makeBranches2,
  List<BranchDetector> Function()? makeBranches4,
}) async {
  // 정방향: 저그=홈
  final fwd = await runBatch(
    home: zPlayer, away: pPlayer, map: map,
    homeBuild: zBuild, awayBuild: pBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 역방향: 프로토스=홈, 저그=어웨이
  final rev = await runBatch(
    home: pPlayer, away: zPlayer, map: map,
    homeBuild: pBuild, awayBuild: zBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합 (역방향에서는 away가 저그이므로 awayWins이 저그승)
  final combined = BatchResult();
  combined.homeWins = fwd.homeWins + rev.awayWins; // 저그 승
  combined.awayWins = fwd.awayWins + rev.homeWins; // 프로토스 승
  combined.armyMargins.addAll(fwd.armyMargins);
  combined.armyMargins.addAll(rev.armyMargins.map((m) => -m)); // 역방향은 부호 반전
  combined.resourceMargins.addAll(fwd.resourceMargins);
  combined.resourceMargins.addAll(rev.resourceMargins.map((m) => -m));

  // 분기는 양방향 합산 (같은 인스턴스를 공유하므로 fwd 것 사용)
  combined.phase2 = fwd.phase2;
  combined.phase4 = fwd.phase4;
  // rev의 분기도 합산
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
  buf.writeln('| 전적 | Z ${result.homeWins} - ${result.awayWins} P (${result.total}게임) |');
  buf.writeln('| Z 승률 | ${result.homeWinRate.toStringAsFixed(1)}% |');
  buf.writeln('| 평균 병력차 | ${result.avgArmy.toStringAsFixed(1)} |');
  buf.writeln('| 평균 자원차 | ${result.avgResource.toStringAsFixed(1)} |');
  buf.writeln('');

  if (result.phase2.isNotEmpty) {
    final p2Total = result.phase2.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**$phaseName2** (${p2Total}감지 / ${result.p2Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | Z승률 |');
    buf.writeln('|------|------|------|-------|');
    for (final b in result.phase2) {
      buf.writeln('| ${b.name} | ${b.count} | ${b.pct(p2Total)} | ${b.winRate(b.count)} |');
    }
    buf.writeln('');
  }

  if (result.phase4.isNotEmpty) {
    final p4Total = result.phase4.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**${phaseName4 ?? 'Phase 4'}** (${p4Total}감지 / ${result.p4Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | Z승률 |');
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
  buf.writeln('| 설정 | 게임수 | Z승 | P승 | Z승률 | 병력차 | 자원차 |');
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
    buf.writeln('| 분기 | 발동 | 비율 | Z승률 | 미감지 |');
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
    buf.writeln('| 분기 | 발동 | 비율 | Z승률 | 미감지 |');
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

  // 맵별 비교 (Z승률 높은 순 정렬)
  final mapResults = results.entries
      .where((e) => e.key.contains('맵'))
      .toList()
    ..sort((a, b) => b.value.homeWinRate.compareTo(a.value.homeWinRate));
  if (mapResults.isNotEmpty) {
    buf.writeln('## 맵별 비교 (Z승률 높은순)\n');
    buf.writeln('| 맵 | 게임수 | Z승률 |');
    buf.writeln('|----|--------|-------|');
    // 밸런스맵 포함, 전체를 Z승률 기준 정렬
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
    final winner = mainResult.lastGameHomeWin == true ? 'Z 승리' : 'P 승리';
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

// S1: 히드라 vs 포지더블
List<BranchDetector> s1Phase2() => [
  BranchDetector('히드라 압박', ['히드라 편대가 프로토스 앞마당을 두드립니다', '캐논이 무너지고', '히드라가 앞마당 진입']),
  BranchDetector('커세어 사냥', ['커세어 3기가 오버로드를 연속 격추', '오버로드가 줄줄이 떨어집니다', '서플라이가 막혀서']),
  BranchDetector('캐논 방어', ['캐논 추가 건설', '캐논 라인이 촘촘', '히드라가 캐논']),
];
List<BranchDetector> s1Phase4() => [
  BranchDetector('하이브 테크', ['하이브 완성', '디파일러', '울트라리스크까지 합류']),
  BranchDetector('프로토스 한방', ['한방 병력 완성', '셔틀에 하이 템플러']),
];

// S2: 뮤탈 vs 포지더블
List<BranchDetector> s2Phase2() => [
  BranchDetector('뮤탈 성공', ['뮤탈이 프로브를 물어뜯습니다', '뮤짤', '뮤탈을 빼면서 다른 곳']),
  BranchDetector('커세어 대응', ['커세어가 뮤탈을 쫓아갑니다', '커세어 컨트롤! 뮤탈을 잡아', '스포어도 깔았습니다']),
];

// S3: 9풀 vs 포지더블
List<BranchDetector> s3Phase2() => [
  BranchDetector('돌파', ['캐논 완성 전에 도착', '프로브로 막으려 하지만 저글링이 너무 빠릅니다', '본진까지 침투']),
  BranchDetector('수비', ['캐논 완성! 저글링을 잡아', '캐논이 제때 완성', '질럿까지 나오면서 완벽한 수비']),
];

// S4: 치즈 vs 치즈
List<BranchDetector> s4Phase2() => [
  BranchDetector('저글링', ['저글링 물량이 질럿을 압도', '저글링이 프로브 라인을 초토화', '저글링이 너무 많습니다']),
  BranchDetector('질럿', ['질럿이 저글링을 다 잡아', '질럿 컨트롤! 저글링이 녹아', '저글링이 전멸']),
];

// S5: 뮤커지 vs 커세어 리버
List<BranchDetector> s5Phase2() => [
  BranchDetector('리버', ['리버 투하! 드론이 스캐럽에', '스캐럽 명중! 드론 대학살', '셔틀 회수! 안전하게 빠집니다']),
  BranchDetector('스커지', ['스커지가 셔틀을 포착', '셔틀이 격추됩니다', '고립된 리버를 잡아냅니다']),
];

// S6: 디파일러 vs 한방 병력 (패턴은 해당 분기에만 고유한 텍스트 사용)
List<BranchDetector> s6Phase2() => [
  BranchDetector('하이브', ['하이브를 올립니다! 디파일러를 준비', '하이브 테크! 디파일러를 노립니다']),
  BranchDetector('타이밍', ['하이브 완성 전에 공격합니다', '한방 병력 전진! 하이브 전에 끝내겠다']),
];
List<BranchDetector> s6Phase4() => [
  BranchDetector('울트라', ['울트라리스크 합류', '울트라+저글링', '울트라가 돌진합니다']),
  BranchDetector('아콘', ['아콘 변환! 스톰과 아콘', '아콘이 완성됩니다', '아콘이 저글링을 쓸어버립니다']),
];

// S7: 973 히드라 올인 (분기 고유 패턴)
List<BranchDetector> s7Phase2() => [
  BranchDetector('히드라 타이밍', ['973 타이밍', '히드라가 캐논 라인을 두드립니다', '커세어가 아직']),
  BranchDetector('캐논 수비', ['질럿으로 버팁니다', '973 타이밍을 넘겼습니다', '캐논 2개']),
];
List<BranchDetector> s7Phase4() => [
  BranchDetector('히드라 물량', ['히드라 물량이 스톰을 이겨', '물량이 스톰을 이겨냅니다']),
  BranchDetector('스톰', ['스톰이 히드라를 쓸어버립니다', '스톰! 히드라']),
];

// S8: 12앞마당 vs 2게이트 (분기 고유 텍스트만 사용)
List<BranchDetector> s8Phase2() => [
  BranchDetector('성큰 수비', ['성큰 콜로니를 세웁니다', '성큰+저글링 수비 성공']),
  BranchDetector('질럿 돌파', ['성큰 완성 전에 도착', '성큰이 아직 안 올라왔습니다']),
];
List<BranchDetector> s8Phase3() => [
  BranchDetector('역공', ['발업 저글링으로 역공', '저글링 역공! 프로토스가']),
  BranchDetector('소모전', ['추가 질럿을 계속 보냅니다', '질럿을 계속 뽑습니다']),
];

// S9: 3해처리 vs 커세어 리버 (P4는 단일 decisive 이벤트만 있으므로 정확 매칭)
List<BranchDetector> s9Phase2() => [
  BranchDetector('리버 성공', ['스캐럽이 드론 뭉치에 명중', '다른 멀티로 이동']),
  BranchDetector('히드라 대공', ['히드라가 셔틀을 사격합니다', '리버가 떨어지기 전에']),
];
List<BranchDetector> s9Phase4() => [
  BranchDetector('물량 승리', ['3해처리의 물량이 테크를 압도합니다']),
  BranchDetector('테크 승리', ['커세어 리버의 기술력이 물량을 꺾습니다']),
];

// S10: 히드라 럴커 vs 포지더블 (분기 고유 패턴)
List<BranchDetector> s10Phase2() => [
  BranchDetector('럴커 잠복', ['럴커가 앞마당 입구에 포진', '드라군이 접근 불가', '럴커가 보이지 않아요']),
  BranchDetector('옵저버', ['옵저버가 럴커를 포착합니다', '럴커 위치가 노출']),
];
List<BranchDetector> s10Phase4() => [
  BranchDetector('럴커 방어', ['럴커를 대량으로 깔아둡니다', '진지가 난공불락']),
  BranchDetector('프로토스 돌파', ['스톰! 히드라 편대가 녹아내립니다', '드라군이 럴커를 하나씩 제거']),
];

// S11: 올인 vs 포지더블 (분기 고유 패턴만)
List<BranchDetector> s11Phase2() => [
  BranchDetector('러시 성공', ['캐논 완성 전에 진입', '저글링 난입! 프로브가 쓰러집니다']),
  BranchDetector('포지 수비', ['캐논이 간신히 완성', '캐논 완성! 저글링이 녹기 시작']),
];
List<BranchDetector> s11Phase3() => [
  BranchDetector('경제 격차', ['드론이 4마리뿐입니다', '4풀의 대가! 드론이 너무 적습니다']),
  BranchDetector('2차 러시', ['저글링을 계속 보냅니다! 2차 러시', '추가 저글링! 한 번 더']),
];
