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
  tvzBbs('tvz_bbs', 'TvZ', 'BBS', BuildStyle.cheese, ['attack', 'control']),
  tvz2BarAcademy('tvz_2bar_academy', 'TvZ', '2배럭아카데미', BuildStyle.aggressive, ['attack', 'control']),
  tvzBarDouble('tvz_bar_double', 'TvZ', '배럭더블', BuildStyle.balanced, ['macro', 'defense']),
  tvz111('tvz_111', 'TvZ', '111', BuildStyle.balanced, ['strategy', 'control'], 1),
  tvzFacDouble('tvz_fac_double', 'TvZ', '팩토리더블', BuildStyle.balanced, ['harass', 'macro']),
  tvzNobarDouble('tvz_nobar_double', 'TvZ', '노배럭더블', BuildStyle.defensive, ['macro', 'defense']),
  tvz2Star('tvz_2star', 'TvZ', '2스타레이스', BuildStyle.aggressive, ['harass', 'strategy']),
  tvz5Bar('tvz_5bar', 'TvZ', '5배럭', BuildStyle.aggressive, ['attack', 'control']),

  // ==================== TvP 빌드 (12개) ====================
  tvpBbs('tvp_bbs', 'TvP', '센터 8배럭', BuildStyle.cheese, ['attack', 'control']),
  tvpDouble('tvp_double', 'TvP', '팩더블', BuildStyle.balanced, ['macro', 'defense']),
  tvpFakeDouble('tvp_fake_double', 'TvP', '타이밍 러쉬', BuildStyle.aggressive, ['attack', 'strategy']),
  tvp1FactDrop('tvp_1fac_drop', 'TvP', '투팩 찌르기', BuildStyle.aggressive, ['attack', 'control']),
  tvp1FactGosu('tvp_1fac_gosu', 'TvP', '업테란', BuildStyle.defensive, ['defense', 'strategy']),
  tvpBarDouble('tvp_bar_double', 'TvP', '배럭 더블', BuildStyle.defensive, ['macro', 'defense']),
  tvp5FacTiming('tvp_5fac_timing', 'TvP', '5팩 타이밍', BuildStyle.aggressive, ['attack', 'macro']),
  tvpMineTriple('tvp_mine_triple', 'TvP', '마인 트리플', BuildStyle.defensive, ['defense', 'macro']),
  tvpFd('tvp_fd', 'TvP', 'FD테란', BuildStyle.balanced, ['macro', 'strategy']),
  tvp11Up8Fac('tvp_11up_8fac', 'TvP', '11업 8팩', BuildStyle.aggressive, ['attack', 'macro']),
  tvpAntiCarrier('tvp_anti_carrier', 'TvP', '안티 캐리어', BuildStyle.balanced, ['strategy', 'defense']),

  // ==================== TvT 빌드 (9개) ====================
  tvt1Fac1Star('tvt_1fac_1star', 'TvT', '원팩원스타', BuildStyle.aggressive, ['attack', 'control']),
  tvt2Star('tvt_2star', 'TvT', '투스타 레이스', BuildStyle.aggressive, ['harass', 'strategy']),
  tvt1BarDouble('tvt_1bar_double', 'TvT', '원배럭더블', BuildStyle.balanced, ['macro', 'defense']),
  tvtNobarDouble('tvt_nobar_double', 'TvT', '노배럭더블', BuildStyle.defensive, ['macro', 'defense']),
  tvt2FacPush('tvt_2fac_push', 'TvT', '투팩타이밍', BuildStyle.balanced, ['attack', 'control']),
  tvt1FacDouble('tvt_1fac_double', 'TvT', '원팩더블', BuildStyle.defensive, ['macro', 'defense']),
  tvt5Fac('tvt_5fac', 'TvT', '5팩토리', BuildStyle.aggressive, ['attack', 'macro']),
  tvtBBS('tvt_bbs', 'TvT', 'BBS', BuildStyle.cheese, ['attack', 'scout']),
  tvtFdRush('tvt_fd_rush', 'TvT', 'FD 러쉬', BuildStyle.aggressive, ['attack', 'strategy']),

  // ==================== ZvT 빌드 (10개) ====================
  // 기본 빌드 (6개)
  zvt4Pool('zvt_4pool', 'ZvT', '4풀', BuildStyle.cheese, ['attack', 'scout']),
  zvt9Pool('zvt_9pool', 'ZvT', '9풀', BuildStyle.aggressive, ['attack', 'harass']),
  zvt9OverPool('zvt_9overpool', 'ZvT', '9오버풀', BuildStyle.aggressive, ['attack', 'control']),
  zvt12Pool('zvt_12pool', 'ZvT', '12풀', BuildStyle.balanced, ['macro', 'harass']),
  zvt12Hatch('zvt_12hatch', 'ZvT', '12앞', BuildStyle.balanced, ['macro', 'defense']),
  zvt3HatchNoPool('zvt_3hatch_nopool', 'ZvT', '노풀 3해처리', BuildStyle.defensive, ['macro', 'attack']),
  // 특화 빌드 (4개)
  zvt3HatchMutal('zvt_3hatch_mutal', 'ZvT', '미친 저그', BuildStyle.aggressive, ['attack', 'macro']),
  zvt2HatchMutal('zvt_2hatch_mutal', 'ZvT', '투해처리 뮤탈', BuildStyle.aggressive, ['harass', 'control']),
  zvt2HatchLurker('zvt_2hatch_lurker', 'ZvT', '가드라', BuildStyle.defensive, ['macro', 'defense']),
  zvt1HatchAllIn('zvt_1hatch_allin', 'ZvT', '원해처리 럴커', BuildStyle.aggressive, ['attack', 'strategy']),

  // ==================== ZvP 빌드 (13개) ====================
  // 기본 빌드 (6개)
  zvp4Pool('zvp_4pool', 'ZvP', '4풀', BuildStyle.cheese, ['attack', 'scout']),
  zvp9Pool('zvp_9pool', 'ZvP', '9풀', BuildStyle.aggressive, ['attack', 'harass']),
  zvp9OverPool('zvp_9overpool', 'ZvP', '9오버풀', BuildStyle.aggressive, ['attack', 'control']),
  zvp12Pool('zvp_12pool', 'ZvP', '12풀', BuildStyle.balanced, ['macro', 'attack']),
  zvp12Hatch('zvp_12hatch', 'ZvP', '12앞', BuildStyle.balanced, ['macro', 'defense']),
  zvp3HatchNoPool('zvp_3hatch_nopool', 'ZvP', '노풀 3해처리', BuildStyle.defensive, ['macro', 'attack']),
  // 특화 빌드 (7개)
  zvp3HatchHydra('zvp_3hatch_hydra', 'ZvP', '5해처리 히드라', BuildStyle.aggressive, ['macro', 'attack']),
  zvp2HatchMutal('zvp_2hatch_mutal', 'ZvP', '5뮤탈', BuildStyle.balanced, ['harass', 'strategy']),
  zvpScourgeDefiler('zvp_scourge_defiler', 'ZvP', '하이브 운영', BuildStyle.defensive, ['macro', 'strategy']),
  zvp5DroneZergling('zvp_5drone', 'ZvP', '9투 올인', BuildStyle.cheese, ['attack', 'control']),
  zvp973Hydra('zvp_973_hydra', 'ZvP', '973 히드라', BuildStyle.aggressive, ['attack', 'control']),
  zvpMukerji('zvp_mukerji', 'ZvP', '뮤커지', BuildStyle.balanced, ['harass', 'control']),
  zvpYabarwi('zvp_yabarwi', 'ZvP', '야바위', BuildStyle.aggressive, ['strategy', 'attack']),

  // ==================== ZvZ 빌드 (6개) ====================
  zvzPoolFirst('zvz_pool_first', 'ZvZ', '4풀', BuildStyle.cheese, ['attack', 'scout']),
  zvz9Pool('zvz_9pool', 'ZvZ', '9풀', BuildStyle.aggressive, ['attack', 'control']),
  zvz9OverPool('zvz_9overpool', 'ZvZ', '9오버풀', BuildStyle.aggressive, ['attack', 'control']),
  zvz12Pool('zvz_12pool', 'ZvZ', '12풀', BuildStyle.balanced, ['macro', 'strategy']),
  zvz12Hatch('zvz_12hatch', 'ZvZ', '12앞', BuildStyle.balanced, ['macro', 'defense']),
  zvz3HatchNoPool('zvz_3hatch_nopool', 'ZvZ', '노풀 3해처리', BuildStyle.defensive, ['macro', 'defense']),

  // ==================== PvT 빌드 (7개) ====================
  pvtProxyGate('pvt_proxy_gate', 'PvT', '센터 게이트', BuildStyle.cheese, ['attack', 'control']),
  pvt2GateZealot('pvt_2gate_zealot', 'PvT', '선질럿 찌르기', BuildStyle.aggressive, ['attack', 'control']),
  pvtDarkSwing('pvt_dark_swing', 'PvT', '초패스트다크', BuildStyle.aggressive, ['strategy', 'harass']),
  pvt1GateObserver('pvt_1gate_obs', 'PvT', '23넥 아비터', BuildStyle.defensive, ['defense', 'macro']),
  pvtProxyDark('pvt_proxy_dark', 'PvT', '전진로보', BuildStyle.aggressive, ['attack', 'control']),
  pvt1GateExpansion('pvt_1gate_expand', 'PvT', '19넥', BuildStyle.balanced, ['macro', 'defense']),
  pvtCarrier('pvt_carrier', 'PvT', '생넥 캐리어', BuildStyle.defensive, ['macro', 'strategy']),
  pvtReaverShuttle('pvt_reaver_shuttle', 'PvT', '리버 후 속셔템', BuildStyle.balanced, ['harass', 'control']),

  // ==================== PvZ 빌드 (7개) ====================
  pvz2GateZealot('pvz_2gate_zealot', 'PvZ', '전진 2게이트', BuildStyle.aggressive, ['attack', 'control']),
  pvzForgeCannon('pvz_forge_cannon', 'PvZ', '포지더블', BuildStyle.balanced, ['macro', 'defense']),
  pvzCorsairReaver('pvz_corsair_reaver', 'PvZ', '선아둔', BuildStyle.balanced, ['strategy', 'macro']),
  pvzProxyGateway('pvz_proxy_gate', 'PvZ', '센터 게이트', BuildStyle.cheese, ['attack', 'control']),
  pvzCannonRush('pvz_cannon_rush', 'PvZ', '캐논 러쉬', BuildStyle.cheese, ['attack', 'sense']),
  pvz8Gat('pvz_8gat', 'PvZ', '8겟뽕', BuildStyle.cheese, ['attack', 'control']),
  pvz2StarCorsair('pvz_2star_corsair', 'PvZ', '투스타 커세어', BuildStyle.aggressive, ['harass', 'strategy']),

  // ==================== PvP 빌드 (6개) ====================
  pvp2GateDragoon('pvp_2gate_dragoon', 'PvP', '옵3겟', BuildStyle.balanced, ['defense', 'scout']),
  pvpDarkAllIn('pvp_dark_allin', 'PvP', '다크 더블', BuildStyle.cheese, ['strategy', 'harass']),
  pvp1GateRobo('pvp_1gate_robo', 'PvP', '1게이트 리버', BuildStyle.defensive, ['defense', 'strategy']),
  pvpZealotRush('pvp_zealot_rush', 'PvP', '센터99게이트', BuildStyle.cheese, ['attack', 'control']),
  pvp4GateDragoon('pvp_4gate_dragoon', 'PvP', '21 3게이트 드라군', BuildStyle.cheese, ['attack', 'control']),
  pvp1GateMulti('pvp_1gate_multi', 'PvP', '원겟 멀티', BuildStyle.defensive, ['macro', 'defense']),
  pvp2GateReaver('pvp_2gate_reaver', 'PvP', '투겟 리버', BuildStyle.aggressive, ['harass', 'control']),
  pvp3GateSpeedZealot('pvp_3gate_speedzealot', 'PvP', '발업 질럿', BuildStyle.aggressive, ['attack', 'control']),

  // ==================== ZvT 트랜지션 빌드 (6개) ====================
  zvtTransMutalUltra('zvt_trans_mutal_ultra', 'ZvT', '뮤탈→울트라', BuildStyle.aggressive, ['attack', 'macro']),
  zvtTrans2HatchMutal('zvt_trans_2hatch_mutal', 'ZvT', '투해처리 뮤탈', BuildStyle.aggressive, ['harass', 'control']),
  zvtTransLurkerDefiler('zvt_trans_lurker_defiler', 'ZvT', '가드라→디파일러', BuildStyle.defensive, ['macro', 'defense']),
  zvtTrans530Mutal('zvt_trans_530_mutal', 'ZvT', '원해처리 럴커', BuildStyle.aggressive, ['attack', 'strategy']),
  zvtTransMutalLurker('zvt_trans_mutal_lurker', 'ZvT', '뮤탈→럴커', BuildStyle.balanced, ['macro', 'harass']),
  zvtTransUltraHive('zvt_trans_ultra_hive', 'ZvT', '울트라→하이브', BuildStyle.defensive, ['macro', 'attack']),

  // ==================== ZvP 트랜지션 빌드 (7개) ====================
  zvpTrans5HatchHydra('zvp_trans_5hatch_hydra', 'ZvP', '5해처리 히드라', BuildStyle.aggressive, ['macro', 'attack']),
  zvpTransMutalHydra('zvp_trans_mutal_hydra', 'ZvP', '뮤탈→히드라', BuildStyle.balanced, ['harass', 'strategy']),
  zvpTransHiveDefiler('zvp_trans_hive_defiler', 'ZvP', '하이브→디파일러', BuildStyle.defensive, ['macro', 'strategy']),
  zvpTrans973Hydra('zvp_trans_973_hydra', 'ZvP', '973 히드라', BuildStyle.aggressive, ['attack', 'control']),
  zvpTransMukerji('zvp_trans_mukerji', 'ZvP', '뮤커지', BuildStyle.balanced, ['harass', 'control']),
  zvpTransYabarwi('zvp_trans_yabarwi', 'ZvP', '야바위', BuildStyle.aggressive, ['strategy', 'attack']),
  zvpTransHydraLurker('zvp_trans_hydra_lurker', 'ZvP', '히드라→럴커', BuildStyle.balanced, ['macro', 'attack']),

  // TvZ 트랜지션 빌드 (6개)
  tvzTransBionic('tvz_trans_bionic', 'TvZ', '바이오닉', BuildStyle.aggressive, ['attack', 'control']),
  tvzTransMech('tvz_trans_mech', 'TvZ', '메카닉', BuildStyle.defensive, ['defense', 'macro']),
  tvzTrans111Balance('tvz_trans_111_balance', 'TvZ', '111 밸런스', BuildStyle.balanced, ['strategy', 'defense']),
  tvzTransValkyrie('tvz_trans_valkyrie', 'TvZ', '발키리', BuildStyle.defensive, ['defense', 'control']),
  tvzTransWraith('tvz_trans_wraith', 'TvZ', '레이스', BuildStyle.aggressive, ['harass', 'control']),
  tvzTransEnbe3bar('tvz_trans_enbe_3bar', 'TvZ', '선엔베 3배럭', BuildStyle.aggressive, ['attack', 'macro']),

  // TvP 트랜지션 빌드 (6개)
  tvpTransTankDefense('tvp_trans_tank_defense', 'TvP', '탱크 수비', BuildStyle.defensive, ['defense', 'macro']),
  tvpTransTimingPush('tvp_trans_timing_push', 'TvP', '타이밍 푸시', BuildStyle.aggressive, ['attack', 'control']),
  tvpTransUpgrade('tvp_trans_upgrade', 'TvP', '업그레이드 운영', BuildStyle.defensive, ['strategy', 'macro']),
  tvpTransBioMech('tvp_trans_bio_mech', 'TvP', '바이오 메카닉', BuildStyle.defensive, ['defense', 'macro']),
  tvpTrans5FacMass('tvp_trans_5fac_mass', 'TvP', '5팩 물량', BuildStyle.aggressive, ['attack', 'macro']),
  tvpTransAntiCarrier('tvp_trans_anti_carrier', 'TvP', '안티 캐리어', BuildStyle.balanced, ['strategy', 'defense']),

  // PvT 트랜지션 빌드 (6개)
  pvtTrans5GatePush('pvt_trans_5gate_push', 'PvT', '5게이트 푸시', BuildStyle.aggressive, ['attack', 'control']),
  pvtTrans5GateArbiter('pvt_trans_5gate_arbiter', 'PvT', '5게이트 아비터', BuildStyle.balanced, ['strategy', 'attack']),
  pvtTrans5GateCarrier('pvt_trans_5gate_carrier', 'PvT', '5게이트 캐리어', BuildStyle.defensive, ['macro', 'strategy']),
  pvtTransReaverPush('pvt_trans_reaver_push', 'PvT', '셔틀리버 푸시', BuildStyle.aggressive, ['harass', 'control']),
  pvtTransReaverArbiter('pvt_trans_reaver_arbiter', 'PvT', '셔틀리버 아비터', BuildStyle.balanced, ['harass', 'strategy']),
  pvtTransReaverCarrier('pvt_trans_reaver_carrier', 'PvT', '셔틀리버 캐리어', BuildStyle.defensive, ['harass', 'macro']),

  // PvZ 트랜지션 빌드 (4개)
  pvzTransDragoonPush('pvz_trans_dragoon_push', 'PvZ', '드라군 압박', BuildStyle.aggressive, ['attack', 'macro']),
  pvzTransCorsair('pvz_trans_corsair', 'PvZ', '커세어 전환', BuildStyle.aggressive, ['harass', 'strategy']),
  pvzTransArchon('pvz_trans_archon', 'PvZ', '아콘 운영', BuildStyle.balanced, ['strategy', 'attack']),
  pvzTransForgeExpand('pvz_trans_forge_expand', 'PvZ', '포지 확장', BuildStyle.defensive, ['defense', 'macro']);

  final String id;
  final String matchup;
  final String koreanName;
  final BuildStyle parentStyle;
  final List<String> keyStats; // 핵심 능력치 2개
  final int _aggrTier; // -1이면 BuildStyle에서 자동 산출

  const BuildType(this.id, this.matchup, this.koreanName, this.parentStyle, this.keyStats, [this._aggrTier = -1]);

  /// 공격성 등급 (0=치즈, 1=공격적, 2=밸런스, 3=수비적)
  /// 기본값은 BuildStyle에서 자동 산출, 예외(111 등)만 직접 지정
  int get aggressionTier {
    if (_aggrTier >= 0) return _aggrTier;
    switch (parentStyle) {
      case BuildStyle.cheese: return 0;
      case BuildStyle.aggressive: return 1;
      case BuildStyle.balanced: return 2;
      case BuildStyle.defensive: return 3;
    }
  }

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

    // 매치업 키 추론 (TvZ, PvP 등)
    final matchupKey = _resolveMatchupKey(attacker.matchup, defender.matchup);

    // 상위 스타일 기반 기본 상성 (종족전별 차등 적용)
    double baseAdvantage = _getStyleAdvantage(attacker.parentStyle, defender.parentStyle, matchupKey: matchupKey);

    // 세부 빌드별 특수 상성
    baseAdvantage += _getSpecificAdvantage(attacker, defender);

    return baseAdvantage.clamp(-40, 40); // 최대 ±40%
  }

  /// 두 빌드의 매치업 필드로 정규화된 종족전 키 반환
  static String? _resolveMatchupKey(String attackerMatchup, String defenderMatchup) {
    if (attackerMatchup == defenderMatchup) return attackerMatchup; // 미러 (TvT, ZvZ, PvP)
    final pair = {attackerMatchup, defenderMatchup};
    if (pair.contains('TvZ') && pair.contains('ZvT')) return 'TvZ';
    if (pair.contains('TvP') && pair.contains('PvT')) return 'TvP';
    if (pair.contains('ZvP') && pair.contains('PvZ')) return 'ZvP';
    return null;
  }

  /// 상위 스타일 간 기본 상성 (반대칭: f(A,B) = -f(B,A))
  /// matchupKey로 종족전별 차등 적용
  static double _getStyleAdvantage(BuildStyle a, BuildStyle b, {String? matchupKey}) {
    if (a == b) return 0;

    // TvZ 전용 스타일 상성 (C14 홈/어웨이 대칭 보정)
    if (matchupKey == 'TvZ') {
      return _getTvZStyleAdvantage(a, b);
    }

    // 기본 상성 (TvZ 이외 모든 종족전)
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

  /// TvZ 전용 스타일 상성 (defensive > aggressive를 +6으로 축소)
  static double _getTvZStyleAdvantage(BuildStyle a, BuildStyle b) {
    if (a == b) return 0;

    if (a == BuildStyle.cheese && b == BuildStyle.defensive) return 25;
    if (a == BuildStyle.defensive && b == BuildStyle.cheese) return -25;

    if (a == BuildStyle.aggressive && b == BuildStyle.balanced) return 10;
    if (a == BuildStyle.balanced && b == BuildStyle.aggressive) return -10;

    // TvZ에서 defensive > aggressive를 +12 → +4로 축소
    if (a == BuildStyle.defensive && b == BuildStyle.aggressive) return 4;
    if (a == BuildStyle.aggressive && b == BuildStyle.defensive) return -4;

    if (a == BuildStyle.aggressive && b == BuildStyle.cheese) return 5;
    if (a == BuildStyle.cheese && b == BuildStyle.aggressive) return -5;

    if (a == BuildStyle.cheese && b == BuildStyle.balanced) return 10;
    if (a == BuildStyle.balanced && b == BuildStyle.cheese) return -10;

    return 0;
  }

  /// 세부 빌드 특수 상성 (반대칭: f(A,B) = -f(B,A))
  static double _getSpecificAdvantage(BuildType a, BuildType b) {
    // ZvZ 특수 상성 (10쌍)
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz12Hatch) return 9;    // 4풀 > 12앞마당 (20→9: 수비 성공 시 12앞 유리)
    if (a == BuildType.zvz12Hatch && b == BuildType.zvzPoolFirst) return -9;
    if (a == BuildType.zvz9Pool && b == BuildType.zvz12Hatch) return 2;        // 9풀 > 12앞마당 (경제력 회복 가능)
    if (a == BuildType.zvz12Hatch && b == BuildType.zvz9Pool) return -2;
    if (a == BuildType.zvz9Pool && b == BuildType.zvzPoolFirst) return 8;      // 9풀 > 4풀
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz9Pool) return -8;
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz3HatchNoPool) return 25; // 4풀 > 노풀 3해처리 (극상성)
    if (a == BuildType.zvz3HatchNoPool && b == BuildType.zvzPoolFirst) return -25;
    if (a == BuildType.zvz9Pool && b == BuildType.zvz3HatchNoPool) return 18;    // 9풀 > 노풀 3해처리
    if (a == BuildType.zvz3HatchNoPool && b == BuildType.zvz9Pool) return -18;
    if (a == BuildType.zvz12Hatch && b == BuildType.zvz12Pool) return 3;       // 12앞 ≈ 12풀 (미세 우위)
    if (a == BuildType.zvz12Pool && b == BuildType.zvz12Hatch) return -3;
    if (a == BuildType.zvz9Pool && b == BuildType.zvz12Pool) return -5;        // 12풀 > 9풀 (드론 3개 경제 우위, 9풀 피해 못 주면 불리)
    if (a == BuildType.zvz12Pool && b == BuildType.zvz9Pool) return 5;
    if (a == BuildType.zvz3HatchNoPool && b == BuildType.zvz12Hatch) return 5; // 노풀 3해처리 > 12앞 (후반 경제력)
    if (a == BuildType.zvz12Hatch && b == BuildType.zvz3HatchNoPool) return -5;
    if (a == BuildType.zvz3HatchNoPool && b == BuildType.zvz12Pool) return 8;  // 노풀 3해처리 > 12풀 (경제력 격차)
    if (a == BuildType.zvz12Pool && b == BuildType.zvz3HatchNoPool) return -8;
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz12Pool) return 12;    // 4풀 > 12풀
    if (a == BuildType.zvz12Pool && b == BuildType.zvzPoolFirst) return -12;
    // 9오버풀 상성
    if (a == BuildType.zvz9OverPool && b == BuildType.zvz12Hatch) return 12;  // 9오버풀 > 12앞
    if (a == BuildType.zvz12Hatch && b == BuildType.zvz9OverPool) return -12;
    if (a == BuildType.zvz9OverPool && b == BuildType.zvz12Pool) return -3;   // 12풀 > 9오버풀 (경제 우위)
    if (a == BuildType.zvz12Pool && b == BuildType.zvz9OverPool) return 3;
    if (a == BuildType.zvz9OverPool && b == BuildType.zvz3HatchNoPool) return 15; // 9오버풀 > 노풀 3해처리
    if (a == BuildType.zvz3HatchNoPool && b == BuildType.zvz9OverPool) return -15;
    if (a == BuildType.zvz9OverPool && b == BuildType.zvz9Pool) return 3;     // 9오버풀 > 9풀 (드론 하나 많은 장점)
    if (a == BuildType.zvz9Pool && b == BuildType.zvz9OverPool) return -3;
    if (a == BuildType.zvzPoolFirst && b == BuildType.zvz9OverPool) return -5; // 9오버풀 > 4풀 (서플 관리)
    if (a == BuildType.zvz9OverPool && b == BuildType.zvzPoolFirst) return 5;

    // TvZ/ZvT 특수 상성
    if (a == BuildType.tvzBbs && b == BuildType.zvt1HatchAllIn) return 15;  // BBS > 원해처리 럴커 (초반 마린으로 히드라/럴커 전 압살)
    if (a == BuildType.zvt1HatchAllIn && b == BuildType.tvzBbs) return -15;
    if (a == BuildType.tvzTransEnbe3bar && b == BuildType.zvt3HatchMutal) return 12;    // 선엔베 > 미친저그
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvzTransEnbe3bar) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt3HatchMutal) return 12;         // 111 탱크가 3해처리 느린 방어 타이밍 노림
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvz111) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt2HatchMutal) return 8;          // 레이스 정찰로 뮤탈 타이밍 파악
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvz111) return -8;
    if (a == BuildType.tvz111 && b == BuildType.zvt2HatchLurker) return 12;        // 111 > 가드라
    if (a == BuildType.zvt2HatchLurker && b == BuildType.tvz111) return -12;
    if (a == BuildType.tvz111 && b == BuildType.zvt1HatchAllIn) return 8;          // 빠른 탱크로 럴커 올인 버팀
    if (a == BuildType.zvt1HatchAllIn && b == BuildType.tvz111) return -8;
    if (a == BuildType.tvzTransValkyrie && b == BuildType.zvt2HatchMutal) return 23;    // 발키리 > 뮤탈: +4(def>agg TvZ) + 23 = +27
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvzTransValkyrie) return -23;
    if (a == BuildType.tvz2Star && b == BuildType.zvt2HatchLurker) return 4; // 레이스 > 지상저그: -4(agg>def TvZ) + 4 = 0
    if (a == BuildType.zvt2HatchLurker && b == BuildType.tvz2Star) return -4;

    // TvZ/ZvT 추가 상성
    // BBS가 12앞마당을 직접 노림 (벙커가 앞마당에 빠르게 올라감)
    if (a == BuildType.tvzBbs && b == BuildType.zvt12Hatch) return 8;           // +10(cheese>bal) + 8 = +18
    if (a == BuildType.zvt12Hatch && b == BuildType.tvzBbs) return -8;
    // BBS vs 노풀3해처리 (저글링도 없어서 벙커 방어 불가)
    if (a == BuildType.tvzBbs && b == BuildType.zvt3HatchNoPool) return 10;     // +25(cheese>def) + 10 = +35
    if (a == BuildType.zvt3HatchNoPool && b == BuildType.tvzBbs) return -10;
    // 9풀 발업저글링이 수비형 테란에 강함 (마린 나오기 전 저글링 도착, GG 多)
    if (a == BuildType.zvt9Pool && b == BuildType.tvzTransMech) return 14;      // -4(def>agg TvZ) + 14 = +10
    if (a == BuildType.tvzTransMech && b == BuildType.zvt9Pool) return -14;
    if (a == BuildType.zvt9Pool && b == BuildType.tvzTransValkyrie) return 14;         // -4 + 14 = +10
    if (a == BuildType.tvzTransValkyrie && b == BuildType.zvt9Pool) return -14;
    // 9오버풀도 비슷하지만 오버로드 먼저 뽑아서 약간 느림
    if (a == BuildType.zvt9OverPool && b == BuildType.tvzTransMech) return 10;  // -4 + 10 = +6
    if (a == BuildType.tvzTransMech && b == BuildType.zvt9OverPool) return -10;
    if (a == BuildType.zvt9OverPool && b == BuildType.tvzTransValkyrie) return 10;     // -4 + 10 = +6
    if (a == BuildType.tvzTransValkyrie && b == BuildType.zvt9OverPool) return -10;
    // 공격 테란 vs 노풀3해처리 (군사 전혀 없는 저그를 공략)
    if (a == BuildType.tvzTransEnbe3bar && b == BuildType.zvt3HatchNoPool) return 17;       // -4(def>agg TvZ) + 17 = +13
    if (a == BuildType.zvt3HatchNoPool && b == BuildType.tvzTransEnbe3bar) return -17;
    if (a == BuildType.tvz2BarAcademy && b == BuildType.zvt3HatchNoPool) return 17;       // -4 + 17 = +13
    if (a == BuildType.zvt3HatchNoPool && b == BuildType.tvz2BarAcademy) return -17;
    // 발키리가 3해처리 뮤탈도 카운터 (대공 진형)
    if (a == BuildType.tvzTransValkyrie && b == BuildType.zvt3HatchMutal) return 20;        // +4(def>agg TvZ) + 20 = +24
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvzTransValkyrie) return -20;
    // 2스타 레이스가 뮤탈 빌드에 강함 (공중 장악 + 오버로드 사냥)
    if (a == BuildType.tvz2Star && b == BuildType.zvt2HatchMutal) return 8;      // 0(agg=agg) + 8 = +8
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvz2Star) return -8;
    if (a == BuildType.tvz2Star && b == BuildType.zvt3HatchMutal) return 10;     // 0 + 10 = +10
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvz2Star) return -10;
    // 노배럭더블이 원해처리 럴커에 강함 (빠른 확장 + 탱크로 럴커 전 포격)
    if (a == BuildType.tvzNobarDouble && b == BuildType.zvt1HatchAllIn) return 18; // +4(def>agg TvZ) + 18 = +22
    if (a == BuildType.zvt1HatchAllIn && b == BuildType.tvzNobarDouble) return -18;
    // 5배럭 vs 노풀3해처리 (순수 마린 물량으로 군사 없는 저그 압살)
    if (a == BuildType.tvz5Bar && b == BuildType.zvt3HatchNoPool) return 17;           // -4(def>agg TvZ) + 17 = +13
    if (a == BuildType.zvt3HatchNoPool && b == BuildType.tvz5Bar) return -17;
    // 5배럭 vs 미친저그 (마린 물량이 3해처리 느린 방어 타이밍 공략)
    if (a == BuildType.tvz5Bar && b == BuildType.zvt3HatchMutal) return 10;            // 0(agg=agg) + 10 = +10
    if (a == BuildType.zvt3HatchMutal && b == BuildType.tvz5Bar) return -10;
    // 5배럭 vs 2해처리 뮤탈 (터렛 없어서 뮤탈에 약함)
    if (a == BuildType.tvz5Bar && b == BuildType.zvt2HatchMutal) return -8;            // 0(agg=agg) - 8 = -8
    if (a == BuildType.zvt2HatchMutal && b == BuildType.tvz5Bar) return 8;

    // TvT 특수 상성 (15쌍)
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvt1BarDouble) return 15;       // 원팩원스타 > 원배럭더블
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvt1Fac1Star) return -15;
    if (a == BuildType.tvt2Star && b == BuildType.tvt1BarDouble) return -8;     // 투스타레이스 vs 원배럭더블 (aggressive+10과 합산 총 +2, C14 대칭 유지)
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvt2Star) return 8;
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvt2Star) return 2;    // 원팩원스타 > 투스타레이스 (C14 대칭 유지)
    if (a == BuildType.tvt2Star && b == BuildType.tvt1Fac1Star) return -2;
    if (a == BuildType.tvt2FacPush && b == BuildType.tvt1FacDouble) return 10; // 투팩타이밍 > 원팩더블
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvt2FacPush) return -10;
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvt2FacPush) return 0;     // 원배럭더블 ≈ 투팩타이밍 (C14 대칭 유지)
    if (a == BuildType.tvt2FacPush && b == BuildType.tvt1BarDouble) return 0;
    if (a == BuildType.tvt2Star && b == BuildType.tvt2FacPush) return 10; // 투스타레이스 > 투팩타이밍
    if (a == BuildType.tvt2FacPush && b == BuildType.tvt2Star) return -10;
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvt2Star) return 8;  // 원팩더블 > 투스타레이스
    if (a == BuildType.tvt2Star && b == BuildType.tvt1FacDouble) return -8;
    if (a == BuildType.tvt5Fac && b == BuildType.tvt1BarDouble) return 10;            // 5팩토리 > 원배럭더블
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvt5Fac) return -10;
    if (a == BuildType.tvt5Fac && b == BuildType.tvt1FacDouble) return 8;         // 5팩토리 > 원팩더블
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvt5Fac) return -8;
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvt1FacDouble) return 5;    // 원팩원스타 > 원팩더블
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvt1Fac1Star) return -5;
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvt2FacPush) return 3;   // 원팩원스타 > 투팩타이밍
    if (a == BuildType.tvt2FacPush && b == BuildType.tvt1Fac1Star) return -3;
    if (a == BuildType.tvt5Fac && b == BuildType.tvt2Star) return 5;         // 5팩토리 > 투스타레이스
    if (a == BuildType.tvt2Star && b == BuildType.tvt5Fac) return -5;
    if (a == BuildType.tvt2FacPush && b == BuildType.tvt5Fac) return 5;        // 투팩타이밍 > 5팩토리
    if (a == BuildType.tvt5Fac && b == BuildType.tvt2FacPush) return -5;
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvt5Fac) return 3;           // 원팩원스타 > 5팩토리
    if (a == BuildType.tvt5Fac && b == BuildType.tvt1Fac1Star) return -3;
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvt1BarDouble) return 5;      // 원팩더블 > 원배럭더블
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvt1FacDouble) return -5;
    // BBS 상성 (7쌍)
    if (a == BuildType.tvtBBS && b == BuildType.tvt1BarDouble) return -8;            // BBS > 원배럭더블 (cheese+10과 합산 총 +2, C14 대칭 유지)
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvtBBS) return 8;
    if (a == BuildType.tvtBBS && b == BuildType.tvt1FacDouble) return 15;        // BBS > 원팩더블 (확장 타이밍 공격)
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvtBBS) return -15;
    if (a == BuildType.tvtBBS && b == BuildType.tvt2FacPush) return -8;       // BBS > 투팩타이밍 (cheese+10과 합산 총 +2, C14 대칭 유지)
    if (a == BuildType.tvt2FacPush && b == BuildType.tvtBBS) return 8;
    if (a == BuildType.tvtBBS && b == BuildType.tvt5Fac) return 8;               // BBS > 5팩토리 (팩토리 올라가기 전 공격)
    if (a == BuildType.tvt5Fac && b == BuildType.tvtBBS) return -8;
    if (a == BuildType.tvtBBS && b == BuildType.tvt2Star) return 5;         // BBS > 투스타레이스 (레이스 나오기 전 공격)
    if (a == BuildType.tvt2Star && b == BuildType.tvtBBS) return -5;
    if (a == BuildType.tvtBBS && b == BuildType.tvt1Fac1Star) return 3;           // BBS > 원팩원스타 (둘 다 공격적, BBS 약간 빠름)
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvtBBS) return -3;
    // 노배럭더블 상성 (7쌍) - 원배럭더블보다 더 그리디, 러쉬에 취약하지만 장기전 강함
    if (a == BuildType.tvtBBS && b == BuildType.tvtNobarDouble) return 5;            // BBS > 노배럭더블 (cheese+10 합산 +15, 배럭 없어 초반 극취약)
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvtBBS) return -5;
    if (a == BuildType.tvt1Fac1Star && b == BuildType.tvtNobarDouble) return 18;     // 원팩원스타 > 노배럭더블 (빠른 푸시에 배럭 없어 대응 불가)
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt1Fac1Star) return -18;
    if (a == BuildType.tvt2Star && b == BuildType.tvtNobarDouble) return 5;          // 투스타레이스 > 노배럭더블 (레이스 견제에 터렛 늦음)
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt2Star) return -5;
    if (a == BuildType.tvt2FacPush && b == BuildType.tvtNobarDouble) return 12;      // 투팩타이밍 > 노배럭더블 (벌처 러쉬에 마린 없음)
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt2FacPush) return -12;
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt1FacDouble) return 8;     // 노배럭더블 > 원팩더블 (더블 자원 먼저 가동)
    if (a == BuildType.tvt1FacDouble && b == BuildType.tvtNobarDouble) return -8;
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt1BarDouble) return 5;     // 노배럭더블 > 원배럭더블 (자원 가동 빠름)
    if (a == BuildType.tvt1BarDouble && b == BuildType.tvtNobarDouble) return -5;
    if (a == BuildType.tvt5Fac && b == BuildType.tvtNobarDouble) return 12;          // 5팩토리 > 노배럭더블 (타이밍 공격에 방어 힘듦)
    if (a == BuildType.tvtNobarDouble && b == BuildType.tvt5Fac) return -12;

    // TvP/PvT 특수 상성
    if (a == BuildType.tvpFakeDouble && b == BuildType.pvt1GateObserver) return -10; // 타이밍러쉬 < 23넥아비터
    if (a == BuildType.pvt1GateObserver && b == BuildType.tvpFakeDouble) return 10;
    if (a == BuildType.tvp5FacTiming && b == BuildType.pvt1GateExpansion) return 12; // 5팩타이밍 > 19넥
    if (a == BuildType.pvt1GateExpansion && b == BuildType.tvp5FacTiming) return -12;
    if (a == BuildType.tvp11Up8Fac && b == BuildType.pvt1GateObserver) return 10;    // 11업8팩 > 느린아비터
    if (a == BuildType.pvt1GateObserver && b == BuildType.tvp11Up8Fac) return -10;
    if (a == BuildType.tvpAntiCarrier && b == BuildType.pvtCarrier) return 12;       // 안티캐리어 특화 (25→12: 캐리어 인터셉터 물량 대응 가능)
    if (a == BuildType.pvtCarrier && b == BuildType.tvpAntiCarrier) return -12;

    // PvT/TvP 특수 상성
    if (a == BuildType.tvpBbs && b == BuildType.pvt1GateExpansion) return 20;  // BBS > 19넥
    if (a == BuildType.pvt1GateExpansion && b == BuildType.tvpBbs) return -20;
    if (a == BuildType.pvt2GateZealot && b == BuildType.tvpBbs) return 15;     // 선질럿 > BBS
    if (a == BuildType.tvpBbs && b == BuildType.pvt2GateZealot) return -15;
    if (a == BuildType.pvtDarkSwing && b == BuildType.tvpDouble) return -10;   // 다크드랍 > 팩더블 (스타일 보정: agg>bal=+10, 합계=0)
    if (a == BuildType.tvpDouble && b == BuildType.pvtDarkSwing) return 10;
    if (a == BuildType.pvt2GateZealot && b == BuildType.tvpDouble) return -7;  // 선질럿 > 팩더블 (스타일 보정: agg>bal=+10, 합계≈3)
    if (a == BuildType.tvpDouble && b == BuildType.pvt2GateZealot) return 7;
    if (a == BuildType.pvtProxyDark && b == BuildType.tvpBarDouble) return 12;  // 전진로보 > 배럭더블
    if (a == BuildType.tvpBarDouble && b == BuildType.pvtProxyDark) return -12;
    if (a == BuildType.pvtCarrier && b == BuildType.tvpFakeDouble) return -10;  // 캐리어 < 타이밍
    if (a == BuildType.tvpFakeDouble && b == BuildType.pvtCarrier) return 10;
    if (a == BuildType.pvtReaverShuttle && b == BuildType.tvpDouble) return 10; // 리버속셔템 > 팩더블
    if (a == BuildType.tvpDouble && b == BuildType.pvtReaverShuttle) return -10;
    if (a == BuildType.pvtProxyGate && b == BuildType.tvpDouble) return 5;    // 센터게이트 > 팩더블 (30→5: 정찰 시 치즈 실패 리스크 반영)
    if (a == BuildType.tvpDouble && b == BuildType.pvtProxyGate) return -5;
    if (a == BuildType.pvtProxyGate && b == BuildType.tvpBbs) return -5;      // 센터게이트 < BBS (치즈 대 치즈, 마린 유리)
    if (a == BuildType.tvpBbs && b == BuildType.pvtProxyGate) return 5;
    if (a == BuildType.pvtProxyGate && b == BuildType.tvpBarDouble) return 15; // 센터게이트 > 배럭더블 (치즈>수비)
    if (a == BuildType.tvpBarDouble && b == BuildType.pvtProxyGate) return -15;

    // PvZ/ZvP 특수 상성
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp5DroneZergling) return 15; // 포지더블 > 9투올인 (스타일 보정: bal>cheese=-10, 합계≈5)
    if (a == BuildType.zvp5DroneZergling && b == BuildType.pvzForgeCannon) return -15;
    if (a == BuildType.pvzCannonRush && b == BuildType.zvpScourgeDefiler) return 20;  // 캐논러쉬 > 하이브운영
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvzCannonRush) return -20;
    if (a == BuildType.pvz8Gat && b == BuildType.zvpScourgeDefiler) return 18;        // 8겟뽕 > 하이브운영
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvz8Gat) return -18;
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvp3HatchHydra) return 10;   // 커세어 > 히드라
    if (a == BuildType.zvp3HatchHydra && b == BuildType.pvz2StarCorsair) return -10;

    // ZvP/PvZ 특수 상성
    if (a == BuildType.zvp3HatchHydra && b == BuildType.pvzForgeCannon) return -10;   // 5해히드라 > 포지더블 (스타일 보정: agg>bal=+10, 합계=0)
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp3HatchHydra) return 10;
    if (a == BuildType.zvp973Hydra && b == BuildType.pvzForgeCannon) return -20;      // 973히드라 < 포지더블 (스타일 보정: agg>bal=+10, 합계≈-10)
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp973Hydra) return 20;
    if (a == BuildType.zvp973Hydra && b == BuildType.pvzCorsairReaver) return 15;     // 973히드라 > 선아둔
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvp973Hydra) return -15;
    if (a == BuildType.zvpMukerji && b == BuildType.pvzForgeCannon) return 8;         // 뮤커지 > 포지더블
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvpMukerji) return -8;
    if (a == BuildType.zvpYabarwi && b == BuildType.pvzCorsairReaver) return 12;      // 야바위 > 선아둔
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvpYabarwi) return -12;
    if (a == BuildType.zvp2HatchMutal && b == BuildType.pvzForgeCannon) return 12;   // 5뮤탈 > 포지더블
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvp2HatchMutal) return -12;
    if (a == BuildType.zvp2HatchMutal && b == BuildType.pvzCannonRush) return 8;     // 5뮤탈 > 캐논러쉬 (2해치 생존 후 뮤탈)
    if (a == BuildType.pvzCannonRush && b == BuildType.zvp2HatchMutal) return -8;
    if (a == BuildType.zvp2HatchMutal && b == BuildType.pvz2StarCorsair) return 15;  // 5뮤탈 > 투스타커세어 (뮤탈 견제)
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvp2HatchMutal) return -15;
    if (a == BuildType.zvp2HatchMutal && b == BuildType.pvz2GateZealot) return 20;   // 5뮤탈 > 파워드라군 (뮤탈 견제)
    if (a == BuildType.pvz2GateZealot && b == BuildType.zvp2HatchMutal) return -20;
    if (a == BuildType.zvp2HatchMutal && b == BuildType.pvzCorsairReaver) return 15; // 5뮤탈 > 선아둔 (뮤탈 harass)
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvp2HatchMutal) return -15;
    if (a == BuildType.zvpMukerji && b == BuildType.pvzCorsairReaver) return 10;     // 뮤커지 > 선아둔
    if (a == BuildType.pvzCorsairReaver && b == BuildType.zvpMukerji) return -10;
    if (a == BuildType.zvpMukerji && b == BuildType.pvz2GateZealot) return 25;       // 뮤커지 > 파워드라군 (디파일러 스웜)
    if (a == BuildType.pvz2GateZealot && b == BuildType.zvpMukerji) return -25;
    if (a == BuildType.zvpMukerji && b == BuildType.pvz2StarCorsair) return 22;      // 뮤커지 > 투스타커세어 (스커지>커세어)
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvpMukerji) return -22;
    if (a == BuildType.zvpMukerji && b == BuildType.pvz8Gat) return 5;               // 뮤커지 > 8겟뽕 (디파일러로 치즈 대응)
    if (a == BuildType.pvz8Gat && b == BuildType.zvpMukerji) return -5;
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvz2GateZealot) return 5;  // 하이브운영 > 파워드라군
    if (a == BuildType.pvz2GateZealot && b == BuildType.zvpScourgeDefiler) return -5;
    if (a == BuildType.zvpScourgeDefiler && b == BuildType.pvz2StarCorsair) return 8;  // 하이브운영 > 투스타커세어 (스커지>커세어)
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvpScourgeDefiler) return -8;
    if (a == BuildType.zvp5DroneZergling && b == BuildType.pvz2GateZealot) return 8;  // 9투올인 > 파워드라군 (러시 도착 전)
    if (a == BuildType.pvz2GateZealot && b == BuildType.zvp5DroneZergling) return -8;
    if (a == BuildType.zvp5DroneZergling && b == BuildType.pvz2StarCorsair) return 5;  // 9투올인 > 투스타커세어 (러시 도착 전)
    if (a == BuildType.pvz2StarCorsair && b == BuildType.zvp5DroneZergling) return -5;
    if (a == BuildType.zvp3HatchHydra && b == BuildType.pvz2GateZealot) return 5;    // 5해히드라 > 파워드라군
    if (a == BuildType.pvz2GateZealot && b == BuildType.zvp3HatchHydra) return -5;
    if (a == BuildType.zvpYabarwi && b == BuildType.pvzForgeCannon) return -5;       // 야바위 > 포지더블 (스타일 보정: agg>bal=+10, 합계≈5)
    if (a == BuildType.pvzForgeCannon && b == BuildType.zvpYabarwi) return 5;

    // PvP 특수 상성 (28쌍)
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp2GateDragoon) return 5;      // 다크더블 > 옵3겟 (8→5: 70%초과 보정)
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvpDarkAllIn) return -5;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp1GateMulti) return 0;     // 3겟드라군 > 원겟멀티 (스타일 +25로 충분)
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp4GateDragoon) return 0;
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp1GateMulti) return 15;      // 센터99겟 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvpZealotRush) return -15;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvpDarkAllIn) return 20;        // 기어리버 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp1GateRobo) return -20;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvp2GateDragoon) return 5;      // 기어리버 > 옵3겟
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvp1GateRobo) return -5;
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvpZealotRush) return 12;    // 옵3겟 > 센터99겟
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp2GateDragoon) return -12;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp2GateDragoon) return 5;   // 3겟드라 > 옵3겟
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvp4GateDragoon) return -5;
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvp1GateMulti) return 10;    // 옵3겟 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp2GateDragoon) return -10;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvp2GateDragoon) return 3;    // 투겟리버 > 옵3겟
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvp2GateReaver) return -3;
    if (a == BuildType.pvp2GateDragoon && b == BuildType.pvp3GateSpeedZealot) return 10; // 옵3겟 > 발업질
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvp2GateDragoon) return -10;
    if (a == BuildType.pvpZealotRush && b == BuildType.pvpDarkAllIn) return 5;        // 센터99겟 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvpZealotRush) return -5;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvpDarkAllIn) return 8;      // 3겟드라 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp4GateDragoon) return -8;
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp1GateMulti) return 5;        // 다크더블 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvpDarkAllIn) return -5;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvpDarkAllIn) return 12;      // 투겟리버 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp2GateReaver) return -12;
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvpDarkAllIn) return 3;  // 발업질 > 다크더블
    if (a == BuildType.pvpDarkAllIn && b == BuildType.pvp3GateSpeedZealot) return -3;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvpZealotRush) return 15;       // 기어리버 > 센터99겟
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp1GateRobo) return -15;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvp4GateDragoon) return 10;     // 기어리버 > 3겟드라
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp1GateRobo) return -10;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvp1GateMulti) return 3;        // 기어리버 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp1GateRobo) return -3;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvp1GateRobo) return 5;       // 투겟리버 > 기어리버
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvp2GateReaver) return -5;
    if (a == BuildType.pvp1GateRobo && b == BuildType.pvp3GateSpeedZealot) return 5;  // 기어리버 > 발업질
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvp1GateRobo) return -5;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvpZealotRush) return 8;     // 3겟드라 > 센터99겟
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp4GateDragoon) return -8;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvpZealotRush) return 8;      // 투겟리버 > 센터99겟
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp2GateReaver) return -8;
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvpZealotRush) return 5; // 발업질 > 센터99겟
    if (a == BuildType.pvpZealotRush && b == BuildType.pvp3GateSpeedZealot) return -5;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp2GateReaver) return 10;   // 3겟드라 > 투겟리버
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvp4GateDragoon) return -10;
    if (a == BuildType.pvp4GateDragoon && b == BuildType.pvp3GateSpeedZealot) return 8; // 3겟드라 > 발업질
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvp4GateDragoon) return -8;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvp1GateMulti) return 5;      // 투겟리버 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp2GateReaver) return -5;
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvp1GateMulti) return 3; // 발업질 > 원겟멀티
    if (a == BuildType.pvp1GateMulti && b == BuildType.pvp3GateSpeedZealot) return -3;
    if (a == BuildType.pvp2GateReaver && b == BuildType.pvp3GateSpeedZealot) return 8; // 투겟리버 > 발업질
    if (a == BuildType.pvp3GateSpeedZealot && b == BuildType.pvp2GateReaver) return -8;

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
          'control': 1.3,   // 드라군/리버 (1.4→1.3: 테란 컨트롤 대응 고려)
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
          'control': 1.5,   // 드라군 컨트롤
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
