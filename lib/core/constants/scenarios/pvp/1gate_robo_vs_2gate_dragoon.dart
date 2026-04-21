part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 로보 vs 투게이트 드라군 (테크 vs 물량)
// ----------------------------------------------------------
const _pvp1gateRoboVs2gateDragoon = ScenarioScript(
  id: 'pvp_1gate_robo_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '원게이트 로보 vs 투게이트 드라군',
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
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 테크를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 로보틱스! 테크를 올리네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 추가! 드라군을 빠르게 모읍니다!',
          owner: LogOwner.away,
          homeResource: 0,
          homeArmy: 2, awayArmy: 3, awayResource: -20,
          altText: '{away}, 두 번째 게이트웨이! 드라군 물량으로 밀어붙이려는 의도!',
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이 건설! 셔틀과 리버를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,
          altText: '{home}, 서포트 베이! 리버를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 빠르게 모입니다! 사업 완료!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 드라군 편대가 두꺼워지고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀과 리버 생산 시작!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 셔틀에 리버를 태울 준비를 합니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 압박 vs 리버 등장 (lines 17-26)
    ScriptPhase(
      name: 'dragoon_push_vs_reaver',
      linearEvents: [
        ScriptEvent(
          text: '{away}, 드라군 편대가 전진합니다! 테크 전에 밀어야 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 4,          altText: '{away} 선수 드라군 전진! 상대 테크가 완성되기 전에!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 적지만 리버가 합류합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -15,
          altText: '{home}, 리버가 합류! 화력이 보강됩니다!',
        ),
        ScriptEvent(
          text: '드라군 물량 vs 리버 화력! 어느 쪽이 유리할까요?',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'clash_result',
      branches: [
        ScriptBranch(
          id: 'dragoon_overwhelm',
          baseProbability: 0.93,
          events: [
            ScriptEvent(
              text: '{away}, 드라군 물량이 상대 테크 전에 밀어냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4, awayArmy: -2,              altText: '{away} 선수 드라군이 압도합니다! 수가 너무 많아요!',
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_turns_tide',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! 드라군 2기가 한 번에!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,              altText: '{home} 선수 스캐럽 명중! 드라군이 터집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 상대 화력에 녹고 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,
              altText: '{away}, 상대 화력을 감당 못 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버 컨트롤! 내렸다 태웠다! 완벽합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 43-52)
    ScriptPhase(
      name: 'late_game',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스! 비슷한 구성으로 전환!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home}, 하이 템플러 준비! 스톰 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰 대결!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 리버 하이 템플러! 전면전!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 4: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      branches: [
        ScriptBranch(
          id: 'home_storm_reaver_wins',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{home}, 스톰과 리버 화력! 드라군이 녹습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰에 스캐럽 이중 화력!',
            ),
            ScriptEvent(
              text: '스톰과 리버가 결정적! 전장을 지배합니다!',
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
          id: 'away_counter_storm_wins',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{away}, 맞스톰! 양쪽 병력이 동시에 소멸합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -8, awayArmy: -8,            ),
            ScriptEvent(
              text: '맞스톰 이후 병력 운용이 결정적! 판을 뒤집습니다!',
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
