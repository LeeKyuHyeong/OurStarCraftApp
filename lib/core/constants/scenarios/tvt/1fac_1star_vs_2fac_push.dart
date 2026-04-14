part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs 투팩 벌처
// ----------------------------------------------------------
const _tvt1fac1starVs2facPush = ScenarioScript(
  id: 'tvt_1fac_1star_vs_2fac_vulture',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '원팩 푸시 vs 투팩 벌처 팩토리 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
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
          text: '{home} 선수 팩토리를 올립니다. 공격적인 운영입니다.',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올립니다. 두 번째 팩토리까지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -700, // 가스 100 + 팩토리 300 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산을 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{home} 선수 벌처가 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 두 개에서 벌처가 쏟아집니다. 물량 차이가 납니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '공격적인 빌드 선택! 팩토리 수 차이로 피해를 얼마나 줄 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 준비 (lines 12-22) - recovery 150/1
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 머신샵을 부착합니다. 시즈 연구를 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -650, // 머신샵 100 + 시즈모드 300 + 탱크 250
          fixedCost: true,
          altText: '{home} 선수 머신샵에서 시즈 연구를 시작합니다. 탱크를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵을 부착합니다. 팩토리 두 개에서 벌처 탱크를 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -450, // 머신샵 100 + 탱크 250 + 머신샵 100
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 중. 아머리도 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{home} 선수 시즈 연구와 아머리 건설. 후반을 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리를 올립니다. 벌처 탱크 물량으로 압박합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다. 컨트롤타워도 건설합니다.',
          owner: LogOwner.home,
          homeResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
          altText: '{home} 선수 스타포트 건설 후 컨트롤타워. 드랍십을 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 올립니다. 컨트롤타워도 건설 중입니다.',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 맞대응! 벌처 컨트롤 대결!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십을 생산합니다. 기동전을 노립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200, // 드랍십 200
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '팩토리 대결! 먼저 밀리면 끝입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+) - recovery 200/2
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 컨트롤이 앞섭니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 벌처 싸움 승리! 맵 컨트롤!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 녹았습니다! 시야가 불리해지네요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 센터 장악! 마인까지 깔면서!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75, // 벌처 75 추가 생산
              fixedCost: true,
              favorsStat: 'harass',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 물량이 압도적입니다! 숫자로 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 벌처 물량 승리! 팩토리 두 개의 힘!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 피해! 물량 차이에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 정찰하면서 마인 매설!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75, // 벌처 75 추가 생산
              fixedCost: true,
              favorsStat: 'scout',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 교전 (lines 32-38) - recovery 200/2
    ScriptPhase(
      name: 'tank_battle',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈! 팩토리 두 개의 물량으로 맞섭니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500, // 탱크 2기 (250x2) 투팩
          fixedCost: true,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 마인 매설. 진격로를 차단합니다.',
          owner: LogOwner.away,
          favorsStat: 'defense',
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
    // Phase 4: 탱크 푸시 체크 - 중반 decisive (lines 38+) - recovery 200/2
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양쪽 탱크 라인이 비등합니다. 쉽게 밀리지 않는 구도.',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 마인 매설. 진격로를 제한합니다.',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 앞서갑니다! 시즈 포격으로 밀어붙입니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력 차이! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 녹습니다! 물량이 빠져도 화력에서 밀려요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 중반 탱크 푸시 성공! 상대 생산시설까지 위협합니다!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              decisive: true,
              altText: '{home} 선수 시즈 화력으로 밀어냅니다! 상대 물량이 힘을 못 씁니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 수가 앞서갑니다! 팩토리 두 개의 생산력! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 물량이 압도적! 숫자로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 터집니다! 물량 차이를 감당하기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 중반 물량 밀어붙이기 성공! 상대 라인을 무너뜨립니다!',
              owner: LogOwner.away,
              homeResource: -300, // 팩토리 파괴
              decisive: true,
              altText: '{away} 선수 물량 화력! 생산력 차이를 막을 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 드랍 운영 (lines 44+) - recovery 200/2
    ScriptPhase(
      name: 'drop_phase',
      startLine: 44,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 (가장 흔함)
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격. 상대 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크 투하! SCV를 잡고 바로 회수!',
              owner: LogOwner.home,
              awayResource: -200, favorsStat: 'harass',
              altText: '{home} 선수 게릴라 드랍! SCV 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 왔지만 이미 빠져나갔습니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
            ),
          ],
        ),
        // 어웨이 게릴라 드랍
        ScriptBranch(
          id: 'away_guerrilla_drop',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍십 출격. 상대 뒤쪽을 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지에 탱크 투하! SCV를 잡고 빠집니다!',
              owner: LogOwner.away,
              homeResource: -200, favorsStat: 'harass',
              altText: '{away} 선수 게릴라 드랍! 빠르게 피해를 주고 회수!',
            ),
          ],
        ),
        // 마무리 드랍 (홈 유리 시)
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 본진과 확장 동시 투하!',
              owner: LogOwner.home,
              awayResource: -400, favorsStat: 'strategy',
              altText: '{home} 선수 마무리 드랍! 세 방향 공격!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 분산됩니다! 정면 탱크 라인도 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격으로 끝냅니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 마무리 공격 성공! 상대가 대응하지 못합니다!',
            ),
          ],
        ),
        // 역전 드랍 (어웨이 승부수)
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.6,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 밀리고 있습니다! 승부수를 던집니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.away,
              homeResource: -300, favorsStat: 'harass',
              altText: '{away} 선수 올인 드랍! 상대 본진 탱크 투하!',
            ),
            ScriptEvent(
              text: '{away} 선수 역전 드랍 성공! 상대 생산시설을 파괴합니다!',
              owner: LogOwner.away,
              homeResource: -300,
              decisive: true,
              altText: '{away} 선수 승부수가 통합니다! 역전!',
            ),
          ],
        ),
      ],
    ),
    // Phase 6: 최종 결전 - 분기 (lines 50+) - recovery 200/2
    ScriptPhase(
      name: 'timing_clash',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 타이밍 공격으로 상대 물량을 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 병력이 더 빠르게 모입니다! 생산력 차이!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 물량 역습! 상대 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 벌처로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 물량으로 타이밍 공격을 꺾습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 벌처로 시야를 잡고 탱크로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
