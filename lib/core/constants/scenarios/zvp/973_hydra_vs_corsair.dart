part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 커세어 지상군: 히드라 타이밍 vs 커세어+지상 빌드업
// ----------------------------------------------------------
const _zvp973HydraVsCorsair = ScenarioScript(
  id: 'zvp_973_hydra_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra', 'zvp_973_hydra', 'zvp_9pool'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '973 히드라 vs 커세어 지상군 — 히드라 타이밍으로 빌드업을 끊는다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9풀 오프닝! 스포닝풀을 올리고 앞마당을 확보합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 973 빌드! 빠른 히드라를 노리는군요.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 올리고 스타게이트를 건설합니다! 커세어를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 게이트웨이 뒤로 스타게이트가 올라갑니다! 커세어 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설하며 히드라 타이밍을 노립니다.',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어를 생산하며 지상군도 함께 모읍니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          altText: '{away}, 커세어와 함께 사이버네틱스 코어에서 드라군을 생산합니다.',
        ),
        ScriptEvent(
          text: '커세어 빌드업이 완성되기 전에 히드라가 들어갈 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 히드라 타이밍 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크 대량 생산! 타이밍 어택!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 히드라가 쏟아집니다! 프로토스를 향해 출격!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어로 오버로드 사냥을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대가 프로토스 앞마당에 접근합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군과 게이트웨이의 질럿으로 수비 라인을 형성합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'defense',
          altText: '{away}, 질럿과 드라군이 앞마당 앞에 진을 칩니다!',
        ),
        ScriptEvent(
          text: '히드라 타이밍! 커세어 빌드가 완성되기 전에 끝낼 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공방전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라가 캐논을 사거리 밖에서 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -1,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어와 지상군이 합류하기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'macro',
          altText: '{away}, 커세어가 돌아와서 지상군과 합동 작전!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 측면에서 투입해 프로토스를 압박합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '타이밍 어택의 성패가 갈리는 순간입니다!',
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
              text: '{home} 선수 히드라가 캐논과 드라군을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home}, 히드라 화력이 프로토스 수비를 뚫었습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어만으로는 히드라 지상 공격을 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 넥서스를 직접 공격! 프로토스가 무너지고 있어요!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '히드라 타이밍 성공! 빌드업 완성 전에 끝냈습니다! GG!',
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
              text: '{away} 선수 드라군과 캐논으로 히드라를 저지합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'defense',
              altText: '{away}, 드라군 집중 사격! 히드라가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 오버로드를 전부 격추합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -1,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 타이밍이 실패했습니다! 후속 전력이 없어요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '타이밍 어택 실패! 커세어와 지상군이 완성됩니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
