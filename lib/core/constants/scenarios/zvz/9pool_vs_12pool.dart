part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 vs 12풀 (공격형 vs 스탠다드)
// ----------------------------------------------------------
const _zvz9poolVs12pool = ScenarioScript(
  id: 'zvz_9pool_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool'],
  awayBuildIds: ['zvz_12pool'],
  description: '9풀 공격 vs 12풀 스탠다드',
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
          text: '{home} 선수 9드론에 스포닝풀 건설! 빠른 저글링!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀! 저글링을 빨리 뽑으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀! 스탠다드한 운영입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀! 드론 3기 차이가 중반에 영향을 줍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링이 나옵니다! 발업까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 늦게 나옵니다. 발업 연구도 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
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
          altText: '{home} 선수 저글링 돌진! 12풀 상대에게 먼저 도착!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 늦게 나왔지만 드론과 함께 수비합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'defense',
          altText: '{away}, 입구에서 수비! 드론도 함께 싸웁니다!',
        ),
        ScriptEvent(
          text: '9풀 vs 12풀! 저글링 타이밍 차이가 관건입니다!',
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
              text: '{home}, 저글링이 입구를 뚫었습니다! 드론을 노립니다!',
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
              text: '{home}, 추가 저글링 합류! 드론 차이를 벌립니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '9풀 공격이 성공적! 드론 피해가 결정적!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 12풀 수비 성공
        ScriptBranch(
          id: 'defender_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론과 저글링으로 방어합니다! 수비 성공!',
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
              text: '{away}, 드론 3기 차이가 벌어지기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 15,
              altText: '{away} 선수 드론 차이! 중반으로 갈수록 벌어집니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 12풀의 드론 이점이 빛납니다!',
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
          text: '{home} 선수 저글링을 줄이고 스파이어를 올립니다!',
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
          text: '{away} 선수도 스파이어를 올립니다! 뮤탈 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 건설! 뮤탈 타이밍 경쟁이 시작됩니다!',
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 53-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 9풀(홈) 뮤탈 결전 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
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
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 12풀(어웨이) 자원으로 뮤탈 물량 역전
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! ZvZ 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 자원 우위로 뮤탈을 추가 생산합니다! 물량 역전!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'macro',
              altText: '{away} 선수 뮤탈 물량! 12풀의 자원이 빛납니다!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, homeResource: -15, favorsStat: 'harass',
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
