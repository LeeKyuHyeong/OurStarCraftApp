part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 드라군 푸쉬 (올인 vs 공격형)
// ----------------------------------------------------------
const _zvp5droneVsDragoonPush = ScenarioScript(
  id: 'zvp_5drone_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '9투 올인 저글링 vs 질럿과 드라군 러쉬',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 올립니다! 저글링 물량으로 밀어붙이려 합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 드론 5마리 후 스포닝풀! 저글링 러시를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 두 기를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 투게이트! 질럿을 빠르게 뽑으려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화! 발업 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 연속으로 생산됩니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 질럿 연속 생산! 수비와 역공을 동시에 준비!',
        ),
        ScriptEvent(
          text: '질럿이 빠르게 나오고 있습니다! 저글링이 뚫을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 교전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 입구에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'control',
          altText: '{home} 선수 저글링 도착! 질럿이 입구를 막고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 두 기로 입구를 봉쇄합니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'defense',
          altText: '{away}, 질럿 벽! 저글링이 들어갈 틈이 없습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 옆을 우회해서 프로브를 노립니다!',
          owner: LogOwner.home,
          awayResource: -5, favorsStat: 'harass',
          altText: '{home}, 저글링이 질럿 사이를 비집고 들어갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 사이버네틱스 코어 완성! 드라군 생산을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '드라군까지 합류하면 저글링은 접근이 힘들어지죠.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 계속 보내지만 질럿과 드라군에 막힙니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 저글링 추가! 돌파구를 찾으려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 원거리에서 저글링을 정리합니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: 1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home}, 마지막 저글링까지 투입합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -5, favorsStat: 'attack',
          altText: '{home} 선수 마지막 웨이브! 모든 것을 걸었습니다!',
        ),
        ScriptEvent(
          text: '{away}, 드라군과 질럿을 모아서 역공을 준비합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
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
              text: '{home}, 발업 저글링이 드라군 뒤를 잡고 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 프로브 전멸! 드라군 뒤를 파고들었습니다!',
            ),
            ScriptEvent(
              text: '일꾼이 사라진 프로토스! 저글링 러시 성공!',
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
              text: '{away}, 드라군과 질럿이 저글링을 전멸시키고 저그 본진으로 진격합니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: 3, favorsStat: 'attack',
              altText: '{away} 선수 역공! 드론이 없는 저그를 밀어냅니다!',
            ),
            ScriptEvent(
              text: '드라군 푸쉬로 저그를 마무리합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
