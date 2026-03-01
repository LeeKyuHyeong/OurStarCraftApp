import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'tvt_verify_helper.dart';

/// TvT 시나리오 1-4 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 배럭더블 vs 팩토리더블
  // =======================================================
  group('TvT S1: 배럭더블 vs 팩더블', () {
    const build1 = 'tvt_cc_first';
    const build2 = 'tvt_2fac_vulture';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 배럭더블 vs 팩토리더블',
        results: results,
      );
      File('test/output/tvt_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['동급 300게임'] = r;
      print('S1 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
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
      print('S1 오델로: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 루나'] = r;
      print('S1 루나: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 투혼'] = r;
      print('S1 투혼: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 A vs B'] = r;
      print('S1 AvsB: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 B vs A'] = r;
      print('S1 BvsA: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 S vs B'] = r;
      print('S1 SvsB: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 B vs S'] = r;
      print('S1 BvsS: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 S+ vs B'] = r;
      print('S1 S+vsB: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 B vs S+'] = r;
      print('S1 BvsS+: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 공격 vs 수비'] = r;
      print('S1 공vs수: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
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
      print('S1 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: BBS vs 노배럭 더블
  // =======================================================
  group('TvT S2: BBS vs 노배럭더블', () {
    const build1 = 'tvt_bbs';
    const build2 = 'tvt_cc_first';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S2 BBS vs 노배럭더블', results: results);
      File('test/output/tvt_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['동급 300게임'] = r;
      print('S2 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(90));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s2Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s2Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s2Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(40));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(65));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(55));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(65));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(60));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(40));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s2Phase2);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });
  });

  // =======================================================
  // S3: 레이스 vs 배럭더블
  // =======================================================
  group('TvT S3: 레이스 vs 배럭더블', () {
    const build1 = 'tvt_wraith_cloak';
    const build2 = 'tvt_cc_first';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S3 레이스 vs 배럭더블', results: results);
      File('test/output/tvt_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['동급 300게임'] = r;
      print('S3 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2, makeBranches4: s3Phase4);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S4: 5팩 vs 마인트리플
  // =======================================================
  group('TvT S4: 5팩 vs 마인트리플', () {
    const build1 = 'tvt_5fac';
    const build2 = 'tvt_1fac_expand';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S4 5팩 vs 마인트리플', results: results);
      File('test/output/tvt_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['동급 300게임'] = r;
      print('S4 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
