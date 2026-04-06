part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 투게이트 리버
// ----------------------------------------------------------
const _pvpDarkVs2gateReaver = ScenarioScript(
  id: 'pvp_dark_vs_2gate_reaver',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_2gate_reaver'],
  description: '다크 올인 vs 투게이트 리버',
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
          text: '{home} 선수 아둔 건설! 다크를 노립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크 올인 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 로보틱스를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 리버를 노리는 빌드!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 로보틱스! 옵저버와 리버를 모두 쓸 수 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 리버 빌드 상대에게 다크!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: 2, homeResource: -20,
          altText: '{home}, 다크 출격! 로보틱스가 있으면 옵저버가 위험!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스에서 옵저버를 생산합니다! 리버도 준비!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '로보틱스 빌드라 옵저버가 있을 가능성이 높습니다! 다크가 통할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'dark_result',
      startLine: 23,
      branches: [
        // 분기 A: 옵저버가 늦어 다크 일부 성공
        ScriptBranch(
          id: 'dark_partial_success',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 먼저 도착합니다! 옵저버보다 빨랐어요!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 다크 타이밍! 리버 생산에 집중하느라 옵저버가 늦었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 뒤늦게 나옵니다! 프로브 피해가 있습니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 프로브를 잡고 후퇴합니다! 다크 피해가 컸습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 올인 부분 성공! 리버가 나오기 전에 자원 타격!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 옵저버로 다크 완벽 차단 + 리버 반격
        ScriptBranch(
          id: 'observer_blocks_reaver_counter',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{away} 선수 옵저버가 다크를 포착합니다! 완벽한 대응!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'scout',
              altText: '{away}, 옵저버! 다크가 보입니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 다크를 집중 사격! 격파!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀에 리버를 태웁니다! 역습 개시!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15,
              altText: '{away}, 셔틀 리버 출격! 다크 실패 후 역습!',
            ),
            ScriptEvent(
              text: '{away}, 리버가 상대 프로브를 공격합니다! 스캐럽 명중!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 실패 + 리버 반격! 완벽한 역전입니다!',
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
