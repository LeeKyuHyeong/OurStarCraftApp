part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 멀티 미러 (운영 대결)
// ----------------------------------------------------------
const _pvp1gateMultiMirror = ScenarioScript(
  id: 'pvp_1gate_multi_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_multi'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '원게이트 멀티 미러 - 확장 운영 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
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
          text: '{home} 선수 게이트웨이 하나 짓자마자 넥서스를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home}, 빠른 확장! 자원 이점을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 넥서스를 올립니다! 양쪽 빠른 확장이네요!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away}, 빠른 확장! 미러 운영전!',
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
          text: '{away} 선수도 사이버네틱스 코어!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 빠른 확장! 장기 운영전이 예상됩니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 드라군 생산 + 확장 안정화 (lines 10-24)
    ScriptPhase(
      name: 'dragoon_expansion',
      linearEvents: [
        ScriptEvent(
          text: '양측 드라군 생산 시작! 앞마당을 지킵니다!',
          owner: LogOwner.system,
          homeArmy: 3, awayArmy: 3, homeResource: -15, awayResource: -15,
          altText: '{home}과 {away}, 동시에 드라군 생산 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가! 멀티 자원으로!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 게이트웨이 추가! 멀티의 힘!',
        ),
        ScriptEvent(
          text: '{away} 선수도 게이트웨이 추가! 양쪽 비슷한 구성!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양측 확장이 안정됩니다! 테크 경쟁으로 넘어갑니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 테크 경쟁 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'tech_race',
      branches: [
        ScriptBranch(
          id: 'home_faster_tech',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 로보틱스 건설! 리버를 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
              altText: '{home}, 로보틱스! 셔틀 리버를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 로보틱스! 하지만 한 발 늦습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 서포트 베이에 셔틀 리버! 견제 출발!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 3, homeResource: -25,            ),
            ScriptEvent(
              text: '{home} 선수 리버 견제! 상대 프로브에 스캐럽!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,              altText: '{home}, 리버 스캐럽! 프로브가 터집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_faster_tech',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 로보틱스 건설! 리버를 준비합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,
              altText: '{away}, 로보틱스! 셔틀 리버를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 로보틱스! 하지만 한 발 늦습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 서포트 베이에 셔틀 리버! 견제 출발!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 3, awayResource: -25,            ),
            ScriptEvent(
              text: '{away} 선수 리버 견제! 상대 프로브에 스캐럽!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,              altText: '{away}, 리버 스캐럽! 프로브가 터집니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 하이 템플러 전환 (lines 41-52)
    ScriptPhase(
      name: 'ht_transition',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 아둔! 하이 템플러 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 연구 완료!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 멀티 자원으로 대규모 병력! 결전!',
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
          id: 'home_macro_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰에 리버 화력! 상대 병력이 녹습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰과 리버! 이중 화력!',
            ),
            ScriptEvent(
              text: '자원 운용이 한 수 위! 결정적인 전투!',
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
          id: 'away_macro_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰에 리버 화력! 상대 병력이 녹습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10, awayArmy: -5,              altText: '{away} 선수 스톰과 리버! 이중 화력!',
            ),
            ScriptEvent(
              text: '자원 운용이 한 수 위! 결정적인 전투!',
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
