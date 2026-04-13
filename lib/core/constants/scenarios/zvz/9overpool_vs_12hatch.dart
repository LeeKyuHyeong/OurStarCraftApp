part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9오버풀 vs 12앞마당 (밸런스 vs 확장)
// 타이밍: 9오버풀 풀 완성 2:15, 저글링 ~2:33, 도착 ~3:10
//         12앞 풀 완성 2:52, 저글링 ~3:10
// → 9오버풀 저글링 도착(3:10) 시 12앞 저글링이 막 나오는 시점!
// → 12앞이 앞마당 해처리(1:41)로 확장 먼저
// → 9오버풀 드론 10기, 12앞 드론 12기+
// → 12앞이 버티면 해처리 라바 이점 → 뮤탈전
// ----------------------------------------------------------
const _zvz9overpoolVs12hatch = ScenarioScript(
  id: 'zvz_9overpool_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_12hatch'],
  description: '9오버풀 vs 12앞마당 -- 저글링전 -> 확장 -> 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 오버로드를 먼저 올립니다.',
          owner: LogOwner.home,
          homeResource: -5,
          altText: '{home}, 9오버풀! 오버로드를 먼저 생산합니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 앞마당 해처리를 먼저 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 12앞마당! 해처리를 먼저 가져갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설합니다. 익스트랙터도 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스포닝풀과 가스를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀을 뒤늦게 건설합니다. 앞마당에 투자해서 풀이 늦었습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 해처리 후 스포닝풀! 저글링이 한참 뒤에 나옵니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성! 저글링 4기 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -8,
          altText: '{home}, 저글링이 나옵니다! 12앞마당보다 먼저!',
        ),
        ScriptEvent(
          text: '9오버풀 대 12앞마당! 저글링 타이밍이 관건입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '12앞마당의 풀이 아직 건설 중입니다. 저글링 도착 타이밍이 중요합니다.',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 상대 앞마당에 도착합니다! 12앞마당의 풀이 막 완성되는 시점입니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 저글링 도착! 상대 저글링이 막 나오려는 타이밍!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 완성됩니다! 저글링 생산을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          altText: '{away}, 풀 완성! 저글링이 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '12앞마당의 저글링이 막 나오기 시작합니다! 드론으로 조금만 버티면 됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '9오버풀 저글링과 12앞 저글링이 거의 동시에 만납니다!',
        ),
      ],
    ),
    // Phase 2: 저글링 교전 (lines 17-22)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 17,
      branches: [
        // 분기: 비등한 교전
        ScriptBranch(
          id: 'even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 앞마당 드론을 노리지만 {away} 선수 저글링이 합류합니다!',
              owner: LogOwner.system,
              homeArmy: -1, awayArmy: -1, awayResource: -5,
              altText: '저글링 대 저글링! 12앞마당의 저글링이 막 합류했습니다!',
            ),
            ScriptEvent(
              text: '비등한 교전! 양쪽 모두 저글링을 잃었습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '서로 저글링을 교환했습니다. 확실한 우위가 없습니다.',
            ),
          ],
        ),
        // 분기: 9오버풀이 드론을 일부 잡음
        ScriptBranch(
          id: 'home_harass',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 상대 저글링이 나오기 전에 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              homeArmy: -1, awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 저글링 컨트롤! 드론 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 합류하면서 막아냅니다. 하지만 드론 피해가 있습니다.',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 저글링 합류! 뒤늦게 막지만 드론이 빠졌습니다.',
            ),
          ],
        ),
        // 분기: 12앞이 드론+저글링으로 잘 막음
        ScriptBranch(
          id: 'away_harass',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론과 저글링을 뭉쳐서 수비합니다! 9오버풀 저글링이 밀립니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away}, 드론과 저글링 합세! 상대 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 밀렸습니다. 드론이 많은 상대를 뚫지 못 합니다.',
              owner: LogOwner.home,
              altText: '{home}, 12앞마당의 드론 물량이 수비에서 빛났습니다.',
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
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 저글링 추가 압박 → 결착
        ScriptBranch(
          id: 'pressure_kills',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 발업이 완료됩니다! 추가 저글링을 보냅니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'attack',
              altText: '{home}, 발업 저글링 추가 투입! 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 노발업 저글링으로 막으려 하지만 속도 차이가 큽니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
              altText: '{away}, 발업 저글링 속도를 따라잡지 못 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링이 드론을 추가로 잡습니다! 해처리가 위험합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
              altText: '{home}, 드론 견제 성공! 앞마당 해처리까지 위험합니다!',
            ),
            ScriptEvent(
              text: '발업 저글링 압박에 앞마당이 무너집니다! 9오버풀의 타이밍!',
              owner: LogOwner.home,
              decisive: true,
              altText: '확장 타이밍을 노린 압박이 성공합니다! 앞마당이 파괴!',
            ),
          ],
        ),
        // 분기 B: 12앞이 수비 후 라바 이점으로 결착
        ScriptBranch(
          id: 'defends_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 늘어나면서 수비에 성공합니다! 해처리 2개의 라바!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 수비 성공! 해처리 2개라 저글링 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막혔습니다. 확장을 올려야 하는데 타이밍이 늦었습니다.',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 압박 실패! 확장도 늦어서 불리합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바로 저글링 물량이 밀려옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'macro',
              altText: '{away}, 라바 이점이 폭발합니다! 물량 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '12앞마당 수비 성공! 해처리 라바 이점으로 물량을 앞섭니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '드론과 저글링으로 버텨낸 12앞! 해처리 2개가 빛을 발합니다!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 합류하면서 수비에 성공합니다. 앞마당 해처리는 살아있습니다.',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2,
              altText: '{away}, 저글링 합류로 수비 성공! 확장 이점을 유지합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수도 앞마당 해처리를 건설합니다. 압박을 접고 확장으로 전환합니다.',
              owner: LogOwner.home,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 압박이 안 됩니다! 확장으로 전환!',
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
        // 분기: 9오버풀(홈) 뮤탈 승리
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 진화를 시작합니다.',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화! 테크를 서두릅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 서둘러 올립니다.',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화! 해처리가 먼저라 라바 이점이 있습니다.',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 12앞의 라바 이점으로 드론과 유닛 동시 생산!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 상대 드론을 견제합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 스커지를 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'control',
              altText: '{home}, 뮤탈 컨트롤이 좋습니다! 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이로 결착! 드론 견제에서 앞선 9오버풀의 승리!',
              owner: LogOwner.home,
              decisive: true,
              altText: '뮤탈 컨트롤로 라바 이점을 극복합니다! 스커지를 피한 견제의 승리!',
            ),
          ],
        ),
        // 분기: 12앞(어웨이) 라바 이점으로 뮤탈 물량 승리
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화! 해처리 2개의 라바로 드론과 유닛을 동시에 뽑습니다.',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 레어 진화! 라바가 많아 테크도 빠르게!',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화를 시작합니다.',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 레어 진화! 테크 타이밍에서 밀리면 안 됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 서둘러 올립니다.',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 라바가 많아 추가 생산도 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20,
              altText: '{away}, 뮤탈 등장! 해처리 2개라 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.home,
              homeResource: -10,
              skipChance: 0.7,
              altText: '{home}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론 견제! 스커지도 정확히 적중합니다!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'harass',
              altText: '{away}, 뮤탈 물량에서 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '해처리 라바 이점! 뮤탈 물량에서 앞서면서 결착!',
              owner: LogOwner.away,
              decisive: true,
              altText: '12앞마당의 라바 이점이 뮤탈전에서 빛을 발합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
