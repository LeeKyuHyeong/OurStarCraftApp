part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 시즈 탱크 터틀
// ----------------------------------------------------------
const _pvt5gateCarrierVsTankDefense = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier'],
  awayBuildIds: ['tvp_trans_tank_defense'],
  description: '5게이트 캐리어 vs 탱크 터틀 — 공중에서 방어선을 우회',
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
          text: '{away} 선수 배럭에서 팩토리! 머신샵도 붙입니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 시즈 모드를 연구합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다! 확장을 가져가는군요.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 벙커도 짓습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 커맨드센터에 벙커! 방어 위주 빌드입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가! 드라군을 뽑으며 방어합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 방어적인 빌드를 가져갑니다. 탱크 터틀이군요.',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          text: '{away} 선수 시즈 탱크를 앞마당에 5대 배치합니다! 철벽 방어!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25, favorsStat: 'defense',
          altText: '{away}, 탱크 라인이 촘촘합니다! 지상으로는 접근 불가!',
        ),
        ScriptEvent(
          text: '{home} 선수 지상으로 밀기 어렵습니다. 스타게이트를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타게이트 건설! 공중으로 우회하겠다는 판단!',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛을 추가합니다. 공중 대비를 하는군요.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 캐리어를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 플릿 비콘이 올라갑니다! 캐리어 체제!',
        ),
        ScriptEvent(
          text: '프로토스가 캐리어로 탱크 라인을 우회하려 합니다.',
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
          text: '{home} 선수 스타게이트 2개에서 캐리어 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 더블 스타게이트! 캐리어가 연속으로 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산을 서둡니다! 아머리에서 사거리 업그레이드!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗 생산! 캐리어 대비를 급히 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 인터셉터를 가득 채운 캐리어 2기 완성!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 5개에서 드라군도 꾸준히 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
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
              text: '{home} 선수 캐리어가 탱크 라인 위로 날아갑니다! 탱크가 공중을 못 칩니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -5, favorsStat: 'macro',
              altText: '{home}, 캐리어 편대! 탱크 위에서 인터셉터가 쏟아집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 대응하지만 캐리어 인터셉터에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -1,
              altText: '{away}, 골리앗이 캐리어를 잡으려 하지만 인터셉터가 너무 많아요!',
            ),
            ScriptEvent(
              text: '{home}, 드라군도 합류! 지상과 공중 동시 공격!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '캐리어가 탱크 터틀을 공중에서 무너뜨립니다!',
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
              text: '{away} 선수 골리앗 편대가 캐리어를 집중 포화합니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away}, 골리앗 집중 사격! 캐리어가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away}, 캐리어 1기 격추! 인터셉터도 쓸려 나갑니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인이 전진! 프로토스 앞마당을 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 탱크가 전진합니다! 시즈 포격으로 넥서스를 노립니다!',
            ),
            ScriptEvent(
              text: '골리앗이 캐리어를 잡고 탱크가 밀어냅니다! 터틀의 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
