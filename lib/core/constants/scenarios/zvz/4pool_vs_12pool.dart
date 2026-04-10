part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12풀 (치즈 vs 스탠다드)
// ----------------------------------------------------------
const _zvz4PoolVs12pool = ScenarioScript(
  id: 'zvz_4pool_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_12pool'],
  description: '4풀 극초반 올인 vs 12풀 스탠다드',
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
          altText: '{home}, 4풀! 극초반 올인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 12기까지 뽑으면서 스포닝풀을 올리려 합니다.',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 12풀! 드론을 최대한 뽑고 스포닝풀!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 빠르게 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 저글링 출발! 12풀 상대에게 풀이 한참 늦습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀 건설! 하지만 4풀보다 훨씬 늦습니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀 스포닝풀! 드론 수는 많지만 저글링이 없습니다!',
        ),
        ScriptEvent(
          text: '4풀 대 12풀! 드론 수는 12풀이 압도적이지만 저글링이 없습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '12풀은 드론이 많아서 수비할 드론도 많습니다! 하지만 풀이 멀어요!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대 풀이 아직 완성 안 됐습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 저글링 도착! 12풀은 아직 저글링이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 풀 완성까지 버텨야 합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          altText: '{away}, 드론 물량으로 저글링을 막아야 하는 상황!',
        ),
        ScriptEvent(
          text: '12풀의 드론 수가 많아서 드론 컨트롤로 버틸 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '4풀 대 12풀! 드론 물량 대 저글링 속도!',
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 17-28)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_damages',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 드론을 물어뜯습니다! 12풀의 드론이 녹습니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home}, 저글링 돌파! 드론을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다! 풀이 아직 멀었습니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 드론 손실이 심각합니다! 스포닝풀 완성 전에 녹고 있어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 저글링 합류! 남은 드론까지 추격합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 저글링이 계속 들어갑니다! 4풀의 압박이 끝나지 않습니다!',
            ),
            ScriptEvent(
              text: '4풀이 12풀의 드론을 초토화합니다! 풀이 너무 늦었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 12풀 수비 성공
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 많은 드론으로 저글링과 교전합니다! 12풀의 드론 수가 많습니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'control',
              altText: '{away}, 드론 물량! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론 물량에 당합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 4풀 저글링이 밀립니다! 드론 수가 너무 많습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포닝풀 완성! 저글링 생산 시작! 발업도 연구합니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 풀 완성! 저글링과 발업으로 반격에 나섭니다!',
            ),
            ScriptEvent(
              text: '4풀을 막았습니다! 12풀의 드론 물량이 빛을 발합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
