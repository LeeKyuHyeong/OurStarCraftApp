part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩 푸시 vs 레이스 클로킹
// ----------------------------------------------------------
const _tvt1fac1starVs2star = ScenarioScript(
  id: 'tvt_1fac_1star_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_2star'],
  description: '원팩 푸시 vs 레이스 클로킹 타이밍 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
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
          text: '{home} 선수 팩토리를 올립니다. 공격적인 운영입니다.',
          owner: LogOwner.home,
          homeResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다. 공격적인 운영이네요.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올립니다. 스타포트를 노립니다.',
          owner: LogOwner.away,
          awayResource: -400, // 가스 100 + 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산을 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75
          fixedCost: true,
          altText: '{home} 선수 벌처가 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트를 올립니다. 공중 유닛을 노립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -325, // 스타포트 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '빠른 지상 타이밍 vs 공중 테크! 지상과 공중의 대결!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 준비 (lines 12-22) - recovery 150/1
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 팩토리를 건설하고 머신샵을 부착합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -650, // 머신샵 100 + 시즈모드 300 + 탱크 250
          fixedCost: true,
          altText: '{home} 선수 팩토리에 머신샵을 추가합니다. 탱크를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스를 생산합니다. 클로킹 연구도 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550, // 컨트롤타워 100 + 클로킹 300 + 레이스 250 (2sup → 2star 빌드)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다. 아머리도 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 스타포트 250 + 아머리 150 (원팩원스타)
          fixedCost: true,
          altText: '{home} 선수 스타포트와 아머리를 동시에 올립니다. 대공 준비.',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 레이스로 견제 시작! SCV를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'harass',
          altText: '{away} 선수 클로킹 레이스 출격! SCV 사냥 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 올립니다. 터렛으로 대공 준비.',
          owner: LogOwner.home,
          homeResource: -275, // 엔지니어링베이 125 + 터렛 75x2
          fixedCost: true,
          altText: '{home} 선수 터렛을 올립니다. 대공 수비를 갖춥니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스를 추가로 생산합니다. 견제를 이어갑니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 레이스 250
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 지상 우위를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 상대 건설 SCV를 괴롭힙니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗을 생산합니다. 대공 화력을 갖춥니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -150, // 골리앗 150
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '지상 vs 공중! 먼저 주도권을 잡는 쪽이 유리합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+) - recovery 200/2
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_ground_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗 대공 사격! 하늘의 위협을 격추합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 골리앗 화력! 공중 유닛이 떨어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 녹았습니다! 견제 효과가 줄어듭니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 지상 병력으로 전진 준비! 탱크 시즈!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 250 추가
              fixedCost: true,
              favorsStat: 'attack',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_air_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스 견제가 성공합니다! SCV 피해!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 견제! 스캔 없는 곳을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 대공이 늦었습니다! SCV가 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 시야 장악! 상대 움직임을 파악합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250, // 레이스 250 추가
              fixedCost: true,
              favorsStat: 'scout',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 교전 (lines 32-38) - recovery 200/2
    ScriptPhase(
      name: 'tank_battle',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리에서 탱크를 뽑기 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 탱크 250
          fixedCost: true,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십을 생산합니다. 컨트롤타워에서 생산.',
          owner: LogOwner.home,
          homeResource: -200, // 드랍십 200 (스타포트는 이미 있음 - 원팩원스타)
          fixedCost: true,
          altText: '{home} 선수 컨트롤타워 완성. 드랍십 생산. 기동전을 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 정찰하면서 상대 움직임을 파악합니다.',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.3,
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
    // Phase 4: 시즈 주도권 체크 - 중반 decisive (lines 40+) - recovery 200/2
    ScriptPhase(
      name: 'siege_dominance',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'siege_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양쪽 탱크 라인이 비등합니다. 쉽게 밀리지 않는 구도.',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 상대 움직임을 계속 파악합니다.',
              owner: LogOwner.away,
              favorsStat: 'scout',
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_siege_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈 화력이 앞섭니다! 상대 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 포격! 지상 화력 차이가 결정적입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스만으로는 지상을 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 지상 화력으로 상대 생산시설을 밀어냅니다!',
              owner: LogOwner.home,
              awayResource: -300,
              decisive: true,
              altText: '{home} 선수 시즈 푸시 성공! 공중 빌드의 약점을 찌릅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wraith_dominance',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 견제가 계속됩니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! 스캔이 모자랍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 자원이 빠지면서 병력 보충이 느려집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 견제로 상대를 무너뜨립니다!',
              owner: LogOwner.away,
              homeResource: -300,
              decisive: true,
              altText: '{away} 선수 공중 견제 압도! 지상 공격이 힘을 못 씁니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 드랍 운영 (lines 46+) - recovery 300/3
    ScriptPhase(
      name: 'drop_phase',
      startLine: 46,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        // 게릴라 드랍 (가장 흔함)
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격. 상대 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크 투하! SCV를 잡고 바로 회수!',
              owner: LogOwner.home,
              awayResource: -200, favorsStat: 'harass',
              altText: '{home} 선수 게릴라 드랍! SCV 피해를 주고 빠집니다!',
            ),
          ],
        ),
        // 어웨이 게릴라 드랍 (레이스와 드랍)
        ScriptBranch(
          id: 'away_guerrilla_drop',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 엄호 아래 드랍십을 보냅니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 레이스와 드랍십 동시 견제. 멀티포인트.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍 성공! SCV를 잡고 빠집니다!',
              owner: LogOwner.away,
              homeResource: -200, favorsStat: 'harass',
            ),
          ],
        ),
        // 마무리 드랍 (홈 유리 시)
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 본진과 확장 동시 투하!',
              owner: LogOwner.home,
              awayResource: -400, favorsStat: 'strategy',
              altText: '{home} 선수 마무리 드랍! 정면과 후방 동시 공격!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 드랍십을 잡으려 하지만 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격으로 끝냅니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 마무리 공격 성공! 상대가 대응하지 못합니다!',
            ),
          ],
        ),
        // 역전 드랍 (어웨이 레이스 올인)
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.6,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 지상에서 밀리고 있습니다! 승부수를 던집니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스와 드랍십 총동원! 상대 본진 올인 기습!',
              owner: LogOwner.away,
              homeResource: -300, favorsStat: 'harass',
              altText: '{away} 선수 올인 견제! 상대 본진이 불바다!',
            ),
            ScriptEvent(
              text: '{away} 선수 역전 견제 성공! 생산시설이 무너집니다!',
              owner: LogOwner.away,
              homeResource: -300,
              decisive: true,
              altText: '{away} 선수 승부수가 통합니다! 역전!',
            ),
          ],
        ),
      ],
    ),
    // Phase 6: 최종 결전 - 분기 (lines 52+) - recovery 300/3
    ScriptPhase(
      name: 'timing_clash',
      startLine: 52,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상 화력으로 공중 빌드를 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 타이밍 공격 성공! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 견제로 자원 우위! 병력이 더 빠르게 모입니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 역습! 견제로 벌어진 자원 차이!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 레이스로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -300, // 팩토리 파괴
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 견제로 상대를 흔들어 놓고 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 공중 견제 성공! 지상 타이밍을 꺾습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
