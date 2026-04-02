part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 5팩토리 물량
// ----------------------------------------------------------
const _pvt5gateCarrierVs5facMass = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_1gate_expand', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '5게이트 캐리어 vs 5팩토리 물량 — 공중 편대 vs 지상 물량',
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
          text: '{away} 선수 배럭 이후 팩토리를 연속으로 올립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리가 줄줄이! 5팩 체제를 만들어갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스를 올리며 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 5개 체제 완성! 벌처 탱크가 밀려나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 5팩토리 가동! 끊임없는 물량!',
        ),
        ScriptEvent(
          text: '테란 5팩토리 물량 빌드입니다. 엄청난 생산력이네요.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 늘리면서 드라군을 생산합니다.',
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
          text: '{away} 선수 탱크 물량이 쌓입니다! 시즈 라인이 전진하고 있어요!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'macro',
          altText: '{away}, 탱크가 8대, 9대! 시즈 라인이 길어집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 지상으로는 밀린다는 판단! 스타게이트 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타게이트! 공중으로 가야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 캐리어를 서두릅니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 플릿 비콘이 급하게 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 프로토스 확장기지를 견제합니다!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'harass',
          altText: '{away}, 벌처 견제! 프로토스 일꾼에 타격!',
        ),
        ScriptEvent(
          text: '프로토스가 캐리어 전까지 버틸 수 있을까요?',
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
          text: '{home} 선수 더블 스타게이트에서 주력 함선 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 캐리어가 나옵니다! 인터셉터를 채우는 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗도 섞기 시작합니다. 대공 대비!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗 추가! 캐리어를 의식한 대응!',
        ),
        ScriptEvent(
          text: '{home} 선수 캐리어 2기 완성! 인터셉터 충전 완료!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 물량이 15대를 넘어갑니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
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
              text: '{home} 선수 캐리어 편대가 탱크 위로 날아갑니다! 탱크는 공중을 못 칩니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -6, favorsStat: 'macro',
              altText: '{home}, 캐리어가 탱크 라인 위에서 인터셉터를 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 대공 사격을 하지만 캐리어가 너무 단단합니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 캐리어로 탱크 라인을 하나씩 정리합니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'attack',
              altText: '{home} 선수 캐리어가 탱크를 하나씩 파괴합니다! 물량이 의미 없습니다!',
            ),
            ScriptEvent(
              text: '공중 화력이 지상 물량을 압도합니다! 캐리어의 지배!',
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
              text: '{away} 선수 골리앗 편대가 캐리어를 집중 공격! 대공 화력 집중!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away}, 골리앗이 공중 함대를 노립니다! 집중 포화!',
            ),
            ScriptEvent(
              text: '{away}, 탱크 물량이 프로토스 앞마당을 시즈로 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 15대 탱크의 시즈 포격! 앞마당이 초토화!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 1기가 격추되면서 공중 화력이 줄어듭니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '5팩토리 물량과 골리앗 대공! 캐리어를 막아냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
