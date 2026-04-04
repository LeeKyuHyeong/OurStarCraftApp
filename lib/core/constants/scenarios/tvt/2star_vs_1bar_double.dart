part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 클로킹 vs CC퍼스트
// ----------------------------------------------------------
const _tvt2starVs1barDouble = ScenarioScript(
  id: 'tvt_wraith_vs_cc_first',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_1bar_double'],
  description: '투스타 레이스 vs CC퍼스트 공중 견제전',
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
          homeResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -400, // CC(400)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 빠른 테크.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에 이어 팩토리 건설. CC퍼스트의 안정적 테크.',
          owner: LogOwner.away,
          awayResource: -450, // 배럭(150) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 수비 준비를 합니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 벌처 1기 (2sup)
          awayResource: -75, // 벌처(75)
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다. CC퍼스트 운영.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트(250)
          fixedCost: true,
          altText: '{home} 선수 스타포트가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 생산하면서 벙커를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 1, // 마린 1기 (1sup)
          awayResource: -150, // 마린(50) + 벙커(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산. 2번째 스타포트도 올립니다.',
          owner: LogOwner.home,
          homeArmy: 2, // 레이스 1기 (2sup)
          homeResource: -500, // 레이스(250) + 스타포트(250)
          fixedCost: true,
          altText: '{home} 선수 레이스가 나옵니다. 스타포트가 하나 더.',
        ),
        ScriptEvent(
          text: '투스타포트! 레이스를 대량으로 뽑겠다는 의도!',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '서플라이 위치 하나하나가 다 빌드고 전략입니다.',
        ),
      ],
    ),
    // Phase 1: 초반 레이스 견제 (lines 12-18) - recovery 150/1
    ScriptPhase(
      name: 'early_wraith_harass',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스가 상대 본진으로! SCV를 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 레이스 출격! 상대 SCV를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 짓는 SCV를 노립니다! 스캔을 늦추려는 의도!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayResource: -5,
          altText: '{home} 선수 아카데미 건설 SCV를 쫓아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 짓는 SCV도 공격! 골리앗 생산을 늦추려는 의도!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayResource: -5,
          altText: '{home} 선수 아머리 건설 SCV까지 괴롭힙니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 SCV까지! 터렛 건설도 지연시킵니다!',
          owner: LogOwner.home,
          awayResource: -5,
          altText: '{home} 선수 엔지니어링 베이 짓는 SCV도 쫓습니다! 터렛이 늦어지네요!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '공중 유닛 한두 기로는 건설을 완전히 막을 수는 없지만, SCV 피해가 계속 쌓이고 있습니다!',
          owner: LogOwner.system,
          altText: '자원 타격이 큽니다. 일꾼 피해가 막심해요.',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 건물 옆에 붙여놓고 끈질기게 건설을 시도합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          altText: '{away} 선수 SCV를 계속 붙이면서 건물을 올립니다! 포기하지 않습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 견제를 이어가면서 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeResource: -400, // CC(400)
          fixedCost: true,
          altText: '{home} 선수 견제와 동시에 앞마당 확장! 멀티를 챙깁니다!',
        ),
        ScriptEvent(
          text: '피해는 누적되고 있지만 {away} 선수 포기하지 않습니다! 건물이 하나둘 올라오고 있어요!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '서로 눈치싸움이 치열합니다. 먼저 칼을 뽑는 쪽은 누굴까요?',
        ),
      ],
    ),
    // Phase 2: 클로킹 완성 + 침투 - 분기 (lines 18+) - recovery 200/2
    ScriptPhase(
      name: 'cloak_infiltrate',
      startLine: 18,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 완성! 레이스 3기가 침투합니다! 아카데미가 늦어서 스캔이 안 됩니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! 컴샛스테이션이 없어 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아카데미가 이제야 완성. 컴샛스테이션을 급히 올립니다.',
              owner: LogOwner.away,
              awayResource: -150, // 아카데미(150)
              fixedCost: true,
              awayArmy: -1,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 레이스 1기 (2sup)
              homeResource: -250, // 레이스(250)
              fixedCost: true,
              awayArmy: -2, favorsStat: 'harass',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 치명적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '압도적인 화력! 이건 컨트롤로 극복이 안 됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 올리려 하지만 SCV가 부족합니다!',
              owner: LogOwner.away,
              awayResource: -150, // 아머리(150) 시도
              fixedCost: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_no_antiair',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 아카데미는 올렸습니다. 컴샛스테이션 부착. 스캔은 가능합니다.',
              owner: LogOwner.away,
              awayResource: -150, // 아카데미(150)
              fixedCost: true,
              altText: '{away} 선수 아카데미 완성. 스캔은 달리지만 아머리가 문제입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔에 걸리지만 아머리 짓는 SCV를 집요하게 노립니다! 골리앗을 막겠다는 의도!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 아머리 건설을 끈질기게 방해합니다! 컨트롤이 뛰어납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 다시 올리지만 또 SCV가 잡힙니다! 건설이 안 됩니다!',
              owner: LogOwner.away,
              awayResource: -150, // 아머리(150) 재시도
              fixedCost: true,
              awayArmy: -1,
              altText: '{away} 선수 아머리 재건설 시도! 하지만 공중 유닛이 놓아주질 않습니다!',
            ),
            ScriptEvent(
              text: '스캔은 달리는데 골리앗이 없습니다. 마린만으로는 공중 유닛을 잡기 어렵습니다.',
              owner: LogOwner.system,
              altText: '상대 골리앗 숫자를 파악했습니다. 없습니다! 큰일이에요!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 5기 이상. 투스타포트에서 쉬지 않고 뽑아냅니다.',
              owner: LogOwner.home,
              homeArmy: 4, // 레이스 2기 (2sup x2)
              homeResource: -500, // 레이스2(500)
              fixedCost: true,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 레이스 물량이 쌓입니다! SCV가 녹아내리고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 있지만 공중 유닛을 잡을 수가 없습니다! SCV가 계속 줄어듭니다!',
              owner: LogOwner.away,
              awayResource: -15, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 편대로 상대 본진을 초토화합니다! 대공유닛 없이는 막을 수가 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 레이스 물량 앞에 속수무책! 아머리가 끝내 올라오지 못했습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 끈질기게 버텨서 아카데미와 아머리를 모두 완성합니다!',
              owner: LogOwner.away,
              awayResource: -300, // 아카데미(150) + 아머리(150)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 피해를 입었지만 핵심 건물을 모두 올렸습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 컴샛스테이션 완성. 스캔으로 클로킹을 잡고 골리앗까지 생산.',
              owner: LogOwner.away,
              homeArmy: -4, // 레이스 2기 격추 (2sup x2)
              awayArmy: 2, // 골리앗 1기 (2sup)
              awayResource: -150, // 골리앗(150)
              fixedCost: true,
              altText: '{away} 선수 스캔과 골리앗! 공중 유닛을 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 하지만 대공 화력이 대기 중!',
              owner: LogOwner.home,
              homeArmy: -2, // 레이스 1기 손실 (2sup)
            ),
            ScriptEvent(
              text: '{away} 선수 공중 견제를 막아냅니다! 하지만 SCV 피해가 좀 있습니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '공중 견제가 막혔습니다! 하지만 투스타 측은 수송선이 빠릅니다!',
              owner: LogOwner.system,
              altText: '서로의 빌드를 다 알고 있습니다. 이제는 컨트롤 싸움이에요.',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 26-34) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 올립니다. 탱크 생산 준비.',
          owner: LogOwner.home,
          homeResource: -100, // 머신샵(100)
          fixedCost: true,
          altText: '{home} 선수 머신샵 부착. 탱크를 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵 부착. 시즈 모드 연구.',
          owner: LogOwner.away,
          awayResource: -400, // 머신샵(100) + 시즈모드(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워 건설. 드랍십을 노립니다.',
          owner: LogOwner.home,
          homeResource: -100, // 컨트롤타워(100)
          fixedCost: true,
          altText: '{home} 선수 컨트롤타워 완성. 드랍십이 가능합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설. 터렛으로 공중 유닛을 대비합니다.',
          owner: LogOwner.away,
          awayResource: -200, // 엔지니어링베이(125) + 터렛(75)
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산. 기동전을 노리는 운영.',
          owner: LogOwner.home,
          homeArmy: 2, // 드랍십 1기 (2sup)
          homeResource: -200, // 드랍십(200)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 탱크가 모이고 있습니다. CC퍼스트 자원으로 라인 방어.',
          owner: LogOwner.away,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -250, // 탱크(250)
          fixedCost: true,
          altText: '{away} 선수 탱크 라인 구축. CC퍼스트 자원 가동.',
        ),
        ScriptEvent(
          text: '중반 전환기. 양쪽 다 메카닉 체제에 들어갑니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '첫 탱크가 나오기 전까지는 폭풍전야입니다.',
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
        ),
        ScriptEvent(
          text: '먼저 자리 잡는 쪽이 센터의 주인입니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
      ],
    ),
    // Phase 4: 후속 전개 - 분기 (lines 36+) - recovery 300/3
    ScriptPhase(
      name: 'post_defense',
      startLine: 36,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        // 게릴라 드랍: 확장 견제 후 회수
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십 출격. 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크 투하! SCV를 잡고 바로 회수합니다!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 일꾼을 솎아내고 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 달려왔지만 이미 빠져나갔습니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '드랍으로 시선을 끈 사이 정면 라인에서 거리재기가 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '게릴라 드랍! 자잘한 피해가 쌓이고 있습니다.',
            ),
          ],
        ),
        // 마무리 드랍: 유리한 쪽이 드랍과 정면으로 끝냄
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 본진과 확장 동시 투하!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십이 두 갈래로 나뉩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 세 방향 공격!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 분산됩니다! 어디를 먼저 막아야 할지!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스까지 합류! 상대 일꾼을 초토화합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 클로킹 레이스와 드랍 동시 투입! 막을 수 없습니다!',
            ),
          ],
        ),
        // 정면 밀기: 어웨이 자원 우위로 정면 승부
        ScriptBranch(
          id: 'frontal_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 CC퍼스트 자원이 풀가동! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 CC퍼스트 풀가동! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상병력이 부족합니다! 스타포트 투자가 무겁네요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 물량으로 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 시즈 포격! 라인을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗과 터렛으로 공중 유닛을 격추! 지상전에서 승리합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 대공 수비 성공! CC퍼스트 자원 우위로 밀어냅니다!',
            ),
          ],
        ),
        // 역전 드랍: 밀리는 홈이 본진 올인 드랍
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다! 승부수를 던집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 올인 드랍! 본진을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 본진에서 시즈 포격! 생산 시설을 파괴합니다!',
            ),
            ScriptEvent(
              text: '역전 드랍! 피해가 크면 경기가 뒤집어질 수 있습니다!',
              owner: LogOwner.system,
              altText: '승부수가 통할 것인가! 긴장감이 고조됩니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
