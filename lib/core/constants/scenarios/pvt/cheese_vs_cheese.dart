part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 치즈 vs 치즈 (센터 게이트 vs 센터 8배럭 BBS)
// ----------------------------------------------------------
const _pvtCheeseVsCheese = ScenarioScript(
  id: 'pvt_cheese_vs_cheese',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_bbs'],
  description: '센터 게이트 vs 센터 8배럭 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
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
          text: '{away} 선수도 SCV를 센터로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 게이트웨이! 공격적인 오프닝!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 배럭 건설! 양쪽 다 센터에 건물을 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 센터 배럭! 양쪽 다 공격적입니다!',
        ),
        ScriptEvent(
          text: '양측 모두 센터에 건물을 올렸습니다! 치즈 대 치즈!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 초반 병력 생산 (lines 11-18)
    ScriptPhase(
      name: 'early_units',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 마린 생산! 본진 배럭에서도 마린이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 질럿 2기! 테란 쪽으로 향합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 질럿이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 마린 3기에 SCV까지 끌고 나옵니다! 벙커를 지으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -5,
          altText: '{away} 선수 SCV를 동원합니다! 벙커링 준비!',
        ),
      ],
    ),
    // Phase 2: 정면 충돌 - 분기 (lines 19-30)
    ScriptPhase(
      name: 'cheese_clash',
      startLine: 19,
      branches: [
        // 분기 A: 질럿이 마린을 압도
        ScriptBranch(
          id: 'zealot_overwhelm',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 마린에 달라붙습니다! 마린이 녹아요!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 질럿 컨트롤! 마린을 순식간에 정리!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV로 수리하려 하지만 SCV가 너무 빨리 녹습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 테란 앞마당으로 진입합니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿이 마린을 제압했습니다! 프로토스 치즈가 우세!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 마린+벙커가 질럿을 막음
        ScriptBranch(
          id: 'marine_bunker_hold',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10, favorsStat: 'defense',
              altText: '{away} 선수 벙커 올렸습니다! 질럿을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커에 막힙니다! 체력만 깎여요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, SCV 수리로 벙커를 유지합니다! 추가 마린도 합류!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커가 질럿을 막아냈습니다! 테란 치즈가 우세!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

