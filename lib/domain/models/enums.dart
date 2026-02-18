/// MyStar 게임 열거형 정의
library;

/// 종족
enum Race {
  terran('T', '테란'),
  zerg('Z', '저그'),
  protoss('P', '프로토스');

  final String code;
  final String koreanName;
  const Race(this.code, this.koreanName);
}

/// 등급 (F- ~ SSS, 25단계)
enum Grade {
  fMinus('F-', 0, 39),
  f('F', 40, 79),
  fPlus('F+', 80, 129),
  eMinus('E-', 130, 199),
  e('E', 200, 319),
  ePlus('E+', 320, 449),
  dMinus('D-', 450, 649),
  d('D', 650, 899),
  dPlus('D+', 900, 1199),
  cMinus('C-', 1200, 1599),
  c('C', 1600, 1999),
  cPlus('C+', 2000, 2399),
  bMinus('B-', 2400, 2799),
  b('B', 2800, 3199),
  bPlus('B+', 3200, 3599),
  aMinus('A-', 3600, 3999),
  a('A', 4000, 4399),
  aPlus('A+', 4400, 4799),
  sMinus('S-', 4800, 5199),
  s('S', 5200, 5599),
  sPlus('S+', 5600, 5999),
  ssMinus('SS-', 6000, 6399),
  ss('SS', 6400, 6799),
  ssPlus('SS+', 6800, 7199),
  sss('SSS', 7200, 7992);

  final String display;
  final int minStat;
  final int maxStat;
  const Grade(this.display, this.minStat, this.maxStat);

  /// 능력치 합계로 등급 계산
  static Grade fromTotalStats(int total) {
    for (final grade in Grade.values.reversed) {
      if (total >= grade.minStat) {
        return grade;
      }
    }
    return Grade.fMinus;
  }

  /// 등급별 기본 몸값 (만원)
  int get basePrice {
    switch (this) {
      case Grade.sss:
        return 1000;
      case Grade.ssPlus:
        return 800;
      case Grade.ss:
        return 600;
      case Grade.ssMinus:
        return 500;
      case Grade.sPlus:
        return 400;
      case Grade.s:
        return 300;
      case Grade.sMinus:
        return 250;
      case Grade.aPlus:
        return 200;
      case Grade.a:
        return 150;
      case Grade.aMinus:
        return 100;
      case Grade.bPlus:
        return 70;
      case Grade.b:
        return 50;
      case Grade.bMinus:
        return 35;
      default:
        return 20;
    }
  }

  /// 등급 간 차이 계산 (-값: 상대가 높음, +값: 내가 높음)
  int compareTo(Grade other) {
    return index - other.index;
  }
}

/// 선수 레벨 (1~20, 경험치 기반)
/// - 경기 출전으로 경험치 누적 → 레벨업
/// - 레벨당 전투 보정 +2% (최대 +38%)
/// - 레벨업 시 8개 능력치 각각 상승 (레벨 낮을수록 상승폭 큼)
/// - 레벨 20은 레전드급만 도달 가능
enum PlayerLevel {
  level1(1, 0, 0, 0),           // 시작 레벨 (상승 없음)
  level2(2, 200, 10, 45),       // 신인 폭풍 성장
  level3(3, 500, 10, 40),
  level4(4, 1000, 8, 35),
  level5(5, 1800, 8, 30),
  level6(6, 3000, 6, 25),       // 성장기
  level7(7, 4500, 6, 22),
  level8(8, 6500, 5, 20),
  level9(9, 9000, 5, 18),
  level10(10, 12000, 4, 16),    // 중견 진입
  level11(11, 16000, 4, 14),
  level12(12, 21000, 3, 12),
  level13(13, 27000, 3, 11),
  level14(14, 35000, 2, 10),    // 베테랑
  level15(15, 45000, 2, 9),
  level16(16, 58000, 2, 8),
  level17(17, 75000, 1, 7),     // 노장
  level18(18, 100000, 1, 6),
  level19(19, 135000, 1, 5),
  level20(20, 180000, 0, 10);   // 레전드 보너스

  final int value;
  final int requiredExp;      // 해당 레벨에 필요한 누적 경험치
  final int levelUpGrowthMin; // 레벨업 시 능력치 상승 최소 (각 스탯별)
  final int levelUpGrowthMax; // 레벨업 시 능력치 상승 최대 (각 스탯별)

  const PlayerLevel(this.value, this.requiredExp, this.levelUpGrowthMin, this.levelUpGrowthMax);

  /// 전투 보정 (레벨당 +2%)
  double get battleBonus => (value - 1) * 0.02;

  /// 전투 보정 퍼센트 표시용
  String get battleBonusDisplay => '+${((value - 1) * 2)}%';

