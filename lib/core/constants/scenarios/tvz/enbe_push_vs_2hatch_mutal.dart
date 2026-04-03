part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 2해처리 뮤탈 (업그레이드 마린 vs 빠른 뮤탈)
// ----------------------------------------------------------
const _tvzEnbePushVs2hatchMutal = ScenarioScript(
  id: 'tvz_enbe_push_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push', 'tvz_4bar_enbe'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '선엔베 업그레이드 마린 vs 2해처리 빠른 뮤탈리스크',
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
          text: '{away} 선수 해처리를 올립니다. 2해처리 체제를 가져가구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리 건설! 빠른 뮤탈을 준비하려나 봅니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 선엔베 빌드입니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 드론을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀 올리면서 일꾼 생산 계속합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 공격력 업그레이드를 연구합니다!',
          owner: LogOwner.home,
          homeResource: -10, homeArmy: 2,
        ),
      ],
    ),
    // Phase 1: 뮤탈 등장 vs 업그레이드 마린 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어가 빠르게 올라갑니다! 2해처리 뮤탈!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 건설! 빠른 뮤탈리스크 생산을 노리구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제 돌입!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 배럭 4개! 대량 마린을 뽑으려 합니다.',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 빠르게 나왔습니다! 스택으로 견제!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크 스택! 일꾼을 노리러 출발합니다!',
        ),
        ScriptEvent(
          text: '{home}, 터렛과 업그레이드 마린으로 뮤탈을 상대합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '업그레이드 마린이 뮤탈을 상대로 더 강한 화력을 보여주네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 엔베 푸시 준비 vs 뮤탈 견제 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4배럭에서 마린이 쏟아집니다! 엔베 푸시 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, +1 마린 대군! 저그 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 후방을 계속 견제합니다!',
          owner: LogOwner.away,
          homeResource: -12, favorsStat: 'harass',
          altText: '{away}, 뮤탈 견제로 마린 푸시를 늦추려 합니다!',
        ),
        ScriptEvent(
          text: '{home}, 마린 부대가 앞마당 앞에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 깔면서 뮤탈 견제를 병행합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
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
              text: '{home}, +1 마린이 뮤탈리스크를 잡아냅니다! 업그레이드 차이!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 마린이 업그레이드 화력으로 뮤탈리스크를 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크를 잃고 지상 병력도 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 4배럭 마린이 앞마당을 밀어버립니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '선엔베 업그레이드 마린의 위력! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 견제로 SCV를 대량 학살합니다! 자원이 고갈!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제 대성공! 테란 자원이 바닥입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 보충이 안 됩니다! 자원이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크와 저글링이 힘을 합쳐 테란을 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '뮤탈 견제 승리! 자원 차이를 뒤집지 못합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
