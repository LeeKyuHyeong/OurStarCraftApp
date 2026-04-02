part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 530 뮤탈(1해처리 럴커): 팩토리 생산 속도 vs 럴커 타이밍
// ----------------------------------------------------------
const _tvzMechGoliathVs530Mutal = ScenarioScript(
  id: 'tvz_mech_goliath_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath', 'tvz_3fac_goliath'],
  awayBuildIds: ['zvt_trans_530_mutal', 'zvt_1hatch_allin'],
  description: '메카닉 골리앗 vs 1해처리 럴커 타이밍 — 팩토리 증설 vs 럴커 속공',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 1해처리 체제에서 히드라덴을 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 해처리 하나로 히드라덴을 올립니다! 공격적이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵을 붙이면서 시즈탱크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크를 생산합니다! 럴커 변태 준비!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '저그가 1해처리에서 럴커를 준비합니다! 빠른 타이밍이 올 수 있겠네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 럴커 타이밍 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 럴커 변태 완료! 테란 앞마당으로 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 럴커가 빠르게 나왔습니다! 돌진합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크 1기가 겨우 완성됩니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈모드를 펼치고 입구를 막습니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'control',
          altText: '{home}, 시즈탱크가 자리 잡았습니다! 버틸 수 있을까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 시즈탱크 사거리 밖에서 버로우합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '럴커 타이밍 공격! 시즈탱크가 막아낼 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 팩토리 증설 vs 럴커 추가 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리를 추가하면서 골리앗 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커를 추가 변태시킵니다! 압박을 유지합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          altText: '{away}, 럴커를 더 뽑습니다! 돌파력을 높이려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 마인을 깔면서 럴커 접근을 막습니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -10,
          favorsStat: 'control',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '팩토리 증설이 빠르면 테란, 럴커가 뚫으면 저그! 시간 싸움입니다!',
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
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗과 시즈탱크가 합류! 럴커를 포격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'macro',
              altText: '{home}, 메카닉 물량이 쌓였습니다! 럴커를 정리합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 시즈탱크 포격에 녹아내립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 메카닉 부대가 전진! 저그 본진을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -1,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '저그 타이밍을 버텨냈습니다! 메카닉 전진 성공! GG!',
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
              text: '{away} 선수 럴커가 시즈탱크 라인을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away}, 럴커 가시가 시즈탱크를 관통합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 아직 부족합니다! 입구가 뚫렸어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라리스크까지 합류! 테란 본진이 무너집니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍이 메카닉을 찢었습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
