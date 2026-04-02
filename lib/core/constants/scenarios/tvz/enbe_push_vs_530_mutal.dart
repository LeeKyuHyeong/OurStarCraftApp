part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 530 뮤탈 (공격 타이밍 대결)
// ----------------------------------------------------------
const _tvzEnbePushVs530Mutal = ScenarioScript(
  id: 'tvz_enbe_push_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push', 'tvz_4rax_enbe'],
  awayBuildIds: ['zvt_trans_530_mutal', 'zvt_1hatch_allin'],
  description: '선엔베 4배럭 타이밍 vs 1해처리 럴커 타이밍 (530)',
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
          text: '{away} 선수 스포닝풀 건설! 1해처리 체제입니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당을 안 올리고 1해처리로 갑니다! 공격적이네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다. 선엔베 빌드!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴이 빠릅니다! 럴커 타이밍을 가져가려 하구요.',
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 빌드! 타이밍 레이스가 될 것 같습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양쪽 타이밍 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 마린 생산 체제!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4배럭 건설! 업그레이드 마린을 대량 생산합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 업그레이드! 럴커를 서두르고 있습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 공격력 +1 연구 중! 곧 완료됩니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away}, 럴커 변태 완료! 테란을 향해 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10, favorsStat: 'attack',
          altText: '{away} 선수 럴커가 완성! 바로 공격에 나섭니다!',
        ),
        ScriptEvent(
          text: '누가 먼저 타이밍을 잡느냐! 양쪽 다 공격적입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 충돌 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 럴커가 테란 앞마당 근처에 바로우합니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'attack',
          altText: '{away} 선수 럴커가 바로우합니다! 테란 보병이 접근하기 어렵네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 4배럭에서 마린이 계속 나옵니다! 물량으로 밀어야 해요.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home}, 스캔으로 럴커 위치를 확인합니다! 마린이 돌격!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'scout',
          altText: '{home} 선수 스캔! 럴커 위치 확인하고 마린이 집중사격!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 럴커와 히드라리스크를 보냅니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
          altText: '{away}, 히드라 럴커 추가 투입! 밀어붙입니다!',
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
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home}, 업그레이드 마린이 럴커를 물량으로 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 +1 마린 물량! 럴커를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 1해처리라 후속 병력이 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 마린 대군이 저그 본진으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '선엔베 마린 물량으로 럴커 타이밍 격파! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away}, 럴커 스파인이 마린을 갈아버립니다! 물량이 녹아요!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 럴커가 마린을 학살합니다! 스파인 한 번에!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 럴커 앞에서 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 히드라리스크까지 합류! 테란 진영을 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍이 선엔베를 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
