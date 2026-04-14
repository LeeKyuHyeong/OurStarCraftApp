part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 로보 vs 원게이트 멀티
// ----------------------------------------------------------
const _pvp1gateRoboVs1gateMulti = ScenarioScript(
  id: 'pvp_1gate_robo_vs_1gate_multi',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '원게이트 로보 vs 원게이트 멀티',
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
          text: '{home} 선수 사이버네틱스 코어 건설! 로보틱스를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 하나 짓고 바로 넥서스를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 빠른 확장! 자원 이점을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 셔틀 리버를 노립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스! 셔틀 리버를 노리는 모습입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 출격 (lines 15-22)
    ScriptPhase(
      name: 'reaver_harass',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다! 멀티를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: 2, homeResource: -20,
          altText: '{home}, 셔틀 리버 출격! 확장 기지 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 앞마당에 배치합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '셔틀 리버가 멀티를 노립니다! 드라군 배치가 관건!',
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
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 리버가 앞마당에 착지! 스캐럽이 프로브를 학살합니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 리버 착지! 프로브가 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 늦게 도착합니다! 프로브 피해가 큽니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 셔틀이 리버를 다시 태워 본진으로! 추가 견제!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '리버 견제 대성공! 멀티의 일꾼 이점이 사라졌습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드라군이 셔틀 격추
        ScriptBranch(
          id: 'shuttle_destroyed',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 셔틀을 집중 사격합니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 셔틀을 격추합니다! 리버가 고립!',
            ),
            ScriptEvent(
              text: '{home} 선수 셔틀이 파괴됩니다! 리버가 갇혔습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 드라군이 리버를 잡습니다! 견제 실패!',
              owner: LogOwner.away,
              awayArmy: 2,
            ),
            ScriptEvent(
              text: '{away} 선수 멀티 자원으로 병력을 모읍니다! 게이트웨이가 추가됩니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15,
            ),
            ScriptEvent(
              text: '셔틀이 잡혔습니다! 멀티 자원 차이로 역전!',
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
