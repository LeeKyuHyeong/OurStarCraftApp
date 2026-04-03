part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs 원팩 확장
// ----------------------------------------------------------
const _tvt1fac1starVs1facDouble = ScenarioScript(
  id: 'tvt_1fac_1star_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '원팩 푸시 vs 원팩 확장 같은 팩토리 다른 전략',
  phases: [
    // Phase 0: 오프닝 (lines 1-16) - recovery 100/0
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
          text: '{home} 선수 팩토리 건설! 빠른 메카닉을 노립니다!',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home}, 팩토리가 올라갑니다! 원팩 푸시!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 하지만 앞마당 확장도 같이!',
          owner: LogOwner.away,
          awayResource: -800, // 가스 100 + 팩토리 300 + 커맨드센터 400
          fixedCost: true,
          altText: '{away}, 팩토리 후 확장! 원팩 확장입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{away}, 마인 매설! 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구! 탱크 벌처 생산에 집중!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -725, // 머신샵 100 + 시즈모드 300 + 탱크 250 + 벌처 75
          fixedCost: true,
          altText: '{home}, 머신샵에서 시즈 연구! 빠른 탱크를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 자원이 들어옵니다! 마인으로 시간을 벌면서!',
          owner: LogOwner.away,
          altText: '{away}, 원팩 확장 자원 가동! 수비하면서 물량을 쌓습니다!',
        ),
      ],
    ),
    // Phase 1: 중반 준비 (lines 17-24) - recovery 150/1
    ScriptPhase(
      name: 'mid_preparation',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설! 병력 생산을 늘립니다!',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{home}, 팩토리를 추가! 물량 차이를 만들겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착! 벌처 마인도 연구합니다!',
          owner: LogOwner.away,
          awayResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{away}, 머신샵에서 마인 연구! 수비 준비!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 벌처가 모이고 있습니다! 빠른 타이밍!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -575, // 탱크 250 + 벌처 75x2 + 스타포트 250 (원팩원스타)
          fixedCost: true,
          altText: '{home} 선수 원팩 푸시! 탱크와 벌처가 모입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 장악합니다! 마인 매설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75, // 벌처 75
          fixedCost: true,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 컨트롤타워 올립니다!',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
          altText: '{away}, 스타포트 건설 후 컨트롤타워! 드랍십을 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 터렛을 올립니다!',
          owner: LogOwner.away,
          awayResource: -200, // 엔지니어링베이 125 + 터렛 75
          fixedCost: true,
          altText: '{away}, 엔지니어링 베이에 터렛! 드랍 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 병력이 모이고 있습니다! 곧 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -325, // 탱크 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{away}, 아머리에서 메카닉 업그레이드!',
        ),
      ],
    ),
    // Phase 2: 원팩 푸시 타이밍 (lines 26-30) - recovery 200/2
    ScriptPhase(
      name: 'timing_push',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 탱크 벌처가 전진합니다! 빠른 타이밍!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -325, // 탱크 250 + 벌처 75
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 원팩 푸시! 탱크 라인이 밀려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 지대에서 수비 준비! 탱크도 배치!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -550, // 시즈모드 300 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보! 상대 탱크 위치를 먼저 파악합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'strategy+scout',
          altText: '{home}, 시즈 탱크 거리재기! 시야 싸움에서 앞서갑니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 보내 상대 병력을 확인합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 벌처 정찰! 상대 병력을 파악합니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 포격 사거리 안에 들어왔습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 시즈! 사거리 안에 들어왔습니다!',
        ),
        ScriptEvent(
          text: '원팩 푸시 vs 원팩 확장! 같은 빌드 다른 선택의 대결!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: 교전 - 분기 (lines 32+) - recovery 200/2
    ScriptPhase(
      name: 'clash',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'timing_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 마인 지대를 정찰합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 정찰! 마인 위치를 확인합니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크 라인 전진! 시즈 모드로 상대 건물까지 포격!',
              owner: LogOwner.home,
              awayResource: -400, // 커맨드센터 파괴
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 상대 앞마당을 위협합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 녹고 있습니다! 탱크 물량 차이가 납니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처를 보내 역습을 시도하지만 마인에 벌처가 터집니다!',
              owner: LogOwner.away,
              awayArmy: -2, // 벌처 1기 = 2sup
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 원팩 푸시 타이밍으로 확장 수비를 뚫습니다!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 탱크 시즈 포격! 상대 수비선을 무너뜨립니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'expand_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인에 벌처가 터집니다! 진격이 멈추는데요!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 벌처가 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실! 탱크도 피해를 입었습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리 건설! 골리앗을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -150, // 아머리 150
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away}, 확장 자원 우위! 탱크 골리앗이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -300, // 골리앗 2기 (150x2)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 마인과 확장 자원으로 원팩 푸시를 버텨냅니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -4,
              decisive: true,
              altText: '{away} 선수 확장 자원 가동! 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
