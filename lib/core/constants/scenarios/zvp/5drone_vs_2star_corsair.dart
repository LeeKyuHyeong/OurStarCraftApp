part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 투스타 커세어 (올인 vs 공중 테크)
// ----------------------------------------------------------
const _zvp5droneVs2starCorsair = ScenarioScript(
  id: 'zvp_5drone_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '9투 올인 저글링 vs 투스타게이트 커세어 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 올립니다! 빠른 저글링을 노리는군요!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 드론 5마리 후 스포닝풀! 올인을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 두 기를 건설합니다! 커세어 대량 생산!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away}, 스타게이트가 두 개! 커세어를 빠르게 모으려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링과 발업이 동시에 나옵니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이에서 질럿을 생산하기 시작합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿 생산! 스타게이트에 자원을 많이 쓴 상태!',
        ),
        ScriptEvent(
          text: '스타게이트 두 기에 투자했으니 지상이 약할 수밖에 없죠!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 본진에 도착합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 진입! 지상 수비가 부족합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 한 기로 입구를 막습니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -1,          altText: '{away}, 질럿으로 버텨야 합니다! 커세어는 도움이 안 되죠!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 질럿을 에워싸고 공격합니다!',
          owner: LogOwner.home,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -1, homeArmy: -1,          altText: '{home}, 서라운드! 질럿을 포위합니다!',
        ),
        ScriptEvent(
          text: '{away}, 프로브까지 동원해서 저글링을 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,
        ),
        ScriptEvent(
          text: '커세어는 저글링을 잡을 수 없습니다! 지상전이 관건!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 공방 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 계속 보냅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 물량 투입! 돌파를 시도합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 나오지만 지상에서는 무력합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '{away}, 추가 질럿을 생산하면서 입구를 지킵니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2, homeArmy: -2,          altText: '{away} 선수 질럿 추가! 입구 방어에 집중합니다!',
        ),
        ScriptEvent(
          text: '{home}, 발업 저글링이 질럿 옆을 파고듭니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 저글링 컨트롤! 질럿 사이를 비집고 들어갑니다!',
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 질럿을 뚫고 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -2,              altText: '{home} 선수 프로브 전멸! 투스타의 약점을 찔렀습니다!',
            ),
            ScriptEvent(
              text: '스타게이트 두 기에 투자한 대가! 지상이 뚫립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 저글링을 전부 잡고 커세어로 오버로드를 사냥합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 3,              altText: '{away} 선수 수비 성공! 커세어가 오버로드를 잡습니다!',
            ),
            ScriptEvent(
              text: '지상 수비 성공! 커세어가 하늘을 장악합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
