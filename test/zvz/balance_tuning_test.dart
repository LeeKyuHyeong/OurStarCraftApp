/// ZvZ 빌드 상성 튜닝용 — 특정 시나리오만 빠르게 1000경기 돌림
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

void main() {
  final homePlayer = Player(
    id: 'zerg_home', name: '이재동', raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  final awayPlayer = Player(
    id: 'zerg_away', name: '박성준', raceIndex: 1,
    stats: const PlayerStats(
      sense: 700, control: 700, attack: 700, harass: 700,
      strategy: 700, macro: 700, defense: 700, scout: 700,
    ),
    levelValue: 7, condition: 100,
  );
  const testMap = GameMap(
    id: 'test_fighting_spirit', name: '파이팅 스피릿',
    rushDistance: 6, resources: 5, terrainComplexity: 5,
    airAccessibility: 6, centerImportance: 5,
  );

  Future<void> run1000(String homeBuild, String awayBuild, String label) async {
    int homeWins = 0;
    const total = 1000;
    for (int i = 0; i < total; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: homeBuild, forcedAwayBuildId: awayBuild,
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state?.homeWin == true) homeWins++;
    }
    final rate = (homeWins / total * 100).toStringAsFixed(1);
    print('$label: 홈 승률 $rate% ($homeWins/$total)');
  }

  // ── 튜닝 대상 시나리오 ──

  test('12pool vs 12hatch (목표: 12hatch 60%)', () async {
    await run1000('zvz_12pool', 'zvz_12hatch', '12pool(홈) vs 12hatch(어웨이)');
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('9pool_lair vs 9overpool (목표: 9overpool 55%)', () async {
    await run1000('zvz_9pool_lair', 'zvz_9overpool', '9pool_lair(홈) vs 9overpool(어웨이)');
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('9pool_lair_mirror 분기 분포', () async {
    const total = 1000;
    int homeWins = 0;

    // Phase 1 분기
    int p1HomeHarass = 0, p1AwayHarass = 0, p1Even = 0;
    // Phase 3 분기
    int p3HarassHome = 0, p3HarassAway = 0;
    int p3ScourgeHome = 0, p3ScourgeAway = 0;
    int p3DroneHome = 0, p3DroneAway = 0;
    int p3TwoFrontHome = 0, p3TwoFrontAway = 0;
    int p3BothExpandHome = 0, p3BothExpandAway = 0;
    int p3HomeExpand = 0, p3AwayExpand = 0;

    for (int i = 0; i < total; i++) {
      final service = MatchSimulationService();
      final stream = service.simulateMatchWithLog(
        homePlayer: homePlayer, awayPlayer: awayPlayer,
        map: testMap, getIntervalMs: () => 0,
        forcedHomeBuildId: 'zvz_9pool_lair', forcedAwayBuildId: 'zvz_9pool_lair',
      );
      SimulationState? state;
      await for (final s in stream) { state = s; }
      if (state == null) continue;
      if (state.homeWin == true) homeWins++;

      final allText = state.battleLogEntries.map((e) => e.text).join('\n');
      final isHomeWin = state.homeWin == true;

      // Phase 1
      if (allText.contains('결정적인 차이가 안 납니다')) {
        p1Even++;
      } else if (allText.contains('드론 피해를 줬습니다')) {
        // 누가 견제했는지: 홈 견제면 홈 이름이 "드론 피해" 앞에 나옴
        // home_ling_harass branch의 텍스트: "{home} 선수 드론 피해를 줬습니다"
        // 간단하게: 홈이 견제 성공하면 awayResource가 줄었을 것
        final homeHarassText = allText.contains('발업 저글링이 상대 미네랄 라인에 침투');
        if (homeHarassText) {
          // 첫 번째 발생이 홈인지 어웨이인지 확인
          final idx = allText.indexOf('발업 저글링이 상대 미네랄 라인에 침투');
          final before = allText.substring(0, idx);
          final lastNewline = before.lastIndexOf('\n');
          final line = lastNewline >= 0 ? before.substring(lastNewline) : before;
          // home entries come from home player name
          if (!line.contains(awayPlayer.name)) {
            p1HomeHarass++;
          } else {
            p1AwayHarass++;
          }
        }
      }

      // Phase 3
      if (allText.contains('누적된 드론 차이가 결정적')) {
        if (isHomeWin) p3HarassHome++; else p3HarassAway++;
      } else if (allText.contains('스커지 컨트롤 한 방이 경기를 결정')) {
        if (isHomeWin) p3ScourgeHome++; else p3ScourgeAway++;
      } else if (allText.contains('초반 드론 관리의 차이가 뮤탈전에서')) {
        if (isHomeWin) p3DroneHome++; else p3DroneAway++;
      } else if (allText.contains('멀티태스킹으로 상대를 완전히 압도')) {
        if (isHomeWin) p3TwoFrontHome++; else p3TwoFrontAway++;
      } else if (allText.contains('장기전에서 매크로 차이가 결정적')) {
        if (isHomeWin) p3BothExpandHome++; else p3BothExpandAway++;
      } else if (allText.contains('라바 차이가 벌어집니다')) {
        if (isHomeWin) p3HomeExpand++; else p3AwayExpand++;
      }
    }

    final rate = (homeWins / total * 100).toStringAsFixed(1);
    final p3Total = p3HarassHome + p3HarassAway + p3ScourgeHome + p3ScourgeAway
        + p3DroneHome + p3DroneAway + p3TwoFrontHome + p3TwoFrontAway
        + p3BothExpandHome + p3BothExpandAway + p3HomeExpand + p3AwayExpand;

    String pct(int n) => (n / total * 100).toStringAsFixed(1);
    String branchRow(String name, String stat, int home, int away) {
      final sum = home + away;
      return '| $name | $stat | $sum | ${pct(sum)}% | $home | $away |';
    }

    final buf = StringBuffer();
    buf.writeln('# ZvZ 9pool_lair_mirror 1000경기 통계');
    buf.writeln();
    buf.writeln('| 항목 | 값 |');
    buf.writeln('|------|-----|');
    buf.writeln('| 총 경기 | $total |');
    buf.writeln('| 홈 승률 | $rate% ($homeWins승) |');
    buf.writeln('| 어웨이 승률 | ${(100 - double.parse(rate)).toStringAsFixed(1)}% (${total - homeWins}승) |');
    buf.writeln();
    buf.writeln('## Phase 1: 저글링 견제');
    buf.writeln();
    buf.writeln('| 분기 | 발동 | 비율 |');
    buf.writeln('|------|------|------|');
    buf.writeln('| 홈 견제 성공 | $p1HomeHarass | ${pct(p1HomeHarass)}% |');
    buf.writeln('| 어웨이 견제 성공 | $p1AwayHarass | ${pct(p1AwayHarass)}% |');
    buf.writeln('| 비등 | $p1Even | ${pct(p1Even)}% |');
    buf.writeln();
    buf.writeln('## Phase 3: 뮤탈전 결전');
    buf.writeln();
    buf.writeln('| 분기 | 조건 stat | 발동 | 비율 | 홈 승 | 어웨이 승 |');
    buf.writeln('|------|----------|------|------|-------|----------|');
    buf.writeln(branchRow('뮤탈 견제 여러라운드', 'harass', p3HarassHome, p3HarassAway));
    buf.writeln(branchRow('스커지 한방', 'control', p3ScourgeHome, p3ScourgeAway));
    buf.writeln(branchRow('드론 차이 물량', 'macro', p3DroneHome, p3DroneAway));
    buf.writeln(branchRow('2정면 공격', 'sense', p3TwoFrontHome, p3TwoFrontAway));
    buf.writeln(branchRow('양쪽 앞마당', 'macro', p3BothExpandHome, p3BothExpandAway));
    buf.writeln(branchRow('한쪽 앞마당', 'strategy', p3HomeExpand, p3AwayExpand));
    buf.writeln('| 미감지 | - | ${total - p3Total} | ${pct(total - p3Total)}% | - | - |');

    final outDir = Directory('test/output/zvz');
    if (!outDir.existsSync()) outDir.createSync(recursive: true);
    File('test/output/zvz/9pool_lair_mirror_1000stats.md').writeAsStringSync(buf.toString());

    print('=== 9pool_lair_mirror 분기 분포 ($total경기) ===');
    print('홈 승률: $rate%');
    print('Phase 1: 홈견제$p1HomeHarass 어웨이견제$p1AwayHarass 비등$p1Even');
    print('Phase 3: 견제${p3HarassHome+p3HarassAway} 스커지${p3ScourgeHome+p3ScourgeAway} 드론${p3DroneHome+p3DroneAway} 2정면${p3TwoFrontHome+p3TwoFrontAway} 양쪽확장${p3BothExpandHome+p3BothExpandAway} 편확장${p3HomeExpand+p3AwayExpand} 미감지${total-p3Total}');
  }, timeout: const Timeout(Duration(minutes: 10)));
}
