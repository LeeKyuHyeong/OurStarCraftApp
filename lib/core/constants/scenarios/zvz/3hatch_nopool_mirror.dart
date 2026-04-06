part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 노풀 3해처리 미러 (극매크로 미러)
// ----------------------------------------------------------
const _zvz3hatchNopoolMirror = ScenarioScript(
  id: 'zvz_3hatch_nopool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_3hatch_nopool'],
  awayBuildIds: ['zvz_3hatch_nopool'],
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
          text: '{home} 선수 3번째 해처리까지! 드론이 쏟아져 나옵니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 3해처리 체제! 자원을 극대화합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 3번째 해처리! 노풀 3해처리 미러!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 3해처리! 양쪽 다 극매크로 빌드입니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 모두 자원을 극대화하는 모습입니다. 후반전이 기대되네요.',
          owner: LogOwner.system,
          skipChance: 0.6,
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
          text: '{away} 선수도 레어를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 모두 후반을 준비하는 고요한 시간이 이어집니다.',
          owner: LogOwner.system,
          skipChance: 0.6,
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
              skipChance: 0.5,
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
              skipChance: 0.5,
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
              skipChance: 0.5,
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
        // 분기 B: 어웨이 뮤탈 결전 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 3해처리 미러 결전입니다!',
              owner: LogOwner.system,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 집중 공격! 상대 뮤탈이 떨어집니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 상대 뮤탈을 잡습니다!',
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
