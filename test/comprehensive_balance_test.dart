import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystar/domain/models/models.dart';
import 'package:mystar/domain/services/match_simulation_service.dart';

// ==================== 선수 팩토리 ====================

Player _makePlayer({
  required String id,
  required String name,
  required int raceIndex,
  int statPer = 700,
  int levelValue = 7,
  int condition = 100,
}) {
  return Player(
    id: id,
    name: name,
    raceIndex: raceIndex,
    stats: PlayerStats(
      sense: statPer,
      control: statPer,
      attack: statPer,
      harass: statPer,
      strategy: statPer,
      macro: statPer,
      defense: statPer,
      scout: statPer,
    ),
    levelValue: levelValue,
    condition: condition,
  );
}

// ==================== 맵 정의 ====================

/// 밸런스맵 (TvZ 55, ZvP 50, PvT 50)
const _balanceMap = GameMap(
  id: 'balance', name: '밸런스맵',
  rushDistance: 6, resources: 5, terrainComplexity: 5,
  airAccessibility: 6, centerImportance: 5,
);

/// 테란맵 (오델로: TvZ 65, ZvP 55, PvT 35)
const _terranMap = GameMap(
  id: 'othello', name: '오델로',
  rushDistance: 5, resources: 8, terrainComplexity: 4,
  airAccessibility: 6, centerImportance: 6,
  matchup: RaceMatchup(tvzTerranWinRate: 65, zvpZergWinRate: 55, pvtProtossWinRate: 35),
);

/// 저그맵 (루나: TvZ 42, ZvP 60, PvT 60)
const _zergMap = GameMap(
  id: 'luna', name: '루나',
  rushDistance: 7, resources: 6, terrainComplexity: 3,
  airAccessibility: 7, centerImportance: 4,
  matchup: RaceMatchup(tvzTerranWinRate: 42, zvpZergWinRate: 60, pvtProtossWinRate: 60),
);

/// 러시맵 (투혼: TvZ 55, ZvP 48, PvT 45)
const _rushMap = GameMap(
  id: 'tuhon', name: '투혼',
  rushDistance: 4, resources: 6, terrainComplexity: 4,
  airAccessibility: 5, centerImportance: 8,
  matchup: RaceMatchup(tvzTerranWinRate: 55, zvpZergWinRate: 48, pvtProtossWinRate: 45),
);

// ==================== 시뮬레이션 헬퍼 ====================

class _Result {
  int homeWins = 0;
  int awayWins = 0;
  int get total => homeWins + awayWins;
  double get homeRate => total > 0 ? homeWins / total * 100 : 0;
}

Future<_Result> _runGames({
  required Player home,
  required Player away,
  required GameMap map,
  int count = 100,
}) async {
  final result = _Result();
  for (int i = 0; i < count; i++) {
    final service = MatchSimulationService();
    final stream = service.simulateMatchWithLog(
      homePlayer: home,
      awayPlayer: away,
      map: map,
      getIntervalMs: () => 0,
    );
    SimulationState? state;
    await for (final s in stream) { state = s; }
    if (state == null) continue;
    if (state.homeWin == true) {
      result.homeWins++;
    } else {
      result.awayWins++;
    }
  }
  return result;
}

// ==================== 테스트 ====================

