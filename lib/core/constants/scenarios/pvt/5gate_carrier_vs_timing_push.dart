part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 타이밍 푸시
// ----------------------------------------------------------
const _pvt5gateCarrierVsTimingPush = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier'],
  awayBuildIds: ['tvp_trans_timing_push'],
  description: '5게이트 캐리어 vs 타이밍 푸시 — 캐리어 전 치명적 방어 국면',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설 후 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에서 팩토리! 더블 팩토리 체제를 갖춥니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 더블 팩토리! 빠른 타이밍 공격 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다. 자원 확보가 우선이네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처와 탱크를 빠르게 모으고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 벌처 탱크 생산! 타이밍 공격을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가! 드라군으로 방어를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 타이밍 공격을 준비합니다. 프로토스가 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 타이밍 공격 개시! 벌처 탱크가 프로토스로 향합니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
          altText: '{away}, 총공격! 벌처 탱크 편대가 밀려옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 탱크 사거리 밖에서 교전합니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -2, favorsStat: 'control',
          altText: '{home}, 드라군 사거리를 활용합니다! 탱크 밖에서 포격!',
        ),
        ScriptEvent(
          text: '{away}, 시즈 탱크 배치! 프로토스 앞마당을 포격합니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿으로 벌처를 끊으며 시간을 법니다!',
          owner: LogOwner.home,
          awayArmy: -2, homeArmy: -1, favorsStat: 'defense',
          altText: '{home}, 질럿이 벌처를 잡습니다! 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '프로토스가 타이밍을 버텨야 캐리어까지 갈 수 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 플릿 비콘도 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 스타게이트에 플릿 비콘! 캐리어 테크를 급하게 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 2차 공격을 위해 병력을 모읍니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 병력 재정비! 2차 공격을 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 더블 스타게이트에서 캐리어 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -30,
          altText: '{home}, 캐리어 생산 돌입! 인터셉터를 채워야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이에서 드라군을 계속 보충합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어 편대 완성! 인터셉터가 가득합니다!',
              owner: LogOwner.home,
              homeArmy: 5, favorsStat: 'macro',
              altText: '{home}, 캐리어가 드디어 나옵니다! 풀 인터셉터!',
            ),
            ScriptEvent(
              text: '{home}, 캐리어가 테란 병력 위를 날아갑니다! 탱크가 공중을 못 치죠!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 캐리어 인터셉터가 쏟아집니다! 탱크가 무용지물!',
            ),
            ScriptEvent(
              text: '{away} 선수 대공 유닛이 부족합니다! 캐리어를 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '타이밍을 넘기고 캐리어 완성! 프로토스의 후반 지배!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 2차 타이밍 공격! 캐리어가 나오기 전에 밀어야 합니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
              altText: '{away}, 지금 밀어야 합니다! 캐리어 전에 끝내야 해요!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크가 스타게이트를 직접 포격합니다! 캐리어 생산 중단!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 인터셉터가 아직 부족합니다! 반도 못 채웠어요!',
              owner: LogOwner.home,
              homeArmy: -4, awayArmy: -2,
              altText: '{home}, 캐리어가 완성되지 못합니다! 인터셉터 부족!',
            ),
            ScriptEvent(
              text: '캐리어 완성 전에 밀어냅니다! 타이밍의 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
