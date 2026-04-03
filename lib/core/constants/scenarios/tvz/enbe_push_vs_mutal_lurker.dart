part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 뮤탈 럴커 (업그레이드 마린 vs 뮤탈과 럴커)
// ----------------------------------------------------------
const _tvzEnbePushVsMutalLurker = ScenarioScript(
  id: 'tvz_enbe_push_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push', 'tvz_4bar_enbe'],
  awayBuildIds: ['zvt_trans_mutal_lurker', 'zvt_12pool', 'zvt_9pool'],
  description: '선엔베 4배럭 마린 vs 뮤탈리스크 견제 + 럴커 전환',
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
          text: '{away} 선수 해처리를 올립니다! 앞마당 확장입니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리 건설! 자원 수급을 챙기구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설합니다! 선엔베!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이가 올라갑니다! 업그레이드를 서두르네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설! 드론도 계속 뽑구요.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산! 공격력 업그레이드도 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 뮤탈 견제 vs 4배럭 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어가 올라갑니다! 뮤탈부터 가져가구요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 건설! 뮤탈리스크를 먼저 뽑으려 합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭을 4개까지 늘립니다! 대량 마린 생산!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 나왔습니다! 테란 후방을 견제합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크 견제! SCV를 잡으러 날아갑니다!',
        ),
        ScriptEvent(
          text: '{home}, 터렛과 업그레이드 마린으로 뮤탈을 쫓아냅니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '뮤탈 견제를 막으면서 엔베 푸시를 가져갈 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 럴커 전환 vs 엔베 푸시 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 히드라덴을 올립니다! 럴커 전환을 노리구요.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴 건설! 뮤탈에 이어 럴커까지!',
        ),
        ScriptEvent(
          text: '{home} 선수 4배럭 마린이 출발합니다! 메딕도 함께!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 업그레이드 마린 대군! 엔베 푸시 나갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로 마린 부대를 견제하면서 럴커를 준비합니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home}, 앞마당 앞에서 마린이 포진합니다! 밀어붙이려 하구요.',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 앞마당 앞에서 마린 진형! 공격 준비 완료!',
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
              text: '{home} 선수 마린이 앞마당을 돌파합니다! 타이밍 적중!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 +1 마린 물량 돌파! 저그 전환 전에 끝냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크만으로는 마린 물량을 감당 못 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 해처리 파괴! 마린이 본진으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '선엔베 푸시 타이밍 적중! 저그가 무너집니다! GG!',
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
              text: '{away}, 뮤탈 견제가 성공적! 마린 부대가 약해졌습니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제로 엔베 푸시를 지연시켰습니다!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 완성됩니다! 앞마당에 바로우!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 스파인에 마린이 녹습니다! 물량이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '뮤탈 견제 + 럴커 전환 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
