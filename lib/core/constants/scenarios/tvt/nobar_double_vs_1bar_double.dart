part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 노배럭더블 vs 원배럭더블
// 노배럭더블이 자원 먼저 가동, 원배럭더블은 마린이 먼저 나옴
// ----------------------------------------------------------
const _tvtNobarDoubleVs1barDouble = ScenarioScript(
  id: 'tvt_nobar_double_vs_1bar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_nobar_double'],
  awayBuildIds: ['tvt_1bar_double'],
  description: '노배럭더블 vs 원배럭더블 - 자원 선행 vs 병력 선행',
  phases: [
    // Phase 0: 오프닝 (lines 1-12) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 없이 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -400, // CC 400
          altText: '{home} 선수 배럭 없이 커맨드센터를 먼저 올립니다. 과감한 자원 운영!',
        ),
        ScriptEvent(
          text: '{away} 선수는 배럭을 먼저 짓고 앞마당 확장.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150, // 배럭 150
          altText: '{away} 선수 배럭을 먼저 올리고 확장합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 먼저 나옵니다! {home} 선수는 아직 배럭도 없습니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -100, // 마린 2기 (50x2)
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -400, // CC 400
        ),
        ScriptEvent(
          text: '{home} 선수 뒤늦게 배럭 건설. 마린 생산까지 시간이 걸립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -150, // 배럭 150
        ),
        ScriptEvent(
          text: '노배럭 vs 원배럭! 자원 가동 시점 차이가 핵심입니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
          altText: '안정적인 운영을 선택했습니다. 실력 싸움 가겠다는 거죠.',
        ),
      ],
    ),
    // Phase 1: 중반 테크업 (lines 16-30) - recovery 150/1
    ScriptPhase(
      name: 'mid_tech',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 더블 자원이 먼저 돌아갑니다! 일꾼 생산 빠릅니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: 15,
          altText: '{home} 선수 더블 자원 가동. 원배럭보다 일꾼이 많습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 시즈 탱크 준비.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -400, // 리파이너리 100 + 팩토리 300
        ),
        ScriptEvent(
          text: '{home} 선수도 팩토리 건설. 자원 우위로 빠르게 따라잡습니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -400, // 리파이너리 100 + 팩토리 300
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -800, // 머신샵 100 + 시즈모드 300 + 탱크 250 + 탱크 250 → 첫 머신샵+시즈+탱크2기
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크. 양측 탱크 대치가 시작됩니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -700, // 머신샵 100 + 시즈모드 300 + 탱크 250 + 잔여
        ),
        ScriptEvent(
          text: '첫 탱크가 나오기 전까지는 폭풍전야입니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.5,
        ),
      ],
    ),
    // Phase 2: 탱크 라인전 (lines 35-80) - recovery 200/2
    ScriptPhase(
      name: 'tank_battle',
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'nobar_resource_wins',
          conditionStat: 'macro',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 더블 자원 효과! 탱크 물량이 더 빠르게 쌓입니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
              altText: '{home} 선수 빠른 확장의 자원 우위가 빛을 발합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 추가하지만 물량에서 밀립니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -250, // 탱크 1기 250
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트와 사이언스 퍼실리티 건설.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -500, // 스타포트 250 + 사이언스퍼실리티 250
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬 생산. 탱크 라인에 합류!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -325, // 사이언스베슬 325
            ),
            ScriptEvent(
              text: '빠른 확장의 자원 우위가 결정적입니다! 병력 수에서 차이가 벌어집니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '테테전의 꽃, 시즈 탱크 라인 긋기 싸움입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인 전진! 물량으로 압도합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 더블 자원의 물량 우위! 상대를 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'bar_double_aggression',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 초반 마린 우위를 살려 벌처로 견제!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 2, awayResource: -75, // 벌처 1기 75
              homeResource: -15,
              altText: '{away} 선수 벌처 견제! 노배럭 측 일꾼을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 일꾼 피해! 자원 우위가 줄어듭니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 올립니다! 적극적으로 전진!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -500, // 탱크 2기 (250x2)
            ),
            ScriptEvent(
              text: '{home} 선수 방어선을 구축하지만 벌처 견제로 자원이 부족합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
            ),
            ScriptEvent(
              text: '초반 병력 우위가 결정적이었습니다! 배럭을 먼저 올린 차이!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '벌처 돌리기! 상대 시선을 분산시키는 고도의 심리전입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인으로 정면 돌파! 상대 방어선을 무너뜨립니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 탱크 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
