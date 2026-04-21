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
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설 후 게이트웨이를 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 스타게이트를 2개 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 스타게이트 2개! 커세어를 대량 생산할 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣습니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 1: 커세어 공습 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 4기가 동시에 출격합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 5, awayResource: -25,
          altText: '{away} 선수, 커세어 4기! 오버로드를 사냥합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수, 커세어 디스럽션 웹으로 오버로드를 격추합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: -1, homeResource: -10,          altText: '{away} 선수 오버로드 격추! 시야가 사라집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라로 대공 방어를 준비합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수, 히드라덴! 히드라로 커세어를 잡아야 합니다!',
        ),
        ScriptEvent(
          text: '커세어 물량이 히드라 생산 전에 오버로드를 얼마나 잡느냐가 관건!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 대공 사격!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -15,        ),
      ],
    ),
    // Phase 2: 커세어 vs 히드라 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어로 계속 오버로드를 사냥합니다! 보급이 줄어듭니다!',
          owner: LogOwner.away,
          awayResource: 0,
          awayArmy: 3, homeArmy: -1, homeResource: -15,          altText: '{away} 선수, 커세어가 오버로드를 계속 격추합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 사정거리 업그레이드를 서두릅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -20,          altText: '{home} 선수, 히드라 사업 연구! 커세어를 아웃레인지합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 지상군도 모으며 전면전을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 드라군을 추가! 지상 전력도 보강합니다!',
        ),
        ScriptEvent(
          text: '커세어의 오버로드 사냥 vs 히드라의 대공 반격! 어느 쪽이 먼저인가!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라 편대가 커세어를 전부 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,              altText: '{home} 선수, 히드라 사격! 커세어가 전멸합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라가 프로토스 앞마당으로 진격합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3, awayArmy: -3,            ),
            ScriptEvent(
              text: '{away} 선수 지상군이 부족합니다! 커세어에 투자가 너무 컸습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '히드라의 대공 화력이 커세어를 완전히 제압했습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 오버로드를 전멸시킵니다! 보급이 막힙니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -3, homeResource: -15,              altText: '{away} 선수, 오버로드 전멸! 저그 보급이 끊깁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 드라군 편대가 전진합니다! 히드라를 정면 돌파!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 3, homeArmy: -3,            ),
            ScriptEvent(
              text: '{home} 선수 보급 부족으로 병력 보충이 불가능합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '오버로드 사냥이 결정타! 프로토스가 승리합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
