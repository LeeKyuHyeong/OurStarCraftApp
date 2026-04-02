part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 울트라 하이브 (마린 물량 vs 울트라 후반)
// ----------------------------------------------------------
const _tvzEnbePushVsUltraHive = ScenarioScript(
  id: 'tvz_enbe_push_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push'],
  awayBuildIds: ['zvt_trans_ultra_hive'],
  description: '선엔베 4배럭 마린 타이밍 vs 울트라리스크 하이브 후반 체제',
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
          text: '{away} 선수 해처리를 올립니다! 확장부터 가져가구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리 건설! 후반을 노리는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 마린 업그레이드를 서두릅니다.',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 선엔베 빌드입니다! 업그레이드 우위를 가져가려 하네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 드론을 최대한 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작! 공격력 업그레이드 연구 중!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 테크 레이스 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 빠른 테크업이네요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어 업그레이드! 하이브까지 가려는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭을 4개까지 늘립니다! 마린 물량 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 퀸즈네스트를 건설합니다! 하이브를 노리구요.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 퀸즈네스트! 울트라리스크로 가는 길입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 공격력 +1 완료! 화력이 올라갔습니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '저그가 후반 테크를 올리고 있습니다. 테란은 빨리 끝내야 하구요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 엔베 푸시 vs 하이브 완성 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4배럭 업그레이드 마린이 출발합니다! 메딕 합류!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 대량 마린과 메딕! 엔베 푸시 나갑니다! 지금 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브가 올라가고 있습니다! 거의 완성!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브 건설 중! 울트라리스크가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{home}, 저그 앞마당 앞에서 마린이 돌격합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 성큰으로 시간을 끕니다! 울트라만 나오면!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 성큰 뒤에서 저글링이 버팁니다! 조금만 더!',
        ),
        ScriptEvent(
          text: '울트라리스크 나오기 전에 끝내야 합니다! 마린만으로는 울트라를 못 잡아요!',
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
              text: '{home}, 4배럭 마린 물량이 앞마당을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 업그레이드 마린 대군! 앞마당 해처리를 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 아직 나오지 않았습니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 마린이 본진까지 밀고 들어갑니다! 저그가 막을 수 없어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '울트라 나오기 전에 선엔베 푸시 성공! GG!',
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
              text: '{away}, 울트라리스크가 등장합니다! 마린이 녹습니다!',
              owner: LogOwner.away,
              awayArmy: 6, homeArmy: -5, favorsStat: 'macro',
              altText: '{away} 선수 울트라리스크! 마린 물량이 순식간에 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린만으로는 울트라를 잡을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크가 테란 진영을 짓밟습니다! 디파일러까지!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라리스크 앞에서 마린은 종이! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
