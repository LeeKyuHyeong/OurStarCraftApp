part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12풀 미러 (스탠다드 미러)
// ----------------------------------------------------------
const _zvz12poolMirror = ScenarioScript(
  id: 'zvz_12pool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12pool'],
  awayBuildIds: ['zvz_12pool'],
  description: '12풀 미러 스탠다드 대결',
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
          text: '{away} 선수도 12드론에 스포닝풀! 12풀 미러!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀 스포닝풀! 동일한 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링과 발업! 앞마당 타이밍을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
        ),
        ScriptEvent(
          text: '12풀 미러! 앞마당 타이밍이 승부의 관건입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 앞마당 확장 타이밍 (lines 15-26)
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 모으면서 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25, favorsStat: 'strategy',
          altText: '{home}, 앞마당! 성큰을 깔면서 확장합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 해처리를 올립니다! 성큰도 같이!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -25, favorsStat: 'strategy',
          altText: '{away}, 앞마당 건설! 서로 확장하는 모습입니다!',
        ),
        ScriptEvent(
          text: 'ZvZ에서 앞마당을 올리는 순간이 가장 위험한 타이밍이죠!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 앞마당에 깔아놓습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 성큰 건설! 수비 태세!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 스파이어 경쟁 (lines 27-40)
    ScriptPhase(
      name: 'spire_race',
      startLine: 27,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어를 올리면서 스파이어 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어에 스파이어! 뮤탈 타이밍 경쟁!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어를 올립니다! 스파이어 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 레어에 스파이어! 뮤탈을 누가 먼저 뽑을까요?',
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 서로에게 가장 위험합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 모아서 상대 앞마당 앞에 배치합니다.',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 뮤탈 교전 - 분기 (lines 41-54)
    ScriptPhase(
      name: 'mutal_clash',
      startLine: 41,
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
    // Phase 4: 결전 - 분기 (lines 55-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      branches: [
        // 분기 A: 홈 뮤탈 견제 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 12풀 미러의 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -5, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -5, favorsStat: 'control',
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
              text: '뮤탈 소모전! 12풀 미러의 결전입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -5, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -5, favorsStat: 'control',
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
