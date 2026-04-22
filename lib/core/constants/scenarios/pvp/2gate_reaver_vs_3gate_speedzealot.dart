part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 리버 vs 쓰리게이트 스피드질럿 (화력 vs 속도 물량)
// ----------------------------------------------------------
const _pvp2gateReaverVs3gateSpeedzealot = ScenarioScript(
  id: 'pvp_2gate_reaver_vs_3gate_speedzealot',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_reaver'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '투게이트 리버 vs 쓰리게이트 스피드질럿',
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
          text: '{home} 선수 게이트웨이 추가! 사이버네틱스 코어!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 게이트웨이가 두 개! 리버를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어! 아둔!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 아둔! 스피드 질럿을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스! 서포트 베이!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25, homeArmy: 2,
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 게이트웨이를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀 리버 생산!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,
          altText: '{home} 선수, 셔틀 리버! 화력을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 다리 업그레이드! 스피드 질럿!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 다리 업그레이드! 질럿이 빨라집니다!',
        ),
      ],
    ),
    // Phase 1: 스피드 질럿 vs 리버 (lines 15-22)
    ScriptPhase(
      name: 'speedzealot_vs_reaver',
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수, 스피드 질럿이 쏟아집니다! 게이트웨이 세 개의 물량!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 5, awayResource: -25,          altText: '{away} 선수 스피드 질럿! 빠른 속도로 돌진!',
        ),
        ScriptEvent(
          text: '{home} 선수, 셔틀 리버에 드라군 호위! 질럿을 막아야!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 2,          altText: '{home} 선수 리버를 내려 질럿을 잡습니다!',
        ),
        ScriptEvent(
          text: '리버 화력 vs 스피드질럿 물량! 화력 vs 속도의 대결!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 (lines 23-38)
    ScriptPhase(
      name: 'clash_result',
      branches: [
        ScriptBranch(
          id: 'reaver_stops_zealot',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{home} 선수, 리버 스캐럽! 밀집한 질럿에 직격!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,              altText: '{home} 선수 스캐럽! 질럿이 한 번에!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 녹습니다! 스캐럽에 속수무책!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수, 드라군과 리버로 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '리버 화력이 질럿을 녹입니다! 화력 차이!',
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
          id: 'speedzealot_overwhelm',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스피드 질럿이 셔틀을 우회! 프로브를 노립니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,              altText: '{away} 선수 질럿이 빠른 속도로 프로브에 도달!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 질럿을 잡지만 수가 너무 많아요!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,            ),
            ScriptEvent(
              text: '{away} 선수, 추가 질럿이 합류! 리버를 둘러쌉니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 2, homeArmy: -3,            ),
            ScriptEvent(
              text: '질럿 물량이 리버를 압도합니다! 속도 차이!',
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
    // Phase 3: 후반 전개 (lines 39-48)
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
          text: '{away} 선수도 앞마당 넥서스!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 대결!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전면전! 스톰과 병력 운용이 관건!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 49-60)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_reaver_storm_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 스톰에 리버 화력! 상대 병력이 녹습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰과 스캐럽! 이중 화력!',
            ),
            ScriptEvent(
              text: '리버와 스톰의 이중 화력! 결정적!',
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
          id: 'away_zealot_storm_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스톰에 스피드 질럿 돌진! 상대를 녹입니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10, awayArmy: -5,              altText: '{away} 선수 스톰! 질럿이 돌진!',
            ),
            ScriptEvent(
              text: '스톰과 스피드 질럿! 결정적인 전투!',
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
