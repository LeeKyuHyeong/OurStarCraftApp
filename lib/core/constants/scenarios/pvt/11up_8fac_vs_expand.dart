part of '../../scenario_scripts.dart';

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
          text: '{away} 선수 가스 채취! 팩토리에 머신샵까지 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 탱크 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 사거리 업그레이드!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 사업 시작! 드라군 준비!',
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
          text: '{home} 선수 로보틱스에 옵저버터리 건설! 옵저버 생산!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스에 옵저버터리! 옵저버로 마인 대비!',
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
              altText: '{home} 선수 드라군이 푸시! 테란 병력이 모이기 전에!',
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
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아둔에서 템플러 아카이브까지! 스톰으로 물량을 상대하려 합니다!',
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
              altText: '{home} 선수 스톰이 투하! 테란 메카닉을 녹여냅니다!',
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
              text: '{away}, 시즈 탱크가 일제 포격! 프로토스 병력을 부숩니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 탱크가 업그레이드된 화력으로 프로토스를 압도합니다!',
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

