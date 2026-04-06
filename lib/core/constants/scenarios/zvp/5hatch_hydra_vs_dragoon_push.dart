part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 드라군 푸시
// ----------------------------------------------------------
const _zvp5hatchHydraVsDragoonPush = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '5해처리 히드라 물량 vs 2게이트 드라군 푸시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 생산합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설 후 게이트웨이를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 자원을 확보합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 2개를 가동합니다! 질럿 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 2게이트! 질럿부터 뽑습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣으면서 테크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 드라군 전환!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 사이버네틱스 코어! 드라군을 준비합니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 푸시 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드라군 4기가 전진합니다! 저그 앞마당을 압박!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20, favorsStat: 'attack',
          altText: '{away}, 드라군 행군! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링과 성큰으로 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15, favorsStat: 'defense',
          altText: '{home}, 저글링 방어! 성큰도 건설합니다!',
        ),
        ScriptEvent(
          text: '{away}, 드라군 사정거리를 활용해 성큰을 노립니다!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라로 전환합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 히드라덴! 히드라가 나오면 달라집니다!',
        ),
        ScriptEvent(
          text: '드라군 푸시를 히드라가 나올 때까지 막아야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 히드라 합류 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크가 합류합니다! 드라군을 사격!',
          owner: LogOwner.home,
          homeArmy: 4, awayArmy: -2, homeResource: -20, favorsStat: 'attack',
          altText: '{home}, 히드라 합류! 드라군과 정면 대결!',
        ),
        ScriptEvent(
          text: '{home} 선수 해처리 추가! 5해처리에서 히드라를 찍어냅니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -30, favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 계속 보충하면서 밀어붙입니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 드라군 추가! 사정거리 싸움!',
        ),
        ScriptEvent(
          text: '히드라 물량 vs 드라군 사정거리! 누가 이길까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          baseProbability: 2.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라 물량이 드라군을 압도합니다! 숫자가 다릅니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -5, favorsStat: 'attack',
              altText: '{home}, 히드라 물량! 드라군을 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라 편대가 프로토스 앞마당을 공격합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 후퇴하지만 병력 손실이 너무 큽니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '5해처리의 물량 차이가 결정적이었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드라군 사정거리로 히드라를 각개격파합니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -4, favorsStat: 'control',
              altText: '{away}, 드라군 마이크로! 히드라를 하나씩 잡습니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 히드라를 보충하지만 드라군 컨트롤에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -1,
            ),
            ScriptEvent(
              text: '드라군의 사정거리와 컨트롤이 히드라를 제압했습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
