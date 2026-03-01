import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'zvp_verify_helper.dart';

/// ZvP 시나리오 1-4 종합 검증 (300게임 × 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 히드라 압박 vs 포지더블
  // =======================================================
  group('ZvP S1: 히드라 vs 포지더블', () {
    const zBuild = 'zvp_3hatch_hydra';
    const pBuild = 'pvz_forge_cannon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 히드라 vs 포지더블',
        results: results,
      );
      File('test/output/zvp_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['동급 300게임'] = r;
      print('S1 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapLuna,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 루나 (ZvP 60)'] = r;
      print('S1 루나: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 오델로 (ZvP 55)'] = r;
      print('S1 오델로: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['맵 투혼 (ZvP 48)'] = r;
      print('S1 투혼: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 Z A vs P B'] = r;
      print('S1 ZAvsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 소 P A vs Z B'] = r;
      print('S1 PAvsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 Z S vs P B'] = r;
      print('S1 ZSvsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 중 P S vs Z B'] = r;
      print('S1 PSvsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 Z S+ vs P B'] = r;
      print('S1 ZS+vsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['등급차 대 P S+ vs Z B'] = r;
      print('S1 PS+vsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(
        zPlayer: zAttack, pPlayer: pDefense, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 Z공격 vs P수비'] = r;
      print('S1 Z공vsP수: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(
        zPlayer: zDefense, pPlayer: pAttack, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase4,
      );
      results['특화 P공격 vs Z수비'] = r;
      print('S1 P공vsZ수: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: 뮤탈 운영 vs 포지더블
  // =======================================================
  group('ZvP S2: 뮤탈 vs 포지더블', () {
    const zBuild = 'zvp_2hatch_mutal';
    const pBuild = 'pvz_forge_cannon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S2 뮤탈 vs 포지더블',
        results: results,
      );
      File('test/output/zvp_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['동급 300게임'] = r;
      print('S2 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapLuna,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 루나 (ZvP 60)'] = r;
      print('S2 루나: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 오델로 (ZvP 55)'] = r;
      print('S2 오델로: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 투혼 (ZvP 48)'] = r;
      print('S2 투혼: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 소 Z A vs P B'] = r;
      print('S2 ZAvsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 소 P A vs Z B'] = r;
      print('S2 PAvsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 중 Z S vs P B'] = r;
      print('S2 ZSvsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 중 P S vs Z B'] = r;
      print('S2 PSvsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(
        zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 대 Z S+ vs P B'] = r;
      print('S2 ZS+vsPB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(
        zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 대 P S+ vs Z B'] = r;
      print('S2 PS+vsZB: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(
        zPlayer: zAttack, pPlayer: pDefense, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['특화 Z공격 vs P수비'] = r;
      print('S2 Z공vsP수: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });

    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(
        zPlayer: zDefense, pPlayer: pAttack, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['특화 P공격 vs Z수비'] = r;
      print('S2 P공vsZ수: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S3: 9풀 vs 포지더블
  // =======================================================
  group('ZvP S3: 9풀 vs 포지더블', () {
    const zBuild = 'zvp_9pool';
    const pBuild = 'pvz_forge_cannon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S3 9풀 vs 포지더블',
        results: results,
      );
      File('test/output/zvp_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s3Phase2,
      );
      results['동급 300게임'] = r;
      print('S3 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapLuna,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 루나 (ZvP 60)'] = r;
    });

    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 오델로 (ZvP 55)'] = r;
    });

    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 투혼 (ZvP 48)'] = r;
    });

    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 Z A vs P B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 P A vs Z B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 Z S vs P B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 P S vs Z B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 Z S+ vs P B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 P S+ vs Z B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 P공격 vs Z수비'] = r;
    });
  });

  // =======================================================
  // S4: 치즈 대결 (4풀 vs 전진 게이트)
  // =======================================================
  group('ZvP S4: 4풀 vs 전진 게이트', () {
    const zBuild = 'zvp_4pool';
    const pBuild = 'pvz_proxy_gate';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S4 4풀 vs 전진 게이트',
        results: results,
      );
      File('test/output/zvp_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        zPlayer: zEqual, pPlayer: pEqual, map: mapBalance,
        zBuild: zBuild, pBuild: pBuild, countPerDir: 150,
        makeBranches2: s4Phase2,
      );
      results['동급 300게임'] = r;
      print('S4 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapLuna, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 루나 (ZvP 60)'] = r;
    });
    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 오델로 (ZvP 55)'] = r;
    });
    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s4Phase2);
      results['맵 투혼 (ZvP 48)'] = r;
    });

    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 Z A vs P B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 P A vs Z B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 Z S vs P B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 P S vs Z B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 Z S+ vs P B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 P S+ vs Z B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });

    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s4Phase2);
      results['특화 P공격 vs Z수비'] = r;
    });
  });
}
