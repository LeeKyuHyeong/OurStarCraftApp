part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 9풀 레어 — 라바 분배 철학의 충돌
// 타이밍: 둘 다 첫 저글링 2:14 동시
// 9풀 발업: 가스100 → 발업(2:08→2:58), 가스 드론 미네랄 복귀
// 9풀 레어: 가스100 → 레어(2:08→3:11), 가스 드론 유지 → 스파이어 4:01 → 뮤탈 4:39
// 핵심: 발업 압박 vs 뮤탈 타이밍 레이스
// ----------------------------------------------------------
const _zvz9poolSpeedVs9poolLair = ScenarioScript(
  id: 'zvz_9pool_speed_vs_9pool_lair',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_9pool_lair'],
  description: '9풀 발업 vs 9풀 레어 — 저글링전 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 같은 9풀, 갈리는 투자 (lines 1-10)
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
          text: '{away} 선수도 9드론에 스포닝풀과 익스트랙터! 같은 타이밍이에요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 역시 9드론에 스포닝풀과 가스를 동시에! 레어를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 가스 100에서 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home}, 저글링에 발업! 가스 드론을 미네랄로 돌립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 가스 100에서 레어 진화 시작!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -5,
          altText: '{away}, 저글링은 같은 수! 하지만 가스는 레어에 투자합니다!',
        ),
        ScriptEvent(
          text: '같은 타이밍 스포닝풀에서 갈라집니다! 발업 대 레어, 라바 분배가 다릅니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '발업은 저글링 속도에, 레어는 빠른 테크에 투자하는 갈림길!',
        ),
      ],
    ),
    // Phase 1: 저글링 교전 시작 — 수는 같지만 미네랄 차이 (lines 11-16)
    ScriptPhase(
      name: 'ling_clash',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 상대 진영으로! 가스 드론을 미네랄로 돌려서 보충이 빠릅니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home}, 발업 쪽은 가스 드론이 미네랄로 복귀해서 저글링 추가가 빠릅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비! 가스 드론이 계속 가스를 캐고 있어요!',
          owner: LogOwner.away,
          awayArmy: 1,
          altText: '{away}, 레어 진화를 위해 가스 드론을 유지합니다! 저글링 보충은 살짝 느립니다!',
        ),
        ScriptEvent(
          text: '저글링 수는 비슷하지만 발업 쪽이 보충이 빠릅니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '가스 드론 차이가 미네랄 수입에 영향을 줍니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 교전 결과 (lines 17-22)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 17,
      branches: [
        ScriptBranch(
          id: 'ling_even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양쪽 저글링이 부딪힙니다! 비등한 교전입니다!',
              owner: LogOwner.system,
              homeArmy: -2, awayArmy: -2,
              altText: '저글링 대 저글링! 서로 비슷한 피해를 주고받습니다!',
            ),
            ScriptEvent(
              text: '초반 저글링전은 비등! 이제 발업 완료 타이밍이 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
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
              text: '{away} 선수 드론이 빠졌지만 레어 진화는 계속됩니다!',
              owner: LogOwner.away,
              altText: '{away}, 드론 손실이 있지만 레어 완성이 다가옵니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_ling_harass',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링과 드론으로 상대 저글링을 잡아냅니다!',
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
    // Phase 3: 발업 완료 — 압박 vs 테크 (lines 23-30)
    ScriptPhase(
      name: 'speed_vs_tech',
      startLine: 23,
      branches: [
        // 분기 A: 발업 압박으로 레어 테크 끊기
        ScriptBranch(
          id: 'speed_breaks_tech',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 발업 저글링을 추가 생산해서 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'control',
              altText: '{home}, 발업 저글링 추가 투입! 레어 완성 전에 끝내려 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레어 진화 중인데 발업 저글링이 들어옵니다! 속도 차이가 큽니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
              altText: '{away}, 노발업 저글링으로는 발업 저글링을 못 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론까지 물어뜯습니다! 스파이어까지 갈 자원이 없습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 드론이 너무 많이 빠졌습니다! 스파이어까지 갈 수 없습니다!',
            ),
            ScriptEvent(
              text: '발업 저글링이 레어 테크를 끊었습니다! 스파이어까지 갈 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '발업 압박 성공! 스파이어를 올릴 자원이 남아있지 않습니다!',
            ),
          ],
        ),
        // 분기 B: 레어 측이 수비하고 뮤탈 선점
        ScriptBranch(
          id: 'lair_defends_to_mutal',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 압박을 넣지만 레어 측 수비가 단단합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -8,
              altText: '{home}, 발업 저글링으로 압박! 하지만 상대 수비가 좋습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링과 드론으로 막아냅니다! 레어가 곧 완성됩니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away}, 수비 성공! 레어 진화가 완료됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레어 완성! 스파이어가 가까워집니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10,
              altText: '{away}, 레어 완성! 발업 쪽보다 테크가 훨씬 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 올립니다! 뮤탈이 먼저 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10,
              altText: '{away}, 스파이어 건설! 뮤탈리스크 생산이 시작됩니다!',
            ),
            ScriptEvent(
              text: '뮤탈이 먼저 나왔습니다! 대공 없는 상대를 견제합니다!',
              owner: LogOwner.away,
              homeResource: -15,
              decisive: true,
              altText: '뮤탈 선점! 발업 쪽은 아직 레어도 시작 안 했습니다!',
            ),
          ],
        ),
        // 분기 C: 발업 측도 확장 → 양쪽 중반전
        ScriptBranch(
          id: 'both_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 하지만 압박 대신 앞마당 해처리를 건설합니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 발업은 챙기고 확장으로! 경기가 길어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레어가 곧 완성됩니다! 테크를 서두릅니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화 중! 테크 우위를 노립니다!',
            ),
            ScriptEvent(
              text: '양쪽 모두 중반으로! 테크 싸움이 시작됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '발업 쪽도 확장! 이제 테크 타이밍이 관건입니다!',
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
    // Phase 4: 뮤탈전 (lines 31-38)
    ScriptPhase(
      name: 'mutal_war',
      startLine: 31,
      branches: [
        // 분기: 홈(발업) 뮤탈 승리 — 컨트롤로 역전
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 0.9,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 완성! 테크 전환을 서두릅니다!',
              owner: LogOwner.away,
              awayArmy: 0, awayResource: -5,
              altText: '{away}, 레어 완성! 레어 빌드의 진가가 드러납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 올립니다! 뮤탈이 먼저 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
              altText: '{away}, 스파이어 완성! 뮤탈리스크 생산 시작!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.home,
              homeResource: -10,
              skipChance: 0.7,
              altText: '{home}, 스포어로 본진과 앞마당을 수비합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화를 서둘러 올립니다! 테크가 늦습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 뒤늦게 레어! 테크 격차를 좁혀야 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈이 늦게 나왔지만 스커지 컨트롤이 좋습니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -15,
              altText: '{home}, 뮤탈 등장! 상대 스커지를 피하면서 드론을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 상대 스커지를 전부 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'control',
              altText: '{home}, 뮤탈 컨트롤이 결정적! 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이로 역전! 발업 쪽이 드론 견제에서 앞섭니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '뮤탈은 늦었지만 컨트롤로 뒤집었습니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        // 분기: 어웨이(레어) 뮤탈 승리 — 타이밍 우위
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 완성! 테크 우위를 가져갑니다!',
              owner: LogOwner.away,
              awayArmy: 0, awayResource: -5,
              altText: '{away}, 레어 완성! 상대는 아직 레어가 멀었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 올립니다! 뮤탈이 먼저 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15,
              altText: '{away}, 스파이어 완성! 뮤탈리스크 생산 시작!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 상대 드론을 견제합니다! 대공이 없습니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away}, 뮤탈 견제! 발업 쪽은 스파이어가 아직 멀었습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 올리지만 드론이 녹고 있습니다!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home}, 뒤늦게 스파이어! 하지만 드론 손실이 너무 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 추가 생산! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'harass',
              altText: '{away}, 뮤탈 물량에서 압도! 스커지도 정확히 적중합니다!',
            ),
            ScriptEvent(
              text: '뮤탈 타이밍 차이가 결정적! 빠른 레어 테크가 빛을 발합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '레어 빌드의 뮤탈 선점! 타이밍 차이를 좁힐 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
