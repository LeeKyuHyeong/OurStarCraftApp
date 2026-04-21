part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩원스타 vs 원배럭더블
// - 원팩원스타: 배럭 → 가스 → 팩토리(머신샵) → 스타포트(컨트롤타워) → 드랍쉽/레이스 견제
// - 원배럭더블: 배럭 → 커맨드센터 → 가스 → 팩토리 → 수비 후 자원 우위
// - 분기: 첫 드랍쉽 견제 성패 → 6가지 전개
// ----------------------------------------------------------
const _tvt1fac1starVs1barDouble = ScenarioScript(
  id: 'tvt_1fac_1star_vs_1bar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_1bar_double'],
  description: '원팩원스타 vs 원배럭더블',
  phases: [
    // Phase 0: 오프닝 (line 1)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 배럭을 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150, // 배럭 150
          altText: '{away} 선수 배럭 올립니다.',
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
          text: '{home} 선수 가스를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 가스 100
          altText: '{home} 선수 가스를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터를 건설합니다. 수비만 된다면 자원적으로 부유한 빌드 선택이죠.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -400, // CC 400
          altText: '{away} 선수 앞마당 커맨드센터가 올라갑니다. 확장을 먼저 가네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100, // 가스 100
          altText: '{away} 선수 가스를 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300, // 팩토리 300
          altText: '{home} 선수 팩토리 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭이 완성되며 앞마당에 벙커를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 1,
          awayResource: -150, // 벙커 100 + 마린 50
          altText: '{away} 선수 앞마당에 벙커를 지어주며 마린을 뽑습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 완성 후 벌처 생산하며 바로 스타포트도 지어줍니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -225, // 벌쳐75 + 스타포트 250
          altText: '{home} 선수 벌쳐 뽑으며 스타포트 건설합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 SCV 붙여주며 팩토리 건설 시작합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayExpansion: true,
          awayResource: -300, // 팩토리 300
          altText: '{away} 선수 앞마당 활성화 시키며 팩토리 올려줍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 첫 벌쳐로 정찰 나가며 애드온 붙입니다. 상대방 앞마당 확인했죠.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 머신샵 100
          altText: '{home} 선수 애드온 진행하며 벌쳐로 정찰에 나섭니다. 상대방의 빠른 확장을 확인했습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이를 올리며 수비적으로 중반을 도모하려고 합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -125, // 엔베 125
          altText: '{away} 선수 엔베를 건설하며 혹시 모를 상대방의 공중 유닛을 대비하려는 움직임입니다.',
        ),
      ],
    ),

    // Phase 1: 드랍쉽 준비 + away 수비 (line 9)
    ScriptPhase(
      name: 'drop_preparation',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 애드온 건설 되자마자 벌쳐 속업을 찍어줍니다. 스타포트도 완성 후 컨트롤타워를 달아주며 드랍쉽 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300, // 속업 200 + 컨트롤타워 100
          altText: '{home} 선수 머신샵에서 벌쳐 스피드업을 먼저 연구합니다. 스타포트 컨트롤타워 부착하며 드랍 준비를 이어갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 완성되자마자 벌쳐를 생산하며, 아머리와 아카데미를 동시에 건설 시작합니다. ',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2,
          awayResource: -375, // 벌쳐 75 + 아머리 150 + 아카데미 150
          altText: '{away} 선수 팩토리 완성, 벌쳐 생산 및 아머리와 아카데미를 동시에 올려줍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍쉽 생산합니다. 드랍쉽이 나올때 4벌쳐가 딱 완성되는게 최적화죠.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6,
          homeResource: -350, // 드랍쉽 150 + 벌쳐 추가 2기 150
          altText: '{home} 선수 드랍쉽이 곧 나옵니다. 드랍쉽이 나오자마자 탈 수 있게 4벌쳐를 모으고 있습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛을 건설하고 벌처를 추가 생산합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2,
          awayResource: -150, // 터렛 75 + 벌처 75
          altText: '{away} 선수 터렛과 벌처 추가. 수비 라인을 형성합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍쉽에 병력을 태웁니다. 상대 진영으로 출발!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 드랍쉽이 상대 진영을 향합니다.',
        ),
        ScriptEvent(
          text: '첫 드랍쉽이 올라갑니다! 이 견제가 경기를 결정지을 수도 있습니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '드랍쉽 출발! 수비 준비가 됐을까요?',
          skipChance: 0.3,
        ),
      ],
    ),

    // Phase 2: 첫 드랍 결과 — 3갈래 (line 15)
    ScriptPhase(
      name: 'first_drop_result',
      recoveryArmyPerLine: 1,
      branches: [
        // A: 4벌처 드랍 — SCV 큰 피해
        ScriptBranch(
          id: 'vulture_drop_heavy',
          description: '4벌처 드랍으로 SCV 큰 피해',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽에서 벌처 4기가 쏟아집니다! 일꾼 사이로 돌진!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              altText: '{home} 선수 벌처가 내립니다! SCV가 순식간에 줄어드네요!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린과 벌처로 막으려 하지만 SCV 피해가 큽니다.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: -4,
              awayResource: -200,
              altText: '{away} 선수 병력을 돌려서 벌처를 잡지만 이미 SCV가 많이 죽었습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽을 빼냅니다. 첫 견제 큰 성과네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home} 선수 드랍쉽 회수. SCV 피해가 상당합니다.',
            ),
          ],
        ),
        // B: 1탱크+2벌처 드랍 — 앞마당/본진 양방향
        ScriptBranch(
          id: 'tank_vulture_split',
          description: '탱크+벌처 드랍으로 앞마당/본진 양방향 공격',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽에서 탱크와 벌처가 내립니다! 탱크 시즈모드!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -200,
              awayArmy: -2,
              altText: '{home} 선수 시즈 탱크가 상대 본진에 내렸습니다! 포격 시작!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상군이 앞마당 앞에 도착합니다! {away} 선수 본진 탱크 처리하느라 병력이 나뉘네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -200,
              altText: '{home} 선수 양쪽 동시 압박! {away} 선수 병력 배분이 어렵습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 빼면서 탱크를 잡아냈지만 자원 채취가 끊겼습니다.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: -2,
              awayResource: -100,
              altText: '{away} 선수 탱크는 잡았지만 SCV 손실과 자원 공백이 발생합니다.',
            ),
          ],
        ),
        // C: 드랍 피해 미미 — 수비 성공
        ScriptBranch(
          id: 'drop_contained',
          description: '드랍 견제가 큰 피해 없이 막힘',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽이 상대 본진에 접근합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home} 선수 드랍쉽이 올라갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 터렛과 마린이 대기하고 있습니다! 드랍 지점이 막혀있네요.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{away} 선수 수비가 철저합니다. 드랍할 자리가 없습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 소수 병력만 내리고 바로 회수합니다. 큰 피해는 없었네요.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,
              homeArmy: -2,
              altText: '{home} 선수 드랍쉽 회수. 수비가 잘 되어서 큰 성과는 없습니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 3: 중반 전개 + 결전 — 6갈래 (line 20)
    ScriptPhase(
      name: 'mid_resolution',
      recoveryArmyPerLine: 2,
      branches: [
        // ── HOME WIN 1: 4벌처 대성공 → 앞마당 확장하며 계속 압박 ──
        ScriptBranch(
          id: 'home_expand_pressure',
          description: 'SCV 큰 피해 후 앞마당 확장하며 지속 압박',
          baseProbability: 1.0,
          conditionStat: 'attack',
          conditionPriorBranchIds: ['vulture_drop_heavy'],
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV 피해를 준 틈에 앞마당 커맨드센터를 올립니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 견제 성공 후 바로 앞마당 확장 진행합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 줄어서 자원 수급이 느려졌습니다. 팩토리를 추가하지만...',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              altText: '{away} 선수 SCV 손실로 자원이 부족합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 팩토리를 추가하며 탱크 물량을 쌓아갑니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4,
              homeResource: -550, // 팩토리 300 + 탱크 250
              altText: '{home} 선수 팩토리 추가. 탱크가 쌓이기 시작합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 두 번째 드랍쉽으로 또 견제! {away} 선수 병력을 나눌 수가 없습니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -300,
              awayArmy: -4,
              altText: '{home} 선수 드랍 견제가 이어집니다! {away} 선수 복구할 시간이 없네요.',
            ),
            ScriptEvent(
              text: '{home} 선수 자원과 병력 우위를 동시에 가져갑니다. 견제의 승리네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 첫 드랍 견제가 경기를 결정지었습니다.',
            ),
          ],
        ),

        // ── AWAY WIN 3: 4벌처 피해 입었지만 2CC로 SCV 복구 → 힘싸움 ──
        ScriptBranch(
          id: 'away_2cc_recovery',
          description: '드랍 피해 후 2CC로 SCV 복구하며 힘싸움 승리',
          baseProbability: 1.0,
          conditionStat: 'macro',
          conditionPriorBranchIds: ['vulture_drop_heavy'],
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 컸지만 커맨드센터 두 개에서 SCV를 바로 뽑습니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{away} 선수 커맨드센터 두 곳에서 SCV 복구 시작합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 생산 속도가 빠릅니다. 커맨드센터 두 개의 위력이죠.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4,
              awayResource: -300, // 팩토리에서 생산
              altText: '{away} 선수 SCV가 빠르게 복구됩니다. 더블의 장점이네요.',
            ),
            ScriptEvent(
              text: '{home} 선수 두 번째 드랍을 시도하지만 이번에는 터렛과 마린이 대기하고 있습니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
              altText: '{home} 선수 추가 드랍이 막힙니다. 수비가 보강됐네요.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 복구되면서 자원 수급이 정상화됩니다. 팩토리를 추가합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6,
              awayResource: -550, // 팩토리 300 + 탱크 250
              altText: '{away} 선수 자원이 다시 돌아옵니다. 물량 생산에 들어갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 복구된 자원으로 탱크 물량이 {home} 선수를 압도합니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -8,
              awayArmy: -2,
              altText: '{away} 선수 탱크 물량으로 밀어붙입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 꾸역꾸역 막아내더니 결국 자원의 힘으로 역전합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 커맨드센터 두 개의 복구력이 결정적이었습니다.',
            ),
          ],
        ),

        // ── HOME WIN 2: 탱크+벌처 드랍 → 레이스+소수 드랍 견제 지속 ──
        ScriptBranch(
          id: 'home_wraith_continued',
          description: '양방향 타격 후 레이스+드랍 견제로 마무리',
          baseProbability: 1.0,
          conditionStat: 'harass',
          conditionPriorBranchIds: ['tank_vulture_split'],
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스를 생산합니다. 공중에서도 견제하겠다는 거죠.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -250,
              altText: '{home} 선수 레이스가 나옵니다. 견제 수단이 늘어납니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스를 막기 위해 터렛을 추가하지만 자원이 빠듯합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -150,
              altText: '{away} 선수 터렛 추가 건설. 하지만 이미 SCV 피해가 누적됐습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스로 SCV를 잡아가며 드랍쉽도 다시 띄웁니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -200,
              altText: '{home} 선수 레이스와 드랍쉽 동시 운영! {away} 선수 방어하기 쉽지 않습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 터렛 범위 밖 SCV가 계속 잡히며 자원 차이가 벌어집니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -300,
              awayArmy: -4,
              altText: '{away} 선수 레이스와 드랍을 동시에 막기 어렵습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 다방면 견제로 상대 자원을 말려버립니다. 생산이 안 되네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 견제의 정석을 보여줍니다. 자원 차이가 승부를 갈랐네요.',
            ),
          ],
        ),

        // ── AWAY WIN 2: 레이스 뽑았지만 엔베+터렛으로 수비 → 지상군 차이 ──
        ScriptBranch(
          id: 'away_turret_defense',
          description: '엔베+터렛 대공으로 레이스 막고 지상군 차이 승리',
          baseProbability: 1.0,
          conditionStat: 'defense',
          conditionPriorBranchIds: ['tank_vulture_split'],
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스를 생산하며 추가 견제를 노립니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2,
              homeResource: -250,
              altText: '{home} 선수 레이스로 추가 견제를 시도합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 터렛을 추가 건설하고 마린도 뽑아줍니다. 대공이 촘촘합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4,
              awayResource: -200,
              altText: '{away} 선수 터렛과 마린으로 대공 수비가 촘촘합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 터렛에 막힙니다. SCV를 잡을 수 없네요.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{home} 선수 레이스가 터렛 범위 안에서 녹습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 견제를 막는 사이 팩토리를 늘려 탱크를 쌓습니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6,
              awayResource: -550, // 팩토리 300 + 탱크 250
              altText: '{away} 선수 수비하면서 물량을 쌓습니다. 지상군 차이가 벌어지네요.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량으로 전진. {home} 선수 지상군이 부족합니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -8,
              awayArmy: -2,
              altText: '{away} 선수 지상군 물량이 압도적입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 대공 수비와 더블 자원이 빛을 발합니다. 안정적인 운영의 승리네요.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 수비 후 역공. 자원 차이가 결정적이었습니다.',
            ),
          ],
        ),

        // ── HOME WIN 3: 드랍 피해 적지만 시간 벌고 앞마당 → 지상+드랍 ──
        ScriptBranch(
          id: 'home_late_ground',
          description: '드랍으로 시간 벌고 확장 후 지상+드랍 운용 승리',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          conditionPriorBranchIds: ['drop_contained'],
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍 피해는 적었지만 그 사이 앞마당 커맨드센터를 올립니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 견제하는 동안 앞마당 확장을 따라갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 팩토리를 늘려주며 탱크 물량을 확보합니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4,
              homeResource: -550, // 팩토리 300 + 탱크 250
              altText: '{home} 선수 팩토리 추가. 본격적인 탱크 생산에 들어갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 팩토리를 추가하지만 {home} 선수의 테크가 한 발 빠릅니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4,
              awayResource: -550,
              altText: '{away} 선수 팩토리 추가. 자원은 앞서지만 테크에서 밀립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 탱크를 태워 상대 확장기지 뒤편에 내립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayArmy: -8,
              homeArmy: -4,
              awayResource: -400,
              altText: '{home} 선수 드랍 견제와 지상 전진을 동시에! 양면 작전입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 지상군 전진과 드랍 견제, 병력을 분산시킵니다. 전략의 승리네요.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 테크 우위를 살렸습니다.',
            ),
          ],
        ),

        // ── AWAY WIN 1: 드랍 깔끔하게 막고 자원 차이 ──
        ScriptBranch(
          id: 'away_resource_gap',
          description: '드랍을 막아내고 더블 자원 우위로 승리',
          baseProbability: 1.0,
          conditionStat: 'macro',
          conditionPriorBranchIds: ['drop_contained'],
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍을 막아낸 후 앞마당 자원이 풀가동됩니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4,
              awayResource: -300,
              altText: '{away} 선수 확장 자원 가동. 물량 차이가 벌어지기 시작합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리를 늘려주며 탱크와 골리앗을 동시에 생산합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6,
              awayResource: -750, // 팩토리 300x2 + 골리앗 150
              altText: '{away} 선수 팩토리 추가. 더블 자원으로 생산량이 두 배입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수도 앞마당을 확장하지만 자원 가동이 늦어 물량에서 밀립니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -400,
              altText: '{home} 선수 확장을 따라가지만 이미 물량 차이가 벌어졌습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 전진합니다. 물량이 압도적이네요.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -8,
              awayArmy: -2,
              altText: '{away} 선수 물량으로 밀어붙입니다! {home} 선수 수비가 어렵습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원의 물량이 모든 것을 해결합니다. 확장의 승리네요.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 자원 차이가 병력 차이로 이어졌습니다.',
            ),
          ],
        ),
      ],
    ),
  ],
);
