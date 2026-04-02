part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 리버 미러 (공격적 리버 대결)
// ----------------------------------------------------------
const _pvp2gateReaverMirror = ScenarioScript(
  id: 'pvp_2gate_reaver_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_reaver'],
  awayBuildIds: ['pvp_2gate_reaver'],
  description: '투게이트 리버 미러 - 공격적 리버 대결',
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
          text: '{home} 선수 게이트웨이 추가! 투게이트!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 투게이트! 드라군을 빠르게 모읍니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 게이트웨이 추가! 양쪽 투게이트!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 투게이트! 미러 매치!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 로보틱스 건설!',
          owner: LogOwner.home,
          homeResource: -30, homeArmy: 2,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어! 로보틱스 건설!',
          owner: LogOwner.away,
          awayResource: -30, awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이! 리버를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 서포트 베이! 빠른 리버!',
        ),
        ScriptEvent(
          text: '{away} 선수도 서포트 베이! 양쪽 리버 경쟁!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
      ],
    ),
    // Phase 1: 리버 출격 (lines 17-26)
    ScriptPhase(
      name: 'reaver_deploy',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 셔틀에 리버를 태웁니다! 투게이트 드라군과 함께!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버! 드라군 호위까지!',
        ),
        ScriptEvent(
          text: '{away} 선수도 셔틀 리버! 양쪽 공격적 리버 운용!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25, favorsStat: 'harass',
          altText: '{away}, 셔틀 리버! 양쪽 다 공격적입니다!',
        ),
        ScriptEvent(
          text: '양쪽 투게이트 리버! 누가 먼저 치명타를 입힐까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 리버 교전 결과 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'reaver_clash_result',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'home_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! 상대 드라군 2기가 한 번에!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 스캐럽 명중! 드라군이 터집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 상대 셔틀을 노립니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 컨트롤! 내렸다 태웠다! 완벽합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 셔틀 리버 컨트롤이 한 수 위!',
            ),
            ScriptEvent(
              text: '리버 컨트롤 차이가 결정적! 병력을 압도합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버 스캐럽! 상대 드라군 2기가 한 번에!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 스캐럽 명중! 드라군이 터집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 상대 셔틀을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 셔틀 컨트롤! 내렸다 태웠다! 완벽합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 셔틀 리버 컨트롤이 한 수 위!',
            ),
            ScriptEvent(
              text: '리버 컨트롤 차이가 결정적! 병력을 압도합니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 하이 템플러 (lines 43-52)
    ScriptPhase(
      name: 'ht_lategame',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스! 확장 경쟁!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰 대결!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 리버 하이 템플러! 전면전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 53-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_storm_reaver_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰에 리버 스캐럽! 이중 화력!',
              owner: LogOwner.home,
              awayArmy: -10, homeArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 스톰과 스캐럽! 상대 병력이 녹습니다!',
            ),
            ScriptEvent(
              text: '스톰과 리버가 결정적! 전장을 지배합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_reaver_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰에 리버 스캐럽! 이중 화력!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'strategy',
              altText: '{away} 선수 스톰과 스캐럽! 상대 병력이 녹습니다!',
            ),
            ScriptEvent(
              text: '스톰과 리버가 결정적! 전장을 지배합니다!',
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
