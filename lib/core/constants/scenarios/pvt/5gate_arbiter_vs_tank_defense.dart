part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 시즈 탱크 터틀
// ----------------------------------------------------------
const _pvt5gateArbiterVsTankDefense = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter'],
  awayBuildIds: ['tvp_trans_tank_defense'],
  description: '5게이트 아비터 vs 탱크 터틀 — 리콜로 방어선 우회',
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
          text: '{away} 선수 배럭 건설 후 팩토리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에서 팩토리까지! 안정적인 오프닝이네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 앞마당 넥서스도 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 넥서스! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구! 앞마당 커맨드센터도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 시즈 모드 연구 중! 커맨드센터까지 건설!',
        ),
        ScriptEvent(
          text: '양쪽 모두 확장을 가져가면서 안정적인 운영을 합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가합니다. 드라군 물량을 늘리겠군요.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
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
          text: '{away} 선수 시즈 탱크를 앞마당 입구에 배치합니다! 철벽 방어!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20, favorsStat: 'defense',
          altText: '{away}, 탱크 라인 형성! 프로토스 접근이 어렵습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 접근하지만 탱크 사거리에 걸립니다!',
          owner: LogOwner.home,
          homeArmy: -2, favorsStat: 'control',
          altText: '{home}, 드라군이 탱크 포격에 당합니다! 접근이 힘들어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 템플러 아카이브를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 벙커와 터렛으로 방어를 더 강화합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 벙커에 터렛까지! 난공불락이 되어가고 있네요.',
        ),
        ScriptEvent(
          text: '테란의 방어가 견고합니다. 프로토스가 정면으로 뚫기 어려운 상황.',
          owner: LogOwner.system,
          skipChance: 0.2,
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
          text: '{home} 선수 게이트웨이 5개 가동 중! 스타게이트도 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 5게이트에 스타게이트! 아비터를 노리는 겁니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아비터 트리뷰널 건설! 최종 테크입니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아비터 트리뷰널이 올라갑니다! 리콜이 나오겠군요!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크를 계속 추가합니다. 사이언스 퍼실리티도 건설!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 생산 시작! 아비터도 곧 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 하이 템플러에 아비터! 더블 테크가 완성됩니다!',
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
              text: '{home} 선수 아비터 리콜! 탱크 라인 뒤로 병력이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -4, favorsStat: 'sense',
              altText: '{home}, 리콜! 탱크 뒤쪽에 드라군 질럿이 쏟아집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 아군 병력까지 포격합니다! 아군 피해!',
              owner: LogOwner.away,
              awayArmy: -5,
              altText: '{away}, 탱크 스플래시 데미지! 아군 마린까지 맞습니다!',
            ),
            ScriptEvent(
              text: '{home}, 스톰 투하! 밀집된 테란 병력에 대참사!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '리콜과 스톰! 탱크 터틀을 완벽하게 무너뜨렸습니다!',
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
              text: '{away} 선수 EMP! 아비터의 에너지를 소진시킵니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'sense',
              altText: '{away}, 사이언스 베슬 EMP! 아비터가 무력화됩니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인이 전진합니다! 시즈 포격으로 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 탱크가 전진! 시즈 포격이 프로토스를 압도합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리콜을 쓰지 못한 채 병력이 소모됩니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: 'EMP로 아비터를 무력화! 탱크 터틀의 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
