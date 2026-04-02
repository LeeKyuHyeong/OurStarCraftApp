part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12앞마당 vs 노풀 3해처리 (확장 vs 극매크로)
// ----------------------------------------------------------
const _zvz12hatchVs3hatchNopool = ScenarioScript(
  id: 'zvz_12hatch_vs_3hatch_nopool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '12앞마당 vs 노풀 3해처리',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 계속 뽑습니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 12드론에 앞마당 해처리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 12앞마당! 확장 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다! 스포닝풀 없이!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 앞마당! 3해처리를 향해 달립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 저글링 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 3번째 해처리까지! 자원을 극대화합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 3해처리! 드론이 쏟아져 나옵니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '12앞마당 vs 3해처리! 양쪽 다 확장 빌드입니다!',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // Phase 1: 저글링 견제 타이밍 (lines 17-28)
    ScriptPhase(
      name: 'ling_timing',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 먼저 나옵니다! 상대 앞마당을 견제할 수 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home}, 저글링 먼저 나왔습니다! 3해처리는 풀이 늦었어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론이 많지만 저글링이 없습니다! 드론으로 막습니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '12앞마당의 저글링이 3해처리를 얼마나 괴롭힐 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 앞마당에 깔아놓습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 성큰 건설! 수비 태세에 들어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
      ],
    ),
    // Phase 2: 스파이어 경쟁 (lines 29-42)
    ScriptPhase(
      name: 'spire_race',
      startLine: 29,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
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
          text: '양측 모두 후반을 준비하는 시간입니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
        ),
      ],
    ),
    // Phase 3: 뮤탈 교전 - 분기 (lines 43-56)
    ScriptPhase(
      name: 'mutal_clash',
      startLine: 43,
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
              text: '뮤탈 컨트롤이 경기를 가르고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.5,
            ),
          ],
        ),
        // 분기 B: 어웨이가 뮤탈 물량 우위
        ScriptBranch(
          id: 'away_mutal_mass',
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
              text: '{away}, 뮤탈로 드론을 견제합니다! 자원 격차가 벌어집니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '3해처리의 자원이 뮤탈 물량으로 전환되고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 57-70)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 57,
      branches: [
        // 분기 A: 홈 스커지 컨트롤 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 결전! 컨트롤 vs 물량!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 스커지 컨트롤로 뮤탈 편대를 격파합니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -8, favorsStat: 'control',
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
        // 분기 B: 3해처리(어웨이) 뮤탈 물량 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 결전! 컨트롤 vs 물량!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 물량이 스커지를 흡수하고 남습니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '3해처리의 자원 차이가 결정적!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
