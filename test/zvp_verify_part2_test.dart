import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'zvp_verify_helper.dart';

/// ZvP 시나리오 5-8 종합 검증 (300게임 × 12설정)
void main() {
  final outputDir = Directory('test/output');
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  // =======================================================
  // S5: 뮤커지 vs 커세어 리버
  // =======================================================
  group('ZvP S5: 뮤커지 vs 커세어리버', () {
    const zBuild = 'zvp_mukerji';
    const pBuild = 'pvz_corsair_reaver';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S5 뮤커지 vs 커세어리버', results: results);
      File('test/output/zvp_s5_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['동급 300게임'] = r;
      print('S5 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      expect(r.homeWinRate, greaterThan(30)); expect(r.homeWinRate, lessThan(70));
    });
    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapLuna, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s5Phase2);
      results['맵 루나 (ZvP 60)'] = r;
    });
    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s5Phase2);
      results['맵 오델로 (ZvP 55)'] = r;
    });
    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s5Phase2);
      results['맵 투혼 (ZvP 48)'] = r;
    });
    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 소 Z A vs P B'] = r; expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 소 P A vs Z B'] = r; expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 중 Z S vs P B'] = r; expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 중 P S vs Z B'] = r; expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 대 Z S+ vs P B'] = r; expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['등급차 대 P S+ vs Z B'] = r; expect(r.homeWinRate, lessThan(30));
    });
    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s5Phase2);
      results['특화 P공격 vs Z수비'] = r;
    });
  });

  // =======================================================
  // S6: 디파일러 vs 한방 병력
  // =======================================================
  group('ZvP S6: 디파일러 vs 한방병력', () {
    const zBuild = 'zvp_scourge_defiler';
    const pBuild = 'pvz_forge_cannon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S6 디파일러 vs 한방병력', results: results);
      File('test/output/zvp_s6_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['동급 300게임'] = r;
      print('S6 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30)); expect(r.homeWinRate, lessThan(70));
    });
    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapLuna, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['맵 루나 (ZvP 60)'] = r;
    });
    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['맵 오델로 (ZvP 55)'] = r;
    });
    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['맵 투혼 (ZvP 48)'] = r;
    });
    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 소 Z A vs P B'] = r; expect(r.homeWinRate, greaterThan(50));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 소 P A vs Z B'] = r; expect(r.homeWinRate, lessThan(50));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 중 Z S vs P B'] = r; expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 중 P S vs Z B'] = r; expect(r.homeWinRate, lessThan(35));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 대 Z S+ vs P B'] = r; expect(r.homeWinRate, greaterThan(70));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['등급차 대 P S+ vs Z B'] = r; expect(r.homeWinRate, lessThan(30));
    });
    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s6Phase2, makeBranches4: s6Phase4);
      results['특화 P공격 vs Z수비'] = r;
    });
  });

  // =======================================================
  // S7: 973 히드라 올인
  // =======================================================
  group('ZvP S7: 973 히드라 올인', () {
    const zBuild = 'zvp_973_hydra';
    const pBuild = 'pvz_forge_cannon';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S7 973 히드라 올인', results: results);
      File('test/output/zvp_s7_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['동급 300게임'] = r;
      print('S7 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P4: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(30)); expect(r.homeWinRate, lessThan(70));
    });
    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapLuna, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 루나 (ZvP 60)'] = r;
    });
    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 오델로 (ZvP 55)'] = r;
    });
    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['맵 투혼 (ZvP 48)'] = r;
    });
    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 소 Z A vs P B'] = r; expect(r.homeWinRate, greaterThan(45));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 소 P A vs Z B'] = r; expect(r.homeWinRate, lessThan(55));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 중 Z S vs P B'] = r; expect(r.homeWinRate, greaterThan(60));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 중 P S vs Z B'] = r; expect(r.homeWinRate, lessThan(40));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 대 Z S+ vs P B'] = r; expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['등급차 대 P S+ vs Z B'] = r; expect(r.homeWinRate, lessThan(35));
    });
    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s7Phase2, makeBranches4: s7Phase4);
      results['특화 P공격 vs Z수비'] = r;
    });
  });

  // =======================================================
  // S8: 12앞마당 vs 2게이트
  // =======================================================
  group('ZvP S8: 12앞마당 vs 2게이트', () {
    const zBuild = 'zvp_12hatch';
    const pBuild = 'pvz_2gate_zealot';
    final results = <String, BatchResult>{};

    tearDownAll(() {
      final report = generateFullReport(title: 'S8 12앞마당 vs 2게이트', results: results, phaseName4: 'Phase 3');
      File('test/output/zvp_s8_report.md').writeAsStringSync(report);
    });

    test('동급 300게임', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['동급 300게임'] = r;
      print('S8 동급: Z ${r.homeWins}-${r.awayWins} P (${r.homeWinRate.toStringAsFixed(1)}%)');
      print('  P2: ${r.phase2.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p2Unknown}');
      print('  P3: ${r.phase4.map((b) => "${b.name}${b.count}").join(" ")} 미감지${r.p4Unknown}');
      expect(r.homeWinRate, greaterThan(25)); expect(r.homeWinRate, lessThan(70));
    });
    test('맵 루나 (ZvP 60)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapLuna, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['맵 루나 (ZvP 60)'] = r;
    });
    test('맵 오델로 (ZvP 55)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapOdelo, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['맵 오델로 (ZvP 55)'] = r;
    });
    test('맵 투혼 (ZvP 48)', () async {
      final r = await runBatchBiDir(zPlayer: zEqual, pPlayer: pEqual, map: mapTuhon, zBuild: zBuild, pBuild: pBuild, countPerDir: 50, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['맵 투혼 (ZvP 48)'] = r;
    });
    test('등급차 소 Z A vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zAGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 소 Z A vs P B'] = r; expect(r.homeWinRate, greaterThan(45));
    });
    test('등급차 소 P A vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pAGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 소 P A vs Z B'] = r; expect(r.homeWinRate, lessThan(55));
    });
    test('등급차 중 Z S vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSGrade, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 중 Z S vs P B'] = r; expect(r.homeWinRate, greaterThan(60));
    });
    test('등급차 중 P S vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 중 P S vs Z B'] = r; expect(r.homeWinRate, lessThan(40));
    });
    test('등급차 대 Z S+ vs P B', () async {
      final r = await runBatchBiDir(zPlayer: zSPlus, pPlayer: pBGrade, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 대 Z S+ vs P B'] = r; expect(r.homeWinRate, greaterThan(65));
    });
    test('등급차 대 P S+ vs Z B', () async {
      final r = await runBatchBiDir(zPlayer: zBGrade, pPlayer: pSPlus, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['등급차 대 P S+ vs Z B'] = r; expect(r.homeWinRate, lessThan(35));
    });
    test('특화 Z공격 vs P수비', () async {
      final r = await runBatchBiDir(zPlayer: zAttack, pPlayer: pDefense, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['특화 Z공격 vs P수비'] = r;
    });
    test('특화 P공격 vs Z수비', () async {
      final r = await runBatchBiDir(zPlayer: zDefense, pPlayer: pAttack, map: mapBalance, zBuild: zBuild, pBuild: pBuild, countPerDir: 150, makeBranches2: s8Phase2, makeBranches4: s8Phase3);
      results['특화 P공격 vs Z수비'] = r;
    });
  });
}
