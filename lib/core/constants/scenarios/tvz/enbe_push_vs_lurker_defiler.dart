part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 럴커 디파일러 (마린 물량 vs 럴커 스플래시)
// ----------------------------------------------------------
const _tvzEnbePushVsLurkerDefiler = ScenarioScript(
  id: 'tvz_enbe_push_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push'],
  awayBuildIds: ['zvt_trans_lurker_defiler'],
  description: '선엔베 4배럭 마린 vs 럴커 디파일러 다크스웜',
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
          altText: '{away}, 앞마당 해처리부터 건설합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 마린 업그레이드를 서두릅니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀에 이어 히드라덴을 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴 건설! 럴커를 준비하는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작! 공격력 업그레이드도 연구구요.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 럴커 등장 vs 4배럭 전환 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제로 전환!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4배럭! 마린을 대량으로 뽑으려 하네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 업그레이드! 럴커 변태를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away}, 럴커가 나왔습니다! 입구에 바로우합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'defense',
          altText: '{away} 선수 럴커 4기 변태 완료! 수비 라인을 잡습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 공격력 +1 완료! 화력이 올라갔습니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '업그레이드 마린 물량 vs 럴커 스플래시! 어느 쪽이 유리할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 디파일러 준비 vs 엔베 푸시 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4배럭 마린이 출발합니다! 메딕도 함께!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 대량 마린과 메딕! 엔베 푸시 나갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 준비합니다! 디파일러까지 가려 하구요.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브 건설! 디파일러 다크스웜이 나오면 마린은 끝입니다.',
        ),
        ScriptEvent(
          text: '{home}, 럴커 진지 앞에서 스캔! 마린이 돌격합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커를 추가하면서 디파일러를 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -2, favorsStat: 'defense',
          altText: '{away}, 럴커 추가 배치! 마린이 다가오면 스파인!',
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
              text: '{home}, 마린 물량이 럴커를 물량으로 뚫습니다! 메딕이 버텨줍니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 업그레이드 마린 물량 돌파! 럴커를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디파일러가 나오기 전에 럴커 라인이 뚫렸습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 마린이 앞마당을 점령합니다! 저그가 막을 수 없어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '마린 물량으로 럴커 진지 돌파! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{away}, 디파일러가 등장합니다! 다크스웜을 뿌립니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'strategy',
              altText: '{away} 선수 다크스웜! 마린의 사격이 완전히 봉쇄됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 다크스웜 안에서 사격이 안 됩니다!',
              owner: LogOwner.home,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '{away}, 럴커와 저글링이 다크스웜 밑에서 마린을 학살합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '다크스웜 앞에서 마린은 무력! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
