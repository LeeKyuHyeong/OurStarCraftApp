part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 럴커 디파일러 — 타이밍 공격 vs 수비 매크로
// ----------------------------------------------------------
const _tvz4raxEnbeVsLurkerDefiler = ScenarioScript(
  id: 'tvz_4rax_enbe_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4rax_enbe'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '선엔베 4배럭 타이밍 vs 럴커 디파일러 수비',
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
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이가 올라갑니다! 선엔베 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀과 가스를 넣습니다. 히드라덴 준비구요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스를 일찍 넣습니다! 히드라리스크를 노리는군요.',
        ),
        ScriptEvent(
          text: '테란은 공격을, 저그는 수비를 준비하고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 추가! 아카데미도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설합니다! 럴커를 준비하네요.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 계속 뽑습니다! 메딕도 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 럴커 변태 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '마린 메딕 타이밍이 럴커보다 빠를까요? 시간 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 충돌 직전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 부대가 출발합니다! 공격력 업그레이드 완료!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -10,
          favorsStat: 'attack',
          altText: '{home}, 마린 메딕이 모였습니다! 진격!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 생산합니다! 럴커 변태도 시작!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 앞마당에 건설! 수비 라인 형성!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '럴커가 자리를 잡기 전에 밀어야 합니다! 타이밍이 중요하네요!',
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
              text: '{home} 선수 스팀팩 마린이 럴커 자리 잡기 전에 돌격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 마린이 버로우 전에 돌격! 저그 병력을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 늦었습니다! 히드라만으로는 마린을 못 막아요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '저그 테크업 전에 밀었습니다! 4배럭 타이밍 성공! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커가 자리를 잡습니다! 마린이 접근하지 못합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 럴커 스파인이 마린을 녹입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔으로 럴커를 잡으려 하지만 수가 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 하이브 완성! 디파일러가 합류합니다! 다크스웜이 깔립니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '디파일러가 전장을 장악합니다! 저그 조합의 승리! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
