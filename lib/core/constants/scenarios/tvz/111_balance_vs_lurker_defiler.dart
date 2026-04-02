part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 럴커 디파일러: 벌처 속도+탱크 vs 럴커+다크스웜
// ----------------------------------------------------------
const _tvz111BalanceVsLurkerDefiler = ScenarioScript(
  id: 'tvz_111_balance_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance', 'tvz_111'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '111 밸런스 vs 럴커 디파일러 — 벌처 견제+사이언스 베슬 vs 럴커+다크스웜',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 111 빌드를 올립니다! 배럭, 팩토리, 스타포트!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭 팩토리 스타포트를 차례로 건설합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 히드라덴을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처를 생산! 속도 업그레이드를 연구합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 생산하면서 럴커 변태를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 히드라리스크가 나옵니다! 럴커로 전환할 겁니다!',
        ),
        ScriptEvent(
          text: '111 빌드의 유연한 대응 vs 럴커의 진지전! 어떤 전개가 될까요?',
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
          text: '{home} 선수 벌처로 저그 확장기지를 견제합니다!',
          owner: LogOwner.home,
          awayResource: -10,
          favorsStat: 'harass',
          altText: '{home}, 벌처가 저그 일꾼을 견제합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커 변태 완료! 앞마당 앞에 배치합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 배치! 럴커 위치를 잡으려 합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 퍼실리티 건설! 사이언스 베슬이 핵심입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '럴커가 자리를 잡았습니다! 시즈탱크가 처리할 수 있을까요?',
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
          text: '{away} 선수 하이브 테크! 디파일러를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 디파일러가 곧 나옵니다! 다크스웜 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 베슬이 나옵니다! 이래디에이트 준비!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 디파일러 등장! 다크스웜으로 시즈탱크를 무력화하려 합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 디파일러가 합류합니다! 다크스웜이 나올 준비!',
        ),
        ScriptEvent(
          text: '사이언스 베슬 vs 디파일러! 이 매치업의 핵심 대결입니다!',
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
              text: '{home} 선수 사이언스베슬이 이래디에이트를 적중시킵니다! 저그 핵심 유닛을 잡아요!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'strategy',
              altText: '{home}, 이래디에이트가 정확히 디파일러를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크가 럴커를 포격합니다! 다크스웜 없이 무방비!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 저그 확장기지를 급습합니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '사이언스 베슬이 디파일러를 무력화! 111 빌드 승리! GG!',
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
              text: '{away} 선수 다크스웜이 시즈탱크 라인을 덮습니다! 포격 무력화!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'strategy',
              altText: '{away} 선수 다크스웜이 테란 라인을 덮습니다! 포격이 멈춰요!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 다크스웜 아래에서 시즈탱크를 녹입니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬이 스커지에 격추됩니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '다크스웜과 럴커 조합이 111 빌드를 무너뜨립니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
