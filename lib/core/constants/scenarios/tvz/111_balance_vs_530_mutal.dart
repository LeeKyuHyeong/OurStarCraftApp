part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 530 뮤탈(1해처리 럴커): 마인 필드 vs 럴커 타이밍
// ----------------------------------------------------------
const _tvz111BalanceVs530Mutal = ScenarioScript(
  id: 'tvz_111_balance_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance'],
  awayBuildIds: ['zvt_trans_530_mutal'],
  description: '111 밸런스 vs 1해처리 럴커 — 벌처 마인 필드 vs 빠른 럴커 공격',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 111 빌드를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 1해처리에서 히드라덴을 빠르게 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 1해처리로 럴커를 빠르게 꺼내려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스를 생산합니다! 정찰 나갑니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 뽑으면서 럴커 변태를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 히드라리스크가 빠르게 나옵니다! 럴커 전환 임박!',
        ),
        ScriptEvent(
          text: '레이스가 저그 진영을 확인합니다! 1해처리 럴커 빌드입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 럴커 돌진 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 럴커 변태 완료! 테란 앞마당으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 럴커가 테란을 향해 이동합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 마인을 입구에 깝니다! 마인 필드!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 입구에 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, 시즈탱크가 시즈모드를 펼칩니다! 입구 방어!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 시즈탱크 사거리 밖에서 버로우합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '마인 필드 vs 럴커! 누가 먼저 상대를 잡느냐가 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공방전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처로 럴커 위치를 확인하면서 마인을 추가합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 추가 생산해서 럴커와 합류시킵니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          altText: '{away}, 히드라리스크 물량을 보탭니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 퍼실리티를 건설합니다! 사이언스 베슬이 필요합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '럴커가 접근하면 마인이 터집니다! 조심스러운 공방이 계속됩니다!',
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
              text: '{home} 선수 마인이 럴커 접근 경로에서 폭발합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 마인 필드에 럴커가 걸렸습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크가 히드라리스크를 포격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 마인에 녹아내립니다! 돌파가 안 됩니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '마인 필드가 럴커 타이밍을 저지했습니다! GG!',
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
              text: '{away} 선수 히드라리스크로 마인을 해제하면서 럴커가 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -1,
              favorsStat: 'strategy',
              altText: '{away}, 히드라가 마인을 터뜨리면서 럴커가 접근합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 시즈탱크 아래에서 가시를 뻗습니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크가 럴커 가시에 녹습니다! 입구가 뚫렸어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '럴커가 마인 필드를 돌파했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
