import '../../domain/models/models.dart';

/// 마이스타크래프트 1.29.01 버전 (2012년 10월) 기준 초기 게임 데이터
/// 8개 팀: KT 롤스터, 삼성전자 칸, STX SouL, SK텔레콤 T1, 웅진 스타즈, CJ 엔투스, 공군 ACE, 제8게임단
class InitialData {
  /// 모든 팀 생성
  static List<Team> createTeams() {
    return [
      _createKtRolster(),
      _createSamsungKhan(),
      _createStxSoul(),
      _createSktT1(),
      _createWoongjinStars(),
      _createCjEntus(),
      _createAirforceAce(),
      _createTeam8(),
    ];
  }

  /// 모든 선수 생성
  static List<Player> createPlayers() {
    return [
      ..._createKtRolsterPlayers(),
      ..._createSamsungKhanPlayers(),
      ..._createStxSoulPlayers(),
      ..._createSktT1Players(),
      ..._createWoongjinStarsPlayers(),
      ..._createCjEntusPlayers(),
      ..._createAirforceAcePlayers(),
      ..._createTeam8Players(),
    ];
  }

  /// 무소속 선수 풀 생성
  /// 1.29.01 버전 기준 무소속/은퇴 프로게이머
  /// 능력치 최대 A등급 (합계 4799 이하)
  static List<Player> createFreeAgentPool() {
    return [
      // ===== 레전드 프로게이머 (은퇴/무소속) - A등급 =====
      Player(
        id: 'free_nada',
        name: '이윤열',
        nickname: 'NaDa',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 600, control: 620, attack: 600, harass: 580,
          strategy: 620, macro: 600, defense: 560, scout: 570,
        ), // 합계: 4750 (A+)
        levelValue: 10, // 은퇴
      ),
      Player(
        id: 'free_boxer',
        name: '임요환',
        nickname: 'BoxeR',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 600,
          strategy: 620, macro: 560, defense: 520, scout: 560,
        ), // 합계: 4600 (A+)
        levelValue: 10, // 은퇴
      ),
      Player(
        id: 'free_iloveoov',
        name: '최인규',
        nickname: 'iloveoov',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 560, control: 580, attack: 570, harass: 540,
          strategy: 570, macro: 580, defense: 560, scout: 540,
        ), // 합계: 4500 (A+)
        levelValue: 10, // 은퇴
      ),
      Player(
        id: 'free_yellow',
        name: '홍진호',
        nickname: 'YellOw',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 620,
          strategy: 560, macro: 620, defense: 540, scout: 520,
        ), // 합계: 4600 (A+)
        levelValue: 10, // 은퇴
      ),
      Player(
        id: 'free_nalra',
        name: '강민',
        nickname: 'Nal_rA',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 520, control: 540, attack: 530, harass: 510,
          strategy: 580, macro: 530, defense: 490, scout: 500,
        ), // 합계: 4200 (A)
        levelValue: 10, // 은퇴
      ),
      Player(
        id: 'free_reach',
        name: '박정석',
        nickname: 'Reach',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 470, control: 490, attack: 480, harass: 460,
          strategy: 500, macro: 480, defense: 460, scout: 460,
        ), // 합계: 3800 (A-)
        levelValue: 10, // 은퇴
      ),
      // ===== 해체된 팀 출신 =====
      // 이제동은 제8게임단 소속 (t8_jaedong)으로 중복 제거
      Player(
        id: 'free_luxury',
        name: '구성훈',
        nickname: 'Luxury',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 540, control: 580, attack: 600, harass: 520,
          strategy: 560, macro: 540, defense: 520, scout: 500,
        ), // 합계: 4360 (A)
        levelValue: 7,
      ),
      Player(
        id: 'free_kal',
        name: '박세정',
        nickname: 'Kal',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 520, control: 540, attack: 530, harass: 500,
          strategy: 560, macro: 530, defense: 510, scout: 510,
        ), // 합계: 4200 (A)
        levelValue: 7, // 위메이드 폭스 해체 후
      ),
      // 이영한(Shine)은 삼성전자 칸 소속 (ssg_shine)으로 중복 제거
      // ===== 신인/아마추어 =====
      // 김성운은 웅진 스타즈 소속 (wjs_kimseongwoon)으로 중복 제거
      Player(
        id: 'free_amateur2',
        name: '이준혁',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 400, control: 460, attack: 480, harass: 380,
          strategy: 420, macro: 400, defense: 380, scout: 360,
        ), // 합계: 3280 (B+)
        levelValue: 1,
      ),
      Player(
        id: 'free_amateur3',
        name: '박민규',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 380, control: 440, attack: 420, harass: 380,
          strategy: 460, macro: 420, defense: 380, scout: 420,
        ), // 합계: 3300 (B+)
        levelValue: 1,
      ),
      Player(
        id: 'free_amateur4',
        name: '김태현',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 340, control: 400, attack: 420, harass: 360,
          strategy: 380, macro: 360, defense: 340, scout: 320,
        ), // 합계: 2920 (B)
        levelValue: 1,
      ),
      Player(
        id: 'free_amateur5',
        name: '이동수',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 320, control: 380, attack: 360, harass: 400,
          strategy: 340, macro: 420, defense: 300, scout: 340,
        ), // 합계: 2860 (B)
        levelValue: 1,
      ),
      Player(
        id: 'free_amateur6',
        name: '최준혁',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 360, control: 420, attack: 400, harass: 360,
          strategy: 440, macro: 400, defense: 360, scout: 380,
        ), // 합계: 3120 (B)
        levelValue: 1,
      ),
    ];
  }

  // ===== 팀별 데이터 (1.29.01 버전) =====

  // KT 롤스터
  static Team _createKtRolster() {
    return Team(
      id: 'kt_rolster',
      name: 'KT 롤스터',
      shortName: 'KT',
      colorValue: 0xFFFF0000,
      playerIds: [
        'kt_flash', 'kt_action', 'kt_stats', 'kt_taegyun',
        'kt_woojungho', 'kt_parkseonggyun', 'kt_hwangbyungyoung',
        'kt_imjunghyun', 'kt_gogangmin', 'kt_joosingwook', 'kt_wonsunjae',
      ],
      acePlayerId: 'kt_flash',
      money: 0,
    );
  }

  static List<Player> _createKtRolsterPlayers() {
    return [
      // 이영호 (Flash) - A+, 9레벨, 6500
      Player(
        id: 'kt_flash',
        name: '이영호',
        nickname: 'Flash',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 820, control: 880, attack: 860, harass: 800,
          strategy: 840, macro: 860, defense: 820, scout: 820,
        ),
        levelValue: 9,
        teamId: 'kt_rolster',
      ),
      // 김성대 (Action) - B-, 5레벨, 5500
      Player(
        id: 'kt_action',
        name: '김성대',
        nickname: 'Action',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 740,
          strategy: 660, macro: 720, defense: 640, scout: 680,
        ),
        levelValue: 5,
        teamId: 'kt_rolster',
      ),
      // 김대엽 (Stats) - B, 6레벨, 5750
      Player(
        id: 'kt_stats',
        name: '김대엽',
        nickname: 'Stats',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 680,
          strategy: 760, macro: 740, defense: 700, scout: 720,
        ),
        levelValue: 6,
        teamId: 'kt_rolster',
      ),
      // 김태균 - C+, 4레벨, 5350
      Player(
        id: 'kt_taegyun',
        name: '김태균',
        nickname: 'TaeGyun',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 4,
        teamId: 'kt_rolster',
      ),
      // 우정호 - C-, 6레벨, 5000
      Player(
        id: 'kt_woojungho',
        name: '우정호',
        nickname: 'Free',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 620, harass: 580,
          strategy: 660, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 6,
        teamId: 'kt_rolster',
      ),
      // 박성균 - B, 8레벨, 5700
      Player(
        id: 'kt_parkseonggyun',
        name: '박성균',
        nickname: 'July',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 760, harass: 680,
          strategy: 720, macro: 700, defense: 680, scout: 660,
        ),
        levelValue: 8,
        teamId: 'kt_rolster',
      ),
      // 황병영 - C-, 3레벨, 5050
      Player(
        id: 'kt_hwangbyungyoung',
        name: '황병영',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 680, harass: 600,
          strategy: 640, macro: 620, defense: 600, scout: 580,
        ),
        levelValue: 3,
        teamId: 'kt_rolster',
      ),
      // 임정현 - B-, 5레벨, 5500
      Player(
        id: 'kt_imjunghyun',
        name: '임정현',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 740,
          strategy: 660, macro: 720, defense: 640, scout: 680,
        ),
        levelValue: 5,
        teamId: 'kt_rolster',
      ),
      // 고강민 - C+, 5레벨, 5250
      Player(
        id: 'kt_gogangmin',
        name: '고강민',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 660, harass: 700,
          strategy: 620, macro: 680, defense: 620, scout: 640,
        ),
        levelValue: 5,
        teamId: 'kt_rolster',
      ),
      // 주성욱 - C, 3레벨, 5100
      Player(
        id: 'kt_joosingwook',
        name: '주성욱',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 680, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 3,
        teamId: 'kt_rolster',
      ),
      // 원선재 - D+, 2레벨, 4950
      Player(
        id: 'kt_wonsunjae',
        name: '원선재',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 620, harass: 580,
          strategy: 660, macro: 620, defense: 600, scout: 620,
        ),
        levelValue: 2,
        teamId: 'kt_rolster',
      ),
    ];
  }

  // 삼성전자 칸
  static Team _createSamsungKhan() {
    return Team(
      id: 'samsung_khan',
      name: '삼성전자 칸',
      shortName: 'SSG',
      colorValue: 0xFF0066CC,
      playerIds: [
        'ssg_jangbi', 'ssg_stork', 'ssg_shine', 'ssg_roro',
        'ssg_reality', 'ssg_turn', 'ssg_brave', 'ssg_jokiseok',
        'ssg_jooyoungdal', 'ssg_yoojoonhee', 'ssg_hanjiwon', 'ssg_imtaegyu',
      ],
      acePlayerId: 'ssg_jangbi',
      money: 0,
    );
  }

  static List<Player> _createSamsungKhanPlayers() {
    return [
      // 허영무 (JangBi) - A+, 8레벨, 6450
      Player(
        id: 'ssg_jangbi',
        name: '허영무',
        nickname: 'JangBi',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 800, control: 840, attack: 820, harass: 780,
          strategy: 860, macro: 820, defense: 780, scout: 820,
        ),
        levelValue: 8,
        teamId: 'samsung_khan',
      ),
      // 송병구 (Stork) - A, 9레벨, 6250
      Player(
        id: 'ssg_stork',
        name: '송병구',
        nickname: 'Stork',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 760, control: 800, attack: 780, harass: 760,
          strategy: 820, macro: 800, defense: 760, scout: 780,
        ),
        levelValue: 9,
        teamId: 'samsung_khan',
      ),
      // 이영한 (Shine) - B+, 7레벨, 5850
      Player(
        id: 'ssg_shine',
        name: '이영한',
        nickname: 'Shine',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 740, harass: 780,
          strategy: 700, macro: 760, defense: 700, scout: 720,
        ),
        levelValue: 7,
        teamId: 'samsung_khan',
      ),
      // 신노열 (RorO) - B, 5레벨, 5650
      Player(
        id: 'ssg_roro',
        name: '신노열',
        nickname: 'RorO',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 760,
          strategy: 680, macro: 740, defense: 680, scout: 700,
        ),
        levelValue: 5,
        teamId: 'samsung_khan',
      ),
      // 김기현 (Reality) - C+, 3레벨, 5250
      Player(
        id: 'ssg_reality',
        name: '김기현',
        nickname: 'Reality',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 700, harass: 620,
          strategy: 660, macro: 640, defense: 660, scout: 620,
        ),
        levelValue: 3,
        teamId: 'samsung_khan',
      ),
      // 박대호 (Turn) - C+, 3레벨, 5250
      Player(
        id: 'ssg_turn',
        name: '박대호',
        nickname: 'Turn',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 720, harass: 600,
          strategy: 660, macro: 640, defense: 620, scout: 600,
        ),
        levelValue: 3,
        teamId: 'samsung_khan',
      ),
      // 유병준 (Brave) - C+, 3레벨, 5350
      Player(
        id: 'ssg_brave',
        name: '유병준',
        nickname: 'BravE',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 3,
        teamId: 'samsung_khan',
      ),
      // 조기석 - E, 1레벨, 4500
      Player(
        id: 'ssg_jokiseok',
        name: '조기석',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 540, control: 580, attack: 600, harass: 520,
          strategy: 560, macro: 540, defense: 520, scout: 500,
        ),
        levelValue: 1,
        teamId: 'samsung_khan',
      ),
      // 주영달 - D+, 6레벨, 4950
      Player(
        id: 'ssg_jooyoungdal',
        name: '주영달',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 620, harass: 660,
          strategy: 580, macro: 640, defense: 580, scout: 600,
        ),
        levelValue: 6,
        teamId: 'samsung_khan',
      ),
      // 유준희 - D+, 3레벨, 4900
      Player(
        id: 'ssg_yoojoonhee',
        name: '유준희',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 600, harass: 640,
          strategy: 560, macro: 640, defense: 560, scout: 580,
        ),
        levelValue: 3,
        teamId: 'samsung_khan',
      ),
      // 한지원 - D, 2레벨, 4700
      Player(
        id: 'ssg_hanjiwon',
        name: '한지원',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 620,
          strategy: 540, macro: 620, defense: 540, scout: 560,
        ),
        levelValue: 2,
        teamId: 'samsung_khan',
      ),
      // 임태규 - C, 4레벨, 5100
      Player(
        id: 'ssg_imtaegyu',
        name: '임태규',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 680, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 4,
        teamId: 'samsung_khan',
      ),
    ];
  }

  // STX SouL
  static Team _createStxSoul() {
    return Team(
      id: 'stx_soul',
      name: 'STX SouL',
      shortName: 'STX',
      colorValue: 0xFFFFCC00,
      playerIds: [
        'stx_bogus', 'stx_calm', 'stx_shindaegeun', 'stx_kimhyunwoo',
        'stx_mini', 'stx_kimyoonjung', 'stx_josungho', 'stx_kimsunghyun',
        'stx_kimdowoo', 'stx_seojisu', 'stx_baekdongjun', 'stx_parkjongsu',
      ],
      acePlayerId: 'stx_bogus',
      money: 0,
    );
  }

  static List<Player> _createStxSoulPlayers() {
    return [
      // 이신형 (Bogus/INnoVation) - B, 5레벨, 5750
      Player(
        id: 'stx_bogus',
        name: '이신형',
        nickname: 'Bogus',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 700, control: 760, attack: 780, harass: 680,
          strategy: 720, macro: 740, defense: 700, scout: 680,
        ),
        levelValue: 5,
        teamId: 'stx_soul',
      ),
      // 김윤환 (Calm) - B+, 8레벨, 5900
      Player(
        id: 'stx_calm',
        name: '김윤환',
        nickname: 'Calm',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 740, harass: 780,
          strategy: 700, macro: 780, defense: 700, scout: 720,
        ),
        levelValue: 8,
        teamId: 'stx_soul',
      ),
      // 신대근 - B-, 7레벨, 5550
      Player(
        id: 'stx_shindaegeun',
        name: '신대근',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 740,
          strategy: 660, macro: 720, defense: 660, scout: 680,
        ),
        levelValue: 7,
        teamId: 'stx_soul',
      ),
      // 김현우 - C+, 3레벨, 5300
      Player(
        id: 'stx_kimhyunwoo',
        name: '김현우',
        nickname: 'Kwanro',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 720,
          strategy: 640, macro: 700, defense: 640, scout: 660,
        ),
        levelValue: 3,
        teamId: 'stx_soul',
      ),
      // 변현제 (Mini) - C+, 1레벨, 5350
      Player(
        id: 'stx_mini',
        name: '변현제',
        nickname: 'Mini',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 720, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 1,
        teamId: 'stx_soul',
      ),
      // 김윤중 - C+, 5레벨, 5300
      Player(
        id: 'stx_kimyoonjung',
        name: '김윤중',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 660,
        ),
        levelValue: 5,
        teamId: 'stx_soul',
      ),
      // 조성호 - C+, 2레벨, 5300
      Player(
        id: 'stx_josungho',
        name: '조성호',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 660,
        ),
        levelValue: 2,
        teamId: 'stx_soul',
      ),
      // 김성현 - B-, 4레벨, 5500
      Player(
        id: 'stx_kimsunghyun',
        name: '김성현',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 740, harass: 660,
          strategy: 700, macro: 700, defense: 680, scout: 660,
        ),
        levelValue: 4,
        teamId: 'stx_soul',
      ),
      // 김도우 - C+, 4레벨, 5250
      Player(
        id: 'stx_kimdowoo',
        name: '김도우',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 700, harass: 620,
          strategy: 660, macro: 660, defense: 640, scout: 620,
        ),
        levelValue: 4,
        teamId: 'stx_soul',
      ),
      // 서지수 - D+, 2레벨, 4900
      Player(
        id: 'stx_seojisu',
        name: '서지수',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 640, harass: 560,
          strategy: 600, macro: 600, defense: 580, scout: 560,
        ),
        levelValue: 2,
        teamId: 'stx_soul',
      ),
      // 백동준 - D+, 2레벨, 4950
      Player(
        id: 'stx_baekdongjun',
        name: '백동준',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 620, harass: 580,
          strategy: 660, macro: 620, defense: 600, scout: 620,
        ),
        levelValue: 2,
        teamId: 'stx_soul',
      ),
      // 박종수 - D, 1레벨, 4700
      Player(
        id: 'stx_parkjongsu',
        name: '박종수',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 540,
          strategy: 620, macro: 580, defense: 560, scout: 580,
        ),
        levelValue: 1,
        teamId: 'stx_soul',
      ),
    ];
  }

  // SK텔레콤 T1
  static Team _createSktT1() {
    return Team(
      id: 'skt_t1',
      name: 'SK텔레콤 T1',
      shortName: 'SKT',
      colorValue: 0xFFCC0000,
      playerIds: [
        'skt_fantasy', 'skt_bisu', 'skt_best', 'skt_mind',
        'skt_soo', 'skt_iris', 'skt_rain', 'skt_choihosun',
        'skt_jungyoungjae', 'skt_kimyonghyo', 'skt_leeyehoon',
        'skt_bangtaesu', 'skt_imhonggyu', 'skt_jungkyungdoo', 'skt_leehoseong',
      ],
      acePlayerId: 'skt_fantasy',
      money: 0,
    );
  }

  static List<Player> _createSktT1Players() {
    return [
      // 정명훈 (Fantasy) - A+, 9레벨, 6550
      Player(
        id: 'skt_fantasy',
        name: '정명훈',
        nickname: 'Fantasy',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 820, control: 860, attack: 840, harass: 800,
          strategy: 840, macro: 840, defense: 820, scout: 820,
        ),
        levelValue: 9,
        teamId: 'skt_t1',
      ),
      // 김택용 (Bisu) - A, 9레벨, 6250
      Player(
        id: 'skt_bisu',
        name: '김택용',
        nickname: 'Bisu',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 760, control: 820, attack: 780, harass: 760,
          strategy: 840, macro: 800, defense: 760, scout: 780,
        ),
        levelValue: 9,
        teamId: 'skt_t1',
      ),
      // 도재욱 (Best) - C+, 8레벨, 5350
      Player(
        id: 'skt_best',
        name: '도재욱',
        nickname: 'Best',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 720, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 8,
        teamId: 'skt_t1',
      ),
      // 박재혁 (Mind) - B-, 6레벨, 5450
      Player(
        id: 'skt_mind',
        name: '박재혁',
        nickname: 'Mind',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 740,
          strategy: 660, macro: 720, defense: 640, scout: 680,
        ),
        levelValue: 6,
        teamId: 'skt_t1',
      ),
      // 어윤수 (soO) - C+, 5레벨, 5300
      Player(
        id: 'skt_soo',
        name: '어윤수',
        nickname: 'soO',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 720,
          strategy: 640, macro: 700, defense: 640, scout: 660,
        ),
        levelValue: 5,
        teamId: 'skt_t1',
      ),
      // 이승석 (Iris) - C+, 4레벨, 5250
      Player(
        id: 'skt_iris',
        name: '이승석',
        nickname: 'Iris',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 660, harass: 700,
          strategy: 620, macro: 680, defense: 620, scout: 640,
        ),
        levelValue: 4,
        teamId: 'skt_t1',
      ),
      // 정윤종 (Rain) - C+, 4레벨, 5300
      Player(
        id: 'skt_rain',
        name: '정윤종',
        nickname: 'Rain',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 4,
        teamId: 'skt_t1',
      ),
      // 최호선 - D+, 3레벨, 5000
      Player(
        id: 'skt_choihosun',
        name: '최호선',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 680, harass: 600,
          strategy: 640, macro: 620, defense: 600, scout: 580,
        ),
        levelValue: 3,
        teamId: 'skt_t1',
      ),
      // 정영재 - E, 1레벨, 4600
      Player(
        id: 'skt_jungyoungjae',
        name: '정영재',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 620, harass: 540,
          strategy: 580, macro: 560, defense: 540, scout: 520,
        ),
        levelValue: 1,
        teamId: 'skt_t1',
      ),
      // 김용효 - D+, 2레벨, 4900
      Player(
        id: 'skt_kimyonghyo',
        name: '김용효',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 640, harass: 560,
          strategy: 600, macro: 600, defense: 580, scout: 560,
        ),
        levelValue: 2,
        teamId: 'skt_t1',
      ),
      // 이예훈 - D+, 2레벨, 4900
      Player(
        id: 'skt_leeyehoon',
        name: '이예훈',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 600, harass: 640,
          strategy: 560, macro: 640, defense: 560, scout: 580,
        ),
        levelValue: 2,
        teamId: 'skt_t1',
      ),
      // 방태수 - D, 1레벨, 4700
      Player(
        id: 'skt_bangtaesu',
        name: '방태수',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 620,
          strategy: 540, macro: 620, defense: 540, scout: 560,
        ),
        levelValue: 1,
        teamId: 'skt_t1',
      ),
      // 임홍규 - D, 1레벨, 4700
      Player(
        id: 'skt_imhonggyu',
        name: '임홍규',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 620,
          strategy: 540, macro: 620, defense: 540, scout: 560,
        ),
        levelValue: 1,
        teamId: 'skt_t1',
      ),
      // 정경두 - C, 3레벨, 5050
      Player(
        id: 'skt_jungkyungdoo',
        name: '정경두',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 680, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 3,
        teamId: 'skt_t1',
      ),
      // 이호성 - D+, 2레벨, 4900
      Player(
        id: 'skt_leehoseong',
        name: '이호성',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 600, harass: 560,
          strategy: 660, macro: 600, defense: 580, scout: 600,
        ),
        levelValue: 2,
        teamId: 'skt_t1',
      ),
    ];
  }

  // 웅진 스타즈
  static Team _createWoongjinStars() {
    return Team(
      id: 'woongjin_stars',
      name: '웅진 스타즈',
      shortName: 'WJS',
      colorValue: 0xFF009933,
      playerIds: [
        'wjs_zero', 'wjs_soulkey', 'wjs_light', 'wjs_killer',
        'wjs_jaewook', 'wjs_nojunggyu', 'wjs_hongjinpyo',
        'wjs_kimyoojin', 'wjs_kimseongwoon',
      ],
      acePlayerId: 'wjs_zero',
      money: 0,
    );
  }

  static List<Player> _createWoongjinStarsPlayers() {
    return [
      // 김명운 (Zero) - A-, 8레벨, 6150
      Player(
        id: 'wjs_zero',
        name: '김명운',
        nickname: 'Zero',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 760, control: 800, attack: 780, harass: 820,
          strategy: 740, macro: 800, defense: 720, scout: 760,
        ),
        levelValue: 8,
        teamId: 'woongjin_stars',
      ),
      // 김민철 (SoulKey) - B+, 7레벨, 5900
      Player(
        id: 'wjs_soulkey',
        name: '김민철',
        nickname: 'SoulKey',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 740, harass: 780,
          strategy: 700, macro: 780, defense: 700, scout: 720,
        ),
        levelValue: 7,
        teamId: 'woongjin_stars',
      ),
      // 이재호 (Light) - B+, 8레벨, 5800
      Player(
        id: 'wjs_light',
        name: '이재호',
        nickname: 'Light',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 780, harass: 700,
          strategy: 740, macro: 740, defense: 720, scout: 700,
        ),
        levelValue: 8,
        teamId: 'woongjin_stars',
      ),
      // 윤용태 (Killer) - B-, 7레벨, 5550
      Player(
        id: 'wjs_killer',
        name: '윤용태',
        nickname: 'Killer',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 660,
          strategy: 740, macro: 700, defense: 680, scout: 700,
        ),
        levelValue: 7,
        teamId: 'woongjin_stars',
      ),
      // 신재욱 - B-, 6레벨, 5450
      Player(
        id: 'wjs_jaewook',
        name: '신재욱',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 660,
          strategy: 720, macro: 700, defense: 680, scout: 680,
        ),
        levelValue: 6,
        teamId: 'woongjin_stars',
      ),
      // 노준규 - D+, 3레벨, 4950
      Player(
        id: 'wjs_nojunggyu',
        name: '노준규',
        nickname: 'BrAvO',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 660, harass: 580,
          strategy: 620, macro: 620, defense: 600, scout: 580,
        ),
        levelValue: 3,
        teamId: 'woongjin_stars',
      ),
      // 홍진표 - F, 1레벨, 4400
      Player(
        id: 'wjs_hongjinpyo',
        name: '홍진표',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 520, control: 560, attack: 580, harass: 500,
          strategy: 540, macro: 520, defense: 500, scout: 480,
        ),
        levelValue: 1,
        teamId: 'woongjin_stars',
      ),
      // 김유진 - C-, 4레벨, 5000
      Player(
        id: 'wjs_kimyoojin',
        name: '김유진',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 660, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 4,
        teamId: 'woongjin_stars',
      ),
      // 김성운 - F, 1레벨, 4400
      Player(
        id: 'wjs_kimseongwoon',
        name: '김성운',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 520, control: 560, attack: 540, harass: 580,
          strategy: 500, macro: 580, defense: 500, scout: 520,
        ),
        levelValue: 1,
        teamId: 'woongjin_stars',
      ),
    ];
  }

  // CJ 엔투스
  static Team _createCjEntus() {
    return Team(
      id: 'cj_entus',
      name: 'CJ 엔투스',
      shortName: 'CJ',
      colorValue: 0xFFE6B800,
      playerIds: [
        'cj_leta', 'cj_hydra', 'cj_snow', 'cj_leekyungmin',
        'cj_jobyungse', 'cj_jungwoyong', 'cj_youyoungjin',
        'cj_kimjungwoo', 'cj_kimjunho', 'cj_songyoungjin', 'cj_handooyeol',
      ],
      acePlayerId: 'cj_leta',
      money: 0,
    );
  }

  static List<Player> _createCjEntusPlayers() {
    return [
      // 신상문 (Leta) - B+, 7레벨, 5900
      Player(
        id: 'cj_leta',
        name: '신상문',
        nickname: 'Leta',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 780, harass: 700,
          strategy: 740, macro: 740, defense: 720, scout: 700,
        ),
        levelValue: 7,
        teamId: 'cj_entus',
      ),
      // 신동원 (Hydra) - B+, 7레벨, 5900
      Player(
        id: 'cj_hydra',
        name: '신동원',
        nickname: 'Hydra',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 740, harass: 780,
          strategy: 700, macro: 780, defense: 700, scout: 720,
        ),
        levelValue: 7,
        teamId: 'cj_entus',
      ),
      // 장윤철 (SnOw) - B, 5레벨, 5700
      Player(
        id: 'cj_snow',
        name: '장윤철',
        nickname: 'SnOw',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 680,
          strategy: 760, macro: 720, defense: 700, scout: 720,
        ),
        levelValue: 5,
        teamId: 'cj_entus',
      ),
      // 이경민 - B, 6레벨, 5650
      Player(
        id: 'cj_leekyungmin',
        name: '이경민',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 680,
          strategy: 740, macro: 720, defense: 700, scout: 700,
        ),
        levelValue: 6,
        teamId: 'cj_entus',
      ),
      // 조병세 - B-, 5레벨, 5500
      Player(
        id: 'cj_jobyungse',
        name: '조병세',
        nickname: 'Iris',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 740, harass: 660,
          strategy: 700, macro: 700, defense: 680, scout: 660,
        ),
        levelValue: 5,
        teamId: 'cj_entus',
      ),
      // 정우용 - D+, 4레벨, 4950
      Player(
        id: 'cj_jungwoyong',
        name: '정우용',
        nickname: 'sKyHigh',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 600, control: 640, attack: 620, harass: 660,
          strategy: 580, macro: 660, defense: 580, scout: 600,
        ),
        levelValue: 4,
        teamId: 'cj_entus',
      ),
      // 유영진 - C-, 3레벨, 5000
      Player(
        id: 'cj_youyoungjin',
        name: '유영진',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 680, harass: 600,
          strategy: 640, macro: 620, defense: 600, scout: 580,
        ),
        levelValue: 3,
        teamId: 'cj_entus',
      ),
      // 김정우 (Effort) - B-, 5레벨, 5500
      Player(
        id: 'cj_kimjungwoo',
        name: '김정우',
        nickname: 'Effort',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 740,
          strategy: 660, macro: 720, defense: 660, scout: 680,
        ),
        levelValue: 5,
        teamId: 'cj_entus',
      ),
      // 김준호 - D-, 3레벨, 4800
      Player(
        id: 'cj_kimjunho',
        name: '김준호',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 600, harass: 640,
          strategy: 560, macro: 640, defense: 560, scout: 580,
        ),
        levelValue: 3,
        teamId: 'cj_entus',
      ),
      // 송영진 - F, 1레벨, 4400
      Player(
        id: 'cj_songyoungjin',
        name: '송영진',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 520, control: 560, attack: 540, harass: 580,
          strategy: 500, macro: 580, defense: 500, scout: 520,
        ),
        levelValue: 1,
        teamId: 'cj_entus',
      ),
      // 한두열 - D+, 3레벨, 4900
      Player(
        id: 'cj_handooyeol',
        name: '한두열',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 600, harass: 640,
          strategy: 560, macro: 640, defense: 560, scout: 580,
        ),
        levelValue: 3,
        teamId: 'cj_entus',
      ),
    ];
  }

  // 공군 ACE
  static Team _createAirforceAce() {
    return Team(
      id: 'airforce_ace',
      name: '공군 ACE',
      shortName: 'ACE',
      colorValue: 0xFF3366CC,
      playerIds: [
        'ace_modesty', 'ace_cha', 'ace_byunhyungtae', 'ace_leeseungeun',
        'ace_koinggyu', 'ace_imjinmook', 'ace_sonseokhee',
        'ace_kimseunghyun', 'ace_leejunghyun', 'ace_ankihyo',
      ],
      acePlayerId: 'ace_modesty',
      money: 0,
    );
  }

  static List<Player> _createAirforceAcePlayers() {
    return [
      // 김구현 (Modesty) - B+, 8레벨, 5800
      Player(
        id: 'ace_modesty',
        name: '김구현',
        nickname: 'Modesty',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 740, harass: 700,
          strategy: 760, macro: 740, defense: 720, scout: 740,
        ),
        levelValue: 8,
        teamId: 'airforce_ace',
      ),
      // 차명환 - B, 7레벨, 5600
      Player(
        id: 'ace_cha',
        name: '차명환',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 760,
          strategy: 680, macro: 740, defense: 680, scout: 700,
        ),
        levelValue: 7,
        teamId: 'airforce_ace',
      ),
      // 변형태 (Movie) - B-, 8레벨, 5400
      Player(
        id: 'ace_byunhyungtae',
        name: '변형태',
        nickname: 'Movie',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 720, harass: 680,
          strategy: 680, macro: 680, defense: 660, scout: 660,
        ),
        levelValue: 8,
        teamId: 'airforce_ace',
      ),
      // 이성은 (ZerO) - B-, 8레벨, 5450
      Player(
        id: 'ace_leeseungeun',
        name: '이성은',
        nickname: 'ZerO',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 680,
          strategy: 700, macro: 700, defense: 680, scout: 680,
        ),
        levelValue: 8,
        teamId: 'airforce_ace',
      ),
      // 고인규 - C+, 7레벨, 5200
      Player(
        id: 'ace_koinggyu',
        name: '고인규',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 700, harass: 620,
          strategy: 660, macro: 660, defense: 640, scout: 620,
        ),
        levelValue: 7,
        teamId: 'airforce_ace',
      ),
      // 임진묵 - C+, 6레벨, 5200
      Player(
        id: 'ace_imjinmook',
        name: '임진묵',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 640, control: 680, attack: 700, harass: 620,
          strategy: 660, macro: 660, defense: 640, scout: 620,
        ),
        levelValue: 6,
        teamId: 'airforce_ace',
      ),
      // 손석희 - C+, 4레벨, 5350
      Player(
        id: 'ace_sonseokhee',
        name: '손석희',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 640,
          strategy: 700, macro: 680, defense: 660, scout: 680,
        ),
        levelValue: 4,
        teamId: 'airforce_ace',
      ),
      // 김승현 - C, 6레벨, 5000
      Player(
        id: 'ace_kimseunghyun',
        name: '김승현',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 660, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 6,
        teamId: 'airforce_ace',
      ),
      // 이정현 - D, 1레벨, 4600
      Player(
        id: 'ace_leejunghyun',
        name: '이정현',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 560, control: 600, attack: 580, harass: 620,
          strategy: 540, macro: 600, defense: 540, scout: 560,
        ),
        levelValue: 1,
        teamId: 'airforce_ace',
      ),
      // 안기효 - C, 4레벨, 5100
      Player(
        id: 'ace_ankihyo',
        name: '안기효',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 620, control: 660, attack: 640, harass: 600,
          strategy: 680, macro: 640, defense: 620, scout: 640,
        ),
        levelValue: 4,
        teamId: 'airforce_ace',
      ),
    ];
  }

  // 제8게임단 (해체팀 출신 + 신인)
  static Team _createTeam8() {
    return Team(
      id: 'team8',
      name: '제8게임단',
      shortName: 'T8',
      colorValue: 0xFF666666,
      playerIds: [
        't8_jaedong', 't8_upmagic', 't8_taeyang', 't8_anytime',
        't8_jaehoon', 't8_gorush', 't8_cal', 't8_joiljang',
        't8_byungryul', 't8_hajaesang', 't8_kimdowook',
      ],
      acePlayerId: 't8_jaedong',
      money: 0,
    );
  }

  static List<Player> _createTeam8Players() {
    return [
      // 이제동 (Jaedong) - A+, 9레벨, 6400
      Player(
        id: 't8_jaedong',
        name: '이제동',
        nickname: 'Jaedong',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 800, control: 840, attack: 820, harass: 800,
          strategy: 780, macro: 820, defense: 760, scout: 800,
        ),
        levelValue: 9,
        teamId: 'team8',
      ),
      // 염보성 (UpMaGiC) - A-, 8레벨, 6000
      Player(
        id: 't8_upmagic',
        name: '염보성',
        nickname: 'UpMaGiC',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 740, control: 780, attack: 800, harass: 720,
          strategy: 760, macro: 760, defense: 740, scout: 720,
        ),
        levelValue: 8,
        teamId: 'team8',
      ),
      // 전태양 (TaeYang) - B+, 6레벨, 5900
      Player(
        id: 't8_taeyang',
        name: '전태양',
        nickname: 'TaeYang',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 720, control: 760, attack: 780, harass: 700,
          strategy: 740, macro: 740, defense: 720, scout: 700,
        ),
        levelValue: 6,
        teamId: 'team8',
      ),
      // 진영화 (Anytime) - B, 7레벨, 5750
      Player(
        id: 't8_anytime',
        name: '진영화',
        nickname: 'Anytime',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 680,
          strategy: 760, macro: 720, defense: 700, scout: 720,
        ),
        levelValue: 7,
        teamId: 'team8',
      ),
      // 김재훈 - B, 5레벨, 5600
      Player(
        id: 't8_jaehoon',
        name: '김재훈',
        nickname: 'Kwanro',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 680,
          strategy: 740, macro: 720, defense: 680, scout: 700,
        ),
        levelValue: 5,
        teamId: 'team8',
      ),
      // 박수범 (GoRush) - B-, 5레벨, 5450
      Player(
        id: 't8_gorush',
        name: '박수범',
        nickname: 'GoRush',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 680, control: 720, attack: 700, harass: 660,
          strategy: 720, macro: 700, defense: 680, scout: 680,
        ),
        levelValue: 5,
        teamId: 'team8',
      ),
      // 박준오 (Cal) - B, 5레벨, 5600
      Player(
        id: 't8_cal',
        name: '박준오',
        nickname: 'Cal',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 700, control: 740, attack: 720, harass: 760,
          strategy: 680, macro: 740, defense: 680, scout: 700,
        ),
        levelValue: 5,
        teamId: 'team8',
      ),
      // 조일장 - B-, 5레벨, 5400
      Player(
        id: 't8_joiljang',
        name: '조일장',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 660, control: 700, attack: 680, harass: 720,
          strategy: 640, macro: 700, defense: 640, scout: 660,
        ),
        levelValue: 5,
        teamId: 'team8',
      ),
      // 이병렬 - F, 1레벨, 4400
      Player(
        id: 't8_byungryul',
        name: '이병렬',
        raceIndex: Race.zerg.index,
        stats: const PlayerStats(
          sense: 520, control: 560, attack: 540, harass: 580,
          strategy: 500, macro: 580, defense: 500, scout: 520,
        ),
        levelValue: 1,
        teamId: 'team8',
      ),
      // 하재상 - F, 1레벨, 4400
      Player(
        id: 't8_hajaesang',
        name: '하재상',
        raceIndex: Race.protoss.index,
        stats: const PlayerStats(
          sense: 520, control: 560, attack: 540, harass: 500,
          strategy: 580, macro: 540, defense: 520, scout: 540,
        ),
        levelValue: 1,
        teamId: 'team8',
      ),
      // 김도욱 - D+, 2레벨, 4900
      Player(
        id: 't8_kimdowook',
        name: '김도욱',
        raceIndex: Race.terran.index,
        stats: const PlayerStats(
          sense: 580, control: 620, attack: 640, harass: 560,
          strategy: 600, macro: 600, defense: 580, scout: 560,
        ),
        levelValue: 2,
        teamId: 'team8',
      ),
    ];
  }
}
