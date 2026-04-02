part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 커세어 운영 (올인 vs 밸런스)
// ----------------------------------------------------------
const _zvp5droneVsCorsair = ScenarioScript(
  id: 'zvp_5drone_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '9투 올인 저글링 vs 커세어 운영 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 건설합니다! 9투 올인!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀 착공! 저글링 물량 러시를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어를 올리고 스타게이트를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 발업까지 연구!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15,
          altText: '{home}, 저글링+발업! 프로토스 본진을 급습합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿을 생산하면서 커세어 테크를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿 수비! 스타게이트까지 시간을 벌어야 합니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 돌격 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 빠른 발업이 유효합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿으로 입구를 막고 프로브를 대피시킵니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 입구 봉쇄! 프로브를 뒤로 빼냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 질럿 옆을 파고들면서 프로브를 잡습니다!',
          owner: LogOwner.home,
          awayResource: -10, homeArmy: -1, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away}, 추가 질럿이 합류하면서 저글링을 잡기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -2, favorsStat: 'defense',
          altText: '{away} 선수 질럿 합류! 저글링이 녹기 시작합니다!',
        ),
        ScriptEvent(
          text: '커세어가 나오기 전에 지상에서 결판이 나야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 공방 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 보냅니다! 밀어붙여야 합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 추가 투입! 시간이 저그 편이 아닙니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트에서 커세어가 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 저글링으로 마지막 돌파를 시도합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 마지막 웨이브! 모든 것을 겁니다!',
        ),
        ScriptEvent(
          text: '{away}, 커세어가 오버로드를 사냥하기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'harass',
          altText: '{away} 선수 오버로드 사냥! 저그의 보급이 줄어듭니다!',
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 질럿을 뚫고 넥서스를 파괴합니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 넥서스 파괴! 프로토스가 무너집니다!',
            ),
            ScriptEvent(
              text: '커세어가 늦었습니다! 저글링 올인 성공!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 저글링을 전멸시키고 커세어가 하늘을 장악합니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: 3, favorsStat: 'defense',
              altText: '{away} 선수 완벽한 수비! 커세어로 전환합니다!',
            ),
            ScriptEvent(
              text: '지상 수비 후 커세어 운영! 프로토스의 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
