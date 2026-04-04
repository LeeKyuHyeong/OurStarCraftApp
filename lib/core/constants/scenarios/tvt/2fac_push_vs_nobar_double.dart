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
    // Phase 0: 오프닝 (lines 1-12) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리.',
          owner: LogOwner.home,
          homeResource: -450, // 배럭(150) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터.',
          owner: LogOwner.away,
          awayResource: -400, // CC(400)
          fixedCost: true,
          altText: '{away} 선수 CC퍼스트, 노배럭더블.',
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 건설, 벌처를 대량 생산하겠다는 겁니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 투팩. 벌처 물량으로 압박하겠다는 겁니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설... 마린이 한참 늦습니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '투팩 vs 노배럭더블, 마린 없이 기동 유닛을 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벌처 러쉬 (lines 16-26) - recovery 150/1
    ScriptPhase(
      name: 'vulture_rush',
      startLine: 16,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작. 속업도 연구합니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처 2기 (2sup x2)
          homeResource: -350, // 벌처2(150) + 속업(200)
          fixedCost: true,
          altText: '{home} 선수 벌처 속업, 빠른 벌처가 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 겨우 1기... 상대 기갑 유닛을 막기엔 부족합니다.',
          owner: LogOwner.away,
          awayArmy: 1, // 마린 1기 (1sup)
          awayResource: -50, // 마린(50)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 3기가 상대 앞마당으로 달려갑니다.',
          owner: LogOwner.home,
          homeArmy: 2, // 벌처 1기 추가 (2sup)
          homeResource: -75, // 벌처(75)
          fixedCost: true,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처가 SCV를 잡아냅니다! 마린 1기로는 막을 수 없습니다!',
          owner: LogOwner.home,
          awayResource: -25,
          favorsStat: 'control',
          altText: '{home} 선수 벌처 컨트롤! SCV가 녹아내립니다!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 교전 강화 (공격 능력치 유리)
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다. 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 2: 결전 (lines 30-60) - recovery 200/2
    ScriptPhase(
      name: 'decisive',
      startLine: 30,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'vulture_devastation',
          conditionStat: 'control',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마인 매설. 상대 병력 접근을 차단합니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커를 올리지만 상대가 우회합니다.',
              owner: LogOwner.away,
              awayResource: -100, // 벙커(100)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 추가 물량. 양 기지 동시 견제.',
              owner: LogOwner.home,
              homeArmy: 4, // 벌처 2기 (2sup x2)
              awayResource: -20,
              homeResource: -150, // 벌처2(150)
              fixedCost: true,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '노배럭더블의 약점. 마린이 없어 기동 유닛을 잡을 수 없습니다.',
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
              text: '{away} 선수 벙커를 올립니다. SCV가 수리합니다.',
              owner: LogOwner.away,
              awayArmy: 1, // 마린 1기 추가 (1sup)
              awayResource: -150, // 벙커(100) + 마린(50)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 벙커 완성, 마린이 들어갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 벙커 사거리에 들어갑니다. 피해를 입습니다.',
              owner: LogOwner.home,
              homeArmy: -4, // 벌처 2기 손실 (2sup x2)
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 완성, 시즈 탱크 생산.',
              owner: LogOwner.away,
              awayArmy: 2, // 탱크 1기 (2sup)
              awayResource: -550, // 팩토리(300) + 탱크(250)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 벙커에 탱크까지! 방어선 완성! 상대가 접근 못 합니다!',
              owner: LogOwner.away,
              awayArmy: 2, // 탱크 1기 추가 (2sup)
              awayResource: -250, // 탱크(250)
              fixedCost: true,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '수비 성공. 더블 자원이 빛을 발합니다.',
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
