part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 투게이트 드라군
// ----------------------------------------------------------
const _pvpDarkVs2gateDragoon = ScenarioScript(
  id: 'pvp_dark_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '다크 올인 vs 투게이트 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크로 갑니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크를 준비하는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 사업!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가합니다! 투게이트 드라군!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15,
          altText: '{away}, 게이트웨이 추가! 드라군을 빠르게 모읍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 템플러 아카이브! 다크 올인입니다!',
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대 진영으로!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 다크 2기 출발! 보이지 않는 칼!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 뽑고 있습니다. 디텍이 있을까요?',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '다크 템플러가 접근합니다! 디텍 여부가 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-36)
    ScriptPhase(
      name: 'dark_result',
      startLine: 23,
      branches: [
        ScriptBranch(
          id: 'dark_massacre',
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 프로브를 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 다크 성공! 프로브가 몰살당합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군으로 다크를 쫓지만 보이지 않습니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 디텍이 없습니다! 다크를 막을 수 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 다크가 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 올인 대성공! 투게이트 드라군의 일꾼이 파괴됐습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'dark_blocked',
          baseProbability: 1.45,
          events: [
            ScriptEvent(
              text: '{away} 선수 로보틱스에 옵저버터리까지 건설! 디텍 준비 완료!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'scout',
              altText: '{away}, 로보틱스와 옵저버터리! 옵저버가 나옵니다! 다크가 보여요!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 다크를 집중 사격! 격파!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 다크를 잡아냅니다! 완벽한 대응!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 막혔습니다! 올인이 실패하면 위기!',
              owner: LogOwner.home,
              homeResource: -15, homeArmy: -2,
            ),
            ScriptEvent(
              text: '다크 올인이 막혔습니다! 드라군 물량 앞에 속수무책!',
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
