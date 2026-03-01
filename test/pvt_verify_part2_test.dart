import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'pvt_verify_helper.dart';

/// PvT 시나리오 5-8 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S5: 캐리어 vs 안티 캐리어
  // =======================================================
  group('PvT S5: 캐리어 vs 안티', () {
    const pBuild = 'pvt_carrier';
    const tBuild = 'tvp_anti_carrier';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S5 캐리어 vs 안티 캐리어',
        results: results,
      );
      File('test/output/pvt_s5_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s5Phase2,
      );
      results['동급 300게임'] = r;
      print('S5 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s5Phase2,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S5 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s5Phase2,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S5 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s5Phase2,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S5 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['특화 P공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['특화 T공격 vs P수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S6: 5게이트 푸시 vs 팩더블
  // =======================================================
  group('PvT S6: 5게이트 푸시 vs 팩더블', () {
    const pBuild = 'pvt_trans_5gate_push';
    const tBuild = 'tvp_double';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S6 5게이트 푸시 vs 팩더블',
        results: results,
      );
      File('test/output/pvt_s6_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s6Phase2,
      );
      results['동급 300게임'] = r;
      print('S6 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(85));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapLuna, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s6Phase2);
      results['맵 루나 (PvT 60)'] = r;
    });
    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s6Phase2);
      results['맵 투혼 (PvT 45)'] = r;
    });
    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s6Phase2);
      results['맵 오델로 (PvT 35)'] = r;
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s6Phase2);
      results['특화 T공격 vs P수비'] = r;
    });
  });

  // =======================================================
  // S7: 질럿 vs BBS (치즈 vs 치즈)
  // =======================================================
  group('PvT S7: 질럿 vs BBS', () {
    const pBuild = 'pvt_proxy_gate';
    const tBuild = 'tvp_bbs';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S7 질럿 vs BBS',
        results: results,
      );
      File('test/output/pvt_s7_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s7Phase2,
      );
      results['동급 300게임'] = r;
      print('S7 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapLuna, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s7Phase2);
      results['맵 루나 (PvT 60)'] = r;
    });
    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s7Phase2);
      results['맵 투혼 (PvT 45)'] = r;
    });
    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s7Phase2);
      results['맵 오델로 (PvT 35)'] = r;
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s7Phase2);
      results['특화 T공격 vs P수비'] = r;
    });
  });

  // =======================================================
  // S8: 리버 셔틀 vs BBS
  // =======================================================
  group('PvT S8: 리버 vs BBS', () {
    const pBuild = 'pvt_reaver_shuttle';
    const tBuild = 'tvp_bbs';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S8 리버 vs BBS',
        results: results,
      );
      File('test/output/pvt_s8_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s8Phase2,
      );
      results['동급 300게임'] = r;
      print('S8 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapLuna, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s8Phase2);
      results['맵 루나 (PvT 60)'] = r;
    });
    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s8Phase2);
      results['맵 투혼 (PvT 45)'] = r;
    });
    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo, pBuild: pBuild, tBuild: tBuild, countPerDir: 50, makeBranches2: s8Phase2);
      results['맵 오델로 (PvT 35)'] = r;
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s8Phase2);
      results['특화 T공격 vs P수비'] = r;
    });
  });
}
