part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 울트라 하이브: 시즈탱크 라인 vs 울트라와 디파일러
// ----------------------------------------------------------
const _tvzMechGoliathVsUltraHive = ScenarioScript(
  id: 'tvz_mech_goliath_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath', 'tvz_3fac_goliath'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_3hatch_nopool', 'zvt_12hatch'],
  description: '메카닉 골리앗 vs 울트라 하이브 — 시즈탱크 스플래시 vs 울트라 돌진',
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
          text: '{away} 선수 앞마당 해처리를 올리면서 일꾼을 늘립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장하면서 장기전을 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 완성! 머신샵을 붙이면서 메카닉 체제를 갖춥니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하고 저글링으로 정찰합니다. 3번째 해처리도 노리구요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -20,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '저그가 빠른 확장으로 장기전을 준비하고 있습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 중반 대치 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리를 추가! 골리앗과 시즈탱크를 쏟아냅니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -25,
          favorsStat: 'macro',
          altText: '{home}, 3팩토리 체제! 메카닉 물량이 쌓입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리면서 하이브 테크를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리에서 메카닉 업그레이드를 연구합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 건설을 시작합니다! 최종 테크를 노리는군요!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브가 올라갑니다! 후반을 준비하고 있습니다!',
        ),
        ScriptEvent(
          text: '테란이 먼저 밀어야 합니다! 하이브가 완성되면 상황이 달라집니다!',
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
          text: '{home} 선수 시즈탱크와 골리앗으로 전진을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 성큰으로 시간을 벌면서 하이브 테크를 완성합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈모드를 전개합니다! 저그 앞마당을 포격!',
          owner: LogOwner.home,
          homeArmy: 1,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{home}, 시즈탱크 라인이 전개됩니다! 포격 개시!',
        ),
        ScriptEvent(
          text: '{away} 선수 디파일러 마운드를 건설합니다! 다크스웜을 준비하구요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 울트라리스크가 등장합니다! 디파일러도 합류!',
          owner: LogOwner.away,
          awayArmy: 6,
          awayResource: -30,
          favorsStat: 'macro',
          altText: '{away}, 울트라리스크와 디파일러! 최종 병기가 나왔습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 대량 생산해서 울트라와 함께 돌진 준비!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '시즈탱크 스플래시가 울트라 돌진을 막을 수 있을까요?',
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
              text: '{home} 선수 시즈탱크 포격이 울트라리스크를 직격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 시즈탱크가 완벽한 포지션에서 울트라를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 저글링을 정리하면서 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 디파일러 다크스웜을 쓰지만 이미 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '시즈탱크 화력이 울트라를 녹였습니다! 메카닉 승리! GG!',
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
              text: '{away} 선수 디파일러 다크스웜! 시즈탱크 포격이 무력화됩니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'strategy',
              altText: '{away}, 다크스웜이 시즈탱크 라인을 덮습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 시즈탱크를 밟으며 돌진합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 후퇴하지만 울트라에 짓밟힙니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '울트라리스크가 메카닉 라인을 짓밟았습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
