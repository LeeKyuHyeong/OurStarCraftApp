part of '../../scenario_scripts.dart';

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
          altText: '{home}, 저글링에 발업! 손싸움 준비 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산! 발업도 함께!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링에 발업! 동시 타이밍!',
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
              altText: '{away}, 스포어와 스커지로 수비! 뮤탈을 잡으려 합니다!',
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
              altText: '{home}, 스포어와 스커지로 수비! 뮤탈을 잡으려 합니다!',
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
              homeArmy: 5, awayArmy: -8, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 상대 뮤탈을 격파!',
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
              awayArmy: 5, homeArmy: -8, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 상대 뮤탈을 격파!',
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

