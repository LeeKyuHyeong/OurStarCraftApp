// 빌드오더 기반 이벤트 시스템
//
// 각 빌드는 순서대로 진행되는 이벤트 단계(step)를 가짐
// 양 선수가 각자의 빌드를 독립적으로 진행하며, 특정 시점에 충돌(clash) 발생

import 'dart:math';

import '../../domain/models/enums.dart' show BuildStyle, BuildType, GamePhase;
import '../../domain/models/game_map.dart';

export '../../domain/models/enums.dart' show BuildStyle, BuildType;

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
  final bool fixedCost;     // true면 모디파이어 미적용 (건물/유닛 생산용)

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
    this.fixedCost = false,
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
  final int? aggressionTier; // 오프닝 공격성 등급 (조합 빌드 시 오프닝에서 상속)

  const BuildOrder({
    required this.id,
    required this.name,
    required this.race,
    required this.vsRace,
    required this.style,
    required this.steps,
    this.aggressionTier,
  });
}

/// 오프닝 (초반 빌드, line 1~16) - 전 종족 공용
class RaceOpening {
  final String id;
  final String name;
  final String race;       // 'T', 'Z', 'P'
  final String vsRace;     // 'T', 'Z', 'P' (미러는 미사용)
  final BuildStyle style;
  final int aggressionTier; // 0~3
  final List<BuildStep> steps; // line 1~16

  const RaceOpening({
    required this.id,
    required this.name,
    required this.race,
    required this.vsRace,
    required this.style,
    required this.aggressionTier,
    required this.steps,
  });
}

/// 트랜지션 (중후반 빌드, line 20~) - 전 종족 공용
class RaceTransition {
  final String id;
  final String name;
  final String race;       // 'T', 'Z', 'P'
  final String vsRace;
  final BuildStyle style;
  final List<String> keyStats;
  final List<BuildStep> steps; // line 20~

  const RaceTransition({
    required this.id,
    required this.name,
    required this.race,
    required this.vsRace,
    required this.style,
    required this.keyStats,
    required this.steps,
  });
}


/// 빌드오더 데이터 저장소
class BuildOrderData {
  static final Random _random = Random();

  // ==================== 명명 상수 ====================

  // ==================== 테란 빌드 ====================

  // TvZ 빌드들 (7개 오프닝 기반)
  // BBS = 치즈, 2배럭아카데미 = 공격형, 배럭더블 = 밸런스, 111 = 밸런스, 팩토리더블 = 밸런스, 노배럭더블 = 수비형, 2스타레이스 = 공격형, 5배럭 = 공격형
  static const terranVsZergBuilds = [
    // 1. BBS (tvz_bbs - Cheese)
    BuildOrder(
      id: 'tvz_bbs',
      name: 'BBS',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 센터에 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 본진에 배럭 추가! BBS!', myResource: -10),
        BuildStep(line: 5, text: '{player} 선수 마린을 모읍니다.', myArmy: 3, myResource: -5),
        BuildStep(line: 7, text: '{player} 선수 SCV를 끌고 전진합니다!', stat: 'attack'),
        BuildStep(line: 10, text: '{player} 선수 벙커 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 마린 벙커 투입!', stat: 'attack', myArmy: 3, myResource: -5),
        BuildStep(line: 18, text: '{player} 선수 SCV 수리하면서 버팁니다!', stat: 'control', isClash: true),
        BuildStep(line: 22, text: '{player} 선수 추가 마린 도착!', stat: 'attack', myArmy: 3, myResource: -5, isClash: true),
        BuildStep(line: 25, text: '{player} 선수 끝장을 보려 합니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 2. 2배럭아카데미 (tvz_2bar_academy - Aggressive)
    BuildOrder(
      id: 'tvz_2bar_academy',
      name: '2배럭아카데미',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 2번째 배럭!', myResource: -10),
        BuildStep(line: 5, text: '{player} 선수 아카데미 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 마린 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 11, text: '{player} 선수 스팀팩 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 마린 메딕 물량으로 공격!', stat: 'attack', myArmy: 6, myResource: -15, isClash: true),
        BuildStep(line: 24, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 30, text: '{player} 선수 탱크 생산!', stat: 'defense', myArmy: 4, myResource: -20),
        BuildStep(line: 40, text: '{player} 선수 마린 메딕 탱크 조합!', stat: 'macro', myArmy: 10, myResource: -30),
      ],
    ),

    // 3. 배럭더블 (tvz_bar_double - Balanced)
    BuildOrder(
      id: 'tvz_bar_double',
      name: '배럭더블',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 11, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 18, text: '{player} 선수 벌처 생산!', stat: 'harass', myArmy: 2, myResource: -5),
        BuildStep(line: 24, text: '{player} 선수 아카데미 건설!', myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 마린 메딕 물량이 늘어납니다.', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
      ],
    ),

    // 4. 111 (tvz_111 - Balanced)
    BuildOrder(
      id: 'tvz_111',
      name: '111',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 11, text: '{player} 선수 벌처 생산! 정찰 나갑니다.', stat: 'scout', myArmy: 2, myResource: -5),
        BuildStep(line: 14, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 24, text: '{player} 선수 벌처 마인으로 견제!', stat: 'harass', enemyArmy: -3, enemyResource: -10),
        BuildStep(line: 30, text: '{player} 선수 탱크 벌처 전진!', stat: 'control', myArmy: 5, isClash: true),
        BuildStep(line: 40, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
      ],
    ),

    // 5. 팩토리더블 (tvz_fac_double - Balanced)
    BuildOrder(
      id: 'tvz_fac_double',
      name: '팩토리더블',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 벌처 생산! 정찰 및 저글링 견제.', stat: 'harass', myArmy: 2, myResource: -5),
        BuildStep(line: 11, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 벌처로 센터를 장악합니다.', stat: 'scout', myArmy: 2, myResource: -5),
        BuildStep(line: 18, text: '{player} 선수 마인 연구!', stat: 'harass', myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 36, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
      ],
    ),

    // 6. 노배럭더블 (tvz_nobar_double - Defensive)
    BuildOrder(
      id: 'tvz_nobar_double',
      name: '노배럭더블',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 앞마당 커맨드센터를 먼저 올립니다! 노배럭더블!', stat: 'macro', myResource: -40),
        BuildStep(line: 4, text: '{player} 선수 배럭 건설!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 10, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 13, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 16, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 벌처 생산!', stat: 'harass', myArmy: 2, myResource: -5),
        BuildStep(line: 26, text: '{player} 선수 아카데미 건설!', myResource: -15),
        BuildStep(line: 32, text: '{player} 선수 마린 메딕 물량이 늘어납니다.', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
      ],
    ),

    // 7. 2스타레이스 (tvz_2star - Aggressive)
    BuildOrder(
      id: 'tvz_2star',
      name: '2스타레이스',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 11, text: '{player} 선수 2번째 스타포트!', stat: 'harass', myResource: -25),
        BuildStep(line: 14, text: '{player} 선수 레이스 더블 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 레이스로 오버로드 사냥!', stat: 'harass', enemyArmy: -3),
        BuildStep(line: 22, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 28, text: '{player} 선수 레이스 추가 생산!', myArmy: 4, myResource: -15),
        BuildStep(line: 36, text: '{player} 선수 레이스 편대 완성!', stat: 'control', myArmy: 4, myResource: -15),
      ],
    ),

