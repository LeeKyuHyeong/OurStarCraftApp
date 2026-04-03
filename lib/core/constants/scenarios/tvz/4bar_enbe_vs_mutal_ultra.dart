part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 뮤탈 울트라 — 타이밍 푸시 vs 매크로
// ----------------------------------------------------------
const _tvz4barEnbeVsMutalUltra = ScenarioScript(
  id: 'tvz_4bar_enbe_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4bar_enbe'],
  awayBuildIds: ['zvt_trans_mutal_ultra', 'zvt_9overpool', 'zvt_3hatch_mutal'],
  description: '선엔베 4배럭 타이밍 vs 뮤탈 울트라 매크로',
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
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올리는 안정적인 빌드구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다! 선엔베!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이가 일찍 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 드론을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 공격력 업그레이드를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'strategy',
          skipChance: 0.3,
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
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭이 4개! 마린 물량이 쏟아질 준비입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다. 스파이어 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 메딕과 스팀팩을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑습니다! 자원 확보에 집중하구요.',
          owner: LogOwner.away,
          awayResource: 15,
          favorsStat: 'macro',
          altText: '{away}, 일꾼 수가 빠르게 늘어나고 있습니다!',
        ),
        ScriptEvent(
          text: '테란이 타이밍을 준비하고 있습니다! 저그는 자원을 쌓고 있네요!',
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
          text: '{home} 선수 마린 메딕 부대가 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 완성! 뮤탈리스크 생산!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 건설합니다! 뮤탈 대비!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 본진에 터렛을 올립니다! 대공 준비!',
        ),
        ScriptEvent(
          text: '마린 메딕 타이밍 vs 뮤탈리스크! 이제 곧 충돌합니다!',
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
              text: '{home} 선수 마린 메딕이 앞마당으로 진격합니다! 스팀팩!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 스팀팩 마린이 저글링을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크로 견제하지만 터렛이 막습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕 물량이 압도적입니다! 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4배럭 타이밍 성공! 울트라 전에 끝냈습니다! GG!',
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
              text: '{away} 선수 뮤탈리스크가 테란 본진을 급습합니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈이 테란 일꾼을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링과 성큰으로 마린 푸시를 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 하이브 올리고 울트라리스크 준비! 자원 차이가 큽니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -20,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '타이밍을 놓쳤습니다! 울트라에 테란이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
