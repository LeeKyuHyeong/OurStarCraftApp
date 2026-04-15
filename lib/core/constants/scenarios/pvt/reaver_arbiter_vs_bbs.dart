part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs BBS: 풀테크 vs 초반 러시 — 생존하면 역전
// ----------------------------------------------------------
const _pvtReaverArbiterVsBbs = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter', 'pvt_1gate_expand', 'pvt_reaver_shuttle'],
  awayBuildIds: ['tvp_bbs'],
  description: '리버 아비터 풀테크 vs BBS 마린 러시 — 초반 생존이 관건',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 건설하고 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 두 개를 빠르게 건설합니다! 마린이 쏟아질 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          awayArmy: 2,
          altText: '{away}, 배럭이 두 개! 마린을 빠르게 모으겠다는 의지!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿을 생산해서 입구를 막습니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
          altText: '{home}, 질럿으로 입구를 막으려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 6기가 프로토스 본진을 향해 출발합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '테란의 초반 러시! 프로토스가 테크를 올리려면 먼저 살아남아야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: BBS 수비 + 테크 업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿과 프로브로 마린을 막아냅니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          awayArmy: -2,
          favorsStat: 'defense',
          altText: '{home}, 프로브까지 동원해서 막습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 마린으로 두 번째 공격을 시도합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 합류합니다! 마린을 효과적으로 상대할 수 있죠!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'defense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이를 올리기 시작합니다! 공성 빌드를 향한 첫걸음!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 마린 러시를 막으면서 로보틱스와 서포트 베이를 건설합니다!',
        ),
        ScriptEvent(
          text: '마린 러시를 버텼다면 테크 차이가 게임을 결정할 겁니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 테크 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버가 완성됩니다! 견제를 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브까지 건설합니다! 풀테크 빌드!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 템플러 아카이브가 올라갑니다! 아비터까지 가려는 건가요!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 러시 이후 확장을 시도하지만 테크가 뒤처져 있습니다.',
          owner: LogOwner.away,
          awayResource: -20,
          awayArmy: 2,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '프로토스의 테크가 빠르게 올라가고 있습니다! 초반 올인의 대가가 크네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 트리뷰널 건설! 아비터가 곧 나옵니다!',
              owner: LogOwner.home,
              homeResource: -15,
              homeArmy: 3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home} 선수 리버 견제로 테란 일꾼을 계속 잡습니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 스캐럽이 SCV를 잡아냅니다! 자원 차이가 벌어지네요!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 리콜! 테란 본진에 병력이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '풀테크 프로토스! 아비터 리콜에 테란이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 초반 러시 피해가 컸습니다! 프로토스 일꾼이 많이 죽었어요!',
              owner: LogOwner.away,
              homeResource: -25,
              awayArmy: 3,
              favorsStat: 'attack',
              altText: '{away}, 마린 공격이 프로브에 큰 피해를 입혔습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 테크를 올리고 싶지만 자원이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 마린으로 다시 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '마린 러시 후속 공격에 프로토스가 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
