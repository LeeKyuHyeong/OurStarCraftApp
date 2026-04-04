part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 배럭 더블 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvt1barDoubleVs1facDouble = ScenarioScript(
  id: 'tvt_1bar_double_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1bar_double'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '배럭 더블 vs 원팩 확장 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        // 홈: 배럭 건설 (-150)
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
        ),
        // 어웨이: 배럭 건설 (-150)
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
        ),
        // 홈: 앞마당 커맨드센터 (-400)
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
          altText: '{home} 선수 빠른 앞마당. 안정적인 운영을 가져갑니다.',
        ),
        // 어웨이: 가스(-100) + 팩토리(-300) = -400
        ScriptEvent(
          text: '{away} 선수 가스 채취 시작. 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다. 원팩 체제.',
        ),
        // 홈: 마린 2기(+2sup, -100) + 벙커(-100) = -200
        ScriptEvent(
          text: '{home} 선수 마린 생산하면서 벙커를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200,
          fixedCost: true,
        ),
        // 어웨이: 벌처 1기(+2sup, -75) + 머신샵(-100)
        ScriptEvent(
          text: '{away} 선수 벌처 생산. 머신샵을 달고 마인 연구를 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -175,
          fixedCost: true,
          altText: '{away} 선수 벌처 정찰을 보내고 머신샵에서 마인 연구.',
        ),
        ScriptEvent(
          text: '첫 탱크가 나오기 전까지는 폭풍전야입니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
        // 홈: 가스(-100) + 팩토리(-300) = -400
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
        ),
        // 어웨이: 앞마당 커맨드센터 (-400)
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터. 원팩 확장입니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수 원팩으로 확장까지. 수비적인 운영.',
        ),
      ],
    ),
    // Phase 1: 초반 벌처 교환 (lines 15-24)
    ScriptPhase(
      name: 'early_pressure',
      startLine: 15,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        // 홈: 마린과 벌처 정찰 (벌처 1기 +2sup, -75)
        ScriptEvent(
          text: '{home} 선수 마린 벌처로 상대 앞마당을 정찰합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75,
          fixedCost: true,
          favorsStat: 'harass',
          altText: '{home} 선수 마린 벌처 전진. 상대 빌드를 확인합니다.',
        ),
        // 어웨이: 벙커(-100)
        ScriptEvent(
          text: '{away} 선수 마인 매설 완료. 벙커도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수 마인과 벙커. 수비를 단단히 합니다.',
        ),
        // 홈: 벌처 견제 → SCV 피해 (전투)
        ScriptEvent(
          text: '{home} 선수 벌처로 견제! 일꾼을 노리는데요!',
          owner: LogOwner.home,
          awayResource: -100, favorsStat: 'harass',
          altText: '{home} 선수 벌처 기동! 일꾼을 노립니다!',
          skipChance: 0.3,
        ),
        // 어웨이: 마인에 병력 피해 (전투 - 벌처 1기 손실 = -2sup)
        ScriptEvent(
          text: '{away} 선수 마인에 탱크가 걸립니다! {home} 선수 탱크 피해!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 빌드 스타일이 극명하게 갈립니다! 이 싸움은 오래 갈 겁니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '서로 눈치싸움이 치열합니다. 먼저 칼을 뽑는 쪽은 누굴까요?',
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 홈 압박 성공 → 확장 피해
        ScriptBranch(
          id: 'pressure_success',
          baseProbability: 1.0,
          events: [
            // 벌처로 SCV 2~3기 격파 (전투)
            ScriptEvent(
              text: '{home} 선수 벌처가 마인을 피하면서 SCV를 잡습니다! 앞마당 가동이 늦어지고 있어요!',
              owner: LogOwner.home,
              awayResource: -150, favorsStat: 'control+harass',
              altText: '{home} 선수 벌처 컨트롤! 상대 앞마당 SCV 피해!',
            ),
            // SCV 추가 피해 (전투)
            ScriptEvent(
              text: '{away} 선수 앞마당 가동이 늦어집니다! 확장 이득을 못 보고 있어요!',
              owner: LogOwner.away,
              awayResource: -100,
            ),
            // 홈: 시즈탱크 2기 생산 (+4sup, -500) + 시즈모드 연구(-300) = -800
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 생산 시작. 앞마당 이득을 살려 밀어붙입니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -800,
              fixedCost: true,
              altText: '{home} 선수 탱크 합류! 압박이 강해집니다!',
            ),
            ScriptEvent(
              text: '압박이 효과를 봤습니다! 하지만 원팩 측 테크 우위가 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '자원 타격이 큽니다. 일꾼 피해가 막심해요.',
            ),
          ],
        ),
        // 분기 B: 어웨이 수비 성공 → 트리플 확장
        ScriptBranch(
          id: 'defense_success',
          baseProbability: 1.0,
          events: [
            // 벌처 2기 격파 (전투)
            ScriptEvent(
              text: '{away} 선수 마인과 벙커로 견제를 막아냅니다! 앞마당이 안정됩니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 벌처 견제를 무력화!',
            ),
            // 어웨이: 세 번째 커맨드센터(-400) + 벌처 1기(+2sup, -75) = -475
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드센터. 트리플 확장입니다.',
              owner: LogOwner.away,
              awayResource: -475, awayArmy: 2,
              fixedCost: true,
              altText: '{away} 선수 트리플. 자원 우위를 끌어올립니다.',
            ),
            // 홈: 머신샵(-100) 추가 (확장 실패 → 테크 전환)
            ScriptEvent(
              text: '{home} 선수 압박이 실패했습니다! 상대 확장이 늘어나는데요!',
              owner: LogOwner.home,
              homeResource: -100,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '수비 성공 후 트리플 확장! 자원 격차가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '안정적인 운영을 선택했습니다. 실력 싸움 가겠다는 거죠.',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 라인 대치 + 중반 종료 체크 (lines 41-54)
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 41,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 탱크 대치 지속 (가장 빈번)
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 2.0,
          events: [
            // 홈: 시즈탱크 2기(+4sup, -500)
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 배치. 라인을 밀어갑니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -500,
              fixedCost: true,
              altText: '{home} 선수 탱크 라인 전진. 시즈 모드.',
            ),
            // 어웨이: 시즈탱크 2기(+4sup, -500)
            ScriptEvent(
              text: '{away} 선수도 시즈 탱크 배치. 라인 대치가 시작됩니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '먼저 자리 잡는 쪽이 센터의 주인입니다.',
              owner: LogOwner.system,
              skipChance: 0.5,
            ),
            // 홈: 아머리(-150)
            ScriptEvent(
              text: '{home} 선수 아머리 건설. 골리앗도 준비합니다.',
              owner: LogOwner.home,
              homeResource: -150,
              fixedCost: true,
              altText: '{home} 선수 아머리가 올라갑니다. 골리앗 생산 준비.',
            ),
            // 어웨이: 아머리(-150)
            ScriptEvent(
              text: '{away} 선수도 아머리 건설. 골리앗 생산에 들어갑니다.',
              owner: LogOwner.away,
              awayResource: -150,
              fixedCost: true,
              skipChance: 0.3,
            ),
            // 어웨이: 스타포트(-250)
            ScriptEvent(
              text: '{away} 선수 스타포트 건설. 드랍십을 준비합니다.',
              owner: LogOwner.away,
              awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 스타포트 건설. 드랍십을 노리는 건가요?',
            ),
            ScriptEvent(
              text: '양측 시즈 탱크 대치. 라인 싸움의 시작입니다.',
              owner: LogOwner.system,
              skipChance: 0.2,
              altText: '테테전의 꽃, 시즈 탱크 라인 긋기 싸움입니다.',
            ),
          ],
        ),
        // 홈 탱크 푸시 (중반 종료)
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크가 모이자마자 전진! 시즈 모드 전에 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -500,
              fixedCost: true,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 아직 부족합니다! 시즈 배치가 늦습니다!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 수 우위로 정면 돌파! 상대 라인을 뚫습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 중반 탱크 푸시 성공! 상대가 막지 못합니다!',
            ),
          ],
        ),
        // 어웨이 탱크 푸시 (중반 종료)
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 원팩 테크 우위! 탱크가 먼저 모입니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500,
              fixedCost: true,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 수에서 밀립니다! 시즈 사거리 밖에서 접근 중!',
              owner: LogOwner.home,
              homeArmy: -4, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량으로 정면 돌파! 배럭더블 라인이 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 중반 탱크 푸시! 원팩 테크가 빛을 발합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'late_transition',
      startLine: 55,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        // 분기 A: 홈 탱크 라인 밀기 성공
        ScriptBranch(
          id: 'tank_push_success',
          baseProbability: 1.0,
          events: [
            // 벌처 견제 → SCV 피해 (전투)
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 후방을 견제합니다! SCV를 노립니다!',
              owner: LogOwner.home,
              awayResource: -150, favorsStat: 'harass',
              altText: '{home} 선수 벌처 견제! 상대 일꾼을 공격!',
            ),
            // 벌처 대응으로 병력 분산 (전투)
            ScriptEvent(
              text: '{away} 선수 벌처를 막느라 병력이 분산됩니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            // 탱크 라인 전진 (전투)
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 압박이 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 정면 전진! 상대 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '배럭 더블의 조기 확장 이득이 나타납니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처 돌리기! 상대 시선을 분산시키는 고도의 심리전입니다.',
            ),
          ],
        ),
        // 분기 B: 어웨이 자원 우위로 역전
        ScriptBranch(
          id: 'resource_advantage',
          baseProbability: 1.0,
          events: [
            // 어웨이: 골리앗 2기(+4sup, -300) + 탱크 1기(+2sup, -250) = -550
            ScriptEvent(
              text: '{away} 선수 확장 기지들의 자원 우위! 병력이 빠르게 늘어납니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -550,
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 물량 차이! 자원 우위가 드러납니다!',
            ),
            // 홈 라인 유지하지만 물량 부족 (전투)
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 유지하지만 물량 차이가 있습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            // 어웨이: 드랍십 1기(+2sup, -200) + 탱크 드랍 (전투 피해)
            ScriptEvent(
              text: '{away} 선수 드랍십으로 상대 확장기지를 습격합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -200,
              fixedCost: true,
              homeResource: -200, homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 탱크 드랍! 상대 후방이 위험합니다!',
            ),
            ScriptEvent(
              text: '자원 우위가 병력 차이로! 역전의 흐름입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '팩토리가 쉴 새 없이 돌아갑니다. 물량전 예고입니다.',
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 71-82)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      linearEvents: [
        // 홈: 탱크2(+4sup,-500) + 골리앗2(+4sup,-300) + 벌처1(+2sup,-75) = +10sup, -875
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 벌처 총동원! 마지막 결전!',
          owner: LogOwner.home,
          homeArmy: 10, homeResource: -875,
          fixedCost: true,
          altText: '{home} 선수 전 병력 결집! 결전을 준비합니다!',
        ),
        // 어웨이: 탱크2(+4sup,-500) + 골리앗2(+4sup,-300) = +8sup, -800
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력. 라인을 형성합니다.',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -800,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗 라인이 정면 충돌합니다!',
          owner: LogOwner.system,
          altText: '모든 병력 쏟아붓습니다! 마지막 결전이에요!',
        ),
        ScriptEvent(
          text: '인구수가 올라갑니다, 이제 곧 한 방이 터질 수 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
        // 전투: 양측 큰 피해
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 라인을 뚫습니다!',
          owner: LogOwner.home,
          awayArmy: -8, homeArmy: -6, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력 집중! 상대 병력이 녹습니다!',
        ),
        // 전투: 반격
        ScriptEvent(
          text: '{away} 선수 골리앗 집중 화력! 반격에 나섭니다!',
          owner: LogOwner.away,
          homeArmy: -8, awayArmy: -6, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 화력으로 맞섭니다!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 시스템 해설
        ScriptEvent(
          text: '근거리 맵이라 벌처 한 기 차이가 더 크게 느껴집니다.',
          owner: LogOwner.system,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
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
        // 복잡 지형 맵: 시스템 해설
        ScriptEvent(
          text: '언덕 위 시즈모드, 테테전에서 가장 무서운 지형지물이죠.',
          owner: LogOwner.system,
          requiresMapTag: 'terrainHigh',
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
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
          altText: '원거리 맵입니다. 멀티 확장이 안전하니 양측 자원이 풍부해지겠네요.',
        ),
      ],
    ),
    // Phase 6: 결전 판정 - 분기 (lines 83+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 83,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 더블 자원 우위! 탱크 물량으로 상대를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 견제로 상대 확장 가동을 늦추며 승기를 잡습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 원팩 테크 우위! 탱크 시즈로 라인을 뚫습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 확장 자원이 뒤늦게 가동되며 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
