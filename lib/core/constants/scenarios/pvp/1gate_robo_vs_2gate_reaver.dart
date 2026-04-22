part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 로보 vs 투게이트 리버 (안정 테크 vs 공격적 테크)
// ----------------------------------------------------------
const _pvp1gateRoboVs2gateReaver = ScenarioScript(
  id: 'pvp_1gate_robo_vs_2gate_reaver',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo'],
  awayBuildIds: ['pvp_2gate_reaver'],
  description: '원게이트 로보 vs 투게이트 리버',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 드라군 사업!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 추가! 사이버네틱스 코어!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 게이트웨이가 두 개! 공격적으로 나오겠네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 후 로보틱스를 올립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20, homeArmy: 2,
          altText: '{home} 선수, 로보틱스! 안정적인 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스! 서포트 베이! 빠른 리버!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -25, awayArmy: 2,
          altText: '{away} 선수, 로보틱스에 서포트 베이! 리버를 빠르게!',
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이 건설! 리버 준비!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '양쪽 로보틱스! 하지만 빌드 차이가 있습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 출격 (lines 17-26)
    ScriptPhase(
      name: 'shuttle_reaver_deploy',
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수, 셔틀 리버 출격! 드라군 호위까지!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -25,          altText: '{away} 선수 셔틀 리버! 드라군 호위까지 붙었습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 셔틀 리버! 교차 견제!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,          altText: '{home} 선수, 셔틀 리버 출발! 양쪽 리버 대결!',
        ),
        ScriptEvent(
          text: '리버 대결! 게이트웨이 두 개 쪽이 드라군이 더 많습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 리버 대결 결과 (lines 27-42)
    ScriptPhase(
      name: 'reaver_duel_result',
      branches: [
        ScriptBranch(
          id: 'home_reaver_better_control',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{home} 선수, 리버 컨트롤! 프로브를 정확하게 타격합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -25,              altText: '{home} 선수 스캐럽 명중! 프로브가 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 리버로 견제! 하지만 드라군 호위에 막힙니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,            ),
            ScriptEvent(
              text: '{home} 선수, 드라군으로 상대 셔틀을 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '리버 컨트롤 차이! 프로브 피해가 결정적!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_2gate_reaver_pressure',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{away} 선수, 리버에 드라군 호위! 게이트웨이 두 개의 힘!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -25, homeArmy: -2,              altText: '{away} 선수 리버 견제! 드라군이 셔틀을 지킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버 견제가 드라군에 막힙니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,            ),
            ScriptEvent(
              text: '{away} 선수, 드라군 물량으로 전진합니다! 게이트가 두 개라 빠릅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: 2,            ),
            ScriptEvent(
              text: '드라군 물량 차이가 앞서기 시작합니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 하이 템플러 전환 (lines 43-52)
    ScriptPhase(
      name: 'ht_transition',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스! 확장!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 대결!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 리버 하이 템플러 드라군! 전면전!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 53-65)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_storm_wins',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{home} 선수, 스톰! 리버 스캐럽까지! 이중 화력!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰과 스캐럽 동시에!',
            ),
            ScriptEvent(
              text: '결정적인 스톰! 전장을 지배합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_wins',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스톰에 리버까지! 두꺼운 병력의 화력!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10, awayArmy: -5,              altText: '{away} 선수 스톰과 스캐럽! 압도적!',
            ),
            ScriptEvent(
              text: '리버의 화력이 빛납니다! 결정적!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
