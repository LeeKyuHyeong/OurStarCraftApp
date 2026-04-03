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
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, CC퍼스트! 노배럭더블!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 계속 증설합니다! 2번째, 3번째!',
          owner: LogOwner.home,
          homeResource: -40,
          altText: '{home}, 팩토리 증설! 5팩토리를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭, 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
      ],
    ),
    // Phase 1: 5팩 가동 (lines 16-35)
    ScriptPhase(
      name: 'five_fac_buildup',
      startLine: 16,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4번째 팩토리! 5번째까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -40,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 생산 시작! 시즈모드 연구!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 5팩토리 풀가동! 탱크를 쏟아냅니다!',
          owner: LogOwner.home,
          homeArmy: 8,
          homeResource: -25,
          altText: '{home}, 5팩에서 탱크가 쏟아집니다! 엄청난 물량!',
        ),
        ScriptEvent(
          text: '5팩토리 타이밍! 노배럭더블이 자원은 먼저 모았지만 팩토리 수가 부족합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 푸시 (lines 40-70)
    ScriptPhase(
      name: 'timing_push',
      startLine: 40,
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
              homeArmy: 5,
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
              homeArmy: 5,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '팩토리 수 차이가 결정적입니다! 노배럭의 자원으로도 메울 수 없는 생산력!',
              owner: LogOwner.system,
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
              awayArmy: 5,
              awayResource: -15,
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
              awayArmy: 5,
              awayResource: -15,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩은 자원이 부족합니다! 확장을 못 먹었습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '5팩 타이밍을 막았습니다! 자원 우위로 역전!',
              owner: LogOwner.system,
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