  /// 이적료 계수 (레벨 높을수록 비쌈)
  double get priceMultiplier => 0.5 + (value * 0.1); // 0.6 ~ 2.5

  /// 다음 레벨
  PlayerLevel? get next {
    if (value >= 20) return null;
    return PlayerLevel.values[value]; // value가 1부터 시작하므로 index = value
  }

  /// 다음 레벨까지 필요한 경험치
  int get expToNextLevel {
    final nextLv = next;
    if (nextLv == null) return 0;
    return nextLv.requiredExp - requiredExp;
  }

  /// 경험치로 레벨 계산
  static PlayerLevel fromExperience(int exp) {
    for (final level in PlayerLevel.values.reversed) {
      if (exp >= level.requiredExp) {
        return level;
      }
    }
    return PlayerLevel.level1;
  }

  static PlayerLevel fromValue(int value) {
    return PlayerLevel.values.firstWhere(
      (l) => l.value == value,
      orElse: () => PlayerLevel.level1,
    );
  }
}

/// 커리어 단계 (시간 기반, 성장/하락 담당)
/// - 시즌 경과에 따라 진행
/// - 성장폭과 하락 위험도 결정
enum Career {
  rookie('신인', 1.8, 20, 40, 5, 25, 50, 0.0),      // 성장 최고
  rising('상승세', 1.5, 15, 35, 0, 20, 45, 0.0),    // 성장 높음
  prime('전성기', 1.0, 5, 15, -10, 5, 35, 0.05),    // 안정
  veteran('베테랑', 0.6, -5, 5, -20, -5, 20, 0.15), // 하락 시작
  twilight('노장', 0.3, -15, 0, -35, -15, 10, 0.30); // 하락 높음

  final String koreanName;
  final double priceMultiplier; // 이적료 계수
  final int winGrowthMin;       // 승리 시 성장 최소
  final int winGrowthMax;       // 승리 시 성장 최대
  final int loseGrowthMin;      // 패배 시 성장 최소
  final int loseGrowthMax;      // 패배 시 성장 최대
  final int trainingMax;        // 특훈 시 능력치 상승 최대값
  final double declineChance;   // 시즌당 은퇴/하락 이벤트 확률

  const Career(
    this.koreanName,
    this.priceMultiplier,
    this.winGrowthMin,
    this.winGrowthMax,
    this.loseGrowthMin,
    this.loseGrowthMax,
    this.trainingMax,
    this.declineChance,
  );

  /// 다음 커리어 단계
  Career? get next {
    if (this == Career.twilight) return null;
    return Career.values[index + 1];
  }

  /// 커리어 단계별 필요 시즌 (누적)
  int get requiredSeasons {
    switch (this) {
      case Career.rookie:
        return 0;  // 시작
      case Career.rising:
        return 3;  // 3시즌 후
      case Career.prime:
        return 7;  // 7시즌 후
      case Career.veteran:
        return 14; // 14시즌 후
      case Career.twilight:
        return 20; // 20시즌 후
    }
  }

  /// 시즌 수로 커리어 단계 계산
  static Career fromSeasons(int seasons) {
    for (final career in Career.values.reversed) {
      if (seasons >= career.requiredSeasons) {
        return career;
      }
    }
    return Career.rookie;
  }

  static Career fromIndex(int index) {
    if (index < 0 || index >= Career.values.length) {
      return Career.rookie;
    }
    return Career.values[index];
  }
}

/// 아이템 종류
enum ItemType {
  consumable('소모품'),
  mouse('마우스'),
  keyboard('키보드'),
  monitor('모니터'),
  accessory('기타');

  final String koreanName;
  const ItemType(this.koreanName);
}

/// 경기 배속
enum MatchSpeed {
  x1(1, 1000),
  x2(2, 500),
  x4(4, 250),
  x8(8, 125);

  final int multiplier;
  final int intervalMs;
  const MatchSpeed(this.multiplier, this.intervalMs);
}

/// 빌드 스타일 (상위 분류)
enum BuildStyle {
  aggressive('공격형'),
  defensive('수비형'),
  balanced('밸런스'),
  cheese('치즈');

  final String koreanName;
  const BuildStyle(this.koreanName);
}

