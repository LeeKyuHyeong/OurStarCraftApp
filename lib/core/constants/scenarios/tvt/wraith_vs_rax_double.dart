part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 3. 투스타 레이스 vs 배럭 더블 (공중 견제)
// ----------------------------------------------------------
const _tvtWraithVsRaxDouble = ScenarioScript(
  id: 'tvt_wraith_vs_rax_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_wraith_cloak', 'tvt_1fac_push'],
  awayBuildIds: ['tvt_cc_first', 'tvt_2fac_vulture', 'tvt_1fac_expand'],
  description: '투스타 레이스/드랍 vs 배럭 더블',
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
          text: '{away} 선수 앞마당 커맨드센터 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 벌처를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 팩토리가 올라갑니다!',
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
    // Phase 1: 초반 레이스 견제 - 디텍 SCV 방해 (lines 12-15)
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
          text: '{away} 선수 아머리 건설하려는데 공중 견제에 방해받습니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 디텍 올리는 SCV를 집요하게 쫓습니다!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayArmy: -1,
          altText: '{home} 선수 아머리 SCV를 노립니다! 디텍을 막으려는 의도!',
        ),
        ScriptEvent(
          text: '클로킹이 완성되기 전에 디텍을 올려야 하는데요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 클로킹 완성 + 3기 침투 - 분기 (lines 18+)
    ScriptPhase(
      name: 'cloak_infiltrate',
      startLine: 18,
      branches: [
        // 분기 A: 디텍 준비 안 됨 → SCV 학살
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스 3기가 침투합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 스캔! 하지만 이미 SCV 피해가 큽니다!',
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
        // 분기 B: 본진+앞마당 분산 건설 → 골리앗/스캔으로 대응
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 아머리를 본진과 앞마당에 나눠 짓습니다! 공중 견제를 피합니다!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 분산 건설! 아머리를 나눠서 짓습니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗 생산 시작! 공중 유닛을 격추합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2,
              altText: '{away} 선수 골리앗! 공중 유닛을 잡습니다!',
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
          text: '{away} 선수 탱크가 모이고 있습니다! 라인 방어 태세!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 탱크 라인 구축! 수비가 단단합니다!',
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
        // 분기 A: 드랍 견제 성공
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
              altText: '{home} 선수 드랍 견제! 일꾼이 쓰러집니다!',
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
              text: '{home} 선수 드랍 견제 성공! 주도권을 잡았습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 배럭더블 물량 우위
        ScriptBranch(
          id: 'minimal_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 앞마당이 풀가동! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 앞마당 풀가동! 물량이 쌓입니다!',
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
              text: '{away} 선수 물량으로 압도! 따라잡기 힘듭니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

