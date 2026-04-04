part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5팩 타이밍 vs 원팩 확장
// ----------------------------------------------------------
const _tvt5facVs1facDouble = ScenarioScript(
  id: 'tvt_5fac_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '5팩 타이밍 vs 원팩 확장 공수 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16) - recovery 100/0
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
          text: '{home} 선수 팩토리를 빠르게 증설합니다. 3개째.',
          owner: LogOwner.home,
          homeResource: -900, // 팩토리x3(900)
          fixedCost: true,
          altText: '{home} 선수 팩토리가 빠르게 늘어납니다. 타이밍을 노리나요.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 앞마당 확장도 가져갑니다.',
          owner: LogOwner.away,
          awayResource: -700, // 팩토리(300) + CC(400)
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다, 확장도 같이.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 벌처 1기 (2sup)
          awayResource: -75, // 벌처(75)
          fixedCost: true,
          altText: '{away} 선수 마인 매설, 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착, 시즈 모드 연구 시작, 팩토리 5개 체제, 탱크 벌처 대량 생산.',
          owner: LogOwner.home,
          homeArmy: 4, // 벌처2(4sup)
          homeResource: -850, // 팩토리2(600) + 머신샵(100) + 벌처2(150)
          fixedCost: true,
          altText: '{home} 선수 머신샵에서 시즈 연구. 5팩토리 풀가동. 병력이 쏟아져 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드센터를 올립니다. 마인으로 시간을 벌면서.',
          owner: LogOwner.away,
          awayResource: -400, // CC(400) 트리플
          fixedCost: true,
          altText: '{away} 선수 트리플 확장. 자원을 최대한 끌어올립니다.',
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
          text: '{home} 선수 머신샵 부착, 시즈 모드 연구.',
          owner: LogOwner.home,
          homeResource: -300, // 시즈모드(300)
          fixedCost: true,
          altText: '{home} 선수 머신샵에서 시즈 연구, 탱크가 본격 가동.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착, 벌처 마인도 연구합니다.',
          owner: LogOwner.away,
          awayResource: -100, // 머신샵(100)
          fixedCost: true,
          altText: '{away} 선수 머신샵에서 마인 연구, 수비 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산이 시작됩니다, 팩토리 5개에서 쏟아집니다.',
          owner: LogOwner.home,
          homeArmy: 6, // 탱크 3기 (2sup x3)
          homeResource: -750, // 탱크3(750)
          fixedCost: true,
          altText: '{home} 선수 5팩 풀가동, 탱크가 쏟아져 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 장악합니다, 마인 매설.',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설, 컨트롤타워 올립니다.',
          owner: LogOwner.away,
          awayResource: -350, // 스타포트(250) + 컨트롤타워(100)
          fixedCost: true,
          altText: '{away} 선수 스타포트 건설 후 컨트롤타워, 드랍십을 대비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설, 터렛을 올립니다.',
          owner: LogOwner.away,
          awayResource: -200, // 엔지니어링베이(125) + 터렛(75)
          fixedCost: true,
          altText: '{away} 선수 엔지니어링 베이에 터렛. 드랍 대비.',
        ),
        ScriptEvent(
          text: '{home} 선수 병력이 모이고 있습니다, 곧 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 탱크 2기 (2sup x2)
          homeResource: -500, // 탱크2(500)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설, 업그레이드를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리(150)
          fixedCost: true,
          altText: '{away} 선수 아머리에서 메카닉 업그레이드.',
        ),
      ],
    ),
    // Phase 2: 5팩 타이밍 (lines 26-30) - recovery 200/2
    ScriptPhase(
      name: 'timing_push',
      startLine: 26,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 5팩토리 물량이 전진합니다. 탱크 8기.',
          owner: LogOwner.home,
          homeArmy: 4, // 탱크 2기 추가 (2sup x2)
          homeResource: -500, // 탱크2(500)
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 대규모 전진. 탱크 라인이 밀려갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 지대에서 수비 준비. 탱크도 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 4, // 탱크 2기 (2sup x2)
          awayResource: -500, // 탱크2(500)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보. 상대 탱크 위치를 먼저 파악합니다.',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'strategy+scout',
          altText: '{home} 선수 시즈 탱크 거리재기, 시야 싸움에서 앞서갑니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 보내 상대 병력을 확인합니다.',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 벌처 정찰, 상대 병력을 파악합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈 모드. 포격 사거리 안에 들어왔습니다.',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 탱크 시즈 모드 전환. 사거리 안에 들어왔습니다.',
        ),
        ScriptEvent(
          text: '5팩 타이밍 vs 원팩 확장 수비. 공수 대결의 시작.',
          owner: LogOwner.system,
          skipChance: 0.2,
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
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다, 지형 싸움.',
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
    // Phase 3: 교전 - 분기 (lines 32+) - recovery 300/3
    ScriptPhase(
      name: 'clash',
      startLine: 32,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'timing_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처로 마인 지대를 정찰합니다.',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 정찰, 마인 위치를 확인합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다.',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인 전진! 시즈 모드로 상대 건물까지 포격!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
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
              awayArmy: -2, // 벌처 1기 손실 (2sup)
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 물량으로 마인 라인을 돌파합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 탱크 시즈 포격! 상대 수비선을 무너뜨립니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'mine_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마인에 {home} 탱크가 걸립니다! 진격이 멈추는데요!',
              owner: LogOwner.away,
              homeArmy: -4, // 탱크 2기 손실 (2sup x2)
              favorsStat: 'defense',
              altText: '{away} 선수 마인 매설 성공! {home} 탱크가 큰 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실이 큽니다! 탱크도 피해를 입었습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리 건설, 골리앗을 준비합니다.',
              owner: LogOwner.away,
              awayResource: -150, // 아머리(150)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 확장 자원 우위. 탱크 골리앗이 쌓입니다.',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크1 + 골리앗1 (2sup x2)
              awayResource: -400, // 탱크(250) + 골리앗(150)
              fixedCost: true,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 마인과 확장 자원으로 5팩 타이밍을 버텨냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -3,
              decisive: true,
              altText: '{away} 선수 트리플 자원 가동! 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