void main() {
  test('종합 밸런스 검증', () async {
    final buf = StringBuffer();
    buf.writeln('# 종합 밸런스 검증 리포트');
    buf.writeln();
    buf.writeln('> 각 시나리오 300경기, 양방향(홈/어웨이) 합산');
    buf.writeln();

    // ========================================
    // 1. 등급 차이 테스트
    // ========================================
    buf.writeln('## 1. 등급 차이 테스트');
    buf.writeln();
    buf.writeln('> 동일 컨디션(100%), 동일 레벨(7), 밸런스맵, TvT 미러');
    buf.writeln();

    // 등급별 스탯 (8능력치 균등)
    // S+ (700) vs A (500) vs B+ (400) vs B (350)
    final gradePairs = [
      {'label': 'S+ vs S+ (동급)', 'homeStat': 700, 'awayStat': 700},
      {'label': 'S+ vs A (격차 소)', 'homeStat': 700, 'awayStat': 500},
      {'label': 'S+ vs B+ (격차 중)', 'homeStat': 700, 'awayStat': 400},
      {'label': 'S+ vs B (격차 대)', 'homeStat': 700, 'awayStat': 350},
      {'label': 'A vs B+ (근접 등급)', 'homeStat': 500, 'awayStat': 400},
    ];

    buf.writeln('| 대결 | 강자 승 | 약자 승 | 강자 승률 | 판정 |');
    buf.writeln('|------|--------|--------|---------|------|');

    for (final pair in gradePairs) {
      final homeStat = pair['homeStat'] as int;
      final awayStat = pair['awayStat'] as int;
      final label = pair['label'] as String;

      // 양방향 합산 (홈/어웨이 편향 제거)
      final r1 = await _runGames(
        home: _makePlayer(id: 'strong', name: '강자', raceIndex: 0, statPer: homeStat),
        away: _makePlayer(id: 'weak', name: '약자', raceIndex: 0, statPer: awayStat),
        map: _balanceMap, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'weak', name: '약자', raceIndex: 0, statPer: awayStat),
        away: _makePlayer(id: 'strong', name: '강자', raceIndex: 0, statPer: homeStat),
        map: _balanceMap, count: 150,
      );

      final strongWins = r1.homeWins + r2.awayWins;
      final weakWins = r1.awayWins + r2.homeWins;
      final total = strongWins + weakWins;
      final strongRate = total > 0 ? strongWins / total * 100 : 0;

      String verdict;
      if (homeStat == awayStat) {
        verdict = (strongRate - 50).abs() <= 5 ? 'OK' : 'WARN';
      } else {
        verdict = strongRate > 55 ? 'OK' : 'FAIL';
      }
      buf.writeln('| $label | $strongWins | $weakWins | ${strongRate.toStringAsFixed(1)}% | $verdict |');
      print('등급: $label → 강자 ${strongRate.toStringAsFixed(1)}%');
    }
    buf.writeln();

    // ========================================
    // 2. 맵 다양성 테스트 (TvZ)
    // ========================================
    buf.writeln('## 2. 맵 다양성 테스트 (TvZ)');
    buf.writeln();
    buf.writeln('> 동일 능력치(700), 동일 레벨(7), 컨디션 100%');
    buf.writeln();

    final maps = [
      {'map': _balanceMap, 'label': '밸런스맵 (TvZ 55)', 'expected': 55},
      {'map': _terranMap, 'label': '오델로 (TvZ 65)', 'expected': 65},
      {'map': _zergMap, 'label': '루나 (TvZ 42)', 'expected': 42},
      {'map': _rushMap, 'label': '투혼 (TvZ 55)', 'expected': 55},
    ];

    buf.writeln('| 맵 | T 승 | Z 승 | T 승률 | 맵 설정 | 차이 |');
    buf.writeln('|-----|------|------|--------|--------|------|');

    for (final m in maps) {
      final map = m['map'] as GameMap;
      final label = m['label'] as String;
      final expected = m['expected'] as int;

      // 양방향 합산
      final r1 = await _runGames(
        home: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0),
        away: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1),
        map: map, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1),
        away: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0),
        map: map, count: 150,
      );

      final terranWins = r1.homeWins + r2.awayWins;
      final zergWins = r1.awayWins + r2.homeWins;
      final total = terranWins + zergWins;
      final tRate = total > 0 ? terranWins / total * 100 : 0;
      final diff = (tRate - expected).abs();

      buf.writeln('| $label | $terranWins | $zergWins | ${tRate.toStringAsFixed(1)}% | $expected% | ${diff.toStringAsFixed(1)}%p |');
      print('맵: $label → T ${tRate.toStringAsFixed(1)}% (설정 $expected%)');
    }
    buf.writeln();

    // 추가: PvT 맵 다양성
    buf.writeln('### PvT 맵 다양성');
    buf.writeln();
    buf.writeln('| 맵 | P 승 | T 승 | P 승률 | 맵 설정 | 차이 |');
    buf.writeln('|-----|------|------|--------|--------|------|');

    final pvtMaps = [
      {'map': _balanceMap, 'label': '밸런스맵 (PvT 50)', 'expected': 50},
      {'map': _terranMap, 'label': '오델로 (PvT 35)', 'expected': 35},
      {'map': _zergMap, 'label': '루나 (PvT 60)', 'expected': 60},
    ];

    for (final m in pvtMaps) {
      final map = m['map'] as GameMap;
      final label = m['label'] as String;
      final expected = m['expected'] as int;

      final r1 = await _runGames(
        home: _makePlayer(id: 'protoss', name: '이제동', raceIndex: 2),
        away: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0),
        map: map, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0),
        away: _makePlayer(id: 'protoss', name: '이제동', raceIndex: 2),
        map: map, count: 150,
      );

      final protossWins = r1.homeWins + r2.awayWins;
      final terranWins = r1.awayWins + r2.homeWins;
      final total = protossWins + terranWins;
      final pRate = total > 0 ? protossWins / total * 100 : 0;
      final diff = (pRate - expected).abs();

      buf.writeln('| $label | $protossWins | $terranWins | ${pRate.toStringAsFixed(1)}% | $expected% | ${diff.toStringAsFixed(1)}%p |');
      print('PvT맵: $label → P ${pRate.toStringAsFixed(1)}% (설정 $expected%)');
    }
    buf.writeln();

    // 추가: ZvP 맵 다양성
    buf.writeln('### ZvP 맵 다양성');
    buf.writeln();
    buf.writeln('| 맵 | Z 승 | P 승 | Z 승률 | 맵 설정 | 차이 |');
    buf.writeln('|-----|------|------|--------|--------|------|');

    final zvpMaps = [
      {'map': _balanceMap, 'label': '밸런스맵 (ZvP 50)', 'expected': 50},
      {'map': _terranMap, 'label': '오델로 (ZvP 55)', 'expected': 55},
      {'map': _zergMap, 'label': '루나 (ZvP 60)', 'expected': 60},
      {'map': _rushMap, 'label': '투혼 (ZvP 48)', 'expected': 48},
    ];

    for (final m in zvpMaps) {
      final map = m['map'] as GameMap;
      final label = m['label'] as String;
      final expected = m['expected'] as int;

      final r1 = await _runGames(
        home: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1),
        away: _makePlayer(id: 'protoss', name: '김택용', raceIndex: 2),
        map: map, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'protoss', name: '김택용', raceIndex: 2),
        away: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1),
        map: map, count: 150,
      );

      final zergWins = r1.homeWins + r2.awayWins;
      final protossWins = r1.awayWins + r2.homeWins;
      final total = zergWins + protossWins;
      final zRate = total > 0 ? zergWins / total * 100 : 0;
      final diff = (zRate - expected).abs();

      buf.writeln('| $label | $zergWins | $protossWins | ${zRate.toStringAsFixed(1)}% | $expected% | ${diff.toStringAsFixed(1)}%p |');
      print('ZvP맵: $label → Z ${zRate.toStringAsFixed(1)}% (설정 $expected%)');
    }
    buf.writeln();

    // ========================================
    // 3. 컨디션 차이 테스트
    // ========================================
    buf.writeln('## 3. 컨디션 차이 테스트');
    buf.writeln();
    buf.writeln('> TvT 미러, 동일 능력치(700), 동일 레벨(7), 밸런스맵');
    buf.writeln();

    final condPairs = [
      {'label': '100% vs 100% (기준)', 'homeCond': 100, 'awayCond': 100},
      {'label': '100% vs 80%', 'homeCond': 100, 'awayCond': 80},
      {'label': '100% vs 90%', 'homeCond': 100, 'awayCond': 90},
      {'label': '110% vs 100%', 'homeCond': 110, 'awayCond': 100},
    ];

    buf.writeln('| 조건 | 유리측 승 | 불리측 승 | 유리측 승률 | 판정 |');
    buf.writeln('|------|---------|---------|-----------|------|');

    for (final pair in condPairs) {
      final label = pair['label'] as String;
      final homeCond = pair['homeCond'] as int;
      final awayCond = pair['awayCond'] as int;

      // 양방향 합산
      final r1 = await _runGames(
        home: _makePlayer(id: 'good', name: '컨디션좋음', raceIndex: 0, condition: homeCond),
        away: _makePlayer(id: 'bad', name: '컨디션나쁨', raceIndex: 0, condition: awayCond),
        map: _balanceMap, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'bad', name: '컨디션나쁨', raceIndex: 0, condition: awayCond),
        away: _makePlayer(id: 'good', name: '컨디션좋음', raceIndex: 0, condition: homeCond),
        map: _balanceMap, count: 150,
      );

      final goodWins = r1.homeWins + r2.awayWins;
      final badWins = r1.awayWins + r2.homeWins;
      final total = goodWins + badWins;
      final goodRate = total > 0 ? goodWins / total * 100 : 0;

      String verdict;
      if (homeCond == awayCond) {
        verdict = (goodRate - 50).abs() <= 5 ? 'OK' : 'WARN';
      } else {
        // 컨디션 차이가 있으면 유리측이 이겨야 함
        verdict = goodRate > 55 ? 'OK' : 'WEAK';
      }
      buf.writeln('| $label | $goodWins | $badWins | ${goodRate.toStringAsFixed(1)}% | $verdict |');
      print('컨디션: $label → 유리측 ${goodRate.toStringAsFixed(1)}%');
    }
    buf.writeln();

    // ========================================
    // 4. 레벨 차이 테스트
    // ========================================
    buf.writeln('## 4. 레벨 차이 테스트');
    buf.writeln();
    buf.writeln('> TvT 미러, 동일 능력치(700), 컨디션 100%, 밸런스맵');
    buf.writeln('> 레벨 보너스: 레벨당 +2% 승률 (최대 ±20%)');
    buf.writeln();

    final levelPairs = [
      {'label': 'Lv7 vs Lv7 (기준)', 'homeLv': 7, 'awayLv': 7, 'expectedBonus': 0},
      {'label': 'Lv10 vs Lv5 (+10%)', 'homeLv': 10, 'awayLv': 5, 'expectedBonus': 10},
      {'label': 'Lv15 vs Lv7 (+16%)', 'homeLv': 15, 'awayLv': 7, 'expectedBonus': 16},
      {'label': 'Lv10 vs Lv10 (동레벨)', 'homeLv': 10, 'awayLv': 10, 'expectedBonus': 0},
      {'label': 'Lv20 vs Lv10 (+20%)', 'homeLv': 20, 'awayLv': 10, 'expectedBonus': 20},
    ];

    buf.writeln('| 조건 | 고레벨 승 | 저레벨 승 | 고레벨 승률 | 기대 보너스 | 판정 |');
    buf.writeln('|------|---------|---------|-----------|-----------|------|');

    for (final pair in levelPairs) {
      final label = pair['label'] as String;
      final homeLv = pair['homeLv'] as int;
      final awayLv = pair['awayLv'] as int;
      final expectedBonus = pair['expectedBonus'] as int;

      // 양방향 합산
      final r1 = await _runGames(
        home: _makePlayer(id: 'high', name: '고레벨', raceIndex: 0, levelValue: homeLv),
        away: _makePlayer(id: 'low', name: '저레벨', raceIndex: 0, levelValue: awayLv),
        map: _balanceMap, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'low', name: '저레벨', raceIndex: 0, levelValue: awayLv),
        away: _makePlayer(id: 'high', name: '고레벨', raceIndex: 0, levelValue: homeLv),
        map: _balanceMap, count: 150,
      );

      final highWins = r1.homeWins + r2.awayWins;
      final lowWins = r1.awayWins + r2.homeWins;
      final total = highWins + lowWins;
      final highRate = total > 0 ? highWins / total * 100 : 0;

      String verdict;
      if (expectedBonus == 0) {
        verdict = (highRate - 50).abs() <= 5 ? 'OK' : 'WARN';
      } else {
        // 기대 승률: 50 + bonus
        final expected = 50.0 + expectedBonus;
        final diff = (highRate - expected).abs();
        verdict = diff <= 10 ? 'OK' : 'DRIFT';
      }
      buf.writeln('| $label | $highWins | $lowWins | ${highRate.toStringAsFixed(1)}% | +$expectedBonus% | $verdict |');
      print('레벨: $label → 고레벨 ${highRate.toStringAsFixed(1)}% (기대 ${50 + expectedBonus}%)');
    }
    buf.writeln();

    // ========================================
    // 5. 이종족전 등급 차이 (TvZ, PvT)
    // ========================================
    buf.writeln('## 5. 이종족전 등급 차이');
    buf.writeln();
    buf.writeln('> 밸런스맵, 동일 레벨(7), 컨디션 100%');
    buf.writeln();

    buf.writeln('### TvZ 등급 차이');
    buf.writeln();
    buf.writeln('| 대결 | T 승 | Z 승 | T 승률 | 판정 |');
    buf.writeln('|------|------|------|--------|------|');

    final crossGrades = [
      {'label': 'T(700) vs Z(700) 동급', 'tStat': 700, 'zStat': 700},
      {'label': 'T(700) vs Z(500) T강', 'tStat': 700, 'zStat': 500},
      {'label': 'T(500) vs Z(700) Z강', 'tStat': 500, 'zStat': 700},
    ];

    for (final pair in crossGrades) {
      final label = pair['label'] as String;
      final tStat = pair['tStat'] as int;
      final zStat = pair['zStat'] as int;

      final r1 = await _runGames(
        home: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0, statPer: tStat),
        away: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1, statPer: zStat),
        map: _balanceMap, count: 150,
      );
      final r2 = await _runGames(
        home: _makePlayer(id: 'zerg', name: '이재동', raceIndex: 1, statPer: zStat),
        away: _makePlayer(id: 'terran', name: '이영호', raceIndex: 0, statPer: tStat),
        map: _balanceMap, count: 150,
      );

      final tWins = r1.homeWins + r2.awayWins;
      final zWins = r1.awayWins + r2.homeWins;
      final total = tWins + zWins;
      final tRate = total > 0 ? tWins / total * 100 : 0;

      String verdict;
      if (tStat == zStat) {
        verdict = (tRate >= 52 && tRate <= 58) ? 'OK' : 'WARN';
      } else if (tStat > zStat) {
        verdict = tRate >= 65 ? 'OK' : 'WEAK';
      } else {
        verdict = tRate <= 40 ? 'OK' : 'WEAK';
      }
      buf.writeln('| $label | $tWins | $zWins | ${tRate.toStringAsFixed(1)}% | $verdict |');
      print('TvZ등급: $label → T ${tRate.toStringAsFixed(1)}%');
    }
    buf.writeln();

    // ========================================
    // 파일 저장
    // ========================================
    final outputDir = Directory('test/output');
    if (!outputDir.existsSync()) outputDir.createSync(recursive: true);
    File('test/output/comprehensive_balance.md').writeAsStringSync(buf.toString());
    print('\ncomprehensive_balance.md 저장 완료');
  });
}
