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
          altText: '{home}, 9풀! 스포닝풀부터 올려 저글링을 빨리 뽑으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 오버로드 먼저! 이후에 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9오버풀 스포닝풀! 드론 한 기의 이점을 노립니다!',
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
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 9오버풀 수비 성공 → 자원 우위
        ScriptBranch(
          id: 'defender_holds',
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
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈리스크가 먼저 나왔습니다! 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 건설! 뮤탈 피해를 최소화하려 합니다!',
              owner: LogOwner.away,
              awayArmy: 1, awayResource: -10,
              altText: '{away}, 스포어 올립니다! 뮤탈 견제를 막으려 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 스포어를 피하면서 드론을 계속 노립니다!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'control',
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
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 스커지가 뮤탈에 돌진! 격추합니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 나옵니다! 이제 반격할 차례!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -15,
              altText: '{away} 선수 뮤탈 합류! 공세 전환!',
            ),
            ScriptEvent(
              text: '스커지 대응이 빛났습니다! 뮤탈 수 차이를 역전시켰어요!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 - 분기 (lines 69-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 69,
      branches: [
        // 분기 A: 9풀(홈) 뮤탈 결전 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -5, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9오버풀(어웨이) 뮤탈 결전 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 스커지 자폭! 뮤탈을 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 스커지 자폭! 뮤탈을 동반 격추!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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
          altText: '{home}, 12앞마당! 확장을 가져가겠다는 배짱 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀 건설! 공격적입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀! 스포닝풀 올리고 빠른 저글링으로 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 뒤늦게 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 발업 저글링 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
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
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 저글링 돌진! 12앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 노발업 저글링+드론+성큰으로 수비합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -15, favorsStat: 'defense',
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
        // 분기 A: 앞마당 파괴 (9풀 공격 성공)
        ScriptBranch(
          id: 'hatch_destroyed',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 드론을 뚫습니다! 앞마당 해처리를 공격!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리가 부서지고 있습니다!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 앞마당이 무너집니다! 자원 손실이 크네요!',
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링 합류! 드론까지 물어뜯습니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '앞마당이 큰 피해를 입었습니다! 9풀 공격 성공!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 수비 성공
        ScriptBranch(
          id: 'defense_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 성큰이 완성됩니다! 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'defense',
              altText: '{home} 선수 성큰 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 성큰에 막힙니다! 피해만 누적!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드론으로 협공! 수비 성공!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '수비 성공! 앞마당이 살았습니다!',
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
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 스파이어 건설 서두릅니다!',
          owner: LogOwner.away,
          awayResource: -25, awayArmy: 2,
          altText: '{away}, 스파이어를 빠르게 올립니다! 뮤탈 선점!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당을 재건하면서 스포어를 설치합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 스포어 건설! 뮤탈에 대비합니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 먼저 나옵니다! 소수라도 강합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수 뮤탈 선점! 드론을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로 드론을 견제합니다! 빠른 뮤탈의 힘!',
          owner: LogOwner.away,
          homeResource: -10, favorsStat: 'harass',
          altText: '{away}, 뮤탈 견제! 드론을 물어뜯습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포어로 버티면서 뮤탈을 기다립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '뮤탈 타이밍 경쟁이 승부를 가르고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 53-68)
    // 9풀이 뮤탈 선점으로 견제, 12앞은 자원으로 버팀
    // 목표: 전체 35-42% 홈(12앞) 승률
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 12앞(홈)이 자원 우위로 뮤탈 물량 역전
        ScriptBranch(
          id: 'home_macro_comeback',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 드디어 합류합니다! 물량이 늘어나고 있어요!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 자원 덕분에 뮤탈 수를 따라잡습니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'macro',
              altText: '{home} 선수 자원 우위! 뮤탈 물량으로 역전합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 반격! 상대 드론을 견제합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '12앞마당의 자원이 빛나는 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀(어웨이)이 뮤탈 선점 유지
        ScriptBranch(
          id: 'away_mutal_dominance',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 공중전을 압도합니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 수 우세! 공중전 승리!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 드론을 계속 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -3, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제 이어갑니다! 드론이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지로 뮤탈을 잡으려 하지만 수가 부족합니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '뮤탈 타이밍 차이가 승부를 가르고 있습니다!',
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
          homeArmy: 4, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 해처리를 건설하는 중입니다.',
          owner: LogOwner.away,
          awayResource: -20, awayArmy: 3,
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
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 상대는 아직 풀도 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 없습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
        ),
        ScriptEvent(
          text: '4풀 올인! 막을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-28)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀 올인 성공 (12앞은 풀이 늦어서 방어 어려움)
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 파괴!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 모든 걸 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 전멸하고 있습니다! 막을 수가 없어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '4풀이 앞마당을 초토화! 저그 올인 성공!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 수비
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전합니다! 드론 컨트롤!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당하고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 완성됩니다! 저글링으로 반격!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '4풀이 막혔습니다! 드론 수 차이로 12앞 유리!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 (lines 29-52)
    // 4풀 실패 시 중반에서 밀리는 구조
    // 목표: 전체 50-65% 홈(4풀) 승률
    ScriptPhase(
      name: 'aftermath',
      startLine: 29,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드론을 보충하면서 자원을 회복합니다.',
          owner: LogOwner.away,
          awayResource: 20, awayArmy: 8,
        ),
        ScriptEvent(
          text: '{home} 선수 드론이 적습니다. 자원 격차가 벌어지고 있어요.',
          owner: LogOwner.home,
          homeArmy: -8, homeResource: -15,
          altText: '{home}, 4풀의 대가! 드론이 너무 적습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 물량이 나오기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 10, awayResource: -15,
        ),
        ScriptEvent(
          text: '{away}, 저글링 물량으로 반격합니다! 4풀 선수가 밀립니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: 5, favorsStat: 'macro',
          altText: '{away} 선수 물량 역전! 물량의 차이가 드러납니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진 드론까지 뽑아서 저항하지만 부족합니다.',
          owner: LogOwner.home,
          homeArmy: -8, homeResource: -10,
          altText: '{home}, 자원이 바닥입니다! 저글링을 뽑을 수가 없어요!',
          skipChance: 0.30,
        ),
        ScriptEvent(
          text: '{away}, 저글링이 상대 본진으로 진격합니다! 반격!',
          owner: LogOwner.away,
          homeArmy: -8, favorsStat: 'attack',
          altText: '{away} 선수 반격 시작! 4풀의 빈 본진을 노립니다!',
          skipChance: 0.30,
        ),
      ],
    ),
    // Phase 4: 최종 결전 - 분기 (lines 53-60)
    ScriptPhase(
      name: 'final_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_last_stand',
          baseProbability: 0.3,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 남은 저글링으로 마지막 돌진! 상대 드론을 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀의 마지막 공격이 상대 자원줄을 끊었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_overwhelms',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away}, 물량으로 밀어붙입니다! 4풀 선수가 버틸 수 없습니다!',
              owner: LogOwner.away,
              homeArmy: -10, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '4풀 올인 실패의 대가! 자원 차이가 돌이킬 수 없습니다!',
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
          text: '{home} 선수 드론을 계속 뽑습니다. 자원 우선!',
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
          text: '{home} 선수 3번째 해처리까지! 자원이 폭발합니다.',
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
          text: '양쪽 모두 자원을 극대화하는 모습입니다. 후반전이 기대되네요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 수비 빌드업 (lines 17-28)
    ScriptPhase(
      name: 'defensive_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
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
        // 분기 A: 홈이 뮤탈 컨트롤 우위
        ScriptBranch(
          id: 'home_mutal_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈 편대 컨트롤이 좋습니다! 상대 뮤탈을 낚습니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤 차이! 상대 뮤탈을 격파!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 손실! 스커지로 대응합니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이가 경기를 가르고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이가 뮤탈 컨트롤 우위
        ScriptBranch(
          id: 'away_mutal_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 편대 컨트롤이 좋습니다! 상대 뮤탈을 낚습니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤 차이! 상대 뮤탈을 격파!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 손실! 스커지로 대응합니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이가 경기를 가르고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 결전 - 분기 (lines 45-60)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 45,
      branches: [
        // 분기 A: 홈 뮤탈 결전 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 3해처리 미러 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -5, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 결전 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 3해처리 미러 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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
// 5. 4풀 vs 9풀/9오버풀 (치즈 vs 공격적)
// ----------------------------------------------------------
const _zvz4poolVs9pool = ScenarioScript(
  id: 'zvz_4pool_vs_9pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_9pool', 'zvz_9overpool'],
  description: '4풀 치즈 vs 9풀 공격적 빌드',
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
          altText: '{home}, 4풀! 극초반 스포닝풀 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 뽑으면서 9드론에 풀을 올리려 합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 빠르게 나옵니다! 상대로 출발!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다! 스포닝풀 완성되기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀 건설! 저글링이 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀 스포닝풀! 하지만 4풀 저글링이 먼저 도착할 수 있습니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 상대 진영에 도착! 풀이 막 완성됩니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 상대 저글링은 아직 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 일단 막으면서 저글링 생산을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 vs 9풀! 저글링 타이밍 차이가 관건입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 초반 교전 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀이 드론 피해를 줌
        // 분기 A: 4풀이 큰 피해를 줌
        ScriptBranch(
          id: 'pool_damages',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 피해가 큽니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실! 하지만 저글링이 나오기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 저글링이 합류하면서 4풀 저글링을 막아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 저글링 합류! 겨우 막아냅니다!',
            ),
            ScriptEvent(
              text: '드론 피해가 컸습니다! 4풀의 시간을 벌었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 9풀이 빠르게 저글링으로 대응
        ScriptBranch(
          id: 'quick_ling_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 빠르게 나옵니다! 드론과 함께 방어!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 3, favorsStat: 'control',
              altText: '{away} 선수 저글링+드론 협공! 4풀을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 녹고 있습니다! 수가 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 발업 연구까지! 저글링 교전에서 우위를 점합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '9풀의 빠른 대응! 4풀이 제대로 먹히지 않았습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 저글링 발업 싸움 (lines 31-44)
    // 4풀 실패 시 중반에서 점진적으로 밀림
    // 목표: 전체 55-60% 홈(4풀) 승률
    ScriptPhase(
      name: 'ling_upgrade_battle',
      startLine: 31,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 발업 저글링으로 반격 준비! 병력 차이가 나기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 발업 완료! 저글링 물량이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론이 너무 적습니다. 저글링만 뽑고 있어요.',
          owner: LogOwner.home,
          homeArmy: -2, homeResource: -10,
          altText: '{home}, 4풀의 대가! 자원이 부족합니다!',
        ),
        ScriptEvent(
          text: '{away}, 발업 저글링이 상대 진영으로 진격합니다!',
          owner: LogOwner.away,
          homeArmy: -2, awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 반격 시작! 4풀의 빈 본진을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진 드론까지 동원하지만 역부족입니다.',
          owner: LogOwner.home,
          homeArmy: -2, homeResource: -10,
          skipChance: 0.40,
        ),
        ScriptEvent(
          text: '{away}, 저글링 물량으로 압도합니다! 4풀 선수가 밀립니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'macro',
          altText: '{away} 선수 물량 역전! 자원 차이가 드러납니다!',
          skipChance: 0.40,
        ),
      ],
    ),
    // Phase 4: 최종 결전 - 분기 (lines 45-52)
    ScriptPhase(
      name: 'final_result',
      startLine: 45,
      branches: [
        ScriptBranch(
          id: 'home_desperate_attack',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 남은 저글링을 모아서 필사의 공격! 드론을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀의 끈질긴 압박이 결실을 맺습니다! 9풀이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_overwhelms',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 발업 저글링이 본진을 덮칩니다! 물량 차이!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '4풀이 9풀을 상대로는 타이밍이 빠듯합니다! 자원 격차!',
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
// 6. 4풀 vs 3해처리 (치즈 vs 극매크로)
// ----------------------------------------------------------
const _zvz4poolVs3hatch = ScenarioScript(
  id: 'zvz_4pool_vs_3hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '4풀 치즈 vs 노풀 3해처리',
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
          altText: '{home}, 4풀! 극초반 스포닝풀 러시입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑습니다. 앞마당을 노리는 모습!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 빠르게 출발합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리 건설! 스포닝풀은 아직 없습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 3해처리! 풀이 없는 상태입니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 도착합니다! 상대는 풀도 없고 저글링도 없습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 3해처리 상대에게 풀이 없어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아야 합니다! 풀이 너무 늦습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '4풀 vs 노풀 3해처리! 드론으로 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 4풀 대성공 (3해처리는 풀이 매우 늦어서 4풀에 특히 약함)
        ScriptBranch(
          id: 'pool_crushes',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당도 공격!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 드론을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠르게 줄어듭니다! 풀이 아직 멀었어요!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 3해처리의 빈 진영을 파괴!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀이 노풀 3해처리를 초토화! 올인 대성공!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 드론 컨트롤로 버팀
        ScriptBranch(
          id: 'drone_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론을 뭉쳐서 저글링과 교전! 필사적인 수비!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 드론 컨트롤! 저글링을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드론에 당합니다! 수가 줄어요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 스포닝풀이 뒤늦게 완성됩니다! 저글링 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -10, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '드론 피해는 컸지만 4풀을 막아냈습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 (lines 31-52)
    // 4풀 실패 시 3해처리의 자원 확보가 압도
    // 목표: 전체 65-72% 홈(4풀) 승률 (3해처리는 풀이 가장 늦음)
    ScriptPhase(
      name: 'aftermath',
      startLine: 31,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드론을 보충합니다. 해처리가 살아남아서 자원이 나옵니다.',
          owner: LogOwner.away,
          awayResource: 15, awayArmy: 4,
        ),
        ScriptEvent(
          text: '{home} 선수 드론이 거의 없습니다. 자원 격차가 심합니다.',
          owner: LogOwner.home,
          homeArmy: -4, homeResource: -15,
          altText: '{home}, 4풀의 대가! 드론이 바닥입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당+본진에서 드론이 쏟아집니다! 물량 차이!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15,
          altText: '{away}, 3해처리의 자원! 저글링이 물밀듯이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away}, 저글링 물량으로 반격! 4풀 선수가 밀립니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: 2, favorsStat: 'macro',
          altText: '{away} 선수 물량 역전! 3해처리의 자원이 빛납니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진 드론까지 뽑아서 저항하지만 부족합니다.',
          owner: LogOwner.home,
          homeArmy: -4, homeResource: -10,
          altText: '{home}, 자원이 바닥! 더 이상 저글링을 뽑을 수 없어요!',
          skipChance: 0.40,
        ),
        ScriptEvent(
          text: '{away}, 저글링이 상대 본진으로 진격! 3해처리의 힘!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'attack',
          altText: '{away} 선수 반격! 4풀의 빈 본진을 짓밟습니다!',
          skipChance: 0.40,
        ),
      ],
    ),
    // Phase 4: 최종 결전 - 분기 (lines 53-60)
    ScriptPhase(
      name: 'final_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_last_push',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home}, 마지막 저글링으로 상대 드론 라인을 급습합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀의 집요한 러시가 3해처리의 자원줄을 끊었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_overwhelms',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 3해처리의 물량이 쏟아집니다! 4풀이 버틸 수 없어요!',
              owner: LogOwner.away,
              homeArmy: -8, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '4풀 올인이 3해처리를 못 잡으면 자원 차이가 압도적!',
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
// 7. 9풀/9오버풀 미러 (공격적 미러)
// ----------------------------------------------------------
const _zvz9poolMirror = ScenarioScript(
  id: 'zvz_9pool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool', 'zvz_9overpool'],
  awayBuildIds: ['zvz_9pool', 'zvz_9overpool'],
  description: '9풀/9오버풀 미러 저글링 대결',
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
          altText: '{home}, 9풀 스포닝풀! 저글링 싸움 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 9드론에 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀 스포닝풀! 양쪽 다 공격적입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링+발업! 손싸움 준비 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산! 발업도 함께!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링+발업! 동시 타이밍!',
        ),
      ],
    ),
    // Phase 1: 저글링 교전 (lines 15-24)
    ScriptPhase(
      name: 'ling_battle',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 센터에서 마주칩니다! 발업 타이밍이 같아요!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
          altText: '{home} 선수 저글링 교전! 발업 타이밍 경쟁!',
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링을 돌진시킵니다! 수 싸움!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'control',
          altText: '{away}, 저글링 맞대결! 컨트롤이 승부를 가릅니다!',
        ),
        ScriptEvent(
          text: '양측 저글링이 맞붙습니다! 컨트롤 싸움!',
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
        // 분기 A: 홈 저글링 컨트롤 우위
        ScriptBranch(
          id: 'home_ling_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 컨트롤이 좋습니다! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 저글링 컨트롤 차이! 상대를 압도합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 손실! 입구에서 막아야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 상대 진영으로 진격! 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이! 한쪽이 밀리기 시작합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 저글링 컨트롤 우위
        ScriptBranch(
          id: 'away_ling_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링 컨트롤이 좋습니다! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 저글링 컨트롤 차이! 상대를 압도합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 손실! 입구에서 막아야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 상대 진영으로 진격! 드론을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -10, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이! 한쪽이 밀리기 시작합니다!',
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
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 줄이고 스파이어를 올리려 합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스파이어 건설! 위험한 타이밍!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 성큰을 깔아놓습니다!',
          owner: LogOwner.away,
          awayResource: -30, awayArmy: 2,
          altText: '{away}, 앞마당 선택! 성큰으로 수비하면서 확장!',
        ),
        ScriptEvent(
          text: '스파이어를 가려는 쪽은 저글링을 아끼며 수비! 앞마당을 가려는 쪽은 자원을 확보!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 본진에 깔면서 저글링 공격에 대비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 레어를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 건설! 뮤탈 경쟁 시작!',
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 53-68)
    ScriptPhase(
      name: 'mutal_battle',
      startLine: 53,
      branches: [
        // 분기 A: 홈 뮤탈 견제 성공
        ScriptBranch(
          id: 'home_mutal_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 먼저 나왔습니다! 상대 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어를 올리면서 스커지를 뽑습니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 스포어+스커지로 수비! 뮤탈을 잡으려 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 스포어를 피하면서 견제합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 스포어를 회피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 선점! 드론 피해를 최소화할 수 있느냐가 관건!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 견제 성공
        ScriptBranch(
          id: 'away_mutal_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈이 먼저 나왔습니다! 상대 드론을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 선점! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스포어를 올리면서 스커지를 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -10, favorsStat: 'defense',
              altText: '{home}, 스포어+스커지로 수비! 뮤탈을 잡으려 합니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 스포어를 피하면서 견제합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 스포어를 회피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 선점! 드론 피해를 최소화할 수 있느냐가 관건!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 - 분기 (lines 69-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 69,
      branches: [
        // 분기 A: 홈 뮤탈 결전 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 미러 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -5, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 격파!',
            ),
            ScriptEvent(
              text: '{home}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 결전 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 미러 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 상대 뮤탈을 격파!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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
// 8. 12풀/12앞 vs 3해처리 (스탠다드 vs 매크로)
// ----------------------------------------------------------
const _zvz12poolVs3hatch = ScenarioScript(
  id: 'zvz_12pool_vs_3hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12pool', 'zvz_12hatch'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '12풀/12앞 스탠다드 vs 노풀 3해처리',
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
          text: '{home} 선수 12드론에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 12풀 스포닝풀! 스탠다드한 오프닝입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다! 풀 없이!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 앞마당! 자원을 극대화합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링+발업! 앞마당을 노릴 수 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다. 풀이 아직 없어요.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
      ],
    ),
    // Phase 1: 저글링 압박 (lines 15-24)
    ScriptPhase(
      name: 'ling_pressure',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 상대 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 3해처리 상대에게 풀이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막으면서 스포닝풀 건설을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'control',
          altText: '{away}, 드론으로 버팁니다! 풀이 곧 완성됩니다!',
        ),
        ScriptEvent(
          text: '12풀의 저글링이 3해처리를 얼마나 괴롭힐 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 저글링이 드론 피해를 줌
        ScriptBranch(
          id: 'ling_destroys_drones',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당 드론이 녹습니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 심각합니다! 풀이 너무 늦었어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 앞마당 해처리까지 위협!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '12풀 저글링이 3해처리의 약점을 정확히 찔렀습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 3해처리가 수비 성공
        ScriptBranch(
          id: 'macro_defense_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론 컨트롤로 저글링을 막아냅니다! 풀도 완성!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 3, favorsStat: 'control',
              altText: '{away} 선수 드론+저글링 합류! 수비 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 제거당합니다! 피해가 적었어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 앞마당 드론이 살아남으면서 자원 우위 확보!',
              owner: LogOwner.away,
              awayResource: 15,
              altText: '{away} 선수 3해처리의 자원! 드론 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 3해처리의 자원 이점이 살아있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 41-54)
    ScriptPhase(
      name: 'spire_race',
      startLine: 41,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어를 올리면서 스파이어를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스파이어 건설! 뮤탈을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 깔면서 앞마당을 안정시킵니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 성큰 건설! 저글링 공격에 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어를 올립니다! 뮤탈 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 가장 위험한 타이밍입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 본진에 깔면서 수비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'mutal_battle',
      startLine: 55,
      branches: [
        // 분기 A: 뮤탈 견제로 드론 차이 벌림
        ScriptBranch(
          id: 'mutal_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 먼저 나왔습니다! 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 3해처리의 드론을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어를 올리면서 스커지로 대응합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 스포어를 피하며 견제하지만 3해처리의 자원이 풍부합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '뮤탈 견제와 자원 차이의 싸움! 누가 유리할까요?',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 3해처리가 뮤탈 물량으로 압도
        ScriptBranch(
          id: 'macro_mutal_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈이 쏟아집니다! 3해처리의 자원이 빛나는 순간!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20, favorsStat: 'macro',
              altText: '{away} 선수 뮤탈 물량! 자원 차이가 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 수에서 밀립니다! 스커지를 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 드론을 견제합니다! 자원 격차가 더 벌어집니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '3해처리의 풍부한 자원이 뮤탈 물량으로 전환되고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 71-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈+스커지를 모아서 결전을 걸어봅니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈 편대로 맞섭니다! 물량이 우세합니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -25,
        ),
        ScriptEvent(
          text: '뮤탈 편대 충돌! 물량 vs 컨트롤!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 스커지로 뮤탈을 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -4, favorsStat: 'control',
          altText: '{home} 선수 스커지 자폭! 뮤탈을 잡습니다!',
        ),
        ScriptEvent(
          text: '{away}, 남은 뮤탈로 드론을 견제합니다! 자원 차이!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -3, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 남은 뮤탈로 압박! 자원 차이가 드러납니다!',
        ),
      ],
    ),
    // Phase 6: 최종 결과 - 분기 (lines 86-95)
    ScriptPhase(
      name: 'final_result',
      startLine: 86,
      branches: [
        ScriptBranch(
          id: 'home_scourge_wins',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 스커지 컨트롤로 뮤탈 편대를 격파합니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '스커지 컨트롤이 뮤탈 물량을 압도했습니다! 12풀의 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mutal_overwhelm',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 물량이 스커지를 흡수하고 남습니다! 드론 견제!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '뮤탈 물량과 자원 차이가 결정적! 3해처리의 승리!',
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
// 9. 9오버풀 미러 (준스탠다드 미러)
// ----------------------------------------------------------
const _zvz9overpoolMirror = ScenarioScript(
  id: 'zvz_9overpool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9오버풀 미러 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 모읍니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 9드론에 오버로드 먼저! 이후 스포닝풀!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9오버풀! 오버로드를 먼저 올리고 스포닝풀을 짓습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 9오버풀! 같은 빌드입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9오버풀 스포닝풀! 미러 매치! 드론 수가 동일합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산과 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링과 발업! 완전한 대칭!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
        ),
        ScriptEvent(
          text: '9오버풀 미러! 드론 수까지 같은 완벽한 대칭 매치입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 앞마당 선택 타이밍 (lines 17-28)
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 모으면서 앞마당 건설 타이밍을 보고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'strategy',
          altText: '{home}, 저글링을 뭉칩니다! 앞마당을 올릴까?',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당을 올리려 하지만 저글링이 걱정입니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10, favorsStat: 'strategy',
          altText: '{away}, 앞마당 타이밍을 노립니다! 저글링 견제가 두렵습니다!',
        ),
        ScriptEvent(
          text: 'ZvZ에서 앞마당을 올리는 순간이 가장 위험한 타이밍이죠!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다! 성큰도 같이!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 앞마당! 성큰을 깔면서 확장합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 건설! 서로 확장하는 모습입니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 앞마당! 양쪽 다 확장에 들어갑니다!',
        ),
      ],
    ),
    // Phase 2: 저글링 견제 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 29,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      branches: [
        // 분기 A: 홈이 저글링 견제 성공
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 저글링 견제! 앞마당 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰이 아직 완성되지 않았습니다! 드론으로 막습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 드론 2기를 잡고 빠집니다! 약간의 이득!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'control',
              altText: '{home} 선수 깔끔한 견제! 드론 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '소소한 견제 성공! 미러에서는 이 작은 차이가 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이가 저글링 견제 성공
        ScriptBranch(
          id: 'away_ling_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전!',
              owner: LogOwner.away,
              homeResource: -10, homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 저글링 견제! 앞마당 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 성큰이 아직 완성되지 않았습니다! 드론으로 막습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 드론 2기를 잡고 빠집니다! 약간의 이득!',
              owner: LogOwner.away,
              homeResource: -5, favorsStat: 'control',
              altText: '{away} 선수 깔끔한 견제! 드론 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '소소한 견제 성공! 미러에서는 이 작은 차이가 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 43-54)
    ScriptPhase(
      name: 'spire_race',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어+스파이어! 뮤탈 타이밍 경쟁!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어를 올립니다! 스파이어 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 레어+스파이어! 뮤탈을 누가 먼저 뽑을까요?',
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 서로에게 가장 위험합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 추가하면서 저글링 공격에 대비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 성큰 추가! 안정적인 수비 태세!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 55-66)
    ScriptPhase(
      name: 'mutal_clash',
      startLine: 55,
      branches: [
        // 분기 A: 홈 뮤탈 컨트롤 우위
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지도 섞습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 스포어도 설치!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 사격! 상대 뮤탈을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{home}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 컨트롤 우위
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지도 섞습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 스포어도 설치!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 스커지로 뮤탈을 격추합니다! 동반 추락!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 스커지 자폭! 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 - 분기 (lines 67-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 67,
      branches: [
        // 분기 A: 홈 뮤탈 견제 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 9오버풀 미러의 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.home,
              homeArmy: 3, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 견제 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 9오버풀 미러의 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
