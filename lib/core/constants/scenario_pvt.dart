part of 'scenario_scripts.dart';

// ============================================================
// PvT 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

// ----------------------------------------------------------
// 1. 드라군 확장 vs 팩더블 (가장 대표적인 PvT)
// ----------------------------------------------------------
const _pvtDragoonExpandVsFactory = ScenarioScript(
  id: 'pvt_dragoon_expand_vs_factory',
  matchup: 'PvT',
  homeBuildIds: ['pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_double', 'tvp_fd', 'tvp_rax_double',
                 'tvp_trans_tank_defense', 'tvp_trans_upgrade', 'tvp_trans_bio_mech'],
  description: '드라군 확장 vs 팩더블 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
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
          altText: '{home}, 앞마당 넥서스가 올라갑니다! 확장을 가져가겠다는 의지!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터! 팩더블 체제입니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 커맨드센터 건설! 양측 모두 확장을 올리네요.',
        ),
      ],
    ),
    // Phase 1: 전개 (lines 17-26)
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
          text: '{away}, 벌처가 프로브 라인을 노립니다! 마인 매설!',
          owner: LogOwner.away,
          homeResource: -10, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{away} 선수 벌처 기동! 프로브 라인에 마인을 뿌립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 옵저버를 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스가 올라갑니다! 리버가 될지 옵저버가 될지!',
        ),
        ScriptEvent(
          text: '양측 모두 내정을 다지면서 중반을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 중반 접촉 - 분기 (lines 27-40)
    ScriptPhase(
      name: 'mid_contact',
      startLine: 27,
      branches: [
        // 분기 A: 드라군 압박 (무조건 eligible, 확률 보정)
        ScriptBranch(
          id: 'protoss_dragoon_push',
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
              altText: '{home} 선수 드라군 집중 포화! 탱크가 터지고 있습니다!',
            ),
            ScriptEvent(
              text: '프로토스 드라군 압박이 효과적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 테란 harass 높으면 벌처 견제
        ScriptBranch(
          id: 'terran_vulture_harass',
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벌처가 프로토스 멀티로 돌진합니다! 마인 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 벌처 기동! 프로브가 마인에 당합니다!',
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
              text: '벌처 견제가 판을 흔들고 있습니다! 프로토스 일꾼에 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 프로토스 scout 높으면 옵저버로 마인 확인
        ScriptBranch(
          id: 'protoss_observer_scout',
          conditionStat: 'scout',
          homeStatMustBeHigher: true,
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 옵저버가 전장을 정찰합니다! 마인 위치가 보입니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 옵저버 정찰! 마인 위치를 완벽히 파악합니다!',
            ),
            ScriptEvent(
              text: '{home}, 드라군이 마인을 피하면서 안전하게 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 마인이 무력화됩니다! 벌처만으로는 부족해요!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 마인이 다 밝혀졌습니다! 계획이 틀어지네요!',
            ),
            ScriptEvent(
              text: '옵저버 정찰이 빛나는 순간입니다! 마인 함정이 무력화!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 셔틀 리버 등장 (lines 41-54)
    ScriptPhase(
      name: 'shuttle_reaver',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다! 견제 출발!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'strategy',
          altText: '{home}, 셔틀 리버 출격! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛이 부족한 곳을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 리버 스캐럽! SCV 라인에 떨어집니다!',
          owner: LogOwner.home,
          awayResource: -20, favorsStat: 'harass',
          altText: '{home} 선수 스캐럽 명중! SCV가 날아갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 급히 벌처를 돌려서 셔틀을 쫓습니다!',
          owner: LogOwner.away,
          homeArmy: -1,
          altText: '{away} 선수 벌처 대응! 셔틀을 격추하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 편대를 모아서 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20, favorsStat: 'attack',
          altText: '{away}, 탱크 라인 전진! 화력으로 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '셔틀 리버 견제와 정면 전투가 동시에 진행됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 후반 전환 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'late_transition',
      startLine: 55,
      branches: [
        // 분기 A: 프로토스 아비터 전환
        ScriptBranch(
          id: 'protoss_arbiter',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 트리뷰널 건설! 아비터를 준비합니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 아비터 테크! 리콜 준비인가요?',
            ),
            ScriptEvent(
              text: '{home}, 아비터 등장! 스테이시스 필드 준비!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home} 선수 아비터가 나왔습니다! 전장의 판도가 바뀝니다!',
            ),
            ScriptEvent(
              text: '{home}, 리콜! 테란 본진에 병력이 떨어집니다!',
              owner: LogOwner.home,
              awayResource: -15, homeArmy: -2, favorsStat: 'sense',
              altText: '{home} 선수 리콜 투하! 테란 본진이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비가 급합니다! 탱크를 돌리는데요!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '아비터 리콜이 판을 뒤집고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 테란 탱크 푸시
        ScriptBranch(
          id: 'terran_tank_push',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 5기 이상! 대규모 푸시 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 시즈 모드! 프로토스 앞마당을 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, homeResource: -15, favorsStat: 'attack',
              altText: '{away} 선수 시즈 포격 시작! 프로토스 앞마당이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 맞서지만 시즈 화력이 너무 강합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home}, 드라군이 시즈 모드에 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버로 탱크 뒤를 노립니다! 역습!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'strategy',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '탱크 화력이 프로토스 전선을 밀어붙이고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 전개 (lines 71-80)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 71,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 사이오닉 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 하이 템플러가 나왔습니다! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 결집! 최종 공격 준비!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 결전 병력이 충돌합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 6: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 81,
      branches: [
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 사이오닉 스톰! 바이오닉 병력이 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -14, homeArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 투하! 마린 메딕이 순식간에 증발합니다!',
            ),
            ScriptEvent(
              text: '스톰이 결정적이었습니다! 프로토스 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_tank_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 시즈 탱크 포격! 드라군 편대가 쓸려나갑니다!',
              owner: LogOwner.away,
              homeArmy: -13, awayArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력 집중! 프로토스 병력이 무너집니다!',
            ),
            ScriptEvent(
              text: '탱크 화력이 결정적이었습니다! 테란 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 2. 리버 셔틀 vs 타이밍 러시 (공격적 대결)
// ----------------------------------------------------------
const _pvtReaverVsTiming = ScenarioScript(
  id: 'pvt_reaver_vs_timing',
  matchup: 'PvT',
  homeBuildIds: ['pvt_reaver_shuttle', 'pvt_proxy_dark',
                 'pvt_trans_reaver_push', 'pvt_trans_reaver_arbiter', 'pvt_trans_reaver_carrier'],
  awayBuildIds: ['tvp_fake_double', 'tvp_1fac_drop', 'tvp_5fac_timing',
                 'tvp_trans_timing_push', 'tvp_trans_5fac_mass'],
  description: '리버 셔틀 vs 타이밍 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 로보틱스 건설!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스가 올라갑니다! 리버를 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 빠르게 테크를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 리버 생산 시작! 셔틀도 올립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 셔틀과 리버를 동시에 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 병력을 빠르게 모으려는 의도!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 팩토리 증설! 빠른 타이밍을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀에 리버를 태웁니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 투입 vs 타이밍 공격 (lines 17-26)
    ScriptPhase(
      name: 'shuttle_drop_vs_timing',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 셔틀 리버 출격! SCV 라인으로 향합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버 투하! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 병력을 모아서 전진합니다! 타이밍 공격!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20, favorsStat: 'attack',
          altText: '{away}, 탱크 벌처 병력이 프로토스로 이동합니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 선택! 서로의 기지를 노리는 형국!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 셔틀 생존 여부 - 분기 (lines 27-38)
    ScriptPhase(
      name: 'shuttle_survival',
      startLine: 27,
      branches: [
        // 분기 A: 셔틀 리버 성공 (무조건 eligible, 확률 보정)
        ScriptBranch(
          id: 'reaver_harass_success',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! SCV 5기가 한 번에 날아갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽 대박! SCV가 증발합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처를 돌려서 리버를 잡으려 합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 셔틀이 리버를 태우고 빠집니다! 안전하게 회수!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'control',
              altText: '{home} 선수 셔틀 컨트롤! 리버를 살려냅니다!',
            ),
            ScriptEvent(
              text: '리버 견제가 성공적! 테란 일꾼에 큰 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 셔틀 격추
        ScriptBranch(
          id: 'shuttle_destroyed',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{away} 선수 터렛과 골리앗이 셔틀을 포착합니다!',
              owner: LogOwner.away,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 셔틀 격추! 리버가 땅에 떨어집니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 셔틀 폭사! 리버가 고립됐습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버를 잃었습니다! 핵심 유닛 손실!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home}, 셔틀이 격추되면서 리버까지! 병력 손실이 크네요!',
            ),
            ScriptEvent(
              text: '셔틀 폭사! 프로토스에게 치명적인 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 정면 교전 (lines 39-52)
    ScriptPhase(
      name: 'frontal_clash',
      startLine: 39,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 시즈 탱크 배치! 프로토스 앞마당을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 편대로 맞섭니다! 사거리가 길어서 유리한데요!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 사업 드라군으로 탱크 사거리 밖에서 포격!',
        ),
        ScriptEvent(
          text: '{away}, 탱크 시즈 포격! 드라군이 한 방에 터집니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
          altText: '{away} 선수 탱크 포격! 드라군이 무너집니다!',
        ),
        ScriptEvent(
          text: '{home}, 질럿이 돌진! 탱크 뒤를 노립니다!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 질럿 돌진! 탱크 라인 교란!',
        ),
        ScriptEvent(
          text: '양측 병력이 크게 소모되고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 53-70)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 프로토스 하이템플러 스톰
        ScriptBranch(
          id: 'protoss_storm_finish',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이 템플러 합류! 사이오닉 스톰!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -12, favorsStat: 'strategy',
              altText: '{home}, 스톰 투하! 바이오닉 병력이 증발합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 스톰에 녹아내립니다! 대규모 피해!',
              owner: LogOwner.away,
              awayArmy: -8,
              altText: '{away}, 스톰에 걸렸습니다! 마린 메딕이 순식간에 사라집니다!',
            ),
            ScriptEvent(
              text: '{home}, 드라군 질럿 총공격! 남은 병력을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰이 결정적이었습니다! 테란 병력이 괴멸!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 테란 물량 압박
        ScriptBranch(
          id: 'terran_mass_push',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 5팩토리 풀가동! 탱크 벌처가 쏟아져 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30, favorsStat: 'macro',
              altText: '{away}, 팩토리 5개에서 물량이 끝없이 나옵니다!',
            ),
            ScriptEvent(
              text: '{away}, 대규모 시즈 라인! 프로토스 방어선이 밀립니다!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 리버로 저항하지만 물량 차이가 큽니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -3,
              altText: '{home}, 리버 스캐럽으로 저항! 하지만 탱크가 너무 많아요!',
            ),
            ScriptEvent(
              text: '테란 물량이 프로토스를 압도하고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 3. 다크 템플러 vs 스탠다드 (기습 빌드)
// ----------------------------------------------------------
const _pvtDarkVsStandard = ScenarioScript(
  id: 'pvt_dark_vs_standard',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing', 'pvt_proxy_dark'],
  awayBuildIds: ['tvp_double', 'tvp_rax_double', 'tvp_fd',
                 'tvp_trans_tank_defense', 'tvp_trans_upgrade'],
  description: '다크 템플러 기습 vs 스탠다드 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크인가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔이 올라갑니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 템플러 아카이브가 올라갑니다! 어떤 유닛이 나올까요?',
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 생산! 은밀하게 이동합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 다크 템플러가 나옵니다! 보이지 않는 위협!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 가동 중! 벌처 생산에 집중합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 다크 템플러가 테란 진영에 잠입합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크가 보이지 않게 접근 중입니다!',
        ),
      ],
    ),
    // Phase 2: 디텍 여부 - 분기 (lines 23-34)
    ScriptPhase(
      name: 'detection_check',
      startLine: 23,
      branches: [
        // 분기 A: 테란 디텍 없음 - 다크 성공
        ScriptBranch(
          id: 'dark_success',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 다크 템플러가 SCV를 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -30, favorsStat: 'harass',
              altText: '{home} 선수 다크 성공! SCV가 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아카데미도 없고 엔지니어링 베이도 없습니다! 디텍이 전무해요!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 스캔도 터렛도 마인도 없습니다! 감지 수단이 하나도 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 다크 한 기가 SCV를 10기 이상 잡아냅니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 템플러가 대활약! 테란 일꾼이 무너지고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 테란 디텍 성공 - 다크 실패
        ScriptBranch(
          id: 'dark_failed',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 스캔! 다크 템플러 위치가 드러납니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 컴샛으로 다크를 포착합니다!',
            ),
            ScriptEvent(
              text: '{away}, 마린이 다크 템플러를 집중 사격! 격파!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 다크를 잡아냅니다! 완벽한 대응!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 막혔습니다! 이후 운영이 어려워지는데요.',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '다크 전략이 간파당했습니다! 프로토스가 테크 뒤처짐!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 (lines 35-48)
    ScriptPhase(
      name: 'followup',
      startLine: 35,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트 추가하면서 드라군 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 드라군 물량으로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 생산! 화력을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home}, 하이 템플러도 준비합니다! 스톰 연구!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home} 선수 하이 템플러 테크까지! 스톰을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 병력을 모아서 전진 준비! 탱크 라인!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '양측 모두 결전을 준비하고 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 49-58)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 49,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 전 병력 결집! 드라군 질럿 하이 템플러!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 총공격! 탱크 벌처 골리앗!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
        ),
        ScriptEvent(
          text: '전면전이 시작됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 5: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 59,
      branches: [
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 탱크+벌처 편대에 떨어집니다!',
              owner: LogOwner.home,
              awayArmy: -12, homeArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 명중! 메카닉 병력에 엄청난 피해!',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 프로토스가 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_firepower_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 탱크 포격! 드라군이 부서집니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 시즈 화력으로 드라군을 날립니다!',
            ),
            ScriptEvent(
              text: '화력이 결정적! 테란이 밀어냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 4. 센터 게이트 vs 스탠다드 (치즈)
// ----------------------------------------------------------
const _pvtCheeseVsStandard = ScenarioScript(
  id: 'pvt_cheese_vs_standard',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_double', 'tvp_rax_double', 'tvp_fd',
                 'tvp_trans_tank_defense', 'tvp_trans_upgrade', 'tvp_trans_bio_mech'],
  description: '센터 게이트 질럿 러시 vs 스탠다드 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 게이트웨이가 센터에! 공격적인 선택!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 빠르게 뽑고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다! 센터에서 바로 출발!',
        ),
      ],
    ),
    // Phase 1: 질럿 러시 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 3기가 테란 앞마당으로 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home}, 질럿이 달려갑니다! 테란 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 1기뿐입니다! 벙커를 지으려 하는데요!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '질럿이 도착했습니다! 테란이 막을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 수비 여부 - 분기 (lines 19-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        ScriptBranch(
          id: 'zealot_rush_success',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 SCV를 베기 시작합니다! 벙커가 완성되지 않았어요!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 들어갔습니다! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 수리로 벙커를 살리려 하지만!',
              owner: LogOwner.away,
              awayArmy: -1, awayResource: -5,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 테란 본진이 초토화됩니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시가 성공적! 테란이 무너지고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_defense_success',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 벙커 완성! 질럿을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커에 막힙니다! 피해만 누적!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, SCV 수리까지! 벙커가 절대 안 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '질럿 러시가 막혔습니다! 프로토스가 위기!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 5. 캐리어 빌드 vs 안티 캐리어 (후반 대결)
// ----------------------------------------------------------
const _pvtCarrierVsAnti = ScenarioScript(
  id: 'pvt_carrier_vs_anti',
  matchup: 'PvT',
  homeBuildIds: ['pvt_carrier', 'pvt_trans_5gate_carrier', 'pvt_trans_reaver_carrier'],
  awayBuildIds: ['tvp_anti_carrier', 'tvp_1fac_gosu',
                 'tvp_trans_anti_carrier', 'tvp_trans_upgrade'],
  description: '캐리어 빌드 vs 안티 캐리어 후반 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스를 올립니다. 확장을 가져가네요.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스 건설! 확장을 가져가겠다는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 공중 테크로 가는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타게이트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 서두릅니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 대비인가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 캐리어를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 플릿 비콘! 캐리어 테크입니다!',
        ),
      ],
    ),
    // Phase 1: 캐리어 빌드업 (lines 17-28)
    ScriptPhase(
      name: 'carrier_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 캐리어 생산 시작! 인터셉터를 채우고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -30,
          altText: '{home}, 캐리어가 나옵니다! 인터셉터 충전 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 대량 생산! 대공 준비를 합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 골리앗이 쏟아져 나옵니다! 캐리어에 대비!',
        ),
        ScriptEvent(
          text: '{home}, 드라군과 캐리어 복합 편성! 하이 템플러도 준비!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크도 추가 생산! 지상 화력을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '캐리어 대 골리앗의 대결이 예상됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 캐리어 교전 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'carrier_battle',
      startLine: 29,
      branches: [
        ScriptBranch(
          id: 'carrier_dominance',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 캐리어 3기! 인터셉터가 쏟아져 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -5, favorsStat: 'macro',
              altText: '{home} 선수 캐리어 편대! 인터셉터가 비처럼 쏟아집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 노리지만 인터셉터에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 하이 템플러 스톰까지! 골리앗이 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'strategy',
              altText: '{home} 선수 스톰+캐리어! 이중 화력에 테란이 무너집니다!',
            ),
            ScriptEvent(
              text: '캐리어가 전장을 지배하고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'goliath_counter',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 골리앗 편대가 캐리어를 집중 포화! 대공 화력이 강합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'defense',
              altText: '{away} 선수 골리앗 집중 사격! 캐리어가 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 1기가 격추됩니다! 인터셉터도 손실!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크까지 합류! 지상 병력도 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '안티 캐리어 전략이 효과를 보고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 6. 5게이트 푸시 vs 팩더블 (타이밍 공격)
// ----------------------------------------------------------
const _pvt5gatePush = ScenarioScript(
  id: 'pvt_5gate_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_trans_5gate_arbiter'],
  awayBuildIds: ['tvp_double', 'tvp_rax_double', 'tvp_mine_triple',
                 'tvp_trans_tank_defense', 'tvp_trans_bio_mech'],
  description: '5게이트 드라군 푸시 vs 팩더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 계속 추가합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 게이트웨이가 빠르게 늘어납니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 확장합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 5개째! 드라군을 쏟아낼 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 5게이트 완성! 드라군이 물밀듯이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 가동! 탱크 생산 시작.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
      ],
    ),
    // Phase 1: 5게이트 타이밍 (lines 17-24)
    ScriptPhase(
      name: 'timing_push',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드라군 10기 이상! 대규모 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 4, favorsStat: 'attack',
          altText: '{home}, 드라군 편대 출격! 테란 앞마당을 향합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크가 아직 2기뿐입니다! 시간이 부족해요!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 탱크가 모이기 전에 드라군이 도착합니다!',
        ),
        ScriptEvent(
          text: '5게이트 타이밍이 절묘합니다! 탱크가 모이기 전!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 - 분기 (lines 25-38)
    ScriptPhase(
      name: 'push_result',
      startLine: 25,
      branches: [
        ScriptBranch(
          id: 'dragoon_overwhelm',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home}, 드라군 물량으로 탱크 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드라군이 탱크를 녹입니다! 물량 차이!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커를 올리지만 드라군 사거리에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 진입! 테란 앞마당이 무너집니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5게이트 타이밍 공격 성공! 테란 앞마당 함락!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_holds',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{away}, 시즈 탱크 시즈 모드! 드라군이 녹기 시작합니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'defense',
              altText: '{away} 선수 탱크 포격! 드라군이 한 방에 터집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 녹고 있습니다! 시즈 화력이 너무 강해요!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 벌처 측면 기동! 드라군 뒤를 칩니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '타이밍 공격이 막혔습니다! 프로토스 병력이 녹았어요!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 7. 치즈 vs 치즈 (센터 게이트 vs 센터 8배럭 BBS)
// ----------------------------------------------------------
const _pvtCheeseVsCheese = ScenarioScript(
  id: 'pvt_cheese_vs_cheese',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_bbs'],
  description: '센터 게이트 vs 센터 8배럭 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수도 SCV를 센터로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 게이트웨이! 공격적인 오프닝!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 배럭 건설! 양쪽 다 센터에 건물을 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 센터 배럭! 양쪽 다 공격적입니다!',
        ),
        ScriptEvent(
          text: '양측 모두 센터에 건물을 올렸습니다! 치즈 대 치즈!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 초반 병력 생산 (lines 11-18)
    ScriptPhase(
      name: 'early_units',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 마린 생산! 본진 배럭에서도 마린이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 질럿 2기! 테란 쪽으로 향합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 질럿이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 마린 3기에 SCV까지 끌고 나옵니다! 벙커를 지으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -5,
          altText: '{away} 선수 SCV를 동원합니다! 벙커링 준비!',
        ),
      ],
    ),
    // Phase 2: 정면 충돌 - 분기 (lines 19-30)
    ScriptPhase(
      name: 'cheese_clash',
      startLine: 19,
      branches: [
        // 분기 A: 질럿이 마린을 압도
        ScriptBranch(
          id: 'zealot_overwhelm',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 마린에 달라붙습니다! 마린이 녹아요!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 질럿 컨트롤! 마린을 순식간에 정리!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV로 수리하려 하지만 질럿이 너무 강합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 테란 앞마당으로 진입합니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿이 마린을 제압했습니다! 프로토스 치즈가 우세!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 마린+벙커가 질럿을 막음
        ScriptBranch(
          id: 'marine_bunker_hold',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10, favorsStat: 'defense',
              altText: '{away} 선수 벙커 올렸습니다! 질럿을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커에 막힙니다! 체력만 깎여요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, SCV 수리로 벙커를 유지합니다! 추가 마린도 합류!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커가 질럿을 막아냈습니다! 테란 치즈가 우세!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 8. 리버 셔틀 vs BBS 대응
// ----------------------------------------------------------
const _pvtReaverVsBbs = ScenarioScript(
  id: 'pvt_reaver_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_reaver_shuttle', 'pvt_proxy_dark',
                 'pvt_trans_reaver_push'],
  awayBuildIds: ['tvp_bbs'],
  description: '리버 셔틀 vs BBS 타이밍',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 센터로 SCV를 보냅니다! 8배럭 오프닝!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 로보틱스를 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터 배럭에서 마린 생산! 본진 배럭도 돌아갑니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 마린이 빠르게 쌓이고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스가 올라갑니다! 리버 준비!',
        ),
        ScriptEvent(
          text: '{away}, SCV까지 끌고 프로토스 앞마당으로 진격합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 SCV 동원! BBS 돌진!',
        ),
      ],
    ),
    // Phase 1: BBS 공격 도착 (lines 15-22)
    ScriptPhase(
      name: 'bbs_attack',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 프로토스 앞마당에 벙커를 올리려 합니다!',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'attack',
          altText: '{away} 선수 벙커링 시도! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿과 드라군으로 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 질럿 드라군 방어! 벙커를 막으려 합니다!',
        ),
        ScriptEvent(
          text: 'BBS가 도착했습니다! 프로토스가 막아낼 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: BBS 결과 - 분기 (lines 23-36)
    ScriptPhase(
      name: 'bbs_result',
      startLine: 23,
      branches: [
        // 분기 A: BBS 수비 성공 → 리버 투입
        ScriptBranch(
          id: 'defense_success_reaver',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 프로브까지 동원해서 벙커 건설을 저지합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 프로브 컨트롤! SCV를 끊어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커가 안 올라갑니다! 마린만으로는 부족해요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 리버 생산 완료! 셔틀에 탑승합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 리버가 나왔습니다! 셔틀 리버 출격!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버가 테란 본진으로! 스캐럽 투하!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽! SCV가 날아갑니다!',
            ),
            ScriptEvent(
              text: 'BBS를 막고 리버 역습! 프로토스가 판을 뒤집습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: BBS 성공
        ScriptBranch(
          id: 'bbs_breakthrough',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away} 선수 벙커링 성공! 프로토스 앞마당이 위험!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿으로 벙커를 부수려 하지만 마린 화력이 강합니다!',
              owner: LogOwner.home,
              homeArmy: -4, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 추가 마린 합류! 프로브까지 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'attack',
              altText: '{away} 선수 마린이 프로브를 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 아직 안 나왔습니다! 테크가 늦었어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: 'BBS가 프로토스를 무너뜨리고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 9. 마인 트리플 수비전 (프로토스 확장 vs 테란 수비적 운영)
// ----------------------------------------------------------
const _pvtMineTriple = ScenarioScript(
  id: 'pvt_mine_triple',
  matchup: 'PvT',
  homeBuildIds: ['pvt_1gate_expand', 'pvt_1gate_obs',
                 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier'],
  awayBuildIds: ['tvp_mine_triple', 'tvp_1fac_gosu',
                 'tvp_trans_tank_defense', 'tvp_trans_upgrade'],
  description: '프로토스 확장 vs 마인 트리플 수비전',
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
          altText: '{home}, 게이트웨이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산! 마인 업그레이드 연구 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 벌처가 나옵니다! 마인까지 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다! 확장!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 그리고 자연스럽게 세 번째 커맨드로!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당에 이어 세 번째 확장까지! 마인 트리플!',
        ),
      ],
    ),
    // Phase 1: 마인 영역 확보 (lines 19-30)
    ScriptPhase(
      name: 'mine_control',
      startLine: 19,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 벌처가 맵 곳곳에 마인을 뿌립니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
          altText: '{away} 선수 마인 매설! 프로토스 이동 경로를 차단!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 사거리 업그레이드 완료!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 로보틱스 건설! 옵저버를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home} 선수 로보틱스! 옵저버로 마인을 잡으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드센터에서 자원이 들어옵니다! 시즈 탱크 추가 생산!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 트리플 자원으로 탱크를 찍어냅니다!',
        ),
        ScriptEvent(
          text: '테란이 마인으로 영역을 확보하며 수비적으로 운영합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 옵저버 vs 마인 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'observer_vs_mine',
      startLine: 31,
      branches: [
        // 분기 A: 옵저버로 마인 무력화
        ScriptBranch(
          id: 'observer_clears_mines',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 옵저버 출격! 마인 위치를 밝혀냅니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 옵저버 정찰! 마인이 다 보입니다!',
            ),
            ScriptEvent(
              text: '{home}, 드라군이 마인을 하나씩 처리합니다! 안전하게 전진!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 마인 방어선이 뚫리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 마인이 무력화됩니다! 영역이 뚫려요!',
            ),
            ScriptEvent(
              text: '옵저버가 마인을 무력화! 프로토스가 전진할 길이 열렸습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 마인에 드라군 피해
        ScriptBranch(
          id: 'mine_damage',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드라군이 전진하는데 마인에 걸립니다!',
              owner: LogOwner.home,
              homeArmy: -3, favorsStat: 'scout',
              altText: '{home}, 드라군이 마인에 터집니다! 옵저버가 늦었어요!',
            ),
            ScriptEvent(
              text: '{away}, 벌처가 마인 위치로 유인! 추가 피해를 줍니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실이 큽니다! 재정비가 필요합니다.',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '마인에 드라군이 당했습니다! 테란 영역 확보가 효과적!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 테크 전환 (lines 45-58)
    ScriptPhase(
      name: 'late_tech',
      startLine: 45,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 하이 템플러 테크! 스톰 연구 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리 건설! 메카닉 업그레이드!',
        ),
        ScriptEvent(
          text: '{home}, 드라군 추가 생산! 게이트웨이 추가!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away}, 시즈 탱크 편대가 정비를 마쳤습니다! 골리앗도 합류!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away} 선수 탱크 골리앗 편대! 화력이 막강합니다!',
        ),
        ScriptEvent(
          text: '양측 후반 병력이 완성되어 갑니다.',
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
        // 분기 A: 프로토스 스톰으로 돌파
        ScriptBranch(
          id: 'protoss_storm_break',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이 템플러 합류! 사이오닉 스톰!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -10, favorsStat: 'strategy',
              altText: '{home}, 스톰 투하! 테란 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 스톰에 쓸려나갑니다!',
              owner: LogOwner.away,
              awayArmy: -6,
              altText: '{away}, 스톰에 바이오닉이 증발!',
            ),
            ScriptEvent(
              text: '{home}, 드라군 총공격! 탱크 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 트리플 체제를 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 테란 화력으로 수비
        ScriptBranch(
          id: 'terran_firepower_hold',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 시즈 탱크 집중 포격! 드라군이 한 방에 날아갑니다!',
              owner: LogOwner.away,
              homeArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 탱크 포격! 드라군 편대가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗까지 합류! 지상 화력이 압도적입니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 병력이 녹고 있습니다! 트리플 자원 차이가 크네요!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 자원 차이가 결국 병력 차이로! 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '트리플 자원의 화력이 프로토스를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 10. 11업 8팩 vs 드라군 확장 (후반 대규모 교전)
// ----------------------------------------------------------
const _pvt11up8facVsExpand = ScenarioScript(
  id: 'pvt_11up8fac_vs_expand',
  matchup: 'PvT',
  homeBuildIds: ['pvt_1gate_expand', 'pvt_1gate_obs',
                 'pvt_trans_5gate_push', 'pvt_trans_5gate_arbiter'],
  awayBuildIds: ['tvp_11up_8fac',
                 'tvp_trans_5fac_mass', 'tvp_trans_timing_push'],
  description: '11업 8팩 vs 드라군 확장 대규모 후반전',
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
          text: '{home} 선수 게이트웨이 건설! 가스 채취 시작!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 가스 채취! 팩토리 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 사거리 업그레이드!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사업 시작! 드라군 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 아머리 건설도 시작합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 더블에 아머리까지! 업그레이드를 서두릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 양측 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 11시 업그레이드 시작! 메카닉 공격력을 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 메카닉 업그레이드! 11업 오프닝!',
        ),
      ],
    ),
    // Phase 1: 테크 경쟁 (lines 19-30)
    ScriptPhase(
      name: 'tech_race',
      startLine: 19,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 팩토리를 계속 증설합니다! 8팩을 향해!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -25,
          altText: '{away}, 팩토리가 빠르게 늘어납니다! 물량 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가하면서 드라군 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 드라군이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away}, 벌처가 마인을 뿌리면서 시간을 벌고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{away} 선수 벌처 기동! 마인으로 시간 벌기!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 옵저버 생산!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스! 옵저버로 마인 대비!',
        ),
        ScriptEvent(
          text: '양측 모두 후반 대전을 준비하고 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 중반 접촉 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'mid_contact',
      startLine: 31,
      branches: [
        // 분기 A: 프로토스 먼저 압박
        ScriptBranch(
          id: 'protoss_early_push',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home}, 사업 완료 드라군 편대가 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home} 선수 드라군 푸시! 탱크가 모이기 전에!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 아직 부족합니다! 벌처로 시간을 벌어야!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 드라군이 테란 앞마당을 압박합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 앞마당 진입! 테란이 흔들립니다!',
            ),
            ScriptEvent(
              text: '드라군이 탱크 물량 전에 압박! 타이밍이 좋습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 테란 업그레이드 완성 후 전진
        ScriptBranch(
          id: 'terran_upgrade_push',
          baseProbability: 0.55,
          events: [
            ScriptEvent(
              text: '{away} 선수 메카닉 업그레이드 완료! 화력이 올라갑니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'macro',
              altText: '{away}, 업그레이드 효과! 탱크 화력이 강해졌습니다!',
            ),
            ScriptEvent(
              text: '{away}, 8팩토리에서 탱크 벌처가 쏟아져 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25,
              altText: '{away} 선수 8팩 가동! 물량이 끝없이 나옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 맞서지만 업그레이드 차이가 느껴집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '11업 완료! 테란 메카닉의 화력이 한 단계 올라갔습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 대규모 교전 전개 (lines 45-55)
    ScriptPhase(
      name: 'mass_battle',
      startLine: 45,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 하이 템플러 테크! 스톰으로 물량을 상대하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 8팩토리 풀가동! 탱크가 끝없이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -30,
          altText: '{away}, 탱크 물량이 대단합니다! 8팩의 위력!',
        ),
        ScriptEvent(
          text: '{home}, 하이 템플러 합류! 드라군과 함께 결전 준비!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -25,
        ),
        ScriptEvent(
          text: '대규모 교전이 임박합니다! 양측 주력이 충돌합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 56,
      branches: [
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 사이오닉 스톰! 메카닉 사이로 떨어집니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 투하! 벌처가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 프로토스가 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_tank_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 시즈 탱크 일제 포격! 드라군이 부서집니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 업그레이드된 탱크 화력! 드라군이 견디지 못합니다!',
            ),
            ScriptEvent(
              text: '업그레이드된 화력이 결정적! 테란이 밀어냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

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
          text: '{away} 선수 팩토리 건설! 벌처를 뽑으면서 앞마당을 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 앞마당까지! FD테란 오프닝!',
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
          text: '{away} 선수 벌처 생산하면서 스타포트 건설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 스타포트가 올라갑니다! 드랍십 준비!',
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
          text: '{home} 선수 로보틱스 건설! 옵저버를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스! 옵저버로 시야 확보!',
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
              altText: '{away} 선수 벌처 기동! 프로브가 마인에 당합니다!',
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
          text: '{home}, 리버 스캐럽! SCV 라인에 명중!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'harass',
          skipChance: 0.3,
          altText: '{home} 선수 스캐럽 대박! SCV가 날아갑니다!',
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
              text: '{home} 선수 아비터 트리뷰널 건설! 아비터를 준비합니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 아비터 테크! 리콜을 노리는 건가요?',
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
              text: '{away} 선수 사이언스 퍼실리티 건설! 사이언스 베슬 생산!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 베슬이 나옵니다! EMP 준비!',
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
