part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩더블 vs 노배럭더블
// 둘 다 수비형이지만 노배럭더블이 자원 더 빠르고, 원팩더블은 병력 먼저
// ----------------------------------------------------------
const _tvt1facDoubleVsNobarDouble = ScenarioScript(
  id: 'tvt_1fac_double_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_double'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '원팩더블 vs 노배럭더블 - 수비형 미러',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리! 원팩더블입니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 없이 앞마당 커맨드센터!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, CC퍼스트! 노배럭더블!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 먼저 나옵니다! 앞마당 확장!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -55,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭, 팩토리 건설! 탱크는 한 템포 늦습니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '양측 모두 수비형! 장기전이 예상됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 (lines 18-35)
    ScriptPhase(
      name: 'mid_game',
      startLine: 18,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 더블 자원 가동! 일꾼이 빠르게 늘어납니다!',
          owner: LogOwner.away,
          awayResource: 15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 추가 생산! 방어선 구축!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산 시작! 물량이 빠르게 따라옵니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 팩토리 증설!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설! 탱크 더블 생산!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'macro',
        ),
      ],
    ),
    // Phase 2: 탱크 라인전 (lines 40-80)
    ScriptPhase(
      name: 'tank_line',
      startLine: 40,
      branches: [
        ScriptBranch(
          id: 'nobar_resource_wins',
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 더블 자원 효과! 탱크가 더 빠르게 모입니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 물량이 밀리기 시작합니다.',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 베슬까지 생산! 디펜시브 매트릭스!',
              owner: LogOwner.away,
              awayArmy: 2,
              awayResource: -20,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '자원 우위가 결정적! 탱크 수에서 점점 벌어집니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인 전진! 물량으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'fac_double_tech_wins',
          conditionStat: 'strategy',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 견제로 상대 확장기지 일꾼을 노립니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트에서 드랍십! 탱크를 태웁니다!',
              owner: LogOwner.home,
              homeResource: -25,
              favorsStat: 'strategy',
              altText: '{home}, 드랍십! 탱크 드랍으로 후방을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 드랍! 상대 확장기지에 시즈!',
              owner: LogOwner.home,
              awayArmy: -3,
              awayResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 대응이 늦습니다! 일꾼 피해 심각!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '드랍 견제로 자원 우위가 역전됐습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 정면+드랍 양면 공격! 상대를 무너뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