/// 세부 빌드 타입 (매치업별 구체적 빌드, sc1hub.com 기준)
enum BuildType {
  // ==================== TvZ 빌드 (7개) ====================
  tvzBunkerRush('tvz_bunker', 'TvZ', '8배럭 벙커링', BuildStyle.cheese, ['attack', 'control']),
  tvzSKTerran('tvz_sk', 'TvZ', '투배럭 아카', BuildStyle.aggressive, ['control', 'macro']),
  tvz3FactoryGoliath('tvz_3fac_goliath', 'TvZ', '5팩 골리앗', BuildStyle.defensive, ['defense', 'macro']),
  tvz4RaxEnbe('tvz_4rax_enbe', 'TvZ', '선엔베 4배럭', BuildStyle.aggressive, ['attack', 'macro']),
  tvz111('tvz_111', 'TvZ', '111', BuildStyle.balanced, ['strategy', 'control']),
  tvzValkyrie('tvz_valkyrie', 'TvZ', '발리오닉', BuildStyle.defensive, ['defense', 'macro']),
  tvz2StarWraith('tvz_2star_wraith', 'TvZ', '투스타 레이스', BuildStyle.aggressive, ['harass', 'strategy']),

  // ==================== TvP 빌드 (11개) ====================
  tvpDouble('tvp_double', 'TvP', '팩더블', BuildStyle.defensive, ['macro', 'defense']),
  tvpFakeDouble('tvp_fake_double', 'TvP', '타이밍 러쉬', BuildStyle.aggressive, ['attack', 'strategy']),
  tvp1FactDrop('tvp_1fac_drop', 'TvP', '투팩 찌르기', BuildStyle.aggressive, ['attack', 'control']),
  tvp1FactGosu('tvp_1fac_gosu', 'TvP', '업테란', BuildStyle.defensive, ['defense', 'strategy']),
  tvpRaxDouble('tvp_rax_double', 'TvP', '배럭 더블', BuildStyle.defensive, ['macro', 'defense']),
  tvp5FacTiming('tvp_5fac_timing', 'TvP', '5팩 타이밍', BuildStyle.aggressive, ['attack', 'macro']),
  tvpMineTriple('tvp_mine_triple', 'TvP', '마인 트리플', BuildStyle.defensive, ['defense', 'macro']),
  tvpFd('tvp_fd', 'TvP', 'FD테란', BuildStyle.balanced, ['macro', 'strategy']),
  tvp11Up8Fac('tvp_11up_8fac', 'TvP', '11업 8팩', BuildStyle.aggressive, ['attack', 'macro']),
  tvpAntiCarrier('tvp_anti_carrier', 'TvP', '안티 캐리어', BuildStyle.balanced, ['strategy', 'defense']),

  // ==================== TvT 빌드 (3개) ====================
  tvt1FactPush('tvt_1fac_push', 'TvT', '원팩원스타', BuildStyle.aggressive, ['attack', 'control']),
  tvtWraithCloak('tvt_wraith_cloak', 'TvT', '투스타 레이스', BuildStyle.aggressive, ['harass', 'strategy']),
  tvtCCFirst('tvt_cc_first', 'TvT', '배럭더블', BuildStyle.defensive, ['macro', 'defense']),

  // ==================== ZvT 빌드 (4개) ====================
  zvt3HatchMutal('zvt_3hatch_mutal', 'ZvT', '미친 저그', BuildStyle.aggressive, ['attack', 'macro']),
  zvt2HatchMutal('zvt_2hatch_mutal', 'ZvT', '투해처리 뮤탈', BuildStyle.aggressive, ['harass', 'control']),
  zvt2HatchLurker('zvt_2hatch_lurker', 'ZvT', '가드라', BuildStyle.defensive, ['macro', 'defense']),
  zvt1HatchAllIn('zvt_1hatch_allin', 'ZvT', '530 뮤탈', BuildStyle.aggressive, ['harass', 'control']),

  // ==================== ZvP 빌드 (7개) ====================
  zvp3HatchHydra('zvp_3hatch_hydra', 'ZvP', '5해처리 히드라', BuildStyle.aggressive, ['macro', 'attack']),
  zvp2HatchMutal('zvp_2hatch_mutal', 'ZvP', '5뮤탈', BuildStyle.balanced, ['harass', 'strategy']),
  zvpScourgeDefiler('zvp_scourge_defiler', 'ZvP', '하이브 운영', BuildStyle.defensive, ['macro', 'strategy']),
  zvp5DroneZergling('zvp_5drone', 'ZvP', '9투 올인', BuildStyle.cheese, ['attack', 'control']),
  zvp973Hydra('zvp_973_hydra', 'ZvP', '973 히드라', BuildStyle.aggressive, ['attack', 'control']),
  zvpMukerji('zvp_mukerji', 'ZvP', '뮤커지', BuildStyle.balanced, ['harass', 'control']),
  zvpYabarwi('zvp_yabarwi', 'ZvP', '야바위', BuildStyle.aggressive, ['strategy', 'attack']),

