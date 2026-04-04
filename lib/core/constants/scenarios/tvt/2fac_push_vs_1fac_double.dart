part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 8. 투팩 벌처 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvt2facPushVs1facDouble = ScenarioScript(
  id: 'tvt_2fac_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_push'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '투팩 벌처 vs 원팩 확장 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-14) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취 후 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취, 팩토리 건설.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리 건설, 투팩 체제입니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 팩토리가 하나 더, 투팩 벌처 체제.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터 건설. 원팩으로 확장을 가져갑니다.',
          owner: LogOwner.away,
          awayResource: -400, // CC(400)
          fixedCost: true,
          altText: '{away} 선수 원팩 확장, 안정적인 운영을 선택합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 2기 생산 시작, 속업 연구도 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처 2기 (2sup x2)
          homeResource: -350, // 벌처2(150) + 속업(200)
          fixedCost: true,
          altText: '{home} 선수 벌처가 나옵니다, 속업 연구 중.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산 후 머신샵에서 마인 연구.',
          owner: LogOwner.away,
          awayArmy: 2, // 벌처 1기 (2sup)
          awayResource: -75, // 벌처(75)
          fixedCost: true,
        ),
      ],
    ),
    // Phase 1: 벌처 센터 장악 (lines 15-24) - recovery 150/1
    ScriptPhase(
      name: 'vulture_control',
      startLine: 15,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 속업 완료. 센터로 벌처를 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처 2기 (2sup x2)
          homeResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
          favorsStat: 'control',
          altText: '{home} 선수 벌처 속업, 기동력이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마인을 앞마당 입구에 깝니다. 벙커도 건설.',
          owner: LogOwner.away,
          awayResource: -100, // 벙커(100)
          fixedCost: true,
          altText: '{away} 선수 마인과 벙커, 병력 접근에 대비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 투팩 벌처 4기가 센터를 장악합니다. 상대 이동 경로를 차단.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처 2기 추가 (2sup x2)
          homeResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
          favorsStat: 'harass',
          altText: '{home} 선수 벌처 4기, 센터 맵 컨트롤을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 생산 시작, 수비를 강화합니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -550, // 머신샵(100) + 탱크(250) + 시즈모드(200)
          fixedCost: true,
          altText: '{away} 선수 시즈 탱크, 벌처 견제를 막아낼 준비.',
        ),
        ScriptEvent(
          text: '투팩 벌처의 기동력 vs 원팩 확장의 수비. 견제 싸움이 시작됩니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벌처 견제 결과 - 분기 (lines 25-40) - recovery 200/2
    ScriptPhase(
      name: 'harass_result',
      startLine: 25,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        // 분기 A: 벌처 견제 대성공 -> SCV 피해
        ScriptBranch(
          id: 'harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처가 마인을 피해 돌아서 SCV에 침투합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass+control',
              altText: '{home} 선수 벌처 우회 침투! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다, 앞마당 가동이 흔들립니다.',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 벌처까지 합류! 상대 일꾼을 계속 괴롭힙니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 벌처 1기 추가 (2sup)
              homeResource: -75, // 벌처(75)
              fixedCost: true,
              awayResource: -5, favorsStat: 'harass',
              altText: '{home} 선수 벌처 추가, 견제가 이어집니다.',
            ),
            ScriptEvent(
              text: '벌처 견제 대성공! SCV 피해로 자원 격차가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 마인에 탱크 피해 -> 수비 안정
        ScriptBranch(
          id: 'mine_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마인에 {home} 탱크가 걸립니다! 투팩 병력에 큰 피해!',
              owner: LogOwner.away,
              homeArmy: -4, // 탱크 2기 손실 (2sup x2)
              favorsStat: 'defense',
              altText: '{away} 선수 마인 매설 성공! {home} 탱크가 큰 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실이 큽니다! 투팩 투자가 아까운데요!',
              owner: LogOwner.home,
              homeArmy: -2, // 벌처 1기 추가 손실 (2sup)
            ),
            ScriptEvent(
              text: '{away} 선수 확장이 안정됩니다. 트리플 확장도 노립니다.',
              owner: LogOwner.away,
              awayResource: -400, // CC(400) 트리플
              fixedCost: true,
              awayArmy: 2,
              altText: '{away} 선수 수비 성공, 세 번째 확장을 가져갑니다.',
            ),
            ScriptEvent(
              text: '마인에 병력 피해! 원팩 확장 측이 안정을 찾았습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드랍십 등장 + 시즈 탱크 대치 (lines 41-54) - recovery 200/2
    ScriptPhase(
      name: 'dropship_tank',
      startLine: 41,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설, 드랍십을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트(250)
          fixedCost: true,
          altText: '{home} 선수 스타포트가 올라갑니다, 드랍십.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작. 드랍용 탱크.',
          owner: LogOwner.home,
          homeArmy: 2, // 탱크 1기 (2sup)
          homeResource: -250, // 탱크(250)
          fixedCost: true,
          altText: '{home} 선수 탱크가 나옵니다, 드랍 준비.',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설, 골리앗을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리(150)
          fixedCost: true,
          altText: '{away} 선수 아머리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크 추가. 라인 대치가 시작됩니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -250, // 탱크(250)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산. 상대 후방을 노릴 준비.',
          owner: LogOwner.home,
          homeArmy: 2, // 드랍십 1기 (2sup)
          homeResource: -200, // 드랍십(200)
          fixedCost: true,
          altText: '{home} 선수 드랍십이 나옵니다.',
        ),
        ScriptEvent(
          text: '수송선 등장. 시즈 라인 대치와 견제전이 동시에.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 55-70) - recovery 300/3
    ScriptPhase(
      name: 'late_clash',
      startLine: 55,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        // 분기 A: 게릴라 드랍 (확장 견제 후 회수)
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 드랍십 출격. 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내립니다! SCV를 잡아냅니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 탱크 드랍! SCV 피해가 발생합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 달려오지만 이미 드랍십이 회수합니다.',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '게릴라 드랍으로 시선을 끈 사이 정면에서 거리재기가 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 마무리 드랍 (유리한 쪽이 드랍과 정면 동시)
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대가 출격합니다! 본진과 확장 동시 투하!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십 두 대! 세 방향 공격!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진합니다! 세 방향에서 압박!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 분산됩니다! 어디를 막아야 할지 모르겠습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격으로 상대를 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 마무리 드랍 성공! 상대 수비선이 무너집니다!',
            ),
          ],
        ),
        // 분기 C: 정면 대치 (어웨이 물량 역전)
        ScriptBranch(
          id: 'frontal_stalemate',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 확장 기지들이 풀가동. 물량이 쏟아집니다.',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 자원 우위. 병력이 빠르게 늘어납니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 투팩 체제로는 물량을 따라잡기 어렵습니다.',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 대군으로 역공! 숫자로 압도!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 물량 공세! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '확장의 자원 우위가 드러납니다. 물량 차이.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 D: 역전 드랍 (불리한 쪽의 승부수)
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.6,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다. 승부수를 던집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 본진 올인 드랍! 승부수!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진에 탱크를 투하합니다! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 피해가 심각합니다! 병력을 급히 돌립니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 71-82) - recovery 300/3
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 총동원! 마지막 전투를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 4, // 탱크1(2sup) + 골리앗1(2sup)
          homeResource: -400, // 탱크(250) + 골리앗(150)
          fixedCost: true,
          altText: '{home} 선수 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력 배치, 정면 교전 준비.',
          owner: LogOwner.away,
          awayArmy: 4, // 탱크1(2sup) + 골리앗1(2sup)
          awayResource: -400, // 탱크(250) + 골리앗(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
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
    // Phase 6: 결전 판정 - 분기 (lines 83+) - recovery 300/3
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
              text: '{home} 선수 투팩 벌처 견제 성공! 상대 일꾼을 초토화합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 물량으로 맵을 장악하며 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 확장 자원이 본격 가동! 물량으로 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 마인과 탱크로 병력 접근을 막아내고 반격합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
