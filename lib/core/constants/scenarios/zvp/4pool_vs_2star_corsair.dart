part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 투스타 커세어 (치즈 vs 공중 테크)
// ----------------------------------------------------------
const _zvp4poolVs2starCorsair = ScenarioScript(
  id: 'zvp_4pool_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '4풀 저글링 올인 vs 투스타게이트 커세어 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 바로 스포닝풀! 올인입니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 4드론에 스포닝풀! 극초반 러시를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스 뒤에 스타게이트를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 스타게이트 건설! 커세어를 준비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리가 부화! 프로토스 본진으로 달립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이에서 질럿을 생산하기 시작합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿 생산! 수비 유닛이 필요합니다!',
        ),
        ScriptEvent(
          text: '스타게이트에 투자한 자원이 많은데, 저글링을 막을 수 있을까요?',
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
          text: '{home}, 저글링이 프로토스 본진에 도착합니다! 질럿이 1기뿐!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 진입! 수비 유닛이 부족합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 한 기와 프로브로 저글링을 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 프로브를 집중 공격! 일꾼이 줄어듭니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home}, 프로브를 잡습니다! 스타게이트에 자원을 쓴 게 약점!',
        ),
        ScriptEvent(
          text: '{away}, 질럿이 추가로 나오면서 저글링을 잡기 시작합니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2, homeArmy: -2,          altText: '{away} 선수 질럿 추가! 저글링을 막아냅니다!',
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 생산해서 보냅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 웨이브! 한 번 더 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트에서 커세어가 나옵니다! 하지만 지상 수비가 급합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '커세어는 저글링을 잡을 수 없죠! 지상 유닛이 관건입니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 질럿을 계속 생산하면서 입구를 막습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2,          altText: '{away} 선수 입구 봉쇄! 질럿으로 버텨야 합니다!',
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
              text: '{home}, 저글링이 질럿 사이를 뚫고 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -2,              altText: '{home} 선수 프로브 전멸! 스타게이트에 투자한 게 독이 됐습니다!',
            ),
            ScriptEvent(
              text: '일꾼이 사라진 프로토스! 극초반 저글링 러시 성공입니다!',
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
              text: '{away}, 질럿이 저글링을 전부 잡아내고 커세어까지 합류합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 3,              altText: '{away} 선수 완벽한 수비! 커세어로 오버로드까지 사냥합니다!',
            ),
            ScriptEvent(
              text: '저글링 러시 실패! 프로토스가 커세어로 하늘을 장악합니다!',
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
