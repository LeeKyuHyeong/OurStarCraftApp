part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 12앞마당 — 풀 완성 시점에 저글링 도착
// 타이밍: 9풀 발업 도착 2:51, 발업 완료 2:58
//         12앞 풀 완성 2:52, 저글링 ~3:10
// → 9풀 도착(2:51) 시 12앞은 풀이 막 완성(2:52)! 저글링 없음!
// → 둘 다 올인은 아니라 초반에 안 끝날 수 있음
// → 12앞이 버티면 해처리 라바 이점 → 레어 → 스파이어 → 뮤탈전
// ----------------------------------------------------------
const _zvz9poolSpeedVs12hatch = ScenarioScript(
  id: 'zvz_9pool_speed_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_12hatch'],
  description: '9풀 발업 vs 12앞 — 저글링 압박 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 빌드 차이 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 9드론에 스포닝풀과 가스를 동시에! 저글링 속업을 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 앞마당 해처리를 먼저 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리를 먼저 올리고 풀은 나중에!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 발업도 연구 시작합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -8,
          altText: '{home}, 저글링에 발업! 앞마당부터 올린 상대를 노릴 수 있는 타이밍!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 스포닝풀을 올립니다! 앞마당에 투자해서 풀이 많이 늦었습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 앞마당 해처리 후 스포닝풀! 저글링이 한참 뒤에 나옵니다!',
        ),
        ScriptEvent(
          text: '스포닝풀 완성 시점이 거의 동시입니다! 하지만 한쪽은 앞마당이 이미 올라가있죠!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '상대 풀이 막 완성되려는 시점에 저글링이 도착합니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 — 풀 막 완성, 저글링 없음 (lines 8-12)
    ScriptPhase(
      name: 'ling_arrives',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대 풀이 막 완성되는 시점입니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home}, 저글링 도착! 상대 풀은 완성됐지만 저글링은 아직 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 풀은 완성됐지만 저글링이 아직 안 나왔습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 3,
          altText: '{away}, 저글링 생산을 시작했지만 나오려면 아직 시간이 필요합니다!',
        ),
        ScriptEvent(
          text: '풀은 완성됐는데 저글링이 나오려면 시간이 더 필요합니다! 드론으로 버텨야!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '앞마당부터 올린 쪽은 드론이 많지만 저글링 없이 버틸 수 있을까요?',
        ),
      ],
    ),
    // Phase 2: 초반 교전 결과 — 드론 수비 (lines 13-17)
    ScriptPhase(
      name: 'initial_fight',
      branches: [
        // 분기: 비등한 교전 — 드론으로 저글링 잡고 저글링도 드론 피해 줌
        ScriptBranch(
          id: 'fight_even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론을 뭉쳐서 저글링과 교전합니다! 저글링도 드론을 몇 기 잡습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              homeArmy: -2, awayArmy: -1, awayResource: -10,
              altText: '드론 대 저글링! 양쪽 모두 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '비등한 교환! 드론 피해가 있지만 저글링도 나오기 시작합니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기: 9풀 발업이 드론을 많이 잡음
        ScriptBranch(
          id: 'home_drone_kill',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 드론을 물어뜯습니다! 저글링이 없어서 피해가 큽니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: -1, awayResource: -15,              altText: '{home}, 저글링 돌파! 드론이 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 심각합니다! 저글링이 빨리 나와야 하는데!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -5,
              altText: '{away}, 저글링이 나오기 전에 드론이 많이 빠졌습니다!',
            ),
          ],
        ),
        // 분기: 12앞이 드론 컨트롤로 잘 막음
        ScriptBranch(
          id: 'away_drone_defense',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론 컨트롤이 좋습니다! 저글링을 잡으면서 피해를 최소화합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,              altText: '{away}, 드론을 뭉쳐서 저글링을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 밀립니다! 드론 물량이 많습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home}, 저글링이 드론에 당하고 있습니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 — 압박 vs 확장 (lines 18-22)
    ScriptPhase(
      name: 'mid_transition',
      branches: [
        // 분기 A: 발업 저글링 추가 압박 → 결착
        ScriptBranch(
          id: 'speed_pressure_kills',
          baseProbability: 0.9,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 추가 저글링을 보냅니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4, homeResource: -10,              altText: '{home}, 발업 저글링 추가 투입! 상대 앞마당을 못 살리겠다는 판단!',
            ),
            ScriptEvent(
              text: '{away} 선수 노발업 저글링이 나왔지만 발업 저글링 속도를 못 따라갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -2, awayResource: -10,
              altText: '{away}, 저글링이 나왔지만 속도 차이가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링이 드론을 추가로 잡습니다! 앞마당도 위험합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,              altText: '{home}, 드론이 계속 빠집니다! 상대 앞마당이 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '발업 저글링 압박 성공! 상대 드론이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '앞마당 해처리 투자가 독이 됐습니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        // 분기 B: 12앞이 수비 후 경제 우위로 결착
        ScriptBranch(
          id: 'hatch_defends_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 나오기 시작합니다! 드론과 합세해서 수비!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 4, homeArmy: -3,              altText: '{away}, 저글링 합류! 드론과 저글링으로 발업 압박을 막습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막히고 있습니다! 상대 해처리의 라바가 돌기 시작합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{home}, 발업 저글링이 밀립니다! 해처리 2개의 라바 차이!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바로 저글링이 밀려옵니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -10,              altText: '{away}, 라바 이점이 폭발합니다! 저글링 물량이 다릅니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 해처리 라바 이점으로 결착!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론 컨트롤로 버텨냈습니다! 해처리 2개가 빛을 발합니다!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 나오면서 수비에 성공합니다! 드론 피해는 있지만 버텼습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 3, homeArmy: -2,
              altText: '{away}, 저글링 합류로 수비! 앞마당 해처리는 살아있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 앞마당 해처리를 건설합니다! 압박을 접고 확장!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 압박이 안 되니 확장으로 전환! 경기가 길어집니다!',
            ),
            ScriptEvent(
              text: '양쪽 모두 앞마당! 이제 테크 싸움이 시작됩니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '둘 다 확장! 이제 테크 타이밍이 관건입니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3.5: 스파이어 건설 (startLine 23)
    ScriptPhase(
      name: 'spire_transition',
      linearEvents: [
        ScriptEvent(
          text: '양쪽 스파이어가 올라갑니다! 뮤탈전이 임박합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '스파이어 완성! 뮤탈리스크 생산이 시작됩니다!',
        ),
      ],
    ),
    // Phase 4: 뮤탈전 (lines 26-33)
    ScriptPhase(
      name: 'mutal_war',
      branches: [
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 진화를 시작합니다! 테크를 서두릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,
              altText: '{home}, 레어 진화! 뮤탈 타이밍을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화! 해처리가 먼저라 라바 이점이 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,
              altText: '{away}, 레어 진화! 해처리가 먼저 올라간 라바 이점으로 드론과 유닛 동시 생산!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 상대 드론을 견제합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 상대 스커지를 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -15, awayArmy: -2,              altText: '{home}, 뮤탈 컨트롤이 좋습니다! 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이! 드론 견제에서 앞서면서 결착!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '뮤탈 컨트롤로 라바 이점을 극복합니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화! 해처리 2개의 라바로 드론과 유닛을 동시에 뽑습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,
              altText: '{away}, 레어 진화! 라바가 많아 테크도 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화! 테크를 서두릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,
              altText: '{home}, 레어 진화! 테크 타이밍에서 밀리면 안 됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 라바가 많아 추가 생산도 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6, awayResource: -20,
              altText: '{away}, 뮤탈 등장! 해처리 2개라 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 본진과 앞마당을 수비합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론 견제! 스커지도 정확히 적중합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15, homeArmy: -2,              altText: '{away}, 뮤탈 물량에서 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '해처리 라바 이점! 뮤탈 물량에서 앞서면서 결착!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '앞마당 해처리의 라바 이점이 뮤탈전에서 빛을 발합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
