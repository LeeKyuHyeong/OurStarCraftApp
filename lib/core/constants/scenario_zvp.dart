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
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home}, 히드라 편대가 프로토스 앞마당을 두드립니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 히드라 공격! 포토캐논이 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿과 포토캐논으로 막으려 하지만 히드라가 너무 많습니다!',
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
          baseProbability: 0.8,
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
              text: '{away} 선수 포토캐논 추가 건설! 히드라를 막아냅니다!',
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
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 하이 템플러가 나왔습니다! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 물량을 계속 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 히드라를 계속 뽑고 있습니다! 물량으로 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 히드라 편대에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -6, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 히드라가 녹아내립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라가 스톰에 큰 피해를 입었습니다!',
          owner: LogOwner.home,
          homeArmy: -3,
          altText: '{home}, 뭉쳐있던 히드라가 스톰에 증발합니다!',
        ),
        ScriptEvent(
          text: '스톰이 결정적입니다! 히드라 물량이 줄어들고 있어요!',
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
              awayArmy: -6, favorsStat: 'strategy',
              altText: '{home} 선수 플레이그! 프로토스 병력에 지속 피해!',
            ),
            ScriptEvent(
              text: '{home}, 울트라리스크까지 합류! 최종 병력 투입!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수 아콘으로 전환! 하지만 디파일러가 너무 강합니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '하이브 병력이 전장을 지배하기 시작합니다!',
              owner: LogOwner.system,
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
              awayArmy: 6, awayResource: -25,
              altText: '{away}, 프로토스 한방 병력이 완성됐습니다!',
            ),
            ScriptEvent(
              text: '{away}, 전진! 야금야금 교전하면서 저그 멀티를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 셔틀에 하이 템플러를 태워서 견제! 드론이 스톰에!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 셔틀 견제! 드론이 스톰에 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커로 입구를 막으려 하지만 옵저버에 보입니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '프로토스 한방 병력이 저그를 압박합니다!',
              owner: LogOwner.system,
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
          text: '{away} 선수 앞마당 넥서스와 포토캐논 건설!',
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
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 뮤탈 5기 완성! 견제 출발!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어와 스포어로 대비합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15,
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
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 물어뜯습니다! 커세어가 늦었어요!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤짤! 프로브가 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 뒤늦게 대응합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈을 빼면서 다른 곳을 노립니다! 기동력이 좋네요!',
              owner: LogOwner.home,
              favorsStat: 'control',
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
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 커세어 컨트롤! 뮤탈을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 2기를 잃었습니다! 견제 효과가 반감!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 커세어로 오버로드까지 사냥합니다! 완벽한 공중 장악!',
              owner: LogOwner.away,
              homeResource: -10, awayArmy: 2,
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
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 뮤탈에 히드라까지! 복합 편성입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러 합류! 스톰 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home}, 히드라 편대가 프로토스 앞마당을 공격합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 히드라 편대에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -10, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 명중! 히드라가 증발합니다!',
        ),
        ScriptEvent(
          text: '스톰과 히드라 물량의 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-70)
    // P 아콘+스톰 화력으로 Z 병력 소모 → decisive에서 winRate(~62%) 결정
    // 목표: 전체 60-65% 홈(저그) 승률
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 전 병력 총동원! 뮤탈 히드라 저글링!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 질럿 하이 템플러 총출동!',
          owner: LogOwner.away,
          awayArmy: 10, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전면전이 시작됩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 하이 템플러를 노립니다! 스톰을 막아야 합니다!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -8, favorsStat: 'control',
          altText: '{home} 선수 뮤탈로 하이 템플러 솎아내기! 핵심 유닛을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰 연속 투하! 저그 병력이 증발합니다!',
          owner: LogOwner.away,
          homeArmy: -8, favorsStat: 'strategy',
          altText: '{away} 선수 더블 스톰! 히드라가 녹아내립니다!',
        ),
        ScriptEvent(
          text: '{away}, 아콘 변환! 남은 하이 템플러가 아콘이 됩니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: -3, favorsStat: 'attack',
          altText: '{away} 선수 아콘! 저그 병력이 녹아내립니다!',
        ),
        ScriptEvent(
          text: '결정적인 순간입니다!',
          owner: LogOwner.system,
          decisive: true,
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
              awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 저글링 진입! 캐논이 아직 미완성!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 저글링이 너무 빠릅니다!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 프로브가 쓰러집니다! 저글링 속도를 못 따라가요!',
            ),
            ScriptEvent(
              text: '{home}, 본진까지 침투! 프로브가 줄어들고 있습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '저글링이 프로토스 일꾼을 파괴하고 있습니다!',
              owner: LogOwner.system,
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
              altText: '{away}, 포토캐논이 제때 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 피해가 큽니다! 캐논에 막히는데요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 질럿까지 나오면서 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '캐논 수비 성공! 저그가 자원이 뒤처집니다!',
              owner: LogOwner.system,
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
          homeArmy: 5, homeResource: -10,
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
          homeArmy: 3, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 저글링 서라운드! 질럿을 감쌉니다!',
        ),
        ScriptEvent(
          text: '{away}, 질럿의 화력으로 저글링을 잡아냅니다!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -1, favorsStat: 'control',
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
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 물량이 질럿을 압도합니다! 프로브를 향해 돌진!',
              owner: LogOwner.home,
              awayResource: -25, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 프로브 라인을 초토화!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 저글링이 너무 많습니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '저글링 물량이 프로토스를 압도합니다!',
              owner: LogOwner.system,
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
              homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 질럿 컨트롤! 저글링이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 전멸! 추가 생산할 자원도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '질럿이 저글링을 압도했습니다! 프로토스 유리!',
              owner: LogOwner.system,
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
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 스캐럽 명중! 드론 대학살!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈이 대응하러 가지만 늦었습니다!',
              owner: LogOwner.home,
              homeResource: -10,
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
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 스커지 자폭! 셔틀이 격추됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 셔틀이 격추됩니다! 리버가 땅에 고립!',
              owner: LogOwner.away,
              awayArmy: -2,
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
    // Phase 3: 결전 (lines 43-60)
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
          awayArmy: 6, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 결전 병력이 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 럴커 포진! 프로토스 병력을 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -8, homeArmy: -4, favorsStat: 'defense',
          altText: '{home} 선수 럴커가 드라군을 꿰뚫습니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 히드라 편대가 녹아내립니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: -5, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 히드라가 증발합니다!',
        ),
        ScriptEvent(
          text: '결정적인 순간입니다!',
          owner: LogOwner.system,
          decisive: true,
        ),
      ],
    ),
  ],
);
