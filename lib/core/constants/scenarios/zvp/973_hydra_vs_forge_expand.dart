part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 포지 확장: 공격형 vs 수비형 클래식 ZvP
// ----------------------------------------------------------
const _zvp973HydraVsForgeExpand = ScenarioScript(
  id: 'zvp_973_hydra_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_trans_forge_expand'],
  description: '973 히드라 vs 포지 확장 — 히드라 타이밍으로 캐논 라인을 돌파한다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9풀로 스포닝풀을 올립니다! 973 히드라 빌드!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀 오프닝! 빠른 히드라를 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 올리고 앞마당 넥서스를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 포지 확장! 캐논으로 앞마당을 지키며 확장합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논 2기를 세워 앞마당을 안전하게 지킵니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당을 확보하고 히드라덴을 건설합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '973 히드라 타이밍 vs 포지 확장! 공격과 수비의 대결입니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 히드라 생산 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 대량 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 히드라가 물밀 듯이 생산됩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿과 캐논 라인으로 수비를 강화합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대를 모아서 프로토스로 출격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가하며 드라군 생산을 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '히드라 타이밍 어택! 캐논 라인을 뚫을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 캐논 라인 공방 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라가 캐논 사거리 밖에서 공격을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -1,
          favorsStat: 'attack',
          altText: '{home}, 히드라가 캐논을 아웃레인지합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿을 앞으로 보내 히드라를 끊으려 합니다.',
          owner: LogOwner.away,
          awayArmy: 1,
          homeArmy: -1,
          favorsStat: 'control',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 커세어를 생산해서 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '캐논 라인이 무너지면 프로토스는 크게 위험합니다!',
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
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라가 캐논 라인을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 히드라 화력이 캐논을 부숩니다! 돌파 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 앞마당 넥서스를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -30,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당이 무너집니다! 후속 테크가 늦었어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '히드라 타이밍으로 포지 확장을 박살냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논과 질럿, 드라군이 히드라를 저지합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'defense',
              altText: '{away}, 질럿이 히드라를 붙잡고 캐논이 마무리합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어로 시야를 장악하며 반격을 준비합니다.',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -15,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 타이밍이 실패했습니다! 자원도 바닥입니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '포지 확장의 수비 성공! 히드라 타이밍을 막아냈습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
