part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 2해처리 뮤탈 (타이밍 대결)
// ----------------------------------------------------------
const _tvzBionicPushVs2hatchMutal = ScenarioScript(
  id: 'tvz_bionic_push_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push', 'tvz_sk'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '바이오닉 타이밍 vs 2해처리 빠른 뮤탈리스크',
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
          text: '{away} 선수 해처리를 올리면서 드론을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리 건설! 일꾼 생산에 집중하구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설 준비! 머신샵까지 붙일 계획이네요.',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 팩토리가 올라갑니다! 머신샵도 곧 건설하구요.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 채취하면서 아카데미를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 아카데미 건설! 스팀팩을 서두르네요.',
        ),
      ],
    ),
    // Phase 1: 뮤탈 등장 vs 바이오닉 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어가 빠르게 올라갑니다! 2해처리 뮤탈이네요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 건설! 빠른 뮤탈리스크를 노리고 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 터렛을 준비하구요.',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 빠르게 나왔습니다! 뭉쳐서 견제 나갑니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크 스택! 일꾼을 노리러 갑니다!',
        ),
        ScriptEvent(
          text: '{home}, 터렛이 아직 안 올라왔습니다! 마린으로 막아야 해요!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -8, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '뮤탈리스크 견제가 얼마나 효과적일지가 중요하겠네요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 바이오닉 카운터 푸시 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스팀팩 완료! 마린 메딕 부대가 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 스팀팩 마린에 메딕 합류! 바이오닉 푸시 나갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 테란 본진을 계속 견제합니다!',
          owner: LogOwner.away,
          homeResource: -12, favorsStat: 'harass',
          altText: '{away}, 뮤탈로 SCV를 계속 잡아냅니다! 자원 차이를 벌리려구요.',
        ),
        ScriptEvent(
          text: '{home}, 시즈탱크와 함께 앞마당 앞에 포진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 깔면서 뮤탈 견제를 이어갑니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
          altText: '{away}, 저글링과 뮤탈리스크 투트랙 운영입니다.',
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
              text: '{home}, 스팀팩 마린이 뮤탈리스크를 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 마린이 집중사격! 뮤탈리스크를 떨어뜨립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크를 잃고 지상 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 바이오닉 푸시로 앞마당을 밀어버립니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '바이오닉 푸시 성공! 앞마당 파괴! GG!',
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
              text: '{away}, 뮤탈리스크 견제로 테란 자원이 고갈됩니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈리스크가 SCV를 잡아냅니다! 테란 일꾼이 거의 없어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 바이오닉 푸시가 힘을 잃습니다. 자원이 부족해요.',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크와 저글링이 함께 테란 진영을 공격합니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '뮤탈리스크 견제 승리! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
