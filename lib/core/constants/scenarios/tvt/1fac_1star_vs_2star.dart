part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs 레이스 클로킹
// ----------------------------------------------------------
const _tvt1fac1starVs2star = ScenarioScript(
  id: 'tvt_1fac_1star_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2star'],
  description: '원팩 푸시 vs 레이스 클로킹 타이밍 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
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
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 공격적인 운영!',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home}, 팩토리가 올라갑니다! 원팩 푸시!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 스타포트를 노립니다!',
          owner: LogOwner.away,
          awayResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작! 빠른 공격!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{home}, 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 공중 유닛을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -325, // 스타포트 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '원팩 푸시 vs 공중 테크! 지상과 공중의 대결!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 준비 (lines 12-22) - recovery 150/1
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -650, // 머신샵 100 + 시즈모드 300 + 탱크 250
          fixedCost: true,
          altText: '{home}, 팩토리에 머신샵 추가! 탱크를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스 생산! 클로킹 연구도 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550, // 컨트롤타워 100 + 클로킹 300 + 레이스 250 (2sup → 2star 빌드)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 아머리도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -400, // 스타포트 250 + 아머리 150 (원팩원스타)
          fixedCost: true,
          altText: '{home}, 시즈 연구와 아머리! 대공 준비까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 레이스로 견제 시작! SCV를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'harass',
          altText: '{away}, 클로킹 레이스 출격! SCV 사냥 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 터렛으로 대공!',
          owner: LogOwner.home,
          homeResource: -275, // 엔지니어링베이 125 + 터렛 75x2
          fixedCost: true,
          altText: '{home}, 터렛 건설! 대공 수비!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스 추가 생산! 견제를 이어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 레이스 250
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 지상 우위를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 상대 건설 SCV를 괴롭힙니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산! 대공 화력을 갖춥니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -150, // 골리앗 150
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '지상 vs 공중! 먼저 주도권을 잡는 쪽이 유리합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+) - recovery 200/2
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_ground_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 골리앗 대공 사격! 하늘의 위협을 격추합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 골리앗 화력! 공중 유닛이 떨어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 녹았습니다! 견제 효과가 줄어듭니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 지상 병력으로 전진 준비! 탱크 시즈!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 250 추가
              fixedCost: true,
              favorsStat: 'attack',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_air_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 클로킹 레이스 견제가 성공합니다! SCV 피해!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 견제! 스캔 없는 곳을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 대공이 늦었습니다! SCV가 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 시야 장악! 상대 움직임을 파악합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250, // 레이스 250 추가
              fixedCost: true,
              favorsStat: 'scout',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 교전 (lines 32-38) - recovery 200/2
    ScriptPhase(
      name: 'tank_battle',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home}, 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리에서 탱크를 뽑기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 탱크 250
          fixedCost: true,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -200, // 드랍십 200 (스타포트는 이미 있음 - 원팩원스타)
          fixedCost: true,
          altText: '{home}, 스타포트에 컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 뒤쪽을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 드랍 견제! 뒤를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 정찰하면서 상대 움직임 파악!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+) - recovery 300/3
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크 골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상 화력으로 공중 빌드를 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 원팩 푸시 성공! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 레이스 견제로 자원 우위! 병력이 더 빠르게 모입니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 역습! 견제로 벌어진 자원 차이!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 레이스로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 견제로 상대를 흔들어 놓고 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 공중 견제 성공! 원팩 푸시를 꺾습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
