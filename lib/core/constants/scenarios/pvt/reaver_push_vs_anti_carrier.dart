part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 푸시 vs 골리앗 대공: 리버 지상 푸시 vs 골리앗 진형
// ----------------------------------------------------------
const _pvtReaverPushVsAntiCarrier = ScenarioScript(
  id: 'pvt_reaver_push_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_push', 'pvt_reaver_shuttle', 'pvt_proxy_dark'],
  awayBuildIds: ['tvp_trans_anti_carrier', 'tvp_anti_carrier'],
  description: '리버 셔틀 푸시 vs 골리앗 대공 — 지상전 승부',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 이후 로보틱스와 서포트 베이를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 골리앗 생산을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          altText: '{away}, 골리앗이 나옵니다! 대공 빌드를 선택했군요!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 앞에 배치하고 정찰합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올리면서 골리앗 레인지 업그레이드를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 사거리 업을 노리네요!',
        ),
        ScriptEvent(
          text: '골리앗 대공 빌드입니다! 셔틀 접근이 쉽지 않겠군요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 셔틀 운용 어려움 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버가 출발하지만 골리앗이 보입니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 곳곳에 배치합니다! 셔틀 접근이 힘듭니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'defense',
          altText: '{away}, 골리앗이 여기저기! 셔틀이 갈 곳이 없어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀을 빠르게 빼고 지상으로 리버를 운용합니다!',
          owner: LogOwner.home,
          favorsStat: 'strategy',
          altText: '{home}, 셔틀을 포기하고 리버를 지상에서 밀어넣습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 리버를 호위하면서 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '셔틀 드랍이 어려우니 지상 리버 푸시로 전환했습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 지상 교전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 리버가 지상에서 스캐럽을 발사합니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗이 드라군과 정면 교전을 벌입니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -1,
          favorsStat: 'attack',
          altText: '{away}, 골리앗이 상대와 사거리 싸움이 시작됩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 리버를 보호하면서 밀어냅니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '지상 교전이 벌어지고 있습니다! 스캐럽 명중률이 관건이죠!',
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
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 스캐럽이 골리앗 뭉치에 명중합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home}, 스캐럽 한 방에 골리앗이 2기 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 빠르게 줄어듭니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 남은 병력을 쓸어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '지상 리버 푸시가 골리앗을 꺾었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗이 리버 사거리 밖에서 집중 사격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 골리앗 사거리 업이 빛을 발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 파괴됩니다! 드라군만 남았습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 대부대가 밀고 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '골리앗 물량에 프로토스가 밀립니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