  // ==================== ZvZ 빌드 (4개) ====================
  zvzPoolFirst('zvz_pool_first', 'ZvZ', '날먹', BuildStyle.cheese, ['attack', 'scout']),
  zvz9Pool('zvz_9pool', 'ZvZ', '9레어', BuildStyle.aggressive, ['strategy', 'control']),
  zvz12Hatch('zvz_12hatch', 'ZvZ', '12앞마당', BuildStyle.defensive, ['macro', 'defense']),
  zvzOverPool('zvz_overpool', 'ZvZ', '오버풀', BuildStyle.balanced, ['macro', 'control']),

  // ==================== PvT 빌드 (7개) ====================
  pvt2GateZealot('pvt_2gate_zealot', 'PvT', '선질럿 찌르기', BuildStyle.aggressive, ['attack', 'control']),
  pvtDarkSwing('pvt_dark_swing', 'PvT', '다크드랍', BuildStyle.cheese, ['strategy', 'harass']),
  pvt1GateObserver('pvt_1gate_obs', 'PvT', '23넥 아비터', BuildStyle.defensive, ['defense', 'macro']),
  pvtProxyDark('pvt_proxy_dark', 'PvT', '전진로보', BuildStyle.aggressive, ['attack', 'control']),
  pvt1GateExpansion('pvt_1gate_expand', 'PvT', '19넥', BuildStyle.balanced, ['macro', 'defense']),
  pvtCarrier('pvt_carrier', 'PvT', '생넥 캐리어', BuildStyle.defensive, ['macro', 'strategy']),
  pvtReaverShuttle('pvt_reaver_shuttle', 'PvT', '리버 후 속셔템', BuildStyle.balanced, ['harass', 'control']),

  // ==================== PvZ 빌드 (7개) ====================
  pvz2GateZealot('pvz_2gate_zealot', 'PvZ', '파워 드라군', BuildStyle.aggressive, ['attack', 'macro']),
  pvzForgeCannon('pvz_forge_cannon', 'PvZ', '포지더블', BuildStyle.defensive, ['defense', 'macro']),
  pvzCorsairReaver('pvz_corsair_reaver', 'PvZ', '선아둔', BuildStyle.balanced, ['strategy', 'macro']),
  pvzProxyGateway('pvz_proxy_gate', 'PvZ', '센터 99게이트', BuildStyle.cheese, ['attack', 'control']),
  pvzCannonRush('pvz_cannon_rush', 'PvZ', '캐논 러쉬', BuildStyle.cheese, ['attack', 'sense']),
  pvz8Gat('pvz_8gat', 'PvZ', '8겟뽕', BuildStyle.cheese, ['attack', 'control']),
  pvz2StarCorsair('pvz_2star_corsair', 'PvZ', '투스타 커세어', BuildStyle.aggressive, ['harass', 'strategy']),

  // ==================== PvP 빌드 (6개) ====================
  pvp2GateDragoon('pvp_2gate_dragoon', 'PvP', '옵3겟', BuildStyle.balanced, ['defense', 'scout']),
  pvpDarkAllIn('pvp_dark_allin', 'PvP', '다크 더블', BuildStyle.cheese, ['strategy', 'harass']),
  pvp1GateRobo('pvp_1gate_robo', 'PvP', '기어리버', BuildStyle.defensive, ['defense', 'strategy']),
  pvpZealotRush('pvp_zealot_rush', 'PvP', '센터99게이트', BuildStyle.cheese, ['attack', 'control']),
  pvp4GateDragoon('pvp_4gate_dragoon', 'PvP', '21 3게이트 드라군', BuildStyle.cheese, ['attack', 'control']),
  pvp1GateMulti('pvp_1gate_multi', 'PvP', '원겟 멀티', BuildStyle.defensive, ['macro', 'defense']);

  final String id;
  final String matchup;
  final String koreanName;
  final BuildStyle parentStyle;
  final List<String> keyStats; // 핵심 능력치 2개

  const BuildType(this.id, this.matchup, this.koreanName, this.parentStyle, this.keyStats);

  /// ID로 BuildType 검색
  static BuildType? getById(String id) {
    for (final b in BuildType.values) {
      if (b.id == id) return b;
    }
    return null;
  }

  /// 매치업에 맞는 빌드 목록 반환
  static List<BuildType> getByMatchup(String matchup) {
    return BuildType.values.where((b) => b.matchup == matchup).toList();
  }

  /// 매치업 + 스타일에 맞는 빌드 목록 반환
  static List<BuildType> getByMatchupAndStyle(String matchup, BuildStyle style) {
    return BuildType.values
        .where((b) => b.matchup == matchup && b.parentStyle == style)
        .toList();
  }
}

