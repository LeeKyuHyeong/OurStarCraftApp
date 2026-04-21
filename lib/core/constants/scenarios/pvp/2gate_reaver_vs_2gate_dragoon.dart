part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 리버 vs 투게이트 드라군 (화력 vs 물량)
// ----------------------------------------------------------
const _pvp2gateReaverVs2gateDragoon = ScenarioScript(
  id: 'pvp_2gate_reaver_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_reaver'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '투게이트 리버 vs 투게이트 드라군',
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
          text: '{home} 선수 두 번째 게이트웨이를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 게이트웨이가 두 개! 리버를 노리는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수도 두 번째 게이트웨이! 드라군을 모읍니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 게이트웨이 두 개! 드라군 물량!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 로보틱스 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어! 드라군 사업!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -15, awayArmy: 3,
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이! 리버를 준비합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10, homeArmy: 2,
          altText: '{home} 선수, 서포트 베이! 셔틀 리버 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 쏟아져 나옵니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 드라군 편대! 물량이 두꺼워집니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 전진 vs 리버 출격 (lines 17-26)
    ScriptPhase(
      name: 'dragoon_vs_reaver',
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수, 드라군 편대가 전진! 리버가 나오기 전에!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2,          altText: '{away} 선수 드라군 전진! 타이밍 공격!',
        ),
        ScriptEvent(
          text: '{home} 선수, 셔틀에 리버를 태웁니다! 간발의 차이!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -25,          altText: '{home} 선수 셔틀 리버! 겨우 간에 맞았습니다!',
        ),
        ScriptEvent(
          text: '드라군 물량 vs 리버 화력! 양쪽 게이트 두 개씩 화력 대결!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 (lines 27-42)
    ScriptPhase(
      name: 'clash_result',
      branches: [
        ScriptBranch(
          id: 'dragoon_volume_wins',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{away} 선수, 드라군이 셔틀을 집중 사격! 격추!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,              altText: '{away} 선수 셔틀 격추! 리버가 고립됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 고립! 셔틀 없이는 위험합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수, 드라군 편대가 밀어냅니다! 물량 차이!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,            ),
            ScriptEvent(
              text: '셔틀 격추가 결정적! 드라군 물량이 압도합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_firepower_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 리버 스캐럽! 밀집한 드라군을 강타!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -5,              altText: '{home} 선수 스캐럽! 드라군 3기가 한 번에!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 녹고 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
              altText: '{away} 선수, 스캐럽에 드라군이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 셔틀 리버 컨트롤! 드라군 호위와 함께!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '리버 화력이 드라군을 압도합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
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
          text: '{away} 선수도 앞마당 넥서스! 확장 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수, 하이 템플러 합류! 스톰 준비!',
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
          text: '양측 드라군 하이 템플러! 전면전!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 4: 결전
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_reaver_storm_combo',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{home} 선수, 스톰과 리버! 이중 화력이 상대를 녹입니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰에 스캐럽! 압도적!',
            ),
            ScriptEvent(
              text: '스톰과 리버의 이중 화력! 결정적!',
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
          id: 'away_dragoon_storm_wins',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스톰으로 상대 드라군을 녹입니다! 물량 차이로!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -8, awayArmy: -5,            ),
            ScriptEvent(
              text: '드라군 물량에 스톰! 판을 뒤집습니다!',
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
