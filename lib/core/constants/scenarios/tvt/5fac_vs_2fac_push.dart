part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5팩 vs 투팩 벌처
// ----------------------------------------------------------
const _tvt5facVs2facPush = ScenarioScript(
  id: 'tvt_5fac_vs_2fac_vulture',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '5팩 타이밍 vs 투팩 벌처 팩토리 물량전',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 빠르게 증설합니다. 5팩 체제.',
          owner: LogOwner.home,
          homeResource: -900, // 팩토리x3(900) - 첫 3개
          fixedCost: true,
          altText: '{home} 선수 팩토리가 빠르게 늘어납니다. 5팩 체제.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설, 두 번째 팩토리도 올립니다.',
          owner: LogOwner.away,
          awayResource: -600, // 팩토리x2(600)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 5팩에서 벌처가 쏟아집니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처 2기 (2sup x2)
          homeResource: -150, // 벌처2(150)
          fixedCost: true,
          altText: '{home} 선수 5팩 벌처 물량.',
        ),
        ScriptEvent(
          text: '{away} 선수 투팩에서 벌처 생산, 물량 싸움.',
          owner: LogOwner.away,
          awayArmy: 4, // 벌처 2기 (2sup x2)
          awayResource: -150, // 벌처2(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '5팩 vs 투팩. 팩토리 물량전이 벌어집니다.',
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
          text: '{home} 선수 5팩에 머신샵 부착. 탱크 대량 생산.',
          owner: LogOwner.home,
          homeArmy: 4, // 탱크 2기 (2sup x2)
          homeResource: -1000, // 머신샵(100) + 시즈모드(300) + 탱크2(500) + 벌처(100: 잔여분)
          fixedCost: true,
          altText: '{home} 선수 5팩 풀가동. 탱크 벌처가 쏟아집니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착, 시즈 모드 연구.',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -650, // 머신샵(100) + 시즈모드(300) + 탱크(250)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구. 아머리도 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아머리(150)
          fixedCost: true,
          altText: '{home} 선수 시즈 연구와 아머리. 후반 준비.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설. 골리앗 생산을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설, 컨트롤타워도 올립니다.',
          owner: LogOwner.home,
          homeResource: -350, // 스타포트(250) + 컨트롤타워(100)
          fixedCost: true,
          altText: '{home} 선수 스타포트 건설 후 컨트롤타워, 드랍십을 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설, 컨트롤타워 올리고 있습니다.',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트(250) + 컨트롤타워(100)
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 5팩 벌처 물량으로 센터를 장악합니다.',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 벌처 물량 차이! 센터 장악!',
        ),
        ScriptEvent(
          text: '{away} 선수도 맞대응. 투팩 벌처 컨트롤 대결.',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산. 기동전을 노립니다.',
          owner: LogOwner.home,
          homeArmy: 2, // 드랍십 1기 (2sup)
          homeResource: -200, // 드랍십(200)
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩 vs 투팩. 팩토리 수 차이가 결정적일까요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+) - recovery 200/2
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 5팩 벌처 물량. 상대 벌처를 압도합니다!',
              owner: LogOwner.home,
              awayArmy: -4, // 벌처 2기 손실 (2sup x2)
              favorsStat: 'control',
              altText: '{home} 선수 5팩 벌처 물량 승리! 맵 컨트롤!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 녹았습니다! 물량 차이에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -2, // 벌처 1기 추가 손실 (2sup)
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 센터 장악. 마인까지 깔면서.',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'harass',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 투팩 벌처 컨트롤이 더 좋습니다! 선제 타격!',
              owner: LogOwner.away,
              homeArmy: -4, // 벌처 2기 손실 (2sup x2)
              favorsStat: 'control',
              altText: '{away} 선수 벌처 컨트롤 승리!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 피해! 맵 컨트롤을 뺏겼습니다!',
              owner: LogOwner.home,
              homeArmy: -2, // 벌처 1기 추가 손실 (2sup)
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 정찰하면서 상대 움직임을 파악합니다.',
              owner: LogOwner.away,
              awayArmy: 1, favorsStat: 'scout',
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
          text: '{home} 선수 5팩 탱크 시즈. 라인을 잡습니다.',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          altText: '{home} 선수 5팩 탱크 라인 구축. 시즈 모드.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈. 맞서는 모양새.',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다. 거리재기.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 뒤쪽을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 드랍 견제, 뒤를 노립니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 마인 매설. 진격로를 차단합니다.',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+) - recovery 300/3
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 5팩 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 5팩 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 물량에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 물량으로 투팩을 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 팩토리 수 차이! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 투팩 벌처 컨트롤! 5팩 병력을 효율적으로 상대합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 벌처 컨트롤 차이! 5팩 물량을 상대합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗으로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 투팩 운영으로 5팩 타이밍을 꺾습니다!',
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
