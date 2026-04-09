part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 12풀 — 저글링 압박이 드론 3기 우위를 끊을 수 있을지
// ----------------------------------------------------------
const _zvz9poolSpeedVs12pool = ScenarioScript(
  id: 'zvz_9pool_speed_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_12pool'],
  description: '9풀 발업 vs 12풀 — 라바 압박 vs 드론 우위',
  phases: [
    // Phase 0: 빌드 차이 (lines 1-8)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 풀, 가스도 같이!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 12드론까지 뽑고 풀을 올립니다!',
          owner: LogOwner.away,
          awayResource: -15, awayArmy: 0,
          altText: '{away}, 12풀! 드론이 3기 더 많아요!',
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기 + 발업! 풀이 한 박자 빠르고 발업도 빠릅니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
        ),
        ScriptEvent(
          text: '{away} 선수 12풀은 저글링이 한참 늦어요! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
        ),
      ],
    ),
    // Phase 1: 발업 저글링 도착 (lines 9-14)
    ScriptPhase(
      name: 'speed_arrives',
      startLine: 9,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 12풀 진영에 도착! 드론을 노립니다!',
          owner: LogOwner.home,
          awayResource: -20, awayArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 침투! 12풀의 드론이 위험합니다!',
        ),
        ScriptEvent(
          text: '{away}, 드론으로 둘러싸면서 막습니다! 풀이 곧 완성돼요!',
          owner: LogOwner.away,
          awayArmy: 4,
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 15-26)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 15,
      branches: [
        // 분기 A: 발업 저글링이 드론 우위 끊음
        ScriptBranch(
          id: 'speed_breaks_economy',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 라바를 전부 저글링에! 두 번째 압박이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다! 12풀 우위가 사라져요!',
              owner: LogOwner.away,
              awayResource: -25, awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 드론 격차를 완전히 뒤집고 결착!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 12풀이 드론 우위로 막아냄
        ScriptBranch(
          id: 'twelve_pool_economy_holds',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 드론 우위로 발업 저글링을 잡아냅니다! 풀도 완성!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: 4, awayResource: -10, favorsStat: 'defense',
              altText: '{away} 선수 드론 컨트롤 + 저글링 합류! 12풀 수비 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 무산됩니다! 드론은 6기뿐인데 상대는 10기예요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 드론 우위로 추가 해처리까지! 운영으로 결착!',
              owner: LogOwner.away,
              awayResource: -30, favorsStat: 'macro',
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
