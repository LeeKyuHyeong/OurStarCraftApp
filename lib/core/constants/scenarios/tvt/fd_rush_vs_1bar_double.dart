part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 원배럭더블 (공격형 vs 빠른 확장)
// ----------------------------------------------------------
const _tvtFdRushVs1barDouble = ScenarioScript(
  id: 'tvt_fd_rush_vs_1bar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_1bar_double'],
  description: 'FD 러쉬 vs 원배럭더블 탱크 푸시',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -150, // 배럭 150
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150, // 배럭 150
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올리고 마린을 계속 뽑습니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 리파이너리 100
          homeArmy: 2, // 마린 생산 시작
          altText: '{home} 선수 리파이너리 건설, 마린 연속 생산입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터. 빠른 확장입니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -400, // CC 400
          altText: '{away} 선수 앞마당 커맨드센터. 배럭 후 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 마린은 계속 뽑습니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300, // 팩토리 300
          homeArmy: 2, // 마린 추가
          altText: '{home} 선수 팩토리를 올리면서 마린을 모읍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착. 벌처 없이 바로 탱크를 노립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 머신샵 100
          altText: '{home} 선수 머신샵을 올립니다, 빠른 탱크 체제입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 확장이 가동됩니다. 가스를 올리고 팩토리를 준비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100, // 리파이너리 100
          altText: '{away} 선수 확장 가동, 리파이너리를 올립니다.',
        ),
        ScriptEvent(
          text: '마린 메카닉 조합 빠른 공격 vs 앞마당 확장! 공격과 수비의 대결!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: 'SCV 정찰로 상대 팩토리 타이밍을 꼼꼼히 체크합니다.',
        ),
      ],
    ),
    // Phase 1: FD 러쉬 전진 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'fd_push',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 생산과 시즈모드 연구를 동시에 시작합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -550, // 탱크 250 + 시즈모드 300
          altText: '{home} 선수 탱크와 시즈모드 동시 진행. 빠른 공격 준비.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 올립니다. 하지만 탱크는 아직 멀었습니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -300, // 팩토리 300
          altText: '{away} 선수 팩토리 건설. 탱크를 빨리 뽑아야 합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈모드 완료! 마린 6기와 탱크를 앞세워 전진합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 2, // 마린 추가 완성분
          altText: '{home} 선수 마린 물량에 탱크까지! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커와 마린으로 수비 준비.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -200, // 벙커 100 + 마린 2기 (50x2)
        ),
        ScriptEvent(
          text: '마린과 시즈탱크가 앞마당 앞에 자리잡습니다! 확장이 위험합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
          altText: '마린 물량에 시즈 포격까지, 수비 측이 버틸 수 있을까요.',
        ),
      ],
    ),
    // Phase 2: 앞마당 공방 분기 (lines 22-34) - recovery 150/1
    ScriptPhase(
      name: 'expansion_siege',
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 탱크 시즈 성공 -> 앞마당 피해
        ScriptBranch(
          id: 'siege_damages_expansion',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 앞마당 커맨드센터에 피해를 줍니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -1,              altText: '{home} 선수 시즈 포격! 앞마당이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 수리하지만 포격이 너무 강합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 탱크 합류! 앞마당을 초토화합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
              awayResource: -15,              altText: '{home} 선수 탱크 추가! 앞마당 파괴!',
            ),
            ScriptEvent(
              text: '앞마당이 큰 피해를 입었습니다! 확장 투자가 물거품!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '탱크 일점사! 상대 탱크 숫자 줄이는 데 집중합니다!',
            ),
          ],
        ),
        // 분기 B: 벙커, 탱크 수비 성공
        ScriptBranch(
          id: 'bunker_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 뒤에 자체 탱크를 배치합니다! 시즈 모드!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -550, // 탱크 250 + 머신샵 100 + 시즈모드 연구 비용은 이미 연구중이므로 실제로는 머신샵+탱크
              altText: '{away} 선수 탱크 합류! 시즈 대 시즈!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 탱크가 나왔습니다! 시즈 교환이 됩니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벙커 마린 화력까지! 초반 공격을 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,              altText: '{away} 선수 벙커와 탱크 수비! 러쉬를 방어합니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 확장의 자원 우위가 살아있습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '조이기 라인이 풀리지 않습니다. 서서히 말라 죽어가네요.',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 36-42) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터. 뒤늦게 확장합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -400, // CC 400
          altText: '{home} 선수 앞마당 확장. 이제 운영으로 전환.',
        ),
        ScriptEvent(
          text: '{away} 선수 자원 우위로 추가 팩토리. 탱크 물량을 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -550, // 팩토리 300 + 탱크 250
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리. 탱크 더블 생산.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -550, // 팩토리 300 + 탱크 250
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설. 드랍십을 준비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -250, // 스타포트 250
          altText: '{away} 선수 스타포트 건설. 드랍으로 반격할 준비.',
        ),
        // ── 맵 특성 이벤트 ──
        ScriptEvent(
          text: '근거리 맵이라 벌처 한 기 차이가 더 크게 느껴집니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -2,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '언덕 위 시즈모드, 테테전에서 가장 무서운 지형지물이죠.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -2,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다! 지형 싸움!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 3b: 중반 결전 분기 (lines 44-48) - recovery 200/2
    ScriptPhase(
      name: 'mid_decisive',
      recoveryArmyPerLine: 2,
      branches: [
        // 게릴라 드랍 - 소규모 피해 후 회수
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -450, // 드랍십 200 + 탱크 250
            ),
            ScriptEvent(
              text: '{away} 선수 확장 기지에 내려서 SCV를 잡아냅니다! 바로 회수!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,              altText: '{away} 선수 드랍 견제 후 빠르게 빠집니다!',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 피해를 주고 빠지는 전형적인 견제입니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
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
              text: '{away} 선수 드랍십 두 대로 본진과 확장 동시 투하!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -3, homeResource: -20,              altText: '{away} 선수 양면 드랍! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 분산됩니다! 정면도 뚫립니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 드랍과 정면 동시 공격으로 마무리합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 양면 공격! 확장 빌드의 역습!',
            ),
          ],
        ),
        // 정면 탱크 푸시 - FD 측 공격
        ScriptBranch(
          id: 'frontal_push',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 일렬로 전진시킵니다! 시즈 포격!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,              altText: '{home} 선수 정면 탱크 돌파! 상대 라인을 찢습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인이 무너집니다! 자원 우위가 소용없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 정면 화력으로 상대를 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 탱크 시즈 화력이 모든 것을 결정합니다!',
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
              text: '{away} 선수 정면에서 밀리고 있습니다! 승부수를 던집니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -450, // 드랍십 200 + 탱크 250
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대를 본진에 투하! 팩토리를 노립니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20, homeArmy: -2,              altText: '{away} 선수 올인 본진 드랍! 역전을 노립니다!',
            ),
            ScriptEvent(
              text: '필사의 드랍! 피해가 크면 경기가 뒤집힐 수 있습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 (lines 46+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 초반 시즈 피해가 결정적! 자원 격차가 벌어집니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,              altText: '{home} 선수 초반 탱크 화력이 결정적이었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 피해를 회복하지 못합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 빠른 탱크가 확장을 무너뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 탱크 푸시로 확장을 파괴하며 승리!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'expansion_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 자원 우위! 탱크 골리앗 물량이 쏟아집니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -650, // 탱크 250 + 골리앗 2기 (150x2) + 잔여
              altText: '{away} 선수 확장 자원! 물량으로 압도합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 단일 가스로는 물량을 따라잡지 못합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 확장의 자원 우위로 물량 역전합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 수비 성공 후 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
