part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs 타이밍 푸시: 리버로 지연 후 아비터 리콜 마무리
// ----------------------------------------------------------
const _pvtReaverArbiterVsTimingPush = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter'],
  awayBuildIds: ['tvp_trans_timing_push'],
  description: '리버 아비터 vs 타이밍 공격 — 리버로 시간 벌고 리콜로 마무리',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이에서 드라군을 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭과 팩토리를 올리며 타이밍을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          awayArmy: 1,
          altText: '{away}, 타이밍 공격을 준비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스를 건설합니다! 리버 아비터 빌드의 시작!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미를 올리고 메딕 생산을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '테란이 타이밍 공격을 노리고 있습니다! 프로토스 테크가 간당간당하네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버로 타이밍 지연 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버가 테란 진영으로 날아갑니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 셔틀 리버 출격! 타이밍을 흔들어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 시즈탱크 병력이 출발 직전입니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 스캐럽이 SCV를 잡습니다! 병력 보충이 늦어질 겁니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 스캐럽 명중! 자원 라인에 큰 피해!',
        ),
        ScriptEvent(
          text: '{away} 선수 병력 일부를 돌려서 리버를 잡으려 합니다!',
          owner: LogOwner.away,
          awayArmy: -1,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '리버 견제가 타이밍을 지연시키고 있습니다! 시간을 벌 수 있을까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 아비터 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터 트리뷰널을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아비터 트리뷰널이 올라갑니다! 아비터가 곧!',
        ),
        ScriptEvent(
          text: '{away} 선수 타이밍 병력이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군과 리버로 정면에서 시간을 끕니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '아비터가 나오기 직전! 타이밍 공격을 조금만 더 버텨야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터가 완성됩니다! 리콜 에너지 확보!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -10,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 리콜! 드라군이 테란 본진에 나타납니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayResource: -25,
              favorsStat: 'strategy',
              altText: '{home}, 리콜 성공! 테란 본진이 뚫립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞에서 공격 중이라 본진이 비어있습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '리콜이 타이밍 공격을 무력화했습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 타이밍 공격이 프로토스 앞마당을 부숩니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away}, 시즈탱크 포격에 넥서스가 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터가 나오기 전에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 메딕이 본진까지 밀고 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '타이밍 공격 성공! 아비터 전에 끝났습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
