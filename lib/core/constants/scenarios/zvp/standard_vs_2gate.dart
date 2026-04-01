part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. Z 스탠다드 vs 2게이트 질럿 (확장 - Z 트랜지션 분기 추가)
// ----------------------------------------------------------
const _zvpStandardVs2Gate = ScenarioScript(
  id: 'zvp_standard_vs_2gate',
  matchup: 'ZvP',
  homeBuildIds: [
    'zvp_12hatch', 'zvp_12pool', 'zvp_3hatch_nopool',
    'zvp_3hatch_hydra', 'zvp_2hatch_mutal',
    'zvp_trans_5hatch_hydra', 'zvp_trans_mutal_hydra',
    'zvp_trans_hydra_lurker',
  ],
  awayBuildIds: ['pvz_2gate_zealot'],
  description: 'Z 스탠다드 vs 전진 2게이트 질럿 압박',
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
          altText: '{home}, 앞마당 해처리! 자원을 챙기는 빌드!',
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
          altText: '{away}, 전진 파일런에 게이트웨이 2개! 공격적인 빌드입니다!',
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
        // 분기 A: 성큰과 저글링 방어 성공
        ScriptBranch(
          id: 'sunken_defense_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당에 성큰을 세웁니다! 드론도 동원!',
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
              homeArmy: 1, awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '성큰과 저글링 수비 성공! 전진 2게이트를 막았습니다!',
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
    // Phase 3: Z 트랜지션 분기 (lines 37-52)
    ScriptPhase(
      name: 'zerg_transition',
      startLine: 37,
      branches: [
        // 분기 A: 히드라 전환
        ScriptBranch(
          id: 'hydra_transition',
          conditionHomeBuildIds: [
            'zvp_3hatch_hydra', 'zvp_trans_5hatch_hydra',
            'zvp_trans_hydra_lurker',
          ],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라덴 건설! 히드라로 전환합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 히드라덴! 지상 전력을 강화합니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 질럿을 잡아냅니다! 사거리 차이!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 히드라 사거리! 질럿이 접근하기 어렵습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 2게이트 질럿만으로는 히드라를 상대할 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '히드라가 합류하면서 전세가 역전됩니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 뮤탈 전환
        ScriptBranch(
          id: 'mutal_transition',
          conditionHomeBuildIds: ['zvp_2hatch_mutal', 'zvp_trans_mutal_hydra'],
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어에서 스파이어를 올립니다! 뮤탈리스크를 택했습니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스파이어! 뮤탈리스크로 전환!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈리스크가 프로토스 본진을 견제합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 견제! 프로브를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 앞마당에 묶여 있어서 본진 수비가 어렵습니다!',
              owner: LogOwner.away,
              awayResource: -5,
            ),
            ScriptEvent(
              text: '뮤탈 견제가 프로토스 본진을 흔들고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 방어 성공 후 역공 (폴백)
        ScriptBranch(
          id: 'zerg_counterattack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 저글링으로 역공! 프로토스 본진을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'attack',
              altText: '{home}, 저글링 역공! 프로토스가 투자한 게 너무 많습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 유닛이 없습니다! 프로브가 위험!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 본진이 비었습니다! 질럿이 전부 앞마당에!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 프로브를 쓸어버립니다!',
              owner: LogOwner.home,
              awayResource: -5, homeArmy: -1, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '2게이트를 막고 역공까지! 저그가 유리합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 D: 질럿 피해 후 소모전 (폴백)
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
              text: '{home} 선수 저글링과 성큰으로 간신히 버팁니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 테크를 올리기 시작합니다! 버틸 수 있을까요?',
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
