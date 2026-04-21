part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩원스타 vs 원팩투스타
// - 양쪽 공통: 가스 먼저 → 배럭 → 팩토리 → 머신샵 + 스타포트
// - 원팩원스타: 팩토리 + 스타포트(컨트롤타워) → 드랍쉽으로 탱크+벌처 본진 견제
// - 원팩투스타: 팩토리 + 스타포트 2개 → 클로킹 레이스 물량으로 SCV 솎아내기
// - 분기: 레이스 견제 성패 × home 대응 → 결전
// ----------------------------------------------------------
const _tvt1fac1starVs2star = ScenarioScript(
  id: 'tvt_1fac_1star_vs_2star',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2star'],
  description: '원팩원스타 vs 원팩투스타',
  phases: [
    // Phase 0: 오프닝 — 양쪽 가스 먼저, 공통 진행
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 가스부터 올립니다. 일반적인 앞마당 먹는 빌드는 아닌가봅니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100,
          altText: '{away} 선수 배럭보다 가스를 먼저 짓습니다. 어떤 전략을 준비해왔을까요?',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -150,
          altText: '{home} 선수 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150,
          altText: '{away} 선수 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100,
          altText: '{home} 선수 가스 지으며 팩토리 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -300,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 완성 후 벌처 생산, 스타포트 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -325, // 벌처 75 + 스타포트 250
          altText: '{home} 선수 벌처 하나 뽑으면서 스타포트 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산 후 스타포트 건설합니다. 서로 상대방의 빌드를 벌처로 파악하기 위함이죠.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -325, // 벌처 75 + 스타포트 250
          altText: '{away} 선수 벌처 생산과 스타포트, 현재까지는 데칼코마니처럼 빌드가 동일합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 스타포트까지 건설합니다. 여기서 빌드가 갈리네요.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -250, // 2nd 스타포트
          altText: '{away} 선수 스타포트 두 개째 올립니다. 클로킹 레이스를 운용하겠다는거죠.',
        ),
      ],
    ),

    // Phase 1: 테크 분화 — 원팩원스타(드랍쉽 준비) vs 원팩투스타(클로킹 레이스)
    ScriptPhase(
      name: 'mid_buildup',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스타포트 완성, 컨트롤타워 부착하면서 레이스 생산 준비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2,
          awayResource: -100, // 컨트롤타워 100
          altText: '{away} 선수 스타포트 완성 후 컨트롤타워 부착합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2,
          homeResource: -100, // 머신샵
          altText: '{home} 선수 머신샵을 올립니다. 벌처 속업이나 마인을 노리겠죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워를 부착합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 컨트롤타워
          altText: '{home} 선수 컨트롤타워를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 연구 진행 중, 두 번째 스타포트에서도 레이스 생산합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2,
          awayResource: -250, // 레이스 2nd
          altText: '{away} 선수 스타포트 두 곳에서 레이스가 동시에 생산되고 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 컨트롤타워 완성. 드랍쉽을 뽑을지 레이스를 뽑을지, 어떤 선택을 할까요?',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 레이스와 드랍쉽 중 어떤 선택을 할까요? 상대방 레이스를 아직은 모르는 상황이죠.',
        ),
      ],
    ),

    // Phase 2: home 테크 선택 — 드랍쉽(25%) vs 레이스(75%)
    //   드랍쉽 선택 시 공중 대응 수단이 없어 투스타 레이스에 격추당함
    ScriptPhase(
      name: 'home_tech_choice',
      recoveryArmyPerLine: 1,
      branches: [
        // 25% — 드랍쉽 선택 (실수): baseProb 0.0 → armyInfluencedSelect 공식상 25%
        ScriptBranch(
          id: 'home_picks_dropship',
          description: '원팩원스타: 드랍쉽 선택 — 공중 대응 부재 상태',
          baseProbability: 0.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽 생산 시작합니다. 상대 레이스에게 들키지 않을 수 있을까요?',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -200, // 드랍쉽
              altText: '{home} 선수 드랍쉽을 선택합니다. 견제하면서 상대가 방어하는동안 확장을 하겠다는거죠.',
            ),
          ],
        ),
        // 75% — 레이스 선택 (정석): baseProb 1.0
        ScriptBranch(
          id: 'home_picks_wraith',
          description: '원팩원스타: 레이스 선택 — 공중전 돌입',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수도 레이스 생산합니다. 상대방 병력의 부조화를 노릴 생각인데요.',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: 2, // netHomeImpact = 0으로 유지 (확률 안정화)
              homeResource: -250,
              awayResource: -250,
              altText: '{home} 선수 레이스를 뽑습니다. 아직 상대방이 투스타인건 모르는 상태입니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 3: home 테크 선택 결과
    //   드랍쉽 → 레이스에 격추당해 away decisive
    //   레이스 → 공중 교전 진입 (계속)
    ScriptPhase(
      name: 'tech_consequence',
      recoveryArmyPerLine: 1,
      branches: [
        // 드랍쉽 선택 시: away 100% 승
        ScriptBranch(
          id: 'away_dropship_annihilation',
          description: '투스타: 레이스로 드랍쉽 격추 + 본진 견제 → 승리',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['home_picks_dropship'],
          events: [
            ScriptEvent(
              text: '{away} 선수, 레이스가 상대 본진을 타격하기 시작합니다. {home} 선수 레이스를 막을 병력이 없는데요!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{away} 선수의 레이스가 무방비인 상대방 본진을 정찰하며 빌드를 확인합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽이 나오자마자 격추. {home} 선수 망연자실한데요!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -4,
              homeResource: -200,
              altText: '{away} 선수 상대방 드랍쉽이 생산되자마자 격추시킵니다. {home} 선수 피해가 큰데요!',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 아머리를 올리지만 시간이 부족합니다. 레이스가 계속 SCV를 잡네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 대공 수단이 없는 상태에서 레이스 견제를 받고 자원이 마르기 시작합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 물량 유지, 공중 제공권을 완전히 장악합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4,
              awayResource: -500, // 레이스 2기 추가
              altText: '{away} 선수 레이스를 계속 뽑아내며 전장을 장악하네요.',
            ),
            ScriptEvent(
              text: '{home} 선수 가지고 있는 병력으로 상대방에게 진격해보지만 추가병력과 레이스로 쉽게 막힙니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              homeArmy: -8,
            ),
            ScriptEvent(
              text: '{away} 선수 공중과 지상 동시 압박, 본진까지 밀어붙입니다. 드랍쉽 선택이 치명적이었습니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 레이스의 물량의 강점을 완벽히 살렸네요. 전략이 통했습니다!',
            ),
          ],
        ),
        // 레이스 선택 시: 첫 레이스 조우 — 3가지 전개로 분기
        //   공통: 양측 레이스가 이동 중 조우, 투스타가 물량에서 유리한 구도
        // 분기 A: home 1대1 승 → away 물량으로 역전, home 뒤늦게 대공 준비
        ScriptBranch(
          id: 'wraith_home_first_hit_then_pushed',
          description: '레이스 1대1은 home 승 → away 추가 물량으로 공중 우위 역전, home 투스타 인지 후 아머리/아카데미 급조',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['home_picks_wraith'],
          events: [
            ScriptEvent(
              text: '양측 레이스가 이동 중 만납니다. 서로 스타포트 시작인 건 알게됐죠.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '두 선수 레이스가 마주칩니다. 아직까진 서로 스타포트의 개수는 알 수 없죠.',
            ),
            ScriptEvent(
              text: '{home} 선수가 먼저 선제공격, 첫 1대1 교전은 {home} 선수가 잡아냅니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
              altText: '{home} 선수 레이스 선제 타격, 첫 레이스를 떨어뜨립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스타포트 두 곳에서 레이스 추가 합류로 약간 밀렸던 초반 레이스 싸움을 뒤집습니다.',
              owner: LogOwner.away,
              homeResource: 0,
              homeArmy: -4,
              awayArmy: 4,
              awayResource: -500, // 레이스 2기
              altText: '{away} 선수 레이스 추가 투입, 첫 레이스 싸움은 밀린 것 처럼 보였지만 숫자로 공중 주도권을 가져오네요.',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 레이스 물량으로 투스타를 확인, 급하게 아머리와 아카데미를 올리며 수비로 전환합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -275, // 아머리 150 + 아카데미 125
              altText: '{home} 선수 상대방 레이스 합류 속도로 투스타를 파악했죠, 아머리와 아카데미를 동시에 올리면서 수비를 생각합니다.',
            ),
          ],
        ),

        // 분기 B: away가 선제+물량 둘 다 앞서 첫 교전부터 완승
        ScriptBranch(
          id: 'wraith_away_first_hit',
          description: '첫 교전 away 선제공격 + 물량 → home 레이스 녹음, home 급조 아머리/아카데미 (away는 레이스 올인 계속)',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['home_picks_wraith'],
          events: [
            ScriptEvent(
              text: '양측 레이스가 상대방의 진영으로 이동 중, {away} 선수의 반응이 좀 더 빨랐고 상대방 레이스를 한대 차이로 쫓아가며 격추시킵니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '두 선수 레이스가 서로의 진영으로 이동하다가 만나는데 {away} 선수의 레이스가 더 기민하게 상대방 레이스를 쫓아가며 제거합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 선제공격 우위로 첫 공중전부터 {home} 선수의 레이스를 녹입니다.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
              altText: '{away} 선수 첫 레이스 교전부터 완승, {home} 선수 비상입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 소실 후 급하게 아머리, 아카데미를 올립니다. 지상 대공으로 보완해야죠.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -275, // 아머리 + 아카데미
              altText: '{home} 선수 상대방 레이스 대응하기 위해 대공 건물을 급하게 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 추가 생산 유지. 상대방 레이스 수급 속도로 원스타인것을 파악했을텐데요.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2,
              awayResource: -250, // 레이스 추가
              altText: '{away} 선수 레이스만 계속 뽑습니다. 승기를 잡았다고 생각합니다.',
            ),
          ],
        ),

        // 분기 C: home이 상대 레이스 인지 후 미리 대공 건물 분산 건설 + 앞마당
        ScriptBranch(
          id: 'wraith_home_prepared',
          description: '원팩원스타: 상대 레이스 인지 즉시 엔베/아머리/아카데미 분산 건설, 마린+레이스로 본진 방어 + 앞마당 확장',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['home_picks_wraith'],
          events: [
            ScriptEvent(
              text: '{home} 선수 상대 레이스를 확인하자마자 엔지니어링 베이부터 올립니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -125, // 엔베
              altText: '{home} 선수 대공 대비, 엔지니어링 베이를 먼저 올립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 이어서 아카데미와 아머리까지 분산 배치합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -275, // 아카데미 125 + 아머리 150
              altText: '{home} 선수 아카데미, 아머리도 동시에 분산 건설합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 계속 합류하면서 건물 건설하는 {home} 선수의 SCV를 견제 계속합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              homeResource: -200,
              awayArmy: 4,
              altText: '{away} 선수 레이스 추가로 보내면서 상대방의 대공 방어를 최대한 늦추려고 합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 소수 마린과 레이스로 본진을 방어, 건물이 올라갈 때 까지 버텨야합니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4,
              homeResource: -300, // 터렛 75*2 + 골리앗 150
              altText: '{home} 선수 나와있는 마린과 레이스로 피해를 최소화하며 건물 올려야합니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 4: 전장 스타일 분기 — 공중전 vs 테테전 (wraith_engagement_start 이후만)
    ScriptPhase(
      name: 'battle_style',
      recoveryArmyPerLine: 1,
      branches: [
        // 공중전: 투스타 쪽 레이스가 이득을 쌓는 분기
        ScriptBranch(
          id: 'two_star_push',
          description: '투스타 레이스 이득 쌓기',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['wraith_home_first_hit_then_pushed'],
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스가 계속 합류하면서 건물 건설하는 {home} 선수의 SCV를 견제 계속합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              homeResource: -200,
              awayArmy: 4,
              altText: '{away} 선수 레이스 추가로 보내면서 상대방의 대공 방어를 최대한 늦춥니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트에서 레이스 추가 생산하면서 건물 짓는 SCV를 계속 붙여줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -350, // 레이스
              altText: '{home} 선수도 레이스 추가. 하지만 레이스 숫자 차이는 유지됩니다. 대공을 위한 건물이 올라가야합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 꽤 모였다고 판단하고 상대방 레이스를 컨트롤로 격추시킵니다.',
              owner: LogOwner.away,
              awayResource: 0,
              homeResource: -200,
              homeArmy: -6,
              awayArmy: -2,
              altText: '{away} 선수 상대방 레이스가 모이게 두질 않습니다. 컨트롤로 {home} 선수의 레이스를 줄입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수는 레이스 컨트롤 이어가며 앞마당 확장 시도합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -400,
              altText: '{away} 선수 승기를 잡았다고 생각하고 앞마당까지 먹습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 끈기로 아머리, 아카데미 등 방어 건물은 올렸지만 피해가 막심합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
              altText: '{home} 선수 이제 골리앗 생산과 스캔 건설이 가능한 상태가 되었지만 SCV 피해가 큽니다.',
            ),

          ],
        ),
        ScriptBranch(
          id: 'two_star_almost_win',
          description: '투스타 레이스 승기 잡음',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['wraith_away_first_hit'],
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스가 계속 합류하면서 건물 건설하는 {home} 선수의 SCV를 견제 계속합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              homeResource: -200,
              awayArmy: 4,
              altText: '{away} 선수 레이스 추가로 보내면서 상대방의 대공 방어를 최대한 늦춥니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트에서 레이스 추가 생산하면서 건물 짓는 SCV를 계속 붙여줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -350, // 레이스
              altText: '{home} 선수도 레이스 추가. 하지만 레이스 숫자 차이는 유지됩니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 꽤 모여서 이제 SCV가 한방에 죽습니다. {home} 선수 건물 짓기 쉽지않은데요.',
              owner: LogOwner.away,
              awayResource: 0,
              homeResource: -200,
              homeArmy: -6,
              awayArmy: -2,
              altText: '{away} 선수 혼신의 컨트롤로 SCV를 계속해서 잡아냅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수는 레이스 컨트롤 이어가며 앞마당 확장 시도합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -400,
              altText: '{away} 선수 승기를 잡았다고 생각하고 앞마당까지 먹습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 피해가 막심합니다! 건물이 올라가지 못해서 골리앗을 뽑을 수가 없습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -6,
              homeResource: -400,
              altText: '{home} 선수 상대방의 레이스를 막아내지 못하는 것으로 보이는데요!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_defense_complete',
          description: '원스타가 눈치채고 빠르게 수비적으로 전환',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['wraith_home_prepared'],
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트에서 레이스 추가 생산하면서 건물 짓는 SCV를 계속 붙여줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -350, // 레이스
              altText: '{home} 선수도 레이스 추가. 하지만 레이스 숫자 차이는 유지됩니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 무리해서 레이스를 더 뽑지않고 앞마당 먹으며 후반을 바라봅니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -400,
              altText: '{away} 선수 지금까지 뽑은 레이스로 견제를 이어가며 앞마당 확장 가져갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 건물 완성하며 수비 태세 갖춥니다. 터렛 건설하며, 골리앗 생산 시작하네요',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -225,
              altText: '{home} 선수 빠른 판단으로 레이스 숫자 차이가 있었지만 큰 피해없이 수비합니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 5: 중반 전개 — 배틀 스타일별 이벤트 진행
    ScriptPhase(
      name: 'mid_transition',
      recoveryArmyPerLine: 2,
      branches: [

        // 테테전: 탱크+골리앗+드랍쉽 지상 중심
        ScriptBranch(
          id: 'mech_battle_focus',
          description: '테테전 돌입 — 탱크+골리앗+드랍쉽 지상 조합',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['home_defense_complete'],
          events: [
            ScriptEvent(
              text: '{home} 선수도 앞마당 따라가며 방어 건물 늘려갑니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -475, // 커맨드센터 + 터렛
              altText: '{home} 선수도 병력 앞마당으로 옮기며 앞마당 확장 따라갑니다.',
            ),
            ScriptEvent(
              text: '양측 초반 교전이 지나가고 추가 확장과 견제 등 중반부 싸움을 준비합니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '레이스로 끝나지 않은 경기 결국 전형적인 테테전 양상이 벌어질 것 같습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스타포트 두 개는 드랍쉽이 빨리 모일 수 있다는 거죠.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{away} 선수의 스타포트 두 개는 상대방보다 드랍쉽이 빠르게 모인다는 장점입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 팩토리를 늘려주며 지상군 확보를 노립니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -900, // 팩토리 3
              altText: '{home} 선수 팩토리 한번에 늘려줍니다. 시즈모드 업그레이드도 진행.',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 한번에 늘려주며 지상군 싸움을 예고합니다. 시즈모드 업그레이드도 진행합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -1200, // 팩토리 3 + 시즈모드 업그레이드
              altText: '{away} 선수 팩토리 늘려줍니다. 시즈모드 업그레이드도 진행.',
            ),
          ],
        ),

        // 공중전 스타일: 레이스 교전 지속
        ScriptBranch(
          id: 'air_battle_finished',
          description: '투스타 쪽이 유리한 공중전 전황',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['two_star_push'],
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트 한대 더 따라가며 발키리 준비합니다. 공중싸움이 더 커질 것 같습니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -500, //
              altText: '{home} 선수 발키리 준비하며 스타포트 한대 더 짓습니다. 공중에서 밀리지 않겠다는 거네요.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 개수 유지하면서 아머리, 아카데미 등 필수 건물 올립니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -400, //
              altText: '{away} 선수 레이스 생산을 멈추지 않습니다. 상대방의 발키리 준비는 아직 모릅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 초반 피해를 뒤집기 위한 공중 공업 진행하고, 발키리와 레이스 섞어줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 6,
              homeResource: -500, // 탱크
              altText: '{home} 선수 발키리, 레이스로 조합하며 공중 공업까지 진행합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔으로 레이스 숫자 대략적으로 파악합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '{home} 선수 상대방 병력 스캔으로 확인 진행합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스캔으로 발키리 준비하고 있는 것 파악합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.4,
              altText: '{away} 선수 상대방 병력 조합을 스캔으로 확인 진행합니다.',
            ),
          ],
        ),

        // 테테전 스타일: 지상 라인 구축
        ScriptBranch(
          id: 'mech_battle_continue',
          description: '테테전 지속 — 탱크 시즈 라인 형성',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['mech_battle_focus'],
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크와 골리앗으로 추가확장 앞 수비라인 형성하며 확장 진행합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -475, // 커맨드 + 터렛
              altText: '{away} 선수 추가확장을 진행하며 확장 앞에 탱크와 골리앗으로 라인 형성합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈모드 업그레이드 진행하며 드랍쉽 모아줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -450,
              homeArmy: 4,
              altText: '{home} 선수 드랍쉽 계속 생산하며 시즈모드 업그레이도 진행합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽도 함께 준비하네요. 두대씩 추가가 됩니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6,
              awayResource: -300, // 탱크 + 드랍쉽
              altText: '{away} 선수 시즈 라인 구축, 드랍쉽 운영도 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 확장 따라가면서 탱크 시즈모드로 수비라인 형성합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 시즈모드로 라인 형성하며 추가 확장 가져갑니다.',
            ),
            // 치고박는 텍스트 추가
            ScriptEvent(
              text: '{away} 선수 드랍쉽이 더 빨리 쌓이는 이점으로 상대방 추가 확장 앞 쪽 병력을 싸먹습니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              homeArmy: -40,
              altText: '{away} 선수 지상병력과 드랍쉽 움직임으로 상대방 추가 확장 앞 수비 병력을 밀어냅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 병력 태워서 추가확장 커버 진행합니다.',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -40,
              homeArmy: -10,
              altText: '{home} 선수 확장에 {away} 선수의 병력이 올라오기전에 드랍쉽으로 수비병력을 채웁니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 확장을 하나 더 진행합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 수비를 진행하며 확장 한개 더 먹습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 병력 태워서 상대방 추가확장에 직접 병력들을 내립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -40,
              homeArmy: -10,
              altText: '{home} 선수 확장 진행하면서 상대방 확장 견제를 드랍쉽에 병력태워서 진행합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장의 SCV를 빼며 드랍쉽으로 확장이 깨지기 전에 수비 성공합니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              homeArmy: -40,
              altText: '{away} 선수 대기하고 있던 드랍쉽으로 SCV 피해없이 상대방 병력 잡아냅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 추가 확장을 하나 더 진행합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{away} 선수도 수비를 진행하며 확장 한개 더 먹습니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 6: 결전 — 배틀 스타일별 decisive 분기
    ScriptPhase(
      name: 'timing_clash',
      recoveryArmyPerLine: 2,
      branches: [
        // 공중전 away 승: 스타포트 수 차이로 레이스 물량 압도
        ScriptBranch(
          id: 'away_air_wins',
          description: '공중전 away 승 — 스타포트 2개 물량 우위',
          baseProbability: 1.0,
          conditionStat: 'control',
          conditionPriorBranchIds: ['air_battle_finished'],
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 수가 두 배 가까이 됩니다. 컨트롤로도 물량 차이는 못 메우네요.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
              altText: '{away} 선수 스타포트 두 개의 생산력이 결정적입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 대부분 잃고 공중 제공권을 완전히 넘겨줍니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 공중 제공권 장악 후 SCV 견제, 본진까지 들어가 마무리합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 공중전 완승, 스타포트 두 개의 선택이 옳았네요.',
            ),
          ],
        ),
        // 공중전 home 승: 컨트롤로 스타포트 수 차이 극복
        ScriptBranch(
          id: 'home_air_wins',
          description: '공중전 home 승 — 레이스 컨트롤로 물량 차이 극복',
          baseProbability: 1.0,
          conditionStat: 'control',
          conditionPriorBranchIds: ['air_battle_finished'],
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 점사로 연속 격추. 스타포트 하나의 물량으로도 컨트롤이 앞서네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,
              altText: '{home} 선수 점사 컨트롤이 빛납니다. 물량 차이를 기술로 메우는 그림이죠.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 손실이 축적됩니다. 스타포트 투자 비용이 무의미해지네요.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 공중을 정리하고 탱크 라인으로 마무리, 컨트롤의 승리입니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 레이스 컨트롤 승리. 스타포트 하나로 두 개를 이겨냈네요.',
            ),
          ],
        ),
        // 테테전 away 승: 탱크 전환 후 물량 우위
        ScriptBranch(
          id: 'away_mech_wins',
          description: '테테전 away 승 — 한 발 빠른 드랍 움직임',
          baseProbability: 1.0,
          conditionStat: 'attack',
          conditionPriorBranchIds: ['mech_battle_continue'],
          events: [

            ScriptEvent(
              text: '{away} 선수 상대방 확장기지 앞 수비 병력을 지상군과 드랍쉽 병력으로 한번 더 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -12,
              homeResource: -400,
              altText: '{away} 선수 상대방 커버 전 수비병력을 밀어내고 상대방 확장기지 한 곳을 점령합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽이 멀리 떨어져있습니다! 최대한 빨리 와서 커버하지만 한 끗 차이로 멀티가 파괴됩니다.',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -12,
              awayArmy: -4,
              altText: '{home} 선수 드랍쉽이 공격을 가려다가 돌아와서 수비를 진행합니다. 하지만 피해가 이미 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대방 확장기지 두 곳을 한 번에 타격 가능한 곳에 드랍쉽에서 내린 병력들이 자리잡습니다!',
              owner: LogOwner.away,
              awayResource: 0,
              homeArmy: -20,
              awayArmy: -8,
              homeResource: -800,
              altText: '{away} 선수 병력을 밀어내기 까다로운 곳에 드랍이 절묘하게 성공합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽과 지상 병력으로 주요 지점을 재 탈환하려하지만 시즈모드 포격에 지상군이 녹고 드랍쉽도 대부분 잃습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
              altText: '{home} 선수 상대방 병력 밀어내려 하다가 병력이 괴멸당합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대방 병력 위치 확인과 절묘한 위치에 드랍의 승리네요.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 한 발 빠른 병력 움직임의 승리입니다.',
            ),
          ],
        ),
        // 테테전 home 승: 골리앗 대공 + 시즈 라인으로 승리
        ScriptBranch(
          id: 'home_mech_wins',
          description: '테테전 home 승 — 공중전은 끝났고 메카닉+드랍쉽 home이 더 잘씀',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          conditionPriorBranchIds: ['mech_battle_continue'],
          events: [
            ScriptEvent(
              text: '{home} 선수 상대방 확장기지를 지상병력 전진과 드랍쉽 병력 투하로 견제 진행합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -6,
              awayResource: -400,
              altText: '{home} 선수 드랍쉽 운용이 상대보다 한 발 빠릅니다. 상대방 확장기지 견제!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 탱크와 골리앗을 태워 상대방 확장기지 뒤편에 내립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayArmy: -12,
              homeArmy: -4,
              awayResource: -400,
              altText: '{home} 선수 계속해서 이어지는 드랍, {away} 선수 속도를 못 따라옵니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽으로 수비하러 오지만 {home} 선수의 탱크가 이미 자리잡았습니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -8,
              homeArmy: -2,
              altText: '{away} 선수 급하게 병력을 채우려고 하지만 상대방의 탱크 포격에 병력이 녹습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 상대방 확장기지 두 곳을 한 번에 타격 가능한 곳에 드랍쉽에서 내린 병력들이 자리잡습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -8,
              awayResource: -400,
              altText: '{home} 선수 병력을 밀어내기 까다로운 곳에 드랍이 절묘하게 성공합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽과 지상 병력으로 주요 지점을 재 탈환하려하지만 시즈모드 포격에 지상군이 녹고 드랍쉽도 대부분 잃습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -8,
              homeArmy: -2,
              altText: '{away} 선수 상대방 병력 밀어내고 확장을 되찾으려다가 병력이 괴멸당합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대방 병력 위치 확인과 절묘한 위치에 드랍의 승리네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 한 발 빠른 병력 움직임의 승리입니다.',
            ),
          ],
        ),
      ],
    ),
  ],
);
