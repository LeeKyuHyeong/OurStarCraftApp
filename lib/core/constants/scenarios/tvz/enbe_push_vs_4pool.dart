part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 푸시 vs 4풀 (업그레이드 마린 vs 치즈)
// ----------------------------------------------------------
const _tvzEnbePushVs4pool = ScenarioScript(
  id: 'tvz_enbe_push_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_enbe_push', 'tvz_4bar_enbe'],
  awayBuildIds: ['zvt_4pool'],
  description: '선엔베 4배럭 타이밍 vs 4풀 저글링 러시',
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
          text: '{away} 선수 드론 4기에 스포닝풀! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 정말 빠른 스포닝풀입니다! 4풀이구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 일찍 올립니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이 건설! 선엔베 빌드입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 테란으로 출발합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
        ),
        ScriptEvent(
          text: '4풀 저글링이 오고 있는데, 엔베 빌드가 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 + 초반 수비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 저글링이 테란 본진에 도착! 마린이 적습니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'attack',
          altText: '{away} 선수 저글링이 본진을 급습합니다! SCV를 노리구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV와 마린으로 저글링을 막아봅니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home}, 마린 업그레이드가 진행 중입니다! 조금만 버티면!',
          owner: LogOwner.home,
          homeResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 보냅니다! 일꾼을 계속 노리구요.',
          owner: LogOwner.away,
          awayArmy: 2, homeResource: -12, favorsStat: 'harass',
          altText: '{away}, 저글링이 계속 들어옵니다! SCV 피해가 크네요!',
        ),
        ScriptEvent(
          text: '선엔베 빌드라 마린 업그레이드가 빠를 텐데, 버틸 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 테란 안정화 시도 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 공격력 업그레이드 완료! 화력이 올라갑니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home}, +1 공격력! 마린이 더 효율적으로 전투합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 추가로 보내지만 업그레이드 완료한 테란을 뚫기 어렵습니다.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제로 전환!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 배럭 추가 건설! 마린 물량을 쏟아내려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론이 4기뿐이라 자원이 부족합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 일꾼이 너무 적어서 후속 병력이 안 나옵니다.',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home}, 업그레이드 마린이 4배럭에서 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 5, favorsStat: 'attack',
              altText: '{home} 선수 4배럭 풀가동! 마린 물량이 엄청납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링으로는 업그레이드 마린을 못 막습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 선엔베 마린이 저그 진영을 밀어버립니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '선엔베 마린 물량으로 4풀 격파! GG!',
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
              text: '{away}, 초반 저글링으로 SCV를 대량으로 잡았습니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 4풀 저글링이 일꾼을 거의 전멸시켰습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 자원이 끊겼습니다! 마린을 더 뽑을 수 없어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 저글링이 건물까지 부수기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 러시 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
