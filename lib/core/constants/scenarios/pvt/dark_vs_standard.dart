part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. 다크 템플러 vs 스탠다드 테란 전체 (기습 빌드)
// ----------------------------------------------------------
const _pvtDarkVsStandard = ScenarioScript(
  id: 'pvt_dark_vs_standard',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing', 'pvt_proxy_dark'],
  awayBuildIds: [
    'tvp_double', 'tvp_rax_double', 'tvp_fd',
    'tvp_fake_double', 'tvp_1fac_drop', 'tvp_5fac_timing',
    'tvp_1fac_gosu', 'tvp_mine_triple', 'tvp_11up_8fac', 'tvp_anti_carrier',
    'tvp_trans_tank_defense', 'tvp_trans_upgrade', 'tvp_trans_bio_mech',
    'tvp_trans_timing_push', 'tvp_trans_5fac_mass', 'tvp_trans_anti_carrier',
  ],
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
          text: '{away} 선수 팩토리 건설합니다. 머신샵도 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 탱크 준비!',
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
              altText: '{home} 선수 다크가 성공! 테란 일꾼을 줄줄이 베어냅니다!',
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
          text: '{away} 선수 시즈 탱크 생산! 아머리도 올려서 골리앗도 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 탱크와 아머리! 골리앗까지 대비합니다!',
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
              text: '{home}, 스톰! 탱크 벌처 편대에 떨어집니다!',
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
              text: '{away}, 탱크가 포격! 프로토스 병력을 부숩니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 탱크가 시즈 화력으로 프로토스를 날립니다!',
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
