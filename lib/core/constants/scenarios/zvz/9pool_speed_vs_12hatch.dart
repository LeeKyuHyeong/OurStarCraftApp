part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 12앞마당 — 풀 없는 12앞이 발업 저글링을 막을 수 있을지
// ----------------------------------------------------------
const _zvz9poolSpeedVs12hatch = ScenarioScript(
  id: 'zvz_9pool_speed_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_12hatch'],
  description: '9풀 발업 vs 12앞 — 풀 없는 12앞에 발업 저글링이 들어가면 결착',
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
          text: '{away} 선수 12드론에 앞마당 해처리부터!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 12앞마당! 풀은 아직 없습니다!',
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기에 발업 연구!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home} 선수 저글링 생산하면서 발업까지!',
        ),
        ScriptEvent(
          text: '9풀 발업이 12앞마당을 만났습니다! 정확히 노린 빌드!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '12앞마당을 저격하는 9풀 발업! 빌드 선택이 적중했습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 풀이 늦어집니다! 저글링도 한참 후에 나와요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 발업 저글링 도착 (lines 9-14)
    ScriptPhase(
      name: 'speed_arrives',
      startLine: 9,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 12앞 진영에 도착! 풀이 막 완성되는 시점이에요!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 발업 저글링 침투! 12앞은 노저글링!',
        ),
        ScriptEvent(
          text: '{away}, 드론으로 막아야 합니다! 저글링이 아직 한 마리도 없어요!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 15-26)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 15,
      branches: [
        // 분기 A: 발업 저글링이 12앞 초토화
        ScriptBranch(
          id: 'speed_crushes_12hatch',
          baseProbability: 1.1,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 발업 저글링이 드론을 학살! 앞마당 해처리도 위협!',
              owner: LogOwner.home,
              awayResource: -30, awayArmy: -5, favorsStat: 'attack',
              altText: '{home} 선수 압도적 압박! 12앞이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 절반 이상 잡혔어요! 막을 수가 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 라바를 또 저글링에! 결착!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -8,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 버틴 후 성큰 완성
        ScriptBranch(
          id: 'sunken_holds',
          baseProbability: 0.9,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 드론 컨트롤! 둘러싸면서 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 풀 완성! 저글링 + 성큰으로 입구를 잠급니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -22, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막혔습니다! 드론 우위가 너무 큽니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 12앞 우위로 결착!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
