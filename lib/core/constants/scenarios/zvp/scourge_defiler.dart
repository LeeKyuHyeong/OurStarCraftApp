part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. 하이브 운영 (스커지 디파일러) vs 포지더블
// ----------------------------------------------------------
const _zvpScourgeDefiler = ScenarioScript(
  id: 'zvp_scourge_defiler',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_scourge_defiler', 'zvp_trans_hive_defiler'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_forge_expand', 'pvz_trans_corsair',
                 'pvz_trans_archon'],
  description: '하이브 운영 디파일러 vs 프로토스 한방 병력',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 자원을 확보합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스! 게이트웨이와 포지더블로 갑니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지와 게이트웨이로 입구를 막아줍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 빠르게 올립니다! 스파이어 준비!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어에서 스파이어가 올라갑니다! 테크를 서두르는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 스커지 히드라 중반 (lines 17-30)
    ScriptPhase(
      name: 'scourge_hydra_mid',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스커지를 생산합니다! 커세어를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 스커지! 커세어를 잡으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 오버로드를 사냥하러 갑니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home}, 스커지가 커세어를 향해 돌진합니다!',
          owner: LogOwner.home,
          awayArmy: -2, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 스커지가 돌진합니다! 공중 유닛 격추!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 지상 병력도 갖춥니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라도 함께 생산! 지상 압박도 가져갑니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '스커지로 공중을 견제하면서 히드라로 압박하는 복합 운영!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 하이브 전환 - 분기 (lines 31-46)
    ScriptPhase(
      name: 'hive_transition',
      startLine: 31,
      branches: [
        // 분기 A: 하이브 전환 성공
        ScriptBranch(
          id: 'hive_tech_up',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 퀸즈네스트 완성 후 하이브를 올립니다! 디파일러 마운드도 건설!',
              owner: LogOwner.home,
              homeResource: -30, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러 마운드를 올립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아둔과 템플러 아카이브를 올려 하이 템플러 합류! 스톰 준비 완료!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 디파일러 생산 시작! 컨슘과 플레이그 연구!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home} 선수 디파일러 마운드에서 디파일러 생산! 저그 후반 핵심 유닛!',
            ),
            ScriptEvent(
              text: '하이브 테크가 완성되면 디파일러의 플레이그가 프로토스를 위협합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 프로토스 선제 공격
        ScriptBranch(
          id: 'protoss_timing_push',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{away} 선수 하이브 완성 전에 공격합니다! 타이밍 어택!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
              altText: '{away}, 한방 병력 전진! 하이브 전에 끝내겠다는 의도!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 히드라로 입구를 막습니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 스톰으로 전진합니다! 스톰이 히드라를 녹여냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 스톰이 히드라 편대를 녹여냅니다!',
            ),
            ScriptEvent(
              text: '하이브 전에 승부를 내려는 프로토스! 시간 싸움!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 디파일러 교전 (lines 47-62)
    ScriptPhase(
      name: 'defiler_battle',
      startLine: 47,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 퀸즈네스트와 하이브 완성! 디파일러 마운드에서 디파일러가 전장에 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 하이브 완성 후 디파일러 마운드! 디파일러 등장! 저그 후반의 시작!',
        ),
        ScriptEvent(
          text: '{home}, 플레이그! 드라군 편대 위에 떨어집니다!',
          owner: LogOwner.home,
          awayArmy: -4, favorsStat: 'strategy',
          altText: '{home} 선수 플레이그 명중! 상대 병력이 녹아내립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스톰으로 맞대응! 히드라 편대를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home}, 다크 스웜! 상대 원거리 공격이 무효화됩니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'strategy',
          altText: '{home} 선수 다크 스웜! 상대 유닛이 히드라를 못 잡습니다!',
        ),
        ScriptEvent(
          text: '디파일러 마법 vs 하이 템플러 마법! 스킬 전쟁입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후반 결전 - 분기 (lines 63-78)
    ScriptPhase(
      name: 'late_decisive',
      startLine: 63,
      branches: [
        // 분기 A: 울트라+저글링 물량 압도
        ScriptBranch(
          id: 'ultra_ling_flood',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 울트라리스크 캐번 완성! 울트라리스크 합류! 아드레날린 저글링도 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -25,
              altText: '{home}, 울트라리스크 캐번에서 울트라 저글링! 하이브 병력 총출동!',
            ),
            ScriptEvent(
              text: '{home}, 플레이그와 다크 스웜 속에서 울트라가 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘으로 전환! 하지만 아콘으로도 역부족입니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 저글링이 확장기지를 공격합니다! 프로브가 위험!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '하이브 병력이 전장을 지배합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 프로토스 아콘+스톰으로 돌파
        ScriptBranch(
          id: 'archon_storm_break',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 아콘 변환! 스톰과 아콘의 복합 화력!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'strategy',
              altText: '{away}, 아콘이 완성됩니다! 저그 병력에 치명적!',
            ),
            ScriptEvent(
              text: '{away}, 아콘이 저글링을 쓸어버립니다! 범위 공격!',
              owner: LogOwner.away,
              homeArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 아콘 화력! 아콘이 저글링을 순식간에 증발시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 디파일러를 계속 보충하지만 아콘이 너무 강합니다!',
              owner: LogOwner.home,
              homeArmy: -3, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 로보틱스에서 생산한 셔틀로 견제! 스톰으로 일꾼을 태웁니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '프로토스 한방 병력의 화력이 저그를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

