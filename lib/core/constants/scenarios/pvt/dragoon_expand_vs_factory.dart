part of '../../scenario_scripts.dart';

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
              altText: '{home} 선수 드라군이 집중 포화로 탱크를 부숩니다!',
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
          text: '{home}, 리버 스캐럽! SCV 사이에 떨어집니다!',
          owner: LogOwner.home,
          awayResource: -20, favorsStat: 'harass',
          altText: '{home} 선수 스캐럽이 명중! 일꾼을 초토화합니다!',
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
              text: '{home} 선수 스타게이트 건설! 아비터 트리뷰널까지 올립니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 스타게이트에 아비터 트리뷰널까지! 리콜 준비인가요?',
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
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 하이 템플러가 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 아둔에서 템플러 아카이브! 하이 템플러 합류!',
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
              altText: '{home} 선수 스톰이 마린 메딕을 순식간에 증발시킵니다!',
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

