part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9오버풀 vs 12풀 (밸런스 vs 밸런스)
// 타이밍: 9오버풀 풀 완성 2:15, 저글링 ~2:33
//         12풀 풀 완성 2:22, 저글링 ~2:40
// → 9오버풀 저글링이 ~7초 먼저, 드론은 12풀이 +2
// → 비슷한 타이밍이라 길어질 가능성 높음
// → 양쪽 다 앞마당 확장 후 뮤탈전으로 귀결
// ----------------------------------------------------------
const _zvz9overpoolVs12pool = ScenarioScript(
  id: 'zvz_9overpool_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_12pool'],
  description: '9오버풀 vs 12풀 -- 저글링전 -> 확장 -> 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 오버로드를 먼저 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -200,
          altText: '{home} 선수, 9드론에 오버로드를 먼저 생산합니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 12기까지 모으고 있습니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -300,
          altText: '{away} 선수, 드론 생산을 이어갑니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 오버로드 이후 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300,
          altText: '{home} 선수, 스포닝풀 건설 시작! 저글링이 곧 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀을 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -200,
          altText: '{away} 선수, 12드론까지 모은 후 스포닝풀! 드론이 많은 안정적인 운영입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 익스트랙터 건설, 가스를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: -50,
          awayResource: -50,
          altText: '{home} 선수, 가스를 올립니다. {away} 선수도 익스트랙터를 건설합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성! 저글링 4기 생산합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -100,
          altText: '{home} 선수, 저글링이 나옵니다! 상대보다 한 발 빠릅니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 완성됩니다! 저글링 4기 생산합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -100,
          altText: '{away} 선수, 저글링 생산 시작! 드론이 2기 더 많습니다.',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 10-14)
    ScriptPhase(
      name: 'ling_arrives',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 먼저 상대 진영으로 이동합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,
          altText: '{home} 선수, 저글링이 약간 먼저 나왔습니다! 상대 진영으로 이동합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링도 이동합니다! 양쪽 저글링이 맞닥뜨립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 1,
          altText: '{away} 선수, 저글링이 나옵니다! 맵 중앙에서 만나게 됩니다!',
        ),
        ScriptEvent(
          text: '양쪽 저글링 타이밍이 거의 비슷합니다! 드론 차이가 관건이에요!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '저글링 시간 차이가 거의 없습니다! 컨트롤 싸움!',
        ),
      ],
    ),
    // Phase 2: 저글링 교전 (lines 15-19)
    ScriptPhase(
      name: 'ling_skirmish',
      branches: [
        // 분기: 비등한 교전
        ScriptBranch(
          id: 'even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링과 {away} 선수 저글링이 교전합니다! 양쪽 저글링이 부딪힙니다!',
              owner: LogOwner.system,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: -2,
              altText: '저글링 대 저글링! 양쪽 모두 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '비등한 교환입니다! 서로 저글링을 잃었습니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '누구도 확실한 우위를 잡지 못 했습니다.',
            ),
          ],
        ),
        // 분기: 9오버풀 저글링이 드론을 조금 견제
        ScriptBranch(
          id: 'home_harass',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 일하는 드론을 공격합니다! 드론 한두 기를 잡습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: -1, awayResource: -100,              altText: '{home} 선수, 저글링 컨트롤! 드론을 물어뜯고 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링으로 방어합니다. 피해가 있지만 막아냅니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -1,
              altText: '{away} 선수, 드론 피해가 있지만 저글링이 도착해서 막아냅니다.',
            ),
          ],
        ),
        // 분기: 12풀이 드론 수 이점으로 잘 막음
        ScriptBranch(
          id: 'away_harass',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론이 많아서 저글링과 드론으로 교전합니다! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: -1,              altText: '{away} 선수, 드론 수가 많습니다! 저글링과 함께 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 밀렸습니다. 뒤로 물러납니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home} 선수, 상대의 드론 이점이 초반 교전에서 빛났습니다.',
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 확장 (lines 20-24)
    ScriptPhase(
      name: 'expansion',
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 저글링 추가 압박 → 결착 (확률 낮음)
        ScriptBranch(
          id: 'pressure_kills',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 발업이 완료됩니다! 추가 저글링을 보냅니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4, homeResource: -400,              altText: '{home} 선수, 발업 저글링 추가 투입! 상대 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 해처리를 건설 중인데 저글링 압박이 들어옵니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -2, awayResource: -300,
              altText: '{away} 선수, 확장 타이밍에 압박이! 해처리가 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링이 드론을 추가로 잡습니다! 확장이 지연됩니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,              altText: '{home} 선수, 드론 견제 성공! 상대 확장을 지연시킵니다!',
            ),
            ScriptEvent(
              text: '저글링 압박에 앞마당이 무너집니다! 타이밍 공격이 성공!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '확장 타이밍을 정확히 짚었습니다! 저글링이 앞마당을 파괴합니다!',
            ),
          ],
        ),
        // 분기 B: 12풀이 수비 후 드론 이점으로 결착
        ScriptBranch(
          id: 'defends_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링으로 압박을 막으면서 앞마당 해처리를 건설합니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayArmy: 3, homeArmy: -2, awayResource: -450,              awayExpansion: true,
              altText: '{away} 선수, 저글링으로 수비하면서 확장! 드론 이점이 살아있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막혔습니다. 자기도 확장을 올려야 합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -300,
              altText: '{home} 선수, 압박 실패. 상대 드론 수가 더 많습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바로 저글링 물량이 늘어갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -200,              altText: '{away} 선수, 라바 이점! 저글링이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '드론 이점이 결정적입니다! 라바 차이로 물량을 앞섭니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '수비에 성공! 드론 2기의 차이가 중반에 빛을 발합니다!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리를 건설합니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -300,
              homeExpansion: true,
              altText: '{home} 선수, 확장으로 전환합니다. 저글링 싸움은 여기까지.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 해처리를 건설합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              awayExpansion: true,
              altText: '{away} 선수, 앞마당 해처리! 양쪽 모두 확장을 올립니다.',
            ),
            ScriptEvent(
              text: '양쪽 모두 확장! 테크 싸움이 시작됩니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '둘 다 앞마당! 이제 테크 타이밍이 관건입니다.',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 스파이어 전환 (lines 25-27)
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
    // Phase 5: 뮤탈전 (lines 28-35)
    ScriptPhase(
      name: 'mutal_war',
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
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -250,
              altText: '{home} 선수, 레어 진화! 테크를 서두릅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 서둘러 올립니다.',
              owner: LogOwner.home,
              homeResource: -300,
              awayResource: 0,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화를 시작합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -250,
              altText: '{away} 선수, 레어 진화! 비슷한 타이밍입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 스파이어를 준비합니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: -300,
              awayArmy: 0, homeArmy: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지를 피하면서 드론을 노립니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 5, homeResource: -500,              altText: '{home} 선수, 뮤탈 등장! 뮤탈 컨트롤이 좋습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -125,
              skipChance: 0.7,
              altText: '{away} 선수, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 스커지를 피합니다! 드론 견제가 누적됩니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -150, awayArmy: -2,              altText: '{home} 선수, 뮤탈 컨트롤이 앞섭니다! 드론이 빠지고 있습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이로 결착! 드론 견제에서 앞선 쪽의 승리!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '뮤탈 컨트롤이 승부를 갈랐습니다! 스커지를 피하면서 견제에 성공!',
            ),
          ],
        ),
        // 분기: 12풀(어웨이) 뮤탈 물량 승리
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화! 드론이 많아서 가스도 빠릅니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -250,
              altText: '{away} 선수, 레어 진화! 드론 이점으로 가스 수급이 좋습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화를 시작합니다. 테크 타이밍에서 밀릴 수 없습니다.',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -250,
              altText: '{home} 선수, 레어 진화! 테크를 서두릅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 드론이 많아서 추가 생산도 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6, awayResource: -900,
              altText: '{away} 선수, 뮤탈 등장! 드론 이점으로 뮤탈 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -125,
              skipChance: 0.7,
              altText: '{home} 선수, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 물량으로 드론을 견제합니다! 스커지도 적중!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -150, homeArmy: -2,              altText: '{away} 선수, 뮤탈 물량이 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '드론 이점이 뮤탈전에서 빛을 발합니다! 물량 차이로 결착!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '뮤탈 물량으로 드론 견제에 성공! 자원 우위가 결정적!',
            ),
          ],
        ),
      ],
    ),
  ],
);
