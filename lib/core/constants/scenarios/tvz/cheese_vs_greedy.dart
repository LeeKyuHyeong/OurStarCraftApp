part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. 벙커 치즈 vs 노풀 3해처리 (극초반 공격 vs 극욕심)
// ----------------------------------------------------------
const _tvzCheeseVsGreedy = ScenarioScript(
  id: 'tvz_cheese_vs_greedy',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_3hatch_nopool'],
  description: '센터 8배럭 벙커 vs 노풀 3해처리',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 해처리를 올립니다! 앞마당 확장!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리까지! 노풀 3해처리입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 풀도 안 짓고 해처리 3개! 대담한 확장이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론만 뽑고 있습니다! 스포닝풀이 없어요!',
          owner: LogOwner.away,
          awayResource: 10,
          altText: '{away}, 드론 풀가동! 수비 유닛이 전혀 없습니다!',
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 15-22)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터 배럭에서 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          altText: '{home}, 센터 배럭 마린 2기! 본진에서도 마린이 나오고 있구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 끌고 상대 진영으로 이동합니다!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'attack',
          altText: '{home}, SCV 4기가 마린과 함께 출발합니다! 공격적인데요!',
        ),
        ScriptEvent(
          text: '노풀이라 저글링이 없습니다! 벙커가 올라가면 막을 수가 없어요!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 벙커 건설 시작합니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 벙커 자리를 잡습니다! 노풀 저그에게 치명적!',
        ),
      ],
    ),
    // Phase 2: 노풀 대응 - 분기 (lines 23-34)
    ScriptPhase(
      name: 'nopool_response',
      startLine: 23,
      branches: [
        // 분기 A: 드론으로 벙커 건설 방해 성공
        ScriptBranch(
          id: 'drone_blocks_bunker',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 드론 6기를 총동원합니다! SCV를 둘러싸서 벙커를 못 짓게 합니다!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 드론이 SCV를 에워쌉니다! 벙커 건설 방해!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV가 밀려납니다! 벙커가 올라가지 않아요!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home}, 드론 물량에 SCV가 못 버팁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 있지만 벙커를 막았습니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 급히 스포닝풀 건설! 저글링을 뽑아야 합니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away} 선수 스포닝풀 건설! 마린에 대비하려면 저글링이 필요합니다!',
            ),
            ScriptEvent(
              text: '드론 수비가 빛났습니다! 벙커가 올라가지 못했어요!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 벙커 건설 성공 → 앞마당 파괴
        ScriptBranch(
          id: 'bunker_complete_destroy',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 건설 성공! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'control',
              altText: '{home}, 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 없습니다! 노풀이라 드론밖에 없어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 수비 유닛이 전혀 없습니다! 드론으로 막아보는데!',
            ),
            ScriptEvent(
              text: '{home}, 벙커에서 마린이 드론을 사격합니다! 앞마당이 초토화!',
              owner: LogOwner.home,
              awayResource: -25, homeArmy: 1, favorsStat: 'attack',
              altText: '{home} 선수 벙커 화력! 드론이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 해처리가 무너집니다! 자원 투자가 날아갔어요!',
              owner: LogOwner.away,
              awayResource: -20, awayArmy: -2,
            ),
            ScriptEvent(
              text: '노풀 3해처리에 벙커 러시라니! 최악의 매치업이었습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 벙커 러시 이후 (lines 35-48)
    ScriptPhase(
      name: 'post_bunker',
      startLine: 35,
      branches: [
        // 분기 A: 벙커 성공 → 마무리
        ScriptBranch(
          id: 'bunker_finishes_game',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 추가 마린 도착! 벙커 2개째까지!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'attack',
              altText: '{home}, 벙커를 추가합니다! 저그가 답이 없어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 스포닝풀을 올리지만 이미 늦었습니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 마린이 본진까지 진입합니다! 저그 일꾼이 남아나질 않아요!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 본진까지 밀고 들어갑니다!',
            ),
            ScriptEvent(
              text: '벙커 러시가 노풀을 박살냅니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 수비 성공 → 저그 자원 이득으로 역전
        ScriptBranch(
          id: 'zerg_recovers_and_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 러시를 막아냈습니다! 저글링이 뒤늦게 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 저글링 생산 시작! 벙커 러시를 막았습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 SCV가 철수합니다! 벙커가 안 올라갔으니까요.',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 3해처리의 위력이 나옵니다! 드론이 폭발적으로 늘어납니다!',
              owner: LogOwner.away,
              awayResource: 30, awayArmy: 3, favorsStat: 'macro',
              altText: '{away} 선수 3해처리 풀가동! 자원이 넘쳐납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커 러시에 자원을 썼는데 실패했습니다! 자원 차이가 크네요!',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 저글링 물량으로 역습합니다! 테란이 자원이 부족해요!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 저글링 대량 생산! 테란에게 역습을 날립니다!',
            ),
            ScriptEvent(
              text: '벙커 러시 실패! 3해처리의 자원 이득이 결정적입니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 벙커 일부 성공 → 접전
        ScriptBranch(
          id: 'partial_damage_battle',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론 피해는 입었지만 벙커를 부쉈습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, awayResource: -15,
              altText: '{away}, 드론 손실이 있지만 벙커를 철거했습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린을 추가하면서 다시 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 나오기 시작합니다! 성큰도 건설!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 저글링과 성큰으로 수비 라인 구축!',
            ),
            ScriptEvent(
              text: '{away}, 마린을 밀어내고 레어 테크를 올립니다!',
              owner: LogOwner.away,
              awayResource: -20, homeArmy: -2,
            ),
            ScriptEvent(
              text: '양측 피해를 입었습니다! 접전 끝 승부가 갈립니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
