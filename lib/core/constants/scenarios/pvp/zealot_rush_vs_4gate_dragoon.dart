part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 포게이트 드라군
// ----------------------------------------------------------
const _pvpZealotRushVs4gateDragoon = ScenarioScript(
  id: 'pvp_zealot_rush_vs_4gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '질럿 러시 vs 포게이트 드라군',
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
          text: '{home} 선수 센터에 게이트웨이! 질럿 러시입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 게이트! 빠른 질럿을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 사업입니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다! 포게이트 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 빠르게 추가합니다! 포게이트!',
          owner: LogOwner.away,
          awayResource: -45,
          altText: '{away}, 게이트웨이 4개! 드라군 물량 빌드!',
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿 3기가 돌진합니다! 포게이트가 돌기 전에!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 드라군 물량이 나오기 전에 끝내야!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 1기로 막으며 게이트웨이 가동을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '질럿 러시 vs 포게이트! 초반 타이밍 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 19-34)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        // 분기 A: 질럿이 초반에 밀어냄
        ScriptBranch(
          id: 'zealot_rush_wins',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 드라군을 잡고 프로브를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -1, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 본진에 침투합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 게이트웨이에 자원을 쏟아서 방어가 약합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 프로브를 학살합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '포게이트에 자원을 쏟은 대가! 질럿 러시가 본진을 초토화!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드라군이 나오면서 수비
        ScriptBranch(
          id: 'four_gate_defense',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 나오기 시작합니다! 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'defense',
              altText: '{away} 선수 드라군으로 질럿을 저격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 드라군에 녹습니다! 사정거리 차이!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 포게이트에서 드라군이 쏟아집니다! 압도적 물량!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '포게이트 드라군 물량! 질럿 러시를 완벽하게 막아냅니다!',
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
