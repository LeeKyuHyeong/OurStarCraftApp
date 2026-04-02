part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs 바이오 메카닉 - 스캔+터렛 vs DT 잠입
// ----------------------------------------------------------
const _pvtDarkSwingVsBioMech = ScenarioScript(
  id: 'pvt_dark_swing_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_rax_double'],
  description: '다크 스윙 vs 바이오 메카닉 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다! 가스를 올려요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 이어서 아둔!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔 건설! 다크 테크 루트!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 아카데미까지! 밸런스 있는 빌드!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리 아카데미! 바이오 메카닉을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브가 올라갑니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '바이오 메카닉은 디텍 수단이 다양합니다! 다크가 통할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 12-20)
    ScriptPhase(
      name: 'dark_deploy',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 테란으로 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 출발! 바이오 메카닉 상대로 통할까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 컴샛이 가능합니다! 아카데미가 있어요!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home}, 다크가 테란 진영에 접근합니다! 우회 경로로!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크가 측면으로 잠입합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 정찰합니다! 다크 경로를 확인하려 해요!',
          owner: LogOwner.away,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '바이오 메카닉의 다양한 디텍 수단! 스캔, 터렛, 사이언스 베슬!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 디텍 공방 + 후속 (lines 22-28)
    ScriptPhase(
      name: 'detection_phase',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크가 미네랄 라인에 접근합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 스캔! 다크를 찾으려 합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 컴샛 사용! 다크의 위치를 확인합니다!',
        ),
        ScriptEvent(
          text: '{home}, 드라군도 모으면서 후속 병력을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          altText: '{home} 선수 다크만 믿을 수 없으니 드라군도 뽑습니다!',
        ),
        ScriptEvent(
          text: '스캔 에너지 관리가 핵심! 한 번 놓치면 다크가 활개칩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 다크 잠입 성공 → 프로토스 승리
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'harass',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크가 스캔 사각지대로 잠입합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home}, 다크가 스캔을 피했습니다! 잠입 성공!',
            ),
            ScriptEvent(
              text: '{away} 선수 스캔 에너지가 바닥입니다! 다크가 안 보여요!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 다크가 SCV를 줄줄이 베어냅니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
              altText: '{home} 선수 다크 활약! SCV 피해 심각!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군 편대도 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '다크 견제에 자원이 끊기고 드라군까지! 테란이 위기!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 다크 + 드라군으로 테란을 밀어냅니다! GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 견제 + 드라군 공격! 바이오 메카닉을 무너뜨립니다!',
            ),
          ],
        ),
        // 분기 B: 디텍 성공 → 사이언스 베슬 합류 → 테란 역전
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'scout',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스캔으로 다크를 잡아냅니다! 마린 집중 사격!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 디텍 성공! 다크를 격파합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 잡혔습니다! 테크 투자가 헛됐어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 사이언스 베슬이 나옵니다! 이제 완벽한 디텍!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
              altText: '{away} 선수 사이언스 베슬! 다크가 다시는 숨지 못합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크 골리앗에 사이언스 베슬까지! 풀 편성!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '바이오 메카닉의 완성형! 프로토스가 막기 힘든 편성!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 풀 편성으로 밀어냅니다! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 바이오 메카닉 완성! 사이언스 베슬이 다크를 봉인!',
            ),
          ],
        ),
      ],
    ),
  ],
);
