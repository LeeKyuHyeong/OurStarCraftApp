part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 캐리어 vs 바이오 메카닉
// ----------------------------------------------------------
const _pvtReaverCarrierVsBioMech = ScenarioScript(
  id: 'pvt_reaver_carrier_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_carrier', 'pvt_reaver_shuttle', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_bar_double'],
  description: '리버 셔틀 + 캐리어 전환 vs 마린 탱크 골리앗 — 분산 공격 vs 복합 편성',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이와 가스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에서 마린을 뽑으면서 팩토리를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 1,
          awayResource: -20,
          altText: '{away}, 배럭과 팩토리를 동시에 가동합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다. 드라군 생산 임박!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭을 추가합니다. 마린과 메딕을 함께 뽑겠다는 거죠.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란이 바이오닉과 메카닉을 섞는 복합 편성을 준비하고 있습니다.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          homeArmy: 2,
        ),
      ],
    ),
    // Phase 1: 리버 견제 vs 바이오 압박 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이에서 셔틀과 리버를 뽑습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          altText: '{home}, 서포트 베이 완성! 리버 셔틀 조합으로 테란 뒤를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 시즈탱크 조합으로 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 리버를 테란 본진에 투하합니다! 스카랩이 마린을 강타!',
          owner: LogOwner.home,
          awayArmy: -2,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 리버 드랍! 테란 본진 일꾼에 스카랩 직격!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 섞기 시작합니다! 대공 준비에 들어가네요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '리버의 견제가 효과적입니다! 하지만 테란의 복합 편성도 만만치 않죠.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 캐리어 전환 vs 골리앗 추가 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트를 건설합니다! 캐리어 전환을 준비하네요!',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리에서 골리앗 사정거리 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 골리앗 레인지 업! 대공 사정거리가 늘어납니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘까지 건설합니다! 캐리어 생산 준비 완료!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -30,
          altText: '{home}, 플릿 비콘이 완성됩니다! 캐리어 시대가 열립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 탱크 골리앗의 삼각 편성이 완성되어 갑니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '캐리어가 나오면 강력하지만, 골리앗의 대공 사격도 무시할 수 없습니다!',
          owner: LogOwner.system,
          skipChance: 0.25,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 캐리어 + 리버 양면 → 홈 승리
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어가 전선에 나타납니다! 인터셉터가 마린을 녹입니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'macro',
              altText: '{home}, 캐리어 등장! 인터셉터가 바이오닉 병력을 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 지상에서 동시 공격! 탱크 라인을 흔듭니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              awayResource: -15,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 쏘지만 수가 부족합니다!',
              owner: LogOwner.away,
              homeArmy: -1,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '하늘에서는 캐리어, 땅에서는 리버! 테란이 양면을 동시에 막을 수 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어와 리버의 협공! 테란 진영이 초토화됩니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 공중과 지상의 이중 타격! 테란이 무너집니다!',
            ),
          ],
        ),
        // 분기 B: 복합 편성이 캐리어를 잡음 → 어웨이 승리
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 집중 사격합니다! 사정거리 업그레이드가 빛을 발합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'control',
              altText: '{away}, 골리앗 집중 사격! 캐리어 실드가 깎여나갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 리버 셔틀을 포격합니다! 셔틀이 터집니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 마린 메딕이 지상 병력을 정리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '마린 탱크 골리앗 복합 편성! 공중도 지상도 다 잡습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크 골리앗이 프로토스를 압도합니다! 캐리어도 리버도 막힙니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 복합 편성의 완승! 프로토스 전력을 완전히 분쇄합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
