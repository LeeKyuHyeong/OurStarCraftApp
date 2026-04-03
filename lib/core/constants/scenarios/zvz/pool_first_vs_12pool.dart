part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12풀 (치즈 vs 스탠다드)
// ----------------------------------------------------------
const _zvzPoolFirstVs12pool = ScenarioScript(
  id: 'zvz_pool_first_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
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
          text: '{away} 선수 드론을 뽑으면서 12드론에 스포닝풀을 올리려 합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 빠르게 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링 출발! 12풀 상대에게 풀이 늦습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀 건설! 하지만 4풀보다 훨씬 늦어요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀! 스포닝풀이 늦지만 드론 수는 많습니다!',
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
          altText: '{home} 선수 저글링 도착! 12풀은 아직 저글링이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 풀 완성까지 버텨야 해요!',
          owner: LogOwner.away,
          awayArmy: 4,
        ),
        ScriptEvent(
          text: '4풀 vs 12풀! 드론 수는 많지만 저글링이 없습니다!',
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
          id: 'pool_damages',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 12풀의 드론이 녹습니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다! 풀이 아직 멀었어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 남은 드론까지 추격!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀이 12풀의 드론을 초토화! 올인 성공!',
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
              text: '{away}, 많은 드론으로 저글링과 교전합니다! 12풀의 드론 수가 많습니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 드론 물량! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론 물량에 당합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀 완성! 저글링 생산 시작! 발업도 연구합니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀을 막았습니다! 12풀의 드론 우위가 빛났습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
