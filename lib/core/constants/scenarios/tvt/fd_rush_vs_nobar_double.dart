part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 노배럭더블 (탱크 푸시 vs CC 퍼스트)
// ----------------------------------------------------------
const _tvtFdRushVsNobarDouble = ScenarioScript(
  id: 'tvt_fd_rush_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_nobar_double'],
  description: 'FD 러쉬 vs 노배럭더블 초반 취약점',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 건설합니다.',
          owner: LogOwner.away,
          awayResource: -400, // CC 400
          fixedCost: true,
          altText: '{away} 선수 커맨드센터 퍼스트. 노배럭더블입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취, 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리 100 + 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 팩토리 건설. 빠른 메카닉을 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭 건설. 마린 생산 시작.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착. 시즈 탱크를 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -350, // 머신샵 100 + 탱크 250
          fixedCost: true,
          altText: '{home} 선수 머신샵 부착. 기갑 유닛이 곧 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 앞마당에 세웁니다. 방어 준비.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -150, // 벙커 100 + 마린 1기 50
          fixedCost: true,
        ),
        ScriptEvent(
          text: '노배럭더블이 위험합니다! 기갑 유닛이 빨리 도착하면 큰일!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 탱크 도착 (lines 12-18) - recovery 150/1
    ScriptPhase(
      name: 'tank_arrives',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 1기 생산 완료. 시즈 모드 연구.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 탱크 250 + 시즈모드 300
          fixedCost: true,
          altText: '{home} 선수 탱크가 나왔습니다! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 3기와 벙커로 수비합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -100, // 마린 2기 (50x2)
          fixedCost: true,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크를 앞세우고 전진합니다! 앞마당을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 전진! 노배럭더블의 약점을 찌릅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 벙커 수리에 투입합니다.',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'defense',
          altText: '{away} 선수 SCV 수리! 벙커를 지켜야 합니다!',
        ),
        ScriptEvent(
          text: '노배럭더블의 초반 취약점! 기갑 유닛이 도착했습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 초반 공방 분기 (lines 20-30) - recovery 150/1
    ScriptPhase(
      name: 'early_siege',
      startLine: 20,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 탱크 시즈가 큰 피해
        ScriptBranch(
          id: 'siege_devastates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 벙커가 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 벙커가 버티지 못합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 벙커 밖에서 녹고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 SCV도 공격합니다! 상대 일꾼 피해가 큽니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 SCV까지 잡아냅니다! 일꾼 피해!',
            ),
            ScriptEvent(
              text: '노배럭더블이 큰 피해를 입었습니다! 확장 투자가 수포로!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 벙커 수비 성공
        ScriptBranch(
          id: 'bunker_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커와 마린으로 포격을 상대합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 벙커 수비! SCV 수리가 이어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 1기로는 벙커를 못 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 건설. 자체 탱크를 빠르게 올립니다.',
              owner: LogOwner.away,
              awayResource: -300, // 팩토리 300
              fixedCost: true,
              altText: '{away} 선수 팩토리 건설. 탱크로 대응 준비.',
            ),
            ScriptEvent(
              text: '벙커 수비 성공! 노배럭더블이 살아남았습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 32-42) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리. 탱크 더블 생산.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 팩토리 300 + 탱크 250
          fixedCost: true,
          altText: '{home} 선수 투팩 체제! 탱크를 밀어냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 더블 자원이 풀가동됩니다.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 생산. 빠르게 따라잡습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550, // 머신샵 100 + 탱크 250 + 시즈모드 연구 비용은 이미 포함하므로 머신샵+탱크 기준 = 머신샵 별도 이미 팩토리에서 → 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터 건설.',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 자원 우위로 탱크 물량을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500, // 탱크 2기 (250x2)
          fixedCost: true,
          favorsStat: 'macro',
          altText: '{away} 선수 자원 차이. 병력이 빠르게 늡니다.',
        ),
        ScriptEvent(
          text: '노배럭더블의 자원 우위가 나타나기 시작합니다.',
          owner: LogOwner.system,
          skipChance: 0.25,
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
    // Phase 3b: 중반 물량 분기 (lines 42-46) - recovery 200/2
    ScriptPhase(
      name: 'mid_mass_check',
      startLine: 42,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 - 소규모 피해
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크를 싣고 상대 본진으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에서 SCV를 잡아냅니다! 빠르게 회수!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드랍 견제 성공! 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '노배럭더블의 자원으로 드랍 견제가 가능합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 마무리 물량 공세 - 더블 자원 활용
        ScriptBranch(
          id: 'finishing_mass',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 더블 자원으로 탱크 골리앗 대군이 완성됩니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -3, favorsStat: 'macro',
              altText: '{away} 선수 물량 공세! 더블 자원의 힘!',
            ),
            ScriptEvent(
              text: '{home} 선수 물량 차이를 메울 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 자원 우위로 물량 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 노배럭더블의 자원이 결정적이었습니다!',
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
              text: '{home} 선수 탱크 시즈 라인으로 정면 돌파!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 정면 탱크 포격! 상대 라인을 찢습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 초반 피해가 회복되지 않았습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 FD 러쉬의 초반 피해가 결정적이었습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 탱크로 확장 빌드를 무너뜨립니다!',
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
              text: '{away} 선수 정면에서 밀립니다! 올인 본진 드랍!',
              owner: LogOwner.away,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십으로 상대 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -2, favorsStat: 'sense',
              altText: '{away} 선수 올인 드랍! 생산 시설을 파괴합니다!',
            ),
            ScriptEvent(
              text: '필사의 드랍! 피해가 크면 경기가 뒤집힙니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 (lines 48+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 48,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 초반 피해가 너무 컸습니다! 상대가 회복하지 못합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 초반 시즈 피해! 상대가 따라잡지 못합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 FD 러쉬가 노배럭더블을 초토화합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 탱크로 확장 빌드를 무너뜨립니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'nobar_double_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 더블 자원의 힘! 물량이 폭발합니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -3, favorsStat: 'macro',
              altText: '{away} 선수 자원 우위! 탱크 골리앗 대군!',
            ),
            ScriptEvent(
              text: '{away} 선수 초반을 버틴 뒤 자원 차이로 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 노배럭더블의 자원이 모든 것을 뒤집습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
