part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 뮤탈 럴커: 골리앗이 뮤탈, 탱크가 럴커 담당
// ----------------------------------------------------------
const _tvzMechGoliathVsMutalLurker = ScenarioScript(
  id: 'tvz_mech_goliath_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '메카닉 골리앗 vs 뮤탈 럴커 — 골리앗 대공+시즈탱크 대지 vs 균형잡힌 저그',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 드론을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 벌처를 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 넣고 스파이어와 히드라덴을 동시에 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'strategy',
          altText: '{away}, 뮤탈과 럴커를 동시에 준비하는 빌드입니다!',
        ),
        ScriptEvent(
          text: '테란은 메카닉, 저그는 뮤탈+럴커 투트랙을 준비합니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 뮤탈+럴커 전개 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 머신샵에서 시즈모드 연구! 골리앗도 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 먼저 출격합니다! 테란 일꾼을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크 편대가 테란 본진으로 향합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗이 뮤탈리스크를 요격합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          awayArmy: -1,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 변태 완료! 지상에서도 압박합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '공중은 뮤탈, 지상은 럴커! 테란이 양면 대응을 해야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 양면 전쟁 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗은 대공, 시즈탱크는 럴커! 역할 분담합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'strategy',
          altText: '{home}, 메카닉 조합이 완성됩니다! 골리앗+시즈탱크!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 시즈탱크를 견제하면서 럴커로 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeArmy: -1,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 추가 건설하면서 방어를 보강합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '골리앗과 시즈탱크가 뮤탈+럴커를 동시에 상대할 수 있을지가 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗이 뮤탈리스크를 격추! 시즈탱크가 럴커를 포격!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home}, 메카닉 역할 분담이 완벽합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 골리앗 화력에 녹습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 메카닉 대군이 저그 본진으로 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '골리앗+시즈탱크 조합이 뮤탈+럴커를 완벽히 제압했습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 시즈탱크 후방을 급습합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              homeResource: -15,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크가 시즈탱크를 잡았습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 시즈탱크 없는 전선을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗만으로는 럴커를 막을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '뮤탈+럴커 양면 공격에 메카닉이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
