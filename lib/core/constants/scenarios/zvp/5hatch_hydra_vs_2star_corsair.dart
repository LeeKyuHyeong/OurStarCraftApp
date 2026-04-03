part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 2스타게이트 커세어
// ----------------------------------------------------------
const _zvp5hatchHydraVs2starCorsair = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '5해처리 히드라 대공 vs 2스타게이트 커세어 물량',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑습니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설 후 게이트웨이를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 스타게이트를 2개 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 스타게이트 2개! 커세어를 대량 생산할 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 1: 커세어 공습 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 4기가 동시에 출격합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away}, 커세어 4기! 오버로드를 사냥합니다!',
        ),
        ScriptEvent(
          text: '{away}, 커세어 디스럽션 웹으로 오버로드를 격추합니다!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 오버로드 격추! 시야가 사라집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라로 대공 방어를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 히드라덴! 히드라로 커세어를 잡아야 합니다!',
        ),
        ScriptEvent(
          text: '커세어 물량이 히드라 생산 전에 오버로드를 얼마나 잡느냐가 관건!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 대공 사격!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15, favorsStat: 'defense',
        ),
      ],
    ),
    // Phase 2: 히드라 대공 vs 커세어 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 사정거리 업그레이드 완료! 커세어를 격추합니다!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: 2, favorsStat: 'control',
          altText: '{home}, 히드라 사업! 커세어가 접근할 수 없습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 해처리를 추가하며 5해처리 체제 완성!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 커세어로 견제하면서 지상군을 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 커세어 견제 유지! 드라군을 보충합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 대량 생산! 물량 차이가 벌어집니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25, favorsStat: 'macro',
          altText: '{home}, 5해처리에서 히드라가 쏟아집니다!',
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
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라 편대가 커세어를 전부 격추합니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home}, 히드라 사격! 커세어가 전멸합니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 프로토스 앞마당으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 지상군이 부족합니다! 커세어에 투자가 너무 컸습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '히드라의 대공 화력이 커세어를 완전히 제압했습니다!',
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
              text: '{away} 선수 커세어가 오버로드를 전멸시킵니다! 보급이 막힙니다!',
              owner: LogOwner.away,
              homeArmy: -3, homeResource: -15, favorsStat: 'harass',
              altText: '{away}, 오버로드 전멸! 저그 보급이 끊깁니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군 편대가 전진합니다! 히드라를 정면 돌파!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 보급 부족으로 병력 보충이 불가능합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '오버로드 사냥이 결정타! 프로토스가 승리합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
