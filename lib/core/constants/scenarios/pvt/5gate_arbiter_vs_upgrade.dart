part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 더블 업그레이드
// ----------------------------------------------------------
const _pvt5gateArbiterVsUpgrade = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '5게이트 아비터 vs 더블 업그레이드 — 후반 테크 대결',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 배럭에서 팩토리까지. 안정적인 오프닝입니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭 팩토리 순서로 올립니다. 기본기에 충실하네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 넥서스! 확장을 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 엔지니어링 베이도 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 커맨드센터에 엔지니어링 베이! 업그레이드 준비!',
        ),
        ScriptEvent(
          text: '양측 모두 확장을 가져가면서 후반을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가합니다. 다섯 개까지 늘리겠네요.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 공방 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 공방 업그레이드가 핵심!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 물량을 끌고 중앙을 차지합니다.',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'macro',
          altText: '{home}, 드라군 편대가 맵 중앙으로! 시야를 확보합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 1-1 업그레이드 완료! 2-2 연구 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 템플러 아카이브로 이어갑니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔에서 템플러 아카이브! 하이 템플러를 준비합니다.',
        ),
        ScriptEvent(
          text: '양쪽 다 후반 테크에 집중하고 있습니다. 장기전이 예상됩니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트에서 아비터 트리뷰널 건설!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타게이트와 아비터 트리뷰널! 아비터가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 3-3 업그레이드 연구 시작! 풀업 병력이 완성됩니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 3-3 업그레이드! 풀업 마린 메딕이면 화력이 다릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러와 아비터를 동시에 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 사이언스 퍼실리티 건설! EMP를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 사이언스 퍼실리티! EMP로 아비터를 견제할 수 있죠.',
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 리콜! 테란 3번째 확장기지로 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -30, favorsStat: 'sense',
              altText: '{home}, 리콜 투하! 테란 확장 기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{home}, 스톰이 연속으로 떨어집니다! 업그레이드 마린도 스톰에는 약하죠!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 병력을 돌리지만 리콜 지점 수비가 늦습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 병력이 분산되면서 수비가 힘듭니다!',
            ),
            ScriptEvent(
              text: '스톰과 리콜의 시너지! 업그레이드 병력도 막을 수 없었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 3-3 풀업 마린 메딕이 전진합니다! 화력이 남다릅니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'macro',
              altText: '{away}, 풀업 바이오닉! 업그레이드 차이가 체감됩니다!',
            ),
            ScriptEvent(
              text: '{away}, EMP! 하이 템플러의 에너지를 소진시킵니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'sense',
              altText: '{away} 선수 EMP가 정확합니다! 스톰을 봉쇄!',
            ),
            ScriptEvent(
              text: '{away}, 풀업 마린이 드라군을 녹입니다! 업그레이드 차이가 결정적!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '업그레이드의 위력! 풀업 바이오닉이 프로토스를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
