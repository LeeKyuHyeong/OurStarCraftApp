part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4. 4풀 vs 전진 게이트 (치즈 대결)
// ----------------------------------------------------------
const _zvpCheeseVsCheese = ScenarioScript(
  id: 'zvp_cheese_vs_cheese',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool', 'zvp_5drone'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_2gate_zealot', 'pvz_cannon_rush', 'pvz_8gat'],
  description: '저그 올인 vs 프로토스 올인 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 아주 빠르게 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 엄청 빠릅니다! 올인인가요?',
        ),
        ScriptEvent(
          text: '{away} 선수도 게이트웨이를 일찍 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 게이트웨이가 빠릅니다! 양쪽 다 공격적!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
        ),
      ],
    ),
    // Phase 1: 충돌 (lines 11-16)
    ScriptPhase(
      name: 'collision',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 모두 올인! 센터에서 마주칠 수 있습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 저글링이 질럿을 만났습니다! 수적 우위!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 저글링 서라운드! 질럿을 감쌉니다!',
        ),
        ScriptEvent(
          text: '{away}, 질럿의 화력으로 저글링을 잡아냅니다!',
          owner: LogOwner.away,
          homeArmy: -1, awayArmy: 2, favorsStat: 'control',
          altText: '{away} 선수 질럿 컨트롤! 질럿이 저글링을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 합류시킵니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          altText: '{home}, 저글링 추가 합류! 물량 싸움입니다!',
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-28)
    ScriptPhase(
      name: 'cheese_result',
      startLine: 17,
      branches: [
        // 분기 A: 저글링 물량 승리 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'lings_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 물량이 질럿을 압도합니다! 프로브를 향해 돌진!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -10, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 프로브를 초토화!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 프로브가 역부족입니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
            ),
            ScriptEvent(
              text: '저글링 물량이 프로토스를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 질럿 수비 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'zealots_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 저글링을 다 잡아냅니다! 컨트롤 차이!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 질럿 컨트롤! 질럿이 저글링을 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 전멸! 추가 생산할 자원도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '질럿이 저글링을 압도했습니다! 프로토스 유리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

