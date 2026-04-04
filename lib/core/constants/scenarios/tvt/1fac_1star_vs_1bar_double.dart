part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs CC퍼스트
// ----------------------------------------------------------
const _tvt1fac1starVs1barDouble = ScenarioScript(
  id: 'tvt_1fac_1star_vs_cc_first',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_1bar_double'],
  description: '원팩 푸시 vs CC퍼스트 타이밍 공격',
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
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -400, // 커맨드센터 400
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올립니다. 공격적인 운영입니다.',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다. 원팩 푸시 운영입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에 이어 팩토리를 건설합니다. CC퍼스트의 안정적 테크 운영입니다.',
          owner: LogOwner.away,
          awayResource: -550, // 배럭 150 + 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{away} 선수 CC퍼스트에서 팩토리 건설. 안정적으로 테크를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{away} 선수 마인을 매설합니다. 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵을 부착합니다. 시즈 모드 연구를 시작합니다. 탱크 벌처를 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -725, // 머신샵 100 + 시즈모드 300 + 탱크 250 + 벌처 75
          fixedCost: true,
          altText: '{home} 선수 머신샵에서 시즈 연구를 시작합니다. 원팩에서 탱크 벌처가 나옵니다.',
        ),
        ScriptEvent(
          text: '안정적인 운영을 선택했습니다. 실력 싸움 가겠다는 거죠.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 자원이 들어옵니다. 마인으로 시간을 벌면서.',
          owner: LogOwner.away,
          altText: '{away} 선수 CC퍼스트 자원 가동. 수비하면서 물량을 쌓습니다.',
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
          text: '{home} 선수 추가 팩토리를 건설합니다. 생산량을 늘립니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리를 추가해서 물량을 쌓습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵을 부착합니다. 벌처 마인도 연구합니다.',
          owner: LogOwner.away,
          awayResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{away} 선수 머신샵에서 마인 연구를 시작합니다. 수비 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 벌처가 모이고 있습니다. 빠른 타이밍.',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -575, // 탱크 250 + 벌처 75x2 + 스타포트 250 (원팩원스타)
          fixedCost: true,
          altText: '{home} 선수 원팩 푸시. 탱크와 벌처가 모입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 장악합니다. 마인 매설.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75, // 벌처 75
          fixedCost: true,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트를 올립니다. 컨트롤타워도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트 250 + 컨트롤타워 100
          fixedCost: true,
          altText: '{away} 선수 스타포트 건설 후 컨트롤타워. 드랍십을 대비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이를 올립니다. 터렛도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -200, // 엔지니어링베이 125 + 터렛 75
          fixedCost: true,
          altText: '{away} 선수 엔지니어링 베이에 터렛 건설. 드랍에 대비합니다.',
        ),
        ScriptEvent(
          text: '스캔 한 방에 양 선수의 희비가 갈립니다.',
          owner: LogOwner.system,
          skipChance: 0.6,
        ),
        ScriptEvent(
          text: '{home} 선수 병력이 모이고 있습니다. 곧 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -325, // 탱크 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올립니다. 업그레이드를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{away} 선수 아머리에서 메카닉 업그레이드를 시작합니다.',
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
          text: '탱크 점사 컨트롤! 한 방 한 방이 치명적입니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 벌처가 전진합니다. 빠른 타이밍.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -325, // 탱크 250 + 벌처 75
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 원팩 푸시. 탱크 라인이 밀려갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 지대에서 수비 준비. 탱크도 배치.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500, // 시즈모드 300 + 탱크 250 (총 투자) → 탱크1+벌처1 = 250+75=325? 문맥상 탱크2=500
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보. 상대 탱크 위치를 먼저 파악합니다.',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'strategy+scout',
          altText: '{home} 선수 시즈 탱크 거리재기. 시야 싸움에서 앞서갑니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 보내 상대 병력을 확인합니다.',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 벌처 정찰. 상대 병력을 파악합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈 모드! 포격 사거리 안에 들어왔습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 시즈! 사거리 안에 들어왔습니다!',
        ),
        ScriptEvent(
          text: '원팩 푸시 vs CC퍼스트 수비! 공수 대결!',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '서로의 빌드를 다 알고 있습니다. 이제는 컨트롤 싸움이에요.',
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
          altText: '원거리 맵입니다. 멀티 확장이 안전하니 양측 자원이 풍부해지겠네요.',
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
              text: '{home} 선수 벌처로 마인 지대를 정찰합니다.',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 정찰. 마인 위치를 확인합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다.',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인 전진! 시즈 모드로 상대 건물까지 포격!',
              owner: LogOwner.home,
              awayResource: -400, // 앞마당 커맨드센터 피해
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 상대 앞마당을 위협합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 녹고 있습니다! 탱크 물량 차이가 납니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 보내 역습을 시도하지만 마인에 탱크가 터집니다!',
              owner: LogOwner.away,
              awayArmy: -2, // 벌처 1기 = 2sup
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 원팩 푸시 타이밍으로 수비 라인을 돌파합니다!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 탱크 시즈 포격! 상대 수비선을 무너뜨립니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마인에 탱크가 터집니다! 진격이 멈추는데요!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 탱크가 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실. 탱크도 피해를 입었습니다.',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 올립니다. 업그레이드를 준비합니다.',
              owner: LogOwner.away,
              awayResource: -150, // 아머리 150
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 CC퍼스트 자원 우위. 아머리에서 골리앗이 쌓입니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -300, // 골리앗 2기 (150x2)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 마인과 더블 자원으로 원팩 푸시를 버텨냅니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -4,
              decisive: true,
              altText: '{away} 선수 CC퍼스트 자원 가동! 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
