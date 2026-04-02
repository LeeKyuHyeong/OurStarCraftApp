part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 4풀: 유연한 빌드 vs 극초반 치즈
// ----------------------------------------------------------
const _tvz111BalanceVs4pool = ScenarioScript(
  id: 'tvz_111_balance_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance', 'tvz_111'],
  awayBuildIds: ['zvt_4pool'],
  description: '111 밸런스 vs 4풀 — 레이스 정찰로 치즈 발견 가능 vs 극초반 올인',
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
          altText: '{away}, 4풀이 올라갑니다! 극초반 러시입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣고 111 빌드를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기가 테란 본진으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '111 빌드인데 저글링이 너무 빨리 옵니다! 마린으로 버텨야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 수비전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린으로 입구를 막습니다! SCV도 지원!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'defense',
          altText: '{home}, 마린과 SCV로 저글링을 막아봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 마린을 둘러쌉니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeArmy: -1,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설 중입니다! 벌처가 나오면 상황이 바뀝니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 보냅니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '마린과 SCV의 합동 수비! 벌처가 나올 때까지 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 벌처 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리에서 벌처가 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 물량이 줄어들고 있습니다.',
          owner: LogOwner.away,
          awayArmy: -1,
          altText: '{away}, 더 이상 보낼 저글링이 없어지고 있네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트까지 건설합니다! 111 체제 완성 가나요?',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '벌처가 나온 이상 저글링으로는 힘듭니다! 저그가 지금 끝내야 합니다!',
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
              text: '{home} 선수 벌처가 저글링을 쓸어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home} 선수 벌처가 저글링을 스플래시로 녹입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린과 벌처로 저그 본진을 역습합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 드론밖에 남지 않았습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '4풀 수비 성공! 111 빌드가 살아남았습니다! GG!',
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
              altText: '{away}, 저글링이 입구를 돌파했습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 잡아냅니다! 팩토리 건설이 취소됩니다!',
              owner: LogOwner.away,
              homeResource: -25,
              awayArmy: 1,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 일꾼도 병력도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '4풀 저글링이 111 빌드를 무너뜨렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
