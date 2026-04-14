part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 9오버풀 — 초반 저글링전 → 확장 분기 → 뮤탈전
// 타이밍: 9풀 발업 저글링 2:14, 도착 2:51, 발업 완료 2:58
//         9오버풀 풀 완성 2:15, 저글링 ~2:33
// → 둘 다 올인이 아니라 초반에 안 끝남
// → 9오버풀은 앞마당/본진 해처리 분기, 9풀 발업은 압박/확장 분기
// → 둘 다 무난하면 레어 → 스파이어 → 뮤탈전
// ----------------------------------------------------------
const _zvz9poolSpeedVs9overpool = ScenarioScript(
  id: 'zvz_9pool_speed_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9풀 발업 vs 9오버풀 — 저글링전 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9드론에 스포닝풀과 가스를 동시에! 저글링 속업을 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 오버로드를 먼저 올립니다! 풀은 그 다음!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 9드론에 오버로드 후 스포닝풀! 인구를 먼저 확보하고 풀 진입!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 발업도 연구 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home}, 저글링에 발업! 가스 드론은 미네랄로 복귀!',
        ),
        ScriptEvent(
          text: '{away} 선수 풀이 완성되면서 저글링 생산 시작! 오버로드를 먼저 올린 만큼 살짝 늦습니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링이 나오기 시작합니다! 상대보다 한 박자 늦지만 드론이 1기 더 많습니다!',
        ),
        ScriptEvent(
          text: '스포닝풀 타이밍 한 박자 차이가 발업 타이밍까지 이어집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '스포닝풀이 먼저인 쪽이 저글링을 뽑았지만 상대도 곧 저글링이 나옵니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 — 9오버풀 이미 저글링 보유 (lines 11-16)
    ScriptPhase(
      name: 'ling_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대도 저글링이 나와있습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 저글링 도착! 하지만 상대 저글링과 마주칩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비합니다! 드론도 1기 더 많은 상태!',
          owner: LogOwner.away,
          awayArmy: 2,
          altText: '{away}, 저글링이 준비되어 있습니다! 드론 우위도 살짝 있습니다!',
        ),
        ScriptEvent(
          text: '아직 발업이 안 끝났습니다! 노발업 상태에서 저글링전이 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '발업 완료까지 조금 남았는데 그 전에 저글링 교전이 벌어집니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 교전 — 비등/홈 피해/어웨이 피해 (lines 17-22)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 17,
      branches: [
        // 분기: 비등한 교전
        ScriptBranch(
          id: 'ling_even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수와 {away} 선수 저글링이 엉킵니다! 비등한 교전!',
              owner: LogOwner.system,
              homeArmy: -2, awayArmy: -2,
              altText: '양쪽 저글링이 부딪힙니다! 서로 비슷한 피해를 주고받습니다!',
            ),
            ScriptEvent(
              text: '양쪽 다 저글링이 빠졌지만 큰 차이는 없습니다! 다음 단계로 넘어갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '초반 저글링전은 비등! 이제 확장 타이밍이 중요합니다!',
            ),
          ],
        ),
        // 분기: 9풀 발업 쪽이 드론 피해를 줌
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 수비 저글링을 피해 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -1, awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 저글링 컨트롤! 드론을 몇 기 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠졌지만 치명적이진 않습니다! 게임은 계속됩니다!',
              owner: LogOwner.away,
              altText: '{away}, 드론 손실이 있지만 아직 괜찮습니다!',
            ),
          ],
        ),
        // 분기: 9오버풀 쪽이 수비 잘 함
        ScriptBranch(
          id: 'away_ling_harass',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링과 드론으로 상대 저글링을 잡아냅니다! 피해 없이 수비!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away}, 드론 합세로 발업 저글링을 잡습니다! 깔끔한 수비!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 좀 빠졌습니다! 하지만 발업이 곧 완료됩니다!',
              owner: LogOwner.home,
              altText: '{home}, 저글링 손실이 있지만 발업 완료가 다가옵니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 확장 분기 — 9오버풀 확장 + 9풀 발업 반응 (lines 23-30)
    ScriptPhase(
      name: 'expansion_phase',
      startLine: 23,
      branches: [
        // 분기 A: 9풀 발업이 추가 저글링으로 압박 → 결착
        ScriptBranch(
          id: 'speed_pressure_kills',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리를 추가합니다! 확장에 들어가려는 순간!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 앞마당 해처리를 건설합니다! 경기를 길게 가져가려 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링을 추가 생산! 확장 타이밍을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'attack',
              altText: '{home}, 발업 저글링 추가 투입! 해처리 건설 중에 들어갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리에 자원을 쓴 상태에서 저글링이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
              altText: '{away}, 확장에 자원을 쓴 타이밍에 압박이 들어옵니다!',
            ),
            ScriptEvent(
              text: '확장 타이밍을 정확히 찔렀습니다! 발업 저글링 압박 성공!',
              owner: LogOwner.home,
              decisive: true,
              altText: '해처리 건설 중 압박에 무너집니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        // 분기 B: 9오버풀이 압박을 막고 경제 우위로 결착
        ScriptBranch(
          id: 'overpool_defends_expands',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리를 추가하면서 저글링도 보충합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
              altText: '{away}, 확장과 수비를 동시에! 드론 우위가 빛납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링으로 압박하지만 수비가 단단합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -8,
              altText: '{home}, 압박을 넣지만 상대 저글링이 충분합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 완성! 라바가 두 배로 돌기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10, favorsStat: 'macro',
              altText: '{away}, 해처리 2개의 라바 이점! 저글링 물량이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '확장 수비 성공! 해처리 라바 이점으로 결착합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '압박을 막고 해처리 우위를 가져갑니다! 라바 차이가 결정적!',
            ),
          ],
        ),
        // 분기 C: 양쪽 모두 확장 → 게임 계속 (비결착)
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리를 추가합니다! 확장에 들어갑니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 앞마당 해처리 건설! 경기를 길게 가져가려 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 앞마당 해처리를 건설합니다! 따라갑니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 압박 대신 해처리! 경기가 중반으로 넘어갑니다!',
            ),
            ScriptEvent(
              text: '양쪽 모두 앞마당 해처리! 이제 레어 타이밍이 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '둘 다 확장! 이제 테크 싸움으로 갑니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3.5: 스파이어 건설 (startLine 29)
    ScriptPhase(
      name: 'spire_transition',
      startLine: 29,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 스파이어가 올라갑니다! 뮤탈전이 임박합니다!',
          owner: LogOwner.system,
          altText: '스파이어 완성! 뮤탈리스크 생산이 시작됩니다!',
        ),
      ],
    ),
    // Phase 4: 레어 → 스파이어 → 뮤탈전 (lines 31-38)
    ScriptPhase(
      name: 'mutal_war',
      startLine: 31,
      branches: [
        // 분기: 홈(9풀 발업) 뮤탈 우위
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 진화를 시작합니다! 발업이 이미 있으니 레어에 집중!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화 시작! 뮤탈 타이밍을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화! 가스를 모읍니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 테크 타이밍 싸움입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 상대 드론을 견제합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크로 드론을 견제합니다! 스커지로 상대 뮤탈도 잡습니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'harass',
              altText: '{home}, 뮤탈 컨트롤이 좋습니다! 상대 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이! 드론 견제가 누적되면서 결착!',
              owner: LogOwner.home,
              decisive: true,
              altText: '뮤탈 물량에서 앞서면서 드론 차이를 벌립니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        // 분기: 어웨이(9오버풀) 뮤탈 우위
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화를 시작합니다! 해처리가 먼저라 라바 이점이 있습니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 해처리 2개의 라바로 드론과 유닛을 동시에!',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화! 테크를 서둘러 올립니다!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화! 테크 타이밍을 놓치면 안 됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 라바가 많아 추가 생산도 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20,
              altText: '{away}, 뮤탈 등장! 해처리 2개라 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론을 견제합니다! 스커지도 정확히 적중!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'harass',
              altText: '{away}, 뮤탈 컨트롤! 상대 뮤탈을 스커지로 잡으면서 드론도 견제!',
            ),
            ScriptEvent(
              text: '뮤탈 물량에서 밀립니다! 해처리 라바 이점이 결정적!',
              owner: LogOwner.away,
              decisive: true,
              altText: '라바 차이로 뮤탈 보충이 빠릅니다! 물량 차이로 결착!',
            ),
          ],
        ),
      ],
    ),
  ],
);
