part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 뮤탈 울트라 (4배럭 마린 vs 뮤탈+울트라)
// ----------------------------------------------------------
const _tvzEnbePushVsMutalUltra = ScenarioScript(
  id: 'tvz_enbe_push_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '선엔베 4배럭 마린 타이밍 vs 뮤탈리스크 울트라 전환',
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
          text: '{away} 선수 해처리를 올립니다! 앞마당 확장이구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리 건설! 드론 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다! 선엔베 빌드!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이가 먼저 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 일꾼을 계속 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작! 공격력 업그레이드도 연구합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 4배럭 전환 vs 뮤탈 생산 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제 구축!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 배럭이 4개까지 늘어납니다! 대량 마린 생산 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어가 올라갑니다! 뮤탈리스크 생산 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 세우면서 뮤탈 대비합니다.',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 나왔습니다! 테란 일꾼을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크 견제! SCV를 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '4배럭 마린 물량과 뮤탈 견제! 어느 쪽이 더 효과적일까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 업그레이드 마린이 뮤탈리스크를 쫓아냅니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'defense',
          altText: '{home} 선수 +1 마린이 뮤탈을 격추합니다!',
        ),
      ],
    ),
    // Phase 2: 엔베 푸시 vs 울트라 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4배럭 마린이 쏟아집니다! 엔베 푸시 출발!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 업그레이드 마린 대군! 저그 앞마당으로 전진!',
        ),
        ScriptEvent(
          text: '{away} 선수 퀸즈네스트를 올립니다! 울트라를 준비하구요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 퀸즈네스트 건설! 울트라리스크까지 가려는 전략입니다.',
        ),
        ScriptEvent(
          text: '{home}, 앞마당 앞에서 마린이 저글링을 잡아냅니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크와 저글링으로 버팁니다! 울트라까지만!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 어떻게든 시간을 끕니다! 울트라가 답입니다!',
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
              text: '{home}, 4배럭 업그레이드 마린이 앞마당을 밀어버립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 마린 물량으로 앞마당 해처리를 파괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 나오기 전에 앞마당이 무너졌습니다!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 마린 대군이 본진까지 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '선엔베 4배럭 타이밍 성공! GG!',
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
              text: '{away}, 울트라리스크가 등장합니다! 마린이 녹기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 6, homeArmy: -4, favorsStat: 'macro',
              altText: '{away} 선수 울트라리스크! 마린 물량이 순식간에 사라집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린만으로는 울트라를 상대할 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크와 저글링이 테란을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라리스크 앞에서 마린은 무력! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
