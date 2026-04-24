part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 아콘 + 질럿
// ----------------------------------------------------------
const _zvp5hatchHydraVsArchon = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_trans_archon', 'pvz_corsair_reaver'],
  description: '5해처리 히드라 물량 vs 하이 템플러 아콘 합체',
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
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 자원을 챙깁니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 아둔을 향합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away} 선수, 사이버네틱스 코어 완성! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣으면서 테크를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 아둔에서 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 템플러 아카이브! 아콘을 향한 테크!',
        ),
      ],
    ),
    // Phase 1: 히드라 생산 vs 아콘 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라리스크 생산 시작!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -20,
          altText: '{home} 선수, 히드라덴! 히드라를 뽑기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 해처리를 추가합니다! 물량을 늘립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러 2기 생산! 아콘 합체를 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -25,          altText: '{away} 선수, 하이 템플러! 아콘으로 합체할까요?',
        ),
        ScriptEvent(
          text: '{away} 선수, 하이 템플러가 아콘으로 합체합니다! 강력한 화력!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 3,
          altText: '{away} 선수 아콘 합체! 범위 공격이 위협적입니다!',
        ),
        ScriptEvent(
          text: '아콘의 범위 공격은 히드라에게 치명적입니다! 스톰 전에 밀어야 합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 타이밍 공격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 히드라를 쏟아냅니다! 물량이 압도적! 지금 밀어야 합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -30,          altText: '{home} 선수, 히드라 대량 생산! 타이밍 공격!',
        ),
        ScriptEvent(
          text: '{home} 선수, 히드라 편대가 프로토스 진지를 향해 전진합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 2,        ),
        ScriptEvent(
          text: '{away} 선수 아콘과 질럿으로 방어진을 구축합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수, 아콘 앞에 질럿 벽! 수비 태세!',
        ),
        ScriptEvent(
          text: '스톰이 완성되면 히드라에게 악몽입니다! 시간과의 싸움!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
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
              text: '{home} 선수 히드라 물량으로 아콘을 집중 사격합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4, homeArmy: -2,              altText: '{home} 선수, 히드라 집중 사격! 아콘이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 질럿까지 쓸어버립니다! 히드라 물량이 압도적!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '{away} 선수 스톰을 쓰지만 히드라 분산으로 피해가 적습니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,            ),
            ScriptEvent(
              text: '스톰 완성 전에 히드라가 밀어붙였습니다! 타이밍 승리!',
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
              text: '{away} 선수 스톰이 히드라 편대에 떨어집니다! 대참사!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -6,              altText: '{away} 선수, 스톰이 저그 병력을 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 아콘이 남은 히드라를 범위 공격으로 정리합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,            ),
            ScriptEvent(
              text: '{home} 선수 병력이 전멸합니다! 스톰이 너무 강했습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '아콘이 앞장서고 스톰이 뒤를 받칩니다! 프로토스의 완벽한 수비!',
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
