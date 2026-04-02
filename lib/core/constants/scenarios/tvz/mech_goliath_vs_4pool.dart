part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 4풀: 팩토리 빌드 vs 극초반 치즈
// ----------------------------------------------------------
const _tvzMechGoliathVs4pool = ScenarioScript(
  id: 'tvz_mech_goliath_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_4pool'],
  description: '메카닉 골리앗 vs 4풀 — 팩토리 지연 위기 vs 극초반 올인',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 4기에서 스포닝풀! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀을 올립니다! 극초반 올인이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 위한 가스를 넣으려 하지만... 이 타이밍에 저글링이 올 수 있습니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 테란 본진으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '팩토리 빌드인데 저글링이 너무 빨리 옵니다! 마린이 충분할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 초반 수비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 2기로 입구를 막습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'defense',
          altText: '{home}, 마린 생산이 겨우 맞습니다! 입구를 틀어막아요!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 입구에 도착! 마린을 물어뜯습니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeArmy: -1,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV까지 동원해서 저글링을 막아봅니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'control',
          altText: '{home}, SCV를 수리 모드로! 마린을 지원합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링이 합류합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '팩토리가 올라가기 전에 끝날 수도 있는 상황입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 분기점 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린 추가 생산! 간신히 버팁니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 물량이 점점 줄어들고 있습니다.',
          owner: LogOwner.away,
          awayArmy: -1,
          altText: '{away}, 저글링 보충이 늦어지고 있네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설을 시작합니다! 막아낸 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '테란이 버텨내면 골리앗이 나오기 시작합니다! 저그는 지금 끝내야 합니다!',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 물량이 쌓이면서 저글링을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'defense',
              altText: '{home}, 마린이 저글링을 정리합니다! 수비 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 팩토리 완성! 벌처가 나오기 시작합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 더 이상 보낼 병력이 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '4풀 수비 성공! 팩토리까지 올라갔습니다! GG!',
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
              text: '{away} 선수 저글링이 마린을 뚫고 본진에 진입합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away}, 저글링이 마린 라인을 돌파했습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 잡아냅니다! 팩토리 건설이 취소됩니다!',
              owner: LogOwner.away,
              homeResource: -25,
              awayArmy: 1,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 마린도 부족하고 일꾼도 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '4풀 저글링이 메카닉 빌드를 짓밟았습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
