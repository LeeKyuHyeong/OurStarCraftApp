import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'pvp_verify_helper.dart';

/// PvP 시나리오 9-10 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S9: 질럿러시 vs 로보리버
  // =======================================================
  group('PvP S9: 질럿러시 vs 로보리버', () {
    const build1 = 'pvp_zealot_rush';
    const build2 = 'pvp_1gate_robo';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S9 질럿러시 vs 로보리버',
        results: results,
        phaseName2: 'Phase 2 러시 vs 테크',
      );
      File('test/output/pvp_s9_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2,
      );
      results['동급 300게임'] = r;
      print('S9 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2,
      );
      results['맵 오델로'] = r;
      print('S9 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2,
      );
      results['맵 루나'] = r;
      print('S9 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2,
      );
      results['맵 투혼'] = r;
      print('S9 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 소 P1 A vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 소 P2 A vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 중 P1 S vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 중 P2 S vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 대 P1 S+ vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 대 P2 S+ vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S10: 다크 미러
  // =======================================================
  group('PvP S10: 다크 미러', () {
    const build1 = 'pvp_dark_allin';
    const build2 = 'pvp_dark_allin';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S10 다크 미러',
        results: results,
        phaseName2: 'Phase 2 다크 교환',
        phaseName4: 'Phase 4 복구전',
      );
      File('test/output/pvp_s10_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['동급 300게임'] = r;
      print('S10 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 오델로'] = r;
      print('S10 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 루나'] = r;
      print('S10 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 투혼'] = r;
      print('S10 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 소 P1 A vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 소 P2 A vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 중 P1 S vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 중 P2 S vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 대 P1 S+ vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 대 P2 S+ vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
