part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 럴커 디파일러: 시즈 사거리 vs 다크스웜 진지전
// ----------------------------------------------------------
const _tvzMechGoliathVsLurkerDefiler = ScenarioScript(
  id: 'tvz_mech_goliath_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_trans_lurker_defiler'],
  description: '메카닉 골리앗 vs 럴커 디파일러 — 시즈탱크 포격 vs 다크스웜 장기전',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 드론을 늘립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 자원 확보가 우선이구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 완성! 머신샵을 붙입니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 건설합니다! 히드라리스크 체제!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴이 올라갑니다!',
        ),
        ScriptEvent(
          text: '양측 모두 중반을 위한 테크를 올리고 있습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 럴커 등장 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 생산합니다! 시즈모드 연구 완료!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 럴커 변태 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어가 올라갑니다! 럴커가 곧 나오겠네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗을 추가 생산! 메카닉 병력이 쌓입니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 등장합니다! 앞마당 앞에 배치!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 퍼실리티 건설! 사이언스 베슬 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '럴커의 가시가 시즈탱크 라인을 위협합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 디파일러 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 퀸즈네스트 건설! 디파일러를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 하이브 테크로! 디파일러가 나온다면 게임이 달라집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크와 골리앗으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 디파일러 등장! 다크스웜을 뿌립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '다크스웜 아래에서는 시즈탱크 포격이 무력화됩니다! 장기전의 시작!',
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
              text: '{home} 선수 사이언스 베슬 이래디에이트로 디파일러를 처리합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'strategy',
              altText: '{home}, 사이언스 베슬이 디파일러를 녹입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크스웜이 사라진 틈에 시즈탱크가 포격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 시즈탱크 사거리에 녹아내립니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '사이언스 베슬이 디파일러를 무력화! 메카닉 전진 성공! GG!',
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
              text: '{away} 선수 다크스웜 위에 럴커가 자리잡습니다! 난공불락!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{away}, 다크스웜+럴커 조합이 철벽입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크 포격이 다크스웜에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 측면에서 시즈탱크를 덮칩니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '다크스웜 앞에 메카닉이 무력화됩니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
