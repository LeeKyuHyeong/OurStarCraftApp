part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 로보 미러 (리버 대결)
// ----------------------------------------------------------
const _pvpRoboMirror = ScenarioScript(
  id: 'pvp_robo_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  awayBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  description: '로보틱스 미러 - 셔틀 리버 대결',
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
          text: '{home} 선수 사이버네틱스 코어! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군을 뽑습니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 서포트 베이까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스에 서포트 베이! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스에 서포트 베이! 양쪽 테크 경쟁입니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 로보틱스에 서포트 베이! 테크 경쟁!',
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 출격 (lines 17-26)
    ScriptPhase(
      name: 'shuttle_reaver_deploy',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 셔틀에 리버를 태웁니다! 출격!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버 출격! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 셔틀 리버! 교차 견제!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25, favorsStat: 'harass',
          altText: '{away}, 셔틀 리버 출발! 양쪽 리버가 교차합니다!',
        ),
        ScriptEvent(
          text: '양측 셔틀 리버 교차! 누가 먼저 피해를 입힐까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 셔틀 리버 견제 결과 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'reaver_harass_result',
      startLine: 27,
      branches: [
        // 분기 A: 홈 리버 견제 성공 + 어웨이 셔틀 격추
        ScriptBranch(
          id: 'home_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 리버가 프로브 쪽에 착지! 스캐럽!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 리버 투하! 프로브가 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 상대 셔틀을 노립니다! 격추!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 셔틀 격추! 하지만 프로브 피해가 크네요!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀은 잃었지만 프로브 피해를 더 많이 줬습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '리버 교환이 끝났습니다! 프로브 피해 차이가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 리버 견제 성공 + 홈 셔틀 격추
        ScriptBranch(
          id: 'away_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버가 프로브 쪽에 투하! 스캐럽 명중!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 리버 투하! 프로브가 쓸려갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 상대 셔틀을 잡습니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{home}, 셔틀을 잡긴 했지만 프로브 피해가!',
            ),
            ScriptEvent(
              text: '{away}, 프로브 피해를 더 많이 입혔습니다! 자원 이점!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '리버 견제 교환! 프로브 피해가 핵심이었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 하이 템플러 준비 (lines 43-50)
    ScriptPhase(
      name: 'ht_prepare',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 하이 템플러! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰 대결!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 리버 하이 템플러! 전면전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 분기 (lines 51-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 51,
      branches: [
        ScriptBranch(
          id: 'home_storm_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '{away}, 맞스톰! 하지만 이미 병력 차이가 벌어졌습니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3,
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 스톰! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '{home}, 맞스톰! 하지만 이미 병력 차이가 벌어졌습니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3,
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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

