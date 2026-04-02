part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 바이오 메카닉
// ----------------------------------------------------------
const _pvt5gateArbiterVsBioMech = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_rax_double'],
  description: '5게이트 아비터 vs 바이오 메카닉 — 스톰으로 바이오 제압, 리콜로 메카닉 우회',
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
          text: '{away} 선수 배럭 건설! 아카데미도 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에 아카데미! 바이오닉 테크를 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어에 넥서스! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어 이후 넥서스 건설!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 마린과 탱크를 섞는 빌드입니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다! 바이오 메카닉 조합이군요.',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가하면서 드라군을 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 생산과 동시에 탱크 생산! 복합 편성!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 마린 메딕에 시즈 탱크까지! 강력한 조합이죠.',
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
          text: '{away} 선수 마린 탱크 편대가 중앙으로 전진합니다.',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
          altText: '{away}, 바이오 메카닉 부대가 이동합니다! 탱크 배치!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 견제하면서 시간을 벌고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗도 추가합니다! 대공까지 갖추는군요.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 골리앗 생산! 마린 탱크 골리앗 풀조합!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 스톰이 필요합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아둔에서 템플러 아카이브! 바이오닉엔 스톰이 답이죠.',
        ),
        ScriptEvent(
          text: '바이오 메카닉 복합 편성, 프로토스가 어떻게 대응할까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          text: '{home} 선수 게이트웨이 5개 풀가동! 하이 템플러도 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 5게이트에서 병력이 쏟아집니다! 하이 템플러도!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 아비터 트리뷰널까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아비터 트리뷰널이 올라갑니다! 리콜 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리에서 업그레이드 중! 병력 증강을 계속합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아비터 생산 시작! 리콜 에너지가 차기를 기다립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 아비터 등장 임박! 전세가 바뀔 수 있습니다.',
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
              text: '{home} 선수 스톰이 마린 메딕 위에 떨어집니다! 바이오닉이 증발!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -1, favorsStat: 'strategy',
              altText: '{home}, 스톰 투하! 상대 병력이 순식간에 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 아비터 리콜! 탱크 라인 뒤로 병력 투하!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'sense',
              altText: '{home} 선수 리콜로 메카닉 후방을 급습합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 바이오닉은 스톰에, 메카닉은 리콜에! 양쪽 다 당합니다!',
              owner: LogOwner.away,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '스톰과 리콜의 이중 타격! 바이오 메카닉이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗이 아비터를 집중 사격! 대공 화력이 강합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 골리앗 대공! 아비터가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away}, 마린이 스톰을 피하며 분산 이동! 탱크가 포격합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 마린 분산 컨트롤! 스톰 피해를 줄입니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크 골리앗 마린 총공격! 삼위일체 화력!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '바이오 메카닉의 복합 화력이 프로토스를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
