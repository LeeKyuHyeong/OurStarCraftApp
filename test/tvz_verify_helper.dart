import 'dart:io';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// =========================================================
// 공통 선수 정의
// =========================================================

/// 동급 테란 (~700)
final tEqual = Player(
  id: 't_equal', name: '이영호', raceIndex: 0,
  stats: const PlayerStats(
    sense: 700, control: 710, attack: 690, harass: 700,
    strategy: 680, macro: 720, defense: 690, scout: 710,
  ),
  levelValue: 7, condition: 100,
);

/// 동급 저그 (~700)
final zEqual = Player(
  id: 'z_equal', name: '이재동', raceIndex: 1,
  stats: const PlayerStats(
    sense: 690, control: 700, attack: 710, harass: 680,
    strategy: 720, macro: 690, defense: 700, scout: 710,
  ),
  levelValue: 7, condition: 100,
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

/// B급 저그 (~650)
final zBGrade = Player(
  id: 'z_b', name: '이재동B', raceIndex: 1,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
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

/// 수비 특화 저그 (defense/strategy/macro 높음)
final zDefense = Player(
  id: 'z_def', name: '이재동DEF', raceIndex: 1,
  stats: const PlayerStats(
    sense: 650, control: 650, attack: 620, harass: 600,
    strategy: 800, macro: 790, defense: 780, scout: 650,
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

/// B급 테란 (~650)
final tBGrade = Player(
  id: 't_b', name: '이영호B', raceIndex: 0,
  stats: const PlayerStats(
    sense: 640, control: 650, attack: 660, harass: 630,
    strategy: 670, macro: 640, defense: 650, scout: 660,
  ),
  levelValue: 5, condition: 100,
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

/// A급 저그 (~780)
final zAGrade = Player(
  id: 'z_a', name: '이재동A', raceIndex: 1,
  stats: const PlayerStats(
    sense: 770, control: 780, attack: 790, harass: 760,
    strategy: 800, macro: 770, defense: 780, scout: 790,
  ),
  levelValue: 8, condition: 100,
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

/// S급 저그 (~850)
final zSGrade = Player(
  id: 'z_s', name: '이재동S0', raceIndex: 1,
  stats: const PlayerStats(
    sense: 840, control: 850, attack: 860, harass: 830,
    strategy: 870, macro: 840, defense: 850, scout: 860,
  ),
  levelValue: 9, condition: 100,
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
    tvzTerranWinRate: 65, // TvZ 65
    zvpZergWinRate: 55,   // ZvP 55
    pvtProtossWinRate: 35, // PvT 35
  ),
);

const mapLuna = GameMap(
  id: 'test_luna', name: '루나',
  rushDistance: 7, resources: 7, terrainComplexity: 6,
  airAccessibility: 7, centerImportance: 4,
  matchup: RaceMatchup(
    tvzTerranWinRate: 42, // TvZ 42
    zvpZergWinRate: 60,   // ZvP 60
    pvtProtossWinRate: 60, // PvT 60
  ),
);

const mapTuhon = GameMap(
  id: 'test_tuhon', name: '투혼',
  rushDistance: 4, resources: 4, terrainComplexity: 3,
  airAccessibility: 5, centerImportance: 7,
  matchup: RaceMatchup(
    tvzTerranWinRate: 55, // TvZ 55
    zvpZergWinRate: 48,   // ZvP 48
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
  required Player tPlayer,
  required Player zPlayer,
  required GameMap map,
  required String tBuild,
  required String zBuild,
  required int countPerDir,
  required List<BranchDetector> Function() makeBranches2,
  List<BranchDetector> Function()? makeBranches4,
}) async {
  // 정방향: 테란=홈
  final fwd = await runBatch(
    home: tPlayer, away: zPlayer, map: map,
    homeBuild: tBuild, awayBuild: zBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 역방향: 저그=홈, 테란=어웨이
  final rev = await runBatch(
    home: zPlayer, away: tPlayer, map: map,
    homeBuild: zBuild, awayBuild: tBuild, count: countPerDir,
    makeBranches2: makeBranches2, makeBranches4: makeBranches4,
  );

  // 통합 (역방향에서는 away가 테란이므로 awayWins이 테란승)
  final combined = BatchResult();
  combined.homeWins = fwd.homeWins + rev.awayWins; // 테란 승
  combined.awayWins = fwd.awayWins + rev.homeWins; // 저그 승
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
  buf.writeln('| 전적 | T ${result.homeWins} - ${result.awayWins} Z (${result.total}게임) |');
  buf.writeln('| T 승률 | ${result.homeWinRate.toStringAsFixed(1)}% |');
  buf.writeln('| 평균 병력차 | ${result.avgArmy.toStringAsFixed(1)} |');
  buf.writeln('| 평균 자원차 | ${result.avgResource.toStringAsFixed(1)} |');
  buf.writeln('');

  if (result.phase2.isNotEmpty) {
    final p2Total = result.phase2.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**$phaseName2** (${p2Total}감지 / ${result.p2Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
    buf.writeln('|------|------|------|-------|');
    for (final b in result.phase2) {
      buf.writeln('| ${b.name} | ${b.count} | ${b.pct(p2Total)} | ${b.winRate(b.count)} |');
    }
    buf.writeln('');
  }

  if (result.phase4.isNotEmpty) {
    final p4Total = result.phase4.fold<int>(0, (s, b) => s + b.count);
    buf.writeln('**${phaseName4 ?? 'Phase 4'}** (${p4Total}감지 / ${result.p4Unknown}미감지)');
    buf.writeln('| 분기 | 발동 | 비율 | T승률 |');
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
  buf.writeln('| 설정 | 게임수 | T승 | Z승 | T승률 | 병력차 | 자원차 |');
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
    buf.writeln('| 분기 | 발동 | 비율 | T승률 | 미감지 |');
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
    buf.writeln('| 분기 | 발동 | 비율 | T승률 | 미감지 |');
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

  // 맵별 비교 (T승률 높은 순 정렬)
  final mapResults = results.entries
      .where((e) => e.key.contains('맵'))
      .toList()
    ..sort((a, b) => b.value.homeWinRate.compareTo(a.value.homeWinRate));
  if (mapResults.isNotEmpty) {
    buf.writeln('## 맵별 비교 (T승률 높은순)\n');
    buf.writeln('| 맵 | 게임수 | T승률 |');
    buf.writeln('|----|--------|-------|');
    // 밸런스맵 포함, 전체를 T승률 기준 정렬
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

// S1: 바이오 러시 vs 뮤탈 (tvz_bio_vs_mutal)
List<BranchDetector> s1Phase2() => [
  BranchDetector('테란 압박', ['스팀팩 ON', '앞마당 압박', '앞마당으로 전진합니다']),
  BranchDetector('뮤탈 등장', ['뮤탈리스크 등장', '뮤탈이 떴습니다', 'SCV 라인을 노립니다']),
  BranchDetector('저글링 기습', ['저글링이 튀어나옵니다', '저글링 서라운드', '매복 저글링']),
  BranchDetector('스파이어 정찰', ['스파이어를 발견', '터렛을 미리 건설', '정찰 SCV가 스파이어']),
];
List<BranchDetector> s1Phase4() => [
  BranchDetector('타이밍 공격', ['이레디에이트', '이레디', '사이언스 베슬 합류']),
  BranchDetector('매크로 전환', ['3번째 해처리', '럴커 변태', '럴커 포진', '물량이 점점']),
  BranchDetector('드랍십 견제', ['드랍십에 마린 메딕', '드랍! 저그 세 번째', '드랍 성공']),
];

// S2: 메카닉 vs 럴커 (tvz_mech_vs_lurker)
List<BranchDetector> s2Phase2() => [
  BranchDetector('스캔 럴커', ['스캔', '럴커 위치를 정확히', '정밀 포격']),
  BranchDetector('럴커 수비', ['럴커 포진', '럴커에 마린이 녹', '럴커 매복']),
];

// S3: 벙커 치즈 vs 스탠다드 (tvz_cheese_vs_standard)
List<BranchDetector> s3Phase2() => [
  BranchDetector('벙커 발견', ['오버로드가 SCV를 포착', '드론 모아서 SCV', '써큰 콜로니 완성']),
  BranchDetector('벙커 성공', ['벙커 건설 성공', '벙커 완성', '마린이 들어갑니다']),
];

// S4: 111 vs 매크로 (tvz_111_vs_macro)
List<BranchDetector> s4Phase2() => [
  BranchDetector('오버로드 격추', ['오버로드를 발견', '오버로드 격추', '서플라이가 막히']),
  BranchDetector('오버로드 방어', ['오버로드 위치 관리', '레이스가 빈손', '오버로드를 안전한']),
];
List<BranchDetector> s4Phase4() => [
  BranchDetector('2차 공격', ['2차 공격', '멀티 포인트 공격', '양쪽에서 동시 압박']),
  BranchDetector('저그 물량', ['울트라리스크', '울트라 등장', '울트라 저글링 대규모']),
];

// S5: 레이스 vs 뮤탈 (tvz_wraith_vs_mutal)
List<BranchDetector> s5Phase2() => [
  BranchDetector('레이스 견제', ['클로킹 레이스가 저그 본진', '오버로드 격추', '드론이 당하고']),
  BranchDetector('뮤탈 대응', ['뮤탈리스크가 빠르게 등장', '레이스가 뮤탈에 쫓기', '뮤탈이 바로 SCV']),
];
List<BranchDetector> s5Phase4() => [
  BranchDetector('지상 전환', ['지상 병력 전환', '시즈 탱크와 골리앗이 합류', '레이스+지상 복합']),
  BranchDetector('뮤탈 압도', ['뮤탈이 끝없이', '뮤탈 12기', '뮤탈 물량에 밀리']),
];

// S6: 벙커 vs 4풀 (tvz_cheese_vs_cheese)
List<BranchDetector> s6Phase2() => [
  BranchDetector('저글링→T본진', ['저글링 6기가 테란 본진', '본진이 비어있습니다', '텅 빈 본진']),
  BranchDetector('테란→Z본진', ['마린 SCV가 저그 앞마당에 도착', '벙커 올립니다', '저글링이 엇갈렸']),
];
List<BranchDetector> s6Phase3() => [
  BranchDetector('벙커 압사', ['벙커 완성! 마린이 들어갑', '드론으로 막아보려', '벙커 압박이 성공']),
  BranchDetector('저글링 파괴', ['저글링이 테란 본진 SCV를 전부', '본진이 괴멸', '돌이킬 수 없는']),
];

// S7: 스탠다드 vs 9풀 (tvz_standard_vs_9pool)
List<BranchDetector> s7Phase2() => [
  BranchDetector('정찰 성공', ['9풀을 확인', '빠른 풀을 읽었', '벙커가 이미 있']),
  BranchDetector('저글링 성공', ['발업 저글링이 진영 입구', '저글링 기습', 'SCV까지 물어뜯']),
];
List<BranchDetector> s7Phase4() => [
  BranchDetector('테란 복구', ['일꾼 복구 완료', '마린 메딕 조합으로 전진', '9풀 이후 자원이 부족']),
  BranchDetector('저그 활용', ['뮤탈리스크 등장! 초반 이득', '뮤탈로 견제하면서 세 번째', '초반 피해 복구가 안']),
];

// S8: 발키리 vs 뮤탈 (tvz_valkyrie_vs_mutal)
List<BranchDetector> s8Phase2() => [
  BranchDetector('발키리 대공', ['발키리 스플래시', '뭉쳐있던 뮤탈에 큰 피해', '발키리 범위 공격']),
  BranchDetector('뮤탈 회피', ['발키리를 확인하고 뮤탈을 다른 곳', '발키리를 피해서', '발키리 없는 앞마당']),
];
List<BranchDetector> s8Phase4() => [
  BranchDetector('발키리 장악', ['발키리 3기! 하늘을 완전히', '뮤탈이 더 이상 견제를', '발키리 덕에 안정적']),
  BranchDetector('럴커 전환', ['뮤탈이 막히니까 럴커로', '럴커가 앞마당 입구에 포진', '발키리가 지상은 못']),
];

// S9: 배럭더블 vs 3해처리 (tvz_double_vs_3hatch)
List<BranchDetector> s9Phase2() => [
  BranchDetector('마린 정찰', ['마린 소수가 앞마당 정찰', '3해처리를 확인', '가스를 안 주려고']),
  BranchDetector('빠른 레어', ['레어 진화 시작', '스파이어 건설 들어갑니다', '뮤탈 3기 등장! 3해처리']),
];
List<BranchDetector> s9Phase4() => [
  BranchDetector('테란 한방', ['한방 병력 전진', '시즈 모드! 앞마당 포격', '한방 갑니다']),
  BranchDetector('디파일러 저지', ['디파일러가 전선에 도착', '다크스웜! 테란 한방을 무력화', '한방이 불발']),
  BranchDetector('대규모 교환', ['풀 병력이 정면에서 부딪', '대규모 교전', '양측 병력이 크게 소모']),
];

// S10: 스탠다드 vs 원해처리 올인 (tvz_standard_vs_1hatch_allin)
List<BranchDetector> s10Phase2() => [
  BranchDetector('럴커 올인 성공', ['럴커 4기가 테란 앞마당', '스캔이 없습니다', '럴커가 입구에 자리잡']),
  BranchDetector('테란 대비', ['원해처리 럴커를 확인', '시즈 탱크로 럴커를 잡겠다', '럴커가 탱크 사거리에']),
];
List<BranchDetector> s10Phase3() => [
  BranchDetector('올인 실패', ['올인이 실패했습니다', '원해처리라 자원이 없', '올인 실패한 저그를']),
  BranchDetector('올인 성공', ['럴커 올인 성공! 테란 앞마당', '본진으로 후퇴', '530 뮤탈 전환']),
];

// S11: 메카닉 vs 하이브 (tvz_mech_vs_hive)
List<BranchDetector> s11Phase3() => [
  BranchDetector('울트라 등장', ['울트라리스크가 등장합니다', '울트라가 골리앗 라인을 향해', '울트라가 나왔습니다']),
  BranchDetector('디파일러 스웜', ['디파일러가 전선에 합류', '다크스웜! 골리앗과 탱크의', '스웜! 메카닉 화력이']),
];
List<BranchDetector> s11Phase4() => [
  BranchDetector('메카닉 물량', ['5팩토리 풀가동', '골리앗 탱크 편대가 저그 4번째', '메카닉 물량으로 저그 확장']),
  BranchDetector('하이브 총공격', ['울트라 디파일러 저글링 총동원', '다크스웜 깔면서 울트라가 돌진', '하이브 유닛 총공격']),
  BranchDetector('재건 경쟁', ['양측 모두 큰 전투 후', '5팩토리에서 골리앗을 재생산', '재건 속도 대결']),
];
