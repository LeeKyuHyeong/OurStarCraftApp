part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 캐리어 vs 5팩토리 매스
// ----------------------------------------------------------
const _pvtReaverCarrierVs5facMass = ScenarioScript(
  id: 'pvt_reaver_carrier_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_carrier', 'pvt_reaver_shuttle', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '리버 셔틀 + 캐리어 전환 vs 5팩토리 물량 — 공중 제공권 vs 지상 물량',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설 후 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에 이어 팩토리를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 빠르게 팩토리를 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 생산하면서 로보틱스와 서포트 베이를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2팩토리에서 벌써 3팩토리로!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 계속 늘어납니다! 물량을 준비하고 있어요!',
        ),
        ScriptEvent(
          text: '테란이 팩토리를 계속 올리고 있습니다! 5팩토리 체제를 노리는 것 같네요.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스를 건설합니다. 자원 확보가 필요합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
      ],
    ),
    // Phase 1: 리버 견제 vs 탱크 물량 형성 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀과 리버가 완성됩니다! 테란 확장을 노려야 합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 리버 셔틀이 나옵니다! 테란 뒤를 급습하겠죠!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈탱크가 줄줄이 나옵니다! 5팩토리의 생산력!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 리버가 테란 앞마당 일꾼을 타격합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 스카랩 발사! 테란 일꾼이 날아갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈탱크 라인이 전진합니다! 벌처가 앞에서 정찰하구요.',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -1,
          favorsStat: 'attack',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5팩토리에서 쏟아지는 물량! 리버로 견제하면서 시간을 벌어야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 캐리어 전환 vs 5팩 압박 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트 2개를 건설합니다! 캐리어로 전환합니다!',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 시즈탱크가 10기를 넘었습니다! 엄청난 포격 라인입니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          altText: '{away}, 시즈탱크가 줄지어 시즈 모드! 지상은 뚫을 수가 없습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘을 올립니다! 캐리어만이 답입니다!',
          owner: LogOwner.home,
          homeResource: -30,
          homeArmy: 2,
          altText: '{home}, 플릿 비콘 건설! 탱크 물량은 공중으로 넘겠다는 전략!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 섞기 시작합니다. 공중 전력에 대비하네요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '시즈탱크는 공중을 못 쏩니다! 캐리어가 나오면 탱크 라인이 무의미해집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 캐리어가 탱크 물량 위를 장악 → 홈 승리
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어 편대가 시즈탱크 위를 날아갑니다! 탱크가 올려다보기만 합니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home}, 캐리어가 하늘을 장악합니다! 탱크 포격은 공중에 닿지 않습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 인터셉터가 시즈탱크를 하나씩 파괴합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 부족합니다! 탱크에 너무 많이 투자했습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              homeArmy: 2,
            ),
            ScriptEvent(
              text: '5팩토리 물량이 공중에서는 무용지물! 캐리어의 일방적인 사냥입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 함대가 테란 기지를 초토화합니다! 탱크로는 답이 없습니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 캐리어의 완벽한 제공권! 테란 진영을 쓸어버립니다!',
            ),
          ],
        ),
        // 분기 B: 탱크 라인이 캐리어 전에 밀어붙임 → 어웨이 승리
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈탱크 라인이 전진합니다! 드라군을 한 방에 날립니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 탱크 시즈! 프로토스 지상군이 사정거리 밖에서 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 프로토스 일꾼을 견제합니다! 자원줄을 끊습니다!',
              owner: LogOwner.away,
              homeResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 생산이 늦어지고 있습니다! 자원이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '5팩토리의 물량 앞에 프로토스가 무릎을 꿇고 있습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량이 프로토스를 밀어냅니다! 적 함대는 끝내 나오지 못했습니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 5팩토리 물량의 힘! 프로토스를 지상에서 제압합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
