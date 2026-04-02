part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 질럿 오프닝 vs 탱크 수비
// ----------------------------------------------------------
const _pvt2gateOpenVsTankDefense = ScenarioScript(
  id: 'pvt_2gate_open_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_2gate_open'],
  awayBuildIds: ['tvp_trans_tank_defense'],
  description: '투게이트 질럿 압박 vs 탱크 수비 운영',
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
          text: '{away} 선수 배럭 건설 후 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭에 가스! 테크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 게이트웨이 건설! 투게이트입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 투게이트 확정! 질럿 압박을 준비하구요!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 머신샵을 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '프로토스는 공격적, 테란은 수비적! 상반된 빌드입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 질럿 압박 vs 벙커+탱크 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿으로 테란 앞마당을 압박합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
          altText: '{home}, 질럿 전진! 테란 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 세웁니다! 마린이 들어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿이 벙커를 칩니다! 하지만 마린 화력에 녹고 있습니다!',
          owner: LogOwner.home,
          homeArmy: -2,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{home}, 질럿이 벙커에 달라붙지만 화력이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크가 나옵니다! 시즈 모드 전환!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '탱크가 자리 잡으면 질럿으로는 뚫기 힘들어집니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 드라군 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 완성! 드라군 생산 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          altText: '{home}, 드라군이 나옵니다! 질럿만으로는 안 되니까요!',
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 올립니다! 탱크로 버티면서 확장!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 커맨드센터! 탱크 수비로 안전하게 확장합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 넥서스 건설! 드라군으로 전환하면서 자원도 확보합니다!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 탱크를 생산합니다! 시즈 라인이 견고해집니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '양쪽 확장을 마치고 본격적인 운영전에 돌입합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
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
              text: '{home} 선수 드라군 물량이 모였습니다! 탱크 라인을 우회합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              favorsStat: 'strategy',
              altText: '{home}, 드라군이 측면으로 돌아갑니다! 시즈 라인을 피합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 자리를 못 잡습니다! 드라군 기동력에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -4,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크를 하나씩 잡아냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -5,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '탱크 라인이 무너지고 있습니다! 프로토스가 밀어붙입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군 대군이 테란 본진을 공격합니다! 더 이상 막을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 드라군 물량 차이! 탱크 수비를 뚫어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 완벽한 라인을 형성합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              favorsStat: 'defense',
              altText: '{away}, 탱크 시즈 라인이 철벽입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 시즈 포격에 녹습니다! 사정거리 밖에서 맞고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -5,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 프로토스 확장을 견제합니다! 프로브 피해가 큽니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '테란의 탱크 수비가 성공합니다! 프로토스가 뚫지 못합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 벌처 물량으로 역공! 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 철벽 수비 후 역공! 프로토스가 무너집니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
