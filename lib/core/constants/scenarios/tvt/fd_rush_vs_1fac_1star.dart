part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 원팩원스타 (탱크 집중 vs 팩토리+스타포트)
// ----------------------------------------------------------
const _tvtFdRushVs1fac1star = ScenarioScript(
  id: 'tvt_fd_rush_vs_1fac_1star',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_1fac_1star'],
  description: 'FD 러쉬 vs 원팩원스타 테크 싸움',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -250, // 배럭 150 + 리파이너리 100
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설. 가스 채취 시작.',
          owner: LogOwner.away,
          awayResource: -250, // 배럭 150 + 리파이너리 100
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 머신샵을 부착합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 팩토리 300 + 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 팩토리에 머신샵. 빠른 시즈를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설 후 스타포트도 올립니다.',
          owner: LogOwner.away,
          awayResource: -550, // 팩토리 300 + 스타포트 250
          fixedCost: true,
          altText: '{away} 선수 팩토리와 스타포트. 원팩원스타 체제.',
        ),
        ScriptEvent(
          text: '양쪽 팩토리 빌드! 하지만 방향이 다릅니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산. 탱크에 올인합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산. 스타포트에서 레이스도 준비.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -325, // 벌처 75 + 레이스 250
          fixedCost: true,
          altText: '{away} 선수 벌처와 레이스. 기동력을 가져갑니다!',
        ),
      ],
    ),
    // Phase 1: 탱크 vs 벌처+레이스 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'tank_vs_mobility',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 시작. 탱크가 진가를 발휘할 준비.',
          owner: LogOwner.home,
          homeResource: -300, // 시즈모드 300
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수 시즈 모드 연구. 탱크 화력을 극대화.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 정찰. 상대 빠른 탱크를 확인합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 벌처 정찰. 상대가 탱크를 빨리 뽑고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스가 나왔습니다. 상대 본진을 정찰합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 레이스 1기 250
          fixedCost: true,
          altText: '{away} 선수 레이스 출격! 상대 진영을 확인!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 2기가 모입니다! 시즈 모드 완료!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 추가 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '탱크 화력 vs 벌처 기동력! 누가 주도권을 잡을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 견제와 대치 분기 (lines 22-34) - recovery 150/1
    ScriptPhase(
      name: 'harass_standoff',
      startLine: 22,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 벌처 견제 성공 -> 탱크 라인 약화
        ScriptBranch(
          id: 'vulture_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 마인을 깔고 우회 침투합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 벌처 우회! SCV를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV 피해! 탱크가 본진에 묶입니다!',
              owner: LogOwner.home,
              homeArmy: -1, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 추가 견제! 상대 일꾼을 괴롭힙니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
              altText: '{away} 선수 레이스 견제! 다방면에서 압박!',
            ),
            ScriptEvent(
              text: '지상과 공중 동시 견제! 시즈 라인이 전진하지 못합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 탱크 시즈로 벌처 차단
        ScriptBranch(
          id: 'tank_siege_blocks',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 접근하는 벌처를 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{home} 선수 시즈 포격! 벌처가 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 손실이 큽니다! 시즈 사거리 안에 들어갔어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 전진시킵니다. 시즈 거리 제기!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 라인을 밀어갑니다!',
            ),
            ScriptEvent(
              text: '탱크 시즈 화력 앞에 벌처가 접근하지 못합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 공방 (lines 36-44) - recovery 200/2
    ScriptPhase(
      name: 'mid_battle',
      startLine: 36,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터 건설. 탱크 뒤에서 확장.',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
          altText: '{home} 선수 앞마당 확장. 탱크 라인이 보호합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드랍십 생산. 탱크를 무력화하려 합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -200, // 드랍십 200
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 추가 생산. 물량이 쌓입니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
          fixedCost: true,
          altText: '{home} 선수 탱크가 계속 나옵니다. 더블 팩토리의 힘!',
        ),
        ScriptEvent(
          text: '{away} 선수 드랍십에 탱크를 싣고 뒤를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{away} 선수 탱크 드랍! 상대 후방 공격!',
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
    // Phase 3b: 중반 드랍 분기 (lines 44-48) - recovery 200/2
    ScriptPhase(
      name: 'mid_drop_check',
      startLine: 44,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 - 소규모 피해 후 회수
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 기지에서 SCV를 잡아냅니다! 빠르게 회수!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드랍 견제 성공! 일꾼 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 자잘한 피해가 쌓입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 마무리 드랍 - 유리한 쪽이 결판
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십과 레이스로 양면 공격!',
              owner: LogOwner.away,
              homeArmy: -3, homeResource: -15, favorsStat: 'strategy',
              altText: '{away} 선수 공중과 드랍 동시 공격!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비가 갈립니다! 탱크 라인이 분산됩니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 기동력으로 탱크를 무력화합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 드랍과 견제로 판을 뒤집습니다!',
            ),
          ],
        ),
        // 정면 탱크 돌파 - FD 측 공격
        ScriptBranch(
          id: 'frontal_push',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 물량이 압도적입니다! 정면 시즈 포격!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 탱크 라인! 상대 진영을 포격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 견제로도 막을 수 없는 물량입니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 빠른 팩토리의 탱크 집중이 빛을 발합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 물량으로 상대를 압살합니다!',
            ),
          ],
        ),
        // 필사적 역전 드랍 - 밀리는 쪽의 승부수
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.6,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 밀리고 있습니다! 승부수 드랍!',
              owner: LogOwner.away,
              favorsStat: 'sense',
              altText: '{away} 선수 올인 본진 드랍! 역전을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 탱크를 투하합니다! 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -2, favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '필사의 드랍! 피해가 크면 경기가 뒤집힐 수 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 (lines 50+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 50,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 물량이 압도적입니다! 정면 시즈 포격!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 탱크 라인! 상대 진영을 포격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 견제로도 막을 수 없는 물량입니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 빠른 팩토리의 탱크 집중이 빛을 발합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 물량으로 상대를 압살합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'fac_star_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍과 레이스 견제가 효과적입니다!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 다방면 견제! 상대가 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 분산됩니다! 수비에 쫓깁니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 기동력으로 탱크를 무력화합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 드랍과 견제로 판을 뒤집습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
