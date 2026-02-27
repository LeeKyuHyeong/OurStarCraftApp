part of 'scenario_scripts.dart';

// ============================================================
// ZvP 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

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
          text: '{away} 선수 앞마당 넥서스! 게이트웨이로 입구를 막습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지+게이트로 입구를 막아주고요.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣으면서 히드라덴 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스 채취 시작! 히드라 테크를 올리려는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 건설! 커세어를 준비합니다.',
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
          text: '{away}, 커세어가 오버로드를 격추합니다! 서플라이 조절!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 커세어 기동! 오버로드가 떨어집니다!',
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
              text: '{away} 선수 질럿과 캐논으로 막으려 하지만 히드라가 너무 많습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 질럿이 녹습니다! 히드라 화력에 밀리는데요!',
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
              text: '{away}, 커세어 3기가 오버로드를 연속 격추합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 커세어 기동! 오버로드가 줄줄이 떨어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 서플라이가 막혀서 히드라를 추가 못 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: -1, homeResource: -10,
              altText: '{home}, 오버로드 손실! 서플라이 블럭!',
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 하이 템플러 테크를 올립니다! 스톰 준비!',
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
              altText: '{away}, 캐논 라인이 촘촘합니다! 히드라가 못 뚫어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 캐논+질럿에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 히드라 공격이 저지됩니다! 수비가 탄탄하구요!',
            ),
            ScriptEvent(
              text: '{away}, 버티면서 하이 템플러를 준비합니다!',
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
          altText: '{away} 선수 스톰 투하! 히드라가 피해를 입습니다!',
        ),
        ScriptEvent(
          text: '{home}, 히드라가 흩어지면서 피해를 줄입니다! 스톰 회피!',
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
              text: '{home} 선수 하이브 완성! 디파일러를 준비합니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러가 나옵니다!',
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
              text: '{away} 선수 아콘으로 전환! 하지만 디파일러가 너무 강합니다!',
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
              text: '{away} 선수 드라군 질럿 하이 템플러 옵저버! 한방 병력 완성!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25,
              altText: '{away}, 프로토스 한방 병력이 완성됐습니다!',
            ),
            ScriptEvent(
              text: '{away}, 전진! 야금야금 교전하면서 저그 멀티를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커+히드라로 입구를 틀어막습니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'defense',
              altText: '{home}, 럴커 포진! 프로토스 전진을 저지합니다!',
            ),
            ScriptEvent(
              text: '{away}, 셔틀에 하이 템플러를 태워서 견제! 드론이 스톰에!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 셔틀 견제! 드론이 스톰에 녹습니다!',
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

// ----------------------------------------------------------
// 2. 뮤탈 운영 vs 포지더블 (뮤탈 택)
// ----------------------------------------------------------
const _zvpMutalVsForge = ScenarioScript(
  id: 'zvp_mutal_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_2hatch_mutal', 'zvp_trans_mutal_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_corsair', 'pvz_trans_forge_expand'],
  description: '뮤탈 운영 vs 포지더블',
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
          text: '{home} 선수 앞마당 해처리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스와 캐논 건설!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 포지더블 완성! 입구를 단단히 막습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스 채취! 뮤탈을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 올리면서 스파이어 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스파이어를 올릴 준비! 뮤탈리스크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 건설! 커세어를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 뮤탈 등장 (lines 17-26)
    ScriptPhase(
      name: 'mutal_debut',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 생산 시작! 5기가 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 뮤탈 5기 완성! 견제 출발!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어와 스포어로 대비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 프로브 라인으로 향합니다! 견제!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 뮤탈 기동! 프로브를 노립니다!',
        ),
      ],
    ),
    // Phase 2: 뮤탈 견제 - 분기 (lines 27-40)
    ScriptPhase(
      name: 'mutal_harass',
      startLine: 27,
      branches: [
        // 분기 A: 뮤탈 견제 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'mutal_harass_success',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 물어뜯습니다! 커세어가 늦었어요!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 뮤짤! 프로브가 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 뒤늦게 대응합니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈을 빼면서 다른 곳을 노립니다! 기동력이 좋네요!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 이리저리 피하면서 견제합니다!',
            ),
            ScriptEvent(
              text: '뮤탈 견제가 성공적입니다! 프로토스 일꾼에 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 커세어가 뮤탈 대응 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'corsair_mutal_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 커세어가 뮤탈을 쫓아갑니다! 공중 추격전!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 커세어 컨트롤! 뮤탈을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈이 피해를 입었지만 빠져나갑니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 커세어로 오버로드를 사냥합니다!',
              owner: LogOwner.away,
              homeResource: -5, awayArmy: 1,
            ),
            ScriptEvent(
              text: '커세어가 뮤탈을 견제하면서 안정적인 운영!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 41-54)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라를 추가 생산합니다! 뮤탈+히드라 조합!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
          altText: '{home}, 뮤탈에 히드라까지! 복합 편성입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러 합류! 스톰 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home}, 히드라 편대가 프로토스 앞마당을 공격합니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 히드라 편대에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -5, favorsStat: 'strategy',
          altText: '{away} 선수 스톰! 히드라가 피해를 입습니다!',
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 하이 템플러를 물어뜯습니다! 스톰 시전을 방해!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 뮤탈 견제! 하이 템플러가 잡힙니다!',
        ),
        ScriptEvent(
          text: '스톰과 뮤탈 기동력의 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 55-66)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 전 병력 총동원! 뮤탈 히드라 저글링!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 질럿 하이 템플러 총출동!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전면전이 시작됩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 하이 템플러를 노립니다! 스톰을 막아야 합니다!',
          owner: LogOwner.home,
          awayArmy: -4, homeArmy: -3, favorsStat: 'control',
          altText: '{home} 선수 뮤탈로 하이 템플러 솎아내기! 핵심 유닛을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰 투하! 히드라가 피해를 입습니다!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -2, favorsStat: 'strategy',
          altText: '{away} 선수 스톰! 히드라에 타격을 줍니다!',
        ),
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 확장기지로 침투합니다! 프로브가 위험!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'harass',
          altText: '{home} 선수 저글링 견제! 프로브를 노립니다!',
        ),
      ],
    ),
    // Phase 5: 결전 결과 - 분기 (lines 67-70)
    ScriptPhase(
      name: 'decisive_result',
      startLine: 67,
      branches: [
        ScriptBranch(
          id: 'zerg_mutal_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 기동력이 승부를 결정합니다! 저그 승리!',
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
              text: '스톰이 히드라를 쓸어버립니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 3. 9풀 vs 포지더블 (초반 압박)
// ----------------------------------------------------------
const _zvp9poolVsForge = ScenarioScript(
  id: 'zvp_9pool_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_9pool', 'zvp_9overpool'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_trans_forge_expand'],
  description: '9풀 저글링 vs 포지더블 초반 압박',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 빠르게 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 빠릅니다! 공격적인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업도 연구합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 저글링 나옵니다! 발업까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스 건설 시작합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 13-18)
    ScriptPhase(
      name: 'ling_arrival',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 프로토스 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논이 완성됐을까요? 아직 건설 중인데!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 수비 여부 - 분기 (lines 19-32)
    ScriptPhase(
      name: 'defense_check',
      startLine: 19,
      branches: [
        // 분기 A: 저글링 돌파 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'ling_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 캐논 완성 전에 도착! 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -1, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 저글링 진입! 캐논이 아직 미완성!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 저글링이 너무 빠릅니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
              altText: '{away}, 프로브가 쓰러집니다! 저글링 속도를 못 따라가요!',
            ),
            ScriptEvent(
              text: '{home}, 본진까지 침투! 프로브가 줄어들고 있습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '저글링이 프로토스 일꾼을 파괴하고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 캐논 수비 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'cannon_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논 완성! 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 캐논이 제때 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 피해가 큽니다! 캐논에 막히는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 질럿까지 나오면서 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '캐논 수비 성공! 저그가 자원이 뒤처집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 4. 4풀 vs 전진 게이트 (치즈 대결)
// ----------------------------------------------------------
const _zvpCheeseVsCheese = ScenarioScript(
  id: 'zvp_cheese_vs_cheese',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool', 'zvp_5drone'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_2gate_zealot', 'pvz_cannon_rush', 'pvz_8gat'],
  description: '저그 올인 vs 프로토스 올인 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 아주 빠르게 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 엄청 빠릅니다! 올인인가요?',
        ),
        ScriptEvent(
          text: '{away} 선수도 게이트웨이를 일찍 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 게이트웨이가 빠릅니다! 양쪽 다 공격적!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
        ),
      ],
    ),
    // Phase 1: 충돌 (lines 11-16)
    ScriptPhase(
      name: 'collision',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 모두 올인! 센터에서 마주칠 수 있습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 저글링이 질럿을 만났습니다! 수적 우위!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 저글링 서라운드! 질럿을 감쌉니다!',
        ),
        ScriptEvent(
          text: '{away}, 질럿의 화력으로 저글링을 잡아냅니다!',
          owner: LogOwner.away,
          homeArmy: -1, awayArmy: 2, favorsStat: 'control',
          altText: '{away} 선수 질럿 컨트롤! 저글링이 녹습니다!',
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-28)
    ScriptPhase(
      name: 'cheese_result',
      startLine: 17,
      branches: [
        // 분기 A: 저글링 물량 승리 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'lings_overwhelm',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 물량이 질럿을 압도합니다! 프로브를 향해 돌진!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -10, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 프로브 라인을 초토화!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 저글링이 너무 많습니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
            ),
            ScriptEvent(
              text: '저글링 물량이 프로토스를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 질럿 수비 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'zealots_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 저글링을 다 잡아냅니다! 컨트롤 차이!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 질럿 컨트롤! 저글링이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 전멸! 추가 생산할 자원도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '질럿이 저글링을 압도했습니다! 프로토스 유리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

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
          text: '{away} 선수 스타게이트 건설! 커세어 리버를 노립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트! 선아둔 빌드로 가는 건가요?',
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
          altText: '{home}, 뮤탈 준비! 견제를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 동시에 로보틱스 건설!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -25,
          altText: '{away}, 커세어+리버 복합 빌드입니다!',
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
          altText: '{home}, 뮤탈+스커지 조합! 커세어를 노립니다!',
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
              text: '{away}, 리버 투하! 드론이 스캐럽에 날아갑니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 스캐럽 명중! 드론 대학살!',
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
              altText: '{home} 선수 스커지 자폭! 셔틀이 격추됩니다!',
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
          text: '{home} 선수 히드라+럴커로 전환! 전면전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 히드라 럴커 조합! 지상 전력을 강화합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 질럿 하이 템플러! 한방 병력!',
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
          text: '{away}, 스톰! 히드라 편대가 녹아내립니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -2, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 히드라가 증발합니다!',
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

// ----------------------------------------------------------
// 6. 하이브 운영 (스커지+디파일러) vs 포지더블
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
          altText: '{home}, 앞마당 해처리! 경제력을 챙깁니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스! 포지더블로 갑니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지+게이트로 입구를 막아줍니다.',
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
          altText: '{home}, 레어가 빠릅니다! 테크를 서두르는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 건설합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 스커지+히드라 중반 (lines 17-30)
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
          altText: '{home} 선수 스커지 자폭! 커세어가 격추됩니다!',
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
              text: '{home} 선수 하이브를 올립니다! 디파일러를 준비!',
              owner: LogOwner.home,
              homeResource: -30, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 하이 템플러 합류! 스톰 준비 완료!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 디파일러 생산 시작! 컨슘+플레이그 연구!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home} 선수 디파일러가 나옵니다! 저그 후반 핵심 유닛!',
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
              text: '{home} 선수 럴커+히드라로 입구를 막습니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 스톰으로 히드라를 녹이면서 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 히드라가 녹아내립니다!',
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
          text: '{home} 선수 디파일러가 전장에 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 디파일러 등장! 저그 후반의 시작!',
        ),
        ScriptEvent(
          text: '{home}, 플레이그! 드라군 편대 위에 떨어집니다!',
          owner: LogOwner.home,
          awayArmy: -5, favorsStat: 'strategy',
          altText: '{home} 선수 플레이그 명중! 드라군이 녹아내립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스톰으로 맞대응! 히드라 편대를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home}, 다크 스웜! 드라군의 공격이 무효화됩니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          altText: '{home} 선수 다크 스웜! 드라군이 히드라를 못 잡습니다!',
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
              text: '{home} 선수 울트라리스크 합류! 아드레날린 저글링도 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -25,
              altText: '{home}, 울트라+저글링! 하이브 병력 총출동!',
            ),
            ScriptEvent(
              text: '{home}, 플레이그+다크 스웜 속에서 울트라가 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘으로 전환! 하지만 디파일러 마법이 너무 강합니다!',
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
              altText: '{away} 선수 아콘 화력! 저글링이 순식간에 증발!',
            ),
            ScriptEvent(
              text: '{home} 선수 디파일러를 계속 보충하지만 아콘이 너무 강합니다!',
              owner: LogOwner.home,
              homeArmy: -3, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 셔틀 견제! 드론을 스톰으로 태웁니다!',
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

// ----------------------------------------------------------
// 7. 973 히드라 전용 (빠른 히드라 올인)
// ----------------------------------------------------------
const _zvp973HydraRush = ScenarioScript(
  id: 'zvp_973_hydra_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_973_hydra', 'zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_forge_expand', 'pvz_trans_corsair'],
  description: '973 히드라 빠른 올인 압박',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9서플 7가스 3해처리로 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 973 오프닝! 가스를 일찍 넣습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설! 동시에 해처리 추가!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 풀과 해처리를 동시에! 빠른 테크 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 가스가 빨라서 히드라가 일찍 나옵니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 히드라덴이 빠릅니다! 973 빌드의 핵심!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이+캐논으로 입구를 막습니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 입구 심시티! 저글링을 대비합니다.',
        ),
      ],
    ),
    // Phase 1: 빠른 히드라 등장 (lines 15-24)
    ScriptPhase(
      name: 'fast_hydra',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 속업+사업 동시 연구! 빠릅니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 히드라 업그레이드가 빠르게 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 올리지만 커세어가 늦을 수 있습니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트 건설! 하지만 히드라가 먼저 올까요?',
        ),
        ScriptEvent(
          text: '{home}, 히드라 편대가 빠르게 모입니다! 프로토스 앞마당으로!',
          owner: LogOwner.home,
          homeArmy: 4, favorsStat: 'attack',
          altText: '{home} 선수 히드라 행군! 973의 빠른 타이밍!',
        ),
        ScriptEvent(
          text: '973 빌드의 히드라 타이밍이 굉장히 빠릅니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 히드라 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'hydra_timing',
      startLine: 25,
      branches: [
        // 분기 A: 히드라 타이밍 성공
        ScriptBranch(
          id: 'hydra_timing_hit',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 히드라가 캐논 라인을 두드립니다! 커세어가 아직 없어요!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 히드라 공격! 캐논만으로는 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿과 캐논으로 막으려 하지만 히드라 화력에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 수비가 밀리고 있습니다! 히드라가 너무 빨랐어요!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 앞마당 진입! 프로브가 도망칩니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '973 타이밍이 적중! 프로토스 앞마당이 흔들립니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 캐논+질럿 방어 성공
        ScriptBranch(
          id: 'cannon_zealot_hold',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논 2개+질럿으로 버팁니다! 히드라를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 캐논 라인이 탄탄합니다! 히드라가 못 뚫어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 피해가 큽니다! 앞마당을 못 뚫는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 커세어 생산 시작! 시간을 벌었습니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
            ),
            ScriptEvent(
              text: '프로토스 수비 성공! 973 타이밍을 넘겼습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전환 (lines 41-52)
    ScriptPhase(
      name: 'late_transition',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 멀티 해처리를 추가합니다! 물량으로 밀어붙입니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 확장! 히드라 물량을 보충합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 하이 템플러가 나왔습니다! 스톰!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 뭉쳐있던 히드라가 피해를 입습니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
          altText: '{away} 선수 스톰! 히드라 편대에 타격!',
        ),
        ScriptEvent(
          text: '{home} 선수 럴커 변태! 입구를 잡으면서 버팁니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -3, favorsStat: 'defense',
        ),
      ],
    ),
    // Phase 4: 후반 결과 - 분기 (lines 53-54)
    ScriptPhase(
      name: 'late_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'hydra_quantity_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '히드라 물량이 스톰을 이겨냅니다! 저그 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'storm_overwhelms',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '스톰이 히드라를 쓸어버립니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 8. 12앞/12풀 vs 전진 2게이트 (스탠다드 vs 공격형)
// ----------------------------------------------------------
const _zvpStandardVs2Gate = ScenarioScript(
  id: 'zvp_standard_vs_2gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_12hatch', 'zvp_12pool'],
  awayBuildIds: ['pvz_2gate_zealot'],
  description: '12앞마당 vs 전진 2게이트 질럿 압박',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 12앞마당! 경제를 챙기는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 프로브가 빠르게 나갑니다! 전진 건물?',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 파일런! 게이트웨이 2개를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 전진 2게이트! 공격적인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 질럿 도착 (lines 13-20)
    ScriptPhase(
      name: 'zealot_arrival',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 질럿 3기가 모였습니다! 저그 앞마당을 향해 출발!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'attack',
          altText: '{away}, 질럿 3기! 앞마당 해처리를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 겨우 나오기 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 저글링이 나왔지만 질럿이 이미 도착!',
        ),
        ScriptEvent(
          text: '질럿이 두 번 찌르면 저글링이 죽습니다! 수적으로 불리!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 앞마당 공방 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'nat_defense',
      startLine: 21,
      branches: [
        // 분기 A: 성큰+저글링 방어 성공
        ScriptBranch(
          id: 'sunken_defense_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당에 성큰 콜로니를 세웁니다! 드론도 동원!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15, favorsStat: 'defense',
              altText: '{home}, 성큰! 드론까지 동원해서 막아봅니다!',
            ),
            ScriptEvent(
              text: '{away}, 질럿이 성큰을 노리지만 저글링이 서라운드합니다!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 질럿이 성큰에 막힙니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링 추가 생산! 질럿을 하나씩 잡아냅니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '성큰+저글링 수비 성공! 전진 2게이트를 막았습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 질럿 돌파
        ScriptBranch(
          id: 'zealot_breakthrough',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 성큰 완성 전에 도착! 해처리를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'attack',
              altText: '{away} 선수 질럿 돌파! 성큰이 아직 안 올라왔습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론으로 막으려 하지만 질럿 화력에 밀립니다!',
              owner: LogOwner.home,
              homeResource: -10, awayArmy: -1,
              altText: '{home}, 드론이 쓰러집니다! 질럿이 너무 강해요!',
            ),
            ScriptEvent(
              text: '{away}, 질럿이 앞마당 해처리를 공격합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '전진 2게이트 타이밍이 적중! 앞마당이 위험합니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 - 분기 (lines 37-50)
    ScriptPhase(
      name: 'aftermath',
      startLine: 37,
      branches: [
        // 분기 A: 방어 성공 후 역공
        ScriptBranch(
          id: 'zerg_counterattack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 저글링으로 역공! 프로토스 본진을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -1, favorsStat: 'attack',
              altText: '{home}, 저글링 역공! 프로토스가 투자한 게 너무 많습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 유닛이 없습니다! 프로브가 위험!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 본진이 비었습니다! 질럿이 전부 앞마당에!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 프로브를 쓸어버립니다!',
              owner: LogOwner.home,
              awayResource: -10, homeArmy: -1, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '2게이트를 막고 역공까지! 저그가 유리합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 질럿 피해 후 소모전
        ScriptBranch(
          id: 'attrition_battle',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 추가 질럿을 계속 보냅니다! 소모전!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
              altText: '{away}, 질럿을 계속 뽑습니다! 물량으로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링+성큰으로 간신히 버팁니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 히드라덴을 올리기 시작합니다! 버틸 수 있을까요?',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '소모전이 계속됩니다! 누가 먼저 지치느냐의 싸움!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

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
          text: '{home} 선수 해처리를 연달아 올립니다! 경제를 최대한 챙깁니다!',
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
          altText: '{home}, 3해처리! 경제력에서 앞서겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 건설! 커세어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트! 커세어로 견제하겠다는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 뒤늦게 스포닝풀을 올립니다! 이제야 유닛이!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 풀이 늦습니다! 3해처리의 약점!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 리버를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 로보틱스! 커세어+리버 조합입니다!',
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
          altText: '{away}, 커세어 기동! 오버로드가 떨어집니다!',
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
              altText: '{away} 선수 스캐럽! 드론이 한 방에 날아갑니다!',
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
              altText: '{home} 선수 히드라 대공! 셔틀이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 피해를 입고 후퇴합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 3해처리의 자원으로 히드라를 대량 생산합니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
              altText: '{home} 선수 히드라 물량! 경제력 차이가 나기 시작합니다!',
            ),
            ScriptEvent(
              text: '리버 드랍을 막아냈습니다! 3해처리의 경제력이 빛을 발합니다!',
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
          text: '{away} 선수 하이 템플러가 합류합니다! 스톰!',
          owner: LogOwner.away,
          awayArmy: 4, homeArmy: -4, favorsStat: 'strategy',
          altText: '{away}, 스톰 투하! 히드라가 녹아내립니다!',
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

// ----------------------------------------------------------
// 10. 히드라 럴커 vs 포지더블 (럴커 운영)
// ----------------------------------------------------------
const _zvpHydraLurkerVsForge = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_trans_forge_expand',
                 'pvz_trans_dragoon_push'],
  description: '히드라 럴커 운영 vs 포지더블 드라군 푸시',
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
          text: '{home} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 경제를 챙기는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스! 포지더블입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지+게이트로 입구를 막습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 히드라덴이 올라갑니다! 히드라 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
      ],
    ),
    // Phase 1: 히드라 생산 + 럴커 변태 (lines 17-28)
    ScriptPhase(
      name: 'hydra_lurker_tech',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 속업 연구도 진행합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 히드라가 나옵니다! 업그레이드도 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 생산과 동시에 스타게이트를 건설합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올립니다! 럴커 변태를 노립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어 진행! 럴커를 준비하는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 사냥하러 갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'harass',
          altText: '{away}, 커세어 출격! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{home}, 히드라가 럴커로 변태합니다! 입구를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home} 선수 럴커 변태 완료! 진지를 구축합니다!',
        ),
        ScriptEvent(
          text: '럴커가 버로우하면 옵저버 없이는 공격할 수 없습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 럴커 포진 결과 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'lurker_position',
      startLine: 29,
      branches: [
        // 분기 A: 럴커 포진 성공 (입구 장악)
        ScriptBranch(
          id: 'lurker_lockdown',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 럴커가 앞마당 입구에 포진합니다! 드라군이 접근 불가!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'defense',
              altText: '{home} 선수 럴커 포진! 프로토스가 전진할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 아직 없습니다! 럴커가 보이지 않아요!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 드라군이 럴커에 그대로 녹습니다! 보이지가 않아요!',
            ),
            ScriptEvent(
              text: '{home}, 럴커 뒤에서 히드라가 지원 사격합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커+히드라 조합이 입구를 완벽하게 틀어막고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 옵저버 대응 성공
        ScriptBranch(
          id: 'observer_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 옵저버가 럴커를 포착합니다! 드라군 사격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'strategy',
              altText: '{away}, 옵저버! 럴커가 보입니다! 드라군 집중 사격!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 잡히고 있습니다! 옵저버가 치명적!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 럴커가 녹습니다! 옵저버에 다 보이는데요!',
            ),
            ScriptEvent(
              text: '{away}, 드라군 편대가 전진합니다! 럴커 제거 후 밀어붙이기!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '옵저버가 럴커를 무력화! 프로토스가 전진합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 45-58)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 45,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 멀티를 추가하면서 럴커+히드라를 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 확장! 럴커 물량을 계속 보충합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 푸시를 준비합니다! 옵저버와 함께!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 드라군+옵저버! 럴커를 잡으면서 전진!',
        ),
        ScriptEvent(
          text: '{home}, 럴커가 새로운 포지션에 버로우합니다! 길목을 막습니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'defense',
          altText: '{home} 선수 럴커 재배치! 드라군을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away}, 하이 템플러가 합류합니다! 스톰 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
        ),
        ScriptEvent(
          text: '럴커 진지전 vs 드라군 옵저버 밀어붙이기! 치열한 공방!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 59-74)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 59,
      branches: [
        // 분기 A: 럴커 물량으로 진지 유지
        ScriptBranch(
          id: 'lurker_holds_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커를 대량으로 깔아둡니다! 전장이 가시밭!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'defense',
              altText: '{home}, 럴커 5기 이상! 드라군이 접근할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버를 잃었습니다! 럴커가 다시 보이지 않아요!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 옵저버 격추! 럴커 위치를 알 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 빈 틈을 노려 견제합니다! 프로브가 위험!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 디파일러까지 추가합니다! 다크 스웜!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home}, 다크 스웜 속에서 럴커가 무적입니다!',
            ),
            ScriptEvent(
              text: '럴커 진지가 난공불락! 프로토스가 돌파하지 못합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 프로토스 한방 병력 돌파
        ScriptBranch(
          id: 'protoss_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스톰! 히드라 편대가 녹아내립니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'strategy',
              altText: '{away}, 스톰 명중! 히드라가 증발합니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 럴커를 하나씩 제거합니다! 옵저버 시야 확보!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 다 잡히고 있습니다! 수비가 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 럴커 진지가 붕괴됩니다! 스톰에 이어 드라군 화력!',
            ),
            ScriptEvent(
              text: '{away}, 전 병력 전진! 저그 본진을 향합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '프로토스 한방 병력이 럴커 진지를 돌파합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 11. 4풀/5드론 vs 포지더블 (치즈 vs 표준)
// ----------------------------------------------------------
const _zvpCheeseVsForge = ScenarioScript(
  id: 'zvp_cheese_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool', 'zvp_5drone'],
  awayBuildIds: ['pvz_forge_cannon'],
  description: '저그 올인 러시 vs 포지더블 표준 방어',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 바로 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 초초반 올인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 대량 생산! 6마리가 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
          altText: '{home}, 저글링이 쏟아집니다! 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 캐논을 건설합니다! 포지더블!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 캐논이 올라갑니다! 제때 완성될까요?',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 앞마당에 도착합니다! 건물이 미완성!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 캐논이 아직 완성 전!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브로 막으면서 캐논 완성을 기다립니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 프로브 방어! 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '캐논 완성이 늦으면 그대로 무너집니다! 타이밍 싸움!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 초반 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 저글링 돌파 성공
        ScriptBranch(
          id: 'ling_rush_success',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 캐논 완성 전에 진입! 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 저글링 난입! 프로브가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 버텨보지만 저글링이 빠릅니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
              altText: '{away}, 프로브가 녹고 있습니다! 캐논이 1초 늦었어요!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 넥서스까지 공격합니다! 앞마당 포기?',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 저글링이 포지더블을 흔들고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 캐논+프로브 방어 성공
        ScriptBranch(
          id: 'forge_defense_hold',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 간신히 완성! 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 캐논 완성! 저글링이 녹기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 캐논에 막힙니다! 추가 저글링을 보냅니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 게이트웨이에서 질럿까지 나옵니다! 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 질럿 합류! 저글링이 전부 녹아내립니다!',
            ),
            ScriptEvent(
              text: '포지더블 수비 성공! 4풀 러시를 막아냈습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'aftermath',
      startLine: 31,
      branches: [
        // 분기 A: 러시 실패 후 경제 격차
        ScriptBranch(
          id: 'economy_gap',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드론이 4마리뿐입니다! 경제가 바닥!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home}, 4풀의 대가! 드론이 너무 적습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 넥서스에서 프로브를 계속 뽑습니다! 경제 격차!',
              owner: LogOwner.away,
              awayResource: 20,
              altText: '{away}, 프로브가 쌓입니다! 경제력 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군을 생산하면서 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 실패! 경제 격차를 극복할 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 피해를 주고 후속 올인
        ScriptBranch(
          id: 'follow_up_allin',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링을 계속 보냅니다! 2차 러시!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'attack',
              altText: '{home}, 추가 저글링! 한 번 더 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논은 있지만 질럿이 아직 적습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 발업 연구 완료! 저글링이 더 빨라졌습니다!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'control',
              altText: '{home} 선수 발업 저글링! 캐논 사이를 파고듭니다!',
            ),
            ScriptEvent(
              text: '2차 저글링 러시! 포지더블이 버틸 수 있을까요?',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
