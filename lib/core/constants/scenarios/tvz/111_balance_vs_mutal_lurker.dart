part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 뮤탈 럴커: 올라운드 대응 vs 균형 저그
// ----------------------------------------------------------
const _tvz111BalanceVsMutalLurker = ScenarioScript(
  id: 'tvz_111_balance_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '111 밸런스 vs 뮤탈 럴커 — 레이스 대공+마인 대지 vs 뮤탈 견제+럴커 진지',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 111 빌드를 세팅합니다. 배럭 팩토리 스타포트!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 111 체제를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 일꾼을 늘립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스를 생산합니다! 정찰 출격!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어와 히드라덴을 동시에 올립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
          altText: '{away}, 뮤탈+럴커 투트랙을 준비하는 빌드입니다!',
        ),
        ScriptEvent(
          text: '레이스가 저그 빌드를 확인하러 갑니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양면 대응 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스가 스파이어와 히드라덴을 모두 확인합니다!',
          owner: LogOwner.home,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 먼저 출격합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크 편대가 테란으로 향합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 세우고 벌처 마인을 깝니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 변태 완료! 지상에서도 압박합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 럴커까지 합류! 공중+지상 양면 공격입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 배치하면서 양면 방어를 시도합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'control',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 공방 격화 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스로 뮤탈리스크를 견제하면서 마인 필드를 넓힙니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          awayArmy: -1,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 테란 확장기지를 급습합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크가 일꾼을 잡고 빠집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커를 전진 배치하면서 테란 라인을 위협합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '111 빌드의 올라운드 대응이 통할까요? 양면 압박이 강합니다!',
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
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스가 뮤탈리스크를 추격 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 레이스가 뮤탈리스크를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마인이 럴커 접근을 차단! 시즈탱크가 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈도 럴커도 돌파를 못 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '111 올라운드 대응 성공! 양면 공격을 모두 막았습니다! GG!',
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
              text: '{away} 선수 뮤탈리스크가 터렛을 피해 일꾼을 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크 견제가 치명적입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 마인을 피해 시즈탱크를 공격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 대응이 분산됩니다! 양면에서 무너지고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈+럴커 양면 공격이 111 빌드를 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
