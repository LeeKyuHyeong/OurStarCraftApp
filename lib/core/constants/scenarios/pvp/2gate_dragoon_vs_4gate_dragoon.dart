part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 드라군 vs 포게이트 드라군
// ----------------------------------------------------------
const _pvp2gateDragoonVs4gateDragoon = ScenarioScript(
  id: 'pvp_2gate_dragoon_vs_4gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_dragoon'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '투게이트 드라군 vs 포게이트 드라군 물량전',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 2개 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설! 사이버네틱스 코어도 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 완성! 드라군 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 투게이트에서 드라군이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 계속 증설합니다! 3개째! 4개째!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -30,
          altText: '{away}, 포게이트! 대규모 드라군 물량을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 투게이트 후 빠른 확장!',
        ),
        ScriptEvent(
          text: '투게이트 확장 vs 포게이트 물량! 타이밍 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 포게이트 압박 (lines 12-18)
    ScriptPhase(
      name: 'four_gate_push',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 포게이트에서 드라군이 쏟아집니다! 전진!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'attack',
          altText: '{away}, 드라군 물량! 상대 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 앞마당 수비 준비!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 계속 합류합니다! 포게이트 물량!',
          owner: LogOwner.away,
          awayArmy: 2,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 확장 자원으로 드라군을 계속 뽑습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '포게이트 물량이 밀려옵니다! 투게이트 확장이 버틸 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 준비 (lines 22-28)
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 리버를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스에서 셔틀+리버를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스 건설! 옵저버를 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 레인지 업그레이드! 사거리가 늘어납니다!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군으로 센터를 장악합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'control',
          altText: '{away}, 포게이트 드라군으로 맵 컨트롤!',
        ),
      ],
    ),
    // Phase 3: 결전 - 분기 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'expand_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 확장 자원이 돌아옵니다! 드라군 물량이 역전!',
              owner: LogOwner.home,
              homeArmy: 4, favorsStat: 'macro',
              altText: '{home}, 확장 자원 차이! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 포게이트 물량이 한계에 다다랐습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 리버 셔틀까지 합류! 상대 드라군을 녹입니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home}, 리버 스카랩! 드라군이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 자원으로 물량 역전! 포게이트를 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 투게이트 확장의 힘! 자원 차이로 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'four_gate_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 포게이트 물량으로 앞마당을 압박합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 드라군 물량! 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장이 아직 자원을 못 뽑고 있습니다! 타이밍이 늦었어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 앞마당 넥서스를 직접 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, awayArmy: 2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 포게이트 타이밍 성공! 확장 전에 끝냅니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 포게이트 물량! 상대 확장을 무너뜨립니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
