part of 'scenario_scripts.dart';

// ============================================================
// ZvZ 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

// ----------------------------------------------------------
// 1. 9풀 vs 9오버풀 (가장 대표적인 ZvZ)
// ----------------------------------------------------------
const _zvz9poolVs9overpool = ScenarioScript(
  id: 'zvz_9pool_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9풀 vs 9오버풀 저글링 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀입니다! 저글링을 빨리 뽑으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 오버로드 먼저! 이후에 풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9오버풀! 드론 한 기의 이점을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산 시작! 발업도 연구합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링이 나옵니다! 발업까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산! 발업 연구 시작!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
        ),
      ],
    ),
    // Phase 1: 저글링 교전 (lines 15-24)
    ScriptPhase(
      name: 'ling_battle',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 먼저 상대 진영으로 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 먼저 공격하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 언덕과 좁은 입구를 이용해서 수비합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'defense',
          altText: '{away}, 입구에서 수비! 저글링 두 마리씩 상대하는 형태!',
        ),
        ScriptEvent(
          text: '저글링 vs 저글링! ZvZ의 핵심 교전입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 저글링 교전 결과 - 분기 (lines 25-38)
    ScriptPhase(
      name: 'ling_result',
      startLine: 25,
      branches: [
        // 분기 A: 9풀 공격 성공
        ScriptBranch(
          id: 'attacker_breaks_through',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 입구를 뚫었습니다! 드론까지 노립니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 큽니다! 저글링이 부족해요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 상대 드론을 초토화!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '9풀 공격이 성공적! 드론 차이가 결정적!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9오버풀 수비 성공 → 경제 우위
        ScriptBranch(
          id: 'defender_holds',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 언덕에서 저글링을 효과적으로 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 저글링 컨트롤! 좁은 입구에서 잘 막습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 손실이 크네요! 뚫지 못 했습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 드론 한 기 차이가 벌어지기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 15,
              altText: '{away} 선수 드론 한 기 차이! 중반으로 갈수록 벌어집니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 9오버풀의 드론 이점이 빛나는 순간!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 39-52)
    ScriptPhase(
      name: 'spire_race',
      startLine: 39,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링 생산을 줄이고 스파이어를 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스파이어 건설! 위험한 타이밍인데요!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 해처리를 올리면서 성큰을 깔아놓습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 성큰으로 수비하면서 자원을 가져갑니다!',
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 서로에게 가장 위험한 타이밍입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰 콜로니를 본진에 깔면서 수비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 스파이어를 올립니다! 뮤탈 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 건설! 뮤탈 타이밍 경쟁이 시작됩니다!',
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 53-68)
    ScriptPhase(
      name: 'mutal_battle',
      startLine: 53,
      branches: [
        // 분기 A: 뮤탈 먼저 낸 쪽이 드론 견제
        ScriptBranch(
          id: 'fast_mutal_harass',
          conditionStat: 'harass',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈리스크가 먼저 나왔습니다! 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 건설! 뮤탈 피해를 최소화하려 합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 스포어 올립니다! 뮤탈 견제를 막으려 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 스포어를 피하면서 드론을 계속 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
              altText: '{home} 선수 뮤탈이 스포어를 회피하면서 견제합니다!',
            ),
            ScriptEvent(
              text: '뮤탈 선점이 빛나고 있습니다! 드론 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 뮤탈 늦은 쪽이 스커지로 대응
        ScriptBranch(
          id: 'scourge_defense',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스커지를 뽑으면서 뮤탈에 대비합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 스커지 생산! 뮤탈을 잡으려 합니다!',
            ),
            ScriptEvent(
              text: '{away}, 스커지 자폭! 뮤탈 2기를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 스커지가 뮤탈에 돌진! 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈을 잃었습니다! 스커지가 효과적!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home}, 뮤탈 손실! 스커지에 당했습니다!',
            ),
            ScriptEvent(
              text: '스커지 대응이 빛났습니다! 뮤탈 수 차이를 줄였어요!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 69-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 69,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈 편대 총출동! 상대 본진을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 뮤탈 스커지로 맞섭니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -20,
        ),
        ScriptEvent(
          text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
          owner: LogOwner.home,
          awayArmy: -10, homeArmy: -5, favorsStat: 'control',
          altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
        ),
        ScriptEvent(
          text: '{away}, 스커지 자폭! 뮤탈이 동시에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -8, awayArmy: -6, favorsStat: 'control',
          altText: '{away} 선수 스커지가 뮤탈을 동반 추락시킵니다!',
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
// 2. 12앞마당 vs 9풀 (수비형 vs 공격형)
// ----------------------------------------------------------
const _zvz12hatchVs9pool = ScenarioScript(
  id: 'zvz_12hatch_vs_9pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch', 'zvz_12pool'],
  awayBuildIds: ['zvz_9pool', 'zvz_9overpool'],
  description: '12앞마당 수비 vs 9풀 공격',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 12드론에 앞마당 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 12앞마당! 경제를 가져가겠다는 배짱 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀 건설! 공격적입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀! 빠른 저글링으로 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 뒤늦게 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 발업 저글링 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링 나옵니다! 발업까지!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 15-20)
    ScriptPhase(
      name: 'ling_attack',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 발업 저글링이 상대 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
          altText: '{away} 선수 저글링 돌진! 12앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 노발업 저글링+드론+성큰으로 수비합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15, favorsStat: 'defense',
          altText: '{home}, 성큰을 올리면서 드론도 같이 막습니다!',
        ),
        ScriptEvent(
          text: '12앞마당을 지킬 수 있을까요? 결정적인 순간입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 앞마당 수비 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'hatch_defense',
      startLine: 21,
      branches: [
        // 분기 A: 앞마당 파괴
        ScriptBranch(
          id: 'hatch_destroyed',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 드론을 뚫습니다! 앞마당 해처리를 공격!',
              owner: LogOwner.away,
              homeResource: -25, homeArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리가 부서지고 있습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 앞마당이 무너집니다! 경제 손실이 크네요!',
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링 합류! 드론까지 초토화!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '앞마당이 파괴됐습니다! 9풀 공격 성공!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 수비 성공
        ScriptBranch(
          id: 'defense_success',
          conditionStat: 'defense',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 성큰이 완성됩니다! 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'defense',
              altText: '{home} 선수 성큰 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 성큰에 막힙니다! 피해만 누적!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 드론으로 협공! 완벽한 수비!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '수비 성공! 앞마당이 살았습니다! 경제 우위 확보!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 뮤탈 경쟁 (lines 37-52)
    ScriptPhase(
      name: 'mutal_race',
      startLine: 37,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 스파이어 건설 서두릅니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어를 빠르게 올립니다! 뮤탈 선점!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 경제를 돌리면서 스포어를 설치합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포어 건설! 뮤탈에 대비합니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 먼저 나옵니다! 소수라도 강합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away} 선수 뮤탈 선점! 드론을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포어로 버티면서 뮤탈을 기다립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
        ),
        ScriptEvent(
          text: '뮤탈 타이밍 경쟁이 승부를 가르고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 53-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈이 완성됩니다! 스커지도 섞습니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
          altText: '{home}, 뮤탈+스커지! 반격 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈로 드론을 계속 견제합니다!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '뮤탈 편대가 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 스커지 자폭! 상대 뮤탈을 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -8, homeArmy: -4, favorsStat: 'control',
          altText: '{home} 선수 스커지가 뮤탈에 돌진! 격추합니다!',
        ),
        ScriptEvent(
          text: '{away}, 남은 뮤탈로 드론을 노립니다! 최후의 견제!',
          owner: LogOwner.away,
          homeResource: -15, awayArmy: -5, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈 최후의 기동! 드론을 끝까지 노립니다!',
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
// 3. 4풀 vs 12앞마당 (극초반 올인)
// ----------------------------------------------------------
const _zvz4poolVs12hatch = ScenarioScript(
  id: 'zvz_4pool_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_12hatch', 'zvz_12pool'],
  description: '4풀 극초반 올인 vs 12앞마당',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 정말 빠른 스포닝풀입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
          altText: '{home}, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 해처리를 건설하는 중입니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 상대 앞마당에 도착합니다! 스포닝풀이 없어요!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 상대는 아직 풀도 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 없습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
        ),
        ScriptEvent(
          text: '4풀 올인! 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-28)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        ScriptBranch(
          id: 'pool_crushes',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 파괴!',
              owner: LogOwner.home,
              awayResource: -30, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 모든 걸 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 전멸하고 있습니다! 막을 수가 없어요!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '4풀이 앞마당을 초토화! 저그 올인 성공!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'drone_defense',
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전합니다! 드론 컨트롤!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 완성됩니다! 저글링으로 반격!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀이 막혔습니다! 드론 수 차이로 12앞 유리!',
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
// 4. 노풀 3해처리 미러 (후반 대결)
// ----------------------------------------------------------
const _zvz3hatchMirror = ScenarioScript(
  id: 'zvz_3hatch_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_3hatch_nopool', 'zvz_12hatch'],
  awayBuildIds: ['zvz_3hatch_nopool', 'zvz_12hatch'],
  description: '노풀 3해처리 미러 후반 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 계속 뽑습니다. 경제 우선!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 해처리 건설!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 3번째 해처리까지! 경제가 폭발합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 3해처리 체제! 드론이 쏟아져 나옵니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 저글링 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수도 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 모두 경제를 극대화하는 모습입니다. 후반전이 기대되네요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 수비 빌드업 (lines 17-28)
    ScriptPhase(
      name: 'defensive_buildup',
      startLine: 17,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 성큰 콜로니를 앞마당에 깔아놓습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 수비 건물 건설! 안정적인 운영!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 레어 올리면서 스파이어 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 레어! 뮤탈 경쟁이 시작됩니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 모두 후반을 준비하는 고요한 시간이 이어집니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 뮤탈 교전 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'mutal_clash',
      startLine: 29,
      branches: [
        ScriptBranch(
          id: 'mutal_control_diff',
          conditionStat: 'control',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈 편대 컨트롤이 좋습니다! 상대 뮤탈을 낚습니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤 차이! 상대 뮤탈을 격파!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 손실! 드론 견제도 어려워집니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이가 경기를 가르고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'mutal_stalemate',
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 뮤탈이 비슷한 수! 소모전이 시작됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 스커지를 섞으면서 뮤탈 수를 줄이려 합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -3, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home} 선수도 스커지로 대응! 공중에서 치열한 전투!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '뮤탈 소모전! 누가 더 효율적으로 교환할 수 있을까요?',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
