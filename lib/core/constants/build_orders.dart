// 빌드오더 기반 이벤트 시스템
//
// 각 빌드는 순서대로 진행되는 이벤트 단계(step)를 가짐
// 양 선수가 각자의 빌드를 독립적으로 진행하며, 특정 시점에 충돌(clash) 발생

import '../../domain/models/enums.dart' show BuildStyle;

export '../../domain/models/enums.dart' show BuildStyle;

/// 빌드 단계 (순서대로 진행)
class BuildStep {
  final int line;           // 발생 라인 (기준점)
  final String text;        // 이벤트 텍스트
  final String? stat;       // 관련 능력치
  final int myArmy;         // 내 병력 변화
  final int myResource;     // 내 자원 변화
  final int enemyArmy;      // 상대 병력 변화 (견제 등)
  final int enemyResource;  // 상대 자원 변화
  final bool isClash;       // 충돌 이벤트 여부 (양측 병력 손실)
  final bool decisive;      // 결정적 이벤트 여부

  const BuildStep({
    required this.line,
    required this.text,
    this.stat,
    this.myArmy = 0,
    this.myResource = 0,
    this.enemyArmy = 0,
    this.enemyResource = 0,
    this.isClash = false,
    this.decisive = false,
  });
}

/// 빌드오더 정의
class BuildOrder {
  final String id;
  final String name;
  final String race;      // T, Z, P
  final String vsRace;    // 상대 종족
  final BuildStyle style;
  final List<BuildStep> steps;

  const BuildOrder({
    required this.id,
    required this.name,
    required this.race,
    required this.vsRace,
    required this.style,
    required this.steps,
  });
}

/// 충돌 시나리오 (양측 빌드가 만났을 때)
class ClashScenario {
  final String id;
  final int startLine;        // 충돌 시작 라인
  final BuildStyle attackerStyle;
  final BuildStyle defenderStyle;
  final List<ClashEvent> events;

  const ClashScenario({
    required this.id,
    required this.startLine,
    required this.attackerStyle,
    required this.defenderStyle,
    required this.events,
  });
}

/// 충돌 이벤트
class ClashEvent {
  final String text;
  final int attackerArmy;     // 공격자 병력 변화
  final int defenderArmy;     // 수비자 병력 변화
  final int attackerResource; // 공격자 자원 변화
  final int defenderResource; // 수비자 자원 변화
  final bool decisive;        // 결정적 이벤트
  final String? favorsStat;   // 이 능력치가 높으면 유리

  const ClashEvent({
    required this.text,
    this.attackerArmy = 0,
    this.defenderArmy = 0,
    this.attackerResource = 0,
    this.defenderResource = 0,
    this.decisive = false,
    this.favorsStat,
  });
}

/// 빌드오더 데이터 저장소
class BuildOrderData {
  // ==================== 테란 빌드 ====================

  // TvZ 빌드들
  static const terranVsZergBuilds = [
    // 1. 벙커링 수비 (Defensive)
    BuildOrder(
      id: 'tvz_bunker_defense',
      name: '벙커링 수비',
      race: 'T',
      vsRace: 'Z',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 서플라이 건설!', myResource: -8),
        BuildStep(line: 7, text: '{player} 선수 정찰 SCV 출발!', stat: 'scout'),
        BuildStep(line: 10, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 15, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 25, text: '{player} 선수 벌처 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 30, text: '{player}, 마인 설치 완료!', stat: 'strategy', myResource: -5),
        BuildStep(line: 35, text: '{player} 선수 시즈탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 50, text: '{player}, 사이언스 베슬 생산!', myArmy: 2, myResource: -20),
        BuildStep(line: 60, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 80, text: '{player}, 탱크 골리앗 조합 완성!', stat: 'macro', myArmy: 15, myResource: -40),
        BuildStep(line: 100, text: '{player} 선수 최대 서플라이 도달!', stat: 'macro', myArmy: 20, myResource: -50),
      ],
    ),

    // 2. 바이오닉 푸시 (Aggressive)
    BuildOrder(
      id: 'tvz_bionic_push',
      name: '바이오닉 푸시',
      race: 'T',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 2배럭 건설!', myResource: -10),
        BuildStep(line: 8, text: '{player}, 마린 추가 생산!', myArmy: 3, myResource: -8),
        BuildStep(line: 12, text: '{player} 선수 메딕 생산 시작!', myArmy: 2, myResource: -10),
        BuildStep(line: 15, text: '{player}, 바이오닉 조합 완성!', myArmy: 5, myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 스팀팩 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 25, text: '{player}, 푸시 나갑니다!', stat: 'attack'),
        BuildStep(line: 30, text: '{player} 선수 상대 앞마당 압박!', stat: 'attack', isClash: true),
      ],
    ),

    // 3. 벌처 견제 (Balanced)
    BuildOrder(
      id: 'tvz_vulture_harass',
      name: '벌처 견제',
      race: 'T',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 벌처 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 12, text: '{player}, 벌처 출발!', stat: 'harass'),
        BuildStep(line: 15, text: '{player}, 벌처로 일꾼 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 18, text: '{player} 선수 마인 설치!', stat: 'strategy', myResource: -5),
        BuildStep(line: 22, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 28, text: '{player}, 마인으로 저글링 학살!', stat: 'strategy', enemyArmy: -10),
        BuildStep(line: 35, text: '{player} 선수 시즈탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 55, text: '{player}, 드랍십 생산!', myArmy: 2, myResource: -15),
        BuildStep(line: 65, text: '{player}, 탱크 드랍 출발!', stat: 'harass'),
      ],
    ),

    // 4. 더블 커맨드 (Macro)
    BuildOrder(
      id: 'tvz_double_command',
      name: '더블 커맨드',
      race: 'T',
      vsRace: 'Z',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 서플라이 건설!', myResource: -8),
        BuildStep(line: 6, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 10, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 15, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 20, text: '{player}, 마린 추가 생산!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 벌처 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 35, text: '{player}, 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 50, text: '{player} 선수 시즈탱크 대량 생산!', myArmy: 10, myResource: -35),
        BuildStep(line: 70, text: '{player}, 4번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 90, text: '{player} 선수 최대 서플라이 도달!', stat: 'macro', myArmy: 25, myResource: -50),
      ],
    ),
  ];

