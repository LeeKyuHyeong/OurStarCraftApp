part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 멀티 vs 투게이트 리버
// ----------------------------------------------------------
const _pvp1gateMultiVs2gateReaver = ScenarioScript(
  id: 'pvp_1gate_multi_vs_2gate_reaver',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_multi'],
  awayBuildIds: ['pvp_2gate_reaver'],
  description: '원게이트 멀티 vs 투게이트 리버',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
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
          text: '{home} 선수 넥서스를 빠르게 건설합니다! 원게이트 멀티!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 빠른 확장! 자원 이점을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 로보틱스를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 셔틀 리버를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 로보틱스! 리버로 견제하겠다는 빌드!',
        ),
      ],
    ),
    // Phase 1: 리버 견제 (lines 15-22)
    ScriptPhase(
      name: 'reaver_harass',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 셔틀에 리버를 태웁니다! 멀티를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 셔틀 리버 출격! 앞마당 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 드라군을 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '셔틀 리버가 멀티를 노립니다! 드라군 배치가 핵심!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 리버 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'reaver_result',
      startLine: 23,
      branches: [
        // 분기 A: 리버 견제 성공
        ScriptBranch(
          id: 'reaver_success',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{away}, 셔틀이 드라군을 피해 앞마당에 착지! 스캐럽!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 리버 착지! 프로브가 학살당합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 뒤늦게 달려옵니다! 프로브 피해가 큽니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 셔틀 태워 본진으로 이동! 추가 견제!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '리버 견제 대성공! 멀티 자원 이점이 사라졌습니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드라군이 셔틀 격추
        ScriptBranch(
          id: 'shuttle_shot_down',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{home}, 드라군이 셔틀을 집중 사격! 격추합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 드라군이 셔틀을 잡습니다! 완벽한 대응!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 잡혔습니다! 리버가 고립됩니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드라군이 리버를 잡습니다! 견제 완전 실패!',
              owner: LogOwner.home,
              homeArmy: 2,
            ),
            ScriptEvent(
              text: '{home} 선수 멀티 자원으로 병력을 빠르게 보충합니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -15,
            ),
            ScriptEvent(
              text: '셔틀이 잡혔습니다! 멀티 자원 차이로 역전!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
