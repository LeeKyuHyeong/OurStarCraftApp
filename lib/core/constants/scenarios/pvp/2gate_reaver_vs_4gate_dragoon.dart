part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 리버 vs 포게이트 드라군 (공격적 테크 vs 대물량)
// ----------------------------------------------------------
const _pvp2gateReaverVs4gateDragoon = ScenarioScript(
  id: 'pvp_2gate_reaver_vs_4gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_reaver'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '투게이트 리버 vs 포게이트 드라군',
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
          text: '{home} 선수 게이트웨이 추가! 사이버네틱스 코어!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 투게이트! 리버를 빠르게 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어! 게이트웨이를 추가합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스! 서포트 베이!',
          owner: LogOwner.home,
          homeResource: -25, homeArmy: 2,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 연달아 추가! 포게이트!',
          owner: LogOwner.away,
          awayResource: -45, awayArmy: 3,
          altText: '{away}, 포게이트! 드라군을 쏟아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀 리버 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 셔틀 리버! 드라군 호위와 함께!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 4게이트에서 밀려옵니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -30,
        ),
      ],
    ),
    // Phase 1: 교전 준비 (lines 17-26)
    ScriptPhase(
      name: 'battle_setup',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 드라군 대편대가 전진! 4게이트 타이밍!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
          altText: '{away} 선수 드라군 전진! 엄청난 물량!',
        ),
        ScriptEvent(
          text: '{home}, 셔틀 리버에 드라군 호위! 맞받아칩니다!',
          owner: LogOwner.home,
          homeArmy: 4, favorsStat: 'control',
          altText: '{home} 선수 리버와 드라군으로 맞섭니다!',
        ),
        ScriptEvent(
          text: '투게이트 리버 vs 포게이트 드라군! 물량 vs 화력!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 (lines 27-42)
    ScriptPhase(
      name: 'clash_result',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'mass_dragoon_overwhelm',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{away}, 드라군 물량이 셔틀을 집중 사격! 격추!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 셔틀 격추! 리버가 떨어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 고립됩니다! 드라군도 부족!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 남은 드라군 물량으로 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4게이트 물량이 압도적! 리버를 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_devastates',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! 밀집한 드라군에 직격!',
              owner: LogOwner.home,
              awayArmy: -6, favorsStat: 'control',
              altText: '{home} 선수 스캐럽! 드라군이 한 번에!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 녹습니다! 물량 우위가 사라져요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 드라군 호위와 리버 컨트롤! 반격!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '투게이트 리버가 물량을 녹입니다! 화력 차이!',
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
          text: '{home} 선수 앞마당 넥서스!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스!',
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
          text: '양측 전면전! 스톰이 관건입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_reaver_storm_wins',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 스톰과 리버 화력! 드라군을 녹입니다!',
              owner: LogOwner.home,
              awayArmy: -10, homeArmy: -5, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '리버와 스톰! 결정적인 이중 화력!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mass_storm_wins',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 드라군 물량과 함께! 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '물량과 스톰이 합쳐져 결정적!',
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