/// 빌드 상성 시스템
class BuildMatchup {
  /// 빌드 타입 간 상성 계산 (공격자 관점 보너스 %, -값은 불리)
  /// 기본 원칙: 올인 > 그리디, 그리디 > 안정형, 안정형 > 올인
  static double getBuildAdvantage(BuildType attacker, BuildType defender) {
    // 같은 빌드면 상성 없음
    if (attacker == defender) return 0;

    // 상위 스타일 기반 기본 상성
    double baseAdvantage = _getStyleAdvantage(attacker.parentStyle, defender.parentStyle);

    // 세부 빌드별 특수 상성
    baseAdvantage += _getSpecificAdvantage(attacker, defender);

    return baseAdvantage.clamp(-40, 40); // 최대 ±40%
  }

  /// 상위 스타일 간 기본 상성 (반대칭: f(A,B) = -f(B,A))
  static double _getStyleAdvantage(BuildStyle a, BuildStyle b) {
    if (a == b) return 0;

    // cheese > defensive: 치즈가 준비 전에 터뜨림 (+25)
    if (a == BuildStyle.cheese && b == BuildStyle.defensive) return 25;
    if (a == BuildStyle.defensive && b == BuildStyle.cheese) return -25;

    // aggressive > balanced: 템포 선점 (+10)
    if (a == BuildStyle.aggressive && b == BuildStyle.balanced) return 10;
    if (a == BuildStyle.balanced && b == BuildStyle.aggressive) return -10;

    // defensive > aggressive: 수비 성공 시 경제 유리 (+12)
    if (a == BuildStyle.defensive && b == BuildStyle.aggressive) return 12;
    if (a == BuildStyle.aggressive && b == BuildStyle.defensive) return -12;

    // aggressive > cheese: 치즈 리스크 징벌 (+5)
    if (a == BuildStyle.aggressive && b == BuildStyle.cheese) return 5;
    if (a == BuildStyle.cheese && b == BuildStyle.aggressive) return -5;

    // cheese > balanced: 기습 성공 (+10)
    if (a == BuildStyle.cheese && b == BuildStyle.balanced) return 10;
    if (a == BuildStyle.balanced && b == BuildStyle.cheese) return -10;

    // defensive vs balanced: 중립
    return 0;
  }

