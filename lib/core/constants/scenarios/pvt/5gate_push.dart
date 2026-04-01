part of '../../scenario_scripts.dart';

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
          text: '{home} 선수 사이버네틱스 코어 건설 후 게이트웨이를 계속 추가합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 게이트웨이가 빠르게 늘어납니다!',
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
          text: '{away} 선수 팩토리에 머신샵! 탱크 생산 시작.',
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
          altText: '{away}, 탱크가 모이기 전에 공격당합니다!',
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
              text: '{away}, 시즈 탱크가 시즈 모드! 프로토스 병력을 녹입니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'defense',
              altText: '{away} 선수 탱크가 포격! 프로토스 전선을 부숩니다!',
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

