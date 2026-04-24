part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 커세어 + 지상군
// ----------------------------------------------------------
const _zvp5hatchHydraVsCorsair = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '5해처리 히드라 vs 커세어 오버로드 사냥 + 지상군',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 9개까지 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
          altText: '{home} 선수, 9드론까지 생산합니다.',
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
          text: '{home} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어에서 스타게이트를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 스타게이트! 커세어를 준비합니다!',
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
    // Phase 1: 커세어 견제 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 오버로드를 사냥하러 출발합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 커세어 출격! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수, 커세어가 오버로드 2기를 격추합니다! 시야가 제한됩니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: -1, homeResource: -10,          altText: '{away} 선수 오버로드 격추! 저그 시야가 줄어듭니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설합니다! 히드라로 대공을 준비!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 히드라덴! 커세어를 잡으려면 히드라가 필요합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 해처리를 추가합니다! 물량 체제를 향해!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '오버로드를 지키느냐 빼앗기느냐! 보급 관리가 중요합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 히드라 생산 + 오버로드 방어 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 생산합니다! 오버로드 호위!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -20,          altText: '{home} 선수, 히드라가 오버로드를 지킵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 견제를 유지하면서 지상군을 모읍니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 드라군과 질럿을 보충합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 대량 생산! 해처리 전부 가동!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -25,          altText: '{home} 선수, 히드라가 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 스톰을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 아둔에서 템플러 아카이브! 스톰 연구!',
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
              text: '{home} 선수 히드라 편대가 커세어를 격추하고 전진합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3, homeArmy: 2,              altText: '{home} 선수, 히드라 사격! 커세어가 떨어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라 물량이 프로토스 진지를 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,            ),
            ScriptEvent(
              text: '{away} 선수 스톰이 아직 완성되지 않았습니다! 히드라를 막을 수 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '스톰 완성 전에 히드라가 도착했습니다! 저그의 승리!',
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
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 오버로드를 전멸시켰습니다! 보급이 막힙니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -2, homeResource: -15,              altText: '{away} 선수, 오버로드 전멸! 저그가 병력을 뽑을 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 하이 템플러 합류! 스톰이 히드라를 강타합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5,              altText: '{away} 선수 스톰이 저그 병력을 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 보충이 안 됩니다! 보급과 자원이 부족!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '커세어의 오버로드 사냥과 스톰이 결정타였습니다!',
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
