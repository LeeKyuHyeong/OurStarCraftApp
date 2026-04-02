part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 리버 아비터 vs 바이오 메카닉: 스톰 + 리콜 vs 복합 병력
// ----------------------------------------------------------
const _pvtReaverArbiterVsBioMech = ScenarioScript(
  id: 'pvt_reaver_arbiter_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_reaver_arbiter', 'pvt_1gate_expand', 'pvt_reaver_shuttle'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_rax_double'],
  description: '리버 아비터 vs 바이오 메카닉 — 스톰으로 바이오를 녹이고 리콜로 찌른다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 이후 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭과 팩토리를 함께 건설합니다! 바이오 메카닉!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 배럭과 팩토리! 복합 병력을 준비하는군요!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스와 서포트 베이를 건설합니다. 로보 아비터 빌드입니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 로보틱스와 서포트 베이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 시즈탱크를 동시에 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '바이오 메카닉의 다양한 병력 vs 풀테크 프로토스! 어떤 전개가 펼쳐질까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 리버 견제 + 스톰 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 셔틀 리버로 테란 확장 기지를 견제합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 추가하면서 복합 진형을 갖춥니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 마린 탱크 골리앗! 풀세트 바이오 메카닉!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브를 건설합니다! 스톰을 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 스캐럽이 마린 뭉치에 떨어져 피해를 줍니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'harass',
          altText: '{home}, 리버 스캐럽이 마린을 잡습니다!',
        ),
        ScriptEvent(
          text: '리버 견제가 효과적입니다! 하지만 복합 병력이 점점 모이고 있어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 아비터 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아비터가 완성됩니다! 하이 템플러도 합류!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'strategy',
          altText: '{home}, 아비터와 하이 템플러! 풀테크 완성!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이언스 베슬을 준비합니다. 아비터 대비!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 복합 병력 대부대가 프로토스를 향해 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '풀테크 vs 복합 병력! 대규모 회전이 임박합니다!',
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
              text: '{home} 선수 사이오닉 스톰이 마린 메딕에 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -5,
              favorsStat: 'strategy',
              altText: '{home}, 스톰 두 방! 바이오 병력이 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 아비터 리콜로 테란 멀티를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크만 남았지만 드라군에게 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '스톰과 리콜! 풀테크의 위력입니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 사이언스 베슬 EMP가 하이 템플러 에너지를 제거합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              awayArmy: 2,
              favorsStat: 'strategy',
              altText: '{away}, EMP! 하이 템플러가 무력화됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈탱크가 드라군을 잡고 마린이 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 복합 병력이 넥서스까지 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: 'EMP로 테크를 무력화! 복합 병력이 밀어냅니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
