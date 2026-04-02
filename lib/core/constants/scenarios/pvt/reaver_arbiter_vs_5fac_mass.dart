part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs 5팩토리 매스: 리콜 + 스테이시스로 물량 대응
// ----------------------------------------------------------
const _pvtReaverArbiterVs5facMass = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter'],
  awayBuildIds: ['tvp_trans_5fac_mass'],
  description: '리버 아비터 vs 5팩토리 매스 — 리콜로 물량 뒤를 찌르고 스테이시스로 분리',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이에서 드라군을 생산하고 넥서스를 확장합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 연달아 건설합니다! 5팩 매스 빌드!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 팩토리가 줄줄이! 5팩토리 매스입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 추가합니다. 자원 확보를 위해서죠.',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5팩 빌드는 시간이 지날수록 강해집니다! 프로토스가 대응책을 찾아야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버 견제 + 아비터 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버로 테란 자원 라인을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 리버 셔틀 출격! SCV를 잡아야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩에서 벌처와 시즈탱크가 쏟아져 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브를 올립니다! 아비터까지 가려 합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아비터를 향한 테크 트리를 올리고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스캐럽으로 SCV를 잡습니다! 자원 채취에 타격!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩 물량이 쌓이기 전에 견제로 자원을 끊어야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 아비터 완성 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터가 완성됩니다! 스테이시스 필드도 준비!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 기갑 대부대가 전진합니다! 시즈탱크가 전열에!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 시즈탱크 줄이 길어집니다! 엄청난 물량!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군과 하이 템플러를 모읍니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5팩 물량 vs 아비터 스테이시스! 승부의 순간입니다!',
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
              text: '{home} 선수 아비터 스테이시스 필드! 시즈탱크 절반이 얼어붙습니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              homeArmy: 2,
              favorsStat: 'strategy',
              altText: '{home}, 스테이시스! 탱크가 통째로 얼어붙었습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리콜로 드라군을 테란 본진에 떨어뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayResource: -25,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 반으로 갈라져 대응이 불가능합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '스테이시스와 리콜! 5팩 물량을 분리시켰습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 물량이 너무 많습니다! 스테이시스로 잡아도 뒤에 더 있어요!',
              owner: LogOwner.away,
              awayArmy: 6,
              homeArmy: -3,
              favorsStat: 'macro',
              altText: '{away}, 5팩 물량이 끝이 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 에너지가 바닥났습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 넥서스 사거리에 자리 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              homeResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '끝없는 물량! 프로토스가 밀립니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
