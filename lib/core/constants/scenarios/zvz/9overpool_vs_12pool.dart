part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9오버풀 vs 12풀 (준공격형 vs 스탠다드)
// ----------------------------------------------------------
const _zvz9overpoolVs12pool = ScenarioScript(
  id: 'zvz_9overpool_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_12pool'],
  description: '9오버풀 vs 12풀 스탠다드',
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
          text: '{home} 선수 9드론에 오버로드 먼저! 이후 스포닝풀!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9오버풀! 드론 한 기의 이점을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀! 스탠다드한 운영!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀! 드론 수가 많은 안정적인 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링에 발업! 저글링이 먼저 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 늦게 나옵니다. 발업도 시작합니다.',
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
          altText: '{home} 선수 저글링 돌진! 먼저 공격하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 언덕과 좁은 입구를 이용해서 수비합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'defense',
          altText: '{away}, 입구에서 수비! 저글링 두 마리씩 상대하는 형태!',
        ),
        ScriptEvent(
          text: '9오버풀 vs 12풀! 저글링 타이밍이 살짝 앞서는 9오버풀!',
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
        // 분기 A: 9오버풀 공격 성공
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
              text: '{away} 선수 드론 피해가 큽니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 상대 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '공격이 성공적! 드론 차이가 벌어집니다!',
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
              text: '{away}, 드론 수가 벌어지기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 15,
              altText: '{away} 선수 12풀의 드론 이점! 중반이 기대됩니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 12풀의 드론 이점이 빛나는 순간!',
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
          text: '스파이어를 올리는 순간이 서로에게 가장 위험합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수도 스파이어를 올립니다! 뮤탈 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 건설! 뮤탈 타이밍 경쟁 시작!',
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 53-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 9오버풀(홈) 뮤탈 결전 승리
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
              text: '{away}, 자원 우위로 뮤탈 물량을 늘립니다! 역전!',
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
