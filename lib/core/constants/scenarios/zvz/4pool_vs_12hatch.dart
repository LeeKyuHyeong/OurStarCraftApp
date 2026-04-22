part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12앞마당 (극초반 올인 vs 확장)
// ----------------------------------------------------------
const _zvz4PoolVs12hatch = ScenarioScript(
  id: 'zvz_4pool_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
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
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 4드론에 스포닝풀을 올립니다! 정말 빠르네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{away} 선수, 드론에 집중! 앞마당 해처리를 올리려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -15,
          altText: '{home} 선수, 저글링이 달려갑니다! 앞마당부터 올린 상대에게 최악의 타이밍!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 앞마당 해처리를 건설하는 중입니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -20, awayArmy: 3,
          altText: '{away} 선수, 앞마당 해처리를 건설 중! 스포닝풀이 아직 없습니다!',
        ),
        ScriptEvent(
          text: '스포닝풀이 아주 빨리 올라갔는데 상대는 풀조차 없는 상태에서 저글링이 옵니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '앞마당을 먼저 올렸는데 이렇게 빠른 스포닝풀에는 가장 취약합니다! 풀이 아예 없어요!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 8-12)
    ScriptPhase(
      name: 'ling_rush',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 상대 앞마당에 도착합니다! 스포닝풀이 없습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수, 저글링 도착! 상대는 아직 풀도 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 없습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 4,
          altText: '{away} 선수, 드론밖에 없습니다! 풀이 올라오기까지 버텨야 해요!',
        ),
        ScriptEvent(
          text: '극초반 저글링 올인! 앞마당부터 올린 상대는 드론만으로 막을 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '앞마당부터 올린 쪽은 드론 수가 많지만 저글링 상대로 충분할까요?',
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 13-24)
    ScriptPhase(
      name: 'rush_result',
      branches: [
        // 분기 A: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 드론을 물어뜯습니다! 앞마당도 위험합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              homeArmy: 4, awayResource: -15, awayArmy: -8,              altText: '{home} 선수, 저글링이 드론과 앞마당을 동시에 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 전멸하고 있습니다! 저글링을 막을 수가 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -5, awayResource: -10,
              altText: '{away} 선수, 드론으로 막으려 하지만 저글링이 너무 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 본진까지 들어갑니다! 남은 드론 추격!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -5,
              altText: '{home} 선수, 앞마당 파괴 후 본진까지! 막을 수 없습니다!',
            ),
            ScriptEvent(
              text: '극초반 저글링이 앞마당을 초토화합니다! 풀도 없는데 막을 수가 없습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
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
              text: '{away} 선수 드론을 뭉쳐서 저글링과 교전합니다! 드론 컨트롤이 좋습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4, awayArmy: -1,              altText: '{away} 선수, 드론 컨트롤! 저글링을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다! 수가 줄어듭니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
              altText: '{home} 선수, 초반 저글링이 밀립니다! 드론 물량을 못 이깁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포닝풀이 완성됩니다! 저글링으로 반격!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 10, awayResource: -10,              altText: '{away} 선수, 풀 완성! 저글링이 나오면서 반격에 나섭니다!',
            ),
            ScriptEvent(
              text: '초반 저글링 러시가 막혔습니다! 드론 수 차이가 압도적입니다!',
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
