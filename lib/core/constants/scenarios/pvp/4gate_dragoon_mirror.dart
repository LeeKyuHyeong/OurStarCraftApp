part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 포게이트 드라군 미러 (물량 대결)
// ----------------------------------------------------------
const _pvp4gateDragoonMirror = ScenarioScript(
  id: 'pvp_4gate_dragoon_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_4gate_dragoon'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '포게이트 드라군 미러 - 드라군 물량 대결',
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
          text: '{home} 선수 게이트웨이를 연달아 추가합니다! 세 개, 네 개!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -45, homeArmy: 2,
          altText: '{home} 선수, 게이트웨이를 빠르게 늘립니다! 벌써 네 개!',
        ),
        ScriptEvent(
          text: '{away} 선수도 게이트웨이 네 개! 양쪽 물량 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -45, awayArmy: 2,
          altText: '{away} 선수, 게이트웨이 네 개! 양쪽 드라군 물량 싸움이 됩니다!',
        ),
        ScriptEvent(
          text: '양쪽 게이트웨이 네 개씩! 드라군 생산 속도 경쟁입니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 드라군 편대 형성 (lines 15-24)
    ScriptPhase(
      name: 'dragoon_buildup',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수, 드라군 편대가 모입니다! 게이트웨이에서 쏟아져 나옵니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -30,
          altText: '{home} 선수 드라군이 빠르게 모입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 편대 구성! 물량이 비슷합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 5, awayResource: -30,
          altText: '{away} 선수, 드라군이 모입니다! 비슷한 물량!',
        ),
        ScriptEvent(
          text: '양측 드라군 편대가 전진합니다! 센터에서 충돌!',
          owner: LogOwner.system,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 2, awayArmy: 2,        ),
      ],
    ),
    // Phase 2: 드라군 교전 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'dragoon_clash_result',
      branches: [
        ScriptBranch(
          id: 'home_dragoon_micro_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 드라군 컨트롤! 집중 사격으로 상대 드라군을 잡습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -5, homeArmy: -3,              altText: '{home} 선수 드라군 마이크로! 상대보다 교환이 좋습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 밀리고 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수, 드라군 편대가 전진! 상대 진영을 위협합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '드라군 물량 차이가 결정적! 밀어냅니다!',
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
          id: 'away_dragoon_micro_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수, 드라군 컨트롤! 집중 사격으로 상대 드라군을 잡습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: -3,              altText: '{away} 선수 드라군 마이크로! 상대보다 교환이 좋습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 밀리고 있습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수, 드라군 편대가 전진! 상대 진영을 위협합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,            ),
            ScriptEvent(
              text: '드라군 물량 차이가 결정적! 밀어냅니다!',
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
    // Phase 3: 후반 하이 템플러 전환 (lines 41-52)
    ScriptPhase(
      name: 'late_ht_transition',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 아둔! 스톰을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아둔! 양쪽 하이 템플러 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 드라군과 함께!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 대결 임박!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -20,
        ),
        ScriptEvent(
          text: '양측 하이 템플러가 합류! 스톰 대결이 임박합니다!',
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
      name: 'decisive_storm',
      branches: [
        ScriptBranch(
          id: 'home_storm_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 스톰! 밀집한 드라군이 한 번에 녹습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -4,              altText: '{home} 선수 스톰 명중! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '스톰이 전세를 결정합니다! 압도적!',
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
          id: 'away_storm_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스톰! 밀집한 드라군이 한 번에 녹습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10, awayArmy: -4,              altText: '{away} 선수 스톰 명중! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '스톰이 전세를 결정합니다! 압도적!',
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
