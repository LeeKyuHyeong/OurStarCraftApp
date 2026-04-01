part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. Z 스탠다드 vs 커세어 리버 (오프닝 통합 + Z 트랜지션 분기)
//    기존: 3hatch_vs_corsair_reaver, mukerji_vs_corsair_reaver 통합
// ----------------------------------------------------------
const _zvpStandardVsCorsairReaver = ScenarioScript(
  id: 'zvp_standard_vs_corsair_reaver',
  matchup: 'ZvP',
  homeBuildIds: [
    // 저그 기본 오프닝
    'zvp_12hatch', 'zvp_12pool', 'zvp_3hatch_nopool',
    // 저그 특화 빌드
    'zvp_mukerji', 'zvp_yabarwi', 'zvp_scourge_defiler',
    'zvp_3hatch_hydra',
    // 저그 트랜지션
    'zvp_trans_mukerji', 'zvp_trans_yabarwi',
    'zvp_trans_hive_defiler', 'zvp_trans_5hatch_hydra',
    'zvp_trans_hydra_lurker',
  ],
  awayBuildIds: [
    'pvz_corsair_reaver', 'pvz_2star_corsair',
    'pvz_trans_corsair', 'pvz_trans_dragoon_push',
    'pvz_trans_archon',
  ],
  description: 'Z 스탠다드 vs 커세어 리버 테크전 (Z 트랜지션 분기)',
  phases: [
    // ======================================================
    // Phase 0: 공통 오프닝 (lines 1-16)
    // ======================================================
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
          altText: '{home}, 앞마당 해처리! 자원을 챙깁니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 사이버네틱스 코어와 스타게이트! 커세어를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 동시에 로보틱스와 서포트 베이 건설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -25,
          altText: '{away}, 커세어와 로보틱스에 서포트 베이! 커세어 리버 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 테크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 어떤 테크를 선택할까요?',
        ),
      ],
    ),
    // ======================================================
    // Phase 1: 커세어 견제 + 리버 준비 (lines 17-28)
    // ======================================================
    ScriptPhase(
      name: 'corsair_harass',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어로 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          awayArmy: 1, homeArmy: -1, favorsStat: 'harass',
          altText: '{away}, 커세어 기동! 오버로드를 격추합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 셔틀에 리버를 태워서 저그 멀티로 향합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
          altText: '{away}, 셔틀 리버 출격! 드론을 노립니다!',
        ),
        ScriptEvent(
          text: '커세어로 시야를 확보하면서 리버 드랍! 치명적인 조합!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // ======================================================
    // Phase 2: Z 트랜지션 분기 (lines 29-46)
    // ======================================================
    ScriptPhase(
      name: 'zerg_transition',
      startLine: 29,
      branches: [
        // --- 분기 A: 뮤커지 (뮤탈 + 스커지 기반) ---
        ScriptBranch(
          id: 'mukerji_play',
          conditionHomeBuildIds: ['zvp_mukerji', 'zvp_trans_mukerji'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어에서 스파이어를 올립니다! 뮤탈 스커지를 택했습니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스파이어! 뮤탈 스커지 조합입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크와 스커지를 생산합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 뮤탈 스커지! 커세어를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지가 셔틀을 포착합니다! 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 스커지 자폭! 셔틀을 잡으려 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 견제합니다! 기동력 승부!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤짤! 프로브가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '뮤커지 플레이! 스커지로 셔틀을 잡고 뮤탈로 견제!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 B: 야바위 (뮤탈 + 럴커 기반 속임수) ---
        ScriptBranch(
          id: 'yabarwi_play',
          conditionHomeBuildIds: ['zvp_yabarwi', 'zvp_trans_yabarwi'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어에서 스파이어를 올리면서 히드라덴도 건설합니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스파이어와 히드라덴! 야바위 빌드입니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈리스크로 견제하면서 히드라 럴커를 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 뮤탈 견제와 동시에 지상 전력 강화!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 변태! 뮤탈이 보이는 곳에서 럴커가 포진합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'defense',
              altText: '{home}, 럴커 등장! 공중과 지상 양면 작전!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 대응에 집중했는데 럴커까지!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 뮤탈만 보고 있었는데 럴커가 나왔습니다!',
            ),
            ScriptEvent(
              text: '야바위! 뮤탈과 럴커의 양면 작전!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 C: 히드라 압박 ---
        ScriptBranch(
          id: 'hydra_pressure',
          conditionHomeBuildIds: [
            'zvp_3hatch_hydra', 'zvp_trans_5hatch_hydra',
            'zvp_trans_hydra_lurker',
          ],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라덴 건설! 히드라리스크 생산!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 히드라가 나옵니다! 대공도 가능!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 셔틀을 사격합니다! 리버가 떨어지기 전에!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 히드라 대공 사격! 셔틀이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 피해를 입고 후퇴합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 히드라 물량이 쌓입니다! 프로토스 앞마당을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '히드라가 리버 드랍을 막아냈습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 D: 스커지 디파일러 운영 ---
        ScriptBranch(
          id: 'scourge_defiler',
          conditionHomeBuildIds: ['zvp_scourge_defiler', 'zvp_trans_hive_defiler'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어에서 스커지를 대량 생산합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
              altText: '{home}, 스커지! 커세어와 셔틀을 잡으려 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지가 셔틀을 포착합니다! 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 스커지 돌진! 셔틀 격추!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 격추됩니다! 리버가 땅에 고립!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 셔틀 폭사! 리버를 잃습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 퀸즈네스트를 거쳐 하이브를 향합니다! 디파일러 마운드 준비!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '스커지가 공중 유닛을 견제하면서 하이브를 향하는 장기전!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 E: 폴백 (리버 드랍 결과) ---
        ScriptBranch(
          id: 'reaver_drop_result',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버 투하! 스캐럽이 드론 뭉치를 강타합니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 스캐럽 명중! 일꾼을 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라덴을 올려서 대공 유닛을 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
              altText: '{home}, 히드라덴 건설! 셔틀을 잡아야 합니다!',
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
      ],
    ),
    // ======================================================
    // Phase 3: 결전 전개 (lines 47-60)
    // ======================================================
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 47,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 전면전 병력을 모았습니다! 저그 병력 총출동!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 저그 병력이 쏟아집니다!',
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
          text: '{away}, 스톰! 저그 병력이 녹아내립니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -2, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 저그 병력을 증발시킵니다!',
        ),
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 확장기지를 노립니다! 프로브가 위험!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'harass',
        ),
      ],
    ),
    // ======================================================
    // Phase 4: 결전 결과 - 분기 (lines 61-64)
    // ======================================================
    ScriptPhase(
      name: 'decisive_result',
      startLine: 61,
      branches: [
        // 분기 A: 저그 운영 승리
        ScriptBranch(
          id: 'zerg_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 견제가 프로토스 확장을 무너뜨립니다! 자원 고갈!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '저그가 확장 차이로 승리합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 프로토스 화력 승리
        ScriptBranch(
          id: 'protoss_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버 스캐럽과 스톰의 복합 화력! 저그 병력이 증발합니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '커세어 리버의 기술력이 저그를 꺾습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
