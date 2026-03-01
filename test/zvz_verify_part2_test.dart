import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'zvz_verify_helper.dart';

/// ZvZ 시나리오 6-9 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S6: 4풀 vs 3해처리
  // =======================================================
  group('ZvZ S6: 4풀 vs 3해처리', () {
    const build1 = 'zvz_pool_first';
    const build2 = 'zvz_3hatch_nopool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S6 4풀 vs 3해처리',
        results: results,
      );
      File('test/output/zvz_s6_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['동급 300게임'] = r;
      print('S6 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(90));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['맵 오델로'] = r;
      print('S6 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['맵 루나'] = r;
      print('S6 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['맵 투혼'] = r;
      print('S6 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S6 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(40));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S6 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(65));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S6 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(55));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S6 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(45));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S6 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(60));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S6 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(40));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S6 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S6 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });
  });

  // =======================================================
  // S7: 9풀 미러 (순수 미러)
  // =======================================================
  group('ZvZ S7: 9풀 미러', () {
    const build1 = 'zvz_9pool';
    const build2 = 'zvz_9pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S7 9풀 미러',
        results: results,
      );
      File('test/output/zvz_s7_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['동급 300게임'] = r;
      print('S7 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['맵 오델로'] = r;
      print('S7 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['맵 루나'] = r;
      print('S7 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['맵 투혼'] = r;
      print('S7 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S7 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S7 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S7 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S7 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S7 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S7 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S7 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S7 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S8: 12풀 vs 3해처리
  // =======================================================
  group('ZvZ S8: 12풀 vs 3해처리', () {
    const build1 = 'zvz_12pool';
    const build2 = 'zvz_3hatch_nopool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S8 12풀 vs 3해처리',
        results: results,
      );
      File('test/output/zvz_s8_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['동급 300게임'] = r;
      print('S8 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['맵 오델로'] = r;
      print('S8 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['맵 루나'] = r;
      print('S8 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['맵 투혼'] = r;
      print('S8 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S8 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S8 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S8 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S8 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S8 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S8 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S8 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S8 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S9: 9오버풀 미러 (순수 미러)
  // =======================================================
  group('ZvZ S9: 9오버풀 미러', () {
    const build1 = 'zvz_9overpool';
    const build2 = 'zvz_9overpool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S9 9오버풀 미러',
        results: results,
      );
      File('test/output/zvz_s9_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['동급 300게임'] = r;
      print('S9 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 오델로'] = r;
      print('S9 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 루나'] = r;
      print('S9 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 투혼'] = r;
      print('S9 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S9 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S9 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S9 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S9 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S9 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S9 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S9 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S9 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
