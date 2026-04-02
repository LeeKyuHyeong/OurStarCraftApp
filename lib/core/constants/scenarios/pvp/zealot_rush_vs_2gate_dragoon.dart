part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 투게이트 드라군
// ----------------------------------------------------------
const _pvpZealotRushVs2gateDragoon = ScenarioScript(
  id: 'pvp_zealot_rush_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '질럿 러시 vs 투게이트 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터에 게이트웨이! 질럿 러시 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가합니다! 투게이트!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 빠르게 돌진해야 합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다! 상대 테크 전에 끝내야 해요!',
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿 3기가 상대 진영으로 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 상대 화력이 갖춰지기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿으로 막으면서 드라군 생산을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '질럿 러시 vs 투게이트 드라군! 드라군이 나오면 막힙니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 19-32)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        ScriptBranch(
          id: 'zealot_rush_wins',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 잡습니다! 수적 우위!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 큽니다! 드라군이 아직 안 나왔어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿까지 합류! 본진을 초토화합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 상대 테크가 갖춰지기 전에 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'dragoon_defense',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브로 시간을 벌었습니다! 드라군 등장!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: 3, favorsStat: 'defense',
              altText: '{away} 선수 드라군이 나옵니다! 질럿을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 상대 화력에 녹습니다! 사정거리 차이!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 투게이트에서 드라군이 쏟아집니다! 반격 개시!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15,
            ),
            ScriptEvent(
              text: '드라군이 질럿 러시를 막아냅니다! 테크 차이가 결정적!',
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
