part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs BBS (공격형 vs 치즈)
// ----------------------------------------------------------
const _tvtFdRushVsBbs = ScenarioScript(
  id: 'tvt_fd_rush_vs_bbs',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_bbs'],
  description: 'FD 러쉬 vs BBS 초반 공격 대결',
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
          text: '{away} 선수 SCV를 센터로 보냅니다.',
          owner: LogOwner.away,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올리고 마린을 계속 뽑습니다.',
          owner: LogOwner.home,
          homeResource: -100, // 리파이너리 100
          homeArmy: 2, // 마린 생산 시작
          fixedCost: true,
          altText: '{home} 선수 리파이너리 건설, 마린 연속 생산입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 센터와 본진에 배럭 건설. 배럭을 두 개 올립니다.',
          owner: LogOwner.away,
          awayResource: -300, // 배럭 x2 (150+150)
          fixedCost: true,
          altText: '{away} 선수 센터 배럭, 본진 배럭. 마린에 올인하네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 마린은 계속 생산합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          homeArmy: 2, // 마린 추가
          fixedCost: true,
          altText: '{home} 선수 팩토리를 올리면서 마린을 모읍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착. 벌처 없이 바로 탱크를 노립니다.',
          owner: LogOwner.home,
          homeResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 머신샵을 올립니다, 빠른 탱크 체제입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 모입니다. SCV도 끌고 전진 준비.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -150, // 마린 3기 (50x3)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '메카닉 병력이 먼저냐 바이오닉 병력이 먼저냐! 타이밍 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: BBS 돌진 vs 탱크 생산 (lines 10-16) - recovery 100/0
    ScriptPhase(
      name: 'bbs_rush_vs_tank',
      startLine: 10,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 마린 3기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -100, // 마린 2기 추가 (50x2)
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{away} 선수 마린과 SCV 돌진! 마린 올인 공격 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 시즈 탱크 생산 시작.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
          altText: '{home} 선수 시즈 탱크가 생산됩니다. 나올 수 있을까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 상대 앞에 벙커 건설 시도.',
          owner: LogOwner.away,
          awayResource: -100, // 벙커 100
          fixedCost: true,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 마린과 SCV로 벙커 건설을 방해합니다!',
          owner: LogOwner.home,
          favorsStat: 'defense',
          altText: '{home} 선수 SCV로 벙커 건설을 끊으려 합니다.',
        ),
        ScriptEvent(
          text: '기갑 유닛이 나올 때까지 버틸 수 있느냐가 관건입니다!',
          owner: LogOwner.system,
          skipChance: 0.25,
        ),
      ],
    ),
    // Phase 2: BBS 결과 분기 (lines 17-28) - recovery 150/1
    ScriptPhase(
      name: 'bbs_result',
      startLine: 17,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 탱크로 BBS 방어 성공
        ScriptBranch(
          id: 'tank_defends_bbs',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 탱크가 나왔습니다! 시즈 모드!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -300, // 시즈모드 연구 300
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{home} 선수 탱크 합류! 상대 마린을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 포격에 녹고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수 벙커도 건설하고 완벽한 수비입니다!',
              owner: LogOwner.home,
              homeResource: -100, // 벙커 100
              fixedCost: true,
              altText: '{home} 선수 벙커까지! 마린 올인을 완전히 막아냅니다!',
            ),
            ScriptEvent(
              text: '마린 올인이 기갑 유닛에 막혔습니다! 빠른 팩토리의 승리!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 전멸했습니다... 큰 손실입니다.',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
          ],
        ),
        // 분기 B: BBS가 탱크 나오기 전에 돌파
        ScriptBranch(
          id: 'bbs_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{away} 선수 벙커 완성! 마린 집중 화력!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 아직 안 나왔습니다! 마린밖에 없어요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 SCV까지 투입! 일꾼을 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'attack',
              altText: '{away} 선수 SCV 공격! 상대 일꾼이 큰 피해!',
            ),
            ScriptEvent(
              text: '마린 올인이 먼저 들어갔습니다! 큰 피해를 줍니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 30-40) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      startLine: 30,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터 건설. 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
          altText: '{home} 선수 앞마당 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 메카닉으로 전환합니다.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다. 테크 전환.',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리 건설. 탱크 더블 생산.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 팩토리 300 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착. 벌처와 탱크 생산을 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -425, // 머신샵 100 + 탱크 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 완료. 탱크 라인을 전진시킵니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 모드! 탱크가 전진합니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 메카닉 체제로 전환 중입니다.',
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
    // Phase 3b: 중반 탱크 대치 분기 (lines 40-44) - recovery 200/2
    ScriptPhase(
      name: 'mid_tank_standoff',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 벌처 견제 - 소규모 피해
        ScriptBranch(
          id: 'guerrilla_vulture',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처로 상대 확장 일꾼을 견제합니다.',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
              altText: '{away} 선수 벌처 견제! SCV를 잡아내고 빠집니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마린으로 벌처를 쫓아냅니다.',
              owner: LogOwner.home,
              awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '벌처 견제! 자잘한 피해가 쌓입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
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
              text: '{home} 선수 탱크 물량으로 밀어붙입니다! 상대 잔여 병력을 정리!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈! 상대 병력을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 부족합니다! 초반 투자가 무겁습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 빠른 탱크 물량이 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 팩토리의 탱크 우위로 밀어냅니다!',
            ),
          ],
        ),
        // BBS 회복 후 역습 - 벌처 견제
        ScriptBranch(
          id: 'bbs_recovery_counter',
          baseProbability: 0.7,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처로 측면 우회! 상대 후방을 기습합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 벌처 기습! 일꾼 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후방 피해가 큽니다! 탱크 라인이 흔들립니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '초반 공격 이후 회복하면서 벌처 견제가 효과적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 필사적 올인 - BBS 측 마지막 승부
        ScriptBranch(
          id: 'desperate_allin',
          baseProbability: 0.6,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{away} 선수 초반 피해를 딛고 마지막 승부수!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500, // 탱크 250 + 벌처 150 + 잔여
              fixedCost: true,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{away} 선수 모든 병력을 정면에 쏟아붓습니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 올인 정면 공격! 탱크 라인에 돌진합니다!',
            ),
            ScriptEvent(
              text: '마지막 승부! 초반 피해를 만회할 수 있을까요?',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 판정 (lines 46+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 46,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 물량으로 밀어붙입니다! 잔여 병력을 정리합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈! 상대 병력을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 부족합니다! 초반에 마린에 쏟은 투자가 무겁습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 물량이 압도합니다! 빠른 팩토리의 승리!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 팩토리의 탱크 우위로 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'bbs_recovery_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 초반 피해를 회복! 벌처로 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 벌처 견제! 상대 후방을 기습!',
            ),
            ScriptEvent(
              text: '{home} 선수 후방 피해가 큽니다! 탱크 라인이 흔들립니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 초반 피해를 딛고 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 기동력으로 탱크 라인을 무력화합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
