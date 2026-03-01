import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'pvt_verify_helper.dart';

/// PvT 시나리오 1-4 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 드라군 확장 vs 팩더블
  // =======================================================
  group('PvT S1: 드라군 확장 vs 팩더블', () {
    const pBuild = 'pvt_1gate_expand';
    const tBuild = 'tvp_double';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 드라군 확장 vs 팩더블',
        results: results,
      );
      File('test/output/pvt_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['동급 300게임'] = r;
      print('S1 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S1 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S1 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S1 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 P A vs T B'] = r;
      print('S1 PAvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 T A vs P B'] = r;
      print('S1 TAvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 P S vs T B'] = r;
      print('S1 PSvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 T S vs P B'] = r;
      print('S1 TSvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 P S+ vs T B'] = r;
      print('S1 PS+vsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 T S+ vs P B'] = r;
      print('S1 TS+vsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pAttack, tPlayer: tDefense, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 P공격 vs T수비'] = r;
      print('S1 P공vsT수: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pDefense, tPlayer: tAttack, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 T공격 vs P수비'] = r;
      print('S1 T공vsP수: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: 리버 셔틀 vs 타이밍 러시
  // =======================================================
  group('PvT S2: 리버 셔틀 vs 타이밍', () {
    const pBuild = 'pvt_reaver_shuttle';
    const tBuild = 'tvp_fake_double';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S2 리버 셔틀 vs 타이밍',
        results: results,
      );
      File('test/output/pvt_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['동급 300게임'] = r;
      print('S2 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S2 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S2 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S2 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 소 P A vs T B'] = r;
      print('S2 PAvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 소 T A vs P B'] = r;
      print('S2 TAvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 중 P S vs T B'] = r;
      print('S2 PSvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 중 T S vs P B'] = r;
      print('S2 TSvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 대 P S+ vs T B'] = r;
      print('S2 PS+vsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['등급차 대 T S+ vs P B'] = r;
      print('S2 TS+vsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pAttack, tPlayer: tDefense, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['특화 P공격 vs T수비'] = r;
      print('S2 P공vsT수: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pDefense, tPlayer: tAttack, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s2Phase2, makeBranches4: s2Phase4,
      );
      results['특화 T공격 vs P수비'] = r;
      print('S2 T공vsP수: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S3: 다크 템플러 vs 스탠다드
  // =======================================================
  group('PvT S3: 다크 기습 vs 스탠다드', () {
    const pBuild = 'pvt_dark_swing';
    const tBuild = 'tvp_double';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S3 다크 기습 vs 스탠다드',
        results: results,
      );
      File('test/output/pvt_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s3Phase2,
      );
      results['동급 300게임'] = r;
      print('S3 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S3 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S3 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S3 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 T공격 vs P수비'] = r;
    });
  });

  // =======================================================
  // S4: 질럿 러시 vs 스탠다드
  // =======================================================
  group('PvT S4: 질럿 러시 vs 스탠다드', () {
    const pBuild = 'pvt_proxy_gate';
    const tBuild = 'tvp_double';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S4 질럿 러시 vs 스탠다드',
        results: results,
      );
      File('test/output/pvt_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s4Phase2,
      );
      results['동급 300게임'] = r;
      print('S4 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(85));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapLuna, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 루나 (PvT 60)'] = r;
    });
    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 투혼 (PvT 45)'] = r;
    });
    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 오델로 (PvT 35)'] = r;
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 T공격 vs P수비'] = r;
    });
  });
}
