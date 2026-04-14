part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩더블 vs 노배럭더블
// 둘 다 수비형이지만 노배럭더블이 자원 더 빠르고, 원팩더블은 병력 먼저
// ----------------------------------------------------------
const _tvt1facDoubleVsNobarDouble = ScenarioScript(
  id: 'tvt_1fac_double_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_double'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '원팩더블 vs 노배럭더블 - 수비형 같은 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-14) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -450, // 배럭(150) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터.',
          owner: LogOwner.away,
          awayResource: -400, // CC(400)
          fixedCost: true,
          altText: '{away} 선수 배럭 없이 커맨드센터를 먼저 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 메카닉 체제 가동. 앞마당 확장.',
          owner: LogOwner.home,
          homeArmy: 2, // 벌처 1기 (2sup)
          homeResource: -475, // CC(400) + 벌처(75)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭, 팩토리 건설. 병력은 한 템포 늦습니다.',
          owner: LogOwner.away,
          awayResource: -450, // 배럭(150) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 모두 수비형! 장기전이 예상됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 (lines 18-35) - recovery 200/2
    ScriptPhase(
      name: 'mid_game',
      startLine: 18,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 더블 자원 가동. 일꾼이 빠르게 늘어납니다.',
          owner: LogOwner.away,
          awayResource: 15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 추가 생산. 방어선 구축.',
          owner: LogOwner.home,
          homeArmy: 2, // 탱크 1기 (2sup)
          homeResource: -250, // 탱크(250)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산 시작. 물량이 빠르게 따라옵니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -250, // 탱크(250)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 증설.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설. 탱크 더블 생산.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리(300)
          fixedCost: true,
          favorsStat: 'macro',
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
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다! 지형 싸움!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 2: 탱크 푸시 체크 (lines 36-50) - recovery 200/2
    // 수비형 빌드지만 탱크 물량 차이로 중반 종료 가능
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 36,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        // 양측 비등 → 장기전 돌입 (가장 빈번)
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 2.0,
          events: [
            ScriptEvent(
              text: '양측 탱크 라인이 비등합니다. 섣불리 움직일 수 없는 상황.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설을 시작합니다.',
              owner: LogOwner.home,
              homeResource: -250, // 스타포트(250)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수도 스타포트 건설.',
              owner: LogOwner.away,
              awayResource: -250, // 스타포트(250)
              fixedCost: true,
            ),
          ],
        ),
        // 홈(원팩더블) 탱크 선제 푸시 - 병력 빠른 이점
        ScriptBranch(
          id: 'home_tank_push',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 물량이 먼저 모였습니다! 시즈 모드 전진!',
              owner: LogOwner.home,
              homeArmy: 4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 아직 탱크가 부족합니다. 라인이 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격으로 앞마당을 직격!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -12,
              decisive: true,
            ),
          ],
        ),
        // 어웨이(노배럭더블) 자원 우위 푸시
        ScriptBranch(
          id: 'away_tank_push',
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 더블 자원으로 탱크를 빠르게 모았습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 수에서 밀립니다. 라인이 위험합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 물량 우위로 시즈 라인 전진! 상대를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -12,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드랍 운영 (lines 55-90) - recovery 300/3
    ScriptPhase(
      name: 'drop_phase',
      startLine: 55,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        // 게릴라 드랍 - 확장 견제 후 회수 (가장 빈번)
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 생산. 탱크를 한 대 태웁니다.',
              owner: LogOwner.home,
              homeArmy: 2, // 드랍십 1기 (2sup)
              homeResource: -200, // 드랍십(200)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십이 상대 확장기지로 향합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 확장기지 뒤편으로 드랍십이 날아갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 투하! 시즈 모드로 SCV를 잡아냅니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 달려오지만, 이미 회수했습니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
              altText: '{away} 선수 탱크를 돌렸지만 드랍십은 이미 빠져나갔습니다.',
            ),
            ScriptEvent(
              text: '드랍 견제로 시선을 끈 사이 정면에서 거리재기가 계속됩니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
            ),
          ],
        ),
        // 마무리 드랍 - 유리한 쪽이 정면과 드랍 동시로 끝냄
        ScriptBranch(
          id: 'finishing_drop',
          conditionStat: 'strategy',
          homeStatMustBeHigher: true,
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 생산. 대규모 드랍을 준비합니다.',
              owner: LogOwner.home,
              homeArmy: 4, // 드랍십 2기 (4sup)
              homeResource: -400, // 드랍십 x2(400)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 본진과 확장에 동시 투하! 세 방향 공격!',
              owner: LogOwner.home,
              awayArmy: -5,
              awayResource: -30,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 분산됩니다! 어디를 막아야 할지!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 완벽한 마무리!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
            ),
          ],
        ),
        // 정면 돌파 - 자원 우위로 탱크 물량 밀어붙이기
        ScriptBranch(
          id: 'frontal_push',
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 더블 자원 효과. 탱크가 더 빠르게 모입니다.',
              owner: LogOwner.away,
              awayArmy: 2, // 탱크 1기 (2sup)
              awayResource: -250, // 탱크(250)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 사이언스 퍼실리티 건설. 베슬을 올립니다.',
              owner: LogOwner.away,
              awayResource: -250, // 사이언스퍼실리티(250)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 사이언스 베슬 생산. 디펜시브 매트릭스로 탱크를 보호합니다.',
              owner: LogOwner.away,
              awayArmy: 2, // 사이언스베슬 1기 (2sup)
              awayResource: -325, // 사이언스베슬(325)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '자원 우위가 결정적입니다! 병력 수에서 점점 벌어집니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인 전진! 물량으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
            ),
          ],
        ),
        // 역전 드랍 - 밀리는 쪽이 승부수
        ScriptBranch(
          id: 'desperate_drop',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다. 승부수를 띄웁니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 드랍십 1기 (2sup)
              homeResource: -200, // 드랍십(200)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 올인 드랍! 상대 본진을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              awayResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 피해가 심각합니다! 탱크를 돌려야 합니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '드랍 피해로 전세가 뒤집혔습니다! 양측 체력이 위태롭습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);