    // 8. 5배럭 (tvz_5bar - Aggressive)
    BuildOrder(
      id: 'tvz_5bar',
      name: '5배럭',
      race: 'T', vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', myResource: -20),
        BuildStep(line: 5, text: '{player} 선수 리파이너리 건설! 가스 채취를 시작합니다.', myResource: -5),
        BuildStep(line: 7, text: '{player} 선수 배럭을 추가합니다!', myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 아카데미 건설! 스팀팩 연구!', myResource: -15),
        BuildStep(line: 11, text: '{player} 선수 3번째 배럭!', myResource: -10),
        BuildStep(line: 14, text: '{player}, 4번째 배럭!', myResource: -10),
        BuildStep(line: 17, text: '{player}, 5번째 배럭까지 올립니다! 5배럭 체제!', myResource: -10),
        BuildStep(line: 20, text: '{player}, 마린 메딕 대량 생산!', stat: 'attack', myArmy: 7, myResource: -20),
        BuildStep(line: 25, text: '{player} 선수 메딕 합류! 물량이 쏟아집니다!', stat: 'control', myArmy: 4, myResource: -15),
        BuildStep(line: 30, text: '{player}, 5배럭 물량 푸시!', stat: 'attack', myArmy: 8, myResource: -20, isClash: true),
        BuildStep(line: 35, text: '{player} 선수 마린 메딕이 앞마당을 압박합니다!', stat: 'attack', enemyArmy: -5, isClash: true),
        BuildStep(line: 40, text: '{player}, 추가 병력 합류! 밀어붙입니다!', stat: 'attack', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

  ];

  // ==================== 테란 오프닝 데이터 (TvZ 6종 + TvP 4종) ====================

  static const terranOpeningsTvZ = [
    // 1. BBS (치즈 - 자체 완결)
    RaceOpening(race: 'T', id: 'tvz_bbs', name: 'BBS', vsRace: 'Z',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 센터에 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 본진에 배럭 추가! BBS!', myResource: -10),
        BuildStep(line: 5, text: '{player} 선수 마린을 모읍니다.', myArmy: 3, myResource: -5),
        BuildStep(line: 7, text: '{player} 선수 SCV를 끌고 전진합니다!', stat: 'attack'),
        BuildStep(line: 10, text: '{player} 선수 벙커 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 마린 벙커 투입!', stat: 'attack', myArmy: 3, myResource: -5),
        BuildStep(line: 18, text: '{player} 선수 SCV 수리하면서 버팁니다!', stat: 'control', isClash: true),
        BuildStep(line: 22, text: '{player} 선수 추가 마린 도착!', stat: 'attack', myArmy: 3, myResource: -5, isClash: true),
        BuildStep(line: 25, text: '{player} 선수 끝장을 보려 합니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 2배럭아카데미 (공격적)
    RaceOpening(race: 'T', id: 'tvz_2bar_academy', name: '2배럭아카데미', vsRace: 'Z',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 2번째 배럭!', myResource: -10),
        BuildStep(line: 5, text: '{player} 선수 아카데미 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 마린 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 11, text: '{player} 선수 스팀팩 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
      ],
    ),
    // 3. 배럭더블 (밸런스)
    RaceOpening(race: 'T', id: 'tvz_bar_double', name: '배럭더블', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 11, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 팩토리 건설!', myResource: -20),
      ],
    ),
    // 4. 111 (밸런스)
    RaceOpening(race: 'T', id: 'tvz_111', name: '111', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 11, text: '{player} 선수 벌처 생산! 정찰 나갑니다.', stat: 'scout', myArmy: 2, myResource: -5),
        BuildStep(line: 14, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
      ],
    ),
    // 5. 팩토리더블 (밸런스)
    RaceOpening(race: 'T', id: 'tvz_fac_double', name: '팩토리더블', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 벌처 생산! 정찰 및 저글링 견제.', stat: 'harass', myArmy: 2, myResource: -5),
        BuildStep(line: 11, text: '{player} 선수 앞마당 커맨드센터를 올립니다.', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 벌처로 센터를 장악합니다.', stat: 'scout', myArmy: 2, myResource: -5),
      ],
    ),
    // 6. 노배럭더블 (수비적)
    RaceOpening(race: 'T', id: 'tvz_nobar_double', name: '노배럭더블', vsRace: 'Z',
      style: BuildStyle.defensive, aggressionTier: 3,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 앞마당 커맨드센터를 먼저 올립니다! 노배럭더블!', stat: 'macro', myResource: -40),
        BuildStep(line: 4, text: '{player} 선수 배럭 건설!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 10, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 13, text: '{player} 선수 팩토리 건설!', myResource: -20),
      ],
    ),
    // 7. 2스타레이스 (공격적)
    RaceOpening(race: 'T', id: 'tvz_2star', name: '2스타레이스', vsRace: 'Z',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 리파이너리 건설.', myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 11, text: '{player} 선수 2번째 스타포트!', stat: 'harass', myResource: -25),
        BuildStep(line: 14, text: '{player} 선수 레이스 더블 생산!', stat: 'harass', myArmy: 4, myResource: -15),
      ],
    ),
  ];

  static const terranOpeningsTvP = [
    // 1. 센터 8배럭 (치즈 - 자체 완결)
    RaceOpening(race: 'T', id: 'tvp_bbs', name: '센터 8배럭', vsRace: 'P',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 8서플 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 2번째 배럭!', myResource: -10),
        BuildStep(line: 7, text: '{player}, 마린 더블 생산!', stat: 'attack', myArmy: 4, myResource: -10),
        BuildStep(line: 10, text: '{player} 선수 마린 푸시!', stat: 'attack'),
        BuildStep(line: 14, text: '{player}, 상대 본진 공격!', stat: 'control', isClash: true),
        BuildStep(line: 18, text: '{player} 선수 마린 추가 합류!', myArmy: 3, myResource: -5),
        BuildStep(line: 22, text: '{player}, 끝장 승부!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 원배럭 빠른팩 (공격적)
    RaceOpening(race: 'T', id: 'tvp_fast_fac', name: '원배럭 빠른팩', vsRace: 'P',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 9, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 시즈 탱크 생산!', stat: 'attack', myArmy: 5, myResource: -15),
        BuildStep(line: 16, text: '{player}, 시즈모드 연구!', myResource: -15),
      ],
    ),
    // 3. 빠른 멀티팩 (공격적)
    RaceOpening(race: 'T', id: 'tvp_multi_fac', name: '빠른 멀티팩', vsRace: 'P',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 6, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 10, text: '{player}, 아머리 건설!', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 1-1 업그레이드 시작!', stat: 'strategy', myResource: -30),
      ],
    ),
    // 4. 원배럭 더블 (밸런스)
    RaceOpening(race: 'T', id: 'tvp_1rax_double', name: '원배럭 더블', vsRace: 'P',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 9, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 13, text: '{player} 선수 팩토리 건설!', myResource: -20),
      ],
    ),
    // 5. 원팩토리 더블 (밸런스)
    RaceOpening(race: 'T', id: 'tvp_1fac_double', name: '원팩토리 더블', vsRace: 'P',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
      ],
    ),
    // 6. 노배럭 더블 (수비적)
    RaceOpening(race: 'T', id: 'tvp_norax_double', name: '노배럭 더블', vsRace: 'P',
      style: BuildStyle.defensive, aggressionTier: 3,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 커맨드센터 건설합니다!', stat: 'macro', myResource: -40),
        BuildStep(line: 5, text: '{player} 선수 배럭 건설!', myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 13, text: '{player} 선수 팩토리 건설!', myResource: -20),
      ],
    ),
  ];

  // ==================== 테란 트랜지션 데이터 (TvZ 6종 + TvP 6종) ====================

  static const terranTransitionsTvZ = [
    // 1. 바이오닉 (from tvz_2bar_academy)
    RaceTransition(race: 'T', id: 'tvz_trans_bionic', name: '바이오닉', vsRace: 'Z',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 24, text: '{player}, 탱크 생산! 맵 장악!', stat: 'harass', myArmy: 3, myResource: -30),
        BuildStep(line: 36, text: '{player}, 마린 메딕 푸시!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 50, text: '{player} 선수 멀티 포인트 공격!', stat: 'control', enemyArmy: -5),
        BuildStep(line: 60, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 75, text: '{player}, 마린 메딕 탱크 조합 완성!', stat: 'macro', myArmy: 15, myResource: -40),
      ],
    ),
    // 2. 메카닉 (from tvz_nobar_double)
    RaceTransition(race: 'T', id: 'tvz_trans_mech', name: '메카닉', vsRace: 'Z',
      style: BuildStyle.defensive, keyStats: ['defense', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 벙커 건설!', stat: 'defense', myArmy: 2, myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 24, text: '{player} 선수 골리앗 레인지 업!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 3번째 팩토리!', myResource: -20),
        BuildStep(line: 36, text: '{player} 선수 5번째 팩토리 건설!', myResource: -20),
        BuildStep(line: 40, text: '{player}, 골리앗 대량 생산!', stat: 'defense', myArmy: 10, myResource: -30),
        BuildStep(line: 48, text: '{player}, 골리앗 추가 생산!', stat: 'defense', myArmy: 8, myResource: -25),
        BuildStep(line: 54, text: '{player} 선수 시즈 탱크 생산 시작!', stat: 'strategy', myArmy: 4, myResource: -20),
        BuildStep(line: 66, text: '{player}, 시즈 탱크 골리앗 조합 완성!', stat: 'macro', myArmy: 18, myResource: -45),
      ],
    ),
    // 3. 111 밸런스 (from tvz_111)
    RaceTransition(race: 'T', id: 'tvz_trans_111_balance', name: '111 밸런스', vsRace: 'Z',
      style: BuildStyle.balanced, keyStats: ['strategy', 'defense'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player}, 레이스 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 레이스로 정찰! 상대 빌드 파악!', stat: 'scout', enemyArmy: -3),
        BuildStep(line: 34, text: '{player}, 벙커 건설로 앞마당 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 42, text: '{player}, 벌처 마인으로 상대 견제!', stat: 'harass', enemyArmy: -5, enemyResource: -10),
        BuildStep(line: 50, text: '{player} 선수 탱크 벌처 전진!', stat: 'control', myArmy: 5, isClash: true),
        BuildStep(line: 58, text: '{player}, 탱크 추가 생산!', stat: 'defense', myArmy: 8, myResource: -20),
        BuildStep(line: 78, text: '{player}, 탱크 바이오닉 조합 완성! 전진!', stat: 'macro', myArmy: 15, myResource: -35, isClash: true),
      ],
    ),
    // 4. 발키리 (from tvz_bar_double)
    RaceTransition(race: 'T', id: 'tvz_trans_valkyrie', name: '발키리', vsRace: 'Z',
      style: BuildStyle.defensive, keyStats: ['defense', 'control'],
      steps: [
        BuildStep(line: 18, text: '{player}, 스타포트 건설!', myResource: -25),
        BuildStep(line: 20, text: '{player}, 컨트롤타워 부착!', myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 발키리 생산!', stat: 'defense', myArmy: 4, myResource: -20),
        BuildStep(line: 28, text: '{player}, 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 40, text: '{player}, 발키리로 뮤탈 요격!', stat: 'defense', enemyArmy: -4),
        BuildStep(line: 56, text: '{player}, 발키리 추가 생산!', stat: 'defense', myArmy: 4, myResource: -20),
        BuildStep(line: 75, text: '{player}, 대공 완벽 장악!', stat: 'defense', enemyArmy: -5),
        BuildStep(line: 85, text: '{player} 선수 마린 메딕 발키리 조합 완성!', stat: 'macro', myArmy: 16, myResource: -40),
      ],
    ),
    // 5. 레이스 (from tvz_2star)
    RaceTransition(race: 'T', id: 'tvz_trans_wraith', name: '레이스', vsRace: 'Z',
      style: BuildStyle.aggressive, keyStats: ['harass', 'control'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 20, text: '{player}, 2번째 스타포트!', stat: 'harass', myResource: -25),
        BuildStep(line: 24, text: '{player} 선수 레이스 더블 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 28, text: '{player}, 레이스로 오버로드 사냥!', stat: 'harass', enemyArmy: -3),
        BuildStep(line: 34, text: '{player}, 드론 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 42, text: '{player}, 레이스 편대 완성!', stat: 'control', myArmy: 4, myResource: -15, isClash: true),
        BuildStep(line: 50, text: '{player} 선수 공중 장악 완료!', stat: 'harass', enemyArmy: -5, isClash: true, decisive: true),
      ],
    ),
    // 6. 5배럭 푸시 (from tvz_5bar)
    RaceTransition(race: 'T', id: 'tvz_trans_5bar', name: '5배럭 푸시', vsRace: 'Z',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 20, text: '{player}, 마린 메딕 대량 생산!', stat: 'attack', myArmy: 7, myResource: -20),
        BuildStep(line: 25, text: '{player} 선수 메딕 합류! 물량이 쏟아집니다!', stat: 'control', myArmy: 4, myResource: -15),
        BuildStep(line: 30, text: '{player}, 5배럭 물량 푸시!', stat: 'attack', myArmy: 8, myResource: -20, isClash: true),
        BuildStep(line: 35, text: '{player} 선수 마린 메딕이 앞마당을 압박합니다!', stat: 'attack', enemyArmy: -5, isClash: true),
        BuildStep(line: 40, text: '{player}, 추가 병력 합류! 밀어붙입니다!', stat: 'attack', myArmy: 5, isClash: true, decisive: true),
      ],
    ),
    // 7. 선엔베 3배럭 (from tvz_2bar_academy)
    RaceTransition(race: 'T', id: 'tvz_trans_enbe_3bar', name: '선엔베 3배럭', vsRace: 'Z',
      style: BuildStyle.aggressive, keyStats: ['attack', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player}, 마린 쏟아냅니다!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 22, text: '{player} 선수 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 26, text: '{player}, 스팀팩 연구 시작!', stat: 'attack', myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 35, text: '{player}, 마린 메딕 대규모 푸시!', stat: 'attack', myArmy: 8, myResource: -20, isClash: true),
        BuildStep(line: 40, text: '{player} 선수 상대 앞마당 압박!', stat: 'control', enemyArmy: -4, isClash: true),
        BuildStep(line: 45, text: '{player}, 추가 병력 합류! 밀어붙입니다!', stat: 'attack', myArmy: 5, isClash: true, decisive: true),
      ],
    ),
  ];

  static const terranTransitionsTvP = [
    // 1. 탱크 수비 (from tvp_double)
    RaceTransition(race: 'T', id: 'tvp_trans_tank_defense', name: '탱크 수비', vsRace: 'P',
      style: BuildStyle.defensive, keyStats: ['defense', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 시즈 탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 22, text: '{player}, 시즈모드 연구!', stat: 'defense', myResource: -15),
        BuildStep(line: 28, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 34, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 42, text: '{player} 선수 벌처 생산!', stat: 'harass', myArmy: 3, myResource: -10),
        BuildStep(line: 50, text: '{player}, 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 62, text: '{player} 선수 골리앗 대량 생산!', myArmy: 10, myResource: -30),
        BuildStep(line: 80, text: '{player}, 탱크 골리앗 조합 완성!', stat: 'macro', myArmy: 15, myResource: -40),
      ],
    ),
    // 2. 타이밍 푸시 (from tvp_fake_double)
    RaceTransition(race: 'T', id: 'tvp_trans_timing_push', name: '타이밍 푸시', vsRace: 'P',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 벌처 생산!', myArmy: 3, myResource: -8),
        BuildStep(line: 24, text: '{player}, 빠른 타이밍 푸시 준비!', stat: 'attack'),
        BuildStep(line: 28, text: '{player} 선수 탱크 벌처 전진!', stat: 'attack'),
        BuildStep(line: 32, text: '{player}, 상대 앞마당 압박!', stat: 'control', isClash: true),
        BuildStep(line: 38, text: '{player} 선수 탱크 추가 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player}, 결정적인 타이밍 푸시!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 3. 업그레이드 운영 (from tvp_1fac_gosu)
    RaceTransition(race: 'T', id: 'tvp_trans_upgrade', name: '업그레이드 운영', vsRace: 'P',
      style: BuildStyle.defensive, keyStats: ['strategy', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 아머리 건설!', myResource: -15),
        BuildStep(line: 22, text: '{player}, 지상 공격력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 34, text: '{player} 선수 지상 방어력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 52, text: '{player}, 사이언스 베슬 생산!', myArmy: 2, myResource: -20),
        BuildStep(line: 60, text: '{player} 선수 EMP 연구!', stat: 'strategy', myResource: -20),
        BuildStep(line: 72, text: '{player}, EMP로 하이템플러 무력화!', stat: 'strategy', enemyArmy: -5),
        BuildStep(line: 85, text: '{player} 선수 업그레이드 완료! 최종 푸시!', stat: 'attack', isClash: true),
      ],
    ),
    // 4. 바이오 메카닉 (from tvp_bar_double)
    RaceTransition(race: 'T', id: 'tvp_trans_bio_mech', name: '바이오 메카닉', vsRace: 'P',
      style: BuildStyle.defensive, keyStats: ['defense', 'macro'],
      steps: [
        BuildStep(line: 17, text: '{player}, 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 스팀팩 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 28, text: '{player}, 팩토리 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 42, text: '{player}, 마린 메딕 탱크 라인 방어!', stat: 'defense'),
        BuildStep(line: 60, text: '{player}, 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 72, text: '{player} 선수 골리앗 생산 시작!', myArmy: 8, myResource: -25),
        BuildStep(line: 85, text: '{player}, 마린 메딕 메카닉 조합 완성!', stat: 'macro', myArmy: 14, myResource: -40),
      ],
    ),
    // 5. 안티 캐리어 (from tvp_anti_carrier)
    RaceTransition(race: 'T', id: 'tvp_trans_anti_carrier', name: '안티 캐리어', vsRace: 'P',
      style: BuildStyle.balanced, keyStats: ['strategy', 'defense'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 골리앗 대량 생산!', stat: 'defense', myArmy: 8, myResource: -25),
        BuildStep(line: 24, text: '{player}, 아머리 건설!', myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 골리앗 레인지 업!', stat: 'strategy', myResource: -15),
        BuildStep(line: 36, text: '{player}, 스타포트 건설!', myResource: -25),
        BuildStep(line: 48, text: '{player}, 베슬 생산! EMP 연구!', stat: 'strategy', myArmy: 2, myResource: -40),
        BuildStep(line: 56, text: '{player} 선수 골리앗 추가 생산!', stat: 'defense', myArmy: 8, myResource: -25),
        BuildStep(line: 64, text: '{player}, EMP로 캐리어 실드 제거!', stat: 'strategy', enemyArmy: -5),
        BuildStep(line: 75, text: '{player} 선수 골리앗 대공 진형 완성!', stat: 'defense', myArmy: 10, myResource: -30, isClash: true),
      ],
    ),
  ];

  // TvP 빌드들
  // 팩더블 = 수비형, 타이밍 러쉬 = 공격형, 투팩 찌르기 = 공격형, 업테란 = 수비형, 배럭 더블 = 수비형, 마인 트리플 = 수비형, 노노사 = 치즈, FD테란 = 밸런스, 안티 캐리어 = 밸런스
  static const terranVsProtossBuilds = [
    // 0. 센터 8배럭 (tvp_bbs - Cheese, 자체완결)
    // BBS 2배럭 마린 러쉬. 센터 맵에서 높은 성공률
    BuildOrder(
      id: 'tvp_bbs',
      name: '센터 8배럭',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 8서플 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 2번째 배럭!', myResource: -10),
        BuildStep(line: 7, text: '{player}, 마린 더블 생산!', stat: 'attack', myArmy: 4, myResource: -10),
        BuildStep(line: 10, text: '{player} 선수 마린 푸시!', stat: 'attack'),
        BuildStep(line: 14, text: '{player}, 상대 본진 공격!', stat: 'control', isClash: true),
        BuildStep(line: 18, text: '{player} 선수 마린 추가 합류!', myArmy: 3, myResource: -5),
        BuildStep(line: 22, text: '{player}, 끝장 승부!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 1. 팩더블 (tvpDouble - Balanced)
    // 현 메타 국룰 정석. 팩토리 건설 후 앞마당 더블 확장
    BuildOrder(
      id: 'tvp_double',
      name: '팩더블',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 시즈 탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 22, text: '{player}, 시즈모드 연구!', stat: 'defense', myResource: -15),
        BuildStep(line: 28, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 34, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 42, text: '{player} 선수 벌처 생산!', stat: 'harass', myArmy: 3, myResource: -10),
        BuildStep(line: 50, text: '{player}, 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 62, text: '{player} 선수 골리앗 대량 생산!', myArmy: 10, myResource: -30),
        BuildStep(line: 80, text: '{player}, 탱크 골리앗 조합 완성!', stat: 'macro', myArmy: 15, myResource: -40),
      ],
    ),

    // 2. 타이밍 러쉬 (tvpFakeDouble - Aggressive)
    // 빠른 팩토리 탱크로 타이밍 공격
    BuildOrder(
      id: 'tvp_fake_double',
      name: '타이밍 러쉬',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 9, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 시즈 탱크 생산!', stat: 'attack', myArmy: 5, myResource: -15),
        BuildStep(line: 16, text: '{player}, 시즈모드 연구!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 벌처 생산!', myArmy: 3, myResource: -8),
        BuildStep(line: 24, text: '{player}, 빠른 타이밍 푸시 준비!', stat: 'attack'),
        BuildStep(line: 28, text: '{player} 선수 탱크 벌처 전진!', stat: 'attack'),
        BuildStep(line: 32, text: '{player}, 상대 앞마당 압박!', stat: 'control', isClash: true),
        BuildStep(line: 38, text: '{player} 선수 탱크 추가 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player}, 결정적인 타이밍 푸시!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 3. 투팩 찌르기 (tvp1FactDrop - Aggressive)
    // 팩토리 2개로 빠른 탱크 벌처 합류 공격
    BuildOrder(
      id: 'tvp_1fac_drop',
      name: '투팩 찌르기',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 9, text: '{player}, 2번째 팩토리!', myResource: -20),
        BuildStep(line: 12, text: '{player} 선수 시즈 탱크 더블 생산!', stat: 'attack', myArmy: 5, myResource: -15),
        BuildStep(line: 16, text: '{player}, 시즈모드 연구!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 벌처 생산!', stat: 'harass', myArmy: 3, myResource: -10),
        BuildStep(line: 24, text: '{player}, 탱크 벌처 합류!', stat: 'attack'),
        BuildStep(line: 28, text: '{player} 선수 상대 진영 찌르기!', stat: 'attack', isClash: true),
        BuildStep(line: 34, text: '{player}, 탱크 추가 합류!', myArmy: 5, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 45, text: '{player}, 투팩 물량으로 밀어붙입니다!', stat: 'attack', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

    // 4. 업테란 (tvp1FactGosu - Defensive)
    // 업그레이드 중심 운영. 지상 업그레이드 + 베슬 + EMP로 후반 전투 우위
    BuildOrder(
      id: 'tvp_1fac_gosu',
      name: '업테란',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 시즈 탱크 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 아머리 건설!', myResource: -15),
        BuildStep(line: 22, text: '{player}, 지상 공격력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 34, text: '{player} 선수 지상 방어력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 46, text: '{player} 선수 사이언스 퍼실리티 건설!', myResource: -20),
        BuildStep(line: 52, text: '{player}, 사이언스 베슬 생산!', myArmy: 2, myResource: -20),
        BuildStep(line: 60, text: '{player} 선수 EMP 연구!', stat: 'strategy', myResource: -20),
        BuildStep(line: 72, text: '{player}, EMP로 하이템플러 무력화!', stat: 'strategy', enemyArmy: -5),
        BuildStep(line: 85, text: '{player} 선수 업그레이드 완료! 최종 푸시!', stat: 'attack', isClash: true),
      ],
    ),

    // 5. 배럭 더블 (tvp_bar_double - Defensive)
    // 배럭 후 빠른 앞마당 확장. 마린 메딕 운영
    BuildOrder(
      id: 'tvp_bar_double',
      name: '배럭 더블',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player}, 빠른 앞마당 확장!', stat: 'macro', myResource: -40),
        BuildStep(line: 9, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 13, text: '{player} 선수 아카데미 건설!', myResource: -15),
        BuildStep(line: 17, text: '{player}, 메딕 생산 시작!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 스팀팩 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 28, text: '{player}, 팩토리 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 42, text: '{player}, 마린 메딕 탱크 라인 방어!', stat: 'defense'),
        BuildStep(line: 50, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 60, text: '{player}, 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 72, text: '{player} 선수 골리앗 생산 시작!', myArmy: 8, myResource: -25),
        BuildStep(line: 85, text: '{player}, 마린 메딕 메카닉 조합 완성!', stat: 'macro', myArmy: 14, myResource: -40),
      ],
    ),

    // 6. 마인 트리플 (tvp_mine_triple - Defensive)
    // 벌처 마인으로 방어 후 3기지 운영
    BuildOrder(
      id: 'tvp_mine_triple',
      name: '마인 트리플',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player}, 벌처 생산!', stat: 'harass', myArmy: 3, myResource: -10),
        BuildStep(line: 18, text: '{player} 선수 마인 연구!', stat: 'harass', myResource: -15),
        BuildStep(line: 22, text: '{player}, 마인 매설로 입구 방어!', stat: 'defense', enemyArmy: -3),
        BuildStep(line: 28, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 34, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 42, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 50, text: '{player}, 벌처 견제로 상대 멀티 압박!', stat: 'harass', enemyResource: -15),
        BuildStep(line: 58, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 68, text: '{player}, 골리앗 생산 시작!', myArmy: 8, myResource: -25),
        BuildStep(line: 78, text: '{player} 선수 자원 수급 안정!', stat: 'macro', myResource: 20),
        BuildStep(line: 88, text: '{player}, 탱크 골리앗 대군으로 진격!', stat: 'macro', myArmy: 16, myResource: -45),
      ],
    ),

    // 8. FD테란 (tvp_fd - Balanced)
    // 팩더블 변형. 팩토리 후 빠른 더블 확장, 밸런스 운영
    BuildOrder(
      id: 'tvp_fd',
      name: 'FD테란',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player}, 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 벙커 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 24, text: '{player}, 벌처 생산!', stat: 'harass', myArmy: 3, myResource: -10),
        BuildStep(line: 30, text: '{player} 선수 팩토리 추가!', myResource: -20),
        BuildStep(line: 38, text: '{player}, 벌처 견제로 드라군 사냥!', stat: 'harass', enemyArmy: -3),
        BuildStep(line: 46, text: '{player} 선수 3번째 멀티 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 54, text: '{player}, 탱크 라인 전개!', stat: 'defense'),
        BuildStep(line: 62, text: '{player} 선수 골리앗 생산!', myArmy: 8, myResource: -25),
        BuildStep(line: 75, text: '{player}, FD 운영 완성! 탱크 골리앗 진격!', stat: 'macro', myArmy: 14, myResource: -40),
      ],
    ),

    // 9. 안티 캐리어 (tvp_anti_carrier - Balanced)
    // 골리앗 중심 대공 + EMP. 캐리어 대비
    BuildOrder(
      id: 'tvp_anti_carrier',
      name: '안티 캐리어',
      race: 'T',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 10, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 14, text: '{player}, 팩토리 추가!', myResource: -20),
        BuildStep(line: 18, text: '{player} 선수 골리앗 대량 생산!', stat: 'defense', myArmy: 8, myResource: -25),
        BuildStep(line: 24, text: '{player}, 아머리 건설!', myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 골리앗 레인지 업!', stat: 'strategy', myResource: -15),
        BuildStep(line: 36, text: '{player}, 스타포트 건설!', myResource: -25),
        BuildStep(line: 42, text: '{player} 선수 사이언스 퍼실리티!', myResource: -20),
        BuildStep(line: 48, text: '{player}, 베슬 생산! EMP 연구!', stat: 'strategy', myArmy: 2, myResource: -40),
        BuildStep(line: 56, text: '{player} 선수 골리앗 추가 생산!', stat: 'defense', myArmy: 8, myResource: -25),
        BuildStep(line: 64, text: '{player}, EMP로 캐리어 실드 제거!', stat: 'strategy', enemyArmy: -5),
        BuildStep(line: 75, text: '{player} 선수 골리앗 대공 진형 완성!', stat: 'defense', myArmy: 10, myResource: -30, isClash: true),
      ],
    ),

  ];

  // TvT 빌드들
  // 원팩원스타 = 공격형, 투스타 레이스 = 공격형, 배럭더블 = 수비형
  static const terranVsTerranBuilds = [
    // 1. 원팩원스타 (tvt1Fac1Star - Aggressive)
    BuildOrder(
      id: 'tvt_1fac_1star',
      name: '원팩원스타',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 6, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 10, text: '{player} 선수 시즈 탱크 생산!', stat: 'attack', myArmy: 5, myResource: -15),
        BuildStep(line: 14, text: '{player}, 시즈모드 연구!', myResource: -15),
        BuildStep(line: 16, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 18, text: '{player}, 빠른 푸시 준비!', stat: 'attack'),
        BuildStep(line: 22, text: '{player} 선수 벌처 생산!', myArmy: 3, myResource: -8),
        BuildStep(line: 26, text: '{player}, 원팩 푸시 시작!', stat: 'attack'),
        BuildStep(line: 30, text: '{player}, 고지대 점령!', stat: 'control', isClash: true),
        BuildStep(line: 38, text: '{player}, 탱크 추가 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player} 선수 탱크 라인 전진!', stat: 'attack', isClash: true),
      ],
    ),

    // 2. 투스타 레이스 (tvt2Star - Aggressive)
    BuildOrder(
      id: 'tvt_2star',
      name: '투스타 레이스',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player} 선수 스타포트 건설!', stat: 'harass', myResource: -25),
        BuildStep(line: 12, text: '{player} 선수 레이스 생산!', myArmy: 4, myResource: -15),
        BuildStep(line: 15, text: '{player}, 레이스로 SCV 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 17, text: '{player}, 컨트롤타워 부착!', myResource: -10),
        BuildStep(line: 19, text: '{player} 선수 클로킹 연구!', stat: 'strategy', myResource: -20),
        BuildStep(line: 24, text: '{player}, 클로킹 레이스 투입!', stat: 'harass', enemyResource: -30),
        BuildStep(line: 28, text: '{player}, 레이스 추가 생산!', myArmy: 4, myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 앞마당 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 40, text: '{player}, 상대 탱크 라인 견제!', stat: 'harass', enemyArmy: -5),
        BuildStep(line: 50, text: '{player} 선수 시즈 탱크 생산!', myArmy: 6, myResource: -20),
        BuildStep(line: 60, text: '{player}, 레이스 탱크 조합!', stat: 'strategy', myArmy: 8, myResource: -25, isClash: true),
      ],
    ),

    // 3. 원배럭더블 (tvt1BarDouble - Defensive)
    BuildOrder(
      id: 'tvt_1bar_double',
      name: '원배럭더블',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 SCV 정찰!', stat: 'scout'),
        BuildStep(line: 5, text: '{player}, 빠른 앞마당 커맨드센터!', stat: 'macro', myResource: -40),
        BuildStep(line: 8, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 12, text: '{player}, 벙커 건설로 앞마당 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 16, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 20, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 24, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 28, text: '{player}, 시즈모드 연구!', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 2번째 팩토리!', stat: 'macro', myResource: -20),
        BuildStep(line: 40, text: '{player}, 탱크 더블 생산 시작!', myArmy: 5, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 자원 수급 안정!', stat: 'macro', myResource: 20),
        BuildStep(line: 56, text: '{player}, 스타포트 건설!', myResource: -25),
        BuildStep(line: 60, text: '{player} 선수 사이언스 퍼실리티!', myResource: -20),
        BuildStep(line: 65, text: '{player} 선수 베슬 생산!', stat: 'strategy', myArmy: 2, myResource: -20),
        BuildStep(line: 75, text: '{player}, 탱크 라인 전진 시작!', stat: 'strategy', isClash: true),
      ],
    ),

    // 3-2. 노배럭더블 (tvtNobarDouble - Defensive)
    // 배럭 없이 커맨드센터 먼저 → 극수비형. 초반 취약하지만 자원 우위
    BuildOrder(
      id: 'tvt_nobar_double',
      name: '노배럭더블',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 SCV 정찰!', stat: 'scout'),
        BuildStep(line: 3, text: '{player}, 배럭 없이 앞마당 커맨드센터!', stat: 'macro', myResource: -40),
        BuildStep(line: 6, text: '{player} 선수 뒤늦게 배럭 건설!', myResource: -10),
        BuildStep(line: 10, text: '{player}, 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 14, text: '{player} 선수 벙커 건설! 초반 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 18, text: '{player}, 팩토리 건설!', myResource: -20),
        BuildStep(line: 22, text: '{player} 선수 머신샵 부착!', myResource: -10),
        BuildStep(line: 26, text: '{player}, 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 시즈모드 연구!', myResource: -15),
        BuildStep(line: 36, text: '{player}, 더블 자원 가동! 2번째 팩토리!', stat: 'macro', myResource: -20, myArmy: 2),
        BuildStep(line: 44, text: '{player} 선수 탱크 더블 생산!', myArmy: 5, myResource: -15),
        BuildStep(line: 52, text: '{player}, 자원 수급 안정! 일꾼 풀가동!', stat: 'macro', myResource: 30),
        BuildStep(line: 58, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 64, text: '{player}, 사이언스 퍼실리티!', myResource: -20),
        BuildStep(line: 70, text: '{player} 선수 베슬 생산!', stat: 'strategy', myArmy: 2, myResource: -20),
        BuildStep(line: 80, text: '{player}, 물량 우위로 탱크 라인 전진!', stat: 'strategy', isClash: true),
      ],
    ),

    // 4. 투팩타이밍 (tvt2FacPush - Aggressive)
    // 팩토리 2개에서 벌처 대량 생산 → 초반 압박
    BuildOrder(
      id: 'tvt_2fac_push',
      name: '투팩타이밍',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player}, 벌처 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 12, text: '{player} 선수 2번째 팩토리!', myResource: -20),
        BuildStep(line: 16, text: '{player}, 벌처 속업 완료!', stat: 'control', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 스파이더 마인 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 24, text: '{player}, 벌처 대량 생산!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 벌처 러쉬!', stat: 'attack', myArmy: -3, enemyArmy: -4, enemyResource: -15, isClash: true),
        BuildStep(line: 36, text: '{player}, 마인 매설!', stat: 'harass', enemyArmy: -3),
        BuildStep(line: 42, text: '{player} 선수 벌처 추가 물량!', stat: 'control', myArmy: 4, myResource: -10),
        BuildStep(line: 52, text: '{player}, 시즈 탱크 전환!', stat: 'attack', myArmy: 5, myResource: -20),
        BuildStep(line: 65, text: '{player} 선수 탱크 라인 밀기!', stat: 'attack', myArmy: 3, isClash: true, decisive: true),
      ],
    ),

    // 5. 원팩더블 (tvt1FacDouble - Defensive)
    // 팩토리 1개 → 시즈탱크 → 확장. TvT 표준 빌드
    BuildOrder(
      id: 'tvt_1fac_double',
      name: '원팩더블',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 시즈 탱크 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 16, text: '{player}, 시즈모드 연구!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 앞마당 커맨드센터!', stat: 'macro', myResource: -40),
        BuildStep(line: 24, text: '{player}, 벙커 건설로 앞마당 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 2번째 팩토리!', stat: 'macro', myResource: -20),
        BuildStep(line: 32, text: '{player}, 탱크 추가 생산!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 38, text: '{player} 선수 벌처 생산! 마인 매설!', stat: 'harass', myArmy: 3, myResource: -8),
        BuildStep(line: 44, text: '{player}, 상대 초반 압박 방어!', stat: 'defense', myArmy: 2, isClash: true),
        BuildStep(line: 50, text: '{player} 선수 스타포트 건설!', myResource: -25),
        BuildStep(line: 56, text: '{player}, 탱크 물량 확보!', stat: 'macro', myArmy: 6, myResource: -20),
        BuildStep(line: 65, text: '{player} 선수 멀티 운영으로 탱크 라인 전진!', stat: 'strategy', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

    // 6. BBS (tvtBBS - Cheese)
    // 배럭 2개(센터+본진) → 마린 5기 → SCV 끌고 앞마당 벙커링 올인
    BuildOrder(
      id: 'tvt_bbs',
      name: 'BBS',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player}, 센터 배럭 건설!', stat: 'attack', myResource: -10),
        BuildStep(line: 6, text: '{player} 선수 마린 생산 시작!', myArmy: 2, myResource: -5),
        BuildStep(line: 9, text: '{player}, 마린 모으는 중!', myArmy: 3, myResource: -5),
        BuildStep(line: 12, text: '{player} 선수 SCV 끌고 출발합니다!', stat: 'scout'),
        BuildStep(line: 15, text: '{player}, 상대 앞마당 벙커 건설!', stat: 'attack', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 센터 배럭 마린 투입!', stat: 'control', myArmy: 2, isClash: true),
        BuildStep(line: 20, text: '{player}, SCV 수리하며 벙커링!', stat: 'control', isClash: true),
        BuildStep(line: 22, text: '{player} 선수 총공격! BBS 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 8. FD 러쉬 (tvtFdRush - Aggressive)
    // FD 러쉬 빌드 (상세 내용 추후 정리)
    BuildOrder(
      id: 'tvt_fd_rush',
      name: 'FD 러쉬',
      race: 'T',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 배럭 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 마린 연속 생산!', myArmy: 2, myResource: -5),
        BuildStep(line: 5, text: '{player} 선수 팩토리 건설!', myResource: -20),
        BuildStep(line: 8, text: '{player}, 머신샵 부착!', myResource: -10),
        BuildStep(line: 10, text: '{player} 선수 탱크 생산과 시즈모드 동시 시작!', stat: 'attack', myArmy: 5, myResource: -30),
        BuildStep(line: 14, text: '{player}, 마린과 탱크로 전진!', stat: 'attack', myArmy: 3),
        BuildStep(line: 18, text: '{player} 선수 앞마당 커맨드센터!', stat: 'macro', myResource: -40),
        BuildStep(line: 22, text: '{player}, 벌처 생산 시작!', myArmy: 3, myResource: -8),
        BuildStep(line: 28, text: '{player} 선수 추가 팩토리!', myResource: -20),
        BuildStep(line: 36, text: '{player}, 탱크 물량 전진!', stat: 'attack', myArmy: 5, myResource: -15),
        BuildStep(line: 45, text: '{player} 선수 탱크 라인 전진!', stat: 'attack', myArmy: 3, isClash: true, decisive: true),
      ],
    ),
  ];

  // ==================== 저그 빌드 ====================

  // ZvT 빌드들 (BuildType: zvt3HatchMutal(미친저그), zvt2HatchMutal, zvt2HatchLurker, zvt1HatchAllIn)
  static const zergVsTerranBuilds = [
    // ===== 기본 빌드 (5개) =====

    // 1. 4풀 (zvt_4pool - Cheese)
    // 4드론에 스포닝풀. 극 초반 저글링 러쉬로 SCV 학살
    BuildOrder(
      id: 'zvt_4pool',
      name: '4풀',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 4드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 저글링 6기 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 9, text: '{player} 선수 저글링 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 13, text: '{player}, SCV 학살!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 17, text: '{player} 선수 저글링 추가 생산!', stat: 'control', myArmy: 6, myResource: -8),
        BuildStep(line: 21, text: '{player}, 올인! 멈추지 않습니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 2. 9풀 (zvt_9pool - Aggressive)
    // 9드론에 스포닝풀. 저글링 견제 후 확장 → 뮤탈 전환
    BuildOrder(
      id: 'zvt_9pool',
      name: '9풀',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 12, text: '{player}, 저글링으로 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 34, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 뮤탈로 일꾼 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 48, text: '{player} 선수 뮤탈 추가 생산!', stat: 'control', myArmy: 5, myResource: -10),
        BuildStep(line: 56, text: '{player}, 뮤탈 물량으로 주도권 장악!', stat: 'control', myArmy: 4, enemyArmy: -5, isClash: true),
      ],
    ),

    // 3. 9오버풀 (zvt_9overpool - Aggressive)
    // 9드론에 오버로드 후 스포닝풀. 서플 관리 + 공격적 저글링 운영
    BuildOrder(
      id: 'zvt_9overpool',
      name: '9오버풀',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 오버로드!', myResource: -5),
        BuildStep(line: 6, text: '{player}, 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 14, text: '{player}, 저글링으로 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 18, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 24, text: '{player}, 저글링 추가 생산!', stat: 'attack', myArmy: 4, myResource: -5),
        BuildStep(line: 30, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 36, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 42, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 48, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 56, text: '{player} 선수 뮤탈 추가! 공중 장악!', stat: 'control', myArmy: 5, enemyArmy: -4, myResource: -10, isClash: true),
      ],
    ),

    // 4. 12풀 (zvt_12pool - Balanced)
    // 12드론에 스포닝풀. 안정적 확장 → 뮤탈/럴커 운영
    BuildOrder(
      id: 'zvt_12pool',
      name: '12풀',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player}, 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 34, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 48, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 56, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 64, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 72, text: '{player}, 뮤탈 럴커 조합으로 운영!', stat: 'macro', myArmy: 8, myResource: -20),
      ],
    ),

    // 4. 12앞 (zvt_12hatch - Balanced)
    // 12드론에 앞마당 해처리. 경제 우선 확장 → 뮤탈/럴커 전환
    BuildOrder(
      id: 'zvt_12hatch',
      name: '12앞',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 7, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player}, 선링 방어!', stat: 'defense'),
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 34, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 48, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 56, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 64, text: '{player}, 멀티에서 나오는 물량 압도!', stat: 'macro', myArmy: 10, myResource: -25),
      ],
    ),

    // 5. 노풀 3해처리 (zvt_3hatch_nopool - Defensive)
    // 스포닝풀 없이 3해처리 먼저. 극 수비적, 후반 울트라 지향
    BuildOrder(
      id: 'zvt_3hatch_nopool',
      name: '노풀 3해처리',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 5, text: '{player} 선수 3번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 10, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 16, text: '{player}, 드론 풀가동!', stat: 'macro', myResource: 20),
        BuildStep(line: 22, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 28, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 40, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 48, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 56, text: '{player} 선수 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 64, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 6, myResource: -15),
        BuildStep(line: 72, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 80, text: '{player}, 울트라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -30),
        BuildStep(line: 88, text: '{player}, 멀티 자원이 터집니다! 울트라 저글링 돌진!', stat: 'attack', myArmy: 12, myResource: -25, isClash: true),
      ],
    ),

    // ===== 특화 빌드 (4개) =====

    // 1. 미친 저그 (zvt3HatchMutal - Aggressive)
    // 럴커/디파일러 스킵 → 뮤탈 견제 후 울트라리스크 직행. 현 메타 공격형
    BuildOrder(
      id: 'zvt_3hatch_mutal',
      name: '미친 저그',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 16, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 20, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 26, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 32, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 5, myResource: -20),
        BuildStep(line: 36, text: '{player}, 뮤탈로 일꾼 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 39, text: '{player} 선수 퀸즈네스트 건설!', myResource: -15),
        BuildStep(line: 42, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 48, text: '{player}, 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 54, text: '{player} 선수 울트라리스크 캐번 건설!', stat: 'attack', myResource: -25),
        BuildStep(line: 60, text: '{player}, 울트라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -30),
        BuildStep(line: 68, text: '{player} 선수 울트라 방업!', stat: 'attack', myResource: -15),
        BuildStep(line: 75, text: '{player}, 울트라 저글링 돌진!', stat: 'attack', myArmy: 10, myResource: -25, isClash: true),
      ],
    ),

    // 2. 투해처리 뮤탈 (zvt2HatchMutal - Aggressive)
    BuildOrder(
      id: 'zvt_2hatch_mutal',
      name: '투해처리 뮤탈',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 22, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 28, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 8, myResource: -15),
        BuildStep(line: 32, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -30),
        BuildStep(line: 38, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 42, text: '{player}, 뮤탈 매직!', stat: 'control', enemyArmy: -6),
        BuildStep(line: 48, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 55, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 62, text: '{player} 선수 뮤탈 추가 생산!', stat: 'harass', myArmy: 5, myResource: -15),
        BuildStep(line: 70, text: '{player}, 뮤탈 히드라 조합 완성!', stat: 'macro', myArmy: 8, myResource: -25),
      ],
    ),

    // 3. 가드라 (zvt2HatchLurker - Defensive)
    // 가스+드론+럴커 빌드. 히드라 + 럴커 기반 수비 후 운영
    BuildOrder(
      id: 'zvt_2hatch_lurker',
      name: '가드라',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 익스트랙터 건설!', myResource: -5),
        BuildStep(line: 16, text: '{player}, 드론 풀가동!', stat: 'macro', myResource: 15),
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 히드라리스크 생산!', stat: 'defense', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 럴커 매복 포진!', stat: 'defense', enemyArmy: -8),
        BuildStep(line: 56, text: '{player}, 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 64, text: '{player} 선수 럴커 추가 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 68, text: '{player} 선수 퀸즈네스트 건설!', myResource: -15),
        BuildStep(line: 72, text: '{player}, 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 80, text: '{player} 선수 디파일러 마운드 건설!', myResource: -15),
        BuildStep(line: 88, text: '{player}, 디파일러 다크스웜으로 전진!', stat: 'macro', myArmy: 3, myResource: -15),
      ],
    ),

    // 4. 원해처리 럴커 (zvt1HatchAllIn - Aggressive)
    // 확장 없이 1베이스에서 빠른 럴커 테크 → 상대 앞마당/본진 올인 공격
    BuildOrder(
      id: 'zvt_1hatch_allin',
      name: '원해처리 럴커',
      race: 'Z',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 3, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 6, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 4, myResource: -5),
        BuildStep(line: 12, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 16, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 히드라리스크 생산!', stat: 'attack', myArmy: 4, myResource: -15),
        BuildStep(line: 24, text: '{player}, 럴커 아스펙트 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 럴커 변태! 공격 출발!', stat: 'attack', myArmy: 4, myResource: -10),
        BuildStep(line: 32, text: '{player}, 상대 앞마당 럴커 매복!', stat: 'attack', enemyArmy: -6, isClash: true),
        BuildStep(line: 36, text: '{player} 선수 럴커 추가! 올인 공격!', stat: 'attack', myArmy: 3, enemyArmy: -4, isClash: true, decisive: true),
      ],
    ),
  ];

  // ZvP 빌드들 (BuildType: zvp3HatchHydra(5해처리히드라), zvp2HatchMutal, zvpScourgeDefiler, zvp5DroneZergling, zvp973Hydra)
  static const zergVsProtossBuilds = [
    // ===== 기본 빌드 (5개) =====

    // 1. 4풀 (zvp_4pool - Cheese)
    // 4드론에 스포닝풀. 극 초반 저글링 러쉬로 프로브 학살
    BuildOrder(
      id: 'zvp_4pool',
      name: '4풀',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 4드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 저글링 6기 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 9, text: '{player} 선수 저글링 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 13, text: '{player}, 프로브 학살!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 17, text: '{player} 선수 저글링 추가 생산!', stat: 'control', myArmy: 6, myResource: -8),
        BuildStep(line: 21, text: '{player}, 올인! 멈추지 않습니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 2. 9풀 (zvp_9pool - Aggressive)
    // 9드론에 스포닝풀. 저글링 견제 후 히드라 전환
    BuildOrder(
      id: 'zvp_9pool',
      name: '9풀',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 12, text: '{player}, 저글링으로 프로브 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 40, text: '{player}, 히드라 물량 압박!', stat: 'attack', myArmy: 8, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 54, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 62, text: '{player}, 히드라 럴커 물량!', stat: 'macro', myArmy: 6, myResource: -15, isClash: true),
      ],
    ),

    // 3. 9오버풀 (zvp_9overpool - Aggressive)
    // 9드론에 오버로드 후 스포닝풀. 서플 관리 + 공격적 저글링 → 히드라 전환
    BuildOrder(
      id: 'zvp_9overpool',
      name: '9오버풀',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 오버로드!', myResource: -5),
        BuildStep(line: 6, text: '{player}, 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 14, text: '{player}, 저글링으로 프로브 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 18, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 24, text: '{player}, 저글링 추가 생산!', stat: 'attack', myArmy: 4, myResource: -5),
        BuildStep(line: 30, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 36, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 42, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 50, text: '{player}, 히드라 물량 압박!', stat: 'attack', myArmy: 8, myResource: -15),
        BuildStep(line: 58, text: '{player} 선수 럴커 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 66, text: '{player}, 히드라 럴커 물량!', stat: 'macro', myArmy: 6, myResource: -15, isClash: true),
      ],
    ),

    // 4. 12풀 (zvp_12pool - Balanced)
    // 12드론에 스포닝풀. 안정적 확장 → 히드라/럴커 운영
    BuildOrder(
      id: 'zvp_12pool',
      name: '12풀',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 40, text: '{player}, 히드라 추가 생산!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 54, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 62, text: '{player} 선수 히드라 럴커 조합으로 운영!', stat: 'macro', myArmy: 8, myResource: -20),
      ],
    ),

    // 4. 12앞 (zvp_12hatch - Balanced)
    // 12드론에 앞마당 해처리. 경제 우선 확장 → 히드라 물량
    BuildOrder(
      id: 'zvp_12hatch',
      name: '12앞',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 7, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player}, 선링 방어!', stat: 'defense'),
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 42, text: '{player}, 히드라 추가 생산!', stat: 'attack', myArmy: 8, myResource: -15),
        BuildStep(line: 50, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 56, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 64, text: '{player}, 멀티에서 나오는 물량 압도!', stat: 'macro', myArmy: 10, myResource: -25),
      ],
    ),

    // 5. 노풀 3해처리 (zvp_3hatch_nopool - Defensive)
    // 스포닝풀 없이 3해처리 먼저. 극 수비적, 후반 히드라 물량 지향
    BuildOrder(
      id: 'zvp_3hatch_nopool',
      name: '노풀 3해처리',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player}, 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 3번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 16, text: '{player}, 드론 풀가동!', stat: 'macro', myResource: 20),
        BuildStep(line: 22, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 28, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 34, text: '{player}, 히드라리스크 대량 생산!', stat: 'attack', myArmy: 12, myResource: -25),
        BuildStep(line: 42, text: '{player} 선수 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 50, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 56, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 64, text: '{player}, 5번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 72, text: '{player} 선수 히드라 럴커 물량!', stat: 'macro', myArmy: 15, myResource: -30),
        BuildStep(line: 80, text: '{player}, 압도적 물량으로 밀어붙입니다!', stat: 'attack', isClash: true),
      ],
    ),

    // ===== 특화 빌드 (7개) =====

    // 1. 5해처리 히드라 (zvp3HatchHydra - Aggressive)
    // 현 메타 정석. 5해처리까지 확장 후 히드라 물량으로 압박
    BuildOrder(
      id: 'zvp_3hatch_hydra',
      name: '5해처리 히드라',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 16, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 20, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 24, text: '{player}, 4번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 28, text: '{player} 선수 5번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 32, text: '{player} 선수 히드라리스크 대량 생산!', stat: 'attack', myArmy: 12, myResource: -30),
        BuildStep(line: 38, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 44, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 52, text: '{player}, 럴커로 질럿 학살!', stat: 'defense', enemyArmy: -15),
        BuildStep(line: 62, text: '{player} 선수 히드라 럴커 물량!', stat: 'macro', myArmy: 15, myResource: -40),
        BuildStep(line: 75, text: '{player}, 물량으로 밀어붙입니다!', stat: 'attack', isClash: true),
      ],
    ),

    // 2. 5뮤탈 (zvp2HatchMutal - Balanced)
    // 5기 뮤탈 생산 후 견제, 이후 히드라 전환
    BuildOrder(
      id: 'zvp_2hatch_mutal',
      name: '5뮤탈',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'strategy', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 저글링 소량 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 18, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 24, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 30, text: '{player} 선수 뮤탈리스크 5기 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 36, text: '{player}, 뮤탈로 프로브 견제!', stat: 'harass', enemyArmy: -3, enemyResource: -25),
        BuildStep(line: 42, text: '{player} 선수 히드라덴 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 50, text: '{player}, 3해처리 확장!', stat: 'strategy', myResource: -30),
        BuildStep(line: 58, text: '{player} 선수 히드라리스크 대량 생산!', stat: 'attack', myArmy: 12, myResource: -25),
        BuildStep(line: 66, text: '{player}, 히드라 뮤탈 콤비네이션!', stat: 'strategy', myArmy: 7, myResource: -15, isClash: true),
        BuildStep(line: 72, text: '{player}, 뮤탈 재생산! 히드라 뮤탈 투트랙!', stat: 'harass', myArmy: 4, myResource: -10),
        BuildStep(line: 78, text: '{player} 선수 물량으로 밀어붙입니다!', stat: 'attack', isClash: true),
      ],
    ),

    // 3. 하이브 운영 (zvpScourgeDefiler - Defensive)
    // 빠른 하이브 → 디파일러 → 다크스웜/플레이그로 후반 운영
    BuildOrder(
      id: 'zvp_scourge_defiler',
      name: '하이브 운영',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 16, text: '{player} 선수 저글링으로 정찰!', stat: 'strategy', myArmy: 4, myResource: -5),
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 25, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 28, text: '{player}, 스커지 생산으로 커세어 견제!', stat: 'strategy', myArmy: 4, myResource: -10),
        BuildStep(line: 36, text: '{player} 선수 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 44, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 52, text: '{player} 선수 히드라리스크 생산!', stat: 'macro', myArmy: 8, myResource: -20),
        BuildStep(line: 56, text: '{player} 선수 퀸즈네스트 건설!', myResource: -15),
        BuildStep(line: 60, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 70, text: '{player} 선수 디파일러 마운드 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 78, text: '{player}, 디파일러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 86, text: '{player}, 다크스웜 전개!', stat: 'strategy', enemyArmy: -8),
        BuildStep(line: 94, text: '{player}, 플레이그 투하!', stat: 'macro', enemyArmy: -15, isClash: true, decisive: true),
      ],
    ),

    // 4. 9투 올인 (zvp5DroneZergling - Cheese)
    // 9서플 투해처리 올인. 저글링 물량 올인
    BuildOrder(
      id: 'zvp_5drone',
      name: '9투 올인',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 9드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 투해처리 건설!', stat: 'attack', myResource: -30),
        BuildStep(line: 9, text: '{player} 선수 저글링 대량 생산!', stat: 'control', myArmy: 8, myResource: -10),
        BuildStep(line: 13, text: '{player}, 저글링 물량 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 17, text: '{player}, 저글링 추가 투입!', stat: 'control', myArmy: 8, myResource: -10),
        BuildStep(line: 21, text: '{player} 선수 프로브 올인!', stat: 'attack', enemyResource: -20, isClash: true, decisive: true),
      ],
    ),

    // 5. 973 히드라 (zvp973Hydra - Aggressive)
    // 9드론 7드론 3드론 타이밍에 히드라 웨이브. 프로토스 확장 전 타이밍 공격
    BuildOrder(
      id: 'zvp_973_hydra',
      name: '973 히드라',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 20, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 26, text: '{player} 선수 히드라 대량 생산!', stat: 'attack', myArmy: 10, myResource: -25),
        BuildStep(line: 30, text: '{player}, 히드라 레인지 업!', stat: 'control', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 973 타이밍!', stat: 'attack'),
        BuildStep(line: 38, text: '{player}, 히드라 웨이브 출발!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 42, text: '{player}, 상대 앞마당 압박!', stat: 'control', isClash: true),
        BuildStep(line: 48, text: '{player} 선수 히드라 물량으로 밀어붙입니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 6. 뮤커지 (zvpMukerji - Balanced)
    // 뮤탈리스크 + 스커지 조합. 공중 장악 후 지상 전환
    BuildOrder(
      id: 'zvp_mukerji',
      name: '뮤커지',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'harass', myResource: -30),
        BuildStep(line: 14, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 26, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 32, text: '{player}, 스커지 동시 생산!', stat: 'control', myArmy: 4, myResource: -10),
        BuildStep(line: 38, text: '{player}, 스커지로 커세어 격추!', stat: 'control', enemyArmy: -10),
        BuildStep(line: 46, text: '{player}, 뮤탈로 프로브 견제!', stat: 'harass', enemyArmy: -3, enemyResource: -25),
        BuildStep(line: 54, text: '{player} 선수 3해처리 확장!', stat: 'harass', myResource: -30),
        BuildStep(line: 60, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 66, text: '{player}, 디파일러 생산! 다크스웜 준비!', stat: 'strategy', myArmy: 5, myResource: -10),
        BuildStep(line: 74, text: '{player}, 히드라 지상군 전환!', stat: 'control', myArmy: 15, myResource: -25, isClash: true),
        BuildStep(line: 82, text: '{player} 선수 디파일러 다크스웜! 물량전!', stat: 'strategy', isClash: true),
      ],
    ),

    // 7. 야바위 (zvpYabarwi - Aggressive)
    // 기만 전술. 히드라덴 보여주고 뮤탈로 전환하거나, 뮤탈 가는 척 히드라 올인
    BuildOrder(
      id: 'zvp_yabarwi',
      name: '야바위',
      race: 'Z',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 앞마당 해처리 건설!', stat: 'strategy', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 히드라덴 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 16, text: '{player}, 상대 정찰에 히드라덴 노출!', stat: 'strategy'),
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', stat: 'strategy', myResource: -25),
        BuildStep(line: 32, text: '{player}, 뮤탈리스크 기습 생산!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 36, text: '{player}, 뮤탈로 기습 견제!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 40, text: '{player} 선수 히드라 추가 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 45, text: '{player}, 뮤탈 히드라 기만 공격!', stat: 'strategy', isClash: true, decisive: true),
      ],
    ),
  ];

  // ==================== 저그 오프닝 데이터 (ZvT 6종 + ZvP 6종) ====================

  static const zergOpeningsZvT = [
    // 1. 4풀 (치즈 - 트랜지션 없이 자체 완결)
    RaceOpening(race: 'Z',
      id: 'zvt_4pool', name: '4풀', vsRace: 'T',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 4드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 저글링 6기 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 9, text: '{player} 선수 저글링 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 13, text: '{player}, SCV 학살!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 17, text: '{player} 선수 저글링 추가 생산!', stat: 'control', myArmy: 6, myResource: -8),
        BuildStep(line: 21, text: '{player}, 올인! 멈추지 않습니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 9풀 (공격적)
    RaceOpening(race: 'Z',
      id: 'zvt_9pool', name: '9풀', vsRace: 'T',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 12, text: '{player}, 저글링으로 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
      ],
    ),
    // 3. 9오버풀 (공격적)
    RaceOpening(race: 'Z',
      id: 'zvt_9overpool', name: '9오버풀', vsRace: 'T',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 오버로드!', myResource: -5),
        BuildStep(line: 6, text: '{player}, 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 14, text: '{player}, 저글링으로 견제!', stat: 'harass', enemyResource: -15, isClash: true),
      ],
    ),
    // 4. 12풀 (밸런스)
    RaceOpening(race: 'Z',
      id: 'zvt_12pool', name: '12풀', vsRace: 'T',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
      ],
    ),
    // 5. 12앞 (밸런스)
    RaceOpening(race: 'Z',
      id: 'zvt_12hatch', name: '12앞', vsRace: 'T',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 7, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player}, 선링 방어!', stat: 'defense'),
      ],
    ),
    // 6. 노풀 3해처리 (수비적)
    RaceOpening(race: 'Z',
      id: 'zvt_3hatch_nopool', name: '노풀 3해처리', vsRace: 'T',
      style: BuildStyle.defensive, aggressionTier: 3,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player}, 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 3번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 16, text: '{player}, 드론 풀가동!', stat: 'macro', myResource: 20),
      ],
    ),
  ];

  static const zergOpeningsZvP = [
    // 1. 4풀 (치즈 - 트랜지션 없이 자체 완결)
    RaceOpening(race: 'Z',
      id: 'zvp_4pool', name: '4풀', vsRace: 'P',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 4드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 저글링 6기 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 9, text: '{player} 선수 저글링 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 13, text: '{player}, 프로브 학살!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 17, text: '{player} 선수 저글링 추가 생산!', stat: 'control', myArmy: 6, myResource: -8),
        BuildStep(line: 21, text: '{player}, 올인! 멈추지 않습니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 9풀 (공격적)
    RaceOpening(race: 'Z',
      id: 'zvp_9pool', name: '9풀', vsRace: 'P',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 12, text: '{player}, 저글링으로 프로브 견제!', stat: 'harass', enemyResource: -15, isClash: true),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
      ],
    ),
    // 3. 9오버풀 (공격적)
    RaceOpening(race: 'Z',
      id: 'zvp_9overpool', name: '9오버풀', vsRace: 'P',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 오버로드!', myResource: -5),
        BuildStep(line: 6, text: '{player}, 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 14, text: '{player}, 저글링으로 프로브 견제!', stat: 'harass', enemyResource: -15, isClash: true),
      ],
    ),
    // 4. 12풀 (밸런스)
    RaceOpening(race: 'Z',
      id: 'zvp_12pool', name: '12풀', vsRace: 'P',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
      ],
    ),
    // 5. 12앞 (밸런스)
    RaceOpening(race: 'Z',
      id: 'zvp_12hatch', name: '12앞', vsRace: 'P',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 7, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 16, text: '{player}, 선링 방어!', stat: 'defense'),
      ],
    ),
    // 6. 노풀 3해처리 (수비적)
    RaceOpening(race: 'Z',
      id: 'zvp_3hatch_nopool', name: '노풀 3해처리', vsRace: 'P',
      style: BuildStyle.defensive, aggressionTier: 3,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 해처리 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player}, 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 8, text: '{player} 선수 3번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 12, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 16, text: '{player}, 드론 풀가동!', stat: 'macro', myResource: 20),
      ],
    ),
    // 7. 9투 올인 (치즈 - 트랜지션 없이 자체 완결)
    RaceOpening(race: 'Z',
      id: 'zvp_5drone', name: '9투 올인', vsRace: 'P',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 9드론에 스포닝풀!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 투해처리 건설!', stat: 'attack', myResource: -30),
        BuildStep(line: 9, text: '{player} 선수 저글링 대량 생산!', stat: 'control', myArmy: 8, myResource: -10),
        BuildStep(line: 13, text: '{player}, 저글링 물량 돌진!', stat: 'attack', isClash: true),
        BuildStep(line: 17, text: '{player}, 저글링 추가 투입!', stat: 'control', myArmy: 8, myResource: -10),
        BuildStep(line: 21, text: '{player} 선수 프로브 올인!', stat: 'attack', enemyResource: -20, isClash: true, decisive: true),
      ],
    ),
  ];

  // ==================== 저그 트랜지션 데이터 ====================

  static const zergTransitionsZvT = [
    // 1. 뮤탈→울트라 (미친 저그에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_mutal_ultra', name: '뮤탈→울트라', vsRace: 'T',
      style: BuildStyle.aggressive, keyStats: ['attack', 'macro'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 26, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 32, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 5, myResource: -20),
        BuildStep(line: 36, text: '{player}, 뮤탈로 일꾼 견제!', stat: 'harass', enemyResource: -25),
        BuildStep(line: 39, text: '{player} 선수 퀸즈네스트 건설!', myResource: -15),
        BuildStep(line: 42, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 48, text: '{player}, 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 54, text: '{player} 선수 울트라리스크 캐번 건설!', stat: 'attack', myResource: -25),
        BuildStep(line: 60, text: '{player}, 울트라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -30),
        BuildStep(line: 68, text: '{player} 선수 울트라 방업!', stat: 'attack', myResource: -15),
        BuildStep(line: 75, text: '{player}, 울트라 저글링 돌진!', stat: 'attack', myArmy: 10, myResource: -25, isClash: true),
      ],
    ),
    // 2. 투해처리 뮤탈 (투해처리 뮤탈에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_2hatch_mutal', name: '투해처리 뮤탈', vsRace: 'T',
      style: BuildStyle.aggressive, keyStats: ['harass', 'control'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 28, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 8, myResource: -15),
        BuildStep(line: 32, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -30),
        BuildStep(line: 38, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 42, text: '{player}, 뮤탈 매직!', stat: 'control', enemyArmy: -6),
        BuildStep(line: 48, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 55, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 62, text: '{player} 선수 뮤탈 추가 생산!', stat: 'harass', myArmy: 5, myResource: -15),
        BuildStep(line: 70, text: '{player}, 뮤탈 히드라 조합 완성!', stat: 'macro', myArmy: 8, myResource: -25),
      ],
    ),
    // 3. 가드라→디파일러 (가드라에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_lurker_defiler', name: '가드라→디파일러', vsRace: 'T',
      style: BuildStyle.defensive, keyStats: ['macro', 'defense'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 히드라리스크 생산!', stat: 'defense', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 럴커 매복 포진!', stat: 'defense', enemyArmy: -8),
        BuildStep(line: 56, text: '{player}, 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 64, text: '{player} 선수 럴커 추가 변태!', stat: 'defense', myArmy: 4, myResource: -15),
        BuildStep(line: 72, text: '{player}, 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 80, text: '{player} 선수 디파일러 마운드 건설!', myResource: -15),
        BuildStep(line: 88, text: '{player}, 디파일러 다크스웜으로 전진!', stat: 'macro', myArmy: 3, myResource: -15),
      ],
    ),
    // 4. 원해처리 럴커 (원해처리 럴커에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_530_mutal', name: '원해처리 럴커', vsRace: 'T',
      style: BuildStyle.aggressive, keyStats: ['attack', 'strategy'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 히드라리스크 생산!', stat: 'attack', myArmy: 4, myResource: -15),
        BuildStep(line: 24, text: '{player}, 럴커 아스펙트 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 럴커 변태! 공격 출발!', stat: 'attack', myArmy: 4, myResource: -10),
        BuildStep(line: 32, text: '{player}, 상대 앞마당 럴커 매복!', stat: 'attack', enemyArmy: -6, isClash: true),
        BuildStep(line: 36, text: '{player} 선수 럴커 추가! 올인 공격!', stat: 'attack', myArmy: 3, enemyArmy: -4, isClash: true, decisive: true),
      ],
    ),
    // 5. 뮤탈→럴커 (기본 12풀에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_mutal_lurker', name: '뮤탈→럴커', vsRace: 'T',
      style: BuildStyle.balanced, keyStats: ['macro', 'harass'],
      steps: [
        BuildStep(line: 22, text: '{player}, 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 34, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 40, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 48, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 56, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 64, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 72, text: '{player}, 뮤탈 럴커 조합으로 운영!', stat: 'macro', myArmy: 8, myResource: -20),
      ],
    ),
    // 6. 울트라→하이브 (기본 노풀3해처리에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvt_trans_ultra_hive', name: '울트라→하이브', vsRace: 'T',
      style: BuildStyle.defensive, keyStats: ['macro', 'attack'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 28, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 40, text: '{player}, 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 48, text: '{player}, 뮤탈로 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 56, text: '{player} 선수 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 64, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 6, myResource: -15),
        BuildStep(line: 72, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 80, text: '{player}, 울트라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -30),
        BuildStep(line: 88, text: '{player}, 멀티 자원이 터집니다! 울트라 저글링 돌진!', stat: 'attack', myArmy: 12, myResource: -25, isClash: true),
      ],
    ),
  ];

  static const zergTransitionsZvP = [
    // 1. 5해처리 히드라 (5해처리 히드라에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_5hatch_hydra', name: '5해처리 히드라', vsRace: 'P',
      style: BuildStyle.aggressive, keyStats: ['macro', 'attack'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 24, text: '{player}, 4번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 28, text: '{player} 선수 5번째 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 32, text: '{player} 선수 히드라리스크 대량 생산!', stat: 'attack', myArmy: 12, myResource: -30),
        BuildStep(line: 38, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 44, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 52, text: '{player}, 럴커로 질럿 학살!', stat: 'defense', enemyArmy: -15),
        BuildStep(line: 62, text: '{player} 선수 히드라 럴커 물량!', stat: 'macro', myArmy: 15, myResource: -40),
        BuildStep(line: 75, text: '{player}, 물량으로 밀어붙입니다!', stat: 'attack', isClash: true),
      ],
    ),
    // 2. 뮤탈→히드라 (5뮤탈에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_mutal_hydra', name: '뮤탈→히드라', vsRace: 'P',
      style: BuildStyle.balanced, keyStats: ['harass', 'strategy'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 24, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 30, text: '{player} 선수 뮤탈리스크 5기 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 36, text: '{player}, 뮤탈로 프로브 견제!', stat: 'harass', enemyArmy: -3, enemyResource: -25),
        BuildStep(line: 42, text: '{player} 선수 히드라덴 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 50, text: '{player}, 3해처리 확장!', stat: 'strategy', myResource: -30),
        BuildStep(line: 58, text: '{player} 선수 히드라리스크 대량 생산!', stat: 'attack', myArmy: 12, myResource: -25),
        BuildStep(line: 66, text: '{player}, 히드라 뮤탈 콤비네이션!', stat: 'strategy', myArmy: 7, myResource: -15, isClash: true),
        BuildStep(line: 72, text: '{player}, 뮤탈 재생산! 히드라 뮤탈 투트랙!', stat: 'harass', myArmy: 4, myResource: -10),
        BuildStep(line: 78, text: '{player} 선수 물량으로 밀어붙입니다!', stat: 'attack', isClash: true),
      ],
    ),
    // 3. 하이브→디파일러 (하이브 운영에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_hive_defiler', name: '하이브→디파일러', vsRace: 'P',
      style: BuildStyle.defensive, keyStats: ['macro', 'strategy'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 25, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 28, text: '{player}, 스커지 생산으로 커세어 견제!', stat: 'strategy', myArmy: 4, myResource: -10),
        BuildStep(line: 36, text: '{player} 선수 4번째 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 44, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 52, text: '{player} 선수 히드라리스크 생산!', stat: 'macro', myArmy: 8, myResource: -20),
        BuildStep(line: 56, text: '{player} 선수 퀸즈네스트 건설!', myResource: -15),
        BuildStep(line: 60, text: '{player} 선수 하이브 건설!', stat: 'macro', myResource: -25),
        BuildStep(line: 70, text: '{player} 선수 디파일러 마운드 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 78, text: '{player}, 디파일러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 86, text: '{player}, 다크스웜 전개!', stat: 'strategy', enemyArmy: -8),
        BuildStep(line: 94, text: '{player}, 플레이그 투하!', stat: 'macro', enemyArmy: -15, isClash: true, decisive: true),
      ],
    ),
    // 4. 973 히드라 (973 히드라에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_973_hydra', name: '973 히드라', vsRace: 'P',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 20, text: '{player}, 3해처리 운영!', stat: 'macro', myResource: -30),
        BuildStep(line: 26, text: '{player} 선수 히드라 대량 생산!', stat: 'attack', myArmy: 10, myResource: -25),
        BuildStep(line: 30, text: '{player}, 히드라 레인지 업!', stat: 'control', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 973 타이밍!', stat: 'attack'),
        BuildStep(line: 38, text: '{player}, 히드라 웨이브 출발!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 42, text: '{player}, 상대 앞마당 압박!', stat: 'control', isClash: true),
        BuildStep(line: 48, text: '{player} 선수 히드라 물량으로 밀어붙입니다!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 5. 뮤커지 (뮤커지에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_mukerji', name: '뮤커지', vsRace: 'P',
      style: BuildStyle.balanced, keyStats: ['harass', 'control'],
      steps: [
        BuildStep(line: 20, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 26, text: '{player} 선수 뮤탈리스크 생산!', stat: 'harass', myArmy: 6, myResource: -15),
        BuildStep(line: 32, text: '{player}, 스커지 동시 생산!', stat: 'control', myArmy: 4, myResource: -10),
        BuildStep(line: 38, text: '{player}, 스커지로 커세어 격추!', stat: 'control', enemyArmy: -10),
        BuildStep(line: 46, text: '{player}, 뮤탈로 프로브 견제!', stat: 'harass', enemyArmy: -3, enemyResource: -25),
        BuildStep(line: 54, text: '{player} 선수 3해처리 확장!', stat: 'harass', myResource: -30),
        BuildStep(line: 60, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 66, text: '{player}, 디파일러 생산! 다크스웜 준비!', stat: 'strategy', myArmy: 5, myResource: -10),
        BuildStep(line: 74, text: '{player}, 히드라 지상군 전환!', stat: 'control', myArmy: 15, myResource: -25, isClash: true),
        BuildStep(line: 82, text: '{player} 선수 디파일러 다크스웜! 물량전!', stat: 'strategy', isClash: true),
      ],
    ),
    // 6. 야바위 (야바위에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_yabarwi', name: '야바위', vsRace: 'P',
      style: BuildStyle.aggressive, keyStats: ['strategy', 'attack'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 28, text: '{player} 선수 스파이어 건설!', stat: 'strategy', myResource: -25),
        BuildStep(line: 32, text: '{player}, 뮤탈리스크 기습 생산!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 36, text: '{player}, 뮤탈로 기습 견제!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 40, text: '{player} 선수 히드라 추가 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 45, text: '{player}, 뮤탈 히드라 기만 공격!', stat: 'strategy', isClash: true, decisive: true),
      ],
    ),
    // 7. 히드라→럴커 (기본 12풀에서 추출)
    RaceTransition(race: 'Z',
      id: 'zvp_trans_hydra_lurker', name: '히드라→럴커', vsRace: 'P',
      style: BuildStyle.balanced, keyStats: ['macro', 'attack'],
      steps: [
        BuildStep(line: 22, text: '{player} 선수 히드라덴 건설!', myResource: -15),
        BuildStep(line: 28, text: '{player}, 히드라리스크 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player} 선수 3해처리 확장!', stat: 'macro', myResource: -30),
        BuildStep(line: 40, text: '{player}, 히드라 추가 생산!', stat: 'attack', myArmy: 6, myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 54, text: '{player}, 럴커 변태!', stat: 'defense', myArmy: 5, myResource: -15),
        BuildStep(line: 62, text: '{player} 선수 히드라 럴커 조합으로 운영!', stat: 'macro', myArmy: 8, myResource: -20),
      ],
    ),
  ];

  // ZvZ 빌드들 (BuildType: zvz4Pool, zvz9PoolSpeed, zvz9PoolLair, zvz9OverPool, zvz12Pool, zvz12Hatch)
  static const zergVsZergBuilds = [
    // 1. 4풀 (zvz4Pool - Cheese)
    // 상대 해처리 퍼스트 읽고 저글링으로 4풀 러시
    BuildOrder(
      id: 'zvz_4pool',
      name: '4풀',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 스포닝풀 건설!', stat: 'scout', myResource: -15),
        BuildStep(line: 5, text: '{player}, 상대 해처리 퍼스트 확인!', stat: 'scout'),
        BuildStep(line: 9, text: '{player} 선수 저글링 6기 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 13, text: '{player}, 저글링 앞마당 진입!', stat: 'attack', isClash: true),
        BuildStep(line: 17, text: '{player}, 드론 학살!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 21, text: '{player} 선수 저글링 추가 생산! 4풀 러시!', stat: 'scout', myArmy: 6, myResource: -8, isClash: true, decisive: true),
      ],
    ),

    // 2-A. 9풀 발업 (zvz9PoolSpeed - Aggressive)
    // 9드론에 풀 → 저글링 + 발업 우선 → 라바를 저글링에 몰빵 → 압박으로 결착
    BuildOrder(
      id: 'zvz_9pool_speed',
      name: '9풀 발업',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 풀!', stat: 'strategy', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 6기 먼저 생산!', stat: 'attack', myArmy: 6, myResource: -5),
        BuildStep(line: 10, text: '{player}, 저글링 발업 연구! 가스에 자원을 묶습니다!', stat: 'control', myResource: -15),
        BuildStep(line: 12, text: '{player}, 저글링 찌르기 한 번!', stat: 'attack', enemyResource: -15, isClash: true),
        BuildStep(line: 14, text: '{player} 선수 라바를 전부 저글링에 돌립니다!', stat: 'attack', myArmy: 4, myResource: -8),
        BuildStep(line: 18, text: '{player}, 발업 완료! 저글링 속도가 붙습니다!', stat: 'control', myArmy: 2),
        BuildStep(line: 22, text: '{player} 선수 추가 저글링으로 두 번째 압박!', stat: 'attack', myArmy: 6, myResource: -10, isClash: true),
        BuildStep(line: 26, text: '{player} 선수 늦은 앞마당 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 32, text: '{player}, 발업 저글링으로 결착을 노립니다!', stat: 'attack', myArmy: 4, isClash: true, decisive: true),
      ],
    ),

    // 2-B. 9풀 레어 (zvz9PoolLair - Aggressive)
    // 9드론에 풀 → 저글링 4기만 → 빠른 앞마당 → 레어 → 스파이어 → 뮤탈 선점
    BuildOrder(
      id: 'zvz_9pool_lair',
      name: '9풀 레어',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 4, text: '{player} 선수 9드론에 풀!', stat: 'strategy', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 저글링 4기만 생산! 라바 절반은 드론으로!', stat: 'macro', myArmy: 4, myResource: -5),
        BuildStep(line: 10, text: '{player}, 가스 채취 시작! 발업은 스킵합니다!', stat: 'strategy', myResource: -8),
        BuildStep(line: 14, text: '{player} 선수 앞마당 해처리 빠르게!', stat: 'macro', myResource: -30),
        BuildStep(line: 18, text: '{player} 선수 레어 올립니다! 저글링은 수비형으로!', stat: 'strategy', myResource: -20),
        BuildStep(line: 22, text: '{player}, 성큰 콜로니로 입구 차단!', stat: 'defense', myArmy: 1, myResource: -12),
        BuildStep(line: 26, text: '{player} 선수 스파이어 건설 시작!', myResource: -25),
        BuildStep(line: 30, text: '{player}, 스포어 콜로니!', stat: 'defense', myArmy: 1, myResource: -10),
        BuildStep(line: 34, text: '{player}, 뮤탈리스크 선행 생산!', stat: 'control', myArmy: 8, myResource: -15),
        BuildStep(line: 38, text: '{player}, 뮤탈로 드론 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 42, text: '{player} 선수 뮤탈 추가 생산!', stat: 'strategy', myArmy: 5, myResource: -10),
        BuildStep(line: 48, text: '{player}, 뮤탈 물량으로 제공권 장악!', stat: 'control', myArmy: 3, enemyArmy: -5, isClash: true, decisive: true),
      ],
    ),

    // 3. 12앞 (zvz12Hatch - Balanced)
    BuildOrder(
      id: 'zvz_12hatch',
      name: '12앞',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 해처리!', stat: 'macro', myResource: -30),
        BuildStep(line: 10, text: '{player} 선수 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 15, text: '{player} 선수 저글링 생산!', myArmy: 4, myResource: -5),
        BuildStep(line: 18, text: '{player}, 선링 방어!', stat: 'defense', isClash: true),
        BuildStep(line: 24, text: '{player}, 저글링 추가!', myArmy: 6, myResource: -8),
        BuildStep(line: 30, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 36, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 40, text: '{player}, 스포어 콜로니 건설합니다.', stat: 'defense', myArmy: 1, myResource: -10),
        BuildStep(line: 46, text: '{player} 선수 뮤탈리스크 생산!', stat: 'control', myArmy: 8, myResource: -20),
        BuildStep(line: 54, text: '{player}, 뮤탈 물량 우세!', stat: 'macro', myArmy: 6, myResource: -15),
      ],
    ),

    // 4. 9오버풀 (zvz9OverPool - Aggressive)
    // 9드론에 오버로드 후 스포닝풀. 서플 관리 + 공격적 저글링 → 뮤탈 전환
    BuildOrder(
      id: 'zvz_9overpool',
      name: '9오버풀',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', myResource: 5),
        BuildStep(line: 3, text: '{player} 선수 9드론에 오버로드!', myResource: -5),
        BuildStep(line: 5, text: '{player}, 스포닝풀 건설!', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 저글링 생산!', stat: 'attack', myArmy: 6, myResource: -8),
        BuildStep(line: 11, text: '{player}, 저글링 발업 연구!', stat: 'control', myResource: -15),
        BuildStep(line: 12, text: '{player}, 저글링 싸움!', stat: 'control', isClash: true),
        BuildStep(line: 16, text: '{player} 선수 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player}, 저글링 추가!', myArmy: 4, myResource: -5),
        BuildStep(line: 28, text: '{player} 선수 레어 건설!', myResource: -20),
        BuildStep(line: 32, text: '{player} 선수 성큰 콜로니 건설!', stat: 'defense', myArmy: 1, myResource: -12),
        BuildStep(line: 34, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 38, text: '{player}, 스포어 콜로니 건설합니다.', stat: 'defense', myArmy: 1, myResource: -10),
        BuildStep(line: 42, text: '{player}, 뮤탈리스크 생산!', stat: 'control', myArmy: 8, myResource: -15),
        BuildStep(line: 48, text: '{player}, 뮤탈로 드론 견제!', stat: 'harass', enemyResource: -20),
        BuildStep(line: 56, text: '{player}, 뮤탈 물량으로 제공권 장악!', stat: 'control', myArmy: 4, enemyArmy: -4, isClash: true, decisive: true),
      ],
    ),

    // 5. 12풀 (zvz12Pool - Balanced)
    // 12드론 후 풀 → 가스 → 안정적 저글링+뮤탈 전환
    BuildOrder(
      id: 'zvz_12pool',
      name: '12풀',
      race: 'Z',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 드론 생산!', stat: 'macro', myResource: 8),
        BuildStep(line: 4, text: '{player} 선수 12드론에 스포닝풀!', myResource: -15),
        BuildStep(line: 8, text: '{player}, 가스 채취 시작!', myResource: -10),
        BuildStep(line: 12, text: '{player} 선수 저글링 생산!', myArmy: 6, myResource: -8),
        BuildStep(line: 16, text: '{player}, 앞마당 해처리 건설!', stat: 'macro', myResource: -30),
        BuildStep(line: 22, text: '{player} 선수 저글링 추가!', stat: 'defense', myArmy: 4, myResource: -5),
        BuildStep(line: 26, text: '{player}, 레어 건설!', myResource: -20),
        BuildStep(line: 30, text: '{player} 선수 저글링 속업 완료!', stat: 'control', myResource: -15),
        BuildStep(line: 36, text: '{player}, 저글링 싸움!', stat: 'control', myArmy: -3, enemyArmy: -4, isClash: true),
        BuildStep(line: 42, text: '{player} 선수 스파이어 건설!', myResource: -25),
        BuildStep(line: 46, text: '{player}, 스포어 콜로니 건설합니다.', stat: 'defense', myArmy: 1, myResource: -10),
        BuildStep(line: 52, text: '{player}, 뮤탈리스크 생산!', stat: 'control', myArmy: 8, myResource: -15),
        BuildStep(line: 60, text: '{player} 선수 뮤탈 물량! 멀티 운영 우세!', stat: 'macro', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

  ];

  // ==================== 프로토스 빌드 ====================

  // PvT 빌드들
  static const protossVsTerranBuilds = [
    // 0. 센터 게이트 (pvtProxyGate - Cheese)
    // 맵 중앙에 게이트웨이 건설. 빠른 질럿 러쉬
    BuildOrder(
      id: 'pvt_proxy_gate',
      name: '센터 게이트',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 맵 중앙에 파일런!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 센터 게이트웨이 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 11, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 15, text: '{player} 선수 질럿 투입!', stat: 'attack', isClash: true),
        BuildStep(line: 19, text: '{player}, 일꾼 사냥!', stat: 'control', enemyResource: -30),
        BuildStep(line: 23, text: '{player}, 질럿 추가!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 1. 선질럿 찌르기 (pvt2GateZealot - Aggressive)
    BuildOrder(
      id: 'pvt_2gate_zealot',
      name: '선질럿 찌르기',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 2번째 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 7, text: '{player} 선수 질럿 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 10, text: '{player}, 질럿 푸시!', stat: 'attack'),
        BuildStep(line: 14, text: '{player}, 상대 본진 압박!', stat: 'attack', isClash: true),
        BuildStep(line: 18, text: '{player}, 질럿 추가 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 드라군 생산!', myArmy: 4, myResource: -12),
        BuildStep(line: 34, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 42, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 50, text: '{player}, 지상군 푸시!', stat: 'attack', isClash: true),
      ],
    ),

    // 2. 초패스트다크 (pvtDarkSwing - Aggressive)
    BuildOrder(
      id: 'pvt_dark_swing',
      name: '초패스트다크',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 아둔 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 20, text: '{player}, 다크템플러 생산!', stat: 'harass', myArmy: 3, myResource: -15),
        BuildStep(line: 25, text: '{player}, 다크 드랍!', stat: 'strategy'),
        BuildStep(line: 28, text: '{player}, 다크로 일꾼 학살!', stat: 'harass', enemyArmy: -5, enemyResource: -40),
        BuildStep(line: 34, text: '{player}, 다크 추가 투입!', myArmy: 2, myResource: -10),
        BuildStep(line: 40, text: '{player} 선수 다크 공습!', stat: 'harass', enemyResource: -30, isClash: true, decisive: true),
      ],
    ),

    // 3. 23넥 아비터 (pvt1GateObserver - Defensive)
    // 현 메타 정석. 23서플라이에 넥서스 확장 → 옵저버 → 아비터 테크
    BuildOrder(
      id: 'pvt_1gate_obs',
      name: '23넥 아비터',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 10, text: '{player} 선수 드라군 생산!', myArmy: 3, myResource: -10),
        BuildStep(line: 14, text: '{player} 선수 23서플라이 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 18, text: '{player} 선수 로보틱스 건설!', stat: 'defense', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 옵저버토리 건설!', myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 옵저버 생산!', stat: 'scout', myArmy: 1, myResource: -10),
        BuildStep(line: 28, text: '{player}, 상대 빌드 정찰!', stat: 'scout'),
        BuildStep(line: 34, text: '{player} 선수 드라군 추가!', myArmy: 6, myResource: -18),
        BuildStep(line: 40, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 46, text: '{player} 선수 아둔!', myResource: -15),
        BuildStep(line: 52, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 58, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 64, text: '{player}, 아비터 트리뷰널 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 72, text: '{player} 선수 아비터 생산!', stat: 'strategy', myArmy: 2, myResource: -20),
        BuildStep(line: 80, text: '{player}, 리콜! 본진 기습!', stat: 'strategy', myArmy: 8, isClash: true),
      ],
    ),

    // 4. 전진로보 (pvtProxyDark - Aggressive)
    // 전진 배치 로보틱스로 리버 빠른 생산. 공격적 리버 드랍
    BuildOrder(
      id: 'pvt_proxy_dark',
      name: '전진로보',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 드라군 생산!', stat: 'control', myArmy: 2, myResource: -10),
        BuildStep(line: 12, text: '{player}, 전진 로보틱스 건설!', stat: 'attack', myResource: -20),
        BuildStep(line: 16, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 18, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 20, text: '{player}, 리버 생산 시작!', stat: 'attack', myArmy: 2, myResource: -15),
        BuildStep(line: 24, text: '{player} 선수 셔틀에 리버 탑승!', stat: 'control'),
        BuildStep(line: 28, text: '{player}, 리버 드랍!', stat: 'attack', enemyArmy: -6, enemyResource: -30, isClash: true),
        BuildStep(line: 32, text: '{player} 선수 리버 추가 생산!', stat: 'control', myArmy: 2, myResource: -15),
        BuildStep(line: 36, text: '{player}, 멀티 방면 리버 드랍!', stat: 'attack', enemyResource: -25),
        BuildStep(line: 40, text: '{player} 선수 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 45, text: '{player}, 리버 드랍과 지상군 동시 압박!', stat: 'control', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

    // 5. 19넥 (pvt1GateExpansion - Balanced)
    // 최신 메타 그리디 빌드. 19서플라이에 빠른 넥서스 → 리버 드랍 → 속셔틀 운영
    BuildOrder(
      id: 'pvt_1gate_expand',
      name: '19넥',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', stat: 'macro', myResource: -10),
        BuildStep(line: 7, text: '{player}, 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 19서플라이 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 13, text: '{player}, 드라군 추가 생산!', myArmy: 3, myResource: -10),
        BuildStep(line: 17, text: '{player} 선수 로보틱스 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 21, text: '{player}, 셔틀 생산!', stat: 'harass', myArmy: 1, myResource: -10),
        BuildStep(line: 23, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 25, text: '{player} 선수 리버 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 셔틀 속업 완료!', stat: 'harass', myResource: -15),
        BuildStep(line: 32, text: '{player}, 속셔틀 리버 드랍!', stat: 'harass', enemyResource: -25, isClash: true),
        BuildStep(line: 38, text: '{player} 선수 아둔 건설!', myResource: -15),
        BuildStep(line: 42, text: '{player} 선수 템플러 아카이브!', stat: 'strategy', myResource: -20),
        BuildStep(line: 50, text: '{player}, 하이템플러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 60, text: '{player}, 스톰 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 72, text: '{player} 선수 병력 모아서 푸시!', stat: 'attack', myArmy: 8, isClash: true),
      ],
    ),

    // 6. 생넥 캐리어 (pvtCarrier - Defensive)
    // 생(raw) 넥서스 확장 후 캐리어 테크. 후반 캐리어 운영
    BuildOrder(
      id: 'pvt_carrier',
      name: '생넥 캐리어',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산!', stat: 'macro', myArmy: 3, myResource: -10),
        BuildStep(line: 13, text: '{player}, 앞마당 생넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 16, text: '{player} 선수 포지 건설!', myResource: -10),
        BuildStep(line: 18, text: '{player} 선수 포톤캐논 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 23, text: '{player}, 드라군 추가 생산!', myArmy: 4, myResource: -12),
        BuildStep(line: 28, text: '{player} 선수 드라군 사거리 연구!', stat: 'strategy', myResource: -15),
        BuildStep(line: 34, text: '{player}, 상대 초반 압박 방어!', stat: 'defense', isClash: true),
        BuildStep(line: 40, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 48, text: '{player}, 스타게이트 추가!', stat: 'strategy', myResource: -25),
        BuildStep(line: 52, text: '{player} 선수 플릿 비콘 건설!', myResource: -15),
        BuildStep(line: 56, text: '{player} 선수 캐리어 생산 시작!', stat: 'macro', myArmy: 3, myResource: -25),
        BuildStep(line: 64, text: '{player}, 인터셉터 가득 충전!', stat: 'macro', myArmy: 4, myResource: -20),
        BuildStep(line: 72, text: '{player} 선수 캐리어 편대 완성!', stat: 'strategy', myArmy: 5, myResource: -25),
        BuildStep(line: 80, text: '{player}, 캐리어 함대 진격!', stat: 'macro', isClash: true),
        BuildStep(line: 88, text: '{player} 선수 공중 함대로 제압!', stat: 'strategy', myArmy: 4, isClash: true, decisive: true),
      ],
    ),

    // 7. 리버 후 속셔템 (pvtReaverShuttle - Balanced)
    // 로보 → 리버 → 셔틀 속업 후 빠른 견제
    BuildOrder(
      id: 'pvt_reaver_shuttle',
      name: '리버 후 속셔템',
      race: 'P',
      vsRace: 'T',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 13, text: '{player} 선수 로보틱스 건설!', stat: 'harass', myResource: -20),
        BuildStep(line: 16, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 18, text: '{player}, 리버 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 22, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 26, text: '{player}, 셔틀 속업 완료!', stat: 'harass', myResource: -15),
        BuildStep(line: 30, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 35, text: '{player}, 속셔틀 리버 출격!', stat: 'control', enemyResource: -25, isClash: true),
        BuildStep(line: 42, text: '{player} 선수 리버 추가 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 50, text: '{player}, 멀티 방면 속셔틀 견제!', stat: 'control', enemyArmy: -5, enemyResource: -20),
        BuildStep(line: 58, text: '{player} 선수 게이트웨이 추가!', myArmy: 5, myResource: -15),
        BuildStep(line: 66, text: '{player}, 드라군 물량 확보!', stat: 'macro', myArmy: 6, myResource: -18),
        BuildStep(line: 75, text: '{player} 선수 리버 셔틀과 지상군 동시 공격!', stat: 'control', myArmy: 4, isClash: true),
      ],
    ),
  ];

  // PvZ 빌드들
  static const protossVsZergBuilds = [
    // 1. 전진 2게이트 (pvz2GateZealot - Aggressive)
    // 센터 파일런 → 2게이트 → 질럿 러쉬로 앞마당 공격
    BuildOrder(
      id: 'pvz_2gate_zealot',
      name: '전진 2게이트',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브를 센터로 보냅니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 센터 파일런 건설!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player}, 2번째 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 18, text: '{player}, 질럿 추가 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 22, text: '{player} 선수 3질럿으로 앞마당 공격!', stat: 'control', isClash: true),
        BuildStep(line: 26, text: '{player}, 드론 사냥 시도!', stat: 'control', enemyResource: -25),
        BuildStep(line: 30, text: '{player} 선수 질럿 추가 투입!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 34, text: '{player}, 성큰 앞에서 교전!', stat: 'control', isClash: true),
        BuildStep(line: 38, text: '{player} 선수 앞마당 파괴 시도!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 2. 포지더블 (pvzForgeCannon - Balanced)
    // 현 메타 국룰 정석. 포지 + 캐논으로 앞마당 보호 후 더블 넥서스 운영
    BuildOrder(
      id: 'pvz_forge_cannon',
      name: '포지더블',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 넥서스 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 포지 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 7, text: '{player} 선수 포톤캐논 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 10, text: '{player}, 저글링 러쉬 방어!', stat: 'defense', myArmy: -2, enemyArmy: -8),
        BuildStep(line: 14, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 22, text: '{player} 선수 지상 공격력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 드라군 생산!', myArmy: 4, myResource: -12),
        BuildStep(line: 40, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 56, text: '{player}, 커세어 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 64, text: '{player}, 커세어로 오버로드 사냥!', stat: 'harass', enemyArmy: -5),
        BuildStep(line: 75, text: '{player} 선수 안정적 더블 운영!', stat: 'macro', myArmy: 10, myResource: -30),
      ],
    ),

    // 3. 선아둔 (pvzCorsairReaver - Balanced)
    // 아둔 선건설 → 질럿 발업 → 레그 질럿 + 아콘 조합
    BuildOrder(
      id: 'pvz_corsair_reaver',
      name: '선아둔',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 아둔 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 13, text: '{player}, 질럿 발업 완성!', stat: 'strategy', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 드라군 생산!', stat: 'macro', myArmy: 3, myResource: -12),
        BuildStep(line: 23, text: '{player}, 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 28, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 34, text: '{player}, 하이템플러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 아콘 합체!', stat: 'macro', myArmy: 4, myResource: -10),
        BuildStep(line: 48, text: '{player}, 레그 질럿 대량 생산!', stat: 'macro', myArmy: 6, myResource: -15),
        BuildStep(line: 56, text: '{player} 선수 질럿 아콘 조합 완성!', stat: 'strategy', myArmy: 4, myResource: -12),
        BuildStep(line: 64, text: '{player}, 지상군 진격!', stat: 'macro', isClash: true),
        BuildStep(line: 75, text: '{player} 선수 레그 질럿 아콘 최종 푸시!', stat: 'strategy', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

    // 4. 센터 게이트 (pvzProxyGate - Cheese)
    // 맵 중앙에 게이트웨이 건설. 빠른 질럿 러쉬
    BuildOrder(
      id: 'pvz_proxy_gate',
      name: '센터 게이트',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 맵 중앙에 파일런!', stat: 'attack', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 센터 게이트웨이 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 11, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 15, text: '{player} 선수 질럿 투입!', stat: 'attack', isClash: true),
        BuildStep(line: 19, text: '{player}, 드론 사냥!', stat: 'control', enemyResource: -30),
        BuildStep(line: 23, text: '{player}, 질럿 추가!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 5. 캐논 러쉬 (pvzCannonRush - Cheese)
    // 전진 포지 + 캐논으로 저그 앞마당 봉쇄
    BuildOrder(
      id: 'pvz_cannon_rush',
      name: '캐논 러쉬',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 상대 앞마당 전진 포지!', stat: 'sense', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 포톤캐논 건설!', stat: 'attack', myResource: -15),
        BuildStep(line: 12, text: '{player}, 캐논 추가 건설!', stat: 'attack', myResource: -15, enemyResource: -15),
        BuildStep(line: 16, text: '{player} 선수 앞마당 봉쇄!', stat: 'sense', enemyArmy: -4, enemyResource: -20, isClash: true),
        BuildStep(line: 20, text: '{player}, 캐논 포위망 완성!', stat: 'attack', enemyArmy: -5, enemyResource: -25),
        BuildStep(line: 25, text: '{player} 선수 캐논으로 해처리 파괴!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 6. 8겟뽕 (pvz8Gat - Cheese)
    // 8서플에 게이트웨이. 질럿 빠른 생산 올인
    BuildOrder(
      id: 'pvz_8gat',
      name: '8겟뽕',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 8서플라이 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 5, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 2, myResource: -8),
        BuildStep(line: 9, text: '{player} 선수 질럿 돌격!', stat: 'control'),
        BuildStep(line: 13, text: '{player}, 드론 학살!', stat: 'attack', enemyResource: -25, isClash: true),
        BuildStep(line: 17, text: '{player} 선수 질럿 추가 생산!', stat: 'control', myArmy: 3, myResource: -8),
        BuildStep(line: 21, text: '{player}, 저글링 상대 컨트롤!', stat: 'control', isClash: true),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 7. 투스타 커세어 (pvz2StarCorsair - Aggressive)
    // 스타게이트 2개로 커세어 대량 생산. 오버로드 학살 → 서플 블락
    BuildOrder(
      id: 'pvz_2star_corsair',
      name: '투스타 커세어',
      race: 'P',
      vsRace: 'Z',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 스타게이트 건설!', stat: 'harass', myResource: -25),
        BuildStep(line: 13, text: '{player}, 2번째 스타게이트!', stat: 'strategy', myResource: -25),
        BuildStep(line: 17, text: '{player} 선수 커세어 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 21, text: '{player}, 커세어 추가 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 오버로드 대량 학살!', stat: 'harass', enemyArmy: -8),
        BuildStep(line: 29, text: '{player}, 서플라이 블락!', stat: 'strategy', enemyResource: -25),
        BuildStep(line: 33, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 37, text: '{player}, 커세어 편대로 맵 장악!', stat: 'harass', enemyArmy: -4, isClash: true),
        BuildStep(line: 41, text: '{player} 선수 지상군 보강!', stat: 'strategy', myArmy: 6, myResource: -18),
        BuildStep(line: 45, text: '{player}, 공중 우세 속에 지상 푸시!', stat: 'strategy', myArmy: 5, isClash: true),
      ],
    ),
  ];

  // ── PvT 오프닝 ──
  static const protossOpeningsPvT = [
    // 1. 센터 게이트 (치즈 - 자체 완결) - 공통
    RaceOpening(race: 'P', id: 'pvt_proxy_gate', name: '센터 게이트', vsRace: 'T',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 맵 중앙에 파일런!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 센터 게이트웨이 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 11, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 15, text: '{player} 선수 질럿 투입!', stat: 'attack', isClash: true),
        BuildStep(line: 19, text: '{player}, 일꾼 사냥!', stat: 'control', enemyResource: -30),
        BuildStep(line: 23, text: '{player}, 질럿 추가!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 초패스트다크 (공격적 - 자체 완결)
    RaceOpening(race: 'P', id: 'pvt_dark_swing', name: '초패스트다크', vsRace: 'T',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 아둔 건설!', stat: 'strategy', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 20, text: '{player}, 다크템플러 생산!', stat: 'harass', myArmy: 3, myResource: -15),
        BuildStep(line: 25, text: '{player}, 다크 드랍!', stat: 'strategy'),
        BuildStep(line: 28, text: '{player}, 다크로 일꾼 학살!', stat: 'harass', enemyArmy: -5, enemyResource: -40),
        BuildStep(line: 34, text: '{player}, 다크 추가 투입!', myArmy: 2, myResource: -10),
        BuildStep(line: 40, text: '{player} 선수 다크 공습!', stat: 'harass', enemyResource: -30, isClash: true, decisive: true),
      ],
    ),
    // 3. 선질럿 (공격적 - 자체 완결)
    RaceOpening(race: 'P', id: 'pvt_2gate_open', name: '선질럿', vsRace: 'T',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 2번째 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 7, text: '{player} 선수 질럿 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 10, text: '{player}, 질럿 찌르기!', stat: 'attack'),
        BuildStep(line: 14, text: '{player}, 상대 본진 압박!', stat: 'attack', isClash: true),
        BuildStep(line: 18, text: '{player}, 질럿 추가 생산!', myArmy: 4, myResource: -10),
        BuildStep(line: 22, text: '{player} 선수 사이버네틱스 코어 올리고 드라군 전환합니다.', stat: 'macro', myResource: -15),
      ],
    ),
    // 4. 원게이트 더블 (밸런스)
    RaceOpening(race: 'P', id: 'pvt_1gate_double', name: '원게이트 사업넥', vsRace: 'T',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 7, text: '{player}, 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 드라군 사거리 연구!', stat: 'attack', myResource: -15),
        BuildStep(line: 12, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 15, text: '{player}, 드라군 추가 생산!', myArmy: 3, myResource: -10),
      ],
    ),
    // 5. 옵저버 더블 (밸런스)
    RaceOpening(race: 'P', id: 'pvt_obs_double', name: '옵저버 더블', vsRace: 'T',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 7, text: '{player}, 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 로보틱스 건설!', myResource: -20),
        BuildStep(line: 11, text: '{player} 선수 옵저버토리 건설!', myResource: -10),
        BuildStep(line: 13, text: '{player} 선수 옵저버 생산!', stat: 'scout', myArmy: 1, myResource: -10),
        BuildStep(line: 15, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
      ],
    ),
    // 6. 노게이트 더블 (수비적) - PvT 전용
    RaceOpening(race: 'P', id: 'pvt_nogate_double', name: '노게이트 더블', vsRace: 'T',
      style: BuildStyle.defensive, aggressionTier: 3,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 넥서스 건설합니다!', stat: 'macro', myResource: -40),
        BuildStep(line: 5, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 13, text: '{player}, 드라군 생산!', myArmy: 3, myResource: -10),
      ],
    ),
  ];

  // ── PvT 트랜지션 ──
  static const protossTransitionsPvT = [
    // 1. 5게이트 푸시 (공격적)
    RaceTransition(race: 'P', id: 'pvt_trans_5gate_push', name: '5게이트 푸시', vsRace: 'T',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 아둔 건설!', myResource: -15),
        BuildStep(line: 24, text: '{player}, 질럿 발업 완성!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 5게이트 가동! 드라군 + 발업질럿 대량 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player}, 상대 앞마당 교전!', stat: 'attack', isClash: true),
        BuildStep(line: 40, text: '{player} 선수 추가 병력 합류!', myArmy: 5, myResource: -15),
        BuildStep(line: 46, text: '{player}, 밀어붙이기!', stat: 'control', isClash: true, decisive: true),
      ],
    ),
    // 2. 5게이트 아비터 (밸런스)
    RaceTransition(race: 'P', id: 'pvt_trans_5gate_arbiter', name: '5게이트 아비터', vsRace: 'T',
      style: BuildStyle.balanced, keyStats: ['strategy', 'attack'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 아둔 건설!', myResource: -15),
        BuildStep(line: 24, text: '{player}, 질럿 발업 완성!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 5게이트 드라군 + 발업질럿 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player}, 상대 앞마당 교전!', stat: 'attack', isClash: true),
        BuildStep(line: 40, text: '{player} 선수 추가 멀티 확장!', stat: 'macro', myResource: -40),
        BuildStep(line: 46, text: '{player} 선수 템플러 아카이브 건설!', stat: 'strategy', myResource: -20),
        BuildStep(line: 52, text: '{player}, 하이템플러 + 스톰 연구!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 58, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 64, text: '{player}, 아비터 트리뷰널!', stat: 'strategy', myResource: -15),
        BuildStep(line: 72, text: '{player} 선수 아비터 생산!', stat: 'strategy', myArmy: 2, myResource: -20),
        BuildStep(line: 80, text: '{player}, 리콜! 본진 기습!', stat: 'strategy', myArmy: 8, isClash: true),
      ],
    ),
    // 3. 5게이트 캐리어 (수비적)
    RaceTransition(race: 'P', id: 'pvt_trans_5gate_carrier', name: '5게이트 캐리어', vsRace: 'T',
      style: BuildStyle.defensive, keyStats: ['macro', 'strategy'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 20, text: '{player} 선수 아둔 건설!', myResource: -15),
        BuildStep(line: 24, text: '{player}, 질럿 발업 완성!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 5게이트 드라군 + 발업질럿 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 34, text: '{player}, 상대 앞마당 교전!', stat: 'attack', isClash: true),
        BuildStep(line: 40, text: '{player} 선수 추가 멀티 확장!', stat: 'macro', myResource: -40),
        BuildStep(line: 48, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 52, text: '{player}, 스타게이트 추가!', stat: 'strategy', myResource: -25),
        BuildStep(line: 56, text: '{player} 선수 플릿 비콘 건설!', myResource: -15),
        BuildStep(line: 64, text: '{player}, 캐리어 생산!', stat: 'macro', myArmy: 3, myResource: -25),
        BuildStep(line: 72, text: '{player} 선수 인터셉터 충전! 캐리어 편대 완성!', stat: 'macro', myArmy: 5, myResource: -20),
        BuildStep(line: 80, text: '{player}, 캐리어 함대 진격!', stat: 'strategy', isClash: true),
        BuildStep(line: 88, text: '{player} 선수 공중 함대 제압!', stat: 'macro', myArmy: 4, isClash: true, decisive: true),
      ],
    ),
    // 4. 셔틀리버 푸시 (공격적)
    RaceTransition(race: 'P', id: 'pvt_trans_reaver_push', name: '셔틀리버 푸시', vsRace: 'T',
      style: BuildStyle.aggressive, keyStats: ['harass', 'control'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 로보틱스 건설!', stat: 'harass', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 23, text: '{player}, 리버 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 26, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 30, text: '{player}, 셔틀 속업 완료!', stat: 'harass', myResource: -15),
        BuildStep(line: 35, text: '{player} 선수 속셔틀 리버 드랍!', stat: 'control', enemyResource: -25, isClash: true),
        BuildStep(line: 42, text: '{player}, 리버 추가 + 게이트웨이 추가!', myArmy: 2, myResource: -15),
        BuildStep(line: 50, text: '{player} 선수 멀티 방면 견제!', stat: 'control', enemyArmy: -5, enemyResource: -20),
        BuildStep(line: 58, text: '{player}, 드라군 물량 합류!', stat: 'macro', myArmy: 6, myResource: -18),
        BuildStep(line: 66, text: '{player} 선수 리버 + 지상군 동시 푸시!', stat: 'control', myArmy: 4, isClash: true, decisive: true),
      ],
    ),
    // 5. 셔틀리버 아비터 (밸런스)
    RaceTransition(race: 'P', id: 'pvt_trans_reaver_arbiter', name: '셔틀리버 아비터', vsRace: 'T',
      style: BuildStyle.balanced, keyStats: ['harass', 'strategy'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 로보틱스 건설!', stat: 'harass', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 23, text: '{player}, 리버 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 26, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 30, text: '{player}, 셔틀 속업 완료!', stat: 'harass', myResource: -15),
        BuildStep(line: 35, text: '{player} 선수 속셔틀 리버 드랍!', stat: 'control', enemyResource: -25, isClash: true),
        BuildStep(line: 42, text: '{player} 선수 추가 멀티 확장!', stat: 'macro', myResource: -40),
        BuildStep(line: 48, text: '{player}, 아둔 + 템플러 아카이브!', stat: 'strategy', myResource: -35),
        BuildStep(line: 56, text: '{player} 선수 하이템플러 + 스톰 연구!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 64, text: '{player}, 스타게이트 + 아비터 트리뷰널!', stat: 'strategy', myResource: -40),
        BuildStep(line: 72, text: '{player} 선수 아비터 생산!', stat: 'strategy', myArmy: 2, myResource: -20),
        BuildStep(line: 80, text: '{player}, 리콜!', stat: 'strategy', myArmy: 8, isClash: true),
      ],
    ),
    // 6. 셔틀리버 캐리어 (수비적)
    RaceTransition(race: 'P', id: 'pvt_trans_reaver_carrier', name: '셔틀리버 캐리어', vsRace: 'T',
      style: BuildStyle.defensive, keyStats: ['harass', 'macro'],
      steps: [
        BuildStep(line: 17, text: '{player} 선수 로보틱스 건설!', stat: 'harass', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 23, text: '{player}, 리버 생산!', stat: 'harass', myArmy: 2, myResource: -15),
        BuildStep(line: 26, text: '{player} 선수 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 30, text: '{player}, 셔틀 속업 완료!', stat: 'harass', myResource: -15),
        BuildStep(line: 35, text: '{player} 선수 속셔틀 리버 드랍!', stat: 'control', enemyResource: -25, isClash: true),
        BuildStep(line: 42, text: '{player} 선수 추가 멀티 확장!', stat: 'macro', myResource: -40),
        BuildStep(line: 50, text: '{player}, 스타게이트 건설!', myResource: -25),
        BuildStep(line: 56, text: '{player} 선수 스타게이트 추가 + 플릿 비콘!', stat: 'strategy', myResource: -40),
        BuildStep(line: 64, text: '{player}, 캐리어 생산!', stat: 'macro', myArmy: 3, myResource: -25),
        BuildStep(line: 72, text: '{player} 선수 캐리어 편대 완성!', stat: 'macro', myArmy: 5, myResource: -20),
        BuildStep(line: 80, text: '{player}, 캐리어 함대 진격!', stat: 'strategy', isClash: true),
        BuildStep(line: 88, text: '{player} 선수 공중 함대 제압!', stat: 'macro', myArmy: 4, isClash: true, decisive: true),
      ],
    ),
  ];

  // ── PvZ 오프닝 ──
  static const protossOpeningsPvZ = [
    // 1. 센터 게이트 (치즈 - 자체 완결) - 공통
    RaceOpening(race: 'P', id: 'pvz_proxy_gate', name: '센터 게이트', vsRace: 'Z',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 맵 중앙에 파일런!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 센터 게이트웨이 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 11, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 15, text: '{player} 선수 질럿 투입!', stat: 'attack', isClash: true),
        BuildStep(line: 19, text: '{player}, 드론 사냥!', stat: 'control', enemyResource: -30),
        BuildStep(line: 23, text: '{player}, 질럿 추가!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 캐논 러쉬 (치즈 - 자체 완결) - PvZ 전용
    RaceOpening(race: 'P', id: 'pvz_cannon_rush', name: '캐논 러쉬', vsRace: 'Z',
      style: BuildStyle.cheese, aggressionTier: 0,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발합니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 상대 앞마당 전진 포지!', stat: 'sense', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 포톤캐논 건설!', stat: 'attack', myResource: -15),
        BuildStep(line: 12, text: '{player}, 캐논 추가 건설!', stat: 'attack', myResource: -15, enemyResource: -15),
        BuildStep(line: 16, text: '{player} 선수 앞마당 봉쇄!', stat: 'sense', enemyArmy: -4, enemyResource: -20, isClash: true),
        BuildStep(line: 20, text: '{player}, 캐논 포위망 완성!', stat: 'attack', enemyArmy: -5, enemyResource: -25),
        BuildStep(line: 25, text: '{player} 선수 캐논으로 해처리 파괴!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 3. 전진 2게이트 (공격적) - PvZ 전용
    RaceOpening(race: 'P', id: 'pvz_2gate_open', name: '전진 2게이트', vsRace: 'Z',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브를 센터로 보냅니다.', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 센터 파일런 건설!', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
        BuildStep(line: 10, text: '{player}, 2번째 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
      ],
    ),
    // 4. 투스타 커세어 (공격적 - 자체 완결) - PvZ 전용
    RaceOpening(race: 'P', id: 'pvz_2star_corsair', name: '투스타 커세어', vsRace: 'Z',
      style: BuildStyle.aggressive, aggressionTier: 1,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 스타게이트 건설!', stat: 'harass', myResource: -25),
        BuildStep(line: 13, text: '{player}, 2번째 스타게이트!', stat: 'strategy', myResource: -25),
        BuildStep(line: 17, text: '{player} 선수 커세어 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 21, text: '{player}, 커세어 추가 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 25, text: '{player} 선수 오버로드 대량 학살!', stat: 'harass', enemyArmy: -8),
        BuildStep(line: 29, text: '{player}, 서플라이 블락!', stat: 'strategy', enemyResource: -25),
        BuildStep(line: 33, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 37, text: '{player}, 커세어 편대로 맵 장악!', stat: 'harass', enemyArmy: -4, isClash: true),
        BuildStep(line: 41, text: '{player} 선수 지상군 보강!', stat: 'strategy', myArmy: 6, myResource: -18),
        BuildStep(line: 45, text: '{player}, 공중 우세 속에 지상 푸시!', stat: 'strategy', myArmy: 5, isClash: true),
      ],
    ),
    // 5. 원게이트 넥서스 (밸런스) - 공통
    RaceOpening(race: 'P', id: 'pvz_1gate_nexus', name: '원게이트 넥서스', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 7, text: '{player}, 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 13, text: '{player}, 드라군 추가 생산!', myArmy: 3, myResource: -10),
      ],
    ),
    // 6. 로보 넥서스 (밸런스) - 공통
    RaceOpening(race: 'P', id: 'pvz_robo_nexus', name: '로보 넥서스', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 3, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 6, text: '{player}, 드라군 생산!', stat: 'control', myArmy: 3, myResource: -10),
        BuildStep(line: 9, text: '{player} 선수 로보틱스 건설!', myResource: -20),
        BuildStep(line: 13, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
      ],
    ),
    // 7. 포지더블 (밸런스) - PvZ 전용 국룰
    RaceOpening(race: 'P', id: 'pvz_forge_open', name: '포지더블', vsRace: 'Z',
      style: BuildStyle.balanced, aggressionTier: 2,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 넥서스 건설합니다.', myResource: -10),
        BuildStep(line: 4, text: '{player} 선수 포지 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 7, text: '{player} 선수 포톤캐논 건설!', stat: 'defense', myResource: -15),
        BuildStep(line: 10, text: '{player}, 저글링 러쉬 방어!', stat: 'defense', myArmy: -2, enemyArmy: -8),
        BuildStep(line: 14, text: '{player} 선수 게이트웨이 건설!', myResource: -15),
      ],
    ),
  ];

  // ── PvZ 트랜지션 ──
  static const protossTransitionsPvZ = [
    // 1. 질럿 러쉬 (from pvz_2gate_zealot)
    RaceTransition(race: 'P', id: 'pvz_trans_dragoon_push', name: '질럿 러쉬', vsRace: 'Z',
      style: BuildStyle.aggressive, keyStats: ['attack', 'control'],
      steps: [
        BuildStep(line: 18, text: '{player}, 질럿 추가 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 22, text: '{player} 선수 3질럿으로 앞마당 공격!', stat: 'control', isClash: true),
        BuildStep(line: 26, text: '{player}, 드론 사냥 시도!', stat: 'control', enemyResource: -25),
        BuildStep(line: 30, text: '{player} 선수 질럿 추가 투입!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 34, text: '{player}, 성큰 앞에서 교전!', stat: 'control', isClash: true),
        BuildStep(line: 38, text: '{player} 선수 앞마당 파괴 시도!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),
    // 2. 커세어 운영 (from pvz_forge_cannon)
    RaceTransition(race: 'P', id: 'pvz_trans_corsair', name: '커세어 운영', vsRace: 'Z',
      style: BuildStyle.balanced, keyStats: ['harass', 'strategy'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 22, text: '{player} 선수 지상 공격력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 드라군 생산!', myArmy: 4, myResource: -12),
        BuildStep(line: 40, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 48, text: '{player} 선수 스타게이트 건설!', myResource: -25),
        BuildStep(line: 56, text: '{player}, 커세어 생산!', stat: 'harass', myArmy: 4, myResource: -15),
        BuildStep(line: 64, text: '{player}, 커세어로 오버로드 사냥!', stat: 'harass', enemyArmy: -5),
        BuildStep(line: 75, text: '{player} 선수 안정적 더블 운영!', stat: 'macro', myArmy: 10, myResource: -30),
      ],
    ),
    // 3. 아콘 조합 (from pvz_corsair_reaver)
    RaceTransition(race: 'P', id: 'pvz_trans_archon', name: '아콘 조합', vsRace: 'Z',
      style: BuildStyle.balanced, keyStats: ['strategy', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 드라군 생산!', stat: 'macro', myArmy: 3, myResource: -12),
        BuildStep(line: 23, text: '{player}, 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 28, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 34, text: '{player}, 하이템플러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 40, text: '{player} 선수 아콘 합체!', stat: 'macro', myArmy: 4, myResource: -10),
        BuildStep(line: 48, text: '{player}, 레그 질럿 대량 생산!', stat: 'macro', myArmy: 6, myResource: -15),
        BuildStep(line: 56, text: '{player} 선수 질럿 아콘 조합 완성!', stat: 'strategy', myArmy: 4, myResource: -12),
        BuildStep(line: 64, text: '{player}, 지상군 진격!', stat: 'macro', isClash: true),
        BuildStep(line: 75, text: '{player} 선수 레그 질럿 아콘 최종 푸시!', stat: 'strategy', myArmy: 5, isClash: true, decisive: true),
      ],
    ),
    // 4. 포지 확장 운영 (from pvz_forge_cannon)
    RaceTransition(race: 'P', id: 'pvz_trans_forge_expand', name: '포지 확장 운영', vsRace: 'Z',
      style: BuildStyle.balanced, keyStats: ['defense', 'macro'],
      steps: [
        BuildStep(line: 18, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 22, text: '{player} 선수 지상 공격력 업그레이드!', stat: 'strategy', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 드라군 생산!', myArmy: 4, myResource: -12),
        BuildStep(line: 40, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 46, text: '{player} 선수 아둔!', myResource: -15),
        BuildStep(line: 52, text: '{player} 선수 템플러 아카이브!', stat: 'strategy', myResource: -20),
        BuildStep(line: 58, text: '{player}, 하이템플러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 66, text: '{player} 선수 아콘 합체!', stat: 'macro', myArmy: 4, myResource: -10),
        BuildStep(line: 75, text: '{player}, 업그레이드 완료 후 진격!', stat: 'macro', myArmy: 8, isClash: true),
      ],
    ),
  ];

  // PvP 빌드들
  static const protossVsProtossBuilds = [
    // 1. 옵3겟 (pvp2GateDragoon - Balanced)
    // 옵저버 → 3게이트 드라군 운영
    BuildOrder(
      id: 'pvp_2gate_dragoon',
      name: '옵3겟',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.balanced,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산!', stat: 'defense', myArmy: 3, myResource: -12),
        BuildStep(line: 13, text: '{player}, 로보틱스 건설!', stat: 'scout', myResource: -20),
        BuildStep(line: 16, text: '{player} 선수 옵저버토리 건설!', myResource: -10),
        BuildStep(line: 18, text: '{player} 선수 옵저버 생산!', stat: 'scout', myArmy: 1, myResource: -10),
        BuildStep(line: 22, text: '{player}, 상대 빌드 정찰!', stat: 'scout'),
        BuildStep(line: 26, text: '{player} 선수 2번째 게이트웨이!', stat: 'defense', myResource: -15),
        BuildStep(line: 30, text: '{player}, 3번째 게이트웨이!', myResource: -15),
        BuildStep(line: 34, text: '{player} 선수 드라군 사거리 연구!', stat: 'defense', myResource: -15),
        BuildStep(line: 40, text: '{player}, 드라군 대량 생산!', stat: 'defense', myArmy: 6, myResource: -18),
        BuildStep(line: 48, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 56, text: '{player}, 드라군 추가 확보!', stat: 'scout', myArmy: 5, myResource: -15),
        BuildStep(line: 66, text: '{player} 선수 옵저버 시야 확보 후 진격!', stat: 'defense', myArmy: 4, isClash: true),
        BuildStep(line: 75, text: '{player}, 3게이트 드라군 푸시!', stat: 'scout', myArmy: 5, isClash: true),
      ],
    ),

    // 2. 다크 더블 (pvpDarkAllIn - Cheese)
    BuildOrder(
      id: 'pvp_dark_allin',
      name: '다크 더블',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 아둔 건설!', stat: 'attack', myResource: -15),
        BuildStep(line: 14, text: '{player} 선수 템플러 아카이브!', myResource: -20),
        BuildStep(line: 20, text: '{player}, 다크템플러 생산!', stat: 'strategy', myArmy: 3, myResource: -15),
        BuildStep(line: 25, text: '{player}, 다크 투입!', stat: 'attack'),
        BuildStep(line: 28, text: '{player}, 프로브 학살!', stat: 'harass', enemyArmy: -5, enemyResource: -40),
        BuildStep(line: 34, text: '{player}, 다크 추가!', myArmy: 2, myResource: -10),
        BuildStep(line: 40, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 3. 기어리버 (pvp1GateRobo - Defensive)
    // 현 메타 정석. 게이트웨이 → 로보 → 리버 → 셔틀 드랍 운영
    BuildOrder(
      id: 'pvp_1gate_robo',
      name: '기어리버',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산!', myArmy: 3, myResource: -10),
        BuildStep(line: 13, text: '{player} 선수 로보틱스 건설!', stat: 'defense', myResource: -20),
        BuildStep(line: 17, text: '{player}, 드라군 사거리!', stat: 'strategy', myResource: -15),
        BuildStep(line: 19, text: '{player} 선수 옵저버토리 건설!', myResource: -10),
        BuildStep(line: 21, text: '{player} 선수 옵저버 생산!', stat: 'scout', myArmy: 1, myResource: -10),
        BuildStep(line: 25, text: '{player}, 다크 탐지 준비!', stat: 'scout'),
        BuildStep(line: 28, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 30, text: '{player} 선수 리버 생산!', stat: 'defense', myArmy: 4, myResource: -18),
        BuildStep(line: 36, text: '{player}, 셔틀 생산!', myArmy: 1, myResource: -10),
        BuildStep(line: 40, text: '{player}, 리버 드랍!', stat: 'harass', enemyArmy: -8, enemyResource: -25),
        BuildStep(line: 48, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 56, text: '{player}, 리버 추가 생산!', stat: 'harass', myArmy: 3, myResource: -15),
        BuildStep(line: 66, text: '{player} 선수 드라군 물량 확보!', stat: 'control', myArmy: 6, myResource: -18),
        BuildStep(line: 78, text: '{player}, 리버 셔틀 드랍 운영!', stat: 'harass', isClash: true),
      ],
    ),

    // 4. 센터99게이트 (pvpZealotRush - Cheese)
    // 맵 중앙에 게이트웨이. 빠른 질럿 올인
    BuildOrder(
      id: 'pvp_zealot_rush',
      name: '센터99게이트',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 프로브 출발!', stat: 'attack'),
        BuildStep(line: 4, text: '{player}, 맵 중앙에 파일런!', stat: 'attack', myResource: -10),
        BuildStep(line: 7, text: '{player} 선수 센터 게이트웨이 건설!', stat: 'control', myResource: -15),
        BuildStep(line: 11, text: '{player}, 질럿 생산!', stat: 'attack', myArmy: 3, myResource: -8),
        BuildStep(line: 15, text: '{player} 선수 질럿 돌격!', stat: 'attack', isClash: true),
        BuildStep(line: 19, text: '{player}, 프로브 타격!', stat: 'control', enemyResource: -20),
        BuildStep(line: 23, text: '{player}, 질럿 추가!', myArmy: 3, myResource: -8),
        BuildStep(line: 25, text: '{player} 선수 올인!', stat: 'attack', isClash: true, decisive: true),
      ],
    ),

    // 5. 21 3게이트 드라군 (pvp4GateDragoon - Cheese)
    // 21서플에 3게이트 드라군 올인
    BuildOrder(
      id: 'pvp_4gate_dragoon',
      name: '21 3게이트 드라군',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.cheese,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 4, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 8, text: '{player} 선수 2번째 게이트웨이!', stat: 'attack', myResource: -15),
        BuildStep(line: 12, text: '{player}, 21서플라이 3번째 게이트웨이!', stat: 'control', myResource: -15),
        BuildStep(line: 16, text: '{player} 선수 드라군 대량 생산!', stat: 'attack', myArmy: 6, myResource: -18),
        BuildStep(line: 20, text: '{player}, 드라군 사거리 연구!', stat: 'control', myResource: -15),
        BuildStep(line: 24, text: '{player} 선수 드라군 올인 푸시!', stat: 'attack', isClash: true),
        BuildStep(line: 25, text: '{player}, 집중 포화!', stat: 'control', myArmy: 4, isClash: true, decisive: true),
      ],
    ),

    // 6. 원겟 멀티 (pvp1GateMulti - Defensive)
    // 게이트웨이 하나로 방어 후 빠른 멀티 확장
    BuildOrder(
      id: 'pvp_1gate_multi',
      name: '원겟 멀티',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.defensive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산!', stat: 'macro', myArmy: 3, myResource: -12),
        BuildStep(line: 13, text: '{player}, 드라군 사거리 연구!', stat: 'defense', myResource: -15),
        BuildStep(line: 18, text: '{player} 선수 앞마당 넥서스!', stat: 'macro', myResource: -40),
        BuildStep(line: 21, text: '{player} 선수 포지 건설!', myResource: -10),
        BuildStep(line: 23, text: '{player}, 포톤캐논 방어!', stat: 'defense', myResource: -15),
        BuildStep(line: 28, text: '{player} 선수 드라군 추가 생산!', stat: 'defense', myArmy: 4, myResource: -12),
        BuildStep(line: 34, text: '{player}, 상대 초반 압박 방어!', stat: 'defense', isClash: true),
        BuildStep(line: 40, text: '{player} 선수 로보틱스 건설!', myResource: -20),
        BuildStep(line: 43, text: '{player} 선수 옵저버토리 건설!', myResource: -10),
        BuildStep(line: 46, text: '{player}, 옵저버 생산!', stat: 'scout', myArmy: 1, myResource: -10),
        BuildStep(line: 49, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 52, text: '{player} 선수 리버 생산!', stat: 'macro', myArmy: 3, myResource: -15),
        BuildStep(line: 60, text: '{player}, 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 68, text: '{player} 선수 드라군 물량 확보!', stat: 'macro', myArmy: 8, myResource: -20),
        BuildStep(line: 78, text: '{player}, 멀티 운영으로 물량 푸시!', stat: 'defense', myArmy: 6, isClash: true),
        BuildStep(line: 88, text: '{player} 선수 더블의 여유!', stat: 'macro', myArmy: 5, isClash: true, decisive: true),
      ],
    ),

    // 7. 투겟 리버 (pvp2GateReaver - Aggressive)
    // 2게이트 + 로보 → 리버+셔틀 공격적 운영
    BuildOrder(
      id: 'pvp_2gate_reaver',
      name: '투겟 리버',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 생산 시작!', stat: 'macro', myArmy: 3, myResource: -12),
        BuildStep(line: 14, text: '{player}, 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 19, text: '{player} 선수 로보틱스!', stat: 'strategy', myResource: -20),
        BuildStep(line: 24, text: '{player}, 드라군 추가 생산!', stat: 'control', myArmy: 3, myResource: -12),
        BuildStep(line: 29, text: '{player} 선수 서포트 베이 건설!', myResource: -10),
        BuildStep(line: 34, text: '{player} 선수 리버 생산!', stat: 'harass', myArmy: 3, myResource: -20),
        BuildStep(line: 39, text: '{player}, 셔틀 생산!', stat: 'control', myArmy: 1, myResource: -12),
        BuildStep(line: 45, text: '{player} 선수 리버 드랍!', stat: 'harass', myArmy: -2, enemyArmy: -4, enemyResource: -25, isClash: true),
        BuildStep(line: 52, text: '{player}, 리버 추가 생산!', stat: 'harass', myArmy: 3, myResource: -20),
        BuildStep(line: 60, text: '{player} 선수 드라군 물량 확보!', stat: 'control', myArmy: 5, myResource: -15),
        BuildStep(line: 70, text: '{player}, 셔틀 리버 운영!', stat: 'harass', myArmy: -2, enemyArmy: -5, enemyResource: -20, isClash: true),
        BuildStep(line: 82, text: '{player} 선수 리버 드라군 최종 공세!', stat: 'control', myArmy: 4, isClash: true, decisive: true),
      ],
    ),

    // 8. 발업 질럿 (pvp3GateSpeedZealot - Aggressive)
    // 아둔 → 다리 업그레이드 → 3게이트 질럿 물량
    BuildOrder(
      id: 'pvp_3gate_speedzealot',
      name: '발업 질럿',
      race: 'P',
      vsRace: 'P',
      style: BuildStyle.aggressive,
      steps: [
        BuildStep(line: 1, text: '{player} 선수 게이트웨이 건설합니다.', myResource: -15),
        BuildStep(line: 5, text: '{player} 선수 사이버네틱스 코어 올립니다.', myResource: -15),
        BuildStep(line: 9, text: '{player} 선수 드라군 1기 생산합니다.', stat: 'macro', myArmy: 3, myResource: -12),
        BuildStep(line: 14, text: '{player}, 아둔!', stat: 'strategy', myResource: -20),
        BuildStep(line: 20, text: '{player} 선수 게이트웨이 추가!', myResource: -15),
        BuildStep(line: 26, text: '{player} 선수 질럿 다리 업그레이드 올립니다.', stat: 'attack', myResource: -15),
        BuildStep(line: 32, text: '{player} 선수 3게이트 완성!', myResource: -15),
        BuildStep(line: 38, text: '{player}, 질럿 대량 생산!', stat: 'attack', myArmy: 8, myResource: -20),
        BuildStep(line: 46, text: '{player} 선수 발업 질럿 돌격!', stat: 'attack', myArmy: -4, enemyArmy: -6, isClash: true),
        BuildStep(line: 56, text: '{player}, 질럿 추가 물량!', stat: 'control', myArmy: 6, myResource: -15),
        BuildStep(line: 68, text: '{player} 선수 질럿 물량 올인!', stat: 'attack', myArmy: 4, isClash: true, decisive: true),
      ],
    ),
  ];



  // ==================== 건물 키워드 추적 ====================

  /// 빌드 스텝 텍스트에서 건물 상태 추출용 키워드 목록
  static const _buildingKeywords = [
    // 테란
    '팩토리', '스타포트', '아카데미', '아머리', '엔지니어링',
    // 저그
    '스포닝풀', '히드라덴', '스파이어', '레어', '하이브', '퀸즈네스트',
    // 프로토스
    '게이트웨이', '로보틱스', '스타게이트', '템플러 아카이브', '포지',
  ];

  /// 확장 관련 키워드 (확장기지 수 증가)
  static const _expansionKeywords = ['앞마당', '멀티 확장', '넥서스', '해처리 건설', '해처리 확장'];

  /// 스텝 텍스트에서 건물 키워드를 추출하여 기존 Set에 추가
  static void addBuildingsFromText(String text, Set<String> buildings) {
    for (final keyword in _buildingKeywords) {
      if (text.contains(keyword)) {
        buildings.add(keyword);
      }
    }
  }

  /// 스텝 텍스트가 확장 이벤트인지 확인 (확장기지 수 증가)
  static bool isExpansionText(String text) {
    // '커맨드센터 건설' (CC first 등)도 확장으로 카운트
    if (text.contains('커맨드센터')) return true;
    for (final keyword in _expansionKeywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }

  /// 스텝 텍스트가 히든 베이스 시도인지 확인
  static bool isHiddenBaseText(String text) {
    return text.contains('히든');
  }


  // ==================== 헬퍼 메서드 ====================

  /// ID로 빌드 검색 (테스트/디버그용)
  /// 트랜지션 ID의 경우 기본 12앞 오프닝과 조합하여 반환
  static BuildOrder? getBuildOrderById(String buildId) {
    final allBuilds = [
      ...terranVsZergBuilds, ...terranVsProtossBuilds, ...terranVsTerranBuilds,
      ...zergVsTerranBuilds, ...zergVsProtossBuilds, ...zergVsZergBuilds,
      ...protossVsTerranBuilds, ...protossVsZergBuilds, ...protossVsProtossBuilds,
    ];
    for (final build in allBuilds) {
      if (build.id == buildId) return build;
    }

    // 트랜지션 ID 검색 → 기본 오프닝과 조합
    final transitionSearch = <(List<RaceTransition>, List<RaceOpening>, String)>[
      (zergTransitionsZvT, zergOpeningsZvT, 'zvt_12hatch'),
      (zergTransitionsZvP, zergOpeningsZvP, 'zvp_12hatch'),
      (terranTransitionsTvZ, terranOpeningsTvZ, 'tvz_bar_double'),
      (terranTransitionsTvP, terranOpeningsTvP, 'tvp_1fac_double'),
      (protossTransitionsPvT, protossOpeningsPvT, 'pvt_1gate_double'),
      (protossTransitionsPvZ, protossOpeningsPvZ, 'pvz_1gate_nexus'),
    ];
    for (final (transitions, openings, defaultOpeningId) in transitionSearch) {
      for (final tr in transitions) {
        if (tr.id == buildId) {
          final opening = openings.firstWhere((o) => o.id == defaultOpeningId);
          return composeBuild(opening, tr);
        }
      }
    }

    return null;
  }

  /// 매치업에 맞는 빌드 후보 목록 반환
  static List<BuildOrder> _getCandidates(String race, String vsRace) {
    final matchupKey = '${race}v$vsRace';
    switch (matchupKey) {
      case 'TvZ': return terranVsZergBuilds;
      case 'TvP': return terranVsProtossBuilds;
      case 'TvT': return terranVsTerranBuilds;
      case 'ZvT': return zergVsTerranBuilds;
      case 'ZvP': return zergVsProtossBuilds;
      case 'ZvZ': return zergVsZergBuilds;
      case 'PvT': return protossVsTerranBuilds;
      case 'PvZ': return protossVsZergBuilds;
      case 'PvP': return protossVsProtossBuilds;
      default: return [];
    }
  }

  /// 저그 오프닝 + 트랜지션 조합으로 BuildOrder 생성
  static BuildOrder composeBuild(RaceOpening opening, RaceTransition transition) {
    return BuildOrder(
      id: transition.id, // BuildType 매핑은 트랜지션 ID 기준
      name: '${opening.name} → ${transition.name}',
      race: opening.race,
      vsRace: opening.vsRace,
      style: transition.style,
      steps: [...opening.steps, ...transition.steps],
      aggressionTier: opening.aggressionTier, // 오프닝 공격성 등급 상속
    );
  }

  /// 오프닝 선택 (능력치 + 맵 기반 스코어링)
  static RaceOpening _selectOpening(
    List<RaceOpening> openings,
    Map<String, int> statValues,
    GameMap map,
  ) {
    // 치즈 오프닝 게이트 (5~15%)
    final cheeseGate = 0.05 + (_random.nextDouble() * 0.10);
    final allowCheese = _random.nextDouble() < cheeseGate;

    final scored = <MapEntry<RaceOpening, double>>[];
    for (final op in openings) {
      if (op.style == BuildStyle.cheese && !allowCheese) continue;

      double score = 0;
      // 공격형 → attack + harass 중시
      if (op.style == BuildStyle.aggressive) {
        score += (statValues['attack'] ?? 500) + (statValues['harass'] ?? 500).toDouble();
        score += (5 - map.rushDistance) * 40;
      }
      // 밸런스 → macro + defense 중시
      else if (op.style == BuildStyle.balanced) {
        score += (statValues['macro'] ?? 500) + (statValues['defense'] ?? 500).toDouble();
      }
      // 수비적 → macro + strategy 중시
      else if (op.style == BuildStyle.defensive) {
        score += (statValues['macro'] ?? 500) + (statValues['strategy'] ?? 500).toDouble();
        score += (map.rushDistance - 5) * 40;
      }
      // 치즈 → attack + sense 중시
      else if (op.style == BuildStyle.cheese) {
        score += (statValues['attack'] ?? 500) + (statValues['sense'] ?? 500).toDouble();
        score += (5 - map.rushDistance) * 60;
        score *= 0.7; // 치즈 감쇠
      }

      scored.add(MapEntry(op, score));
    }

    if (scored.isEmpty) return openings[_random.nextInt(openings.length)];

    // 가중 랜덤 선택
    final minScore = scored.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final adjusted = scored.map((e) => MapEntry(e.key, e.value - minScore + 100)).toList();
    final totalWeight = adjusted.fold<double>(0, (sum, e) => sum + e.value);
    var roll = _random.nextDouble() * totalWeight;
    for (final entry in adjusted) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return adjusted.last.key;
  }

  /// 트랜지션 선택 (능력치 + 맵 기반 스코어링)
  static RaceTransition _selectTransition(
    List<RaceTransition> transitions,
    Map<String, int> statValues,
    GameMap map,
  ) {
    final scored = <MapEntry<RaceTransition, double>>[];
    for (final tr in transitions) {
      double score = 0;
      for (final stat in tr.keyStats) {
        score += (statValues[stat] ?? 500).toDouble();
      }

      // 맵 보너스 (스타일 기반)
      if (tr.style == BuildStyle.aggressive) {
        score += (5 - map.rushDistance) * 30;
      } else if (tr.style == BuildStyle.defensive) {
        score += (map.rushDistance - 5) * 30;
        if (tr.keyStats.contains('macro')) score += (map.resources - 5) * 20;
      }

      scored.add(MapEntry(tr, score));
    }

    if (scored.isEmpty) return transitions[_random.nextInt(transitions.length)];

    final minScore = scored.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final adjusted = scored.map((e) => MapEntry(e.key, e.value - minScore + 100)).toList();
    final totalWeight = adjusted.fold<double>(0, (sum, e) => sum + e.value);
    var roll = _random.nextDouble() * totalWeight;
    for (final entry in adjusted) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }
    return adjusted.last.key;
  }

  /// 매치업과 능력치/맵 기반 통합 빌드 선택
  ///
  /// [statValues]/[map] 둘 다 있으면 스코어링 시스템 사용,
  /// 없으면 [preferredStyle] 기반 기존 로직 (하위 호환).
  static BuildOrder? getBuildOrder({
    required String race,
    required String vsRace,
    BuildStyle? preferredStyle,
    Map<String, int>? statValues,
    GameMap? map,
  }) {
    final candidates = _getCandidates(race, vsRace);
    if (candidates.isEmpty) return null;

    // ── 저그 비미러 조합 시스템 (스코어링 모드에서만) ──
    if (race == 'Z' && vsRace != 'Z' && statValues != null && map != null) {
      final openings = vsRace == 'T' ? zergOpeningsZvT : zergOpeningsZvP;
      final opening = _selectOpening(openings, statValues, map);

      // 치즈 오프닝은 트랜지션 없이 자체 완결
      if (opening.style == BuildStyle.cheese) {
        // 기존 풀 빌드 반환 (치즈 빌드는 오프닝 = 전체 빌드)
        final cheeseBuild = getBuildOrderById(opening.id);
        if (cheeseBuild != null) return cheeseBuild;
      }

      // 트랜지션 선택 → 조합
      final transitions = vsRace == 'T' ? zergTransitionsZvT : zergTransitionsZvP;
      final transition = _selectTransition(transitions, statValues, map);
      return composeBuild(opening, transition);
    }

    // ── 테란 비미러 조합 시스템 (스코어링 모드에서만) ──
    if (race == 'T' && vsRace != 'T' && statValues != null && map != null) {
      final openings = vsRace == 'Z' ? terranOpeningsTvZ : terranOpeningsTvP;
      final opening = _selectOpening(openings, statValues, map);

      // 치즈 또는 자체 완결 오프닝 (steps가 line 16 이후까지 있으면 풀 빌드)
      if (opening.style == BuildStyle.cheese || opening.steps.last.line > 16) {
        final fullBuild = getBuildOrderById(opening.id);
        if (fullBuild != null) return fullBuild;
      }

      // 트랜지션 선택 → 조합
      final transitions = vsRace == 'Z' ? terranTransitionsTvZ : terranTransitionsTvP;
      final transition = _selectTransition(transitions, statValues, map);
      return composeBuild(opening, transition);
    }

    // ── 프로토스 비미러 조합 시스템 (스코어링 모드에서만) ──
    if (race == 'P' && vsRace != 'P' && statValues != null && map != null) {
      final openings = vsRace == 'T' ? protossOpeningsPvT : protossOpeningsPvZ;
      final opening = _selectOpening(openings, statValues, map);

      // 치즈 또는 자체 완결 오프닝 (steps가 line 16 이후까지 있으면 풀 빌드)
      if (opening.style == BuildStyle.cheese || opening.steps.last.line > 16) {
        final fullBuild = getBuildOrderById(opening.id);
        if (fullBuild != null) return fullBuild;
      }

      // 트랜지션 선택 → 조합
      final transitions = vsRace == 'T' ? protossTransitionsPvT : protossTransitionsPvZ;
      final transition = _selectTransition(transitions, statValues, map);
      return composeBuild(opening, transition);
    }

    // ── 새 스코어링 시스템 (능력치 + 맵 모두 있을 때) ──
    if (statValues != null && map != null) {
      return _scoredSelection(candidates, statValues, map);
    }

    // ── 기존 로직 (하위 호환) ──
    if (preferredStyle != null) {
      final preferred = candidates.where((b) => b.style == preferredStyle).toList();
      if (preferred.isNotEmpty) {
        return preferred[_random.nextInt(preferred.length)];
      }
    }
    return candidates[_random.nextInt(candidates.length)];
  }

  /// 능력치 + 맵 속성 기반 스코어링 선택
  static BuildOrder? _scoredSelection(
    List<BuildOrder> candidates,
    Map<String, int> statValues,
    GameMap map,
  ) {
    // 치즈 게이트: 5~15% 확률로만 치즈 후보 포함
    final cheeseGate = 0.05 + (_random.nextDouble() * 0.10); // 5~15%
    final allowCheese = _random.nextDouble() < cheeseGate;

    final scored = <MapEntry<BuildOrder, double>>[];

    for (final bo in candidates) {
      final bt = BuildType.getById(bo.id);
      if (bt == null) continue;

      // 치즈 필터
      if (bt.parentStyle == BuildStyle.cheese && !allowCheese) continue;

      // 1) 능력치 점수: keyStats 2개 합산 (0~1998)
      double statScore = 0;
      for (final stat in bt.keyStats) {
        statScore += (statValues[stat] ?? 500).toDouble();
      }

      // 2) 맵 보너스: 연속 스케일링
      double mapBonus = 0;

      // rushDistance: 공격형/치즈는 짧을수록, 수비형은 길수록 유리
      if (bt.parentStyle == BuildStyle.aggressive || bt.parentStyle == BuildStyle.cheese) {
        mapBonus += (5 - map.rushDistance) * 40; // 짧으면 +, 길면 -
      } else if (bt.parentStyle == BuildStyle.defensive) {
        mapBonus += (map.rushDistance - 5) * 40;
      }

      // resources: macro keyStat이면 풍부한 자원 보너스
      if (bt.keyStats.contains('macro')) {
        mapBonus += (map.resources - 5) * 30;
      }

      // terrainComplexity: defense keyStat이면 보너스
      if (bt.keyStats.contains('defense')) {
        mapBonus += (map.terrainComplexity - 5) * 25;
      }

      // complexity: strategy keyStat이면 보너스
      if (bt.keyStats.contains('strategy')) {
        mapBonus += (map.complexity - 5) * 25;
      }

      // airAccessibility: harass keyStat이면 보너스
      if (bt.keyStats.contains('harass')) {
        mapBonus += (map.airAccessibility - 5) * 20;
      }

      // centerImportance: control 또는 attack keyStat이면 보너스
      if (bt.keyStats.contains('control') || bt.keyStats.contains('attack')) {
        mapBonus += (map.centerImportance - 5) * 20;
      }

      // hasIsland: strategy/macro 보너스
      if (map.hasIsland) {
        if (bt.keyStats.contains('strategy')) mapBonus += 60;
        if (bt.keyStats.contains('macro')) mapBonus += 40;
      }

      // expansionCount: macro keyStat이면 보너스
      if (bt.keyStats.contains('macro')) {
        mapBonus += (map.expansionCount - 3) * 30;
      }

      double totalScore = statScore + mapBonus;

      // 치즈 감쇠
      if (bt.parentStyle == BuildStyle.cheese) {
        totalScore *= 0.7;
      }

      scored.add(MapEntry(bo, totalScore));
    }

    if (scored.isEmpty) {
      // 모든 빌드가 필터링됨 (치즈만 있고 게이트 실패 등) → 전체에서 랜덤
      return candidates[_random.nextInt(candidates.length)];
    }

    // 가중 랜덤 선택 (모든 점수를 양수로 보정 + 바닥값 100)
    final minScore = scored.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final adjusted = scored.map((e) => MapEntry(e.key, e.value - minScore + 100)).toList();
    final totalWeight = adjusted.fold<double>(0, (sum, e) => sum + e.value);
    var roll = _random.nextDouble() * totalWeight;

    for (final entry in adjusted) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }

    return adjusted.last.key;
  }

}
