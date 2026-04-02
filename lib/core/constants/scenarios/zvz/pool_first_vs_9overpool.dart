part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9오버풀 (치즈 vs 준스탠다드)
// ----------------------------------------------------------
const _zvzPoolFirstVs9overpool = ScenarioScript(
  id: 'zvz_pool_first_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_9overpool'],
  description: '4풀 치즈 vs 9오버풀',
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
          altText: '{home}, 4풀! 극초반 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 뽑으면서 9드론에 오버로드를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 빠르게 나옵니다! 상대로 출발!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링 출발! 9오버풀 상대에게 타이밍이 좋습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 오버로드 후 스포닝풀! 저글링이 늦게 나옵니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9오버풀! 오버로드를 먼저 올려서 풀이 더 늦습니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 도착합니다! 상대 풀이 아직 완성 안 됐습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 9오버풀이라 풀이 더 늦어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 저글링이 한참 남았어요!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 vs 9오버풀! 오버로드를 먼저 올린 만큼 풀이 더 늦었습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 풀이 너무 늦었어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론이 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실이 심각합니다! 풀이 너무 멀었어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 9오버풀의 약점을 찔렀습니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 올인이 9오버풀을 파괴! 풀 타이밍이 치명적이었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 버팀
        ScriptBranch(
          id: 'drone_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전합니다! 필사적인 수비!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 하나씩 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 완성됩니다! 저글링 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀을 막아냈습니다! 드론 한 기 이점이 살아있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
