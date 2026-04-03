part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 울트라 하이브: 중반 우위로 끝내야 하는 테란
// ----------------------------------------------------------
const _tvz111BalanceVsUltraHive = ScenarioScript(
  id: 'tvz_111_balance_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance', 'tvz_111'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_3hatch_nopool', 'zvt_12hatch'],
  description: '111 밸런스 vs 울트라 하이브 — 중반 타이밍 공격 vs 울트라와 디파일러 장기전',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 올립니다! 111 빌드네요!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭에서 팩토리로! 111 체제를 갖추고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리고 3번째 확장도 노립니다!',
          owner: LogOwner.away,
          awayResource: -35,
          altText: '{away}, 해처리를 연달아 올립니다! 장기전 준비구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 붙이고 스타포트까지! 111이 완성됩니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하고 저글링으로 견제합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '저그가 빠른 확장을 가져갑니다! 테란이 중반에 치고 나가야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 중반 압박 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스로 정찰합니다! 확장이 빠른 것을 확인!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 저그 확장기지 일꾼을 견제합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 벌처가 3번째 확장을 급습합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 건설합니다! 히드라리스크 생산 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크와 마린으로 중반 타이밍 공격을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 히드라리스크로 수비합니다.',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'defense',
          altText: '{away}, 저글링과 히드라로 테란 공격을 막아봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올리기 시작합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '테란이 하이브 완성 전에 끝내야 합니다! 후반으로 가면 불리해요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 울트라 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린과 시즈탱크와 벌처로 전진합니다! 타이밍 공격!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'attack',
          altText: '{home}, 111 병력으로 전진합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 완성! 울트라리스크가 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 울트라리스크 생산 시작! 디파일러도 준비합니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'macro',
          altText: '{away}, 울트라리스크가 나옵니다! 게임 체인저!',
        ),
        ScriptEvent(
          text: '하이브 테크가 완성됐습니다! 테란의 타이밍이 지나가고 있습니다!',
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
              text: '{home} 선수 울트라 합류 전에 저그 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home}, 타이밍 공격이 적중합니다! 앞마당 파괴!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크 포격으로 히드라리스크를 정리합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 1기 나왔지만 이미 자원이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '중반 타이밍 공격 성공! 하이브 전에 끝냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 전선에 합류합니다! 시즈탱크를 향해 돌진!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away}, 울트라리스크가 시즈탱크를 밟습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디파일러가 다크스웜을 뿌립니다! 사격이 무력화!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home} 선수 타이밍을 놓쳤습니다! 울트라와 디파일러에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '울트라와 디파일러 조합이 111 빌드를 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
