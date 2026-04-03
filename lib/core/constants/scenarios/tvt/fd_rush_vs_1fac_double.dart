part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 원팩더블 (공격형 팩토리 vs 확장형 팩토리)
// ----------------------------------------------------------
const _tvtFdRushVs1facDouble = ScenarioScript(
  id: 'tvt_fd_rush_vs_1fac_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_1fac_double'],
  description: 'FD 러쉬 vs 원팩더블 팩토리 대결',
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
          text: '{home} 선수 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.home,
          homeResource: -400, // 팩토리 300 + 머신샵 100
          fixedCost: true,
          altText: '{home}, 팩토리에 머신샵! 시즈 모드를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 벌처 생산 시작!',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{away}, 팩토리! 벌처부터 뽑습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산! 공격에 집중합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 원팩으로 확장합니다!',
          owner: LogOwner.away,
          awayResource: -400, // CC 400
          fixedCost: true,
          altText: '{away}, 앞마당 확장! 안정적 운영!',
        ),
        ScriptEvent(
          text: '같은 팩토리 빌드지만 방향이 다릅니다! 공격 vs 확장!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: FD 전진 vs 수비 준비 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'fd_advance',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 시즈 모드 연구! 탱크를 전진 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 시즈모드 300 + 탱크 1기 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 모드! 탱크가 전진합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 정찰! 상대 탱크 전진을 확인!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 벌처 정찰! 탱크가 오고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착! 자체 탱크를 생산합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -350, // 머신샵 100 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home}, 두 번째 팩토리 건설! 탱크 더블 생산 체제!',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          fixedCost: true,
          altText: '{home} 선수 투팩 체제! 탱크를 밀어냅니다!',
        ),
        ScriptEvent(
          text: '병력 물량에서 FD가 앞섭니다! 확장 측이 버틸 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.25,
        ),
      ],
    ),
    // Phase 2: 탱크 대치 분기 (lines 24-36) - recovery 150/1
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 24,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: FD 시즈가 확장을 압박
        ScriptBranch(
          id: 'fd_pressures_expansion',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 시즈! 앞마당을 포격합니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 1기밖에 없습니다! 수적 열세!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 벌처도 합류시켜 견제합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75, // 벌처 1기 75
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 벌처 합류! 다방면 압박!',
            ),
            ScriptEvent(
              text: 'FD의 병력 물량이 앞섭니다! 확장이 흔들립니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 원팩더블 수비 안정
        ScriptBranch(
          id: 'fac_double_stabilizes',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벙커를 앞에 세우고 탱크를 뒤에 배치합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -350, // 벙커 100 + 탱크 250
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 벙커와 탱크 수비 진지! 단단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커 뒤 탱크를 못 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 확장 자원으로 빠르게 병력을 보충합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 자원 우위! 병력이 빠르게 늡니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 확장의 자원이 살아있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 38-46) - recovery 200/2
    ScriptPhase(
      name: 'late_game',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 확장! 늦었지만 자원을 늘립니다!',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{away}, 스타포트! 드랍 견제를 노립니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 더블 생산이 이어집니다! 물량을 밀어냅니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
          fixedCost: true,
          altText: '{home} 선수 탱크 물량! 더블 팩토리의 힘!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 골리앗 라인! 안정적으로 늘립니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -400, // 탱크 250 + 골리앗 150
          fixedCost: true,
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
              text: '{home}, 탱크 시즈 라인으로 최종 공세!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 자원이 있지만 탱크 수가 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 공격적 팩토리 빌드의 탱크 우위로 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 빠른 탱크 물량이 결정적이었습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'fac_double_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드랍십 견제! 상대 후방을 공격합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 탱크 드랍! 후방 기습!',
            ),
            ScriptEvent(
              text: '{away}, 정면에서도 물량으로 밀어붙입니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 자원의 물량으로 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 안정적 운영이 공격을 이겨냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
