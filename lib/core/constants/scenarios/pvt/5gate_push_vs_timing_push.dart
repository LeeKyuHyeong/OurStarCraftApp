part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs 타이밍 푸시
// ----------------------------------------------------------
const _pvt5gatePushVsTimingPush = ScenarioScript(
  id: 'pvt_5gate_push_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push'],
  awayBuildIds: ['tvp_trans_timing_push'],
  description: '5게이트 타이밍 vs 마린 탱크 타이밍 — 정면 충돌',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이와 사이버네틱스 코어를 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 팩토리를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭 팩토리! 빠른 타이밍 푸시를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 생산하면서 게이트웨이를 추가합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          altText: '{home}, 드라군 생산! 게이트웨이를 늘려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구! 타이밍 푸시 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 다 타이밍을 잡으려 합니다! 누가 먼저 도착하느냐 싸움입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 3개 완성!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 양쪽 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 질럿 스피드를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아둔 올립니다! 질럿 다리!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 탱크를 모읍니다! 푸시 타이밍이 다가옵니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 4번째 게이트웨이 건설! 5게이트를 향해!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 마린 탱크 부대가 전진합니다! 타이밍 푸시 시작!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'attack',
          altText: '{away}, 마린 탱크 전진! 프로토스 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '테란 타이밍과 프로토스 5게이트! 시간 싸움이 치열합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 충돌 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 5게이트 완성! 드라군과 질럿이 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 5게이트 가동! 병력이 폭발적으로 늘어납니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 모드로 전환! 포격 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 스피드 질럿이 완성됩니다! 빠른 질럿과 드라군!',
          owner: LogOwner.home,
          homeArmy: 2,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 병력이 합류합니다! 마린 메딕 탱크 편성!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          altText: '{away}, 마린 메딕 탱크! 정면 전투 편성 완료!',
        ),
        ScriptEvent(
          text: '양쪽 타이밍이 겹칩니다! 정면 충돌이 불가피합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스피드 질럿이 탱크를 먼저 덮칩니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 질럿이 탱크에 달라붙습니다! 시즈 모드 해제 불가!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 질럿을 쏘지만 드라군이 마린을 잡습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트 물량이 계속 합류합니다! 끊이지 않는 생산!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '5게이트 생산력! 한 번의 교전으로 끝나지 않습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트 물량으로 타이밍 푸시를 분쇄합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 5게이트 타이밍 승리! 테란 푸시를 역으로 깨부숩니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 포격이 드라군 무리에 직격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -5,
              favorsStat: 'attack',
              altText: '{away}, 탱크 포격! 드라군이 뭉쳐 있다가 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 마린에 막힙니다! 스팀팩 마린 화력!',
              owner: LogOwner.home,
              homeArmy: -3,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 전진합니다! 탱크 엄호 아래 밀어붙입니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '타이밍 푸시가 5게이트를 뚫었습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크로 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 타이밍 푸시 성공! 5게이트 완성 전에 끝냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
