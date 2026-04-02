part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 울트라 하이브 (타이밍 레이스)
// ----------------------------------------------------------
const _tvzBionicPushVsUltraHive = ScenarioScript(
  id: 'tvz_bionic_push_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push'],
  awayBuildIds: ['zvt_trans_ultra_hive'],
  description: '바이오닉 푸시 vs 울트라리스크 하이브 후반 체제',
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
          text: '{away} 선수 해처리를 올립니다! 확장 먼저 가져가구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리부터 건설합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 드론을 최대한 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 일꾼 생산에 올인합니다! 후반을 노리는 거죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 빠른 스팀팩을 노리네요.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 저그 빠른 테크업 vs 바이오닉 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 하이브까지 가려는 건가요?',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어 업그레이드! 빠르게 테크를 올리구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 스팀팩 연구 완료! 마린 메딕을 계속 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 시간을 끌면서 퀸즈네스트를 올립니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15, favorsStat: 'defense',
          altText: '{away}, 퀸즈네스트 건설! 하이브를 향한 테크 트리입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 바이오닉 부대가 상당히 모였습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '저그가 후반을 노리고 있습니다. 테란은 그전에 끝내야 하구요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 바이오닉 푸시 vs 하이브 레이스 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 시즈탱크! 바이오닉 풀셋으로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 바이오닉 부대가 진격합니다! 울트라 나오기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브가 올라가고 있습니다! 거의 다 됐어요!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브 건설 중! 울트라리스크까지 얼마 안 남았습니다!',
        ),
        ScriptEvent(
          text: '{home}, 저그 앞마당 앞에서 시즈모드! 압박을 가합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 성큰으로 어떻게든 시간을 법니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 성큰과 저글링으로 버팁니다! 울트라만 나오면!',
        ),
        ScriptEvent(
          text: '울트라리스크가 나오느냐, 바이오닉이 먼저 뚫느냐! 시간 싸움입니다!',
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
              text: '{home}, 바이오닉이 앞마당을 돌파합니다! 울트라가 안 나왔어요!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 앞마당 해처리 파괴! 울트라 전에 끝냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 하이브가 아직 완성되지 않았습니다! 시간이 부족해요!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕이 본진까지 진격! 저그가 막을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '울트라 나오기 전에 바이오닉 푸시 성공! GG!',
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
              text: '{away}, 울트라리스크가 등장합니다! 마린이 순식간에 사라집니다!',
              owner: LogOwner.away,
              awayArmy: 6, homeArmy: -5, favorsStat: 'macro',
              altText: '{away} 선수 울트라리스크 합류! 바이오닉이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린으로는 울트라를 잡을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크가 테란 진영을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라리스크 완성! 바이오닉의 시대는 끝났습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
