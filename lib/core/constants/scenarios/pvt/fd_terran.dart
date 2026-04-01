part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 11. FD테란 vs 프로토스 (밸런스 운영전)
// ----------------------------------------------------------
const _pvtFdTerran = ScenarioScript(
  id: 'pvt_fd_terran',
  matchup: 'PvT',
  homeBuildIds: ['pvt_1gate_expand', 'pvt_1gate_obs', 'pvt_reaver_shuttle',
                 'pvt_trans_reaver_arbiter', 'pvt_trans_5gate_push'],
  awayBuildIds: ['tvp_fd',
                 'tvp_trans_bio_mech', 'tvp_trans_upgrade'],
  description: 'FD테란 vs 프로토스 밸런스 운영전',
  phases: [
    // Phase 0: 오프닝 (lines 1-18)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 파일런 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설! 가스도 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 가스 채취 시작합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 드라군 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵 건설! 벌처를 뽑으면서 앞마당을 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리 머신샵에 앞마당까지! FD테란 오프닝!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작! 사거리 업그레이드!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 드라군과 사업! 안정적인 오프닝!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! FD 체제!',
        ),
      ],
    ),
    // Phase 1: FD 전개 (lines 19-30)
    ScriptPhase(
      name: 'fd_deployment',
      startLine: 19,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 벌처 생산하면서 스타포트에 컨트롤타워 건설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 스타포트에 컨트롤타워! 드랍십 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스 건설! 양측 모두 확장을 올립니다!',
        ),
        ScriptEvent(
          text: '{away}, 벌처가 마인을 뿌리면서 영역을 확보합니다.',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{away} 선수 마인 매설! 프로토스 이동을 제한!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 옵저버터리에 서포트 베이도 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스에 옵저버터리, 서포트 베이 건설! 옵저버 생산!',
        ),
        ScriptEvent(
          text: '양측 모두 내정을 다지면서 중반을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 벌처 견제 vs 드라군 방어 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'vulture_vs_dragoon',
      startLine: 31,
      branches: [
        // 분기 A: 벌처 견제 성공
        ScriptBranch(
          id: 'vulture_harass_success',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벌처가 프로토스 멀티로 돌진! 마인 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 벌처가 기동! 마인으로 일꾼을 타격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브 피해! 대응이 늦었습니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 드랍십 건설! 탱크 드랍을 준비합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20,
              altText: '{away} 선수 스타포트에서 드랍십! 견제를 이어갑니다!',
            ),
            ScriptEvent(
              text: '벌처 견제가 프로토스 내정을 흔들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 드라군 방어 성공
        ScriptBranch(
          id: 'dragoon_defense',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드라군이 벌처를 잡아냅니다! 사거리가 깁니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home}, 드라군으로 벌처를 격퇴! 견제를 막았습니다!',
            ),
            ScriptEvent(
              text: '{home}, 옵저버로 마인 위치까지 확인! 안전하게 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 손실! 견제가 실패했습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '프로토스가 벌처 견제를 막아내며 안정적으로 운영합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드랍 & 리버 견제전 (lines 45-58)
    ScriptPhase(
      name: 'drop_harass',
      startLine: 45,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드랍십에 탱크를 태웁니다! 프로토스 뒷마당을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20, favorsStat: 'strategy',
          altText: '{away}, 탱크 드랍! 프로토스 뒤를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다! 맞견제!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'harass',
          altText: '{home}, 셔틀 리버 출격! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 탱크 드랍 투하! SCV가 뒤를 돌지만!',
          owner: LogOwner.away,
          homeResource: -15,
          skipChance: 0.3,
          altText: '{away} 선수 탱크가 프로토스 멀티에 내려갑니다!',
        ),
        ScriptEvent(
          text: '{home}, 리버 스캐럽! SCV에 명중!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{home} 선수 스캐럽이 대박! 테란 일꾼을 초토화합니다!',
        ),
        ScriptEvent(
          text: '양측 견제가 동시에 진행됩니다! 멀티태스킹 대결!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 59-75)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 59,
      branches: [
        // 분기 A: 프로토스 아비터 리콜
        ScriptBranch(
          id: 'protoss_arbiter_recall',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타게이트 건설! 아둔에 템플러 아카이브, 아비터 트리뷰널까지 올립니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스타게이트에 아비터 트리뷰널! 리콜을 노리는 건가요?',
            ),
            ScriptEvent(
              text: '{home}, 아비터 등장! 리콜로 테란 본진에 병력을 떨어뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayResource: -25, favorsStat: 'sense',
              altText: '{home} 선수 리콜 투하! 테란 본진이 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비! 탱크를 급히 돌립니다!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드라군이 앞마당도 동시 공격! 테란이 갈리고 있습니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '아비터 리콜이 판을 뒤집습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 테란 대규모 푸시
        ScriptBranch(
          id: 'terran_fd_push',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 사이언스 퍼실리티 건설! 사이언스베슬 생산!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 사이언스 퍼실리티에서 사이언스베슬이 나옵니다! EMP 준비!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크 라인 전진! 베슬과 함께!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -25, favorsStat: 'attack',
              altText: '{away} 선수 대규모 푸시! 탱크 베슬 편대!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 맞서지만 시즈 화력이 강합니다!',
              owner: LogOwner.home,
              homeArmy: -5, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, EMP! 프로토스 실드가 사라집니다!',
              owner: LogOwner.away,
              homeArmy: -6, favorsStat: 'strategy',
              altText: '{away} 선수 EMP 명중! 쉴드가 벗겨집니다!',
            ),
            ScriptEvent(
              text: 'FD테란의 화력이 프로토스를 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
