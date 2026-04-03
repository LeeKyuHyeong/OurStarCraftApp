part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투팩타이밍 vs 노배럭더블
// 벌처 러쉬 vs 배럭 없는 극수비. 마린 없어 벌처에 극취약
// ----------------------------------------------------------
const _tvt2facPushVsNobarDouble = ScenarioScript(
  id: 'tvt_2fac_push_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_push'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '투팩타이밍 vs 노배럭더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, CC퍼스트! 노배럭더블!',
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 건설! 벌처를 대량 생산하겠다는 겁니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 투팩! 벌처 물량으로 압박하겠다는 겁니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설... 마린이 한참 늦습니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '투팩 벌처 vs 노배럭더블! 마린 없이 벌처를 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벌처 러쉬 (lines 16-26)
    ScriptPhase(
      name: 'vulture_rush',
      startLine: 16,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작! 속업도 연구합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -23,
          altText: '{home}, 벌처 속업! 빠른 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 겨우 1기... 벌처를 상대하기엔 부족합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 3기가 상대 앞마당으로 달려갑니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -8,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home}, 벌처가 SCV를 잡아냅니다! 마린 1기로는 막을 수 없습니다!',
          owner: LogOwner.home,
          awayResource: -25,
          favorsStat: 'control',
          altText: '{home} 선수 벌처 컨트롤! SCV가 쓰러져갑니다!',
        ),
      ],
    ),
    // Phase 2: 결전 (lines 30-60)
    ScriptPhase(
      name: 'decisive',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'vulture_devastation',
          conditionStat: 'control',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마인 매설! 상대 벌처 견제까지 차단!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커를 올리지만 벌처가 우회합니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 추가 물량! 양 기지 동시 견제!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayResource: -20,
              homeResource: -10,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '노배럭더블의 약점! 마린이 없어 벌처를 잡을 수 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 SCV 학살! 탱크까지 합류합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 투팩 벌처 완승! 상대가 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'bunker_defense',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커를 올립니다! SCV가 수리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              awayResource: -15,
              favorsStat: 'defense',
              altText: '{away}, 벙커 완성! 마린이 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 벙커 사거리에 들어갑니다! 피해를 입습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 완성! 시즈 탱크 생산!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 벙커+탱크로 방어선 완성! 벌처가 접근 못 합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '수비 성공! 더블 자원이 빛을 발합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원으로 탱크 물량 확보! 역전 공세!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 수비 후 역전! 물량이 압도합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
