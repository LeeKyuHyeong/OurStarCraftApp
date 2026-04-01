part of '../../scenario_scripts.dart';

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
          text: '{home} 선수 사이버네틱스 코어 이후 로보틱스 건설! 서포트 베이도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 사이버네틱스 코어 이후 로보틱스에 서포트 베이까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 머신샵도 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 빠르게 테크를 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀 생산 시작! 서포트 베이에서 준비 중!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 셔틀 생산 중! 서포트 베이가 가동됩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 병력을 빠르게 모으려는 의도!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 팩토리 증설! 빠른 타이밍을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀 완성! 리버를 태울 준비가 됐습니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 투입 vs 타이밍 공격 (lines 17-26)
    ScriptPhase(
      name: 'shuttle_drop_vs_timing',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 셔틀에 리버를 태우고 출격! 테란 일꾼으로 향합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버 투하! 테란 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 병력을 모아서 전진합니다! 타이밍 공격!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20, favorsStat: 'attack',
          altText: '{away}, 벌처 편대가 프로토스로 이동합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미에 엔지니어링 베이, 아머리까지! 업그레이드와 대공 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아카데미와 엔지니어링 베이, 아머리 건설! 골리앗도 대비합니다!',
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
          baseProbability: 0.50,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽이 일꾼에 명중! 5기가 한 번에 날아갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽이 대박! 테란 일꾼을 초토화합니다!',
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
          baseProbability: 0.50,
          events: [
            ScriptEvent(
              text: '{away} 선수 터렛과 골리앗이 셔틀을 포착합니다!',
              owner: LogOwner.away,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 골리앗이 셔틀을 격추합니다! 리버도 함께 떨어집니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 골리앗이 셔틀을 잡아냅니다! 리버도 고립!',
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
          text: '{away}, 탱크가 시즈 포격! 한 방에 프로토스 병력을 날립니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
          altText: '{away} 선수 탱크가 포격! 프로토스 전선을 무너뜨립니다!',
        ),
        ScriptEvent(
          text: '{home}, 질럿이 돌진! 탱크 뒤를 노립니다!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 질럿 돌진! 탱크 라인 교란!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 스톰을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.3,
          altText: '{home}, 아둔에서 템플러 아카이브까지! 하이 템플러 테크!',
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
              altText: '{home}, 리버가 스캐럽으로 저항! 하지만 물량 차이가 너무 커요!',
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

