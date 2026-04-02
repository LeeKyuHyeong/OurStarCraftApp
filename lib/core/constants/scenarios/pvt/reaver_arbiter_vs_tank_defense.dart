part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs 탱크 수비: 리버 견제 + 리콜로 시즈 라인 돌파
// ----------------------------------------------------------
const _pvtReaverArbiterVsTankDefense = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter'],
  awayBuildIds: ['tvp_trans_tank_defense'],
  description: '리버 아비터 vs 시즈탱크 수비 — 리콜로 시즈 라인 뒤를 찌른다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 이후 사이버네틱스 코어를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 시즈탱크를 생산합니다. 수비형 빌드!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -20,
          altText: '{away}, 시즈탱크 생산! 수비적인 진형을 갖추려 하네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스를 건설합니다. 리버를 준비하는군요.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 로보틱스가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커와 시즈탱크로 앞마당 라인을 구축합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '시즈 라인이 완성되면 정면 돌파가 어렵습니다. 다른 방법을 찾아야겠죠!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버 견제 + 테크 업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버가 출발합니다! 일꾼 라인을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 스캐럽이 확장 기지 SCV에 명중합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 스캐럽 명중! SCV가 날아갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛을 올리고 마린을 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 1,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브와 아비터 트리뷰널을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아비터 트리뷰널까지 건설합니다! 아비터가 나올 겁니다!',
        ),
        ScriptEvent(
          text: '리버 견제를 하면서 동시에 아비터를 준비합니다! 완벽한 패키지!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 아비터 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터가 완성됩니다! 리콜 에너지를 모으고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 라인을 더 두텁게 쌓습니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 시즈탱크가 추가됩니다! 정면은 철벽이에요!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 부대를 앞에 두고 아비터를 뒤에서 대기시킵니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '아비터 리콜이 준비됩니다! 시즈 라인 뒤로 떨어뜨릴 수 있을까요!',
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
              text: '{home} 선수 아비터 리콜! 드라군이 테란 본진에 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayResource: -20,
              favorsStat: 'strategy',
              altText: '{home}, 리콜! 드라군 대부대가 테란 일꾼 라인에 나타납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 언시즈하고 돌아오지만 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 리버 스캐럽까지! 본진이 초토화됩니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '리콜이 시즈 라인을 무력화했습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 사이언스 베슬이 아비터를 감지합니다! EMP!',
              owner: LogOwner.away,
              homeArmy: -3,
              awayArmy: 2,
              favorsStat: 'defense',
              altText: '{away}, EMP에 아비터 에너지가 사라집니다! 리콜 불가!',
            ),
            ScriptEvent(
              text: '{home} 선수 리콜 없이 정면 돌파를 시도하지만 시즈 라인에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 전진합니다! 프로토스 진영을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '시즈 라인이 무적입니다! 프로토스가 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
