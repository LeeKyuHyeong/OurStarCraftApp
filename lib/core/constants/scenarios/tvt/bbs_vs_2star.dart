part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS vs 투스타 레이스 (BBS 압박으로 스타포트 단계는 사실상 포기, 팩토리 후 수비 올인)
// 타이밍: BBS 첫 마린 2:10, 마린 3기 ~2:25 / 비BBS 빌드 첫 마린 2:23
//
// 분기 4개 (Phase 1 non-decisive, baseProbability 75/25 비율):
//   center_def_wins      : 센터 정찰 + SCV 컨트롤로 BBS 마린 줄임 → 수비 우세 (basePr 0.375)
//   center_atk_wins      : 센터 정찰이지만 BBS 컨트롤 우위 → SCV 괴멸, BBS 압박 (basePr 0.125)
//   base_bunker_success  : 본진 정찰 → 1vs3 교전 + 벙커 성공 → BBS 큰 피해 (basePr 0.375)
//   base_defended        : 본진 정찰이지만 SCV 컨트롤로 막음 → 수비 우세 (basePr 0.125)
//
// Phase 2: army state shortcut (totalArmy > 10, homeRatio < 0.15 → away / > 0.85 → home)
// ----------------------------------------------------------
const _tvtBbsVs2star = ScenarioScript(
  id: 'tvt_bbs_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_2star'],
  description: 'BBS vs 투스타 레이스',
  phases: [
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV 한 기를 센터로 보냅니다.',
          owner: LogOwner.home,
          altText: '{home} 선수 초반부터 SCV를 센터로 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 첫 배럭을 올립니다. 빠른 배럭입니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 센터 첫 배럭 건설. 공격적인 빌드입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 본진에 배럭을 올리고 곧바로 가스도 올립니다. 정찰 SCV도 함께 출발합니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수 배럭, 가스 순서대로 건설하면서 정찰을 보냅니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 두 번째 배럭. 뒤가 없는 빌드 선택입니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 센터 배럭 두 개! 초반 공격에 모든 걸 겁니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 추가 생산 하며 상대방 위치를 찾기 위해 배럭 건설한 SCV가 정찰을 나섭니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 마린을 모으며 상대방 위치를 찾기 위해 정찰을 진행합니다.',
        ),
      ],
    ),

    ScriptPhase(
      name: 'scout_and_engage',
      startLine: 9,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      branches: [
        ScriptBranch(
          id: 'center_def_wins',
          description: '센터 정찰 + SCV 컨트롤로 BBS 마린 줄임 → 수비 우세',
          baseProbability: 0.375,
          events: [
            ScriptEvent(
              text: '{away} 선수 정찰 SCV가 센터 쪽으로 향합니다. 분위기를 느꼈나요!',
              owner: LogOwner.away,
              altText: '{away} 선수 센터배럭을 의심했나요! SCV가 센터로 정찰을 갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 가스조절을 하며 팩토리를 건설합니다.',
              owner: LogOwner.away,
              awayArmy: 1,
              awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 팩토리 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 센터에서 배럭 두 기를 발견합니다! 본진 SCV 이끌고 수비해야죠!',
              owner: LogOwner.system,
              awayArmy: 1,
              awayResource: -50,
              fixedCost: true,
              altText: '{away} 선수 센터 배럭 두 기 확인! 막으면 이긴다는 마인드로 다수의 SCV를 끌고 나옵니다',
            ),
            ScriptEvent(
              text: '벌써 마린 수가 차이가 납니다! {home} 선수는 3기, {away} 선수는 1기!',
              owner: LogOwner.system,
              altText: '{home} 마린이 3기 모이는 사이 {away}는 1기뿐! 컨트롤로 극복할 수 있을까요?',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV로 BBS 마린을 감싸 잡아냅니다! 마린이 모이지 못하게 만들죠.',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'control',
              altText: '{away} 선수 SCV 컨트롤! {home} 선수의 마린이 모이질 못합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV도 잃고 마린도 부족합니다! 후퇴!',
              owner: LogOwner.home,
              homeResource: -150,
              awayArmy: -1,
              altText: '{home} 선수 마린이 다 잡히고 후퇴합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 완성, 벌처 생산 시작! 굉장한 수비력입니다.',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -75,
              fixedCost: true,
              altText: '{away} 선수 벌처가 나오면 {home} 선수는 마린만으로 막기는 힘들죠',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 벌처를 상대방 진영으로 보냅니다. 사실상 BBS가 막힌 순간 승기를 잡았죠.',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -75,
              fixedCost: true,
              altText: '{away} 선수 벌처와 추가 탱크로 마린밖에 못 뽑는 {home} 선수를 궁지로 몰아넣습니다.',
            ),
          ],
        ),

        ScriptBranch(
          id: 'center_atk_wins',
          description: '센터 정찰 했지만 BBS 컨트롤 우위 → SCV 괴멸, 마린 압박',
          baseProbability: 0.125,
          events: [
            ScriptEvent(
              text: '{away} 선수 정찰 SCV가 센터 쪽으로 향합니다. 확실하게 정찰하고 가려고 합니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 센터배럭을 의심했나요! SCV가 센터로 정찰을 갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 가스조절을 하며 팩토리를 건설합니다.',
              owner: LogOwner.away,
              awayArmy: 1,
              awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 팩토리 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 센터에서 배럭 두 기를 발견합니다! 본진 SCV 이끌고 수비해야죠!',
              owner: LogOwner.system,
              awayArmy: 1,
              awayResource: -50,
              fixedCost: true,
              altText: '{away} 선수 센터 배럭 두 기 확인! 막으면 이긴다는 마인드로 다수의 SCV를 끌고 나옵니다',
            ),
            ScriptEvent(
              text: '벌써 마린 수가 차이가 납니다! {home} 선수는 3기, {away} 선수는 1기!',
              owner: LogOwner.system,
              altText: '{home} 마린이 3기 모이는 사이 {away}는 1기뿐! 컨트롤로 극복할 수 있을까요?',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 끌고 센터로 진출. {home} 선수의 마린을 모이기전에 끊어줄 심산이죠.',
              owner: LogOwner.away,
              altText: '{away} 선수 SCV 부대를 끌고 나갑니다. 마린이 모이지 않게 해야합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 컨트롤로 수비측 SCV가 마린을 감싸지 못하게 합니다.',
              owner: LogOwner.home,
              awayResource: -300,
              awayArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 마린 컨트롤이 대단합니다. 수비측 SCV 피해가 큽니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 계속 쌓입니다! 수비측 본진까지 압박이 들어옵니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -150,
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 마린 추가 생산! 수비측 본진을 올라가려합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 벙커를 지으며 버텨보려하지만 상대방 마린이 너무 많습니다',
              owner: LogOwner.away,
              homeResource: -100,
              fixedCost: true,
              homeArmy: -2,
              awayArmy: -4,
              awayResource: -300,
              altText: '{away} 선수 본진 벙커로 수비 시도하지만 쉽지않습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린 투입! 본진까지 침투합니다.',
              owner: LogOwner.home,
              homeArmy: 5,
              homeResource: -250,
              fixedCost: true,
              awayArmy: -3,
              altText: '{home} 선수 초반 승부수가 통했습니다! 본진 초토화!',
            ),
          ],
        ),

        ScriptBranch(
          id: 'base_bunker_success',
          description: '본진 정찰 → 1vs3 교전 + 벙커 성공 + 마린 진입 → BBS 큰 피해',
          baseProbability: 0.375,
          events: [
            ScriptEvent(
              text: '{away} 선수 이상함을 느끼지 못하고 일반적인 정찰 루트를 선택합니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 정찰 SCV로 상대 본진을 찾으려고 합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 배럭 완성, 첫 마린 1기. 상대방의 공격적인 빌드를 아직은 전혀 눈치채지 못합니다.',
              owner: LogOwner.away,
              awayArmy: 1,
              awayResource: -50,
              fixedCost: true,
              altText: '{away} 선수 마린 1기로 상대방 정찰 SCV를 몰아내려합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 3기로 정찰을 끊으려던 {away} 선수의 마린을 덮칩니다.',
              owner: LogOwner.home,
              favorsStat: 'attack',
              altText: '{home} 선수 마린 숫자 차이로 {away} 선수 압박하기 시작합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 첫 마린 1기로 막아보지만 숫자 차이로 인해 3마린이 압도합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              homeArmy: -1,
              altText: '{away} 선수 겨우 1마린인데 {home} 선수는 마린이 3기, 화력 차이가 납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 {away} 선수의 배럭앞에 벙커 건설 시도!',
              owner: LogOwner.home,
              homeResource: -100,
              fixedCost: true,
              altText: '{home} 선수 벙커를 지으며 SCV 나오라고 압박합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 다 끌고 나와서 수비하려 합니다.',
              owner: LogOwner.away,
              altText: '{away} SCV 빨리 나와야죠!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커 완성, 마린 진입! 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -150,
              fixedCost: true,
              awayResource: -200,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 벙커 마린 화력! 수비측 배럭이 장악당합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린 투입! 본진을 직접 노립니다!',
              owner: LogOwner.home,
              homeArmy: 6,
              homeResource: -300,
              fixedCost: true,
              awayResource: -300,
              altText: '{home} 선수 벙커링 성공! 본진까지 진격합니다.',
            ),
          ],
        ),

        ScriptBranch(
          id: 'base_defended',
          description: '본진 정찰이지만 SCV 컨트롤로 벙커/마린 진입 막음 → 수비 우세',
          baseProbability: 0.125,
          events: [
            ScriptEvent(
              text: '{away} 선수 이상함을 느끼지 못하고 일반적인 정찰 루트를 선택합니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 정찰 SCV로 상대 본진을 찾으려고 합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 가스조절을 하며 팩토리를 건설합니다.',
              owner: LogOwner.away,
              awayArmy: 1,
              awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 팩토리 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 상대 본진을 원서치로 찾아냅니다. 배럭이 없는 걸 발견, SCV 다수를 수비적으로 배치합니다!',
              owner: LogOwner.system,
              awayResource: -50,
              fixedCost: true,
              altText: '{away} 선수 원서치에 성공합니다. 배럭이 없음에 이상함을 느끼고 다수의 SCV를 수비대기 시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 3기와 SCV가 수비 진영 도착 직전입니다!',
              owner: LogOwner.home,
              favorsStat: 'attack',
              altText: '{home} 선수 마린과 SCV 상대방을 압박하기 위해 이동합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 첫 마린과 SCV를 동원해 시간을 법니다!',
              owner: LogOwner.away,
              awayArmy: 1,
              awayResource: -50,
              fixedCost: true,
              homeArmy: -1,
              altText: '{away} 선수 마린 추가 생산하면서 SCV 뭉치기로 막아봅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 {away} 선수의 배럭 앞에 벙커 건설 시도!',
              owner: LogOwner.home,
              homeResource: -100,
              fixedCost: true,
              altText: '{home} 선수 벙커를 지으며 압박 진행합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 컨트롤! 벙커 짓는 SCV 잡고, 진입하려는 마린도 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 SCV 컨트롤이 미쳤는데요, 벙커 진입을 막습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 작은 피해로 막아냅니다! 팩토리에서 벌처와 시즈 탱크가 나온 순간 {home} 선수는 막기 힘들죠!',
              owner: LogOwner.away,
              awayArmy: 12,
              awayResource: -625,
              fixedCost: true,
              altText: '{away} 선수 수비력이 빛난 순간입니다! {home} 선수의 마린으로 메카닉병력을 막기는 쉽지 않죠.',
            ),
          ],
        ),
      ],
    ),

    ScriptPhase(
      name: 'finisher',
      startLine: 17,
      recoveryResourcePerLine: 0,
      recoveryArmyPerLine: 0,
      branches: [
        ScriptBranch(
          id: 'finisher_home',
          description: 'BBS 측 마무리',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 초반 전략이 통했습니다! {away} 선수 마우스를 놓습니다.',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 마무리! 경기 종료입니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'finisher_away',
          description: '수비 측 마무리',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 수비력이 돋보이는 경기입니다! {home} 선수 키보드에서 손을 뗍니다.',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 마무리! 경기 종료입니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
