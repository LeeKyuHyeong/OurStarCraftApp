part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 레어 vs 12풀 — 빠른 뮤탈 vs 드론 3기 우위
// 타이밍: 9풀 레어 저글링 2:14, 레어 3:11, 스파이어 4:01, 뮤탈 4:39
//         12풀 풀 2:22, 저글링 ~2:40, 드론 3기 우위, 발업 3:29
// → 9풀 레어가 뮤탈 훨씬 빠름 / 12풀은 드론 3기+발업으로 중반 안정
// ----------------------------------------------------------
const _zvz9poolLairVs12pool = ScenarioScript(
  id: 'zvz_9pool_lair_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_lair'],
  awayBuildIds: ['zvz_12pool'],
  description: '9풀 레어 vs 12풀 — 저글링전 → 확장 → 뮤탈전',
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
          altText: '{home}, 9풀 레어! 풀과 가스를 동시에!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 12기까지 뽑고 스포닝풀을 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀! 드론이 3기 더 많은 상태에서 풀 진입!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 가스 100에서 레어 진화 시작!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -5,
          altText: '{home}, 저글링과 레어 진화! 가스 드론은 계속 유지합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12풀 스포닝풀 완성! 저글링 생산 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 12풀 저글링이 나옵니다! 드론이 3기 많습니다!',
        ),
        ScriptEvent(
          text: '9풀 레어 대 12풀! 빠른 테크 대 드론 우위!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '9풀 레어는 테크가 빠르고, 12풀은 드론이 많습니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 — 12풀은 이미 저글링 보유 (lines 11-16)
    ScriptPhase(
      name: 'ling_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 12풀도 이미 저글링이 나와있습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 저글링 도착! 하지만 12풀 저글링이 수비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비합니다! 드론 수도 12기로 여유있습니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          altText: '{away}, 저글링이 준비되어 있고 드론도 많습니다!',
        ),
        ScriptEvent(
          text: '9풀 레어는 가스 드론 유지로 저글링 보충이 느립니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '레어 진화에 투자 중! 미네랄이 부족해서 저글링 추가가 느립니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 교전 (lines 17-22)
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
              text: '초반 저글링전은 비등! 레어 완성 타이밍이 관건입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 수비 저글링을 피해 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -1, awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 저글링 컨트롤! 12풀의 드론을 몇 기 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠졌지만 아직 드론 우위가 남아있습니다!',
              owner: LogOwner.away,
              altText: '{away}, 드론 손실이 있지만 12풀의 드론 우위는 건재합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_defense',
          baseProbability: 0.9,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론과 저글링으로 상대 저글링을 잡아냅니다! 물량이 다릅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away}, 드론 합세! 12풀의 물량으로 저글링을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 좀 빠졌습니다! 레어 완성까지 버텨야 합니다!',
              owner: LogOwner.home,
              altText: '{home}, 저글링 손실! 레어 진화에 집중해야 합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 확장 + 레어 분기 (lines 23-30)
    ScriptPhase(
      name: 'expansion_tech',
      startLine: 23,
      branches: [
        // 분기 A: 9풀 레어가 뮤탈 선점으로 결착
        ScriptBranch(
          id: 'lair_mutal_timing',
          baseProbability: 0.8,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 완성! 바로 테크를 올립니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 레어 완성! 바로 테크를 올립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 올립니다! 테크가 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
              altText: '{home}, 스파이어를 올립니다! 레어 빌드의 테크 이점!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크 등장! 12풀은 아직 스파이어가 멀었습니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayResource: -15, favorsStat: 'harass',
              altText: '{home}, 뮤탈로 드론 견제! 12풀은 뮤탈이 한참 멀었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뒤늦게 스파이어를 건설하지만 이미 늦었습니다!',
              owner: LogOwner.away,
              awayResource: -5,
              altText: '{away}, 스파이어를 올리지만 뮤탈이 먼저 왔습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 계속 빠집니다! 뮤탈이 나올 때까지 버틸 수 없습니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 뮤탈 견제를 막을 수 없습니다! 드론이 녹고 있어요!',
            ),
            ScriptEvent(
              text: '뮤탈 타이밍 차이가 결정적! 9풀 레어의 빠른 뮤탈이 승부를 갈랐습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '빠른 뮤탈의 위력! 12풀이 뮤탈 전에 무너집니다!',
            ),
          ],
        ),
        // 분기 B: 12풀이 드론 우위로 수비 후 결착
        ScriptBranch(
          id: 'twelve_pool_economy',
          baseProbability: 0.8,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 앞마당 해처리를 건설합니다! 드론 3기 우위를 유지합니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 12풀 확장! 드론이 많아서 안정적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레어는 완성됐지만 미네랄이 부족합니다! 가스 드론 때문에!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 가스 투자가 크다 보니 미네랄이 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 물량으로 밀어붙입니다! 드론 우위가 차이를 만듭니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -3, favorsStat: 'macro',
              altText: '{away}, 12풀의 드론과 라바 우위! 저글링 물량이 다릅니다!',
            ),
            ScriptEvent(
              text: '테크가 완성되기 전에 저글링 물량으로 결착! 12풀의 드론 우위 승리!',
              owner: LogOwner.away,
              decisive: true,
              altText: '드론 우위를 유지한 12풀! 저글링 물량으로 밀어붙입니다!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 완성! 앞마당 해처리도 건설합니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 레어 챙기고 확장! 테크를 준비합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어도 올립니다!',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 해처리를 건설합니다! 드론 우위를 유지합니다!',
              owner: LogOwner.away,
              awayResource: -20,
              awayExpansion: true,
              altText: '{away}, 12풀도 확장! 드론 우위로 중반전!',
            ),
            ScriptEvent(
              text: '양쪽 확장! 스파이어 싸움이 시작됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '둘 다 앞마당! 테크 타이밍 싸움입니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 스파이어 전환 (lines 29-30)
    ScriptPhase(
      name: 'spire_transition',
      startLine: 29,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스파이어가 올라갑니다! 공중 전환이 시작됩니다!',
          owner: LogOwner.home,
          altText: '{home}, 스파이어 완성! 공중 유닛 생산을 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스파이어를 올립니다! 공중 싸움이 시작됩니다!',
          owner: LogOwner.away,
          altText: '{away}, 스파이어를 올립니다! 공중 전환을 서두릅니다!',
        ),
      ],
    ),
    // Phase 5: 뮤탈전 (lines 31-38)
    ScriptPhase(
      name: 'mutal_war',
      startLine: 31,
      branches: [
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 먼저 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 라바에서 뮤탈리스크가 나옵니다! 레어 빌드의 타이밍 이점!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈로 드론을 견제합니다! 12풀은 아직 스파이어가 멀었습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home}, 뮤탈 견제! 상대 스파이어가 완성되기 전에!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 스커지를 떨쳐냅니다! 견제가 계속됩니다!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -2, favorsStat: 'control',
              altText: '{home}, 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 선점 타이밍이 빛납니다! 빠른 뮤탈의 드론 견제로 결착!',
              owner: LogOwner.home,
              decisive: true,
              altText: '레어 빌드의 뮤탈 타이밍! 12풀이 뮤탈 전에 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 먼저 나왔지만 상대 스커지가 정확히 적중합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home}, 뮤탈이 먼저지만 스커지에 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지로 뮤탈을 잡고 자기 뮤탈도 합류합니다! 드론 우위로 보충이 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 6, awayResource: -20, favorsStat: 'macro',
              altText: '{away}, 스커지 적중! 뮤탈도 나오면서 물량 역전!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론 견제! 드론이 많아서 뮤탈 추가도 빠릅니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away}, 12풀의 자원 우위! 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '드론 우위로 뮤탈 물량을 역전! 12풀의 자원 우위가 빛을 발합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '뮤탈 타이밍을 뒤집었습니다! 12풀의 자원 우위 승리!',
            ),
          ],
        ),
      ],
    ),
  ],
);
