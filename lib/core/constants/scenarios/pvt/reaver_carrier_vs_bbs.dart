part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 캐리어 vs BBS 마린 러시
// ----------------------------------------------------------
const _pvtReaverCarrierVsBbs = ScenarioScript(
  id: 'pvt_reaver_carrier_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_carrier', 'pvt_reaver_shuttle', 'pvt_carrier'],
  awayBuildIds: ['tvp_bbs'],
  description: '리버 셔틀 + 캐리어 전환 vs BBS 마린 러시 — 초반 생존이 관건',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다. 파일런 옆에 올리네요.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 첫 게이트웨이가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 배럭을 건설합니다! 공격적인 위치입니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 테크를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라가면서 드라군 생산을 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 본진에도 배럭을 건설합니다! BBS 확정입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 두 번째 배럭! BBS 빌드입니다!',
        ),
        ScriptEvent(
          text: '테란이 BBS를 선택했습니다! 프로토스는 초반 수비가 매우 중요하겠네요.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 생산합니다! 수비 병력이 필요합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: BBS 러시 방어 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 마린 6기와 SCV를 끌고 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 마린 물량을 모아서 돌진합니다! SCV도 함께!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 입구를 막습니다! 프로브도 동원하네요!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -5,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 드라군을 집중 사격합니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{away}, 마린 집중 사격! 드라군 체력이 빠르게 줍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 드라군이 나옵니다! 게이트웨이에서 계속 생산 중!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'macro',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: 'BBS 러시를 막느냐 못 막느냐! 이 경기의 분수령입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 리버 + 캐리어 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이 건설! 리버를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스와 서포트 베이가 올라갑니다! 리버 생산을 향한 첫걸음!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 올립니다. 뒤늦게 테크를 전환하네요.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀과 리버가 나옵니다! 테란 본진을 노리겠습니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 리버 셔틀 완성! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트까지 건설합니다! 캐리어 전환을 노리는군요!',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '프로토스가 BBS를 버텨냈습니다! 이제 리버 캐리어 조합이 나오면 테란은 답이 없습니다!',
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
        // 분기 A: 리버 견제 + 캐리어 완성 → 홈 승리
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 리버가 테란 본진에 스카랩을 발사합니다! 일꾼이 날아갑니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -30,
              favorsStat: 'harass',
              altText: '{home}, 리버 스카랩! 테란 일꾼에 직격탄입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 플릿 비콘 완성! 캐리어 생산에 들어갑니다!',
              owner: LogOwner.home,
              homeResource: -30,
              homeArmy: 3,
            ),
            ScriptEvent(
              text: '{away} 선수 마린만으로는 캐리어를 상대할 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '캐리어의 인터셉터가 테란 병력을 녹이고 있습니다! BBS의 한계가 드러납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 편대가 테란 본진을 덮칩니다! 마린으로는 답이 없습니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 캐리어 함대 완성! 테란 기지를 초토화합니다!',
            ),
          ],
        ),
        // 분기 B: BBS 피해 누적 → 어웨이 승리
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린이 계속 밀어붙입니다! 프로브 피해가 심각합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              homeResource: -20,
              favorsStat: 'attack',
              altText: '{away}, 마린 공세가 계속됩니다! 프로토스 일꾼이 줄고 있어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 로보틱스를 올렸지만 자원이 부족합니다!',
              owner: LogOwner.home,
              homeResource: -15,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 마린이 계속 합류합니다! 배럭 2개의 생산력!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '프로토스가 테크를 올리기도 전에 무너지고 있습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 물량으로 프로토스 본진을 짓밟습니다! 적 함대는 꿈도 못 꿨습니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, BBS 완벽한 성공! 프로토스를 초반에 끝냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