  /// 세부 빌드 특수 상성 (반대칭: f(A,B) = -f(B,A))
  static double _getSpecificAdvantage(BuildType a, BuildType b) {
    // ZvZ 특수 상성
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz12Hatch) return 20;   // 날먹 > 12앞마당
    if (a == BuildType.zvz12Hatch && b == BuildType.zvzPoolFirst) return -20;
    if (a == BuildType.zvz9Pool && b == BuildType.zvz12Hatch) return 15;       // 9레어 > 12앞마당
    if (a == BuildType.zvz12Hatch && b == BuildType.zvz9Pool) return -15;
    if (a == BuildType.zvzOverPool && b == BuildType.zvzPoolFirst) return 10;   // 오버풀 > 날먹
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvzOverPool) return -10;

    // TvZ/ZvT 특수 상성
    if (a == BuildType.tvzBunkerRush && b == BuildType.zvt1HatchAllIn) return 15;  // 벙커링 > 530뮤탈
    if (a == BuildType.zvt1HatchAllIn && b == BuildType.tvzBunkerRush) return -15;
    if (a == BuildType.tvz4RaxEnbe && b == BuildType.zvt3HatchMutal) return 12;    // 선엔베 > 미친저그
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvz4RaxEnbe) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt3HatchMutal) return 12;         // 111 탱크가 3해처리 느린 방어 타이밍 노림
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvz111) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt2HatchMutal) return 8;          // 레이스 정찰로 뮤탈 타이밍 파악
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvz111) return -8;
    if (a == BuildType.tvz111 && b == BuildType.zvt2HatchLurker) return 12;        // 111 > 가드라
    if (a == BuildType.zvt2HatchLurker && b == BuildType.tvz111) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt1HatchAllIn) return 8;          // 빠른 탱크로 530 타이밍 버팀
    if (a == BuildType.zvt1HatchAllIn && b == BuildType.tvz111) return -8;
    if (a == BuildType.tvzValkyrie && b == BuildType.zvt2HatchMutal) return 15;    // 발리오닉 > 뮤탈
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvzValkyrie) return -15;
    if (a == BuildType.tvz2StarWraith && b == BuildType.zvt2HatchLurker) return 12; // 레이스 > 지상저그
    if (a == BuildType.zvt2HatchLurker && b == BuildType.tvz2StarWraith) return -12;

    // TvT 특수 상성
    if (a == BuildType.tvt1FactPush && b == BuildType.tvtCCFirst) return 15;   // 원팩원스타 > 배럭더블
    if (a == BuildType.tvtCCFirst && b == BuildType.tvt1FactPush) return -15;
    if (a == BuildType.tvtWraithCloak && b == BuildType.tvtCCFirst) return 12;  // 투스타레이스 > 배럭더블
    if (a == BuildType.tvtCCFirst && b == BuildType.tvtWraithCloak) return -12;

    // TvP/PvT 특수 상성
    if (a == BuildType.tvpFakeDouble && b == BuildType.pvt1GateObserver) return -10; // 타이밍러쉬 < 23넥아비터
    if (a == BuildType.pvt1GateObserver && b == BuildType.tvpFakeDouble) return 10;
    if (a == BuildType.tvp5FacTiming && b == BuildType.pvt1GateExpansion) return 12; // 5팩타이밍 > 19넥
    if (a == BuildType.pvt1GateExpansion && b == BuildType.tvp5FacTiming) return -12;
    if (a == BuildType.tvp11Up8Fac && b == BuildType.pvt1GateObserver) return 10;    // 11업8팩 > 느린아비터
    if (a == BuildType.pvt1GateObserver && b == BuildType.tvp11Up8Fac) return -10;
    if (a == BuildType.tvpAntiCarrier && b == BuildType.pvtCarrier) return 25;       // 안티캐리어 특화
    if (a == BuildType.pvtCarrier && b == BuildType.tvpAntiCarrier) return -25;

    // PvT/TvP 특수 상성
    if (a == BuildType.pvtDarkSwing && b == BuildType.tvpDouble) return 12;    // 다크드랍 > 팩더블
    if (a == BuildType.tvpDouble && b == BuildType.pvtDarkSwing) return -12;
    if (a == BuildType.pvt2GateZealot && b == BuildType.tvpDouble) return 15;  // 선질럿 > 팩더블
    if (a == BuildType.tvpDouble && b == BuildType.pvt2GateZealot) return -15;
    if (a == BuildType.pvtProxyDark && b == BuildType.tvpRaxDouble) return 12;  // 전진로보 > 배럭더블
    if (a == BuildType.tvpRaxDouble && b == BuildType.pvtProxyDark) return -12;
    if (a == BuildType.pvtCarrier && b == BuildType.tvpFakeDouble) return -10;  // 캐리어 < 타이밍
    if (a == BuildType.tvpFakeDouble && b == BuildType.pvtCarrier) return 10;
    if (a == BuildType.pvtReaverShuttle && b == BuildType.tvpDouble) return 10; // 리버속셔템 > 팩더블
    if (a == BuildType.tvpDouble && b == BuildType.pvtReaverShuttle) return -10;

    // PvZ/ZvP 특수 상성
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp5DroneZergling) return 30; // 포지더블 > 9투올인
    if (a == BuildType.zvp5DroneZergling && b == BuildType.pvzForgeCannon) return -30;
    if (a == BuildType.pvzCannonRush && b == BuildType.zvpScourgeDefiler) return 20;  // 캐논러쉬 > 하이브운영
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvzCannonRush) return -20;
    if (a == BuildType.pvz8Gat && b == BuildType.zvpScourgeDefiler) return 18;        // 8겟뽕 > 하이브운영
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvz8Gat) return -18;
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvp3HatchHydra) return 10;   // 커세어 > 히드라
    if (a == BuildType.zvp3HatchHydra && b == BuildType.pvz2StarCorsair) return -10;

    // ZvP/PvZ 특수 상성
    if (a == BuildType.zvp3HatchHydra && b == BuildType.pvzForgeCannon) return 12;    // 5해히드라 > 포지더블
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp3HatchHydra) return -12;
    if (a == BuildType.zvp973Hydra && b == BuildType.pvzForgeCannon) return -5;       // 973히드라 < 포지더블
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp973Hydra) return 5;
    if (a == BuildType.zvp973Hydra && b == BuildType.pvzCorsairReaver) return 15;     // 973히드라 > 선아둔
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvp973Hydra) return -15;
    if (a == BuildType.zvpMukerji && b == BuildType.pvzForgeCannon) return 8;         // 뮤커지 > 포지더블
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvpMukerji) return -8;
    if (a == BuildType.zvpYabarwi && b == BuildType.pvzCorsairReaver) return 12;      // 야바위 > 선아둔
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvpYabarwi) return -12;

    // PvP 특수 상성
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp2GateDragoon) return 15;     // 다크더블 > 옵3겟
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvpDarkAllIn) return -15;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp1GateMulti) return 18;    // 3겟드라군 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp4GateDragoon) return -18;
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp1GateMulti) return 15;      // 센터99겟 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvpZealotRush) return -15;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvpDarkAllIn) return 20;        // 기어리버 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp1GateRobo) return -20;

    return 0;
  }

  /// 정찰 성공 시 상성 역전 보너스
  static double getScoutBonus(int scoutStat, BuildType opponentBuild) {
    // 정찰력 700 이상이면 상대 빌드 읽기 가능
    if (scoutStat < 600) return 0;

    // cheese 빌드는 읽히면 치명적
    if (opponentBuild.parentStyle == BuildStyle.cheese) {
      return (scoutStat - 600) / 20; // 최대 +20%
    }

    // 일반 빌드도 읽으면 유리
    return (scoutStat - 600) / 40; // 최대 +10%
  }
}

