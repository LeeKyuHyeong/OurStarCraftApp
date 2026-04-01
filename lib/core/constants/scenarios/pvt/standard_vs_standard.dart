part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4. 프로토스 스탠다드 vs 테란 스탠다드 (오프닝 매칭 + 트랜지션 분기)
// 기존 dragoon_expand, 5gate_push, mine_triple, 11up_8fac, fd_terran 통합
// ----------------------------------------------------------
const _pvtStandardVsStandard = ScenarioScript(
  id: 'pvt_standard_vs_standard',
  matchup: 'PvT',
  homeBuildIds: [
    'pvt_1gate_expand', 'pvt_1gate_obs',
    'pvt_trans_5gate_push', 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier',
    'pvt_trans_reaver_push', 'pvt_trans_reaver_arbiter', 'pvt_trans_reaver_carrier',
  ],
  awayBuildIds: [
    'tvp_double', 'tvp_rax_double', 'tvp_fd',
    'tvp_mine_triple', 'tvp_1fac_gosu', 'tvp_11up_8fac',
    'tvp_trans_tank_defense', 'tvp_trans_upgrade', 'tvp_trans_bio_mech',
    'tvp_trans_5fac_mass', 'tvp_trans_timing_push', 'tvp_trans_anti_carrier',
  ],
  description: '프로토스 스탠다드 vs 테란 스탠다드 (트랜지션 분기)',
  phases: [
    // ============================================================
    // Phase 0: 공통 오프닝 (lines 1-16)
    // ============================================================
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
          altText: '{home}, 게이트웨이가 올라갑니다!',
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
          altText: '{home}, 사이버네틱스 코어가 올라갑니다! 드라군 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다. 머신샵도 붙입니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -20,
          altText: '{away}, 팩토리에 머신샵까지! 탱크 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작! 사거리 업그레이드도 들어갑니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 첫 드라군이 나옵니다! 사업 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 넥서스가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 커맨드센터 건설! 양측 모두 확장을 올리네요.',
        ),
      ],
    ),

    // ============================================================
    // Phase 1: 전개 (lines 17-26) - 공통
    // ============================================================
    ScriptPhase(
      name: 'deployment',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 벌처 생산! 마인 업그레이드도 연구합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 벌처가 나옵니다! 마인까지 준비하고 있어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 추가 생산! 앞마당을 지킵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away}, 벌처가 프로브를 노립니다! 마인 매설!',
          owner: LogOwner.away,
          homeResource: -10, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{away} 선수 벌처 기동! 일꾼 사이에 마인을 뿌립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 옵저버터리에 서포트 베이까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스에 서포트 베이, 옵저버터리까지 올립니다!',
        ),
        ScriptEvent(
          text: '양측 모두 내정을 다지면서 중반을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),

    // ============================================================
    // Phase 2: 트랜지션 분기 (lines 27-42) - conditionBuildIds 기반
    // ============================================================
    ScriptPhase(
      name: 'transition_branch',
      startLine: 27,
      branches: [
        // --- 분기 A: 5게이트 푸시 (P trans_5gate_push) ---
        ScriptBranch(
          id: 'p_5gate_push',
          conditionHomeBuildIds: ['pvt_trans_5gate_push'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 게이트웨이를 5개까지 증설합니다! 드라군을 쏟아냅니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -25,
              altText: '{home}, 5게이트 완성! 드라군이 물밀듯이 나옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군 10기 이상! 대규모 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home}, 드라군 편대 출격! 테란 앞마당을 향합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 아직 부족합니다! 시간이 부족해요!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -15,
              altText: '{away}, 탱크가 모이기 전에 공격당합니다!',
            ),
            ScriptEvent(
              text: '5게이트 타이밍이 절묘합니다! 탱크가 모이기 전!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),

        // --- 분기 B: 5게이트 아비터 (P trans_5gate_arbiter) ---
        ScriptBranch(
          id: 'p_5gate_arbiter',
          conditionHomeBuildIds: ['pvt_trans_5gate_arbiter'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 게이트웨이 추가! 스타게이트도 건설합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25,
              altText: '{home}, 게이트 확장에 스타게이트까지! 아비터를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 트리뷰널 건설! 리콜을 준비하고 있습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 아비터 트리뷰널! 리콜 전략!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크를 모으면서 전진 준비합니다.',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
            ),
            ScriptEvent(
              text: '프로토스가 아비터 테크로 전환합니다! 리콜이 나올까요?',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),

        // --- 분기 C: 캐리어 전환 (P trans_5gate_carrier / trans_reaver_carrier) ---
        ScriptBranch(
          id: 'p_carrier_transition',
          conditionHomeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_trans_reaver_carrier'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타게이트 건설! 플릿 비콘까지 올립니다!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 스타게이트에 플릿 비콘! 캐리어를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 생산 시작! 인터셉터를 충전합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25,
              altText: '{home}, 캐리어가 나옵니다! 공중 대형 유닛!',
            ),
            ScriptEvent(
              text: '{away} 선수 아머리에서 업그레이드! 골리앗 대비를 합니다.',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
              altText: '{away}, 아머리 건설! 골리앗으로 대공 준비!',
            ),
            ScriptEvent(
              text: '프로토스가 캐리어 테크! 후반 공중전이 예상됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 D: 리버 푸시 (P trans_reaver_push) ---
        ScriptBranch(
          id: 'p_reaver_push',
          conditionHomeBuildIds: ['pvt_trans_reaver_push'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 셔틀에 리버를 태웁니다! 견제 출발!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 셔틀 리버 출격! 테란 일꾼을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 리버 스캐럽! SCV 사이에 떨어집니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽이 명중! 일꾼을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away}, 벌처를 급히 돌려서 셔틀을 쫓습니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: 2,
              altText: '{away} 선수 벌처 대응! 셔틀을 격추하려 합니다!',
            ),
            ScriptEvent(
              text: '셔틀 리버 견제가 전장을 흔들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 E: 리버 아비터 (P trans_reaver_arbiter) ---
        ScriptBranch(
          id: 'p_reaver_arbiter',
          conditionHomeBuildIds: ['pvt_trans_reaver_arbiter'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 셔틀 리버 견제하면서 스타게이트도 건설합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -25, favorsStat: 'harass',
              altText: '{home}, 리버 견제에 스타게이트까지! 아비터를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 리버 스캐럽이 테란 일꾼을 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽이 명중! SCV 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 트리뷰널도 올립니다! 리콜 준비!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 아비터 트리뷰널까지! 리콜 전략인가요?',
            ),
            ScriptEvent(
              text: '리버 견제에 아비터 테크까지! 다중 전략입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 F: vs 마인 트리플 (T mine_triple/1fac_gosu) ---
        ScriptBranch(
          id: 't_mine_triple',
          conditionAwayBuildIds: ['tvp_mine_triple', 'tvp_1fac_gosu'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드센터를 올립니다! 마인 트리플!',
              owner: LogOwner.away,
              awayResource: -30,
              altText: '{away}, 앞마당에 이어 세 번째 확장까지! 마인 트리플!',
            ),
            ScriptEvent(
              text: '{away}, 벌처가 맵 곳곳에 마인을 뿌립니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'strategy',
              altText: '{away} 선수 마인 매설! 프로토스 이동 경로를 차단!',
            ),
            ScriptEvent(
              text: '{home} 선수 옵저버 출격! 마인 위치를 밝혀냅니다.',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'scout',
              altText: '{home}, 옵저버 정찰! 마인 위치가 보입니다!',
            ),
            ScriptEvent(
              text: '테란이 마인으로 영역을 확보하며 수비적으로 운영합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 G: vs 11업 8팩 (T 11up_8fac) ---
        ScriptBranch(
          id: 't_11up_8fac',
          conditionAwayBuildIds: ['tvp_11up_8fac'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 아머리 건설! 메카닉 업그레이드를 서두릅니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 아머리! 11시 업그레이드 시작!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리를 계속 증설합니다! 8팩을 향해!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25,
              altText: '{away}, 팩토리가 빠르게 늘어납니다! 물량 준비!',
            ),
            ScriptEvent(
              text: '{home} 선수 게이트웨이 추가하면서 드라군 대량 생산!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home}, 드라군이 쏟아져 나옵니다! 물량으로 맞서려 합니다!',
            ),
            ScriptEvent(
              text: '테란이 8팩 체제를 갖추고 있습니다! 업그레이드도 진행 중!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 H: vs FD테란 (T fd) ---
        ScriptBranch(
          id: 't_fd_terran',
          conditionAwayBuildIds: ['tvp_fd', 'tvp_trans_bio_mech'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스타포트에 컨트롤타워 건설! 드랍십 준비!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20,
              altText: '{away}, 스타포트에 컨트롤타워! FD 체제!',
            ),
            ScriptEvent(
              text: '{away}, 벌처가 마인을 뿌리면서 영역을 확보합니다.',
              owner: LogOwner.away,
              awayArmy: 1, favorsStat: 'harass',
              altText: '{away} 선수 마인 매설! 프로토스 이동을 제한!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'defense',
              altText: '{home}, 드라군이 벌처를 격퇴합니다!',
            ),
            ScriptEvent(
              text: 'FD테란 운영이 본격화되고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 I: 폴백 (조건 없음) - 드라군 압박 vs 탱크 ---
        ScriptBranch(
          id: 'default_dragoon_push',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home} 선수 드라군 편대가 전진합니다! 사거리 업그레이드 완료!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'attack',
              altText: '{home}, 사업 완료된 드라군이 밀려갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크로 맞서는데 수가 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -1, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드라군 화력이 탱크 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 드라군이 집중 포화로 탱크를 부숩니다!',
            ),
            ScriptEvent(
              text: '프로토스 드라군 압박이 효과적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),

        // --- 분기 J: 폴백 - 테란 벌처 견제 ---
        ScriptBranch(
          id: 'default_vulture_harass',
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{away}, 벌처가 프로토스 멀티로 돌진합니다! 마인 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 벌처가 기동! 마인으로 일꾼을 타격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브 피해가 큽니다! 대응이 늦었어요!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 프로브가 마인에 줄줄이 터집니다!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크도 전진 배치! 화력을 올립니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20,
            ),
            ScriptEvent(
              text: '벌처 견제가 판을 흔들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),

    // ============================================================
    // Phase 3: 후반 전환 (lines 43-58)
    // ============================================================
    ScriptPhase(
      name: 'late_transition',
      startLine: 43,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 아둔에서 템플러 아카이브까지! 스톰 연구 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 병력을 모아서 전진 준비! 탱크 라인이 길어집니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 시즈 탱크 편대가 정비를 마쳤습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다! 견제를 노립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          skipChance: 0.3,
          altText: '{home}, 셔틀 리버 출격! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 편대가 전진 배치합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15, favorsStat: 'attack',
          altText: '{away}, 탱크 라인이 프로토스 앞마당을 향합니다!',
        ),
        ScriptEvent(
          text: '양측 결전 병력이 갖추어지고 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),

    // ============================================================
    // Phase 4: 결전 - 분기 (lines 59-75)
    // ============================================================
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 59,
      branches: [
        // 분기 A: 프로토스 스톰으로 결전
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이 템플러 합류! 사이오닉 스톰!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -12, favorsStat: 'strategy',
              altText: '{home}, 스톰 투하! 테란 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 스톰에 쓸려나갑니다! 탱크도 피해!',
              owner: LogOwner.away,
              awayArmy: -5,
              altText: '{away}, 스톰에 바이오닉이 증발! 엄청난 피해!',
            ),
            ScriptEvent(
              text: '{home}, 드라군 총공격! 남은 병력을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰이 결정적이었습니다! 프로토스가 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 아비터 리콜
        ScriptBranch(
          id: 'protoss_arbiter_recall',
          conditionHomeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_trans_reaver_arbiter'],
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 아비터 등장! 리콜로 테란 본진에 병력을 떨어뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -25, favorsStat: 'sense',
              altText: '{home} 선수 리콜 투하! 테란 본진이 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비가 급합니다! 탱크를 돌립니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 앞마당도 동시 공격! 테란이 갈리고 있습니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '아비터 리콜이 판을 뒤집습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 캐리어 화력
        ScriptBranch(
          id: 'protoss_carrier_wins',
          conditionHomeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_trans_reaver_carrier'],
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 캐리어 편대! 인터셉터가 비처럼 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -6, favorsStat: 'macro',
              altText: '{home} 선수 캐리어 3기! 공중에서 화력을 퍼붓습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 노리지만 인터셉터에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 하이 템플러 스톰까지! 이중 화력에 테란이 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -1, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '캐리어가 전장을 지배합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 D: 테란 탱크 화력
        ScriptBranch(
          id: 'terran_tank_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 일제 포격! 프로토스 병력을 부숩니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -4, favorsStat: 'attack',
              altText: '{away}, 탱크 화력 집중! 프로토스 전선이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away}, 벌처가 측면에서 돌진! 드라군을 마무리합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '탱크 화력이 결정적이었습니다! 테란이 밀어냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 E: 테란 대규모 물량 (8팩/5팩)
        ScriptBranch(
          id: 'terran_mass_push',
          conditionAwayBuildIds: ['tvp_11up_8fac', 'tvp_trans_5fac_mass'],
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 팩토리 풀가동! 탱크 벌처가 쏟아져 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30, favorsStat: 'macro',
              altText: '{away}, 팩토리에서 물량이 끝없이 나옵니다!',
            ),
            ScriptEvent(
              text: '{away}, 대규모 시즈 라인! 업그레이드된 화력으로 프로토스를 압도합니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '업그레이드된 물량이 프로토스를 압도하고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 F: FD테란 EMP 푸시
        ScriptBranch(
          id: 'terran_fd_push',
          conditionAwayBuildIds: ['tvp_fd', 'tvp_trans_bio_mech'],
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 사이언스 퍼실리티에서 사이언스베슬이 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25,
              altText: '{away}, 사이언스베슬 합류! EMP 준비!',
            ),
            ScriptEvent(
              text: '{away}, EMP! 프로토스 실드가 사라집니다!',
              owner: LogOwner.away,
              homeArmy: -6, favorsStat: 'strategy',
              altText: '{away} 선수 EMP 명중! 쉴드가 벗겨집니다!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크까지 포격! 프로토스가 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: 'EMP에 시즈 포격! 테란이 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
