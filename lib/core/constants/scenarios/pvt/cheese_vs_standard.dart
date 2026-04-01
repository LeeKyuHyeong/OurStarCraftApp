part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 3. 센터 게이트 vs 스탠다드 테란 전체 (치즈 vs 스탠다드)
// ----------------------------------------------------------
const _pvtCheeseVsStandard = ScenarioScript(
  id: 'pvt_cheese_vs_standard',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate', 'pvt_2gate_zealot'],
  awayBuildIds: [
    'tvp_double', 'tvp_rax_double', 'tvp_fd',
    'tvp_fake_double', 'tvp_1fac_drop', 'tvp_5fac_timing',
    'tvp_1fac_gosu', 'tvp_mine_triple', 'tvp_11up_8fac', 'tvp_anti_carrier',
    'tvp_trans_tank_defense', 'tvp_trans_upgrade', 'tvp_trans_bio_mech',
    'tvp_trans_timing_push', 'tvp_trans_5fac_mass', 'tvp_trans_anti_carrier',
  ],
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
    // Phase 2: 러시 결과 - 분기 (lines 19-32)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        // 분기 A: 질럿 러시 성공
        ScriptBranch(
          id: 'zealot_rush_success',
          baseProbability: 0.45,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 SCV를 베기 시작합니다! 벙커가 완성되지 않았어요!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 들어갔습니다! 일꾼을 베어냅니다!',
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
        // 분기 B: 테란 수비 성공 → 트랜지션 분기
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
              text: '벙커가 지켜냈습니다! 프로토스 러시 실패!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
