import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'tvz_verify_helper.dart';

/// TvZ 시나리오 1-4 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 바이오 러시 vs 뮤탈
  // =======================================================
  group('TvZ S1: 바이오 vs 뮤탈', () {
    const tBuild = 'tvz_sk';
    const zBuild = 'zvt_2hatch_mutal';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 바이오 vs 뮤탈',
        results: results,
      );
      File('test/output/tvz_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['동급 300게임'] = r;
      print('S1 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 오델로 (TvZ 65)'] = r;
      print('S1 오델로: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 투혼 (TvZ 55)'] = r;
      print('S1 투혼: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapLuna,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 루나 (TvZ 42)'] = r;
      print('S1 루나: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(
        tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 T A vs Z B'] = r;
      print('S1 TAvsZB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(
        tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 Z A vs T B'] = r;
      print('S1 ZAvsTB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(
        tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 T S vs Z B'] = r;
      print('S1 TSvsZB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(
        tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 Z S vs T B'] = r;
      print('S1 ZSvsTB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(
        tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 T S+ vs Z B'] = r;
      print('S1 TS+vsZB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(
        tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 Z S+ vs T B'] = r;
      print('S1 ZS+vsTB: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(
        tPlayer: tAttack, zPlayer: zDefense, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 T공격 vs Z수비'] = r;
      print('S1 T공vsZ수: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(
        tPlayer: tDefense, zPlayer: zAttack, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 Z공격 vs T수비'] = r;
      print('S1 Z공vsT수: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: 메카닉 vs 럴커
  // =======================================================
  group('TvZ S2: 메카닉 vs 럴커', () {
    const tBuild = 'tvz_3fac_goliath';
    const zBuild = 'zvt_2hatch_lurker';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S2 메카닉 vs 럴커',
        results: results,
      );
      File('test/output/tvz_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['동급 300게임'] = r;
      print('S2 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 오델로 (TvZ 65)'] = r;
      print('S2 오델로: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 투혼 (TvZ 55)'] = r;
      print('S2 투혼: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapLuna,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 루나 (TvZ 42)'] = r;
      print('S2 루나: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s2Phase2);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S3: 벙커 치즈 vs 스탠다드
  // =======================================================
  group('TvZ S3: 벙커 vs 스탠다드', () {
    const tBuild = 'tvz_bunker';
    const zBuild = 'zvt_12pool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S3 벙커 vs 스탠다드',
        results: results,
      );
      File('test/output/tvz_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s3Phase2,
      );
      results['동급 300게임'] = r;
      print('S3 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s3Phase2);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s3Phase2);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s3Phase2);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S4: 111 vs 3해처리
  // =======================================================
  group('TvZ S4: 111 vs 3해처리', () {
    const tBuild = 'tvz_111';
    const zBuild = 'zvt_3hatch_nopool';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S4 111 vs 3해처리',
        results: results,
      );
      File('test/output/tvz_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        tPlayer: tEqual, zPlayer: zEqual, map: mapBalance,
        tBuild: tBuild, zBuild: zBuild, countPerDir: 150,
        makeBranches2: s4Phase2, makeBranches4: s4Phase4,
      );
      results['동급 300게임'] = r;
      print('S4 동급: T ${r.homeWins}-${r.awayWins} Z (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로 (TvZ 65)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapOdelo, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['맵 오델로 (TvZ 65)'] = r;
    });
    test('맵 투혼 (TvZ 55)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapTuhon, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['맵 투혼 (TvZ 55)'] = r;
    });
    test('맵 루나 (TvZ 42)', () async {
      final r = await runBatchBiDir(tPlayer: tEqual, zPlayer: zEqual, map: mapLuna, tBuild: tBuild, zBuild: zBuild, countPerDir: 50, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['맵 루나 (TvZ 42)'] = r;
    });

    test('등급차 소 T A vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tAGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 소 T A vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 Z A vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zAGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 소 Z A vs T B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 T S vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSGrade, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 중 T S vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 Z S vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 중 Z S vs T B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 T S+ vs Z B', () async {
      final r = await runBatchBiDir(tPlayer: tSPlus, zPlayer: zBGrade, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 대 T S+ vs Z B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 Z S+ vs T B', () async {
      final r = await runBatchBiDir(tPlayer: tBGrade, zPlayer: zSPlus, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['등급차 대 Z S+ vs T B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 T공격 vs Z수비', () async {
      final r = await runBatchBiDir(tPlayer: tAttack, zPlayer: zDefense, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['특화 T공격 vs Z수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 Z공격 vs T수비', () async {
      final r = await runBatchBiDir(tPlayer: tDefense, zPlayer: zAttack, map: mapBalance, tBuild: tBuild, zBuild: zBuild, countPerDir: 150, makeBranches2: s4Phase2, makeBranches4: s4Phase4);
      results['특화 Z공격 vs T수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });
}
