part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 투스타 레이스 (지상 화력 vs 공중 기동)
// ----------------------------------------------------------
const _tvtFdRushVs2star = ScenarioScript(
  id: 'tvt_fd_rush_vs_2star',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_2star'],
  description: 'FD 러쉬 vs 투스타 레이스 공중전',
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
          altText: '{home}, 팩토리에 머신샵! 빠른 메카닉!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 바로 스타포트로! 두 번째 스타포트도!',
          owner: LogOwner.away,
          awayResource: -800, // 팩토리 300 + 스타포트 x2 (250+250)
          fixedCost: true,
          altText: '{away}, 스타포트 2개! 투스타 공중 체제!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트에서 기다립니다! 클로킹도 연구합니다!',
          owner: LogOwner.away,
          awayResource: -400, // 컨트롤타워 100 + 클로킹 300
          fixedCost: true,
          altText: '{away}, 스타포트 클로킹 연구! 은신 공격을 노립니다!',
        ),
        ScriptEvent(
          text: '지상 화력 vs 공중 기동! 전혀 다른 빌드가 맞붙습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 레이스 견제 시작 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'wraith_harass',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산! 맵 중앙 정찰에 나섭니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75
          fixedCost: true,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away}, 레이스 2기가 출격합니다! 클로킹 돌입!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500, // 레이스 2기 (250x2)
          fixedCost: true,
          favorsStat: 'harass',
          altText: '{away} 선수 레이스 출격! 은신 상태로 접근!',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛이 없습니다! 클로킹을 못 봐요!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 디텍터가 없습니다! 공중 유닛이 보이지 않아요!',
        ),
        ScriptEvent(
          text: '{home} 선수 급하게 엔지니어링 베이 건설! 터렛을 올립니다!',
          owner: LogOwner.home,
          homeResource: -200, // 엔지니어링베이 125 + 터렛 75
          fixedCost: true,
          favorsStat: 'scout',
          altText: '{home}, 엔지니어링 베이! 터렛으로 대공 수비!',
        ),
        ScriptEvent(
          text: '{away}, 레이스로 SCV를 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '클로킹 공중 유닛의 위력! 대공이 없으면 속수무책!',
          owner: LogOwner.system,
          skipChance: 0.25,
        ),
      ],
    ),
    // Phase 2: 대공 수비 vs 견제 분기 (lines 22-32) - recovery 150/1
    ScriptPhase(
      name: 'anti_air_response',
      startLine: 22,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 터렛 수비 성공
        ScriptBranch(
          id: 'turret_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 터렛이 올라갑니다! 공중 유닛을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 터렛 완성! 공중 유닛 격추!',
            ),
            ScriptEvent(
              text: '{away} 선수 공중 유닛이 터렛에 격추됩니다! 투자가 아깝습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크가 계속 모입니다! 시즈 라인 형성!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{home} 선수 탱크 물량! 지상에서는 압도적!',
            ),
            ScriptEvent(
              text: '터렛 수비 성공! 지상 병력이 쌓이기 시작합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 레이스 견제 계속 성공
        ScriptBranch(
          id: 'wraith_keeps_harassing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 대공 대비를 갖춥니다.',
              owner: LogOwner.home,
              homeResource: -250, // 스타포트 250
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away}, 레이스가 터렛을 피해 다른 미네랄 라인으로!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 레이스 우회! 터렛이 없는 곳을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 터렛을 추가로 지어야 합니다! 자원이 빠듯!',
              owner: LogOwner.home,
              homeResource: -75, // 터렛 75
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away}, 드랍십도 섞습니다! 병력을 실어서 뒤를 칩니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -200, // 드랍십 200
              fixedCost: true,
              homeResource: -10, favorsStat: 'strategy',
              altText: '{away} 선수 공중 유닛과 드랍십! 다방면 공격!',
            ),
            ScriptEvent(
              text: '공중 견제가 효과적입니다! 지상군 전진이 늦어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 결전 (lines 34-44) - recovery 200/2
    ScriptPhase(
      name: 'late_battle',
      startLine: 34,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 확장! 탱크 더블 생산 체제!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -900, // CC 400 + 탱크 2기 (250x2)
          fixedCost: true,
          altText: '{home}, 앞마당과 더블 팩토리! 탱크를 밀어냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗도 섞습니다! 레이스와 지상군 혼합!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -400, // 골리앗 150 + 레이스 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home}, 골리앗도 생산! 대공 보강합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -300, // 아머리 150 + 골리앗 150
          fixedCost: true,
          altText: '{home} 선수 아머리에서 골리앗! 대공 보강!',
        ),
        ScriptEvent(
          text: '양측 모두 본격적인 전투 준비를 마칩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
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
              text: '{home}, 탱크 골리앗 라인이 전진합니다! 시즈 포격!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 지상군이 압도적! 시즈 라인!',
            ),
            ScriptEvent(
              text: '{away} 선수 공중만으로는 시즈 라인을 못 뚫습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 지상 화력으로 상대 체제를 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크와 골리앗으로 승리합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'wraith_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 레이스 편대와 드랍십! 양면 공격!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 공중과 드랍 동시 공격!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비가 갈립니다! 탱크가 분산됩니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 공중 기동력으로 지상군을 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 레이스 견제가 결정적이었습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
