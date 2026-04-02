part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 럴커 디파일러 (바이오닉 vs 수비형 저그)
// ----------------------------------------------------------
const _tvzBionicPushVsLurkerDefiler = ScenarioScript(
  id: 'tvz_bionic_push_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push', 'tvz_sk'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '바이오닉 푸시 vs 럴커 디파일러 다크스웜 수비',
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
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올리면서 드론 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산! 팩토리와 아카데미도 건설하구요.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀에 이어 히드라덴을 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴 건설! 히드라리스크 럴커 라인을 가져가려 하네요.',
        ),
        ScriptEvent(
          text: '저그가 히드라덴을 올렸습니다. 럴커 전환이 예상되는데요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 럴커 등장 vs 바이오닉 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어 업그레이드 중! 럴커 변태를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스팀팩 연구 완료! 마린 메딕을 모으고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 스팀팩 마린과 메딕이 차곡차곡 모입니다.',
        ),
        ScriptEvent(
          text: '{away}, 럴커 4기 변태 완료! 앞마당 입구에 배치합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'defense',
          altText: '{away} 선수 럴커가 나왔습니다! 바로우하고 수비 라인을 잡네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 퍼실리티 건설! 사이언스 베슬을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '럴커 라인을 바이오닉으로 뚫을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 디파일러 등장 vs 바이오닉 푸시 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 바이오닉 부대가 전진합니다! 시즈탱크도 함께!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 마린 메딕 시즈탱크 풀셋! 저그 앞마당으로 진격!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 디파일러를 뽑으려 하구요!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브 업그레이드! 디파일러 다크스웜을 노립니다!',
        ),
        ScriptEvent(
          text: '{home}, 시즈모드로 럴커 진지를 포격합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커를 추가하면서 시간을 끕니다!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 럴커 추가 배치! 디파일러만 나오면 됩니다!',
        ),
        ScriptEvent(
          text: '디파일러가 나오기 전에 돌파해야 합니다! 시간 싸움이네요.',
          owner: LogOwner.system,
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
              text: '{home} 선수 사이언스베슬이 이래디에이트를 적중시킵니다! 저그 라인이 녹습니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 이래디에이트로 럴커 진지를 무력화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디파일러가 나오기 전에 럴커 라인이 뚫렸습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕이 돌파! 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '저그 방어선 돌파 성공! GG!',
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
              altText: '{away} 선수 디파일러가 다크스웜을 뿌립니다! 테란 사격이 차단!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 다크스웜 안에서 아무것도 못 합니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 럴커와 저글링이 다크스웜 아래에서 테란을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '다크스웜 수비 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
