part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 13. 5팩토리 미러 (올인 미러)
// ----------------------------------------------------------
const _tvt5facMirror = ScenarioScript(
  id: 'tvt_5fac_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_5fac'],
  description: '5팩토리 미러 올인 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-13) - recovery 100/줄
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
          text: '{home} 선수 가스를 넣고 팩토리 건설!',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          fixedCost: true,
          altText: '{home}, 가스 채취와 동시에 팩토리!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 가스를 올립니다!',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 연달아 증설합니다! 벌써 세 번째!',
          owner: LogOwner.home,
          homeResource: -600, // 팩토리 x2 추가 (300+300)
          fixedCost: true,
          altText: '{home}, 팩토리가 쭉쭉 올라갑니다! 5팩 체제로!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설! 확장 없이 올인하겠다는 의도!',
          owner: LogOwner.away,
          awayResource: -600,
          fixedCost: true,
          altText: '{away}, 확장 없이 팩토리만 짓습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 시작! 벌처 탱크 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -550, // 시즈탱크(250/2sup) + 벌처(75/2sup) + 시즈모드 연구(300) = 625 -> 간소화: 탱크+벌처+연구
          fixedCost: true,
          altText: '{home}, 시즈 연구! 탱크와 벌처가 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구! 5팩 물량으로 맞섭니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -550,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 5팩토리! 확장 없는 올인 미러입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 물량 축적 + 시야 경쟁 (lines 14-23) - recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'buildup',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 4기로 센터 시야를 확보합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
          altText: '{home}, 벌처가 센터를 장악합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 기동! 마인을 매설하며 이동 경로를 차단!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150,
          fixedCost: true,
          altText: '{away}, 마인 매설! 상대 벌처 접근을 차단!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 3기 배치! 센터 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -750, // 탱크 3기 (250x3)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 배치! 양쪽 탱크가 마주 보고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -750,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '5팩 미러에서는 시야 확보가 곧 승부! 벌처로 눈을 뜨고 탱크로 때려야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 탱크 교전 - 분기 (lines 24-37) - recovery 150/줄
    ScriptPhase(
      name: 'tank_clash',
      startLine: 24,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 시야 우위
        ScriptBranch(
          id: 'home_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 시야를 잡았습니다! 상대 탱크 위치가 보입니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 시야 확보! 상대 탱크 배치를 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 시즈 탱크 선제 포격! 상대 탱크가 터집니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, // 탱크 교환
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 선제 포격! 상대 탱크 라인에 직격!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 먼저 맞습니다! 시야 싸움에서 밀렸어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 벌처로 잔여 병력 추격! 탱크 잔해를 정리합니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 추격! 남은 병력까지 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '시야 싸움에서 앞선 쪽이 탱크 교전을 지배합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 시야 우위
        ScriptBranch(
          id: 'away_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인으로 상대 벌처를 잡습니다! 시야가 끊겼어요!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 마인 폭발! 상대 벌처가 시야를 잃습니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크를 우회시켜 측면에서 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 측면 우회! 탱크가 상대 라인을 측면에서 때립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 측면에서 포격을 받습니다! 탱크가 큰 피해!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 벌처로 후속 추격! 잔여 탱크를 정리합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 추격! 남은 병력을 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '측면 포격으로 탱크 라인이 무너집니다! 시야가 곧 승부!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 결전 (lines 38-50) - recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -300, // 아머리(150) + 골리앗(150/2sup)
          fixedCost: true,
          altText: '{home}, 아머리! 골리앗으로 화력을 보강합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗이 합류합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -300,
          fixedCost: true,
          altText: '{away}, 아머리! 골리앗까지! 최종 결전 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 잔여 병력 총동원! 탱크 골리앗 재배치합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -400, // 탱크(250/2sup) + 골리앗(150/2sup)
          fixedCost: true,
          altText: '{home}, 탱크 골리앗 총출동! 마지막 공세!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 재배치! 결전 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -400,
          fixedCost: true,
          altText: '{away}, 탱크 골리앗 재배치! 맞붙을 준비!',
        ),
        ScriptEvent(
          text: '양측 탱크, 골리앗, 벌처가 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력 집중! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞서 싸웁니다!',
        ),
      ],
    ),
    // Phase 4: 결전 판정 - 분기 (lines 51+) - recovery 200/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 51,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시야 확보 성공! 측면 탱크 포격으로 상대 라인을 무너뜨립니다!',
              altText: '{home} 선수 벌처 마인으로 상대 벌처를 잡고 탱크로 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 측면 포격! 시야가 끊긴 상대 탱크를 직격합니다!',
              altText: '{away} 선수 마인으로 상대 벌처를 제거! 시야 없는 탱크를 포격합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
