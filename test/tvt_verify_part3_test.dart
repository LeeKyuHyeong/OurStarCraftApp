import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'tvt_verify_helper.dart';

/// TvT 시나리오 9-12 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S9: 원팩원스타 vs 5팩
  // =======================================================
  group('TvT S9: 원팩원스타 vs 5팩', () {
    const build1 = 'tvt_1fac_push';
    const build2 = 'tvt_5fac';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S9 원팩원스타 vs 5팩', results: results);
      File('test/output/tvt_s9_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['동급 300게임'] = r;
      print('S9 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s9Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s9Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s9Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['특화 공격 vs 수비'] = r;
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s9Phase2);
      results['특화 수비 vs 공격'] = r;
    });
  });

  // =======================================================
  // S10: BBS 미러
  // =======================================================
  group('TvT S10: BBS 미러', () {
    const build1 = 'tvt_bbs';
    const build2 = 'tvt_bbs';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S10 BBS 미러', results: results);
      File('test/output/tvt_s10_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['동급 300게임'] = r;
      print('S10 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s10Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s10Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s10Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['특화 공격 vs 수비'] = r;
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s10Phase2);
      results['특화 수비 vs 공격'] = r;
    });
  });

  // =======================================================
  // S11: 원팩원스타 미러
  // =======================================================
  group('TvT S11: 원팩원스타 미러', () {
    const build1 = 'tvt_1fac_push';
    const build2 = 'tvt_1fac_push';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S11 원팩원스타 미러', results: results);
      File('test/output/tvt_s11_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['동급 300게임'] = r;
      print('S11 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s11Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s11Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s11Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['특화 공격 vs 수비'] = r;
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s11Phase2);
      results['특화 수비 vs 공격'] = r;
    });
  });

  // =======================================================
  // S12: 레이스 미러
  // =======================================================
  group('TvT S12: 레이스 미러', () {
    const build1 = 'tvt_wraith_cloak';
    const build2 = 'tvt_wraith_cloak';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S12 레이스 미러', results: results);
      File('test/output/tvt_s12_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['동급 300게임'] = r;
      print('S12 동급: 홈 ${r.homeWins}-${r.awayWins} 어 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapOdelo, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s12Phase2);
      results['맵 오델로'] = r;
    });
    test('맵 루나', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapLuna, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s12Phase2);
      results['맵 루나'] = r;
    });
    test('맵 투혼', () async {
      final r = await runBatchBiDir(player1: homeEqual, player2: awayEqual, map: mapTuhon, build1: build1, build2: build2, countPerDir: 50, makeBranches2: s12Phase2);
      results['맵 투혼'] = r;
    });

    test('등급차 소 A vs B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 소 A vs B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 B vs A', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 소 B vs A'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 S vs B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 중 S vs B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 B vs S', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 중 B vs S'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 S+ vs B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 대 S+ vs B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 B vs S+', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['등급차 대 B vs S+'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['특화 공격 vs 수비'] = r;
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s12Phase2);
      results['특화 수비 vs 공격'] = r;
    });
  });
}
