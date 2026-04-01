part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. 뮤커지 vs 커세어 리버 (전략전)
// ----------------------------------------------------------
const _zvpMukerjiVsCorsairReaver = ScenarioScript(
  id: 'zvp_mukerji_vs_corsair_reaver',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_mukerji', 'zvp_trans_mukerji', 'zvp_yabarwi', 'zvp_trans_yabarwi'],
  awayBuildIds: ['pvz_corsair_reaver', 'pvz_2star_corsair',
                 'pvz_trans_corsair', 'pvz_trans_dragoon_push'],
  description: '뮤커지/야바위 vs 커세어 리버 전략전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론 생산합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설! 커세어를 노립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 사이버네틱스 코어와 스타게이트! 커세어 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 레어 올리면서 스파이어를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어에서 스파이어! 견제를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 동시에 로보틱스와 서포트 베이 건설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -25,
          altText: '{away}, 커세어와 로보틱스에 서포트 베이 복합 빌드입니다!',
        ),
      ],
    ),
    // Phase 1: 뮤탈 vs 커세어 공중전 (lines 17-28)
    ScriptPhase(
      name: 'air_battle',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 생산! 스커지도 섞습니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 뮤탈 스커지 조합! 커세어를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어로 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home}, 스커지가 커세어를 노립니다! 공중 전투!',
          owner: LogOwner.home,
          awayArmy: -2, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 스커지 자폭! 커세어를 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away}, 셔틀에 리버를 태워서 저그 멀티로 향합니다!',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          altText: '{away} 선수 셔틀 리버 출격! 드론을 노립니다!',
        ),
      ],
    ),
    // Phase 2: 리버 드랍 결과 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'reaver_drop',
      startLine: 29,
      branches: [
        // 분기 A: 리버 드랍 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'reaver_devastation',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버 투하! 스캐럽이 드론 뭉치를 강타합니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 스캐럽 명중! 스캐럽이 일꾼을 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈이 대응하러 가지만 늦었습니다!',
              owner: LogOwner.home,
              homeResource: -5,
            ),
            ScriptEvent(
              text: '{away}, 셔틀 회수! 안전하게 빠집니다!',
              owner: LogOwner.away,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '리버 드랍이 성공! 저그 일꾼에 큰 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 스커지 셔틀 격추 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'scourge_shuttle_kill',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스커지가 셔틀을 포착합니다! 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 스커지가 돌진합니다! 공중 자폭 공격!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 격추됩니다! 리버가 땅에 고립!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 셔틀 폭사! 리버를 잃습니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 고립된 리버를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '셔틀 격추! 프로토스의 핵심 전력이 사라졌습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 결전 전개 (lines 43-56)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설 후 히드라 럴커로 전환! 전면전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 히드라덴에서 히드라 럴커 조합! 지상 전력을 강화합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 드라군 질럿 하이 템플러! 한방 병력!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 결전 병력이 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 럴커 포진! 프로토스 병력을 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -4, homeArmy: -3, favorsStat: 'defense',
          altText: '{home} 선수 럴커가 드라군을 꿰뚫습니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 스톰이 히드라 편대를 녹여냅니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -2, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 스톰이 히드라 편대를 증발시킵니다!',
        ),
      ],
    ),
    // Phase 4: 결전 결과 - 분기 (lines 57-60)
    ScriptPhase(
      name: 'decisive_result',
      startLine: 57,
      branches: [
        ScriptBranch(
          id: 'zerg_lurker_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '럴커가 전장을 지배합니다! 저그 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '스톰이 저그 병력을 쓸어버립니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

