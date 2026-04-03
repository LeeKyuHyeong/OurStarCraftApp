part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 미러 (탱크 시즈 거리재기)
// ----------------------------------------------------------
const _tvtFdRushMirror = ScenarioScript(
  id: 'tvt_fd_rush_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_fd_rush'],
  description: 'FD 러쉬 미러 탱크 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취 후 팩토리! 머신샵 부착!',
          owner: LogOwner.home,
          homeResource: -500, // 리파이너리(100) + 팩토리(300) + 머신샵(100)
          fixedCost: true,
          altText: '{home}, 팩토리에 머신샵! 빠른 메카닉!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취 후 팩토리! 머신샵 부착!',
          owner: LogOwner.away,
          awayResource: -500,
          fixedCost: true,
          altText: '{away}, 역시 팩토리에 머신샵! 양쪽 같은 빌드!',
        ),
        ScriptEvent(
          text: '양측 모두 빠른 팩토리! FD 러쉬 미러입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 시즈탱크 250/2sup
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크 생산!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
        ),
      ],
    ),
    // Phase 1: 시즈 모드 연구 경쟁 (lines 12-20) - recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'siege_research_race',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 탱크를 전진 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 탱크 추가(250/2sup) + 시즈모드 연구(300)
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home}, 시즈 모드 연구 시작! 탱크가 전진합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구! 센터로 탱크를 보냅니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{away}, 시즈 모드 연구! 센터에서 마주칠 준비!',
        ),
        ScriptEvent(
          text: '양측 기갑 유닛이 센터에서 마주칩니다! 거리재기가 시작됩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 고지를 먼저 잡으려 합니다! 시즈 거리가 중요합니다!',
          owner: LogOwner.home,
          favorsStat: 'control',
          altText: '{home} 선수 고지 선점 시도! 시즈 사거리!',
        ),
        ScriptEvent(
          text: '{away} 선수도 고지를 노립니다! 탱크 배치 경쟁!',
          owner: LogOwner.away,
          favorsStat: 'control',
          altText: '{away}, 고지 확보 시도! 먼저 잡는 쪽이 유리합니다!',
        ),
      ],
    ),
    // Phase 2: 시즈 대치 분기 (lines 22-32) - recovery 150/줄
    ScriptPhase(
      name: 'siege_standoff',
      startLine: 22,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 고지 선점
        ScriptBranch(
          id: 'home_high_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 고지를 먼저 잡았습니다! 시즈 모드!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 추가 (250/2sup)
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 고지 선점! 시즈 화력이 내려다봅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아래에서 시즈를 잡지만 사거리가 불리합니다!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -2, // 탱크 교전
            ),
            ScriptEvent(
              text: '{home}, 시즈 포격! 상대 탱크를 직격합니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 고지 시즈 포격! 상대 탱크가 폭발!',
            ),
            ScriptEvent(
              text: '고지 선점 차이! 시즈 라인 미러에서 위치가 결정적!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 어웨이 고지 선점
        ScriptBranch(
          id: 'away_high_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 고지를 먼저 잡았습니다! 시즈 모드!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              favorsStat: 'control',
              altText: '{away} 선수 고지 선점! 시즈 사거리 우위!',
            ),
            ScriptEvent(
              text: '{home} 선수 아래에서 올려다보는 형국! 불리합니다!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 고지에서 포격! 상대 탱크를 맞춥니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 고지 시즈! 상대 탱크가 무너집니다!',
            ),
            ScriptEvent(
              text: '고지 선점! 한 발 빠른 배치가 판도를 가릅니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 C: 양쪽 교착
        ScriptBranch(
          id: 'siege_stalemate',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 탱크가 비슷한 거리에서 시즈를 잡습니다! 교착!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 벌처를 생산해 우회를 시도합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75, // 벌처 75/2sup
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 벌처 추가! 옆길로 돌아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처로 대응! 마인을 깝니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away}, 벌처 마인! 우회 경로를 차단합니다!',
            ),
            ScriptEvent(
              text: '시즈 교착! 누가 먼저 실수하느냐가 관건입니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 확장 + 추가 생산 (lines 34-44) - recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'mid_expansion',
      startLine: 34,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터! 두 번째 팩토리도!',
          owner: LogOwner.home,
          homeResource: -700, // CC(400) + 팩토리(300)
          fixedCost: true,
          altText: '{home}, 앞마당 확장과 투팩! 탱크를 늘립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 확장! 팩토리 추가!',
          owner: LogOwner.away,
          awayResource: -700,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home}, 탱크 더블 생산! 물량을 올립니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 더블 생산! 물량 경쟁!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home}, 스타포트! 드랍으로 돌파를 노립니다!',
        ),
        ScriptEvent(
          text: '양측 시즈 라인 미러! 드랍과 우회가 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 46+) - recovery 200/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 46,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크를 싣고 뒤쪽 고지로!',
              owner: LogOwner.home,
              awayResource: -300, awayArmy: -2, // 후방 시설+병력 피해
              favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 후방 고지에 시즈!',
            ),
            ScriptEvent(
              text: '{home}, 양면 시즈 포격! 정면과 후방 동시 공격!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 미러에서 위치 선점과 드랍으로 승리합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 운용이 한 수 위였습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벌처로 마인을 깔며 상대 이동 경로를 차단합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 마인 매복! 상대 탱크가 밟습니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크가 유리한 위치에서 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 배치와 마인 운용으로 미러를 제압합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 시즈 거리재기에서 승리합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
