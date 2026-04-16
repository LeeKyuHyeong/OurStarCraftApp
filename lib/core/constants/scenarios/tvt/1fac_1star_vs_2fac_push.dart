part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩원스타 vs 투팩푸쉬
// - 양쪽 모두 가스 먼저(리파이너리 → 배럭 → 팩토리) 빌드
// - 원팩원스타: 팩토리 + 머신샵 + 스타포트 → 탱크 1기 + 드랍십 운용
// - 투팩푸쉬: 팩토리 2개 + 머신샵 2개 → 탱크 2기 동시, 앞마당 없는 원베이스 올인
// - 투팩푸쉬 측은 배럭 플로팅(마린 1~2기 후 정찰용)
// ----------------------------------------------------------
const _tvt1fac1starVs2facPush = ScenarioScript(
  id: 'tvt_1fac_1star_vs_2fac_push',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '원팩원스타 vs 투팩푸쉬',
  phases: [
    // Phase 0: 오프닝 — 양쪽 가스 먼저
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 서플라이 이후 바로 가스부터 올립니다. 가스가 많이 드는 빌드로 선택할 듯 하네요.',
          owner: LogOwner.home,
          homeResource: -100,
          fixedCost: true,
          altText: '{home} 선수 가스 먼저 올립니다. 가스가 많이 필요한 빌드인가봅니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 먼저, 배럭보다 가스를 먼저 건설하네요.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 가스를 먼저 건설, 양측 다 앞마당을 먹는 빌드는 아니네요. 어떤 색다른 빌드가 선택될까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          homeResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수도 배럭 건설 시작.',
          owner: LogOwner.home,
          awayResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 완성 후 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 팩토리 건설 시작.',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 팩토리까지 건설. 공격적인 메카닉 병력 운용을 노리고 있습니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수 팩토리 두 개째 짓습니다. 병력없이 확장을 하면 메카닉 병력 차이로 피해를 주겠다는 거죠!',
        ),
      ],
    ),

    // Phase 1: 중반 테크 분화 — 원팩원스타(스타포트) vs 투팩푸쉬(두 번째 팩토리)
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 9,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 완성, 머신샵 부착하면서 스타포트도 건설합니다.',
          owner: LogOwner.home,
          homeResource: -350, // 머신샵 100 + 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 머신샵과 스타포트 동시에 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 첫 팩토리 완성, 머신샵 부착. 배럭은 띄워서 정찰용으로 돌립니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수 머신샵 붙이고 배럭은 플로팅합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 첫 벌처 생산, 상대방 앞마당 시도 및 병력 확인을 위해 나갑니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -75,
          fixedCost: true,
          altText: '{home} 선수 벌처 한 기 뽑아 바로 정찰 보냅니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착 완료 후 탱크 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -550,
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{away} 선수 탱크 생산 시작합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 완성, 마인 업그레이드 시작. 스타포트도 거의 완성입니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -250,
          fixedCost: true,
          altText: '{home} 선수 벌처 추가 생산 하며 마인 업그레이드 진행합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 팩토리 완성, 두 번째 머신샵 부착.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수 머신샵 두 개. 한번에 업그레이드를 진행하겠다는 거죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 완성, 컨트롤타워 부착하면서 상황을 봅니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 컨트롤타워 올립니다. 레이스와 드랍쉽 중 어떤 선택으로 준비해 왔을까요?',
        ),
      ],
    ),

    // Phase 2: 투팩푸쉬 3탱크 이후 조합 결정 — 아머리 여부 분기
    ScriptPhase(
      name: 'away_mech_decision',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        ScriptBranch(
          id: 'away_no_armory_vulture',
          description: '투팩푸쉬: 3탱크 이후 벌처만 추가 생산해 압박 (아머리 X)',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 속업과 마인업 한번에 진행합니다. 추가 병력의 합류 속도를 올리네요.',
              owner: LogOwner.away,
              awayResource: -300, // 시즈모드 300
              fixedCost: true,
              altText: '{away} 선수 벌처 스피드업, 마인 업그레이드 같이 진행합니다. 벌처 합류 속도를 올리는 선택이네요.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 3기 확보 후 마린, SCV 포함된 병력으로 진출합니다.',
              owner: LogOwner.away,
              awayArmy: 4,
              awayResource: -150, // 벌처 2기
              fixedCost: true,
              altText: '{away} 선수 3탱크, 마린, SCV로 상대방 압박 출발합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 모였다고 판단 진출하며 벌쳐를 전장에 추가로 합류시키려합니다.',
              owner: LogOwner.away,
              favorsStat: 'attack',
              altText: '{away} 선수 3탱크로 진격합니다. 타이밍을 앞당기겠다는 판단이네요.',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_armory_goliath',
          description: '투팩푸쉬: 3탱크 이후 아머리 건설, 골리앗 섞기',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 아머리 건설. 빠른 벌처 합류보다 골리앗을 섞고 혹시 모를 공중 유닛까지 대비하는 판단입니다.',
              owner: LogOwner.away,
              awayResource: -150, // 아머리
              fixedCost: true,
              altText: '{away} 선수 아머리까지 올립니다. 메카닉 조합이 완벽해집니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 생산 시작, 탱크,벌처,골리앗 정석 메카닉 조합이 됩니다.',
              owner: LogOwner.away,
              awayArmy: 4,
              awayResource: -200, // 골리앗 2기
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{away} 선수 골리앗 합류. 공중 대응까지 갖춘 완성형 조합입니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 3: 원팩원스타 대응 — 레이스 vs 드랍쉽 분기
    ScriptPhase(
      name: 'home_tech_decision',
      startLine: 20,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        ScriptBranch(
          id: 'home_wraith',
          description: '원팩원스타: 스타포트에서 레이스 생산 — 공중 견제 노림',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트에서 레이스를 꾸준히 뽑습니다. 레이스로 정찰도 되고 가능하면 견제까지 진행할 예정이죠.',
              owner: LogOwner.home,
              homeArmy: 10,
              homeResource: -600, // 레이스 4기 (150x4)
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{home} 선수 레이스 생산. 상대방의 조합을 흔들어놓을 생각입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 없으면 탱크를 괴롭혀 주겠다는 선택입니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_dropship',
          description: '원팩원스타: 드랍쉽 생산 — 본진 견제로 꾸역꾸역 버티기',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트에서 드랍쉽 생산, 견제 병력이 빠진 만큼 수비가 중요합니다.',
              owner: LogOwner.home,
              homeArmy: 8,
              homeResource: -700, // 드랍쉽 200 + 탱크 + 벌처 추가
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽 생산. 기동전으로 끌고 가려고 합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽이 나오자마자 4벌쳐를 태워서 상대방 본진으로 이동합니다.',
              owner: LogOwner.home,
              favorsStat: 'defense',
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),

    // Phase 4: 병력 구도 — 투팩 메카닉 수 우위 확정, home은 정면 회피
    //   정면 대결 시 탱크 1~3기 차이로 home 99% 병력 괴멸 → 둘 다 home 불리 구도
    //   home은 수비 라인으로 후퇴하며 레이스/드랍쉽 타이밍을 기다리는 것이 유일한 생존법
    ScriptPhase(
      name: 'army_positioning',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'away_mech_push_advance',
          description: '투팩 메카닉 병력 센터 장악, home은 본진 후퇴',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 뽑아놓은 메카닉 병력이 센터로 진출합니다. 팩토리 수 차이가 병력에 그대로 나타나네요.',
              owner: LogOwner.away,
              awayArmy: 2,
              favorsStat: 'attack',
              altText: '{away} 선수 메카닉 병력 수가 확실히 앞섭니다. 센터 장악 시도합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 대결은 불가능합니다. 견제로 큰 피해를 주면서 추가되는 병력으로 막아야됩니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 탱크 수 차이가 커서 정면 교전은 피합니다.',
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_mine_stall',
          description: 'home이 마인 깔면서 시간 벌기 — 병력은 소모되지만 진출 지연',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처로 주요 길목에 마인을 대량 매설합니다. 시간을 버는 선택이죠.',
              owner: LogOwner.home,
              favorsStat: 'defense',
              altText: '{home} 선수 마인으로 진격로를 좁혀놓습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 병력의 일부가 마인에 걸리지만 급하지 않게 직접 마인 제거하며 거리 좁혀옵니다.',
              owner: LogOwner.away,
              awayArmy: -2,
              homeArmy: -2,
              altText: '{away} 선수 마인 피해가 거의 없이 라인 전진합니다.',
            ),
          ],
        ),
      ],
    ),

    // Phase 5: 결전 — 메카닉 병력 차이 vs 레이스/드랍쉽 승리 경로
    ScriptPhase(
      name: 'timing_clash',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 기본: 메카닉 병력 차이로 투팩푸쉬가 이기는 일반적인 경우
        ScriptBranch(
          id: 'away_mech_advantage',
          description: '투팩푸쉬 메카닉 병력 차이로 승리 (아머리+골리앗 조합 시)',
          baseProbability: 1.5,
          conditionStat: 'attack',
          conditionPriorBranchIds: ['away_armory_goliath'],
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 시즈, 시즈 사거리에서 화력을 쏟아냅니다. 팩토리 수 차이가 그대로 병력 차이로 나타납니다.',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 메카닉 한방, 병력 차이가 큽니다.',
            ),
            ScriptEvent(
              text: '{home} 선수는 최대한 정면 싸움을 피했어야하는데요. 벌처 마인과 추가 병력으로 버텨보지만 밀립니다.',
              owner: LogOwner.home,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 건설하며 격차를 벌리려고 합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              altText: '{away} 선수 압박 이어가며 앞마당 확장 가져갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 진입, 생산시설까지 포격하며 경기를 끝냅니다!',
              owner: LogOwner.away,
              homeResource: -400,
              decisive: true,
              altText: '{away} 선수 메카닉 압박이 통했습니다! 경기 종료!',
            ),
          ],
        ),
        // 승리 경로 1: 레이스 선택 + 상대가 아머리를 올리지 않은 조합
        ScriptBranch(
          id: 'home_wraith_vs_no_armory',
          description: '원팩원스타: 레이스가 골리앗 없는 상대 메카닉을 공중에서 정리',
          baseProbability: 5.0,
          conditionStat: 'strategy',
          conditionPriorBranchIds: ['away_no_armory_vulture', 'home_wraith'],
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스가 상대 진출 탱크를 잡습니다. 골리앗이 없어 공중 대응이 안 됩니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home} 선수 레이스로 공중 장악을 노립니다, 상대는 대공 수단이 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스로 탱크를 한 기씩 점사, SCV 리페어를 진행하지만 SCV를 끊어주며 끈질기게 탱크를 노립니다.',
              owner: LogOwner.home,
              awayArmy: -4,
              awayResource: -300,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 레이스를 견제할 건물을 올리지만 이미 진출 병력이 무너진 뒤입니다.',
              owner: LogOwner.away,
              awayResource: -150,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 올리며 격차를 벌립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 아머리 없는 틈을 완벽하게 공략했습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 공중 장악 승리! 다양한 병력 조합이 통했습니다!',
            ),
          ],
        ),
        // 투팩 승리 경로 2: 아머리 없이도 벌처 물량으로 드랍쉽 견제 방어
        ScriptBranch(
          id: 'away_vulture_mass_vs_dropship',
          description: '투팩푸쉬: 아머리 X 상황에서 벌처 다수로 드랍쉽 타이밍 수비 후 진격',
          baseProbability: 1.0,
          conditionStat: 'control',
          conditionPriorBranchIds: ['away_no_armory_vulture', 'home_dropship'],
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽에서 벌처가 내리지만 {away} 선수 SCV 뭉치기와 추가 생산된 벌처로 피해없이 막습니다.',
              owner: LogOwner.home,
              homeArmy: -6,
              awayArmy: 2,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽 견제가 {away} 선수에게 피해를 주지 못하고 막힙니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 마인으로 라인 좁히며 탱크를 전진시킵니다.',
              owner: LogOwner.away,
              awayArmy: 2,
              awayResource: -300,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 메카닉 병력 그대로 본진까지 밀어버립니다! 견제 수비와 공격을 동시에 성공합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 벌처 수비 성공 후 진격!',
            ),
          ],
        ),
        // 승리 경로 2: 드랍쉽 견제로 피해 주고 꾸역꾸역 수비
        ScriptBranch(
          id: 'home_dropship_harass_wins',
          description: '원팩원스타: 드랍쉽 견제 피해 + 추가 병력으로 꾸역꾸역 수비',
          baseProbability: 3.0,
          conditionStat: 'harass',
          conditionPriorBranchIds: ['home_dropship'],
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽 출격, 4벌처 싣고 상대 본진에 투하! SCV 피해를 입힙니다!',
              owner: LogOwner.home,
              awayResource: -500,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽 견제 성공, 일꾼 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 진출 병력 일부를 본진 수비로 회군시킵니다. 진격 타이밍이 틀어집니다.',
              owner: LogOwner.away,
              awayArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽으로 시간 벌면서 탱크 추가 생산, 앞마당을 먹으며 방어 라인을 두껍게 깝니다.',
              owner: LogOwner.home,
              homeArmy: 4,
              homeResource: -500,
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{home} 선수 추가 병력 쌓아 라인을 유지합니다. 여유가 생겼는지 앞마당 건설 시작합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 진격이 막혔고, 상대방의 다양한 공격 루트를 계속해서 신경써야합니다.',
              owner: LogOwner.away,
              awayResource: -300,
            ),
            ScriptEvent(
              text: '{home} 선수 견제를 수비안할 수 없게 지독하게 괴롭혔네요!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 드랍쉽 운영 승리! 상대방의 진출 타이밍을 완전히 흔들어 버립니다!',
            ),
          ],
        ),
        // 승리 경로 3: 골리앗 상대로도 드랍쉽 운영으로 타이밍을 흔들어 수비 완성
        ScriptBranch(
          id: 'home_dropship_vs_goliath_wins',
          description: '원팩원스타: 골리앗 상대로도 드랍쉽 다중 견제로 진출 타이밍 지연 후 수비',
          baseProbability: 1.0,
          conditionStat: 'control',
          conditionPriorBranchIds: ['away_armory_goliath', 'home_dropship'],
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽으로 본진 견제, 상대방 병력이 나가있는 틈을 노렸습니다.',
              owner: LogOwner.home,
              awayResource: -400,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽 견제로 상대방 병력의 동선을 흔듭니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비에 병력 회군, 진격 타이밍이 크게 지연됩니다.',
              owner: LogOwner.away,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{away} 선수 드랍쉽 대응에 발목 잡히며 진출이 늦어집니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 버는 시간에 앞마당 가스까지 채우며 탱크, 벌처 추가 생산, 라인을 두껍게 깝니다.',
              owner: LogOwner.home,
              homeArmy: 4,
              homeResource: -500,
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 견제로 벌어낸 시간이 수비 라인 완성으로 이어졌습니다! 확장 차이가 나기 시작합니다.',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 드랍쉽 다중 견제 운영으로 공격적인 상대방의 빌드를 버텨냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
