part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 투게이트 리버 (올인 vs 공격적 테크)
// ----------------------------------------------------------
const _pvpZealotRushVs2gateReaver = ScenarioScript(
  id: 'pvp_zealot_rush_vs_2gate_reaver',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_2gate_reaver'],
  description: '질럿 러시 vs 투게이트 리버',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 앞으로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이! 질럿 러시!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터에 게이트웨이! 올인 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 추가! 사이버네틱스 코어!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 투게이트! 리버를 빠르게 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스! 서포트 베이!',
          owner: LogOwner.away,
          awayResource: -25, awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 추가 질럿! 빠르게 공격!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10,
          altText: '{home}, 질럿이 계속 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 생산! 리버까지 버텨야!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-20)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿이 돌진합니다! 리버 전에 끝내야!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 시간이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군과 질럿으로 막습니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
          altText: '{away}, 수비! 리버가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '질럿 러시 vs 투게이트 리버! 리버가 나오면 끝!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 결과 (lines 21-36)
    ScriptPhase(
      name: 'rush_result',
      startLine: 21,
      branches: [
        ScriptBranch(
          id: 'zealot_rush_success',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 사냥합니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 부족합니다! 리버가 아직!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 질럿이 로보틱스까지 위협합니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 리버가 나오기 전에!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_defends',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{away}, 드라군으로 질럿을 잡습니다! 리버가 나옵니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 리버 합류!',
            ),
            ScriptEvent(
              text: '{away}, 리버 스캐럽! 질럿이 한 번에 터집니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: 2, favorsStat: 'control',
              altText: '{away} 선수 리버! 스캐럽에 질럿이!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 녹습니다! 리버를 상대할 수 없어요!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '리버가 전세를 뒤집습니다! 질럿 러시 실패!',
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
