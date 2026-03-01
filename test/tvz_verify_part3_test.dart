import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'tvz_verify_helper.dart';

/// TvZ 시나리오 9-11 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S9: 배럭더블 vs 3해처리
  // =======================================================
  group('TvZ S9: 배럭더블 vs 3해처리', () {
    const tBuild = 'tvz_sk';
    const zBuild = 'zvt_3hatch_nopool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S9 배럭더블 vs 3해처리',
        results: results,
      );
      File('test/output/tvz_s9_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s9Phase2, makeBranches4: s9Phase4,
      );
      results['동급 300게임'] = r;
      print('S9 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s9Phase2, makeBranches4: s9Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S10: 스탠다드 vs 원해처리 올인
  // =======================================================
  group('TvZ S10: 스탠다드 vs 원해처리 올인', () {
    const tBuild = 'tvz_sk';
    const zBuild = 'zvt_1hatch_allin';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S10 스탠다드 vs 원해처리 올인',
        results: results,
      );
      File('test/output/tvz_s10_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s10Phase2, makeBranches4: s10Phase3,
      );
      results['동급 300게임'] = r;
      print('S10 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P3: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s10Phase2, makeBranches4: s10Phase3);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S11: 메카닉 vs 하이브
  // =======================================================
  group('TvZ S11: 메카닉 vs 하이브', () {
    const tBuild = 'tvz_3fac_goliath';
    const zBuild = 'zvt_trans_ultra_hive';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S11 메카닉 vs 하이브',
        results: results,
      );
      File('test/output/tvz_s11_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s11Phase3, makeBranches4: s11Phase4,
      );
      results['동급 300게임'] = r;
      print('S11 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P3: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s11Phase3, makeBranches4: s11Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
