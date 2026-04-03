part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 노배럭더블 미러
// 양측 모두 배럭 없이 앞마당 → 자원 경쟁 → 탱크 라인전
// ----------------------------------------------------------
const _tvtNobarDoubleMirror = ScenarioScript(
  id: 'tvt_nobar_double_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_nobar_double'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '노배럭더블 미러 - 자원 경쟁 장기전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '양 선수 모두 배럭 없이 앞마당 커맨드센터를 올립니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터 먼저!',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
          altText: '{home}, CC퍼스트! 배럭 없이 커맨드 먼저!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away}도 노배럭더블! 미러 매치입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설!',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 모두 노배럭더블! 초반 교전 없이 자원 싸움이 될 전망입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크업 (lines 14-30) - recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'tech_up',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 시즈 탱크를 노립니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리! 머신샵 부착합니다.',
          owner: LogOwner.away,
          awayResource: -500, // 리파이너리(100) + 팩토리(300) + 머신샵(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -550, // 시즈탱크(250/2sup) + 시즈모드 연구(300)
          fixedCost: true,
          altText: '{home}, 탱크가 나옵니다! 시즈모드 연구!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크! 양측 탱크 동시 생산!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -550,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 증설!',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          fixedCost: true,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설! 탱크 더블 생산 체제!',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          favorsStat: 'macro',
        ),
      ],
    ),
    // Phase 2: 탱크 라인전 (lines 35-80) - recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'tank_line_battle',
      startLine: 35,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_tank_advantage',
          conditionStat: 'strategy',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처로 정찰! 상대 탱크 배치를 확인합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 유리한 고지를 선점합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              homeResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 올리지만 위치가 불리합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              awayResource: -250, // 탱크 1기
              fixedCost: true,
            ),
            ScriptEvent(
              text: '노배럭더블 미러! 자원은 비슷한데 병력 배치에서 차이가 납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 드랍십을 노립니다!',
              owner: LogOwner.home,
              homeResource: -250, // 스타포트 250
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{home}, 스타포트! 드랍 운영으로 승부를 보겠다는 거죠!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 태워 상대 확장기지를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              homeResource: -200, // 드랍십 200/2sup
              fixedCost: true,
              awayArmy: -4,
              awayResource: -300, // SCV 피해
              favorsStat: 'harass',
              altText: '{home}, 탱크 드랍! 상대 일꾼이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 대응이 늦습니다! 확장기지 피해가 큽니다!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -200,
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 양면 공격!',
              owner: LogOwner.home,
              homeArmy: 10,
              awayArmy: -10,
              decisive: true,
              altText: '{home} 선수 탱크 라인 전진! 물량 우위로 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_tank_advantage',
          conditionStat: 'strategy',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처로 마인 매설! 상대 벌처 견제를 차단합니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량이 더 빠르게 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              awayResource: -500, // 탱크 2기 (250x2)
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수도 탱크를 모으지만 물량이 부족합니다.',
              owner: LogOwner.home,
              homeArmy: 2,
              homeResource: -250, // 탱크 1기
              fixedCost: true,
            ),
            ScriptEvent(
              text: '자원은 비슷한데 병력 운영에서 차이가 벌어집니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 스타포트와 사이언스 퍼실리티 건설!',
              owner: LogOwner.away,
              awayResource: -500, // 스타포트(250) + 사이언스퍼실리티(250)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 사이언스 베슬 생산! 탱크 라인에 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              awayResource: -325, // 사이언스베슬 325/2sup
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{away}, 사이언스 베슬! 디펜시브 매트릭스 준비!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인 전진! {home} 선수 방어선을 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              awayResource: -500, // 탱크 2기 추가
              fixedCost: true,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트를 올립니다! 역습을 노립니다.',
              owner: LogOwner.home,
              homeResource: -250, // 스타포트 250
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십으로 역습을 시도하지만 터렛에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -4, // 드랍십+탱크 손실
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량 우위! 정면으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 10,
              homeArmy: -10,
              decisive: true,
              altText: '{away} 선수 탱크 라인이 압도합니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
