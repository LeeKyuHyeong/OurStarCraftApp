part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩원스타 vs 노배럭더블
// 빠른 탱크 푸시 vs 배럭 없는 극수비. 원팩원스타 크게 유리
// ----------------------------------------------------------
const _tvt1fac1starVsNobarDouble = ScenarioScript(
  id: 'tvt_1fac_1star_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '원팩원스타 vs 노배럭더블 - 빠른 푸시 vs 극수비',
  phases: [
    // Phase 0: 오프닝 (lines 1-10) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설! 빠른 팩토리를 노립니다!',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -400, // 커맨드센터 400
          fixedCost: true,
          altText: '{away}, CC퍼스트! 노배럭더블입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵 부착!',
          owner: LogOwner.home,
          homeResource: -500, // 가스 100 + 팩토리 300 + 머신샵 100
          fixedCost: true,
          altText: '{home}, 팩토리에 머신샵! 빠른 테크 전환입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭을 올립니다... 마린이 한참 늦습니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '원팩원스타 vs 노배럭더블! 초반 푸시를 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 원팩 푸시 (lines 14-22) - recovery 150/1
    ScriptPhase(
      name: 'push',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산! 시즈모드 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -625, // 시즈모드 300 + 탱크 250 + 벌처 75
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 겨우 나오기 시작합니다. 팩토리는 아직 멀었습니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -100, // 마린 2기 (50x2)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 벌처도 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -325, // 스타포트 250 + 벌처 75
          fixedCost: true,
          altText: '{home}, 스타포트까지! 공격 준비가 빠릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크와 벌처를 이끌고 전진합니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 원팩 푸시 시작! 상대는 탱크가 없습니다!',
        ),
      ],
    ),
    // Phase 2: 결전 (lines 26-45) - recovery 200/2
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'push_success',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 상대 앞마당을 사정거리에 넣습니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 추가 벌처 도착
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 마린과 SCV로 필사적으로 막아봅니다!',
              owner: LogOwner.away,
              awayArmy: 1, awayResource: -50, // 마린 1기 추가
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 SCV를 쫓아다닙니다! 수리가 안 됩니다!',
              owner: LogOwner.home,
              awayResource: -400, // 커맨드센터 피해
              favorsStat: 'control',
              altText: '{home}, 벌처 컨트롤! SCV가 수리를 못 합니다!',
            ),
            ScriptEvent(
              text: '기갑 유닛 한 대 차이가 이렇게 큽니다! 마린으로는 상대가 안 됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당을 밀어버립니다! 원팩 푸시 성공!',
              owner: LogOwner.home,
              awayArmy: -4,
              awayResource: -300, // 팩토리 등 건물 파괴
              decisive: true,
              altText: '{home} 선수 탱크 화력! 상대가 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'push_defended',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커를 올립니다! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -200, // 벙커 100 + 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away}, 벙커 완성! 마린 화력으로 벌처를 견제!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크로 벙커를 노리지만 SCV 수리가 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리가 완성됩니다! 테크 전환 성공!',
              owner: LogOwner.away,
              awayResource: -400, // 가스 100 + 팩토리 300
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 생산! 벙커 뒤에서 시즈!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -550, // 머신샵 100 + 시즈모드 300 + 탱크 250 (약간 묶음)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away}, 탱크 합류! 벙커와 탱크 조합 완성!',
            ),
            ScriptEvent(
              text: '{home} 선수 푸시가 막혔습니다! 후퇴합니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '노배럭 측이 수비 성공! 더블 자원이 가동됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 더블 자원으로 탱크 물량 확보! 역전 공세!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              decisive: true,
              altText: '{away} 선수 수비 후 역전! 자원 우위가 빛납니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
