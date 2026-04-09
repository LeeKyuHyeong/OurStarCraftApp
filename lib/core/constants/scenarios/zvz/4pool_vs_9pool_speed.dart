part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9풀 발업 (치즈 vs 발업 압박)
// ----------------------------------------------------------
const _zvz4PoolVs9poolSpeed = ScenarioScript(
  id: 'zvz_4pool_vs_9pool_speed',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_9pool_speed'],
  description: '4풀 vs 9풀 발업 — 4풀 선저글링이 9풀 라바 압박을 막을 수 있을지',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 극단적인 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 9드론까지 뽑고 가스, 풀 동시!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기 먼저! 4풀의 첫 저글링이 이미 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 9풀 발업, 저글링은 아직입니다!',
          owner: LogOwner.away,
          awayResource: -8,
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 9-14)
    ScriptPhase(
      name: 'first_arrival',
      startLine: 9,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 9풀 진영에 도착! 드론을 물어뜯습니다!',
          owner: LogOwner.home,
          awayResource: -20, awayArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 4풀 저글링 침투! 9풀은 저글링이 아직 없어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 일단 막으면서 저글링을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 저글링이 도착할 때 9풀은 아직 풀이 막 완성되는 시점!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 15-26)
    ScriptPhase(
      name: 'rush_result',
      startLine: 15,
      branches: [
        // 분기 A: 4풀이 먼저 큰 피해
        ScriptBranch(
          id: 'pool_breaks_through',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 드론을 끊임없이 잡아냅니다! 9풀의 라바가 모자랍니다!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 나오긴 하지만 드론 손실이 너무 큽니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -5,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링! 4풀 올인이 결착납니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀 발업 저글링 합류로 역전
        ScriptBranch(
          id: 'speed_lings_arrive',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 합류합니다! 라바를 전부 저글링에!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 4풀 저글링이 더 이상 추가가 안 됩니다! 드론이 4기뿐!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 발업까지 완료되면서 4풀 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away}, 9풀의 드론 우위가 살아납니다! 결착!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
