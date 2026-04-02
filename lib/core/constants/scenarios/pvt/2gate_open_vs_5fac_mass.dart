part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 질럿 오프닝 vs 5팩 물량
// ----------------------------------------------------------
const _pvt2gateOpenVs5facMass = ScenarioScript(
  id: 'pvt_2gate_open_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_2gate_open', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '투게이트 질럿 초반 압박 vs 5팩토리 물량 빌드업',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 팩토리를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭 완성! 가스를 올리고 팩토리를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 게이트웨이 건설! 투게이트입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 투게이트 확정! 초반 압박!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 건설합니다! 추가 팩토리를 계속 지을 겁니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '테란이 팩토리를 여러 개 올리는 빌드입니다! 중반 이후 물량이 쏟아지죠!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿을 모아 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 질럿 압박 vs 팩토리 증설 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿이 테란 진지에 도착합니다! 팩토리 짓는 걸 방해해야 합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
          altText: '{home}, 질럿 전진! 팩토리 건설을 늦춰야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 벌처로 질럿을 방어합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -1,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 팩토리가 올라갑니다! 세 번째도 준비 중입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 계속 늘어납니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿으로 SCV를 잡으려 합니다! 시간을 벌어야 합니다!',
          owner: LogOwner.home,
          awayResource: -10,
          favorsStat: 'harass',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '팩토리가 완성되면 탱크 벌처가 쏟아집니다! 그 전에 피해를 줘야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 드라군 전환 vs 5팩 가동 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 완성! 드라군 생산에 들어갑니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 5팩토리가 모두 가동됩니다! 벌처와 탱크가 줄줄이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -30,
          altText: '{away}, 5팩 가동! 메카닉 물량이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 넥서스를 올립니다! 자원이 필요합니다!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드와 마인을 연구합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩토리 물량이 모이고 있습니다! 프로토스가 버틸 수 있을까요?',
          owner: LogOwner.system,
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
              text: '{home} 선수 초반 질럿 피해가 컸습니다! 테란 자원이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              favorsStat: 'strategy',
              altText: '{home}, 초반 압박 효과! 5팩 가동이 늦어졌습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 수가 적습니다! 질럿 피해로 팩토리 가동이 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크를 하나씩 처리합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '질럿 압박으로 5팩 빌드업을 지연시킨 게 결정적이었습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 밀고 들어갑니다! 팩토리를 부수면 끝입니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 초반 피해를 살려 5팩 완성 전에 끝냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩토리에서 탱크 벌처가 쏟아집니다! 물량이 어마어마합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -3,
              favorsStat: 'macro',
              altText: '{away}, 5팩 물량! 탱크 벌처가 줄줄이 나옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로는 이 물량을 감당할 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 라인을 형성합니다! 포격이 시작됩니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5팩토리 물량이 프로토스를 압도합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 메카닉 대군으로 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 5팩 물량 완성! 프로토스가 감당할 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
