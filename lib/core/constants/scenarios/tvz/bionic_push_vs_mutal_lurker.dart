part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 뮤탈 럴커 (균형형 저그 대응)
// ----------------------------------------------------------
const _tvzBionicPushVsMutalLurker = ScenarioScript(
  id: 'tvz_bionic_push_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '바이오닉 푸시 vs 뮤탈리스크 견제 + 럴커 전환',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 해처리를 올립니다. 앞마당 확장이구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리부터 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설! 드론도 계속 뽑구요.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설하면서 스팀팩을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아카데미가 올라갑니다! 바이오닉 준비구요.',
        ),
      ],
    ),
    // Phase 1: 뮤탈 견제 시작 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어가 올라갑니다! 뮤탈리스크 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 건설! 뮤탈리스크부터 가져가려 하네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 터렛을 올리구요.',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 나왔습니다! 테란 일꾼을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크 견제! SCV를 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '{home}, 터렛과 마린으로 뮤탈리스크를 쫓아냅니다.',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '뮤탈 견제를 하면서 럴커 전환까지 가져가려는 전략이네요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 전환 vs 바이오닉 푸시 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 히드라덴을 올립니다! 럴커로 전환하려 하구요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴 건설! 뮤탈에 이어 럴커까지 갈 생각입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 시즈탱크 부대가 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 바이오닉 풀셋! 럴커 나오기 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크로 바이오닉 부대를 견제합니다! 진군을 늦추려 하구요.',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home}, 시즈탱크를 전개하면서 앞마당을 압박합니다.',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 시즈모드! 앞마당 앞에서 포격을 시작합니다!',
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-38)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 럴커가 나오기 전에 앞마당을 밀어버립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 바이오닉 타이밍 적중! 럴커 전환 전에 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크만으로는 바이오닉을 못 막습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 해처리 파괴! 본진까지 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '럴커 전환 전에 바이오닉 푸시 성공! GG!',
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
              text: '{away}, 뮤탈 견제로 바이오닉 진군을 늦추는 데 성공했습니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제가 효과적! 바이오닉이 늦어졌어요!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 완성됩니다! 앞마당 입구에 바로우!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 스파인에 마린이 녹습니다! 시즈탱크도 부족해요!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '뮤탈 견제 + 럴커 수비 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
