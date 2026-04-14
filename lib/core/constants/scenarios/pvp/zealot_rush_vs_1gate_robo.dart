part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 원게이트 로보 (올인 vs 테크)
// ----------------------------------------------------------
const _pvpZealotRushVs1gateRobo = ScenarioScript(
  id: 'pvp_zealot_rush_vs_1gate_robo',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_1gate_robo'],
  description: '질럿 러시 vs 원게이트 로보',
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
          altText: '{home}, 센터에 게이트웨이! 빠른 질럿!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 테크를 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 로보틱스! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 질럿! 공격 준비!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10,
          altText: '{home}, 질럿이 계속 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 서포트 베이 건설! 리버 준비!',
          owner: LogOwner.away,
          awayResource: -10, awayArmy: 2,
          altText: '{away}, 서포트 베이! 리버를 준비합니다!',
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-20)
    ScriptPhase(
      name: 'zealot_charge',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿이 상대 진영으로 돌진합니다! 테크 전에 끝내야!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군과 질럿으로 막습니다! 리버까지 버텨야!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 수비! 리버가 나올 때까지!',
        ),
        ScriptEvent(
          text: '질럿 러시 vs 로보틱스 테크! 시간 싸움입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'rush_vs_tech_result',
      startLine: 21,
      branches: [
        ScriptBranch(
          id: 'zealot_before_reaver',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 잡습니다! 테크가 아직이에요!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 리버가 생산 중이지만 시간이 부족합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 로보틱스까지 위협합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 상대 테크가 완성되기 전에!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_saves',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브로 버팁니다! 리버가 곧!',
              owner: LogOwner.away,
              homeArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 수비! 리버만 나오면!',
            ),
            ScriptEvent(
              text: '{away}, 리버가 나왔습니다! 스캐럽! 질럿이 터집니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: 2, favorsStat: 'control',
              altText: '{away} 선수 리버 등장! 스캐럽 한 방에 질럿이!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 상대 화력에 녹고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '리버가 전세를 뒤집습니다! 질럿으로는 감당할 수 없습니다!',
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
