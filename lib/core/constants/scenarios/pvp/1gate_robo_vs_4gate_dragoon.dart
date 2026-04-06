part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 로보 vs 포게이트 드라군 (테크 vs 대물량)
// ----------------------------------------------------------
const _pvp1gateRoboVs4gateDragoon = ScenarioScript(
  id: 'pvp_1gate_robo_vs_4gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '원게이트 로보 vs 포게이트 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 로보틱스를 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어! 게이트웨이를 빠르게 추가!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 서포트 베이까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스에 서포트 베이! 리버를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 연달아 추가! 포게이트!',
          owner: LogOwner.away,
          awayResource: -45, awayArmy: 3,
          altText: '{away}, 포게이트! 드라군 물량으로 밀어붙이겠다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀 리버 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 밀려옵니다! 4게이트 물량!',
          owner: LogOwner.away,
          awayArmy: 5, homeArmy: 2, awayResource: -30,
          altText: '{away}, 드라군이 쏟아져 나옵니다!',
        ),
      ],
    ),
    // Phase 1: 물량 압박 vs 리버 (lines 17-26)
    ScriptPhase(
      name: 'mass_dragoon_vs_reaver',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 드라군 대편대가 전진! 4게이트의 위력!',
          owner: LogOwner.away,
          homeArmy: 2, awayArmy: 3, favorsStat: 'attack',
          altText: '{away} 선수 드라군 전진! 수가 엄청나게 많습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 리버가 합류! 하지만 드라군 수가 너무 많습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 리버가 나왔지만 호위 드라군이 부족합니다!',
        ),
        ScriptEvent(
          text: '4게이트 물량 vs 로보 테크! 리버가 버틸 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 (lines 27-42)
    ScriptPhase(
      name: 'clash_result',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'mass_dragoon_overwhelm',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 셔틀을 집중 사격! 수가 너무 많아요!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 드라군 집중 사격! 셔틀이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 셔틀이 격추됩니다! 리버가 고립!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 남은 드라군으로 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4게이트 물량이 압도적! 테크가 완성되기 전에!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_holds_and_turns',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! 밀집한 드라군을 강타합니다!',
              owner: LogOwner.home,
              awayArmy: -6, favorsStat: 'control',
              altText: '{home} 선수 스캐럽! 드라군이 한 번에 3기!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 녹고 있습니다! 물량 우위가 사라져요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 셔틀 컨트롤! 리버를 지켜내며 반격!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '리버 화력이 물량을 역전! 4게이트를 막아냅니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 (lines 43-52)
    ScriptPhase(
      name: 'late_game',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스! 리버로 시간을 벌었습니다!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스! 장기전으로 전환!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 대결!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전면전! 스톰과 드라군!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전
    ScriptPhase(
      name: 'decisive_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_tech_advantage_wins',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 스톰에 리버까지! 이중 화력!',
              owner: LogOwner.home,
              awayArmy: -10, homeArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 스톰과 스캐럽! 상대가 녹습니다!',
            ),
            ScriptEvent(
              text: '테크 이점이 빛을 발합니다! 결정적!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_volume_storm_wins',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 드라군 물량에 스톰까지 더해집니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '물량에 스톰! 결정적인 전투!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
