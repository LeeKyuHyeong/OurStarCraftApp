part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 캐리어 vs 시즈탱크 수비형
// ----------------------------------------------------------
const _pvtReaverCarrierVsTankDefense = ScenarioScript(
  id: 'pvt_reaver_carrier_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_carrier', 'pvt_reaver_shuttle', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_tank_defense', 'tvp_double', 'tvp_mine_triple', 'tvp_fd'],
  description: '리버 셔틀 + 캐리어 전환 vs 시즈탱크 터틀 수비 — 공중으로 우회하는 전략',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이와 가스를 올립니다. 안정적인 시작이네요.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 팩토리를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭에 이어 팩토리를 올립니다. 시즈탱크를 노리는 빌드죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어에 이어 로보틱스와 서포트 베이까지! 공성 유닛을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 사이버네틱스 코어와 로보틱스, 서포트 베이를 연달아 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 시즈탱크를 생산합니다! 수비적인 운영이네요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 다 테크를 올리는 모습입니다. 조용한 초반이 될 것 같습니다.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 뽑으면서 앞마당 넥서스를 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -30,
        ),
      ],
    ),
    // Phase 1: 리버 견제 vs 탱크 라인 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다! 테란 확장 기지를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 리버 셔틀 출격! 테란 앞마당으로 향합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈탱크를 시즈 모드로 전환합니다! 단단한 방어선!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 리버 스카랩이 터렛 옆 일꾼을 강타합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 스카랩 명중! 테란 일꾼에 큰 피해를 줍니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈탱크 포격으로 리버 셔틀을 견제합니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'control',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '시즈탱크 라인이 단단합니다! 지상으로는 돌파가 어려워 보이네요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 캐리어 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트 2개를 건설합니다! 캐리어 전환!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타게이트가 2개 올라갑니다! 공중 전력으로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛을 추가로 건설하고 확장 기지를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 완성! 캐리어 생산이 시작됩니다!',
          owner: LogOwner.home,
          homeResource: -30,
          homeArmy: 3,
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 섞기 시작합니다. 대공이 필요하다고 판단했나요?',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          altText: '{away}, 골리앗을 생산합니다! 캐리어를 의식한 대응이죠.',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '캐리어가 나오면 시즈탱크 라인을 무시하고 위에서 공격할 수 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 캐리어가 탱크 라인 우회 → 홈 승리
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어가 시즈탱크 위를 날아갑니다! 탱크가 올려다볼 수만 있습니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'strategy',
              altText: '{home}, 캐리어 편대가 시즈탱크 라인을 완전히 무시합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버까지 셔틀로 뒤쪽을 공격합니다! 앞뒤에서 협공!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 부족합니다! 인터셉터를 막을 수가 없어요!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '시즈탱크는 공중 유닛을 공격할 수 없습니다! 완벽한 상성 카운터!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 함대가 테란 기지를 유린합니다! 탱크 수비가 무의미합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 캐리어 인터셉터가 쏟아집니다! 테란은 속수무책!',
            ),
          ],
        ),
        // 분기 B: 탱크 라인이 확장 차단 → 어웨이 승리
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 프로토스 앞마당을 포격합니다! 넥서스가 위험합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              homeResource: -20,
              favorsStat: 'attack',
              altText: '{away}, 시즈탱크 포격! 프로토스 확장을 압박합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어가 아직 완성되지 않았습니다! 시간이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 시즈탱크와 벌처가 합류합니다! 라인이 밀립니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '프로토스가 캐리어를 완성하기 전에 테란이 밀어붙이고 있습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크 라인이 프로토스 본진까지 도달합니다! 적 함대는 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 탱크 푸시 성공! 프로토스를 캐리어 전환 전에 끝냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
