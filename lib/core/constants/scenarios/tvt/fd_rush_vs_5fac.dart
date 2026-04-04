part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 5팩토리 (중반 타이밍 vs 후반 물량)
// ----------------------------------------------------------
const _tvtFdRushVs5fac = ScenarioScript(
  id: 'tvt_fd_rush_vs_5fac',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_5fac'],
  description: 'FD 러쉬 vs 5팩토리 타이밍 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취 후 팩토리, 머신샵 부착.',
          owner: LogOwner.home,
          homeResource: -500, // 리파이너리 100 + 팩토리 300 + 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 빠른 팩토리에 머신샵. 시즈 모드를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설, 추가 팩토리도 연달아 올립니다.',
          owner: LogOwner.away,
          awayResource: -600, // 팩토리 x2 (300+300)
          fixedCost: true,
          altText: '{away} 선수 팩토리가 계속 올라갑니다. 멀티 팩토리 체제.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산. 빠른 탱크입니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 3개, 벌처를 쏟아냅니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -450, // 팩토리 300 + 벌처 2기 (75x2)
          fixedCost: true,
          altText: '{away} 선수 3팩토리 가동. 벌처가 빠르게 모입니다.',
        ),
        ScriptEvent(
          text: '빠른 탱크 vs 멀티 팩토리! 타이밍 싸움이 시작됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 타이밍 압박 (lines 12-22) - recovery 150/1
    ScriptPhase(
      name: 'timing_pressure',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 완료, 탱크를 전진시킵니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 시즈모드 300 + 탱크 1기 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 모드! 빠른 전진!',
        ),
        ScriptEvent(
          text: '{away} 선수 아직 팩토리를 짓고 있습니다. 4번째 팩토리.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 2기로 앞마당을 압박합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 전진! 5팩 완성 전에 칩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처와 마인으로 탱크를 저지하려 합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
          favorsStat: 'defense',
          altText: '{away} 선수 벌처로 탱크를 막아야 합니다!',
        ),
        ScriptEvent(
          text: '5팩이 완성되기 전에 FD가 치고 들어갑니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 타이밍 결과 분기 (lines 24-36) - recovery 150/1
    ScriptPhase(
      name: 'timing_result',
      startLine: 24,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: FD 타이밍 성공
        ScriptBranch(
          id: 'timing_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 상대 앞마당을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 앞마당 건물이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 투자가 너무 무겁습니다! 방어가 부족해요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 탱크 합류! 포격이 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
              fixedCost: true,
              awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 탱크 추가! 5팩 완성을 허락하지 않습니다!',
            ),
            ScriptEvent(
              text: '타이밍 공격 성공! 5팩이 가동되기 전에 큰 피해!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 5팩 수비 성공
        ScriptBranch(
          id: 'five_fac_defends',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 마인에 탱크가 저지됩니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 탱크에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 마인에 손상! 전진이 멈춥니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 5번째 팩토리가 완성됩니다. 물량이 쏟아질 준비.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -550, // 팩토리 300 + 탱크 1기 250
              fixedCost: true,
              altText: '{away} 선수 5팩 완성. 이제부터 물량 차이가 납니다.',
            ),
            ScriptEvent(
              text: '5팩 체제 완성! 타이밍을 넘겼습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 물량전 (lines 38-48) - recovery 200/2
    ScriptPhase(
      name: 'mass_battle',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리에서 탱크 더블 생산.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -800, // 팩토리 300 + 탱크 2기 (250x2)
          fixedCost: true,
          altText: '{home} 선수 탱크를 계속 뽑습니다. 더블 생산.',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩에서 탱크 벌처 골리앗이 쏟아집니다!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -950, // 탱크 2기 (500) + 벌처 2기 (150) + 골리앗 2기 (300)
          fixedCost: true,
          altText: '{away} 선수 5팩 물량! 탱크 벌처 골리앗 대군!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 라인을 재정비합니다. 시즈 거리재기.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '물량 차이가 점점 벌어집니다! 5팩의 힘!',
          owner: LogOwner.system,
          skipChance: 0.3,
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
    // Phase 3b: 중반 물량 분기 (lines 48-52) - recovery 200/2
    ScriptPhase(
      name: 'mid_mass_check',
      startLine: 48,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 견제 - 소규모 피해
        ScriptBranch(
          id: 'guerrilla_harass',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처를 빼내 상대 일꾼을 견제합니다.',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 벌처 견제! 5팩 가동을 방해합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 대응하지만 이미 피해를 입었습니다.',
              owner: LogOwner.away,
              awayResource: -5,
            ),
            ScriptEvent(
              text: '벌처 견제전! 자잘한 피해가 쌓입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 마무리 탱크 푸시 - FD 타이밍 마무리
        ScriptBranch(
          id: 'finishing_push',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 일렬로 전진! 5팩 완성 전에 끝내겠다는 의지!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 정면 돌파! 5팩 물량이 나오기 전에!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 투자가 무겁습니다! 병력이 부족해요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 타이밍 공격으로 5팩 체제를 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 탱크 타이밍이 5팩을 눌렀습니다!',
            ),
          ],
        ),
        // 5팩 물량 반격 - 물량이 터지는 순간
        ScriptBranch(
          id: 'mass_counterattack',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩에서 병력이 쏟아집니다! 탱크 벌처 골리앗!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -700, // 탱크 250 + 벌처 150 + 골리앗 300
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 5팩 물량 폭발! 대군이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 물량 차이를 못 메웁니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '5팩의 물량이 무섭습니다! 병력 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 필사적 올인 - FD가 마지막 승부
        ScriptBranch(
          id: 'desperate_allin',
          baseProbability: 0.6,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{home} 선수 후반 물량에서 밀립니다! 올인 전진!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 250
              fixedCost: true,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 전부 전진! 5팩 물량 전에 끝내야 합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 올인 전진! 마지막 승부!',
            ),
            ScriptEvent(
              text: '타이밍의 마지막 기회! 이것이 지나면 5팩 물량을 막을 수 없습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 (lines 54+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 54,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_timing_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 초반 피해가 누적됩니다! 5팩이 회복하지 못합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 타이밍 공격의 잔재! 5팩이 온전치 못합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인으로 마무리합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 탱크 타이밍이 5팩을 눌렀습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'five_fac_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩 물량이 폭발합니다! 탱크 골리앗 대군!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -4, favorsStat: 'macro',
              altText: '{away} 선수 물량 공세! 상대를 압도합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 5팩의 물량이 모든 것을 뒤덮습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 후반 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
