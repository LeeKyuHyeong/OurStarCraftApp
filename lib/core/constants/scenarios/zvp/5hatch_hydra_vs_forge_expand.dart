part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 포지 더블 (국룰)
// ----------------------------------------------------------
const _zvp5hatchHydraVsForgeExpand = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_trans_forge_expand', 'pvz_forge_cannon'],
  description: '5해처리 히드라 타이밍 vs 포지 더블 캐논 수비',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지를 올리고 앞마당 확장을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스 건설! 게이트웨이로 입구를 막습니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스와 캐논! 앞마당 방어를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '국룰 구도! 저그 타이밍 어택이냐 캐논 수비냐!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 히드라 타이밍 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 속업 사업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 히드라덴! 업그레이드를 서둡니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 해처리를 추가합니다! 물량 체제 가동!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 캐논을 앞마당 입구에 추가 건설합니다! 방어 강화!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20, favorsStat: 'defense',
          altText: '{away}, 캐논 추가! 히드라를 막을 수 있을까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어에서 스타게이트를 올립니다! 커세어!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 사이버네틱스 코어에서 스타게이트! 커세어로 오버로드를 사냥합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 대량 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20, favorsStat: 'macro',
          altText: '{home}, 히드라가 쏟아집니다!',
        ),
      ],
    ),
    // Phase 2: 히드라 진격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 편대가 프로토스 앞마당으로 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 5, favorsStat: 'attack',
          altText: '{home}, 히드라 행군! 캐논 라인을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어로 오버로드를 격추합니다!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home}, 히드라가 캐논 사정거리 밖에서 대기합니다! 업그레이드를 기다립니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'strategy',
          altText: '{home} 선수 히드라 집결! 사업 완성을 기다립니다!',
        ),
        ScriptEvent(
          text: '히드라 사업이 완성되면 캐논 사정거리 밖에서 공격할 수 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
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
              text: '{home} 선수 히드라 사업 완성! 캐논 라인을 무너뜨립니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home}, 히드라 사격! 캐논이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 앞마당 넥서스까지 공격합니다!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿과 드라군으로 방어하지만 물량이 부족!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '히드라가 캐논 벽을 돌파했습니다! 앞마당이 무너집니다!',
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
              text: '{away} 선수 캐논과 질럿으로 히드라를 막아냅니다! 수비 성공!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away}, 캐논 라인이 히드라를 저지합니다!',
            ),
            ScriptEvent(
              text: '{away}, 하이 템플러 합류! 스톰이 히드라를 강타합니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 저그 병력을 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군 질럿 한방 병력으로 역공합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '캐논 수비에 성공한 프로토스가 역공으로 마무리합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
