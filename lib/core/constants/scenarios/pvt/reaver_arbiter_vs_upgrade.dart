part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs 더블 업그레이드: 후반 지향 대결
// ----------------------------------------------------------
const _pvtReaverArbiterVsUpgrade = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter', 'pvt_1gate_expand', 'pvt_reaver_shuttle'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '리버 아비터 vs 더블 업그레이드 — 풀테크 vs 업그레이드 물량',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 완성 후 드라군을 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이를 건설합니다! 업그레이드 빌드!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 엔지니어링 베이! 더블 업그레이드를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이를 건설하고 넥서스를 확장합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스, 서포트 베이와 넥서스 확장을 동시에! 매크로 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올리면서 1-1 업그레이드를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '양쪽 모두 후반을 바라보는 빌드입니다! 누가 더 빨리 완성할까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버 견제 + 테크 경쟁 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버로 견제를 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 터렛을 올리고 마린으로 방어합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브를 건설합니다! 하이 템플러를 준비하네요!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 템플러 아카이브가 올라갑니다! 사이오닉 스톰!',
        ),
        ScriptEvent(
          text: '{away} 선수 2-2 업그레이드를 시작합니다! 병력 질이 올라가겠네요!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 2-2 업그레이드 진행 중! 마린이 점점 강해집니다!',
        ),
        ScriptEvent(
          text: '테크 대 업그레이드! 어느 쪽 투자가 더 빛을 발할까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 최종 병력 구성 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터 트리뷰널을 건설합니다! 최종 테크!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 업그레이드된 마린 메딕 대부대를 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'macro',
          altText: '{away}, 3-3 업그레이드 마린! 한 기 한 기가 무섭습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러도 합류합니다! 스톰 에너지 충전 중!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '풀테크 프로토스 vs 풀업그레이드 테란! 대규모 교전이 시작됩니다!',
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
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 사이오닉 스톰이 마린 뭉치에 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -5,
              favorsStat: 'strategy',
              altText: '{home}, 스톰 한 방에 상대 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 리콜로 테란 확장 기지를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayResource: -25,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드된 병력이지만 스톰에 녹았습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '스톰과 리콜의 콤보! 업그레이드가 소용없었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 업그레이드 마린이 스톰을 맞기 전에 산개합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away}, 마린이 깔끔하게 산개합니다! 스톰 피해가 적어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 사이언스 베슬 EMP로 아비터 에너지를 제거합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 마린이 넥서스를 직접 타격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              homeResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '업그레이드 물량에 테크가 밀립니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
