part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4. Z 스탠다드 vs 포지더블 (오프닝 통합 + Z 트랜지션 분기)
//    기존: hydra_vs_forge, mutal_vs_forge, hydra_lurker_vs_forge,
//          scourge_defiler, 973_hydra_rush 통합
// ----------------------------------------------------------
const _zvpStandardVsForge = ScenarioScript(
  id: 'zvp_standard_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: [
    // 저그 기본 오프닝
    'zvp_12hatch', 'zvp_12pool', 'zvp_3hatch_nopool',
    // 저그 특화 빌드
    'zvp_3hatch_hydra', 'zvp_2hatch_mutal', 'zvp_scourge_defiler',
    'zvp_973_hydra',
    // 저그 트랜지션
    'zvp_trans_5hatch_hydra', 'zvp_trans_mutal_hydra',
    'zvp_trans_hive_defiler', 'zvp_trans_973_hydra',
    'zvp_trans_hydra_lurker',
  ],
  awayBuildIds: [
    'pvz_forge_cannon',
    'pvz_trans_forge_expand', 'pvz_trans_corsair',
    'pvz_trans_dragoon_push', 'pvz_trans_archon',
  ],
  description: 'Z 스탠다드 vs 포지더블 국룰전 (Z 트랜지션 분기)',
  phases: [
    // ======================================================
    // Phase 0: 공통 오프닝 (lines 1-16)
    // ======================================================
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설! 앞마당 심시티를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지가 올라갑니다! 포지더블이구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스! 게이트웨이와 사이버네틱스 코어로 입구를 막습니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지와 게이트웨이, 사이버네틱스 코어로 입구를 막아주고요.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣으면서 테크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스 채취 시작! 어떤 테크로 갈까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설! 커세어를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트가 올라갑니다! 커세어!',
        ),
      ],
    ),
    // ======================================================
    // Phase 1: 초반 전개 - 공통 (lines 17-28)
    // ======================================================
    ScriptPhase(
      name: 'early_development',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 오버로드를 사냥하러 갑니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 커세어가 뜹니다! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 커세어로 오버로드를 격추합니다!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 커세어 기동! 오버로드 격추!',
        ),
        ScriptEvent(
          text: '{home} 선수 테크 건물을 올리면서 병력을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 테크를 진행합니다! 어떤 조합을 택할까요?',
        ),
        ScriptEvent(
          text: '커세어가 오버로드를 견제하면서 시야를 확보하고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // ======================================================
    // Phase 2: Z 트랜지션 분기 (lines 29-46)
    //   conditionHomeBuildIds로 빌드별 다른 전개
    // ======================================================
    ScriptPhase(
      name: 'zerg_transition',
      startLine: 29,
      branches: [
        // --- 분기 A: 히드라 압박 (5해처리 히드라 / 3해처리 히드라 / 973) ---
        ScriptBranch(
          id: 'hydra_push',
          conditionHomeBuildIds: [
            'zvp_3hatch_hydra', 'zvp_trans_5hatch_hydra',
            'zvp_973_hydra', 'zvp_trans_973_hydra',
          ],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라덴에서 히드라리스크 대량 생산! 속업 사업 동시 연구!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25,
              altText: '{home}, 히드라가 쏟아집니다! 업그레이드도 진행 중!',
            ),
            ScriptEvent(
              text: '{home}, 히드라 편대가 프로토스 앞마당으로 이동합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home} 선수 히드라 행군! 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 캐논 라인을 두드립니다! 화력이 강합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 히드라 공격! 캐논이 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿과 캐논으로 막으려 하지만 수비가 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 질럿이 녹습니다! 캐논으로도 부족한 화력!',
            ),
            ScriptEvent(
              text: '히드라 압박이 프로토스 앞마당을 흔들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // --- 분기 B: 히드라 럴커 전환 ---
        ScriptBranch(
          id: 'hydra_lurker',
          conditionHomeBuildIds: ['zvp_trans_hydra_lurker'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라리스크를 생산하면서 레어를 올립니다! 럴커를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25,
              altText: '{home}, 히드라와 레어! 럴커 변태를 준비합니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 럴커로 변태합니다! 입구를 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
              altText: '{home} 선수 럴커 변태 완료! 진지를 구축합니다!',
            ),
            ScriptEvent(
              text: '{home}, 럴커가 앞마당 입구에 포진합니다! 상대가 접근 불가!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'defense',
              altText: '{home} 선수 럴커 포진! 프로토스가 전진할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 로보틱스와 옵저버터리를 올려 옵저버를 급히 생산합니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 로보틱스와 옵저버터리! 럴커를 잡으려면 탐지기가 필요합니다!',
            ),
            ScriptEvent(
              text: '럴커가 버로우하면 옵저버 없이는 공격할 수 없습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 C: 뮤탈리스크 전환 ---
        ScriptBranch(
          id: 'mutal_harass',
          conditionHomeBuildIds: ['zvp_2hatch_mutal', 'zvp_trans_mutal_hydra'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어에서 스파이어를 올립니다! 뮤탈리스크를 택했습니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스파이어! 뮤탈리스크입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크 5기 완성! 프로브를 견제하러 갑니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -25, favorsStat: 'harass',
              altText: '{home}, 뮤탈 5기 완성! 견제 출발!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 물어뜯습니다! 커세어가 늦었어요!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤짤! 일꾼이 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 뒤늦게 대응합니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: -1,
            ),
            ScriptEvent(
              text: '뮤탈 견제가 성공적입니다! 프로토스 일꾼에 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 D: 하이브 디파일러 전환 ---
        ScriptBranch(
          id: 'hive_defiler',
          conditionHomeBuildIds: ['zvp_scourge_defiler', 'zvp_trans_hive_defiler'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어에서 스파이어와 스커지를 생산합니다! 커세어를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home}, 스파이어에서 스커지! 커세어를 잡으려는 의도!',
            ),
            ScriptEvent(
              text: '{home}, 스커지가 커세어를 향해 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 스커지 돌진! 커세어를 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 퀸즈네스트를 거쳐 하이브를 향합니다! 디파일러 마운드도 준비!',
              owner: LogOwner.home,
              homeResource: -30, favorsStat: 'strategy',
              altText: '{home}, 퀸즈네스트에서 하이브! 디파일러 마운드를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라덴 건설! 히드라도 함께 생산합니다.',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
            ),
            ScriptEvent(
              text: '스커지로 공중을 견제하면서 하이브를 향하는 장기 운영!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // --- 분기 E: 폴백 (조건 없음 → 기본 히드라 운영) ---
        ScriptBranch(
          id: 'default_hydra',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라덴 건설! 히드라리스크 생산 시작!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -25,
              altText: '{home}, 히드라가 나옵니다! 업그레이드도 진행!',
            ),
            ScriptEvent(
              text: '{home}, 히드라 편대가 프로토스 앞마당을 향해 이동합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home} 선수 히드라 행군! 프로토스 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논 추가 건설! 히드라를 막으려 합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '히드라 압박과 프로토스 수비의 대결입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ======================================================
    // Phase 3: 중반 교전 - 하이 템플러 등장 (lines 47-60)
    // ======================================================
    ScriptPhase(
      name: 'mid_battle',
      startLine: 47,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 하이 템플러가 나왔습니다! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{home} 선수 병력을 계속 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
          altText: '{home}, 병력을 계속 뽑고 있습니다! 물량으로 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 저그 병력에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 스톰이 저그 병력을 강타합니다!',
        ),
        ScriptEvent(
          text: '{home}, 분산 컨트롤! 피해를 줄입니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 분산! 스톰 피해를 최소화합니다!',
        ),
        ScriptEvent(
          text: '스톰과 저그 물량의 대결이 계속됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // ======================================================
    // Phase 4: 후반 결전 - 분기 (lines 61-78)
    // ======================================================
    ScriptPhase(
      name: 'late_decisive',
      startLine: 61,
      branches: [
        // 분기 A: 하이브 병력 (디파일러 + 울트라)
        ScriptBranch(
          id: 'hive_army',
          conditionHomeBuildIds: [
            'zvp_scourge_defiler', 'zvp_trans_hive_defiler',
          ],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이브 완성! 디파일러 마운드에서 디파일러가 합류합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 하이브 완성! 디파일러 마운드! 디파일러 등장!',
            ),
            ScriptEvent(
              text: '{home}, 플레이그! 드라군 편대가 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 플레이그 명중! 상대 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 울트라리스크 캐번 완성 후 울트라리스크까지 합류! 최종 병력 투입!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수 아콘으로 전환! 하지만 역부족입니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '하이브 병력이 전장을 지배하기 시작합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 럴커 진지 유지
        ScriptBranch(
          id: 'lurker_lockdown',
          conditionHomeBuildIds: ['zvp_trans_hydra_lurker'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커를 대량으로 깔아둡니다! 전장이 가시밭!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'defense',
              altText: '{home}, 럴커가 5기 이상! 상대가 접근할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버를 잃었습니다! 드라군이 보이지 않는 공격에 당합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 옵저버 격추! 상대가 럴커를 포착할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 빈 틈을 노려 견제합니다! 프로브가 위험!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 퀸즈네스트와 하이브 완성! 디파일러 마운드에서 디파일러까지! 다크 스웜!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러 마운드 완성! 다크 스웜 속에서 무적!',
            ),
            ScriptEvent(
              text: '럴커 진지가 난공불락! 프로토스가 돌파하지 못합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 뮤탈 기동력 승리
        ScriptBranch(
          id: 'mutal_mobility',
          conditionHomeBuildIds: ['zvp_2hatch_mutal', 'zvp_trans_mutal_hydra'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈 히드라 저글링 전 병력 총동원!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 하이 템플러를 물어뜯습니다! 스톰 시전을 방해!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 견제! 하이 템플러가 잡힙니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 프로토스 확장기지로 침투합니다! 프로브가 위험!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 저글링 견제! 프로브를 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 스톰으로 맞대응! 하지만 뮤탈이 빠져나갑니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '뮤탈 기동력이 승부를 결정합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 D: 프로토스 한방 병력 승리 (폴백)
        ScriptBranch(
          id: 'protoss_deathball',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드라군 질럿 하이 템플러 한방 병력 완성!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25,
              altText: '{away}, 프로토스 한방 병력이 완성됐습니다!',
            ),
            ScriptEvent(
              text: '{away}, 전진! 저그 멀티를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 스톰! 저그 병력을 쓸어버립니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 저그 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away}, 셔틀에 하이 템플러를 태워서 견제! 스톰으로 일꾼을 태웁니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 셔틀 견제! 스톰이 드론을 강타합니다!',
            ),
            ScriptEvent(
              text: '프로토스 한방 병력이 저그를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
