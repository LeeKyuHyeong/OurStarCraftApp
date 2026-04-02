part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 울트라 하이브 — 타이밍 공격 vs 최후반
// ----------------------------------------------------------
const _tvz4raxEnbeVsUltraHive = ScenarioScript(
  id: 'tvz_4rax_enbe_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4rax_enbe'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_3hatch_nopool'],
  description: '선엔베 4배럭 타이밍 vs 울트라 하이브 최후반 빌드',
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
          text: '{away} 선수 앞마당 해처리를 올립니다. 확장부터 가져가네요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올리면서 드론 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 공격력 업그레이드 시작!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다. 가스도 넣구요.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '테란이 선엔베! 공격적인 빌드입니다!',
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
          text: '{home} 선수 배럭을 4개까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 4배럭 체제! 마린이 쏟아질 준비입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 대량 생산합니다! 자원을 빠르게 확보합니다!',
          owner: LogOwner.away,
          awayResource: 20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 메딕과 스팀팩을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다. 장기전을 가져가려는 구상입니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어를 올리면서 장기전을 준비합니다!',
        ),
        ScriptEvent(
          text: '테란은 빠른 공격을, 저그는 장기전을 원하고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 부대가 완성됩니다! 출발!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 건설합니다! 앞마당 수비 라인!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 퀸즈네스트를 건설합니다! 하이브를 향해 가는군요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 퀸즈네스트가 올라갑니다! 하이브 테크!',
        ),
        ScriptEvent(
          text: '하이브까지 가면 울트라리스크가 나옵니다! 지금 밀어야 합니다!',
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
              text: '{home} 선수 스팀팩 마린 메딕이 앞마당을 돌격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 마린 메딕 물량이 저글링을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰과 저글링만으로는 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리를 부수고 본진까지 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '하이브 완성 전에 끝냈습니다! 4배럭 타이밍 성공! GG!',
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
              text: '{away} 선수 저글링과 성큰으로 마린 푸시를 간신히 막습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'defense',
              altText: '{away}, 성큰이 마린을 막아냅니다! 간신히 수비 성공!',
            ),
            ScriptEvent(
              text: '{away} 선수 하이브가 올라갑니다! 울트라리스크 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크가 테란 진영으로 돌진합니다! 마린으로는 안 돼요!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라리스크에 마린이 무력화됩니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