/// 개인리그 단계
enum IndividualLeagueStage {
  pcBangQualifier('PC방 예선'),
  dualTournament('듀얼토너먼트'),
  groupDraw('조지명식'),
  round32('32강'),
  round16('16강'),
  quarterFinal('8강'),
  semiFinal('4강'),
  final_('결승');

  final String koreanName;
  const IndividualLeagueStage(this.koreanName);
}

/// 시즌 단계
enum SeasonPhase {
  regularSeason('정규 시즌'),
  playoffReady('플레이오프 대기'),
  playoff34('플레이오프 3,4위전'),
  individualSemiFinal('개인리그 4강'),
  playoff23('플레이오프 2,3위전'),
  individualFinal('개인리그 결승'),
  playoffFinal('플레이오프 결승'),
  seasonEnd('시즌 종료');

  final String koreanName;
  const SeasonPhase(this.koreanName);
}

/// 플레이오프 매치 타입
enum PlayoffMatchType {
  thirdFourth('3,4위전'),
  secondThird('2,3위전'),
  final_('결승전');

  final String koreanName;
  const PlayoffMatchType(this.koreanName);
}


/// 경기 단계
enum GamePhase {
  early('초반', 1, 30),
  mid('중반', 31, 80),
  late('후반', 81, 200);

  final String koreanName;
  final int startLine;
  final int endLine;

  const GamePhase(this.koreanName, this.startLine, this.endLine);

  static GamePhase fromLineCount(int lineCount) {
    if (lineCount <= 30) return GamePhase.early;
    if (lineCount <= 80) return GamePhase.mid;
    return GamePhase.late;
  }
}

/// 능력치 가중치 시스템
class StatWeights {
  /// 경기 단계별 능력치 가중치 (1.0 = 기본, 1.5 = 50% 보너스)
  static Map<String, double> getPhaseWeights(GamePhase phase) {
    switch (phase) {
      case GamePhase.early:
        return {
          'sense': 1.2,     // 빌드 선택
          'control': 1.0,
          'attack': 1.5,    // 초반 공격
          'harass': 1.0,
          'strategy': 1.3,  // 빌드 전략
          'macro': 0.8,
          'defense': 1.4,   // 초반 수비
          'scout': 1.5,     // 정찰 중요
        };
      case GamePhase.mid:
        return {
          'sense': 1.0,
          'control': 1.3,   // 교전 컨트롤
          'attack': 1.0,
          'harass': 1.5,    // 견제 전성기
          'strategy': 1.3,  // 테크 선택
          'macro': 1.2,     // 확장
          'defense': 1.0,
          'scout': 1.0,
        };
      case GamePhase.late:
        return {
          'sense': 1.0,
          'control': 1.5,   // 대규모 전투
          'attack': 1.0,
          'harass': 0.8,
          'strategy': 1.2,  // 역전 전략
          'macro': 1.5,     // 물량 싸움
          'defense': 1.0,
          'scout': 0.8,
        };
    }
  }

