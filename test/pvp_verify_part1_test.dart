import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'pvp_verify_helper.dart';

/// PvP 시나리오 1-4 종합 검증 (300게임 x 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S1: 드라군 넥서스 미러
  // =======================================================
  group('PvP S1: 드라군 넥서스 미러', () {
    const build1 = 'pvp_2gate_dragoon';
    const build2 = 'pvp_2gate_dragoon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S1 드라군 넥서스 미러',
        results: results,
        phaseName2: 'Phase 2 테크 분기',
      );
      File('test/output/pvp_s1_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['동급 300게임'] = r;
      print('S1 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P3: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(40));
      expect(r.homeWinRate, lessThan(60));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['맵 오델로'] = r;
      print('S1 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['맵 루나'] = r;
      print('S1 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['맵 투혼'] = r;
      print('S1 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S1 P1AvsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S1 P2AvsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S1 P1SvsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S1 P2SvsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S1 P1S+vsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S1 P2S+vsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
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
        makeBranches2: s1Phase2, makeBranches4: s1Phase3,
      );
      results['특화 수비 vs 공격'] = r;
      print('S1 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S2: 드라군 vs 노겟넥서스
  // =======================================================
  group('PvP S2: 드라군 vs 노겟넥서스', () {
    const build1 = 'pvp_2gate_dragoon';
    const build2 = 'pvp_1gate_multi';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S2 드라군 vs 노겟넥서스',
        results: results,
        phaseName2: 'Phase 2 초반 압박',
      );
      File('test/output/pvp_s2_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['동급 300게임'] = r;
      print('S2 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 오델로'] = r;
      print('S2 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 루나'] = r;
      print('S2 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s2Phase2,
      );
      results['맵 투혼'] = r;
      print('S2 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeAGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 소 P1 A vs P2 B'] = r;
      print('S2 P1AvsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(50));
    });

    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awayAGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 소 P2 A vs P1 B'] = r;
      print('S2 P2AvsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(50));
    });

    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSGrade, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 중 P1 S vs P2 B'] = r;
      print('S2 P1SvsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(65));
    });

    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 중 P2 S vs P1 B'] = r;
      print('S2 P2SvsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(35));
    });

    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(
        player1: homeSPlus, player2: awayBGrade, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 대 P1 S+ vs P2 B'] = r;
      print('S2 P1S+vsP2B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(70));
    });

    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(
        player1: homeBGrade, player2: awaySPlus, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
      );
      results['등급차 대 P2 S+ vs P1 B'] = r;
      print('S2 P2S+vsP1B: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(
        player1: homeAttack, player2: awayDefense, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s2Phase2,
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
        makeBranches2: s2Phase2,
      );
      results['특화 수비 vs 공격'] = r;
      print('S2 수vs공: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S3: 로보리버 vs 투겟드라군
  // =======================================================
  group('PvP S3: 로보리버 vs 투겟드라군', () {
    const build1 = 'pvp_1gate_robo';
    const build2 = 'pvp_2gate_dragoon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S3 로보리버 vs 투겟드라군',
        results: results,
        phaseName2: 'Phase 2 교전',
      );
      File('test/output/pvp_s3_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s3Phase2,
      );
      results['동급 300게임'] = r;
      print('S3 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 오델로'] = r;
      print('S3 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 루나'] = r;
      print('S3 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s3Phase2,
      );
      results['맵 투혼'] = r;
      print('S3 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 P1 A vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 소 P2 A vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 P1 S vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 중 P2 S vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 P1 S+ vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['등급차 대 P2 S+ vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(30));
    });

    test('특화 공격 vs 수비', () async {
      final r = await runBatchBiDir(player1: homeAttack, player2: awayDefense, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 공격 vs 수비'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
    test('특화 수비 vs 공격', () async {
      final r = await runBatchBiDir(player1: homeDefense, player2: awayAttack, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s3Phase2);
      results['특화 수비 vs 공격'] = r;
      expect(r.homeWinRate, greaterThan(25));
      expect(r.homeWinRate, lessThan(75));
    });
  });

  // =======================================================
  // S4: 다크 올인 vs 드라군
  // =======================================================
  group('PvP S4: 다크 올인 vs 드라군', () {
    const build1 = 'pvp_dark_allin';
    const build2 = 'pvp_2gate_dragoon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(
        title: 'S4 다크 올인 vs 드라군',
        results: results,
        phaseName2: 'Phase 2 다크 결과',
      );
      File('test/output/pvp_s4_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapBalance,
        build1: build1, build2: build2, countPerDir: 150,
        makeBranches2: s4Phase2,
      );
      results['동급 300게임'] = r;
      print('S4 동급: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30));
      expect(r.homeWinRate, lessThan(70));
    });

    test('맵 오델로', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapOdelo,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2,
      );
      results['맵 오델로'] = r;
      print('S4 오델로: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 루나', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapLuna,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2,
      );
      results['맵 루나'] = r;
      print('S4 루나: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('맵 투혼', () async {
      final r = await runBatchBiDir(
        player1: homeEqual, player2: awayEqual, map: mapTuhon,
        build1: build1, build2: build2, countPerDir: 50,
        makeBranches2: s4Phase2,
      );
      results['맵 투혼'] = r;
      print('S4 투혼: 홈 ${r.homeWins}-${r.awayWins} 어웨이 (${r.homeWinRate.toStringAsFixed(1)}%)');
    });

    test('등급차 소 P1 A vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeAGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 P1 A vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P2 A vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awayAGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 소 P2 A vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 P1 S vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSGrade, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 P1 S vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P2 S vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 중 P2 S vs P1 B'] = r;
      expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 P1 S+ vs P2 B', () async {
      final r = await runBatchBiDir(player1: homeSPlus, player2: awayBGrade, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 P1 S+ vs P2 B'] = r;
      expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P2 S+ vs P1 B', () async {
      final r = await runBatchBiDir(player1: homeBGrade, player2: awaySPlus, map: mapBalance, build1: build1, build2: build2, countPerDir: 150, makeBranches2: s4Phase2);
      results['등급차 대 P2 S+ vs P1 B'] = r;
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