  // TvP 빌드들
  static const terranVsProtossBuilds = [
    // 1. 시즈 푸시 (Balanced)
    BuildOrder(
      id: 'tvp_siege_push',
      name: '시즈 푸시',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 시즈탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 시즈모드 연구!', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 25, text: '{player}, 탱크 라인 전개!', stat: 'strategy'),
        BuildStep(line: 35, text: '{player} 선수 골리앗 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player}, 상대 앞마당 압박!', stat: 'attack', isClash: true),
      ],
    ),

    // 2. 벌처 견제 (Aggressive)
    BuildOrder(
      id: 'tvp_vulture_harass',
      name: '벌처 견제',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 9, text: '{player} 선수 벌처 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 12, text: '{player}, 벌처로 프로브 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 15, text: '{player}, 마인 설치!', stat: 'strategy', myResource: -5),
        BuildStep(line: 18, text: '{player}, 마인으로 질럿 처리!', stat: 'strategy', enemyArmy: -6),
        BuildStep(line: 22, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 30, text: '{player}, 추가 벌처 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 40, text: '{player}, 시즈탱크 생산!', myArmy: 5, myResource: -15),
      ],
    ),
  ];

  // TvT 빌드들
  static const terranVsTerranBuilds = [
    // 1. 시즈 라인 (Balanced)
    BuildOrder(
      id: 'tvt_siege_line',
      name: '시즈 라인',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 시즈탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 15, text: '{player} 선수 고지대 점령!', stat: 'strategy'),
        BuildStep(line: 20, text: '{player}, 시즈모드 전개!', stat: 'strategy'),
        BuildStep(line: 30, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 40, text: '{player}, 레이스 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 50, text: '{player} 선수 탱크 라인 확장!', myArmy: 10, myResource: -35),
      ],
    ),

    // 2. 레이스 러쉬 (Aggressive)
    BuildOrder(
      id: 'tvt_wraith_rush',
      name: '레이스 러쉬',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 12, text: '{player} 선수 레이스 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 15, text: '{player}, 레이스로 SCV 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 20, text: '{player}, 클로킹 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 25, text: '{player}, 클로킹 레이스 투입!', stat: 'harass', enemyResource: -30),
      ],
    ),
  ];

  // ==================== 저그 빌드 ====================

  // ZvT 빌드들
  static const zergVsTerranBuilds = [
    // 1. 3해처리 히드라 (Balanced)
    BuildOrder(
      id: 'zvt_3hatch_hydra',
      name: '3해처리 히드라',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 15, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 20, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 히드라리스크 생산!', myArmy: 5, myResource: -10),
        BuildStep(line: 35, text: '{player}, 럴커 변태!', stat: 'strategy', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player} 선수 럴커 포진!', stat: 'defense'),
        BuildStep(line: 60, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 75, text: '{player} 선수 디파일러 생산!', myArmy: 3, myResource: -15),
      ],
    ),

    // 2. 뮤탈 견제 (Aggressive)
    BuildOrder(
      id: 'zvt_mutal_harass',
      name: '뮤탈 견제',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 18, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 25, text: '{player} 선수 뮤탈리스크 생산!', myArmy: 6, myResource: -15),
        BuildStep(line: 28, text: '{player}, 뮤탈로 일꾼 견제!', stat: 'harass', enemyResource: -30),
        BuildStep(line: 32, text: '{player} 선수 뮤탈 매직!', stat: 'control', enemyArmy: -10),
        BuildStep(line: 40, text: '{player}, 추가 뮤탈 생산!', myArmy: 6, myResource: -15),
        BuildStep(line: 50, text: '{player}, 뮤탈로 드랍십 격추!', stat: 'control', enemyArmy: -8),
      ],
    ),

    // 3. 저글링 러쉬 (Cheese)
    BuildOrder(
      id: 'zvt_zergling_rush',
      name: '저글링 러쉬',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 저글링 생산 시작!', myArmy: 6, myResource: -8),
        BuildStep(line: 8, text: '{player}, 저글링 러쉬!', stat: 'attack'),
        BuildStep(line: 10, text: '{player}, 상대 본진 진입!', stat: 'attack', isClash: true),
      ],
    ),

    // 4. 울트라 디파일러 (Defensive)
    BuildOrder(
      id: 'zvt_ultra_defiler',
      name: '울트라 디파일러',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 35, text: '{player}, 4번째 해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 45, text: '{player} 선수 하이브 건설!', myResource: -25),
        BuildStep(line: 55, text: '{player} 선수 디파일러 생산!', myArmy: 3, myResource: -15),
        BuildStep(line: 65, text: '{player} 선수 울트라리스크 생산!', myArmy: 10, myResource: -30),
        BuildStep(line: 80, text: '{player}, 다크스웜 전개!', stat: 'strategy'),
        BuildStep(line: 90, text: '{player}, 울트라로 탱크 라인 돌파!', stat: 'attack', isClash: true),
      ],
    ),
  ];

  // ZvP 빌드들
  static const zergVsProtossBuilds = [
    // 1. 3해처리 럴커 (Balanced)
    BuildOrder(
      id: 'zvp_3hatch_lurker',
      name: '3해처리 럴커',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 32, text: '{player}, 럴커 변태!', stat: 'strategy', myArmy: 5, myResource: -15),
        BuildStep(line: 40, text: '{player}, 럴커로 질럿 학살!', stat: 'defense', enemyArmy: -15),
        BuildStep(line: 50, text: '{player} 선수 럴커 포진 완료!', stat: 'strategy'),
      ],
    ),

    // 2. 뮤탈 하이드라 (Aggressive)
    BuildOrder(
      id: 'zvp_mutal_hydra',
      name: '뮤탈 히드라',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 26, text: '{player} 선수 뮤탈리스크 생산!', myArmy: 6, myResource: -15),
        BuildStep(line: 30, text: '{player}, 뮤탈로 프로브 견제!', stat: 'harass', enemyResource: -30),
        BuildStep(line: 35, text: '{player} 선수 히드라 추가 생산!', myArmy: 8, myResource: -20),
        BuildStep(line: 45, text: '{player}, 뮤탈 히드라 콤비네이션!', stat: 'attack', isClash: true),
      ],
    ),
  ];

  // ZvZ 빌드들
  static const zergVsZergBuilds = [
    // 1. 선풀 저글링 (Aggressive)
    BuildOrder(
      id: 'zvz_pool_first',
      name: '선풀 저글링',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 저글링 생산 시작!', myArmy: 6, myResource: -8),
        BuildStep(line: 8, text: '{player}, 저글링 싸움 시작!', stat: 'control', isClash: true),
        BuildStep(line: 15, text: '{player} 선수 해처리 건설!', myResource: -30),
        BuildStep(line: 25, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 35, text: '{player} 선수 뮤탈리스크 생산!', myArmy: 6, myResource: -15),
      ],
    ),

    // 2. 해처리 퍼스트 (Macro)
    BuildOrder(
      id: 'zvz_hatch_first',
      name: '해처리 퍼스트',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -30),
        BuildStep(line: 5, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 15, text: '{player}, 선링 방어!', stat: 'defense', isClash: true),
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 30, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 38, text: '{player} 선수 뮤탈리스크 생산!', myArmy: 8, myResource: -20),
      ],
    ),
  ];

  // ==================== 프로토스 빌드 ====================

  // PvT 빌드들
  static const protossVsTerranBuilds = [
    // 1. 드라군 사거리 (Balanced)
    BuildOrder(
      id: 'pvt_dragoon_range',
      name: '드라군 사거리',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 드라군 생산!', myArmy: 5, myResource: -12),
        BuildStep(line: 14, text: '{player}, 드라군 사거리 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 앞마당 넥서스 건설!', stat: 'macro', myResource: -40),
        BuildStep(line: 25, text: '{player}, 추가 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 32, text: '{player} 선수 드라군 추가 생산!', myArmy: 8, myResource: -25),
        BuildStep(line: 40, text: '{player}, 상대 앞마당 압박!', stat: 'attack', isClash: true),
      ],
    ),

    // 2. 리버 드랍 (Aggressive)
    BuildOrder(
      id: 'pvt_reaver_drop',
      name: '리버 드랍',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 로보틱스 건설!', myResource: -20),
        BuildStep(line: 15, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 리버 생산!', myArmy: 5, myResource: -20),
        BuildStep(line: 25, text: '{player}, 리버 드랍 출발!', stat: 'harass'),
        BuildStep(line: 28, text: '{player} 선수 리버 드랍 성공!', stat: 'harass', enemyArmy: -8, enemyResource: -35),
      ],
    ),

    // 3. 다크 투입 (Cheese)
    BuildOrder(
      id: 'pvt_dark_templar',
      name: '다크템플러 투입',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 시타델 건설!', myResource: -15),
        BuildStep(line: 15, text: '{player} 선수 템플러 아카이브 건설!', myResource: -20),
        BuildStep(line: 22, text: '{player}, 다크템플러 생산!', myArmy: 3, myResource: -15),
        BuildStep(line: 28, text: '{player}, 다크템플러 투입!', stat: 'strategy'),
        BuildStep(line: 30, text: '{player} 선수 다크로 일꾼 학살!', stat: 'harass', enemyArmy: -5, enemyResource: -40),
      ],
    ),
  ];

  // PvZ 빌드들
  static const protossVsZergBuilds = [
    // 1. 포지 캐논 (Defensive)
    BuildOrder(
      id: 'pvz_forge_cannon',
      name: '포지 캐논',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 넥서스 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 포지 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 포톤캐논 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 12, text: '{player}, 저글링 러쉬 방어!', stat: 'defense', myArmy: -2, enemyArmy: -8),
        BuildStep(line: 16, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 앞마당 넥서스 건설!', stat: 'macro', myResource: -40),
        BuildStep(line: 28, text: '{player} 선수 질럿 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 35, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
      ],
    ),

    // 2. 커세어 리버 (Aggressive)
    BuildOrder(
      id: 'pvz_corsair_reaver',
      name: '커세어 리버',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 15, text: '{player} 선수 커세어 생산!', myArmy: 4, myResource: -15),
        BuildStep(line: 18, text: '{player}, 커세어로 오버로드 사냥!', stat: 'harass', enemyArmy: -3),
        BuildStep(line: 22, text: '{player} 선수 로보틱스 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 리버 생산!', myArmy: 5, myResource: -20),
        BuildStep(line: 32, text: '{player}, 리버 드랍 출발!', stat: 'harass'),
        BuildStep(line: 35, text: '{player} 선수 리버 드랍 성공!', stat: 'harass', enemyArmy: -10, enemyResource: -35),
      ],
    ),

    // 3. 스톰 드랍 (Balanced)
    BuildOrder(
      id: 'pvz_storm_drop',
      name: '스톰 드랍',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 앞마당 넥서스 건설!', stat: 'macro', myResource: -40),
        BuildStep(line: 18, text: '{player} 선수 시타델 건설!', myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 템플러 아카이브 건설!', myResource: -20),
        BuildStep(line: 32, text: '{player} 선수 하이템플러 생산!', myArmy: 3, myResource: -15),
        BuildStep(line: 38, text: '{player}, 스톰 연구 완료!', stat: 'strategy', myResource: -15),
        BuildStep(line: 45, text: '{player}, 사이오닉 스톰!', stat: 'strategy', enemyArmy: -25),
        BuildStep(line: 50, text: '{player} 선수 스톰으로 히드라 초토화!', stat: 'control', enemyArmy: -30),
      ],
    ),
  ];

  // PvP 빌드들
  static const protossVsProtossBuilds = [
    // 1. 드라군 마이크로 (Balanced)
    BuildOrder(
      id: 'pvp_dragoon_micro',
      name: '드라군 마이크로',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 드라군 생산!', myArmy: 5, myResource: -12),
        BuildStep(line: 14, text: '{player}, 드라군 사거리 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 20, text: '{player}, 드라군 마이크로!', stat: 'control', isClash: true),
        BuildStep(line: 28, text: '{player} 선수 앞마당 넥서스 건설!', stat: 'macro', myResource: -40),
        BuildStep(line: 35, text: '{player} 선수 로보틱스 건설!', myResource: -20),
      ],
    ),

    // 2. 다크 러쉬 (Cheese)
    BuildOrder(
      id: 'pvp_dark_rush',
      name: '다크 러쉬',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 시타델 건설!', myResource: -15),
        BuildStep(line: 15, text: '{player} 선수 템플러 아카이브 건설!', myResource: -20),
        BuildStep(line: 22, text: '{player}, 다크템플러 생산!', myArmy: 3, myResource: -15),
        BuildStep(line: 26, text: '{player}, 다크템플러 투입!', stat: 'strategy'),
        BuildStep(line: 28, text: '{player} 선수 다크로 프로브 학살!', stat: 'harass', enemyArmy: -5, enemyResource: -40),
      ],
    ),
  ];

  // ==================== 충돌 시나리오 ====================

  /// 공격 vs 수비 충돌
  static const aggressiveVsDefensive = [
    ClashEvent(
      text: '{attacker} 선수 공격 들어갑니다!',
      attackerArmy: -5,
      defenderArmy: -3,
    ),
    ClashEvent(
      text: '{defender}, 완벽한 방어!',
      favorsStat: 'defense',
      attackerArmy: -10,
      defenderArmy: -2,
    ),
    ClashEvent(
      text: '{attacker}, 수비를 뚫습니다!',
      favorsStat: 'attack',
      attackerArmy: -5,
      defenderArmy: -12,
      defenderResource: -20,
    ),
    ClashEvent(
      text: '치열한 공방전입니다!',
      attackerArmy: -8,
      defenderArmy: -8,
    ),
    // 역전 이벤트
    ClashEvent(
      text: '{defender}, 물량 열세에서 환상적인 역습!',
      favorsStat: 'strategy',
      attackerArmy: -15,
      defenderArmy: -3,
      attackerResource: -25,
    ),
    ClashEvent(
      text: '{attacker}, 빈틈을 노린 기습 드랍!',
      favorsStat: 'harass',
      attackerArmy: -2,
      defenderArmy: -8,
      defenderResource: -35,
    ),
  ];

  /// 공격 vs 공격 충돌
  static const aggressiveVsAggressive = [
    ClashEvent(
      text: '양 선수 정면 충돌!',
      attackerArmy: -10,
      defenderArmy: -10,
    ),
    ClashEvent(
      text: '{attacker}, 컨트롤 싸움 승리!',
      favorsStat: 'control',
      attackerArmy: -5,
      defenderArmy: -15,
    ),
    ClashEvent(
      text: '{defender}, 역습 성공!',
      favorsStat: 'control',
      attackerArmy: -15,
      defenderArmy: -5,
    ),
    ClashEvent(
      text: '피터지는 전투입니다!',
      attackerArmy: -12,
      defenderArmy: -12,
    ),
    // 명장면 이벤트
    ClashEvent(
      text: '{attacker}, 환상적인 마이크로! 이것이 컨트롤입니다!',
      favorsStat: 'control',
      attackerArmy: -3,
      defenderArmy: -18,
    ),
    ClashEvent(
      text: '대단합니다! {defender} 선수 포커싱으로 핵심 유닛 제거!',
      favorsStat: 'control',
      attackerArmy: -20,
      defenderArmy: -5,
    ),
  ];

  /// 수비 vs 수비 충돌 (후반 대회전)
  static const defensiveVsDefensive = [
    ClashEvent(
      text: '양 선수 대치 중입니다...',
      attackerArmy: 0,
      defenderArmy: 0,
    ),
    ClashEvent(
      text: '조심스러운 진격!',
      attackerArmy: -2,
      defenderArmy: -2,
    ),
    ClashEvent(
      text: '최대 서플라이 대회전! 숨막히는 긴장감!',
      attackerArmy: -15,
      defenderArmy: -15,
    ),
    ClashEvent(
      text: '후반 물량 싸움! 자원이 승패를 가릅니다!',
      favorsStat: 'macro',
      attackerArmy: -10,
      defenderArmy: -10,
    ),
  ];

  // ==================== 명장면 이벤트 (특수) ====================

  /// 드랍 이벤트
  static const dropEvents = [
    ClashEvent(
      text: '{attacker} 선수, 드랍십 투입! 일꾼 라인 초토화!',
      favorsStat: 'harass',
      attackerArmy: -3,
      defenderArmy: -5,
      defenderResource: -40,
    ),
    ClashEvent(
      text: '{attacker} 선수, 리버 드랍! 스캐럽이 작렬합니다!',
      favorsStat: 'harass',
      attackerArmy: -2,
      defenderArmy: -12,
      defenderResource: -30,
    ),
    ClashEvent(
      text: '{defender}, 드랍 미리 읽었습니다! 완벽한 수비!',
      favorsStat: 'scout',
      attackerArmy: -8,
      defenderArmy: -2,
    ),
  ];

  /// 스톰/스펠 이벤트 (프로토스 vs 테란/저그)
  static const spellEventsPvTZ = [
    ClashEvent(
      text: '사이오닉 스톰! 상대 병력이 녹습니다!',
      favorsStat: 'strategy',
      attackerArmy: -25,
      defenderArmy: -5,
    ),
  ];

  /// 스톰/스펠 이벤트 (테란이 스톰 상대)
  static const spellEventsTvP = [
    ClashEvent(
      text: '{attacker}, 마린 스플릿! 스톰 피해 최소화!',
      favorsStat: 'control',
      attackerArmy: -8,
      defenderArmy: -3,
    ),
  ];

  /// 저그 스펠 이벤트 (저그 vs 테란)
  static const spellEventsZvT = [
    ClashEvent(
      text: '다크스웜 전개! 탱크 라인이 무력화됩니다!',
      favorsStat: 'strategy',
      attackerArmy: -5,
      defenderArmy: -3,
    ),
    ClashEvent(
      text: '디파일러 플레이그! 상대 병력 체력 급감!',
      favorsStat: 'strategy',
      attackerArmy: -3,
      defenderArmy: -15,
    ),
  ];

  /// 테란 스펠 이벤트 (테란 vs 저그)
  static const spellEventsTvZ = [
    ClashEvent(
      text: '이레디에이트! 뮤탈리스크 편대 박살!',
      favorsStat: 'strategy',
      attackerArmy: -2,
      defenderArmy: -12,
    ),
  ];

  /// 범용 스펠 이벤트 (모든 매치업)
  static const spellEventsGeneral = [
    ClashEvent(
      text: '결정적인 타이밍에 스킬 사용! 전세 역전!',
      favorsStat: 'strategy',
      attackerArmy: -5,
      defenderArmy: -12,
    ),
  ];

  /// 역전 이벤트
  static const comebackEvents = [
    ClashEvent(
      text: '{defender}, 불리한 상황에서 기적같은 역전!',
      favorsStat: 'sense',
      attackerArmy: -20,
      defenderArmy: -5,
      decisive: true,
    ),
    ClashEvent(
      text: '{defender}, 읽기 싸움 승리! 카운터 빌드 적중!',
      favorsStat: 'strategy',
      attackerArmy: -18,
      defenderArmy: -3,
    ),
    ClashEvent(
      text: '{defender}, 히든 테크로 상대 허를 찌릅니다!',
      favorsStat: 'strategy',
      attackerArmy: -15,
      defenderArmy: -2,
      attackerResource: -20,
    ),
  ];

  /// 저그 컨트롤 명장면 (저그 사용 시)
  static const microEventsZerg = [
    ClashEvent(
      text: '뮤탈 매직! 환상적인 뮤탈리스크 컨트롤!',
      favorsStat: 'control',
      attackerArmy: -2,
      defenderArmy: -15,
    ),
    ClashEvent(
      text: '저글링 서라운드! 병력을 감쌉니다!',
      favorsStat: 'control',
      attackerArmy: -8,
      defenderArmy: -15,
    ),
  ];

  /// 저그 vs 테란 전용 (럴커 홀드)
  static const microEventsZvT = [
    ClashEvent(
      text: '럴커 홀드! 바이오닉이 녹아내립니다!',
      favorsStat: 'defense',
      attackerArmy: -20,
      defenderArmy: -2,
    ),
  ];

  /// 테란 컨트롤 명장면 (테란 사용 시)
  static const microEventsTerran = [
    ClashEvent(
      text: '벌처 컨트롤! 마인을 피하며 일꾼 학살!',
      favorsStat: 'control',
      attackerArmy: -1,
      defenderArmy: -3,
      defenderResource: -30,
    ),
  ];

  /// 프로토스 컨트롤 명장면 (프로토스 사용 시)
  static const microEventsProtoss = [
    ClashEvent(
      text: '드라군 마이크로! 완벽한 포커싱!',
      favorsStat: 'control',
      attackerArmy: -5,
      defenderArmy: -12,
    ),
  ];

  /// 범용 컨트롤 명장면 (모든 매치업)
  static const microEventsGeneral = [
    ClashEvent(
      text: '환상적인 컨트롤! 피해 최소화!',
      favorsStat: 'control',
      attackerArmy: -3,
      defenderArmy: -10,
    ),
    ClashEvent(
      text: '완벽한 포커싱으로 핵심 유닛 제거!',
      favorsStat: 'control',
      attackerArmy: -5,
      defenderArmy: -12,
    ),
  ];

  /// 심리전 이벤트
  static const mindGameEvents = [
    ClashEvent(
      text: '{attacker}, 페이크 멀티로 상대 병력 분산!',
      favorsStat: 'strategy',
      attackerArmy: -2,
      defenderArmy: -8,
    ),
    ClashEvent(
      text: '{defender}, 타이밍 완벽히 읽었습니다! 카운터 준비 완료!',
      favorsStat: 'scout',
      attackerArmy: -12,
      defenderArmy: -3,
    ),
    ClashEvent(
      text: '{attacker}, 히든 베이스 발각되지 않았습니다!',
      favorsStat: 'sense',
      attackerResource: 30,
      defenderArmy: 0,
    ),
    ClashEvent(
      text: '{defender}, 정찰로 상대 빌드 완벽 파악!',
      favorsStat: 'scout',
      attackerArmy: -5,
      defenderArmy: -2,
    ),
  ];

  // ==================== 중후반 일반 이벤트 (빌드 스텝이 없을 때) ====================

  /// 멀티/확장 이벤트 (자원 증가)
  static const expansionEvents = [
    BuildStep(line: 0, text: '{player} 선수 멀티 확장 성공!', stat: 'macro', myResource: 25),
    BuildStep(line: 0, text: '{player}, 새로운 기지에서 자원 채취 시작!', stat: 'macro', myResource: 20),
    BuildStep(line: 0, text: '{player} 선수 자원 라인 풀가동!', stat: 'macro', myResource: 15),
    BuildStep(line: 0, text: '{player}, 확장 기지 완성! 경제력 상승!', stat: 'macro', myResource: 30),
    BuildStep(line: 0, text: '{player} 선수 일꾼 추가 생산!', stat: 'macro', myArmy: 1, myResource: 10),
    BuildStep(line: 0, text: '{player}, 가스 채취 가속!', stat: 'macro', myResource: 12),
  ];

  /// 병력 생산 이벤트 (병력 증가)
  static const productionEvents = [
    BuildStep(line: 0, text: '{player} 선수 병력 추가 생산!', myArmy: 5, myResource: -15),
    BuildStep(line: 0, text: '{player}, 주력 유닛 보충 중!', myArmy: 4, myResource: -12),
    BuildStep(line: 0, text: '{player} 선수 물량 빌드업!', stat: 'macro', myArmy: 6, myResource: -18),
    BuildStep(line: 0, text: '{player}, 테크 유닛 생산!', stat: 'strategy', myArmy: 3, myResource: -20),
    BuildStep(line: 0, text: '{player} 선수 공격 유닛 대량 생산!', stat: 'attack', myArmy: 7, myResource: -22),
  ];

  /// 테크 업그레이드 이벤트
  static const techEvents = [
    BuildStep(line: 0, text: '{player} 선수 업그레이드 완료!', stat: 'strategy', myArmy: 2, myResource: -10),
    BuildStep(line: 0, text: '{player}, 공격력 업그레이드!', stat: 'attack', myResource: -15),
    BuildStep(line: 0, text: '{player} 선수 방어력 업그레이드!', stat: 'defense', myResource: -15),
    BuildStep(line: 0, text: '{player}, 테크 트리 확장!', stat: 'strategy', myResource: -20),
  ];

  /// 소규모 교전 이벤트 (충돌 전 작은 전투)
  static const skirmishEvents = [
    BuildStep(line: 0, text: '{player} 선수 소규모 교전 승리!', stat: 'control', myArmy: -2, enemyArmy: -5),
    BuildStep(line: 0, text: '{player}, 정찰 유닛 교환!', stat: 'scout', myArmy: -1, enemyArmy: -2),
    BuildStep(line: 0, text: '{player} 선수 견제 성공!', stat: 'harass', myArmy: -1, enemyResource: -15),
    BuildStep(line: 0, text: '{player}, 상대 확장 견제!', stat: 'harass', enemyResource: -20),
    BuildStep(line: 0, text: '{player} 선수 상대 정찰 저지!', stat: 'defense', enemyArmy: -1),
  ];

  /// 중립/대치 이벤트 (변화 적음)
  static const neutralEvents = [
    BuildStep(line: 0, text: '양 선수 신중하게 운영 중입니다.', myResource: 5),
    BuildStep(line: 0, text: '팽팽한 대치 상황이 이어집니다.', myResource: 3),
    BuildStep(line: 0, text: '양측 모두 타이밍을 노리고 있습니다.', myResource: 4),
    BuildStep(line: 0, text: '조심스러운 움직임... 언제 터질지 모릅니다.', myResource: 3),
    BuildStep(line: 0, text: '양 선수 물량 축적 중입니다.', myArmy: 2, myResource: -3),
  ];

  /// 중후반 이벤트 가져오기 (빌드 스텝이 없을 때 사용)
  static BuildStep getMidLateEvent({
    required int lineCount,
    required int currentArmy,
    required int currentResource,
    required String race,
  }) {
    // 랜덤 시드
    final now = DateTime.now();
    final seed = now.millisecond + now.second * 1000;

    // 상황에 따른 이벤트 가중치
    List<BuildStep> candidates = [];

    // 자원이 낮으면 확장/자원 이벤트 우선
    if (currentResource < 100) {
      candidates.addAll(expansionEvents);
      candidates.addAll(expansionEvents); // 가중치 2배
      candidates.addAll(neutralEvents);
    }
    // 병력이 낮으면 생산 이벤트 우선
    else if (currentArmy < 60) {
      candidates.addAll(productionEvents);
      candidates.addAll(productionEvents); // 가중치 2배
      candidates.addAll(expansionEvents);
    }
    // 중반 (50줄 이전)
    else if (lineCount < 50) {
      candidates.addAll(expansionEvents);
      candidates.addAll(productionEvents);
      candidates.addAll(techEvents);
      candidates.addAll(skirmishEvents);
      candidates.addAll(neutralEvents);
    }
    // 중후반 (50~100줄)
    else if (lineCount < 100) {
      candidates.addAll(productionEvents);
      candidates.addAll(skirmishEvents);
      candidates.addAll(skirmishEvents); // 교전 증가
      candidates.addAll(techEvents);
      candidates.addAll(expansionEvents);
    }
    // 후반 (100줄 이후)
    else {
      candidates.addAll(productionEvents);
      candidates.addAll(productionEvents);
      candidates.addAll(skirmishEvents);
      candidates.addAll(skirmishEvents);
      candidates.addAll(skirmishEvents); // 교전 빈번
    }

    // 랜덤 선택
    return candidates[seed % candidates.length];
  }

  // ==================== 헬퍼 메서드 ====================

  /// 매치업과 스타일에 맞는 빌드 선택
  static BuildOrder? getBuildOrder({
    required String race,
    required String vsRace,
    required BuildStyle preferredStyle,
  }) {
    List<BuildOrder> candidates;

    // 매치업에 맞는 빌드 목록
    final matchupKey = '${race}v$vsRace';
    switch (matchupKey) {
      case 'TvZ':
        candidates = terranVsZergBuilds;
        break;
      case 'TvP':
        candidates = terranVsProtossBuilds;
        break;
      case 'TvT':
        candidates = terranVsTerranBuilds;
        break;
      case 'ZvT':
        candidates = zergVsTerranBuilds;
        break;
      case 'ZvP':
        candidates = zergVsProtossBuilds;
        break;
      case 'ZvZ':
        candidates = zergVsZergBuilds;
        break;
      case 'PvT':
        candidates = protossVsTerranBuilds;
        break;
      case 'PvZ':
        candidates = protossVsZergBuilds;
        break;
      case 'PvP':
        candidates = protossVsProtossBuilds;
        break;
      default:
        return null;
    }

    // 선호 스타일과 일치하는 빌드 우선
    final preferred = candidates.where((b) => b.style == preferredStyle).toList();
    if (preferred.isNotEmpty) {
      return preferred[DateTime.now().millisecond % preferred.length];
    }

    // 없으면 아무거나
    if (candidates.isNotEmpty) {
      return candidates[DateTime.now().millisecond % candidates.length];
    }

    return null;
  }

  /// 충돌 이벤트 가져오기 (매치업별 적절한 이벤트만 반환)
  static List<ClashEvent> getClashEvents(
    BuildStyle attackerStyle,
    BuildStyle defenderStyle, {
    String? attackerRace,
    String? defenderRace,
  }) {
    final baseEvents = <ClashEvent>[];

    // 기본 충돌 이벤트
    if (attackerStyle == BuildStyle.aggressive && defenderStyle == BuildStyle.defensive) {
      baseEvents.addAll(aggressiveVsDefensive);
    } else if (attackerStyle == BuildStyle.aggressive || defenderStyle == BuildStyle.aggressive) {
      baseEvents.addAll(aggressiveVsAggressive);
    } else {
      baseEvents.addAll(defensiveVsDefensive);
    }

    // 범용 이벤트 추가 (모든 경기에 적용)
    baseEvents.addAll(microEventsGeneral);
    baseEvents.addAll(mindGameEvents);
    baseEvents.addAll(spellEventsGeneral);

    // 매치업별 종족 특화 이벤트 추가
    if (attackerRace != null && defenderRace != null) {
      // 저그 공격자
      if (attackerRace == 'Z') {
        baseEvents.addAll(microEventsZerg);
        // ZvT 전용
        if (defenderRace == 'T') {
          baseEvents.addAll(microEventsZvT);
          baseEvents.addAll(spellEventsZvT);
        }
      }

      // 테란 공격자
      if (attackerRace == 'T') {
        baseEvents.addAll(microEventsTerran);
        // TvZ 전용
        if (defenderRace == 'Z') {
          baseEvents.addAll(spellEventsTvZ);
        }
        // TvP 전용
        if (defenderRace == 'P') {
          baseEvents.addAll(spellEventsTvP);
        }
      }

      // 프로토스 공격자
      if (attackerRace == 'P') {
        baseEvents.addAll(microEventsProtoss);
        // PvT, PvZ 전용 (스톰)
        if (defenderRace == 'T' || defenderRace == 'Z') {
          baseEvents.addAll(spellEventsPvTZ);
        }
      }

      // 저그 수비자
      if (defenderRace == 'Z') {
        baseEvents.addAll(microEventsZerg);
        // TvZ에서 저그가 수비자일 때
        if (attackerRace == 'T') {
          baseEvents.addAll(microEventsZvT);
          baseEvents.addAll(spellEventsZvT);
        }
      }

      // 테란 수비자
      if (defenderRace == 'T') {
        baseEvents.addAll(microEventsTerran);
        if (attackerRace == 'Z') {
          baseEvents.addAll(spellEventsTvZ);
        }
        if (attackerRace == 'P') {
          baseEvents.addAll(spellEventsTvP);
        }
      }

      // 프로토스 수비자
      if (defenderRace == 'P') {
        baseEvents.addAll(microEventsProtoss);
        if (attackerRace == 'T' || attackerRace == 'Z') {
          baseEvents.addAll(spellEventsPvTZ);
        }
      }
    }

    // 견제형이면 드랍 이벤트 추가
    if (attackerStyle == BuildStyle.aggressive || attackerStyle == BuildStyle.cheese) {
      baseEvents.addAll(dropEvents);
    }

    // 수비형이면 역전 이벤트 추가
    if (defenderStyle == BuildStyle.defensive) {
      baseEvents.addAll(comebackEvents);
    }

    return baseEvents;
  }

  /// 경기 단계별 특수 이벤트 가져오기
  static ClashEvent? getSpecialEvent({
    required int lineCount,
    required String homeRace,
    required String awayRace,
    required int homeArmy,
    required int awayArmy,
  }) {
    // 병력 열세 역전 가능성
    if (homeArmy < awayArmy * 0.6 || awayArmy < homeArmy * 0.6) {
      // 10% 확률로 역전 이벤트
      if (DateTime.now().millisecond % 10 == 0) {
        return comebackEvents[DateTime.now().millisecond % comebackEvents.length];
      }
    }

    // 중반 이후 스펠 이벤트
    if (lineCount >= 40) {
      if (DateTime.now().millisecond % 5 == 0) {
        return spellEventsGeneral[DateTime.now().millisecond % spellEventsGeneral.length];
      }
    }

    return null;
  }
}
