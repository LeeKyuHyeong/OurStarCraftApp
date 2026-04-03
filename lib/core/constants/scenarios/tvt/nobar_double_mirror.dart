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
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '양 선수 모두 배럭 없이 앞마당 커맨드센터를 올립니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터 먼저!',
          owner: LogOwner.home,
          homeResource: -40,
          altText: '{home}, CC퍼스트! 배럭 없이 커맨드 먼저!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}도 노배럭더블! 미러 매치입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '양측 모두 노배럭더블! 초반 교전 없이 자원 싸움이 될 전망입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크업 (lines 14-30)
    ScriptPhase(
      name: 'tech_up',
      startLine: 14,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 시즈 탱크를 노립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리! 머신샵 부착합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
          altText: '{home}, 탱크가 나옵니다! 시즈모드 연구!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크! 양측 탱크 동시 생산!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 증설!',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설! 탱크 더블 생산 체제!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'macro',
        ),
      ],
    ),
    // Phase 2: 탱크 라인전 (lines 35-80)
    ScriptPhase(
      name: 'tank_line_battle',
      startLine: 35,
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
              homeArmy: 5,
              homeResource: -15,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 올리지만 위치가 불리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '노배럭더블 미러! 자원은 비슷한데 탱크 배치에서 차이가 납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 드랍십을 노립니다!',
              owner: LogOwner.home,
              homeResource: -25,
              favorsStat: 'strategy',
              altText: '{home}, 스타포트! 드랍 운영으로 승부를 보겠다는 거죠!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 태워 상대 확장기지를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -5,
              awayResource: -20,
              favorsStat: 'harass',
              altText: '{home}, 탱크 드랍! 상대 일꾼이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 대응이 늦습니다! 확장기지 피해가 큽니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 양면 공격!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
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
              awayArmy: 5,
              awayResource: -15,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수도 탱크를 모으지만 물량이 부족합니다.',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '자원은 비슷한데 탱크 운영에서 차이가 벌어집니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 베슬 생산! 탱크 라인에 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              awayResource: -20,
              favorsStat: 'strategy',
              altText: '{away}, 사이언스 베슬! 디펜시브 매트릭스 준비!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인 전진! {home} 선수 방어선을 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십으로 역습을 시도하지만 터렛에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량 우위! 정면으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 탱크 라인이 압도합니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
