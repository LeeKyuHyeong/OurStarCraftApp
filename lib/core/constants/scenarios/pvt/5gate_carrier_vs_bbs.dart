part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs BBS 마린 러시
// ----------------------------------------------------------
const _pvt5gateCarrierVsBbs = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_1gate_expand', 'pvt_carrier'],
  awayBuildIds: ['tvp_bbs'],
  description: '5게이트 캐리어 vs BBS 마린 러시 — 초반 수비 후 캐리어 지배',
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
          text: '{away} 선수 배럭을 두 개 동시에 올립니다! 마린을 빠르게 뽑겠네요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭이 두 개! 초반 러시를 노리는군요!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어를 올리고 있습니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 마린을 모아서 출격합니다! SCV도 함께!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -10,
          altText: '{away}, 마린과 SCV 총출동! 배럭 두 개의 물량이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '배럭 두 개에서 마린이 쏟아집니다! 프로토스 입구가 위험합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿과 프로브로 방어합니다! 파일런으로 입구를 좁힙니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 필사적인 수비! 질럿과 프로브 동원!',
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
          text: '{home} 선수 드라군이 합류하면서 마린을 밀어냅니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -4, favorsStat: 'defense',
          altText: '{home}, 드라군 등장! 마린을 압도합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 러시가 실패합니다. 뒤늦게 팩토리를 올리고 있어요.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가하며 안정을 찾습니다. 넥서스도 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 수비 성공! 넥서스와 게이트웨이 추가!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 공중 테크를 가져갑니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타게이트가 올라갑니다! 캐리어를 노리는 건가요?',
        ),
        ScriptEvent(
          text: '초반 러시 실패 후 테란이 큰 불리를 안고 있습니다.',
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
          text: '{home} 선수 스타게이트 2개 가동! 플릿 비콘도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 더블 스타게이트에 플릿 비콘! 캐리어 체제!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 골리앗을 뽑으려 하지만 늦었습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 뒤늦게 골리앗 생산! 대공 준비가 되긴 할까요?',
        ),
        ScriptEvent(
          text: '{home} 선수 캐리어 생산 시작! 인터셉터를 채웁니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 캐리어가 나옵니다! 인터셉터 충전 중!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 5개에서 드라군도 계속 나옵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
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
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어 편대가 출격합니다! 인터셉터가 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -5, favorsStat: 'macro',
              altText: '{home}, 캐리어 3기! 인터셉터 비가 쏟아져 내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 수가 부족합니다! 캐리어를 막을 수 없어요!',
              owner: LogOwner.away,
              awayArmy: -4,
              altText: '{away}, 골리앗이 너무 적습니다! 초반 올인의 후유증이네요!',
            ),
            ScriptEvent(
              text: '{home}, 캐리어와 드라군 총공격! 테란을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '초반 러시 실패 후 캐리어! 프로토스의 완벽한 역전입니다!',
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
              text: '{away} 선수 캐리어 완성 전에 총공격! 탱크와 마린이 전진!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away}, 캐리어 전에 승부! 남은 병력으로 총공격!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크 포격! 프로토스 방어선을 뚫습니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 포격! 캐리어 나오기 전에 끝내야 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어가 아직 인터셉터를 다 못 채웠습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '캐리어 완성 전에 테란이 밀어냅니다! 타이밍의 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
