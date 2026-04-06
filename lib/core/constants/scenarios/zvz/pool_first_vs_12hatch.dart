part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12앞마당 (극초반 올인 vs 확장)
// ----------------------------------------------------------
const _zvzPoolFirstVs12hatch = ScenarioScript(
  id: 'zvz_pool_first_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_12hatch'],
  description: '4풀 극초반 올인 vs 12앞마당',
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
          altText: '{home}, 4풀! 정말 빠른 스포닝풀입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 앞마당 해처리를 건설하는 중입니다.',
          owner: LogOwner.away,
          awayResource: -20, awayArmy: 3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 7-10)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 7,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 상대 앞마당에 도착합니다! 스포닝풀이 없어요!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 상대는 아직 풀도 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 없습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
        ),
        ScriptEvent(
          text: '4풀 올인! 12앞마당을 막을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 11-22)
    ScriptPhase(
      name: 'rush_result',
      startLine: 11,
      branches: [
        // 분기 A: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 파괴!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -15, awayArmy: -8, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 모든 걸 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 전멸하고 있습니다! 막을 수가 없어요!',
              owner: LogOwner.away,
              awayArmy: -5, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 저글링이 본진까지 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -5,
              altText: '{home} 선수 저글링, 남은 드론까지 추격합니다!',
            ),
            ScriptEvent(
              text: '4풀이 12앞마당을 초토화! 올인 성공! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 수비
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전합니다! 드론 컨트롤!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 완성됩니다! 저글링으로 반격!',
              owner: LogOwner.away,
              awayArmy: 10, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀이 막혔습니다! 드론 수 차이로 12앞마당 유리! 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
