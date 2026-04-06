part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9오버풀 vs 노풀 3해처리 (준공격형 vs 극매크로)
// ----------------------------------------------------------
const _zvz9overpoolVs3hatchNopool = ScenarioScript(
  id: 'zvz_9overpool_vs_3hatch_nopool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '9오버풀 vs 노풀 3해처리',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 9드론에 오버로드 먼저! 이후 스포닝풀!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9오버풀! 드론 한 기의 이점을 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다! 스포닝풀 없이!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 앞마당! 3해처리를 향한 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 3번째 해처리 건설! 풀이 아직 없습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 3해처리! 스포닝풀 없이 확장을 극대화합니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 9-13)
    ScriptPhase(
      name: 'ling_pressure',
      startLine: 9,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 도착합니다! 상대에게 풀이 없어요!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 3해처리 상대에게 저글링이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 풀이 너무 늦었어요!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '9오버풀 vs 노풀 3해처리! 드론으로 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 13-26)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 13,
      branches: [
        // 분기 A: 저글링 공격 성공
        ScriptBranch(
          id: 'ling_crushes',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 공격!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 드론을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 3해처리의 빈 진영을 파괴!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '저글링 공격이 3해처리를 초토화! 올인 성공! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 버팀
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전! 필사적인 수비!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 완성됩니다! 저글링 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '저글링을 막아냈습니다! 3해처리의 자원이 살아있습니다! 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
