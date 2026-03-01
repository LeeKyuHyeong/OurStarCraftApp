import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'zvz_verify_helper.dart';

/// ZvZ 시나리오 1-5 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 9풀 vs 9오버풀
  // =======================================================
  group('ZvZ S1: 9풀 vs 9오버풀', () {
    const build1 = 'zvz_9pool';
    const build2 = 'zvz_9overpool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 9풀 vs 9오버풀',
        results: results,
      );
      File('test/output/zvz_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['동급 300게임'] = r;
      print('S1 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 오델로'] = r;
      print('S1 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 루나'] = r;
      print('S1 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 투혼'] = r;
      print('S1 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S1 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S1 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S1 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S1 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S1 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S1 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S1 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S1 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: 12앞마당 vs 9풀
  // =======================================================
  group('ZvZ S2: 12앞마당 vs 9풀', () {
    const build1 = 'zvz_12hatch';
    const build2 = 'zvz_9pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S2 12앞마당 vs 9풀',
        results: results,
      );
      File('test/output/zvz_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['동급 300게임'] = r;
      print('S2 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 오델로'] = r;
      print('S2 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 루나'] = r;
      print('S2 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 투혼'] = r;
      print('S2 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S2 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S2 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S2 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S2 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S2 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S2 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S2 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S2 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S3: 4풀 vs 12앞마당
  // =======================================================
  group('ZvZ S3: 4풀 vs 12앞마당', () {
    const build1 = 'zvz_pool_first';
    const build2 = 'zvz_12hatch';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S3 4풀 vs 12앞마당',
        results: results,
      );
      File('test/output/zvz_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['동급 300게임'] = r;
      print('S3 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(85));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['맵 오델로'] = r;
      print('S3 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['맵 루나'] = r;
      print('S3 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['맵 투혼'] = r;
      print('S3 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S3 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S3 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S3 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S3 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S3 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S3 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S3 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2, makeBranches4: s3Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S3 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S4: 3해처리 미러 (순수 미러)
  // =======================================================
  group('ZvZ S4: 3해처리 미러', () {
    const build1 = 'zvz_3hatch_nopool';
    const build2 = 'zvz_3hatch_nopool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S4 3해처리 미러',
        results: results,
      );
      File('test/output/zvz_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['동급 300게임'] = r;
      print('S4 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['맵 오델로'] = r;
      print('S4 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['맵 루나'] = r;
      print('S4 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['맵 투혼'] = r;
      print('S4 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S4 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S4 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S4 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S4 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S4 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S4 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S4 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S4 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S5: 4풀 vs 9풀
  // =======================================================
  group('ZvZ S5: 4풀 vs 9풀', () {
    const build1 = 'zvz_pool_first';
    const build2 = 'zvz_9pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S5 4풀 vs 9풀',
        results: results,
      );
      File('test/output/zvz_s5_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['동급 300게임'] = r;
      print('S5 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['맵 오델로'] = r;
      print('S5 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['맵 루나'] = r;
      print('S5 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['맵 투혼'] = r;
      print('S5 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S5 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S5 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S5 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S5 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S5 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S5 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S5 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(
        player1: homeDefense, player2: awayAttack, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['특화 수비 vs 공격'] = r;
      print('S5 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
