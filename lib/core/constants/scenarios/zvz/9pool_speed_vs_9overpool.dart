part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 9오버풀 — 발업 타이밍 한 박자 차이
// ----------------------------------------------------------
const _zvz9poolSpeedVs9overpool = ScenarioScript(
  id: 'zvz_9pool_speed_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9풀 발업 vs 9오버풀 — 오버로드 선건설로 풀이 한 박자 늦은 9오버풀',
  phases: [
    // Phase 0: 9풀이 한 박자 빠름 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 풀, 가스 동시!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 오버로드 먼저! 풀은 그 다음입니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 9오버풀! 인구 안정 후 풀 진입!',
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기 + 발업! 라바 전부 저글링!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home} 선수 발업 저글링이 한 박자 먼저 출발!',
        ),
        ScriptEvent(
          text: '{away}, 풀이 늦어서 저글링도 늦게 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -8,
        ),
        ScriptEvent(
          text: '풀 타이밍 한 박자 차이가 발업 타이밍까지 이어집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 첫 충돌 (lines 11-16)
    ScriptPhase(
      name: 'first_clash',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 먼저 도착! 9오버풀 진영을 압박합니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 노발업 저글링과 드론으로 막아야 해요!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 17-28)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 17,
      branches: [
        // 분기 A: 9풀 발업이 한 박자 우위로 결착
        ScriptBranch(
          id: 'speed_pressure_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 발업 저글링이 노발업 저글링을 사정없이 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실까지! 한 박자 늦은 발업이 치명적입니다!',
              owner: LogOwner.away,
              awayResource: -20, awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 라바를 또 저글링에! 두 번째 압박!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -8, favorsStat: 'attack',
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9오버풀이 드론 우위 + 컨트롤로 버팀
        ScriptBranch(
          id: 'overpool_holds',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 드론 한 기 많은 우위로 저글링과 함께 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 발업도 곧 완료됩니다! 동등한 싸움으로 끌고 갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막혔어요! 드론 격차 + 안정성에서 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 드론 우위로 결착!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
