part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12. 투스타 레이스 미러 (공중전)
// ----------------------------------------------------------
const _tvt2starMirror = ScenarioScript(
  id: 'tvt_wraith_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_2star'],
  description: '투스타 레이스 클로킹 공중전',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-12) ── recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 가스를 먼저 올립니다.',
          owner: LogOwner.home,
          homeResource: -100, // 리파이너리 100
          fixedCost: true,
          altText: '{home} 선수 리파이너리부터 건설합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 리파이너리부터입니다.',
        ),
        ScriptEvent(
          text: '양 선수 모두 가스를 먼저 올렸습니다. 가스가 많이 드는 빌드인가봅니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '두 선수 모두 배럭보다 가스가 먼저입니다. 어떤 빌드가 나올지 지켜보죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
          altText: '{home} 선수 배럭을 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설합니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설합니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수 스타포트가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트가 두 개로 늘어납니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트 하나 더. 레이스 대량 생산 체제입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 두 번째입니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 스타포트가 두 개. 공중 전력 집중입니다.',
        ),
        ScriptEvent(
          text: '양 선수 모두 스타포트를 두 개씩 올렸습니다. 공중전이 펼쳐지겠습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '스타포트 두 개씩. 레이스 물량 싸움이 시작됩니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산합니다. 컨트롤타워도 올립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -350, // 레이스 250 + 컨트롤타워 100
          fixedCost: true,
          altText: '{home} 선수 레이스가 나옵니다. 컨트롤타워도 함께.',
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스를 생산합니다. 컨트롤타워를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -350,
          fixedCost: true,
          altText: '{away} 선수 레이스 출격. 컨트롤타워도 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 클로킹 300
          fixedCost: true,
          altText: '{home} 선수 클로킹 연구 시작. 타이밍이 관건입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 클로킹 연구를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수 클로킹 연구 시작. 누가 먼저 완성하느냐입니다.',
        ),
      ],
    ),
    // ── Phase 1: 레이스 공중전 + 스캔 준비 (lines 17-25) ── recovery 150/줄
    ScriptPhase(
      name: 'wraith_battle_setup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스를 추가 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 레이스 (250/2sup)
          fixedCost: true,
          altText: '{home} 선수 레이스가 계속 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스를 추가 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수 레이스도 계속 출격합니다.',
        ),
        ScriptEvent(
          text: '레이스 대 레이스, 공중전이 본격화됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '양쪽 레이스 물량이 늘어갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미를 건설합니다. 스캔을 준비하는 겁니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아카데미 150
          fixedCost: true,
          altText: '{home} 선수 아카데미가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아카데미 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수도 아카데미를 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 커맨드센터에 컴셋을 올립니다.',
          owner: LogOwner.home,
          homeResource: -50, // 컴셋 50
          fixedCost: true,
          altText: '{home} 선수 컴셋 완성. 스캔 준비 됐습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 컴셋을 올립니다.',
          owner: LogOwner.away,
          awayResource: -50,
          fixedCost: true,
          altText: '{away} 선수 컴셋. 스캔 체제 완성입니다.',
        ),
        ScriptEvent(
          text: '양 선수 모두 스캔 체제를 갖춰갑니다. 클로킹 타이밍과의 레이스입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '클로킹이 먼저냐, 스캔이 먼저냐. 타이밍 싸움입니다.',
        ),
      ],
    ),
    // ── Phase 2: 스캔 분기 (lines 26-38) ── recovery 150/줄
    // 분기 1: 양쪽 모두 스캔 준비 완료 → 비등한 공중전 → 메카닉 전환
    // 분기 2: 양쪽 스캔 있지만 한쪽 컨트롤/센스 우위 → 약간의 피해 차이
    // 분기 3: 한쪽이 스캔 실수/긴장으로 미달성 → 클로킹 레이스에 크게 밀림
    ScriptPhase(
      name: 'scan_war',
      startLine: 26,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // ── 분기 1: 양쪽 스캔 준비 완료, 비등한 교환 후 지상 전환 (가장 빈번)
        ScriptBranch(
          id: 'both_scan_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 즉시 스캔을 씁니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2, // 레이스 교환
              favorsStat: 'control',
              altText: '{home} 선수 클로킹 레이스가 들어가지만 상대도 스캔으로 바로 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 클로킹 레이스로 맞받습니다! 상대도 스캔!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 클로킹 레이스 투입. 양쪽 스캔으로 맞교환.',
            ),
            ScriptEvent(
              text: '양쪽 모두 스캔이 있으니 클로킹 레이스도 오래 못 버팁니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '스캔과 클로킹의 정면 대결. 소모전입니다.',
            ),
            ScriptEvent(
              text: '공중전이 소강상태로 접어듭니다. 레이스 피해는 비슷합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '비등한 공중전. 양쪽 지상 병력 체제로 전환합니다.',
            ),
          ],
        ),
        // ── 분기 2a: 홈 컨트롤/센스 우위, 약간의 레이스 교환 차이
        ScriptBranch(
          id: 'home_scan_edge',
          baseProbability: 0.7,
          conditionStat: 'sense',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 스캔 타이밍이 절묘합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, // 홈이 더 적은 피해
              favorsStat: 'sense',
              altText: '{home} 선수 클로킹 레이스와 스캔을 능숙하게 운용합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스캔으로 레이스를 탐지했지만, 대응이 한 박자 늦습니다.',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 스캔은 있지만 컨트롤에서 밀립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 수에서 앞서기 시작합니다. 공중 우위를 잡아갑니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 레이스 컨트롤 우위. 상대가 수세에 몰립니다.',
            ),
          ],
        ),
        // ── 분기 2b: 어웨이 컨트롤/센스 우위
        ScriptBranch(
          id: 'away_scan_edge',
          baseProbability: 0.7,
          conditionStat: 'sense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스 침투! 스캔 타이밍이 절묘합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'sense',
              altText: '{away} 선수 클로킹 레이스와 스캔을 능숙하게 운용합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔으로 탐지했지만 컨트롤에서 밀립니다.',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 스캔은 있지만 대응이 한 박자 늦습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 수에서 앞서기 시작합니다. 공중 우위입니다.',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 레이스 컨트롤 우위. 상대를 수세로 몰아넣습니다.',
            ),
          ],
        ),
        // ── 분기 3a: 홈이 스캔 실수/긴장으로 미달성 → 클로킹 레이스에 크게 밀림
        ScriptBranch(
          id: 'home_no_scan',
          baseProbability: 0.5,
          conditionStat: 'sense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스 침투! {home} 선수... 스캔이 없습니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -300, // SCV 대량 피해
              favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! {home} 선수 스캔을 못 달았습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 터렛을 급하게 올리지만... SCV가 이미 녹고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -4, homeResource: -275, // 터렛(75) + SCV 피해(200)
              altText: '{home} 선수 터렛 건설! 하지만 이미 일꾼 피해가 심각합니다.',
            ),
            ScriptEvent(
              text: '실수 하나가 이렇게 무섭습니다. 스캔 하나 차이로 흐름이 완전히 바뀝니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '긴장이 부른 실수. 클로킹 레이스에 무방비로 당했습니다.',
            ),
          ],
        ),
        // ── 분기 3b: 어웨이가 스캔 실수/긴장으로 미달성
        ScriptBranch(
          id: 'away_no_scan',
          baseProbability: 0.5,
          conditionStat: 'sense',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! {away} 선수... 스캔이 없습니다!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -300,
              favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스! {away} 선수 스캔을 못 달았습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 터렛을 급하게 올리지만... SCV가 이미 녹고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -4, awayResource: -275, // 터렛(75) + SCV 피해(200)
              altText: '{away} 선수 터렛 건설! 하지만 이미 일꾼 피해가 심각합니다.',
            ),
            ScriptEvent(
              text: '실수 하나가 이렇게 무섭습니다. 스캔 하나 차이로 흐름이 완전히 바뀝니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '긴장이 부른 실수. 클로킹 레이스에 무방비로 당했습니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 지상 전환 (lines 40-52) ── recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'ground_transition',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '레이스 교전이 소강상태로 접어들었습니다. 지상 병력 체제로 전환합니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '공중전이 끝나갑니다. 지상전으로 전환되는 흐름입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 세웁니다.',
          owner: LogOwner.home,
          homeResource: -75, // 터렛 75
          fixedCost: true,
          altText: '{home} 선수 터렛 건설. 클로킹 레이스 대비입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 터렛을 세웁니다.',
          owner: LogOwner.away,
          awayResource: -75,
          fixedCost: true,
          altText: '{away} 선수도 터렛. 잔여 레이스를 막습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{home} 선수 아머리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수 아머리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산합니다. 대공 방어를 갖춥니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -150, // 골리앗(150/2sup)
          fixedCost: true,
          altText: '{home} 선수 골리앗이 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 골리앗 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수 골리앗도 나옵니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵을 부착합니다.',
          owner: LogOwner.home,
          homeResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 머신샵 건설. 시즈 모드를 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵을 부착합니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수 머신샵 건설. 탱크 체제 진입입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 시즈탱크(250/2sup)
          fixedCost: true,
          altText: '{home} 선수 시즈탱크가 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈탱크 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수 시즈탱크도 나옵니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 시즈모드 300
          fixedCost: true,
          altText: '{home} 선수 시즈 모드 연구 시작.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수 시즈 모드 연구 시작.',
        ),
      ],
    ),
    // ── Phase 4: 탱크 푸시 체크 - 분기 (lines 55-65) ── recovery 200/줄
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 55,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 비등 - 양쪽 라인 유지 (가장 빈번)
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 생산합니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400, // 탱크(250) + 골리앗(150)
              fixedCost: true,
              altText: '{home} 선수 탱크 골리앗 조합. 라인을 잡아갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 탱크 골리앗 병력을 보강합니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 탱크 골리앗도 나옵니다.',
            ),
            ScriptEvent(
              text: '양쪽 시즈 라인이 대치합니다. 누가 먼저 움직이느냐가 관건이죠.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '시즈 라인 대치. 쉽게 움직일 수 없는 상황입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 남아 있어 정찰이 유리합니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'scout',
              skipChance: 0.4,
              altText: '{home} 선수 레이스로 상대 병력 배치를 확인합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 대공 사격! 레이스를 견제합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'defense',
              skipChance: 0.4,
              altText: '{away} 선수 골리앗으로 레이스를 쫓아냅니다!',
            ),
          ],
        ),
        // 홈 탱크 푸시 (레이스 우위 → 시야 확보 → 시즈 전진)
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 수 우위! 시야를 확보하고 탱크가 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400, // 탱크와 골리앗 추가
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '{home} 선수 공중 우위를 살려 시즈 라인을 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
              owner: LogOwner.home,
              awayArmy: -6,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 시즈탱크 화력! 상대 방어선이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 화력 집중! {away} 선수 탱크가 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 레이스와 탱크 합동 공격! 막을 수가 없습니다!',
            ),
          ],
        ),
        // 어웨이 탱크 푸시
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 수 우위! 시야를 확보하고 탱크가 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              altText: '{away} 선수 공중 우위를 살려 시즈 라인을 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
              owner: LogOwner.away,
              homeArmy: -6,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 시즈탱크 화력! 상대 방어선이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 화력 집중! {home} 선수 탱크가 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 레이스와 탱크 합동 공격! 막을 수가 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 확장 타이밍 - 분기 (lines 50-61) ── recovery 200/줄
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 68,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 동시 확장 (가장 빈번)
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당에 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장. 자원 보충이 필요합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당에 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장. 비슷한 타이밍입니다.',
            ),
            ScriptEvent(
              text: '양쪽 앞마당 확장이 올라갑니다. 자원 싸움이 본격화됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '양쪽 확장이 비슷한 타이밍. 균형 잡힌 전개입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 보강합니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 탱크 골리앗 물량이 늘어갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 탱크 골리앗 병력을 추가합니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 탱크 골리앗도 계속 나옵니다.',
            ),
          ],
        ),
        // 홈 빠른 확장 (자원 우위 노림)
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 빠른 확장. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 병력을 모아 압박합니다! 확장 타이밍을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400, // 탱크와 골리앗 추가
              fixedCost: true,
              altText: '{away} 선수 확장 대신 병력에 집중합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크로 앞마당을 지킵니다. 확장이 살아남느냐가 관건입니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 추가
              fixedCost: true,
              altText: '{home} 선수 시즈 모드로 수비. 확장 기지를 사수합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 이제 앞마당을 올립니다. 자원 차이가 벌어졌습니다.',
            ),
          ],
        ),
        // 어웨이 빠른 확장
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 빠른 확장. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 병력을 모아 압박합니다! 확장 타이밍을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 확장 대신 병력에 집중합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크로 앞마당을 지킵니다. 확장이 살아남느냐가 관건입니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 시즈 모드로 수비. 확장 기지를 사수합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수도 이제 앞마당을 올립니다. 자원 차이가 벌어졌습니다.',
            ),
          ],
        ),
        // 홈 확장 스킵 공격 (올인)
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 확장을 포기합니다! 병력에 올인!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
              awayResource: -400, // 어웨이 CC
              fixedCost: true,
              altText: '{home} 선수 확장 대신 탱크 골리앗을 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 타이밍에 공격을 감행합니다! {away} 선수 위험합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 확장 타이밍에 시즈 전진! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 총공격! 확장 기지를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 올인 공격! 확장 기지가 무너집니다!',
            ),
          ],
        ),
        // 어웨이 확장 스킵 공격 (올인)
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 확장을 포기합니다! 병력에 올인!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -650,
              homeResource: -400, // 홈 CC
              fixedCost: true,
              altText: '{away} 선수 확장 대신 탱크 골리앗을 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 타이밍에 공격을 감행합니다! {home} 선수 위험합니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 확장 타이밍에 시즈 전진! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 총공격! 확장 기지를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 올인 공격! 확장 기지가 무너집니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 6: 결전 + 맵 특성 (lines 62-75) ── recovery 200/줄
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 80,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗을 총동원합니다.',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
          fixedCost: true,
          altText: '{home} 선수 전 병력을 결집합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력을 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -650,
          fixedCost: true,
          altText: '{away} 선수 총력전 준비 완료.',
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞섭니다!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 탱크 교전 강화 (공격 능력치 유리)
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
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움입니다.',
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
    // ── Phase 7: 드랍 운영 - 분기 (lines 95-108) ── recovery 300/줄 (late)
    ScriptPhase(
      name: 'drop_phase',
      startLine: 95,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        // 게릴라 드랍 (가장 빈번, 자잘한 피해)
        ScriptBranch(
          id: 'guerrilla',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십을 생산합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -200, // 드랍십 200/2sup
              fixedCost: true,
              altText: '{home} 선수 드랍십이 나옵니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍십을 생산합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -200,
              fixedCost: true,
              altText: '양쪽 드랍십이 생산됩니다. 견제전이 시작됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              awayResource: -200, // SCV 견제 피해
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 확장 기지에 탱크를 내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 달려오지만, 이미 드랍십이 빠져나갑니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
              altText: '{away} 선수 대응이 조금 늦었습니다. 일꾼 피해를 입습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍으로 맞견제! 상대 일꾼을 노립니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍십 견제! {home} 선수 확장 기지가 흔들립니다!',
            ),
            ScriptEvent(
              text: '드랍 견제전이 치열합니다. 정면은 대치 상황입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '양쪽 드랍으로 시선을 끌면서 정면 거리재기가 계속됩니다.',
            ),
          ],
        ),
        // 마무리 드랍 (유리한 쪽이 드랍과 정면 동시)
        ScriptBranch(
          id: 'finishing',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대를 생산합니다. 마무리를 노립니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400, // 드랍십 2대
              awayArmy: 2, awayResource: -200, // 어웨이 드랍십 1대
              fixedCost: true,
              altText: '{home} 선수 드랍십 대량 생산. 마지막 승부를 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 본진과 확장에 동시 드랍! 정면 탱크도 전진!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -300,
              favorsStat: 'strategy',
              altText: '{home} 선수 세 방향 공격! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다방면 공격! {away} 선수 수비가 갈립니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 드랍과 정면 동시 공격! 승부를 결정짓습니다!',
            ),
          ],
        ),
        // 정면 돌파 (드랍 없이 탱크 물량 밀어붙이기)
        ScriptBranch(
          id: 'frontal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 보강합니다. {away} 선수도 물량 쌓기.',
              owner: LogOwner.system,
              homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
              awayArmy: 6, awayResource: -650,
              fixedCost: true,
              altText: '양쪽 최대 물량 생산. 정면 결전을 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 라인 전진! 상대 앞마당을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 앞마당 탱크를 깨뜨립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격으로 맞불! 치열한 포격전!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'defense',
              altText: '{away} 선수 탱크 집중 사격! 정면 포격전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '양쪽 탱크가 녹아내립니다. 누가 더 버티느냐의 싸움입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '포격전에서 탱크가 빠르게 소모됩니다. 집중력 싸움입니다.',
            ),
          ],
        ),
        // 역전 드랍 (불리한 쪽 승부수)
        ScriptBranch(
          id: 'desperate',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대를 생산합니다. 승부수를 던집니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400, // 드랍십 2대
              homeArmy: 2, homeResource: -200, // 홈 드랍십 1대
              fixedCost: true,
              altText: '{away} 선수 드랍십 대량 생산. 역전의 한 수를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.away,
              homeResource: -300, // 본진 시설 파괴
              favorsStat: 'harass',
              altText: '{away} 선수 본진 올인 드랍! 승부수입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 드랍 올인! 생산시설이 파괴되고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 수비에 병력을 돌립니다. 정면이 비어버립니다.',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 수비 병력 복귀. 정면 라인이 약해집니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 8: 최종 결전 판정 - 분기 (lines 115+) ── recovery 300/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 115,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 최종 포격전에서 승리! 상대 병력을 괴멸시킵니다!',
              altText: '{home} 선수 레이스와 탱크 조합으로 완벽한 마무리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 최종 포격전에서 승리! 상대 병력을 괴멸시킵니다!',
              altText: '{away} 선수 골리앗 대공과 탱크 화력으로 완벽한 마무리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
