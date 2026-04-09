part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 레어 vs 9오버풀 (테크 우선 vs 안정형)
// ----------------------------------------------------------
const _zvz9poolLairVs9overpool = ScenarioScript(
  id: 'zvz_9pool_lair_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_lair'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9풀 레어 vs 9오버풀 — 뮤탈 타이밍 경쟁',
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
        // 분기 A: 9풀 공격 성공 — 저글링 먼저 나오는 이점
        ScriptBranch(
          id: 'attacker_breaks_through',
          baseProbability: 1.5,
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
          baseProbability: 0.5,
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
          awayArmy: 2, awayResource: -25,
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
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -8, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home}, 결정타! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9오버풀(어웨이) 뮤탈 결전 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 스커지 자폭! 뮤탈을 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'control',
              altText: '{away} 선수 스커지 자폭! 뮤탈을 동반 격추!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away}, 결정타! 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

