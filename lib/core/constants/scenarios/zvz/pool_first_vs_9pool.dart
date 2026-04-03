part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9풀 (치즈 vs 공격적)
// ----------------------------------------------------------
const _zvzPoolFirstVs9pool = ScenarioScript(
  id: 'zvz_pool_first_vs_9pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_9pool'],
  description: '4풀 치즈 vs 9풀 공격적 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 극초반 스포닝풀 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 뽑으면서 9드론에 풀을 올리려 합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 빠르게 나옵니다! 상대로 출발!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다! 스포닝풀 완성되기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀 건설! 저글링이 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀 스포닝풀! 하지만 4풀 저글링이 먼저 도착할 수 있습니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 상대 진영에 도착! 풀이 막 완성됩니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 상대 저글링은 아직 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 일단 막으면서 저글링 생산을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 vs 9풀! 저글링 타이밍 차이가 관건입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 초반 교전 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀이 큰 피해를 줌
        ScriptBranch(
          id: 'pool_damages',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 피해가 큽니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실! 하지만 저글링이 나오기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 저글링이 합류하면서 4풀 저글링을 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 저글링 합류! 겨우 막아냅니다!',
            ),
            ScriptEvent(
              text: '드론 피해가 컸습니다! 4풀 올인이 먹혔습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀이 빠르게 저글링으로 대응
        ScriptBranch(
          id: 'quick_ling_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 빠르게 나옵니다! 드론과 함께 방어!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 3, favorsStat: 'control',
              altText: '{away} 선수 저글링과 드론 협공! 4풀을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 녹고 있습니다! 수가 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 발업 연구까지! 저글링 교전에서 우위를 점합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '9풀의 빠른 대응! 4풀이 막혔습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
