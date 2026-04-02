part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 뮤탈 울트라 (클래식 TvZ)
// ----------------------------------------------------------
const _tvzBionicPushVsMutalUltra = ScenarioScript(
  id: 'tvz_bionic_push_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '바이오닉 푸시 vs 뮤탈리스크 → 울트라리스크 전환',
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
          altText: '{away}, 앞마당 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 드론을 계속 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 드론 생산에 집중하면서 스포닝풀을 올리구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 스팀팩 연구를 준비하네요.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 중반 뮤탈 견제 vs 바이오닉 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어가 올라갑니다! 뮤탈리스크 생산 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 건설! 뮤탈리스크가 곧 나올 텐데요.',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 미리 세우고 있습니다. 뮤탈 대비하구요.',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크 3기 생산! 테란 본진을 향해 출발합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크가 모였습니다! 견제 나갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 부대를 모으고 있습니다. 스팀팩 완료!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '뮤탈리스크 견제와 바이오닉 타이밍 어느 쪽이 더 효과적일까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 일꾼을 노립니다! SCV가 잡혀나가구요!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈리스크로 SCV를 학살합니다!',
        ),
      ],
    ),
    // Phase 2: 울트라 전환 vs 바이오닉 푸시 타이밍 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 시즈탱크 부대가 이동합니다! 바이오닉 푸시!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -15, favorsStat: 'attack',
          altText: '{home}, 마린 메딕에 시즈탱크까지! 저그 앞마당으로 출발합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 퀸즈네스트를 올립니다! 하이브를 준비하는 건가요?',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 퀸즈네스트 건설! 울트라리스크를 노리고 있습니다!',
        ),
        ScriptEvent(
          text: '{home}, 저그 앞마당 앞에서 시즈모드! 압박을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 뮤탈리스크로 시간을 끕니다! 울트라가 나와야 해요!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 저글링 뮤탈로 어떻게든 버팁니다! 울트라까지만!',
        ),
        ScriptEvent(
          text: '바이오닉 푸시가 울트라리스크 전에 끝낼 수 있을까요?',
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
              text: '{home}, 바이오닉 푸시가 저그 앞마당을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 마린 메딕이 앞마당을 밀어버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 나오기 전에 앞마당이 무너졌습니다!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 추가 병력까지 합류! 본진을 향해 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '바이오닉 타이밍 푸시 성공! GG!',
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
              text: '{away}, 울트라리스크가 등장합니다! 마린이 녹기 시작해요!',
              owner: LogOwner.away,
              awayArmy: 6, homeArmy: -4, favorsStat: 'macro',
              altText: '{away} 선수 울트라리스크 합류! 마린 메딕이 순식간에 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 울트라리스크 앞에서 무력합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크와 저글링이 테란 진영을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라리스크 전환 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
