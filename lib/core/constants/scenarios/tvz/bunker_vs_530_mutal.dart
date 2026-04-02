part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 530 뮤탈 (1해처리 럴커) — 양쪽 공격적
// ----------------------------------------------------------
const _tvzBunkerVs530Mutal = ScenarioScript(
  id: 'tvz_bunker_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_530_mutal'],
  description: '벙커 러시 vs 1해처리 럴커 — 양쪽 공격적 타이밍 대결',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터에 배럭을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 12해처리가 아닙니다! 1해처리 빌드구요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당을 늦게 올립니다! 공격적인 빌드 같습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 앞으로 보냅니다.',
          owner: LogOwner.home,
          homeResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 히드라덴도 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 빌드를 선택했습니다! 타이밍 싸움이 될 것 같네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양쪽 타이밍 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 SCV가 저그 앞마당에 도착! 벙커를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 빠르게 뽑고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 히드라리스크가 나오기 시작합니다! 빠른 타이밍이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 벙커 건설 중! 저글링이 달려듭니다!',
          owner: LogOwner.home,
          homeResource: -5,
          homeArmy: -1,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 럴커 변태 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '벙커 타이밍 vs 럴커 타이밍! 누가 먼저 완성할까요!',
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
          text: '{away} 선수 히드라리스크가 벙커를 공격합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -1,
          favorsStat: 'attack',
          altText: '{away}, 히드라 사거리가 벙커를 때립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV 수리로 벙커를 유지합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커 변태 시작! 곧 럴커가 나옵니다!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '럴커까지 나오면 벙커는 버틸 수 없습니다!',
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
              text: '{home} 선수 벙커가 버팁니다! 마린 화력으로 히드라를 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 벙커 마린이 히드라를 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 히드라리스크가 무너집니다! 럴커가 늦었어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 병력으로 밀고 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 타이밍이 이겼습니다! GG!',
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
              text: '{away} 선수 럴커 변태 완료! 벙커 앞에 자리 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away}, 럴커가 벙커 앞에서 버로우합니다! 마린이 녹아요!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 럴커 스파인에 전멸합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라 럴커가 테란 진영을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍이 벙커를 압도했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
