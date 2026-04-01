part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 1. 히드라 압박 vs 포지더블 (가장 대표적인 ZvP)
// ----------------------------------------------------------
const _zvpHydraVsForge = ScenarioScript(
  id: 'zvp_hydra_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_12hatch', 'zvp_12pool', 'zvp_3hatch_hydra',
                 'zvp_trans_5hatch_hydra', 'zvp_973_hydra', 'zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_forge_expand', 'pvz_trans_corsair'],
  description: '히드라 압박 vs 포지더블 국룰전',
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
          text: '{away} 선수 파일런 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 12앞마당 해처리! 확장을 가져갑니다.',
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
          text: '{away} 선수 앞마당 넥서스! 게이트웨이와 사이버네틱스 코어로 입구를 막습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지와 게이트웨이, 사이버네틱스 코어로 입구를 막아주고요.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣으면서 히드라덴 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스 채취 시작! 히드라덴을 올리려는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설! 커세어를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트가 올라갑니다! 커세어!',
        ),
      ],
    ),
    // Phase 1: 히드라 vs 커세어 (lines 17-28)
    ScriptPhase(
      name: 'hydra_vs_corsair',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 속업 사업 동시 연구!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 히드라가 나옵니다! 업그레이드도 진행 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 오버로드를 사냥하러 갑니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 커세어가 뜹니다! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 편대가 프로토스 앞마당으로 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home}, 히드라 행군 시작! 프로토스 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 커세어로 오버로드를 격추합니다! 서플라이 조절!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 커세어 기동! 오버로드 격추!',
        ),
        ScriptEvent(
          text: '히드라 압박과 커세어 견제가 동시에 진행됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 히드라 압박 결과 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'hydra_push_result',
      startLine: 29,
      branches: [
        // 분기 A: 히드라 압박 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'hydra_push_success',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 히드라 편대가 프로토스 앞마당을 두드립니다!',
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
              text: '{home}, 히드라가 앞마당 진입! 프로브가 위험합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '히드라 압박이 프로토스 앞마당을 흔들고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 커세어 오버로드 사냥 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'corsair_overlord_hunt',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away}, 커세어 3기로 오버로드를 연속 격추합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 커세어 기동! 오버로드 연속 격추!',
            ),
            ScriptEvent(
              text: '{home} 선수 서플라이가 막혀서 히드라를 추가 못 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: -1, homeResource: -10,
              altText: '{home}, 오버로드 손실! 서플라이 블럭!',
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 아둔과 템플러 아카이브를 올립니다! 스톰 준비!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '커세어가 오버로드를 줄여주면서 테크 시간을 벌었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 캐논 방어 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'cannon_defense_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논 추가 건설! 히드라를 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 캐논 라인이 촘촘합니다! 캐논이 압박을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 공격이 캐논과 질럿에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 압박이 저지됩니다! 수비가 탄탄하구요!',
            ),
            ScriptEvent(
              text: '{away}, 버티면서 아둔과 템플러 아카이브를 올려 하이 템플러를 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '프로토스 수비가 성공! 하이 템플러 타이밍이 다가옵니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 하이 템플러 등장 (lines 43-56)
    ScriptPhase(
      name: 'high_templar',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 하이 템플러 합류! 사이오닉 스톰 준비!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 하이 템플러가 나왔습니다! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 물량을 계속 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
          altText: '{home}, 히드라를 계속 뽑고 있습니다! 물량으로 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 히드라 편대에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 스톰이 히드라 편대를 강타합니다!',
        ),
        ScriptEvent(
          text: '{home}, 히드라 분산 컨트롤! 피해를 줄입니다! 스톰 회피!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 히드라 분산! 스톰 피해를 최소화합니다!',
        ),
        ScriptEvent(
          text: '스톰과 히드라 물량의 대결이 계속됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 후반 전환 - 분기 (lines 57-72)
    ScriptPhase(
      name: 'late_game',
      startLine: 57,
      branches: [
        // 분기 A: 저그 하이브 테크 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'zerg_hive_tech',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이브 완성! 디파일러 마운드와 울트라리스크 캐번을 올립니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러 마운드와 울트라리스크 캐번 건설!',
            ),
            ScriptEvent(
              text: '{home}, 디파일러 플레이그! 드라군 편대가 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 플레이그! 프로토스 병력에 지속 피해!',
            ),
            ScriptEvent(
              text: '{home}, 울트라리스크까지 합류! 최종 병력 투입!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수 아콘으로 전환! 하지만 아콘으로도 역부족!',
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
        // 분기 B: 프로토스 한방 병력 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'protoss_deathball',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 게이트웨이와 사이버네틱스 코어에서 드라군 질럿! 로보틱스에서 옵저버터리까지! 한방 병력 완성!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25,
              altText: '{away}, 프로토스 한방 병력이 완성됐습니다! 게이트웨이와 로보틱스에서 옵저버터리까지 풀가동!',
            ),
            ScriptEvent(
              text: '{away}, 전진! 야금야금 교전하면서 저그 멀티를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 히드라로 입구를 틀어막습니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'defense',
              altText: '{home}, 럴커 포진! 프로토스 전진을 저지합니다!',
            ),
            ScriptEvent(
              text: '{away}, 셔틀에 하이 템플러를 태워서 견제! 스톰으로 일꾼을 태웁니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 셔틀 견제! 스톰이 드론을 강타합니다!',
            ),
            ScriptEvent(
              text: '프로토스 한방 병력과 저그 수비의 팽팽한 대결!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

