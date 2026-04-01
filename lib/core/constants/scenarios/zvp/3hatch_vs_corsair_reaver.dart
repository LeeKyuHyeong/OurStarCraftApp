part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9. 노풀 3해처리 vs 커세어 리버 (매크로 vs 테크)
// ----------------------------------------------------------
const _zvp3HatchVsCorsairReaver = ScenarioScript(
  id: 'zvp_3hatch_vs_corsair_reaver',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_3hatch_nopool', 'zvp_12hatch', 'zvp_12pool'],
  awayBuildIds: ['pvz_corsair_reaver', 'pvz_2star_corsair',
                 'pvz_trans_corsair', 'pvz_trans_dragoon_push'],
  description: '3해처리 매크로 vs 커세어 리버 테크전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리를 연달아 올립니다! 자원을 최대한 챙깁니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 해처리가 빠르게 올라갑니다! 매크로 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설 후 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 3번째 해처리까지! 드론을 최대한 뽑습니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 3해처리! 자원에서 앞서겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설! 커세어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 사이버네틱스 코어와 스타게이트! 커세어로 견제하겠다는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 뒤늦게 스포닝풀을 올립니다! 이제야 유닛이!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 늦습니다! 3해처리의 약점!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스와 서포트 베이 건설! 리버를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 로보틱스와 서포트 베이! 커세어 리버 조합입니다!',
        ),
      ],
    ),
    // Phase 1: 커세어 견제 + 리버 드랍 (lines 17-28)
    ScriptPhase(
      name: 'corsair_reaver',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -1, favorsStat: 'harass',
          altText: '{away}, 커세어 기동! 커세어가 오버로드를 격추합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 대공 유닛을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 히드라덴이 올라갑니다! 커세어 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라를 생산합니다! 커세어를 쫓아냅니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 히드라 생산! 커세어를 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 셔틀에 리버를 태워서 출격합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
          altText: '{away}, 셔틀 리버! 드론을 노립니다!',
        ),
        ScriptEvent(
          text: '커세어로 시야를 확보하면서 리버 드랍! 치명적인 조합!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 리버 드랍 결과 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'reaver_drop_result',
      startLine: 29,
      branches: [
        // 분기 A: 리버 드랍 성공
        ScriptBranch(
          id: 'reaver_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버 투하! 스캐럽이 드론 뭉치에 명중합니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 스캐럽! 스캐럽이 일꾼을 한 방에 날려버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 대응하지만 드론 피해가 큽니다!',
              owner: LogOwner.home,
              homeResource: -10, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 셔틀 회수 후 다른 멀티로 이동! 또 드랍!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'control',
              altText: '{away} 선수 셔틀 기동! 이번엔 다른 기지를 노립니다!',
            ),
            ScriptEvent(
              text: '리버 드랍이 연속 성공! 3해처리의 드론이 줄어들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 히드라 대응 성공
        ScriptBranch(
          id: 'hydra_anti_air',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 히드라가 셔틀을 사격합니다! 리버가 떨어지기 전에!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 히드라가 대공 사격을 합니다! 공중 유닛이 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 피해를 입고 후퇴합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 3해처리의 자원으로 히드라를 대량 생산합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home} 선수 히드라 물량! 일꾼 차이가 나기 시작합니다!',
            ),
            ScriptEvent(
              text: '리버 드랍을 막아냈습니다! 3해처리의 자원 우위가 빛을 발합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 45-56)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 45,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 물량이 압도적입니다! 프로토스 앞마당을 공격!',
          owner: LogOwner.home,
          homeArmy: 4, awayArmy: -3, favorsStat: 'attack',
          altText: '{home}, 히드라 대군! 3해처리의 물량이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 하이 템플러가 합류합니다! 스톰!',
          owner: LogOwner.away,
          awayArmy: 4, homeArmy: -4, favorsStat: 'strategy',
          altText: '{away}, 스톰 투하! 스톰이 히드라 편대를 녹여냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라를 계속 보충합니다! 자원이 넉넉합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away}, 리버를 추가로 배치합니다! 스캐럽 화력!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: 1, awayResource: -20,
          altText: '{away} 선수 리버 추가! 히드라 물량을 잡아냅니다!',
        ),
      ],
    ),
    // Phase 4: 결전 결과 - 분기 (lines 57-58)
    ScriptPhase(
      name: 'decisive_result',
      startLine: 57,
      branches: [
        ScriptBranch(
          id: 'macro_quantity_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '3해처리의 물량이 테크를 압도합니다! 저그 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'tech_quality_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '커세어 리버의 기술력이 물량을 꺾습니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

