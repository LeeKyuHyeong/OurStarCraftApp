import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'pvt_verify_helper.dart';

/// PvT 시나리오 9-11 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S9: 확장 vs 마인 트리플
  // =======================================================
  group('PvT S9: 확장 vs 마인트리플', () {
    const pBuild = 'pvt_1gate_expand';
    const tBuild = 'tvp_mine_triple';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S9 확장 vs 마인트리플',
        results: results,
      );
      File('test/output/pvt_s9_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['동급 300게임'] = r;
      print('S9 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S9 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S9 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S9 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 소 P A vs T B'] = r;
      print('S9 PAvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 소 T A vs P B'] = r;
      print('S9 TAvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pAttack, tPlayer: tDefense, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['특화 P공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(
        pPlayer: pDefense, tPlayer: tAttack, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['특화 T공격 vs P수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S10: 11업 8팩 vs 확장
  // =======================================================
  group('PvT S10: 11업 8팩 vs 확장', () {
    const pBuild = 'pvt_1gate_expand';
    const tBuild = 'tvp_11up_8fac';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S10 11업 8팩 vs 확장',
        results: results,
      );
      File('test/output/pvt_s10_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['동급 300게임'] = r;
      print('S10 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S10 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S10 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s10Phase2, makeBranches4: s10Phase4,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S10 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 소 P A vs T B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 소 T A vs P B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase4);
      results['특화 T공격 vs P수비'] = r;
    });
  });

  // =======================================================
  // S11: FD테란 vs 프로토스
  // =======================================================
  group('PvT S11: FD테란 vs 프로토스', () {
    const pBuild = 'pvt_1gate_expand';
    const tBuild = 'tvp_fd';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S11 FD테란 vs 프로토스',
        results: results,
      );
      File('test/output/pvt_s11_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['동급 300게임'] = r;
      print('S11 동급: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (PvT 60)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapLuna,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['맵 루나 (PvT 60)'] = r;
      print('S11 루나: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (PvT 45)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapTuhon,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['맵 투혼 (PvT 45)'] = r;
      print('S11 투혼: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (PvT 35)', () async {
      final r = await runBatchBiDir(
        pPlayer: pEqual, tPlayer: tEqual, map: mapOdelo,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 50,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['맵 오델로 (PvT 35)'] = r;
      print('S11 오델로: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P A vs T B', () async {
      final r = await runBatchBiDir(
        pPlayer: pAGrade, tPlayer: tBGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['등급차 소 P A vs T B'] = r;
      print('S11 PAvsTB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 T A vs P B', () async {
      final r = await runBatchBiDir(
        pPlayer: pBGrade, tPlayer: tAGrade, map: mapBalance,
        pBuild: pBuild, tBuild: tBuild, countPerDir: 150,
        makeBranches2: s11Phase2, makeBranches4: s11Phase4,
      );
      results['등급차 소 T A vs P B'] = r;
      print('S11 TAvsPB: P ${r.homeWins}-${r.awayWins} T (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P S vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSGrade, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['등급차 중 P S vs T B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 T S vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['등급차 중 T S vs P B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P S+ vs T B', () async {
      final r = await runBatchBiDir(pPlayer: pSPlus, tPlayer: tBGrade, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['등급차 대 P S+ vs T B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 T S+ vs P B', () async {
      final r = await runBatchBiDir(pPlayer: pBGrade, tPlayer: tSPlus, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['등급차 대 T S+ vs P B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 P공격 vs T수비', () async {
      final r = await runBatchBiDir(pPlayer: pAttack, tPlayer: tDefense, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['특화 P공격 vs T수비'] = r;
    });
    test('특화 T공격 vs P수비', () async {
      final r = await runBatchBiDir(pPlayer: pDefense, tPlayer: tAttack, map: mapBalance, pBuild: pBuild, tBuild: tBuild, countPerDir: 150, makeBranches2: s11Phase2, makeBranches4: s11Phase4);
      results['특화 T공격 vs P수비'] = r;
    });
  });
}
