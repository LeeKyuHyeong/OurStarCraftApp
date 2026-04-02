part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 5팩토리 물량
// ----------------------------------------------------------
const _pvt5gateArbiterVs5facMass = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '5게이트 아비터 vs 5팩토리 물량 — 리콜 일꾼 급습 vs 탱크 물량',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 팩토리를 빠르게 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에서 팩토리! 메카닉 체제를 갖춥니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스 건설! 확장을 가져가는군요.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 연이어 건설합니다! 3개, 4개, 5개!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 팩토리가 줄줄이 올라갑니다! 5팩 체제!',
        ),
        ScriptEvent(
          text: '테란이 5팩토리 체제를 구축하고 있습니다. 물량 승부를 걸겠군요.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가! 드라군 생산을 늘립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 5팩토리에서 벌처 탱크가 쏟아져 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25, favorsStat: 'macro',
          altText: '{away}, 5팩 풀가동! 메카닉 물량이 밀려옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 방어하지만 물량 차이가 크네요.',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -2, favorsStat: 'defense',
          altText: '{home}, 드라군 방어! 하지만 물량이 밀립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 라인을 형성합니다! 전선이 조여옵니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브! 스타게이트도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 템플러 아카이브에 스타게이트! 더블 테크 준비!',
        ),
        ScriptEvent(
          text: '프로토스가 테크로 물량 차이를 극복할 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터 트리뷰널 건설! 아비터가 곧 나옵니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아비터 트리뷰널! 리콜이 열쇠입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 물량이 10대를 넘어갑니다! 시즈 라인이 길어집니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 탱크 라인이 끝이 없습니다! 이 물량을 어떻게 막죠?',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러와 아비터 동시 생산! 역전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 3번째 확장기지까지! 자원 확보가 절실합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 3번째 넥서스! 자원이 부족하면 물량전에서 밀리니까요.',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 리콜! 테란 미네랄 라인에 병력 투하!',
              owner: LogOwner.home,
              homeArmy: 3, awayResource: -30, favorsStat: 'sense',
              altText: '{home}, 리콜! 테란 일꾼을 노립니다! 자원줄을 끊어야죠!',
            ),
            ScriptEvent(
              text: '{home}, 일꾼을 날리면서 스톰까지! 수비 병력이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -6, awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 리콜 지점에서 스톰! 이중 타격!',
            ),
            ScriptEvent(
              text: '{away} 선수 자원이 끊기면서 5팩토리 가동이 멈춥니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '리콜로 자원줄을 끊었습니다! 물량 생산이 불가능해집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 물량으로 전선을 밀어냅니다! 시즈 포격!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -5, favorsStat: 'attack',
              altText: '{away}, 대규모 시즈 라인! 프로토스 전선이 후퇴합니다!',
            ),
            ScriptEvent(
              text: '{away}, 터렛과 골리앗으로 아비터를 견제합니다! 리콜 기회를 안 줍니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 압도적인 탱크 물량! 프로토스 앞마당이 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -2, favorsStat: 'macro',
              altText: '{away} 선수 5팩 물량의 위력! 넥서스가 파괴됩니다!',
            ),
            ScriptEvent(
              text: '5팩토리 물량 앞에 테크 유닛이 빛을 발하지 못합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
