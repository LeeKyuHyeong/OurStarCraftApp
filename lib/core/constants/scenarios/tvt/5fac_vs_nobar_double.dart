part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5팩토리 vs 노배럭더블
// 5팩 타이밍 푸시 vs 극수비. 탱크 물량 타이밍에 방어 힘듦
// ----------------------------------------------------------
const _tvt5facVsNobarDouble = ScenarioScript(
  id: 'tvt_5fac_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '5팩토리 vs 노배럭더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-12) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리!',
          owner: LogOwner.home,
          homeResource: -450, // 배럭 150 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -400, // CC 400
          fixedCost: true,
          altText: '{away}, CC퍼스트! 노배럭더블!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 계속 증설합니다! 2번째, 3번째!',
          owner: LogOwner.home,
          homeResource: -600, // 팩토리 x2 (300+300)
          fixedCost: true,
          altText: '{home}, 팩토리 증설! 5팩토리를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭, 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -450, // 배럭 150 + 팩토리 300
          fixedCost: true,
        ),
      ],
    ),
    // Phase 1: 5팩 가동 (lines 16-35) - recovery 150/1
    ScriptPhase(
      name: 'five_fac_buildup',
      startLine: 16,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4번째 팩토리! 5번째까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -600, // 팩토리 x2 (300+300)
          fixedCost: true,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 생산 시작! 시즈모드 연구!',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 = 2sup
          awayResource: -550, // 탱크 250 + 시즈모드 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 5팩토리 풀가동! 탱크를 쏟아냅니다!',
          owner: LogOwner.home,
          homeArmy: 6, // 탱크 3기 = 6sup
          homeResource: -750, // 탱크 3기 (250x3)
          fixedCost: true,
          altText: '{home}, 5팩에서 탱크가 쏟아집니다! 엄청난 물량!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 자원이 들어오기 시작합니다! 확장 먹은 자원이 중요합니다!',
          owner: LogOwner.away,
          awayResource: 10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩토리 타이밍! 노배럭더블이 자원은 먼저 모았지만 팩토리 수가 부족합니다!',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
      ],
    ),
    // Phase 2: 타이밍 푸시 (lines 40-70) - recovery 200/2
    ScriptPhase(
      name: 'timing_push',
      startLine: 40,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'fac5_overwhelm',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 5팩 타이밍 푸시! 탱크 대군이 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 4, // 탱크 2기 = 4sup
              homeResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home}, 5팩 타이밍! 탱크가 끝없이 나옵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 2대로 방어하지만 물량이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 계속 보충합니다! 5팩 생산력이 압도적!',
              owner: LogOwner.home,
              homeArmy: 4, // 탱크 2기 = 4sup
              homeResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 저항하지만 탱크 물량에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '팩토리 수 차이가 결정적입니다! 노배럭의 자원으로도 메울 수 없는 생산력!',
              owner: LogOwner.system,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 물량으로 밀어냅니다! 5팩 타이밍 성공!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'nobar_survives',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커와 탱크로 방어선 구축!',
              owner: LogOwner.away,
              awayArmy: 2, // 탱크 1기 = 2sup
              awayResource: -350, // 벙커 100 + 탱크 250
              fixedCost: true,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 푸시! 하지만 고지 방어가 단단합니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원으로 탱크 보충이 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 2기 = 4sup
              awayResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩은 자원이 부족합니다! 확장을 못 먹었습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 고지대에서 시즈모드! 유리한 위치를 선점합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '5팩 타이밍을 막았습니다! 자원 우위로 역전!',
              owner: LogOwner.system,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원의 물량 우위! 반격으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 수비 후 역전! 자원 차이로 압도!',
            ),
          ],
        ),
      ],
    ),
  ],
);
