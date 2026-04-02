part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs 5팩 물량
// ----------------------------------------------------------
const _pvt5gatePushVs5facMass = ScenarioScript(
  id: 'pvt_5gate_push_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_1gate_expand'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '5게이트 드라군+질럿 vs 5팩토리 메카닉 물량 — PvT 정석 대결',
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
          text: '{away} 선수 배럭 건설 후 팩토리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에 팩토리! 메카닉 물량을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산! 게이트웨이를 늘려갑니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2번째, 3번째까지!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리가 늘어납니다! 5팩을 향해!',
        ),
        ScriptEvent(
          text: '게이트웨이 물량 vs 팩토리 물량! PvT의 정석 대결 구도입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 3개 완성!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 양쪽 물량 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔을 올립니다! 질럿 스피드 연구!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아둔 건설! 스피드 질럿을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 4번째, 5번째 팩토리가 올라갑니다! 5팩 완성!',
          owner: LogOwner.away,
          awayResource: -25,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 5게이트 완성! 드라군과 질럿을 풀가동합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          altText: '{home}, 5게이트 가동! 생산 속도가 폭발합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩에서 탱크와 벌처가 쏟아집니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '5게이트 vs 5팩! 생산력 싸움입니다! 누가 더 많이 뽑느냐!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 물량 충돌 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스피드 질럿 연구 완료! 드라군과 함께 대군을 형성합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크가 라인을 형성합니다! 벌처가 전방에!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 탱크 벌처 라인! 5팩의 물량이 대단합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 전군 전진! 드라군이 전진합니다! 상대 병력이 더 모이기 전에 가야 합니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 전군 전진! 5게이트 타이밍!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인을 매설합니다! 질럿 접근을 차단합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5게이트 vs 5팩! 최종 결전이 시작됩니다!',
          owner: LogOwner.system,
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
              text: '{home} 선수 스피드 질럿이 벌처를 잡고 탱크에 돌진합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 질럿이 탱크에 달라붙습니다! 시즈 모드 탱크가 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 아군 벌처를 같이 맞힙니다! 시즈 탱크의 단점!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 남은 탱크를 마무리합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5게이트가 5팩을 뚫었습니다! 게이트웨이 물량의 승리!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트 물량으로 5팩 메카닉을 분쇄합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 5게이트 타이밍! 5팩 물량을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 집중 포격! 상대 병력이 접근도 못 합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -5,
              favorsStat: 'defense',
              altText: '{away}, 탱크가 포격합니다! 상대 병력이 사정거리 밖에서 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 마인에 걸립니다! 접근 자체가 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 프로토스 확장을 급습합니다! 프로브 피해!',
              owner: LogOwner.away,
              homeResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '5팩 물량이 5게이트를 압도합니다! 메카닉의 화력 차이!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 5팩 메카닉 대군으로 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 5팩 물량! 게이트웨이 병력으로는 감당 불가!',
            ),
          ],
        ),
      ],
    ),
  ],
);
