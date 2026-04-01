part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. 센터 99게이트 vs 스탠다드 (질럿 러시)
// ----------------------------------------------------------
const _pvpZealotRush = ScenarioScript(
  id: 'pvp_zealot_rush',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush', 'pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_2gate_dragoon', 'pvp_1gate_robo', 'pvp_1gate_multi'],
  description: '센터 게이트 질럿 러시 vs 스탠다드',
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
          altText: '{home}, 센터에 게이트웨이! 질럿 러시입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다!',
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
          altText: '{home} 선수 질럿 러시! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 1기로 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '센터 게이트 질럿 러시! 막을 수 있을까요?',
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
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 잡습니다! 수적 우위!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 큽니다! 자원이 흔들립니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿까지 합류! 상대 본진 초토화!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 프로토스가 무너지고 있습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'rush_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브로 협공! 적 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 완벽한 수비! 질럿 러시를 막습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 녹고 있습니다! 러시 실패!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 드라군이 나오면서 반격 준비!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15,
            ),
            ScriptEvent(
              text: '질럿 러시가 막혔습니다! 테크 차이가 벌어집니다!',
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

