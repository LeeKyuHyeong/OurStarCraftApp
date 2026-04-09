part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 9풀 레어 — 라바 분배 철학의 충돌
// ----------------------------------------------------------
const _zvz9poolSpeedVs9poolLair = ScenarioScript(
  id: 'zvz_9pool_speed_vs_9pool_lair',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_9pool_lair'],
  description: '9풀 발업 vs 9풀 레어 — 저글링 압박이 뮤탈 타이밍을 끊을 수 있을지',
  phases: [
    // Phase 0: 같은 9풀, 갈리는 라바 분배 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9풀, 가스도 동시!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 9풀, 가스! 같은 빌드처럼 보입니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 라바를 전부 저글링에! 발업도 연구!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home}, 저글링 6기에 발업! 압박형입니다!',
        ),
        ScriptEvent(
          text: '{away}, 저글링은 4기만! 나머지 라바는 드론에! 발업도 스킵!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -5,
          altText: '{away}, 저글링 4기에 드론, 빠른 레어! 테크형입니다!',
        ),
        ScriptEvent(
          text: '같은 9풀이지만 라바 분배가 완전히 다릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 발업 저글링 도착 vs 레어 진행 (lines 11-18)
    ScriptPhase(
      name: 'speed_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 상대 본진에 도착! 레어 올리는 중에 도착했어요!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 발업 저글링이 레어 타이밍을 끊으러 옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 4기뿐이고 드론은 많아요! 성큰이 완성되기 전이에요!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '레어 vs 압박! 누가 먼저 도착했는지가 모든 걸 결정합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 19-32)
    ScriptPhase(
      name: 'tech_vs_pressure',
      startLine: 19,
      branches: [
        // 분기 A: 발업 저글링이 레어 끊음
        ScriptBranch(
          id: 'speed_breaks_tech',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 발업 저글링이 드론을 학살합니다! 레어가 취소돼요!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 저글링 압박! 9풀 레어의 드론이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레어 완성이 늦어지고, 스파이어는 꿈도 못 꿉니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링도 라바에서 바로 합류!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -8, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home}, 압박으로 결착! 테크 올라가기도 전에 끝납니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀 레어가 수비 후 뮤탈 선점
        ScriptBranch(
          id: 'lair_survives_to_mutal',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 드론과 저글링으로 발업 저글링을 잡아냅니다! 성큰도 완성!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, awayResource: -10, favorsStat: 'defense',
              altText: '{away} 선수 드론 컨트롤에 성큰! 발업 저글링이 녹아요!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 저글링이 약해집니다! 레어가 곧 완성돼요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스파이어 완성! 뮤탈이 먼저 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -25, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 드론을 견제! 9풀 레어의 테크 우위가 살아납니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
