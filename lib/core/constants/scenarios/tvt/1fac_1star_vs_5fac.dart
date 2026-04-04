part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9. 원팩원스타 vs 5팩토리 (비대칭 공격 대결)
// ----------------------------------------------------------
const _tvt1fac1starVs5fac = ScenarioScript(
  id: 'tvt_1fac_1star_vs_5fac',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_5fac'],
  description: '원팩원스타 소수정예 vs 5팩토리 물량 올인',
  phases: [
    // Phase 0: 오프닝 (lines 1-13) - recovery 100/0
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
          text: '{home} 선수 가스를 올리고 팩토리를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 올리고 팩토리를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다. 빠른 테크 전환입니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트가 올라갑니다. 원팩원스타 운영입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2팩... 3팩!',
          owner: LogOwner.away,
          awayResource: -600, // 팩토리 2기 추가 (300x2)
          fixedCost: true,
          altText: '{away} 선수 팩토리가 계속 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 탱크 소수 생산. 시즈 모드 연구도 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -725, // 머신샵 100 + 시즈모드 300 + 탱크 250 + 벌처 75
          fixedCost: true,
          altText: '{home} 선수 벌처와 탱크가 나옵니다. 시즈 연구까지.',
        ),
        ScriptEvent(
          text: '{away} 선수 4팩, 5팩. 벌처 탱크 대량 생산 체제.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -750, // 팩토리 2기 추가 (300x2) + 벌처 2기 (75x2)
          fixedCost: true,
          altText: '{away} 선수 5팩토리. 물량으로 밀어붙이겠다는 의도.',
        ),
        ScriptEvent(
          text: '원팩원스타의 기술 vs 5팩의 물량! 극과극 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 원팩 선제공격 (lines 14-21) - recovery 150/1
    ScriptPhase(
      name: 'early_clash',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 탱크 소수정예로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75 추가
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 소수정예 출격! 5팩이 완성되기 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아직 물량이 덜 모였습니다! 팩토리에서 유닛이 나오는 중!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -325, // 탱크 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 상대 앞마당을 포격합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 시즈 포격! 상대 병력이 나오기 전에 밀어야!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 나오면서 마인을 깝니다! 시간을 끕니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'defense',
          altText: '{away} 선수 마인으로 시간 벌기! 물량이 모이길 기다립니다!',
        ),
        ScriptEvent(
          text: '5팩 물량이 도착하기 전에 끝내야 합니다! 시간이 없어요!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 선제공격 결과 - 분기 (lines 22-34) - recovery 200/2
    ScriptPhase(
      name: 'clash_result',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 분기 A: 원팩 선제 성공 - 드랍과 정면 돌파
        ScriptBranch(
          id: 'push_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 탱크로 상대 팩토리 라인을 향해 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 정면 돌파! 상대 생산시설을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리가 파괴됩니다! 생산력이 줄어들고 있어요!',
              owner: LogOwner.away,
              awayResource: -600, awayArmy: -2, // 팩토리 2기 파괴 (300x2)
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십으로 후방 기습! 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -300, favorsStat: 'strategy', // 팩토리 1기 추가 파괴
              altText: '{home} 선수 드랍십 출격! 상대 후방이 불바다!',
            ),
            ScriptEvent(
              text: '정면과 후방 동시 공격! 5팩의 생산력을 꺾었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 5팩 물량 도달 - 숫자로 압도
        ScriptBranch(
          id: 'mass_arrives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩토리에서 탱크 벌처가 쏟아집니다! 물량이 도착했습니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -575, // 탱크 250 + 벌처 75x2 + 골리앗 150 + 벌처 75 (5팩 생산)
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 물량 폭발! 5팩의 위력이 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 소수정예로는 숫자를 감당할 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 벌처 대군으로 역공! 숫자가 힘!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 물량 공세! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '5팩 물량 앞에 소수정예가 한계를 드러냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반전 (lines 35-54) - recovery 300/3
    ScriptPhase(
      name: 'late_fight',
      startLine: 35,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스를 생산합니다. 공중에서 견제를 노립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 레이스 250
          fixedCost: true,
          altText: '{home} 선수 레이스 출격. 드랍과 레이스 투트랙 견제.',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올립니다. 골리앗으로 대공을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{away} 선수 아머리가 올라갑니다. 골리앗을 생산합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 상대 확장기지를 노립니다!',
          owner: LogOwner.home,
          awayResource: -400, // 커맨드센터 파괴
          favorsStat: 'harass',
          altText: '{home} 선수 드랍 견제! 상대 SCV를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산을 시작합니다. 탱크 골리앗 조합으로 전환합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -300, // 골리앗 2기 (150x2)
          fixedCost: true,
          altText: '{away} 선수 골리앗이 합류합니다. 물량이 더 두터워집니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 물량으로 벌처를 대량 보냅니다! 마인으로 상대 이동을 봉쇄!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'macro',
          skipChance: 0.3,
          altText: '{away} 선수 벌처 물량! 마인 매설로 상대 기동을 제한합니다!',
        ),
        ScriptEvent(
          text: '기술 vs 물량! 결전의 시간이 다가옵니다!',
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
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-65) - recovery 300/3
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원. 마지막 승부.',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -650, // 탱크 250 + 골리앗 150 + 드랍십 200 + 벌처 75 (잔여 생산)
          fixedCost: true,
          altText: '{home} 선수 전 병력 결집. 결전입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 풀가동 물량. 탱크, 골리앗, 벌처 대군.',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -725, // 탱크 250 + 골리앗 150x2 + 벌처 75 (5팩 생산)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 총동원! 기술과 물량의 최종 대결!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격에 드랍 동시 투입! 상대 라인을 흔듭니다!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4, favorsStat: 'attack',
          altText: '{home} 선수 멀티포인트 공격! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 물량으로 밀어붙입니다! 골리앗 화력 집중!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 숫자의 힘!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 66+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 66,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 소수정예 타이밍 공격 성공! 5팩이 완성되기 전에 끝냅니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 드랍과 정면 동시 공격! 상대가 대응하지 못합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩 물량 폭발! 소수정예를 숫자로 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 타이밍을 버텨내고 팩토리 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
