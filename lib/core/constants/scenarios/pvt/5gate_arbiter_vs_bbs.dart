part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs BBS 마린 러시
// ----------------------------------------------------------
const _pvt5gateArbiterVsBbs = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_bbs'],
  description: '5게이트 아비터 vs BBS 마린 러시 — 초반 수비 후 스톰+리콜',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭을 두 개 건설합니다! 마린을 빠르게 모으겠네요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭 2개가 올라갑니다! 공격적인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린을 대량 생산! SCV와 함께 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -10,
          altText: '{away}, 마린을 끌고 나갑니다! 일꾼까지 동원한 올인!',
        ),
        ScriptEvent(
          text: '테란이 배럭 두 개로 마린 러시를 합니다! 프로토스가 막아낼 수 있을까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이에서 질럿 생산! 프로브와 함께 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 질럿과 프로브 동원! 필사적인 수비입니다!',
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 마린이 프로토스 입구에 도달합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away}, 마린 편대가 입구에 도착! 교전 시작입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 합류! 마린을 상대로 사거리 우위를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -3, favorsStat: 'control',
          altText: '{home}, 드라군이 나왔습니다! 마린 상대로 효과적이죠!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 러시를 막아냈습니다! 게이트웨이를 추가합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 수비 성공! 이제 게이트웨이를 늘립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 팩토리를 올리며 체제를 정비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '초반 러시가 실패하면서 테란이 불리해졌습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 5개 가동! 아둔에 템플러 아카이브까지 올립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 게이트웨이 다섯 개 체제! 템플러 아카이브도 건설!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 시즈 탱크 생산! 방어선을 구축합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 시즈 탱크가 나옵니다! 방어 태세입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 아비터 트리뷰널까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타게이트에 아비터 트리뷰널! 아비터를 노리는군요!',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 생산 시작! 사이오닉 스톰을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '프로토스의 테크가 완성되어 가고 있습니다. 아비터까지 나오면 큰일인데요.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 등장! 리콜 에너지가 찼습니다!',
              owner: LogOwner.home,
              homeArmy: 4, favorsStat: 'sense',
              altText: '{home}, 아비터가 나왔습니다! 리콜 준비 완료!',
            ),
            ScriptEvent(
              text: '{home}, 리콜! 테란 본진에 드라군 질럿이 떨어집니다!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 리콜 투하! 테란 본진이 아수라장!',
            ),
            ScriptEvent(
              text: '{home}, 하이 템플러 스톰까지! 상대 병력이 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '아비터 리콜과 스톰의 조합! 테란이 무너집니다!',
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
              text: '{away} 선수 아비터가 나오기 전에 총공격! 시즈 탱크와 마린이 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
              altText: '{away}, 아비터 전에 승부를 걸어야 합니다! 전군 돌격!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크 포격이 프로토스 방어선을 뚫습니다!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 시즈 모드! 프로토스 건물이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터가 나오지 못합니다! 스타게이트가 파괴!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '테란의 타이밍 공격이 성공합니다! 아비터 전에 끝났습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
