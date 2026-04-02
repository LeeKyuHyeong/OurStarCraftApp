part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 타이밍 푸시
// ----------------------------------------------------------
const _pvt5gateArbiterVsTimingPush = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter'],
  awayBuildIds: ['tvp_trans_timing_push'],
  description: '5게이트 아비터 vs 타이밍 푸시 — 수비 후 리콜 역습',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설 후 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다. 팩토리도 빠르게 올리는군요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에서 팩토리! 빠른 테크입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다! 자원 확보가 우선이군요.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 2개 가동! 벌처와 탱크를 빠르게 생산합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 더블 팩토리! 타이밍 공격을 준비하는 모습!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가하며 드라군을 늘립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 병력을 모으고 있습니다. 타이밍 공격이 올 것 같은데요.',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          text: '{away} 선수 벌처 탱크 편대가 전진합니다! 타이밍 푸시!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'attack',
          altText: '{away}, 타이밍 공격 개시! 벌처 탱크가 밀려옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 방어합니다! 입구를 틀어막습니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -2, favorsStat: 'defense',
          altText: '{home}, 드라군 방어! 입구에서 교전합니다!',
        ),
        ScriptEvent(
          text: '{away}, 시즈 탱크 배치! 프로토스 앞마당을 포격합니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿으로 탱크 뒤를 노립니다! 측면 우회!',
          owner: LogOwner.home,
          awayArmy: -2, homeArmy: -1, favorsStat: 'control',
          altText: '{home}, 질럿 우회! 탱크 뒤를 노리는 판단!',
        ),
        ScriptEvent(
          text: '프로토스가 타이밍 공격을 간신히 막아냅니다.',
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
          text: '{home} 선수 아둔 건설! 템플러 아카이브도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아둔에 템플러 아카이브! 스톰 테크 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트에 아비터 트리뷰널 건설! 아비터를 노립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아비터 트리뷰널! 리콜 역습을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 2차 공격을 위해 병력을 재정비합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 병력을 다시 모으고 있습니다. 2차 공격 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 생산! 아비터도 곧 나올 겁니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '프로토스 테크가 완성되면 상황이 역전될 수 있습니다.',
          owner: LogOwner.system,
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
              text: '{home} 선수 아비터 등장! 리콜로 테란 본진을 급습합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayResource: -25, favorsStat: 'sense',
              altText: '{home}, 아비터 리콜! 테란 본진에 병력 투하!',
            ),
            ScriptEvent(
              text: '{home}, 스톰이 터집니다! 테란 병력이 녹아내리고 있어요!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -1, favorsStat: 'strategy',
              altText: '{home} 선수 사이오닉 스톰! 마린 메딕이 순식간에!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비와 전선 유지를 동시에 할 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '리콜 역습이 성공! 타이밍 푸시를 넘기고 역전합니다!',
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
              text: '{away} 선수 아비터가 나오기 전에 2차 공격을 감행합니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
              altText: '{away}, 지금이 기회! 아비터 전에 밀어야 합니다!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크 포격! 프로토스 앞마당이 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 시즈 포격! 프로토스 전선이 붕괴합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 없이 정면 교전은 불리합니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '2차 타이밍 공격 성공! 프로토스가 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
