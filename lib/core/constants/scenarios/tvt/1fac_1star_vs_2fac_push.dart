part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs 투팩 벌처
// ----------------------------------------------------------
const _tvt1fac1starVs2facPush = ScenarioScript(
  id: 'tvt_1fac_1star_vs_2fac_vulture',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '원팩 푸시 vs 투팩 벌처 팩토리 대결',
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
          text: '{away} 선수도 팩토리 건설! 두 번째 팩토리도!',
          owner: LogOwner.away,
          awayResource: -700, // 가스 100 + 팩토리 300 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{home}, 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 투팩에서 벌처가 쏟아집니다! 물량 차이!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '원팩 vs 투팩! 팩토리 수 차이가 관건입니다!',
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
          text: '{home} 선수 머신샵 부착합니다! 시즈 연구!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -650, // 머신샵 100 + 시즈모드 300 + 탱크 250
          fixedCost: true,
          altText: '{home}, 머신샵에서 시즈 연구! 탱크를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착! 투팩에서 벌처 탱크!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -450, // 머신샵 100 + 탱크 250 + 머신샵 100
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 아머리도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{home}, 시즈 연구와 아머리! 후반 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 투팩 벌처 탱크로 압박!',
          owner: LogOwner.away,
          awayResource: -150, // 아머리 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워도 올립니다!',
          owner: LogOwner.home,
          homeResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
          altText: '{home}, 스타포트 건설 후 컨트롤타워! 드랍십을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 컨트롤타워 올리고 있습니다!',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 맞대응! 벌처 컨트롤 대결!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 기동전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200, // 드랍십 200
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '팩토리 대결! 먼저 밀리면 끝입니다!',
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
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 컨트롤이 앞섭니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 벌처 싸움 승리! 맵 컨트롤!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 녹았습니다! 시야가 불리해지네요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 센터 장악! 마인까지 깔면서!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75, // 벌처 75 추가 생산
              fixedCost: true,
              favorsStat: 'harass',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 투팩 벌처 물량! 숫자로 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 투팩 벌처 물량 승리!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 피해! 물량 차이에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 정찰하면서 마인 매설!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75, // 벌처 75 추가 생산
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
          text: '{away} 선수도 탱크 시즈! 투팩 물량으로 맞섭니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500, // 탱크 2기 (250x2) 투팩
          fixedCost: true,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 뒤쪽을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 드랍 견제! 뒤를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 마인 매설! 진격로를 차단합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+) - recovery 200/2
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
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
              text: '{home} 선수 원팩 푸시 타이밍으로 투팩을 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 투팩 물량! 병력이 더 빠르게 모입니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 투팩 물량 역습! 상대 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 벌처로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 투팩 물량으로 원팩 푸시를 꺾습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 벌처로 시야를 잡고 탱크로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
