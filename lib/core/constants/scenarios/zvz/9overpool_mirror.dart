part of '../../scenario_scripts.dart';

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
          text: '{away} 선수도 9오버풀 스포닝풀! 같은 빌드입니다!',
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
          baseProbability: 1.3,
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
          baseProbability: 0.7,
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
          baseProbability: 1.3,
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
          baseProbability: 0.7,
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
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 9오버풀 미러의 결전입니다!',
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
              text: '{home}, 결정타! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 견제 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 9오버풀 미러의 결전입니다!',
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