  /// 매치업별 핵심 능력치 가중치
  static Map<String, double> getMatchupWeights(String matchup) {
    switch (matchup) {
      // TvZ: 견제와 물량이 핵심
      case 'TvZ':
        return {
          'sense': 1.0,
          'control': 1.1,
          'attack': 1.0,
          'harass': 1.4,    // 벌처 견제
          'strategy': 1.2,
          'macro': 1.3,     // 멀티 운영
          'defense': 1.0,
          'scout': 1.2,
        };
      case 'ZvT':
        return {
          'sense': 1.0,
          'control': 1.3,   // 뮤탈 컨트롤
          'attack': 1.0,
          'harass': 1.2,
          'strategy': 1.3,  // 스웜/디파 타이밍
          'macro': 1.4,     // 멀티 확장
          'defense': 1.1,   // 럴커 수비
          'scout': 1.0,
        };

      // TvP: 컨트롤과 전략이 핵심
      case 'TvP':
        return {
          'sense': 1.0,
          'control': 1.4,   // EMP/마린 스플릿
          'attack': 1.1,
          'harass': 1.2,    // 드랍
          'strategy': 1.3,
          'macro': 1.2,     // 멀티 운영 (1.1→1.2: 테란 경제력 반영)
          'defense': 1.3,   // 시즈 탱크 방어 (1.2→1.3: 프로토스 공세 대응)
          'scout': 1.1,
        };
      case 'PvT':
        return {
          'sense': 1.0,
          'control': 1.3,   // 드라군/리버 (1.4→1.3: 테란 마이크로 대응 고려)
          'attack': 1.1,
          'harass': 1.2,    // 리버 드랍 (1.3→1.2: TvP harass와 균형)
          'strategy': 1.3,  // 스톰 타이밍
          'macro': 1.1,
          'defense': 1.1,
          'scout': 1.2,
        };

      // ZvP: 물량과 컨트롤이 핵심
      case 'ZvP':
        return {
          'sense': 1.0,
          'control': 1.3,
          'attack': 1.0,
          'harass': 1.2,    // 뮤탈 견제
          'strategy': 1.2,
          'macro': 1.3,     // 물량 압도 (1.5→1.3: 맵 영향 비대칭 완화)
          'defense': 1.2,   // 럴커 수비
          'scout': 1.0,
        };
      case 'PvZ':
        return {
          'sense': 1.0,
          'control': 1.4,   // 스톰/리버
          'attack': 1.1,
          'harass': 1.3,    // 커세어/리버
          'strategy': 1.4,  // 스톰 타이밍
          'macro': 1.1,
          'defense': 1.2,   // 캐논/포지 방어 (1.0→1.2: P유리맵 보정 강화)
          'scout': 1.1,
        };

      // 동족전: 컨트롤과 센스가 핵심
      case 'TvT':
        return {
          'sense': 1.3,     // 읽기 싸움
          'control': 1.5,   // 탱크 라인
          'attack': 1.1,
          'harass': 1.2,    // 레이스
          'strategy': 1.3,
          'macro': 1.0,
          'defense': 1.0,
          'scout': 1.2,
        };
      case 'ZvZ':
        return {
          'sense': 1.3,     // 빌드 읽기
          'control': 1.5,   // 저글링/뮤탈
          'attack': 1.4,    // 선제 공격
          'harass': 1.0,
          'strategy': 1.0,
          'macro': 1.1,
          'defense': 1.3,   // 선링 방어
          'scout': 1.2,
        };
      case 'PvP':
        return {
          'sense': 1.3,     // 다크 읽기
          'control': 1.5,   // 드라군 마이크로
          'attack': 1.2,
          'harass': 1.0,
          'strategy': 1.3,  // 다크/리버
          'macro': 1.0,
          'defense': 1.1,
          'scout': 1.3,     // 다크 탐지
        };

      default:
        return {
          'sense': 1.0,
          'control': 1.0,
          'attack': 1.0,
          'harass': 1.0,
          'strategy': 1.0,
          'macro': 1.0,
          'defense': 1.0,
          'scout': 1.0,
        };
    }
  }

  /// 단계 + 매치업 복합 가중치 계산
  static double getCombinedWeight(String stat, GamePhase phase, String matchup) {
    final phaseWeights = getPhaseWeights(phase);
    final matchupWeights = getMatchupWeights(matchup);

    final phaseWeight = phaseWeights[stat] ?? 1.0;
    final matchupWeight = matchupWeights[stat] ?? 1.0;

    // 두 가중치의 곱 사용, 0.5~2.0 범위로 제한 (극단적 값 방지)
    return (phaseWeight * matchupWeight).clamp(0.5, 2.0);
  }

  /// 가중치 적용된 능력치 총합 계산
  static double getWeightedTotal({
    required int sense,
    required int control,
    required int attack,
    required int harass,
    required int strategy,
    required int macro,
    required int defense,
    required int scout,
    required GamePhase phase,
    required String matchup,
  }) {
    double total = 0;

    total += sense * getCombinedWeight('sense', phase, matchup);
    total += control * getCombinedWeight('control', phase, matchup);
    total += attack * getCombinedWeight('attack', phase, matchup);
    total += harass * getCombinedWeight('harass', phase, matchup);
    total += strategy * getCombinedWeight('strategy', phase, matchup);
    total += macro * getCombinedWeight('macro', phase, matchup);
    total += defense * getCombinedWeight('defense', phase, matchup);
    total += scout * getCombinedWeight('scout', phase, matchup);

    return total;
  }
}
