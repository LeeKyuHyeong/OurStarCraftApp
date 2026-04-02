part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 푸시 vs 5팩토리 매스: 견제로 생산 시설 가동 지연
// ----------------------------------------------------------
const _pvtReaverPushVs5facMass = ScenarioScript(
  id: 'pvt_reaver_push_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_push', 'pvt_reaver_shuttle', 'pvt_proxy_dark'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '리버 셔틀 푸시 vs 5팩토리 매스 — 견제로 물량 빌드업 저지',
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
          text: '{away} 선수 팩토리를 연달아 건설합니다! 5팩 빌드!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 팩토리가 줄줄이 올라갑니다! 5팩토리 매스 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이를 건설합니다. 공성 유닛을 준비하는군요.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 로보틱스와 서포트 베이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 확장합니다. 자원이 많이 필요한 빌드이니까요.',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5팩토리가 다 가동되면 물량이 쏟아집니다! 그 전에 끝내야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버 견제로 생산 지연 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버가 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처와 시즈탱크를 생산하기 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 팩토리에서 기갑 병력이 나오기 시작합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀이 팩토리 밀집 지역 뒤편으로 진입합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 셔틀이 팩토리 뒤쪽 SCV를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스캐럽이 미네랄 라인에 떨어집니다! 자원 채취가 줄어들겠네요!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩 가동 전에 자원을 끊느냐 마느냐! 리버 견제의 효율이 관건입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 물량 대결 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 5팩토리가 모두 가동됩니다! 기갑 물량이 쏟아져 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 부대를 모아서 대비합니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 드라군이 상당수 모였습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 리버를 회수하고 정면 전투에 투입합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'strategy',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5팩 물량 vs 리버 드라군! 대규모 교전이 임박합니다!',
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
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 리버 견제로 자원이 부족한 테란! 물량이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 기갑 병력이 예상보다 적습니다! 자원 피해가 컸어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 5팩인데 물량이 안 나옵니다! SCV 손실이 치명적!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군과 리버가 함께 밀고 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '견제가 완벽했습니다! 5팩이 무용지물! GG!',
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
              text: '{away} 선수 견제에도 불구하고 5팩 물량이 밀려옵니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -20,
              favorsStat: 'macro',
              altText: '{away}, 기갑 부대가 끝없이 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 막아보지만 물량 차이가 너무 큽니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 넥서스 사정거리에 자리 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5팩 물량 앞에 프로토스가 밀립니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
