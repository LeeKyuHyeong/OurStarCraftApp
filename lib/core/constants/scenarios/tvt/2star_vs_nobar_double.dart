part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투스타 레이스 vs 노배럭더블
// 레이스 견제 vs 배럭 없는 극수비. 터렛이 늦어 견제에 취약
// ----------------------------------------------------------
const _tvt2starVsNobarDouble = ScenarioScript(
  id: 'tvt_2star_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '투스타 레이스 vs 노배럭더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-12) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리!',
          owner: LogOwner.home,
          homeResource: -450, // 배럭(150) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -400, // CC(400)
          fixedCost: true,
          altText: '{away}, CC퍼스트! 노배럭더블!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 공중 테크를 노립니다!',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트(250)
          fixedCost: true,
          altText: '{home}, 스타포트가 올라갑니다! 투스타 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 시작... 배럭도 터렛도 없습니다!',
          owner: LogOwner.away,
          awayResource: -150, // 배럭(150)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 스타포트까지 올립니다! 투스타 확정!',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트(250)
          fixedCost: true,
          altText: '{home}, 스타포트 2개! 공중 유닛을 대량으로 뽑겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 팩토리 건설을 시작합니다.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리(300)
          fixedCost: true,
          altText: '{away}, 팩토리가 올라갑니다! 벌처라도 뽑아야 합니다!',
        ),
      ],
    ),
    // Phase 1: 레이스 견제 (lines 14-24) - recovery 150/1
    ScriptPhase(
      name: 'wraith_harass',
      startLine: 14,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 생산! SCV 견제를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4, // 레이스 2기 (2sup x2)
          homeResource: -500, // 레이스2(500)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스가 상대 본진에 도착! SCV를 공격합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 레이스 견제! 터렛이 없어서 자유롭게 공격합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 겨우 나왔지만 공중 유닛을 쫓기엔 부족합니다!',
          owner: LogOwner.away,
          awayArmy: 1, // 마린 1기 (1sup)
          awayResource: -50, // 마린(50)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 컨트롤타워 부착! 클로킹 연구 시작!',
          owner: LogOwner.home,
          homeResource: -400, // 컨트롤타워(100) + 클로킹(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '노배럭더블이라 터렛도 엔지니어링 베이도 없습니다! 클로킹이 나오면 큰일입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결전 (lines 28-60) - recovery 200/2
    ScriptPhase(
      name: 'decisive',
      startLine: 28,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'cloak_devastation',
          conditionStat: 'harass',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 투입! 상대가 볼 수 없습니다!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'harass',
              altText: '{home}, 클로킹! SCV가 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급하게 엔지니어링 베이 건설! 터렛을 올려야 합니다!',
              owner: LogOwner.away,
              awayResource: -200, // 엔지니어링베이(125) + 터렛(75)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 추가! 양 기지 동시 견제!',
              owner: LogOwner.home,
              homeArmy: 4, // 레이스 2기 (2sup x2)
              awayResource: -25,
              homeResource: -500, // 레이스2(500)
              fixedCost: true,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: 'SCV 피해가 심각합니다! 노배럭더블의 약점이 드러납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 견제로 자원 우위! 탱크까지 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 레이스와 탱크 조합! 상대가 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'turret_defense',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린을 모아 공중 유닛을 잡아냅니다! 피해를 최소화!',
              owner: LogOwner.away,
              homeArmy: -2, // 레이스 1기 격추 (2sup)
              awayArmy: 2, // 마린 추가 (2sup 분)
              awayResource: -100, // 마린2(100)
              fixedCost: true,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 엔지니어링 베이에 이어 터렛 건설! 클로킹 대비 완료!',
              owner: LogOwner.away,
              awayResource: -200, // 엔지니어링베이(125) + 터렛(75)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스가 터렛에 걸립니다! 견제 효과 감소!',
              owner: LogOwner.home,
              homeArmy: -4, // 레이스 2기 격추 (2sup x2)
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원 가동! 탱크 물량이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 2기 (2sup x2)
              awayResource: -500, // 탱크2(500)
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '공중 견제를 막아냈습니다! 노배럭더블의 자원이 빛을 발합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량 우위로 전진! 역전합니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 수비 후 물량 역전! 탱크 라인이 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
