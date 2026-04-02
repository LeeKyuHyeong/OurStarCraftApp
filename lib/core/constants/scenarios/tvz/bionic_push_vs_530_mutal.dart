part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 530 뮤탈 (공격적 타이밍 대결)
// ----------------------------------------------------------
const _tvzBionicPushVs530Mutal = ScenarioScript(
  id: 'tvz_bionic_push_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push'],
  awayBuildIds: ['zvt_trans_530_mutal'],
  description: '바이오닉 푸시 vs 1해처리 럴커 타이밍 (530)',
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
          text: '{away} 선수 스포닝풀 건설! 1해처리 체제입니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당을 안 가져가고 1해처리로 갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 빠르게 올립니다! 공격적이네요.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴이 빠릅니다! 럴커 타이밍을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '1해처리 빌드! 빠른 럴커가 예상됩니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양쪽 공격 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어 업그레이드! 럴커 변태를 서두릅니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 레어가 올라갑니다! 럴커까지 얼마 안 남았어요.',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미에서 스팀팩 연구 중! 마린을 모으구요.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away}, 럴커 2기 변태 완료! 테란 진영으로 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10, favorsStat: 'attack',
          altText: '{away} 선수 럴커가 나왔습니다! 바로 공격 나갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕을 모으면서 바이오닉 푸시를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 타이밍! 누가 먼저 치느냐가 관건입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 타이밍 충돌 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 럴커가 테란 앞마당 앞에 바로우합니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'attack',
          altText: '{away} 선수 럴커 바로우! 마린이 다가가기 어렵습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스캔으로 럴커 위치를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home}, 시즈탱크 시즈모드! 럴커를 포격합니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 시즈탱크로 럴커를 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 럴커와 저글링을 보냅니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10, favorsStat: 'attack',
          altText: '{away}, 럴커 저글링 추가 투입! 밀어붙입니다!',
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
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home}, 스팀팩 마린이 럴커 진지를 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 시즈탱크 포격과 스팀팩으로 럴커를 처리합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 1해처리라 후속 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 바이오닉 푸시가 저그 본진까지 밀어넣습니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '럴커 타이밍을 막고 역공! GG!',
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
              text: '{away}, 럴커가 마린 부대를 갈아버립니다! 스파인이 작렬!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -4, favorsStat: 'attack',
              altText: '{away} 선수 럴커 스파인에 마린이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 바이오닉이 럴커 앞에서 무력합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 저글링까지 합류해서 테란 진영을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
