part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 바이오 메카닉
// ----------------------------------------------------------
const _pvt5gateCarrierVsBioMech = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_1gate_expand', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_bar_double'],
  description: '5게이트 캐리어 vs 바이오 메카닉 — 캐리어 vs 골리앗 대공',
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
          text: '{away} 선수 배럭 건설! 아카데미도 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에 아카데미! 바이오닉 체제!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설 후 넥서스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 넥서스! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 탱크와 골리앗을 섞을 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다! 마린 탱크 골리앗 조합!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가합니다. 드라군 물량을 확보합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 마린 탱크 골리앗 복합 조합을 준비합니다.',
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
          text: '{away} 선수 마린 메딕에 탱크, 골리앗까지! 풀조합입니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20, favorsStat: 'macro',
          altText: '{away}, 마린 탱크 골리앗 풀조합! 지상 공중 모두 커버!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 공중 테크를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타게이트! 캐리어를 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 드랍십으로 마린 메딕 기습! 프로토스 일꾼을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 1, homeResource: -15, favorsStat: 'harass',
          altText: '{away}, 드랍십 기습! 일꾼에 타격을 줍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 드랍십을 격추합니다!',
          owner: LogOwner.home,
          homeArmy: 1, awayArmy: -1, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 캐리어까지 가겠다는 의지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 플릿 비콘! 캐리어 테크 확정!',
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
          text: '{home} 선수 더블 스타게이트에서 주력 함선 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 캐리어 생산 돌입! 인터셉터를 채웁니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 추가 생산합니다! 대공 화력 강화!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗이 늘어납니다! 캐리어 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 다섯 개에서 드라군과 질럿도 계속 나옵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '캐리어 vs 골리앗 대공, 누가 이길까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
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
              text: '{home} 선수 캐리어와 드라군이 동시 공격! 지상 공중 협공!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -5, favorsStat: 'attack',
              altText: '{home}, 캐리어 위에서, 드라군 아래에서! 이중 압박!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 노리는 사이 드라군에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -2,
              altText: '{away}, 골리앗이 위를 보는 사이 지상이 뚫립니다!',
            ),
            ScriptEvent(
              text: '{home}, 캐리어 인터셉터가 테란 일꾼을 날립니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '공중과 지상 동시 압박! 테란 복합 편성이 분산되어 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗 편대가 캐리어에 집중 화력! 사거리 업그레이드!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away}, 골리앗 집중 사격! 골리앗이 집중 사격! 적 함대가 버티지 못합니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크 시즈 포격으로 드라군도 정리합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 마린 메딕이 프로토스 진영으로 돌입! 잔여 병력 정리!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 마린 메딕 돌격! 프로토스를 밀어냅니다!',
            ),
            ScriptEvent(
              text: '마린 탱크 골리앗의 복합 화력! 캐리어도 드라군도 막아냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
