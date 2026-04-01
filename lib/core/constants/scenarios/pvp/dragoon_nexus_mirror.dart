part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 1. 원겟 드라군 넥서스 미러 (가장 대표적인 PvP)
// ----------------------------------------------------------
const _pvpDragoonNexusMirror = ScenarioScript(
  id: 'pvp_dragoon_nexus_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_dragoon'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '원겟 드라군 넥서스 미러',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 파일런 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작! 사거리 업그레이드!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 드라군이 나옵니다! 사업 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 생산! 사업 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 초반 질럿/드라군 교전 (lines 17-26)
    ScriptPhase(
      name: 'early_skirmish',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 한 기로 상대를 정찰합니다!',
          owner: LogOwner.home,
          favorsStat: 'scout',
          altText: '{home}, 질럿 정찰! 상대 빌드를 확인하러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 질럿으로 정찰!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 확장! 드라군으로 커버하면서!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '양측 모두 확장을 올립니다! 빌드가 동일한데요, 운영 싸움이 중요하겠습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 테크 분기 (lines 27-42)
    ScriptPhase(
      name: 'tech_choice',
      startLine: 27,
      branches: [
        // 분기 A: 로보틱스 (리버)
        ScriptBranch(
          id: 'home_robo_away_dark',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 로보틱스 건설! 서포트 베이까지 이어갑니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 로보틱스에 서포트 베이! 리버를 노리는 건가요?',
            ),
            ScriptEvent(
              text: '{away} 선수 아둔 건설! 질럿 발업을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 아둔! 하이 템플러를 준비하는 건가요?',
            ),
            ScriptEvent(
              text: '{home}, 옵저버터리도 완성! 옵저버를 먼저 뽑을까 리버를 먼저 뽑을까?',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
            ScriptEvent(
              text: '{home} 선수 리버를 먼저 생산! 공격적인 선택입니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -15, favorsStat: 'harass',
              altText: '{home}, 리버 먼저! 견제를 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 그런데 다크 템플러가 잠입합니다! 디텍이 없습니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 B: 양쪽 로보틱스
        ScriptBranch(
          id: 'double_robo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 로보틱스에 서포트 베이 건설!',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수도 로보틱스에 서포트 베이 건설! 셔틀 리버 경쟁!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 셔틀에 리버를 태웁니다! 견제 출발!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 셔틀 리버 출격!',
            ),
            ScriptEvent(
              text: '{away} 선수도 셔틀 리버 출격! 서로 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25,
            ),
            ScriptEvent(
              text: '양측 셔틀 리버가 교차합니다! PvP의 꽃입니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 셔틀 리버 교전 (lines 43-58)
    ScriptPhase(
      name: 'shuttle_reaver_battle',
      startLine: 43,
      branches: [
        // 분기 A: 셔틀 리버 견제 성공
        ScriptBranch(
          id: 'reaver_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 셔틀이 상대 프로브에 리버를 내립니다! 스캐럽!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 리버 투하! 프로브가 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 크네요! 드라군이 달려옵니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 셔틀이 리버를 태우고 안전하게 빠집니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home} 선수 셔틀 컨트롤! 리버를 살립니다!',
            ),
            ScriptEvent(
              text: '리버 견제가 성공! 프로브 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 셔틀 격추
        ScriptBranch(
          id: 'shuttle_shot_down',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 상대 수송선을 집중 사격합니다! 격추!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 드라군 집중 사격! 수송선이 격추됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 셔틀이 떨어집니다! 리버가 고립!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 셔틀 폭사! 리버도 잃을 위기!',
            ),
            ScriptEvent(
              text: '{away}, 고립된 유닛을 잡아냅니다! 드라군 화력!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '셔틀 격추! PvP에서 가장 뼈아픈 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 하이 템플러 준비 (lines 59-66)
    ScriptPhase(
      name: 'ht_prepare',
      startLine: 59,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 하이 템플러가 나왔습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 연구 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 질럿 하이 템플러! 전면전입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 5: 결전 분기 (lines 67-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 67,
      branches: [
        ScriptBranch(
          id: 'home_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 상대 드라군 편대에 떨어집니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 투하! 드라군이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away}, 맞스톰! 하지만 타이밍이 늦었습니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3,
              altText: '{away} 선수도 스톰! 하지만 이미 병력이 부족합니다!',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 상대 드라군 편대에 떨어집니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 드라군이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 맞스톰! 하지만 타이밍이 늦었습니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3,
              altText: '{home} 선수도 스톰! 하지만 이미 병력이 부족합니다!',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

