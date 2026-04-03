part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS vs 투팩 벌처
// ----------------------------------------------------------
const _tvtBbsVs2facPush = ScenarioScript(
  id: 'tvt_bbs_vs_2fac_vulture',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_2fac_push'],
  description: 'BBS vs 투팩 벌처 초반 공격 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-6) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 센터로 보냅니다!',
          owner: LogOwner.home,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설, 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -250, // 배럭(150) + 리파이너리(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home}, 센터 배럭! 공격적인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 2개 건설! 투팩 벌처입니다!',
          owner: LogOwner.away,
          awayResource: -600, // 팩토리 x2 (300x2)
          fixedCost: true,
          altText: '{away}, 팩토리 두 개! 투팩 벌처로 승부합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home}, BBS 확정! 마린을 모읍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 3, // 마린 3기
          homeResource: -150, // 마린 3기 (50x3)
          fixedCost: true,
        ),
      ],
    ),
    // Phase 1: BBS 돌진 (lines 10-12) - recovery 100/줄
    ScriptPhase(
      name: 'bbs_rush',
      startLine: 10,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 3기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, // 마린 2기 추가
          homeResource: -100, // 마린 2기 (50x2)
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 돌진! 빠른 공격!',
        ),
        ScriptEvent(
          text: '{away} 선수 투팩에서 벌처가 쏟아집니다!',
          owner: LogOwner.away,
          awayArmy: 4, // 벌처 2대 (2sup x2)
          awayResource: -150, // 벌처 2대 (75x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home}, 상대 진지에 벙커 건설 시도!',
          owner: LogOwner.home,
          homeResource: -100, // 벙커
          fixedCost: true,
          altText: '{home} 선수 벙커를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 분기 (lines 15+) - recovery 150/줄
    ScriptPhase(
      name: 'rush_result',
      startLine: 15,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        ScriptBranch(
          id: 'tech_defends',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 기동력으로 마린을 견제합니다!',
              owner: LogOwner.away,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'defense',
              altText: '{away}, 투팩 벌처로 마린 격퇴!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 기동력을 따라잡지 못해요!',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away}, 추가 벌처까지 생산! BBS를 완전히 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, // 벌처 1대 (2sup)
              awayResource: -75, // 벌처
              fixedCost: true,
              homeArmy: -1, // 마린 1기 사망
              altText: '{away} 선수 벌처 물량! BBS를 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -150, // SCV 손실
            ),
            ScriptEvent(
              text: 'BBS가 막혔습니다! 전환기에 들어갑니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bbs_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 화력 집중!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 벙커를 못 뚫습니다!',
              owner: LogOwner.away,
              awayArmy: -2, // 벌처 1대 사망 (2sup)
            ),
            ScriptEvent(
              text: '{home}, 마린으로 밀어붙입니다! SCV 수리까지!',
              owner: LogOwner.home,
              awayArmy: -2, // 벌처 1대 사망 (2sup)
              favorsStat: 'control',
              altText: '{home} 선수 마린 화력! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 일꾼이 많이 죽었습니다!',
              owner: LogOwner.away,
              awayResource: -200, // SCV 손실
            ),
            ScriptEvent(
              text: 'BBS 공격이 큰 피해를 줬습니다! 하지만 끝나진 않았습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 24-32) - recovery 200/줄
    ScriptPhase(
      name: 'mid_transition',
      startLine: 24,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵도 올립니다!',
          owner: LogOwner.home,
          homeResource: -500, // 리파이너리(100) + 팩토리(300) + 머신샵(100)
          fixedCost: true,
          altText: '{home}, 팩토리에 머신샵! 메카닉 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구!',
          owner: LogOwner.away,
          awayResource: -400, // 머신샵(100) + 시즈모드(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산 시작! BBS 이후 전환!',
          owner: LogOwner.home,
          homeArmy: 2, // 탱크 1대 (2sup)
          homeResource: -250, // 탱크
          fixedCost: true,
          altText: '{home}, 탱크 체제로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 투팩에서 벌처 탱크가 쏟아집니다!',
          owner: LogOwner.away,
          awayArmy: 6, // 탱크 1대(2sup) + 벌처 2대(2sup x2)
          awayResource: -400, // 탱크(250) + 벌처 2대(75x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -350, // 스타포트(250) + 컨트롤타워(100)
          fixedCost: true,
          altText: '{home}, 스타포트 건설 후 컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -125, // 엔지니어링베이
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산 시작! 기동전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, // 드랍십 1대 (2sup)
          homeResource: -200, // 드랍십
          fixedCost: true,
        ),
        ScriptEvent(
          text: '전환기에 들어갑니다! 양쪽 모두 메카닉 체제!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 중반 결전 - 분기 (lines 34+) - recovery 200/줄
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 34,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'bbs_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크를 싣고 뒤쪽으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 미네랄 라인을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크를 내립니다! 뒤쪽 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayResource: -200, // SCV 손실
              awayArmy: -2, // 벌처 1대 사망 (2sup)
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 시즈! 양면 공격!',
              owner: LogOwner.home,
              homeArmy: -2, // 탱크 1대 사망
              awayArmy: -4, // 탱크 2대 사망
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 초반 피해를 이어갑니다! 투팩 측이 회복하지 못합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 초반 마린 화력으로 상대를 압살합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'tech_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 테크 우위! 투팩 벌처 탱크 물량이 압도적입니다!',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
              awayResource: -325, // 탱크(250) + 벌처(75)
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 물량 차이! 투팩의 힘!',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 투자가 무겁습니다! 따라잡기 힘들어요!',
              owner: LogOwner.home,
              homeArmy: -2, // 탱크 1대 사망
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -4, // 탱크 2대 사망
              awayArmy: -2, // 탱크 1대 사망
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 투팩 물량으로 BBS를 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 초반을 버텨내고 물량 차이로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
