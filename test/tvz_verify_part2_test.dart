import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'tvz_verify_helper.dart';

/// TvZ 시나리오 5-8 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S5: 레이스 vs 뮤탈
  // =======================================================
  group('TvZ S5: 레이스 vs 뮤탈', () {
    const tBuild = 'tvz_2star_wraith';
    const zBuild = 'zvt_2hatch_mutal';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S5 레이스 vs 뮤탈',
        results: results,
      );
      File('test/output/tvz_s5_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s5Phase2, makeBranches4: s5Phase4,
      );
      results['동급 300게임'] = r;
      print('S5 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s5Phase2, makeBranches4: s5Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S6: 벙커 vs 4풀
  // =======================================================
  group('TvZ S6: 벙커 vs 4풀', () {
    const tBuild = 'tvz_bunker';
    const zBuild = 'zvt_4pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S6 벙커 vs 4풀',
        results: results,
      );
      File('test/output/tvz_s6_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s6Phase2, makeBranches4: s6Phase3,
      );
      results['동급 300게임'] = r;
      print('S6 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P3: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase3);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S7: 스탠다드 vs 9풀
  // =======================================================
  group('TvZ S7: 스탠다드 vs 9풀', () {
    const tBuild = 'tvz_sk';
    const zBuild = 'zvt_9pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S7 스탠다드 vs 9풀',
        results: results,
      );
      File('test/output/tvz_s7_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s7Phase2, makeBranches4: s7Phase4,
      );
      results['동급 300게임'] = r;
      print('S7 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S8: 발키리 vs 뮤탈
  // =======================================================
  group('TvZ S8: 발키리 vs 뮤탈', () {
    const tBuild = 'tvz_valkyrie';
    const zBuild = 'zvt_2hatch_mutal';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S8 발키리 vs 뮤탈',
        results: results,
      );
      File('test/output/tvz_s8_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s8Phase2, makeBranches4: s8Phase4,
      );
      results['동급 300게임'] = r;
      print('S8 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(15));
      expect(r.homeWinRate, lessThan(90));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(40));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(60));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(55));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(45));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(60));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(40));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(10));
      expect(r.homeWinRate, lessThan(90));
    });
  });
}
