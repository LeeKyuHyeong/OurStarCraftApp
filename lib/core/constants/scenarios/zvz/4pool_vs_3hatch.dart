part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. 4풀 vs 3해처리 (치즈 vs 극매크로)
// ----------------------------------------------------------
const _zvz4poolVs3hatch = ScenarioScript(
  id: 'zvz_4pool_vs_3hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '4풀 치즈 vs 노풀 3해처리',
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
          altText: '{home}, 4풀! 극초반 스포닝풀 러시입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑습니다. 앞마당을 노리는 모습!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 빠르게 출발합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리 건설! 스포닝풀은 아직 없습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 3해처리! 스포닝풀이 없는 상태입니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 도착합니다! 상대는 풀도 없고 저글링도 없습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 3해처리 상대에게 풀이 없어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 풀이 너무 늦습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 vs 노풀 3해처리! 드론으로 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀 대성공 → 즉시 결정
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 공격!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 드론을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다! 풀이 아직 멀었어요!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 3해처리의 빈 진영을 파괴!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀이 노풀 3해처리를 초토화! 올인 대성공!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 버팀 → 즉시 결정
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전! 필사적인 수비!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당합니다! 수가 줄어요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 뒤늦게 완성됩니다! 저글링 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀을 막아냈습니다! 3해처리의 자원이 살아있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
