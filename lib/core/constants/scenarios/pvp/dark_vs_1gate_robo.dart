part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 원게이트 로보
// ----------------------------------------------------------
const _pvpDarkVs1gateRobo = ScenarioScript(
  id: 'pvp_dark_vs_1gate_robo',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_1gate_robo'],
  description: '다크 올인 vs 원게이트 로보',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home}, 아둔으로 갑니다! 다크를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 로보틱스를 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 옵저버를 생산할 수 있습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 로보틱스! 옵저버가 나오면 다크를 잡을 수 있어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대 진영으로 출발!',
          owner: LogOwner.home,
          awayResource: 0,
          homeArmy: 3, awayArmy: 2, homeResource: -20,
          altText: '{home}, 다크 출격! 로보틱스가 있으면 위험합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스에서 옵저버를 생산 중입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '로보틱스가 있다면 옵저버로 다크를 잡을 수 있습니다! 타이밍이 관건!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-36)
    ScriptPhase(
      name: 'dark_result',
      branches: [
        // 분기 A: 옵저버가 늦게 나와 다크 성공
        ScriptBranch(
          id: 'dark_before_observer',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 먼저 도착합니다! 옵저버가 아직입니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -25,              altText: '{home} 선수 다크 타이밍! 옵저버보다 빨랐습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 아직 생산 중! 프로브가 잡힙니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 프로브를 학살합니다! 옵저버가 나와도 이미 늦었어요!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,            ),
            ScriptEvent(
              text: '다크 올인 성공! 옵저버보다 빨랐습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 옵저버가 제때 나와 다크 차단
        ScriptBranch(
          id: 'observer_ready',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{away} 선수 옵저버가 딱 맞춰 나옵니다! 다크가 보입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 2,              altText: '{away}, 옵저버! 다크를 완벽하게 포착합니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 다크를 집중 사격! 한 기 격파!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,            ),
            ScriptEvent(
              text: '{home} 선수 다크가 막혔습니다! 로보틱스 빌드 상대로는 힘듭니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 셔틀 리버까지 준비합니다! 다크 올인 완전 실패!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 3,
            ),
            ScriptEvent(
              text: '로보틱스의 옵저버가 다크를 완벽히 차단! 역전입니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
