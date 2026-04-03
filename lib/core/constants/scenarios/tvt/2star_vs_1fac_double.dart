part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 클로킹 vs 원팩 확장
// ----------------------------------------------------------
const _tvt2starVs1facDouble = ScenarioScript(
  id: 'tvt_wraith_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '투스타 레이스 vs 원팩 확장 공중 견제전',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 빠른 테크!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 앞마당 확장도 같이 가져갑니다!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 앞마당 커맨드를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 원팩 확장! 벌처 생산하면서 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 생산하면서 벙커를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산! 2번째 스타포트도 올립니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -25,
          altText: '{home}, 레이스가 나옵니다! 스타포트가 하나 더!',
        ),
        ScriptEvent(
          text: '투스타포트! 레이스를 대량으로 뽑겠다는 의도!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 초반 레이스 견제 (lines 12-18)
    ScriptPhase(
      name: 'early_wraith_harass',
      startLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 레이스가 상대 본진으로! SCV를 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 레이스 출격! 상대 SCV를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home}, 아카데미 짓는 SCV를 노립니다! 스캔을 늦추려는 의도!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayResource: -5,
          altText: '{home} 선수 아카데미 건설 SCV를 쫓아냅니다!',
        ),
        ScriptEvent(
          text: '{home}, 아머리 짓는 SCV도 공격! 골리앗 생산을 늦추려는 의도!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayResource: -5,
          altText: '{home} 선수 아머리 건설 SCV까지 괴롭힙니다!',
        ),
        ScriptEvent(
          text: '{home}, 엔지니어링 베이 SCV까지! 터렛 건설도 지연시킵니다!',
          owner: LogOwner.home,
          awayResource: -5,
          altText: '{home}, 엔지니어링 베이 짓는 SCV도 쫓습니다! 터렛이 늦어지네요!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '레이스 한두 기로는 건설을 완전히 막을 수는 없지만, SCV 피해가 계속 쌓이고 있습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 건물 옆에 붙여놓고 끈질기게 건설을 시도합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          altText: '{away}, SCV를 계속 붙이면서 건물을 올립니다! 포기하지 않습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 견제를 이어가면서 앞마당 커맨드센터를 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 견제와 동시에 앞마당 확장! 멀티를 챙깁니다!',
        ),
        ScriptEvent(
          text: '피해는 누적되고 있지만 {away} 선수 포기하지 않습니다! 건물이 하나둘 올라오고 있어요!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 클로킹 완성 + 침투 - 분기 (lines 18+)
    ScriptPhase(
      name: 'cloak_infiltrate',
      startLine: 18,
      branches: [
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스 3기가 침투합니다! 아카데미가 늦어서 스캔이 안 됩니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! 컴샛스테이션이 없어 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아카데미가 이제야 완성! 컴샛스테이션을 급히 올립니다!',
              owner: LogOwner.away,
              awayResource: -10, awayArmy: -1,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home}, 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -2, favorsStat: 'harass',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 치명적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 올리려 하지만 SCV가 부족합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_no_antiair',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 아카데미는 올렸습니다! 컴샛스테이션 부착! 스캔은 가능합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 아카데미 완성! 스캔은 달리지만 아머리가 문제입니다!',
            ),
            ScriptEvent(
              text: '{home}, 스캔에 걸리지만 아머리 짓는 SCV를 집요하게 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 아머리 건설을 끈질기게 방해합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 다시 올리지만 또 SCV가 잡힙니다!',
              owner: LogOwner.away,
              awayResource: -10, awayArmy: -1,
              altText: '{away}, 아머리 재건설 시도! 하지만 공중 유닛이 놓아주질 않습니다!',
            ),
            ScriptEvent(
              text: '스캔은 달리는데 골리앗이 없습니다! 마린으로는 레이스를 잡기 어렵습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 레이스가 5기 이상! 투스타포트에서 쉬지 않고 뽑아냅니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 레이스 물량이 쌓입니다! SCV가 녹아내리고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 있지만 공중 유닛을 잡을 수가 없습니다!',
              owner: LogOwner.away,
              awayResource: -15, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 편대로 상대 본진을 초토화합니다! 대공유닛 없이는 막을 수가 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home}, 레이스 물량 앞에 속수무책! 아머리가 끝내 올라오지 못했습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 끈질기게 버텨서 아카데미와 아머리를 모두 완성합니다!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 피해를 입었지만 핵심 건물을 모두 올렸습니다!',
            ),
            ScriptEvent(
              text: '{away}, 컴샛스테이션 완성! 스캔으로 클로킹을 잡고 골리앗까지 생산!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2,
              altText: '{away} 선수 스캔과 골리앗! 공중 유닛을 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 하지만 대공 화력이 대기 중!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 공중 견제를 막아냅니다! 하지만 SCV 피해가 좀 있습니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '레이스 견제가 막혔습니다! 하지만 투스타 측은 드랍십이 빠릅니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 26-34)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 올립니다! 탱크 생산 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 머신샵 부착! 탱크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵 부착! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워 건설! 드랍십을 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 컨트롤타워 완성! 드랍십이 가능합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 터렛으로 공중 유닛을 대비합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 기동전을 노리는 운영!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 확장 자원으로 탱크가 모이고 있습니다! 라인 방어!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 원팩 확장 자원 가동! 탱크 라인 구축!',
        ),
        ScriptEvent(
          text: '중반 전환기! 양쪽 다 메카닉 체제에 들어갑니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후속 전개 - 분기 (lines 36+)
    ScriptPhase(
      name: 'post_defense',
      startLine: 36,
      branches: [
        ScriptBranch(
          id: 'good_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크 벌처! 뒤쪽으로 우회합니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home} 선수 드랍 출격! 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 드랍십에서 탱크를 내립니다! 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 일꾼을 솎아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤를 잡혔습니다! 터렛이 없는 곳이에요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 동시 전진! 양쪽에서 압박!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 견제로 상대 일꾼을 학살합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 클로킹 레이스! 스캔 없는 상대 본진을 초토화합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'minimal_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 원팩 확장 자원이 풀가동! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 확장 자원 풀가동! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상병력이 부족합니다! 스타포트 투자가 무겁네요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 물량으로 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 탱크 시즈 포격! 라인을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗과 터렛으로 공중 유닛을 격추! 확장 자원으로 승리합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 대공 수비 성공! 확장 자원 우위로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
