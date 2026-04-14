part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12앞마당 vs 12풀 (확장 vs 밸런스)
// 타이밍: 12앞 해처리 1:41, 풀 완성 2:52, 저글링 ~3:10
//         12풀 풀 완성 2:22, 저글링 ~2:40, 발업 완료 3:29
// → 12풀 저글링(2:40)이 12앞 저글링(3:10)보다 30초 먼저!
// → 12풀이 초반 압박 가능, 12앞이 버티면 해처리 이점
// → 양쪽 다 밸런스형이라 뮤탈전으로 귀결 가능성 높음
// ----------------------------------------------------------
const _zvz12hatchVs12pool = ScenarioScript(
  id: 'zvz_12hatch_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch'],
  awayBuildIds: ['zvz_12pool'],
  description: '12앞마당 vs 12풀 -- 저글링전 -> 확장 -> 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 12드론에 앞마당 해처리를 먼저 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리를 먼저 가네요! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀을 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12드론에 스포닝풀! 저글링으로 앞마당을 압박할 수 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 뒤늦게 건설합니다. 앞마당에 투자해서 풀이 늦었습니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 해처리 후 스포닝풀! 저글링이 한참 뒤에 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 익스트랙터 건설. 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -5,
          homeResource: -5,
          altText: '{away}, 가스를 올립니다. {home} 선수도 익스트랙터를 건설합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 완성! 저글링 4기 생산하면서 발업 연구를 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -8,
          altText: '{away}, 저글링에 발업! 앞마당부터 올린 상대보다 30초 먼저 저글링이 나옵니다.',
        ),
        ScriptEvent(
          text: '앞마당부터 올린 쪽 대 스포닝풀부터 올린 쪽! 저글링 타이밍이 30초 차이 납니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '스포닝풀 먼저 올린 쪽 저글링이 먼저 나옵니다! 앞마당 쪽 풀은 아직 건설 중!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 저글링이 상대 앞마당에 도착합니다! 상대 풀은 아직 건설 중입니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away}, 저글링 도착! 상대 저글링이 없습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 막아야 합니다! 저글링이 아직 안 나왔습니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          altText: '{home}, 풀이 건설 중! 드론으로 버텨야 합니다!',
        ),
        ScriptEvent(
          text: '저글링이 먼저 도착했습니다! 앞마당부터 올린 쪽은 드론으로 버텨야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '앞마당 해처리가 위험합니다! 드론 컨트롤이 관건!',
        ),
      ],
    ),
    // Phase 2: 저글링 교전 (lines 17-22)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 17,
      branches: [
        // 분기: 비등한 교전 - 드론 수비 후 저글링 합류
        ScriptBranch(
          id: 'even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드론을 뭉쳐서 저글링과 교전합니다! 드론이 몇 기 빠지지만 버팁니다!',
              owner: LogOwner.home,
              homeArmy: -1, awayArmy: -1, homeResource: -5,
              altText: '드론 대 저글링! 앞마당부터 올린 쪽은 드론이 많아서 버팁니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포닝풀이 완성됩니다! 저글링이 나오기 시작합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              skipChance: 0.3,
              altText: '{home}, 풀 완성! 이제 저글링으로 수비할 수 있습니다!',
            ),
          ],
        ),
        // 분기: 12풀이 드론을 많이 잡음
        ScriptBranch(
          id: 'home_harass',
          baseProbability: 0.8,
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 드론을 물어뜯습니다! 풀이 없어서 피해가 큽니다!',
              owner: LogOwner.away,
              homeResource: -15, awayArmy: -1, favorsStat: 'attack',
              altText: '{away}, 저글링 돌파! 드론이 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론 피해가 있지만 풀이 곧 완성됩니다. 조금만 더 버텨야 합니다.',
              owner: LogOwner.home,
              homeResource: -5,
              altText: '{home}, 드론이 빠졌지만 풀 완성이 임박합니다.',
            ),
          ],
        ),
        // 분기: 12앞이 드론 물량으로 잘 막음
        ScriptBranch(
          id: 'away_harass',
          baseProbability: 0.8,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 드론 컨트롤이 좋습니다! 저글링을 에워싸서 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeResource: -5, favorsStat: 'defense',
              altText: '{home}, 드론 물량으로 저글링을 잡습니다! 앞마당부터 올려서 드론이 많습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 밀렸습니다. 드론에 둘러싸여 손실이 큽니다.',
              owner: LogOwner.away,
              altText: '{away}, 저글링이 드론에 당하고 있습니다. 추가 저글링을 보내야 합니다.',
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 확장 (lines 23-30)
    ScriptPhase(
      name: 'expansion',
      startLine: 23,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      branches: [
        // 분기 A: 12풀 저글링 추가 압박 → 결착
        ScriptBranch(
          id: 'pressure_kills',
          baseProbability: 0.8,
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 발업이 완료됩니다! 추가 저글링을 보냅니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'attack',
              altText: '{away}, 발업 저글링! 상대 앞마당 해처리를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 노발업 저글링으로 막으려 하지만 속도 차이가 큽니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
              altText: '{home}, 발업 저글링을 따라잡지 못 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 발업 저글링이 앞마당 드론을 추가로 잡습니다! 해처리가 위험합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'attack',
              altText: '{away}, 드론 견제 성공! 앞마당 해처리가 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '발업 저글링 압박에 앞마당이 무너집니다! 저글링 압박이 성공!',
              owner: LogOwner.away,
              decisive: true,
              altText: '앞마당 해처리 투자가 독이 됐습니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        // 분기 B: 12앞이 수비 후 해처리 이점으로 결착
        ScriptBranch(
          id: 'defends_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 합류하면서 수비에 성공합니다! 앞마당을 지켜냅니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3, favorsStat: 'defense',
              altText: '{home}, 저글링 합류! 드론과 저글링으로 압박을 막습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 압박이 막혔습니다. 앞마당 해처리가 살아있습니다.',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 압박 실패! 앞마당 해처리가 살아남으면서 이점을 가져갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 해처리 2개의 라바가 돌기 시작합니다! 저글링 물량이 다릅니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'macro',
              altText: '{home}, 라바 이점이 폭발합니다! 해처리 2개의 힘!',
            ),
            ScriptEvent(
              text: '수비 성공! 해처리 라바 이점으로 물량을 앞섭니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '앞마당을 지켜냈습니다! 해처리 2개의 라바가 결정적!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 합류하면서 수비에 성공합니다. 앞마당 해처리는 살아있습니다.',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2,
              altText: '{home}, 저글링 합류로 수비! 앞마당이 살아있습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 해처리를 건설합니다. 압박을 접고 확장으로 전환합니다.',
              owner: LogOwner.away,
              awayResource: -20,
              awayExpansion: true,
              altText: '{away}, 앞마당 해처리! 양쪽 모두 확장을 올립니다.',
            ),
            ScriptEvent(
              text: '양쪽 모두 앞마당! 테크 싸움이 시작됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '둘 다 확장! 이제 테크 타이밍이 관건입니다.',
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
          text: '양쪽 스파이어가 올라갑니다! 뮤탈전이 임박합니다!',
          owner: LogOwner.system,
          altText: '스파이어 완성! 뮤탈리스크 생산이 시작됩니다!',
        ),
      ],
    ),
    // Phase 5: 뮤탈전 (lines 31-38)
    ScriptPhase(
      name: 'mutal_war',
      startLine: 31,
      branches: [
        // 분기: 12앞(홈) 라바 이점으로 뮤탈 물량 승리
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 진화! 해처리가 먼저라 라바 이점이 있습니다.',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화! 해처리가 먼저 올라간 라바 이점으로 드론과 유닛 동시 생산!',
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화를 시작합니다.',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 테크 타이밍에서 밀리면 안 됩니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 서둘러 올립니다.',
              owner: LogOwner.away,
              awayArmy: 0, homeArmy: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 라바가 많아 추가 생산도 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 해처리 2개라 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 물량으로 드론을 견제합니다! 스커지도 뿌립니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'harass',
              altText: '{home}, 뮤탈 물량이 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '해처리 라바 이점! 뮤탈 물량에서 앞서면서 결착!',
              owner: LogOwner.home,
              decisive: true,
              altText: '앞마당 해처리의 라바 이점이 뮤탈전에서 빛을 발합니다!',
            ),
          ],
        ),
        // 분기: 12풀(어웨이) 뮤탈 컨트롤 승리
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화를 시작합니다.',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 테크를 서두릅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 서둘러 올립니다.',
              owner: LogOwner.away,
              awayArmy: 0, homeArmy: 0,
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화! 해처리 이점으로 라바가 많습니다.',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화! 라바 이점을 살려야 합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
              altText: '{away}, 뮤탈 등장! 상대 드론을 견제합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.home,
              homeResource: -10,
              skipChance: 0.7,
              altText: '{home}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 컨트롤로 스커지를 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'control',
              altText: '{away}, 뮤탈 컨트롤이 좋습니다! 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이로 결착! 라바 이점을 극복하는 뮤탈 운용!',
              owner: LogOwner.away,
              decisive: true,
              altText: '뮤탈 컨트롤이 물량 차이를 극복합니다! 스포닝풀 먼저 올린 쪽의 승리!',
            ),
          ],
        ),
      ],
    ),
  ],
);
