part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9오버풀 (치즈 vs 준스탠다드)
// ----------------------------------------------------------
const _zvz4PoolVs9overpool = ScenarioScript(
  id: 'zvz_4pool_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
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
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 4드론에 스포닝풀을 올립니다! 극초반 올인이네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 뽑으면서 9드론에 오버로드를 먼저 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{away} 선수, 9드론에 오버로드를 먼저 올리고 스포닝풀로 이어갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 빠르게 나옵니다! 상대로 출발!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -15,
          altText: '{home} 선수, 저글링 출발! 오버로드 먼저 올린 상대에게 타이밍이 좋습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 오버로드 후 스포닝풀! 오버로드를 먼저 올려서 풀이 더 늦습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 오버로드를 먼저 올렸기 때문에 스포닝풀이 더 늦어요!',
        ),
        ScriptEvent(
          text: '스포닝풀이 아주 빨리 올라갔는데 상대는 오버로드를 먼저 올린 만큼 풀이 더 늦습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '오버로드를 먼저 올리는 빌드라 이렇게 빠른 스포닝풀에 가장 취약합니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 8-12)
    ScriptPhase(
      name: 'ling_rush',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대 풀이 아직 완성 안 됐습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수, 저글링 도착! 오버로드를 먼저 올려서 풀이 더 늦어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 저글링이 한참 남았습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 3,
          altText: '{away} 선수, 스포닝풀이 아직 멀었습니다! 드론으로 버텨야 해요!',
        ),
        ScriptEvent(
          text: '오버로드를 먼저 올린 대가를 치르고 있습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '풀 완성까지 드론으로 버텨야 하는 상황! 드론 컨트롤이 관건!',
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 13-24)
    ScriptPhase(
      name: 'rush_result',
      branches: [
        // 분기 A: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 드론을 물어뜯습니다! 풀이 너무 늦었습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              homeArmy: 1, awayResource: -20, awayArmy: -3,              altText: '{home} 선수, 저글링 돌파! 드론이 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실이 심각합니다! 풀이 아직 멀었습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
              altText: '{away} 선수, 드론이 빠르게 줄어듭니다! 스포닝풀이 아직 안 됐어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 저글링 합류! 오버로드 먼저 올린 약점을 정확히 찔렀습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -10,              altText: '{home} 선수, 저글링이 계속 들어갑니다! 남은 드론까지 추격!',
            ),
            ScriptEvent(
              text: '극초반 저글링 올인이 성공합니다! 오버로드를 먼저 올린 대가가 컸습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
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
              text: '{away} 선수 드론을 뭉쳐서 저글링과 교전합니다! 필사적인 수비!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: -1,              altText: '{away} 선수, 드론 컨트롤! 저글링을 하나씩 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{home} 선수, 초반 저글링이 밀립니다! 드론 물량에 막히고 있어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포닝풀이 완성됩니다! 저글링 생산 시작!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 5, awayResource: -10,              altText: '{away} 선수, 풀 완성! 저글링으로 반격합니다!',
            ),
            ScriptEvent(
              text: '초반 저글링 러시를 막아냈습니다! 드론 수 이점이 살아있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
