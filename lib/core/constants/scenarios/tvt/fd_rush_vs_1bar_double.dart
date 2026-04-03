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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취! 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리 100 + 팩토리 300
          fixedCost: true,
          altText: '{home}, 팩토리! 빠른 메카닉을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 빠른 확장입니다!',
          owner: LogOwner.away,
          awayResource: -400, // CC 400
          fixedCost: true,
          altText: '{away}, 앞마당 커맨드센터! 원배럭더블로 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 탱크를 뽑습니다!',
          owner: LogOwner.home,
          homeResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{home}, 머신샵! 기갑 유닛 생산 준비 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수 확장이 가동됩니다! 일꾼을 추가 생산합니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '빠른 메카닉 vs 빠른 확장! 공격과 수비의 대결!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: FD 러쉬 전진 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'fd_push',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 탱크 250 + 시즈모드 300
          fixedCost: true,
          altText: '{home}, 탱크와 시즈 모드! FD 러쉬 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 넣고 팩토리를 올립니다! 하지만 늦습니다!',
          owner: LogOwner.away,
          awayResource: -400, // 리파이너리 100 + 팩토리 300
          fixedCost: true,
          altText: '{away}, 팩토리 건설! 탱크를 빨리 뽑아야 합니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 2기를 앞세우고 전진합니다! 시즈 모드!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 추가 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 전진! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커와 마린으로 수비 준비!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -200, // 벙커 100 + 마린 2기 (50x2)
          fixedCost: true,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '시즈 라인이 앞마당 앞에 자리잡습니다! 확장이 위험합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 앞마당 공방 분기 (lines 22-34) - recovery 150/1
    ScriptPhase(
      name: 'expansion_siege',
      startLine: 22,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 탱크 시즈 성공 -> 앞마당 피해
        ScriptBranch(
          id: 'siege_damages_expansion',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 시즈 포격! 앞마당 커맨드센터에 피해를 줍니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 앞마당이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV가 수리하지만 포격이 너무 강합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 탱크 합류! 앞마당을 초토화합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
              fixedCost: true,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 탱크 추가! 앞마당 파괴!',
            ),
            ScriptEvent(
              text: '앞마당이 큰 피해를 입었습니다! 확장 투자가 물거품!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 벙커, 탱크 수비 성공
        ScriptBranch(
          id: 'bunker_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 뒤에 자체 탱크를 배치합니다! 시즈 모드!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -550, // 탱크 250 + 머신샵 100 + 시즈모드 연구 비용은 이미 연구중이므로 실제로는 머신샵+탱크
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 탱크 합류! 시즈 대 시즈!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 탱크가 나왔습니다! 시즈 교환이 됩니다!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 벙커 마린 화력까지! FD 러쉬를 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 벙커와 탱크 수비! 러쉬를 방어합니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 확장의 자원 우위가 살아있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 36-44) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      startLine: 36,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터! 뒤늦게 확장합니다!',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
          altText: '{home}, 앞마당 확장! 이제 운영으로 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 자원 우위로 추가 팩토리! 탱크 물량을 올립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550, // 팩토리 300 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리! 탱크 더블 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 팩토리 300 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{away}, 스타포트! 드랍으로 반격할 준비!',
        ),
      ],
    ),
    // Phase 4: 결전 (lines 46+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 46,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 초반 시즈 피해가 결정적! 자원 격차가 벌어집니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 초반 탱크 화력이 결정적이었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 피해를 회복하지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 FD 러쉬의 탱크가 확장 빌드를 무너뜨립니다!',
              owner: LogOwner.home,
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
              text: '{away}, 자원 우위! 탱크 골리앗 물량이 쏟아집니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -650, // 탱크 250 + 골리앗 2기 (150x2) + 잔여
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 확장 자원! 물량으로 압도합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 단일 가스로는 물량을 따라잡지 못합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 확장의 자원 우위로 물량 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 수비 성공 후 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
