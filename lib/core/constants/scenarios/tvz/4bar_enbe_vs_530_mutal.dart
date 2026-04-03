part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 530 뮤탈 (1해처리 럴커) — 양쪽 공격적
// ----------------------------------------------------------
const _tvz4barEnbeVs530Mutal = ScenarioScript(
  id: 'tvz_4bar_enbe_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4bar_enbe'],
  awayBuildIds: ['zvt_trans_530_mutal', 'zvt_1hatch_allin'],
  description: '선엔베 4배럭 vs 1해처리 럴커 — 양쪽 타이밍 공격',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 1해처리에서 빠르게 히드라덴을 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 1해처리 히드라 빌드! 공격적인 선택이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 선엔베!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀에서 저글링을 소량 뽑습니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 빌드입니다! 누가 먼저 치느냐가 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양쪽 타이밍 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 빠르게 뽑습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 히드라가 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산에 집중합니다! 아카데미도 올리구요!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 건설! 럴커 변태를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '마린 메딕 타이밍 vs 럴커 타이밍! 긴장감이 높아집니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 직전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 부대가 모였습니다! 출발!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커 변태가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라 럴커가 앞마당에 자리를 잡으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'defense',
          altText: '{away}, 럴커가 포지션을 잡습니다!',
        ),
        ScriptEvent(
          text: '양쪽 타이밍이 거의 동시에 완성됩니다! 정면 충돌!',
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
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 스팀팩 마린이 럴커보다 빠릅니다! 히드라를 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home}, 마린 메딕이 히드라를 녹입니다! 럴커가 아직이에요!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 변태 중에 잡힙니다! 치명적!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '마린 타이밍이 앞섰습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커가 자리를 잡았습니다! 마린이 접근하지 못해요!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'control',
              altText: '{away}, 럴커 스파인이 마린 부대를 찢어놓습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 스캔도 부족해요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라 럴커가 역공을 갑니다! 테란 진영으로!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍이 이겼습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
