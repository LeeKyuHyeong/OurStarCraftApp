part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 2스타 커세어: 히드라 대공 vs 커세어 물량
// ----------------------------------------------------------
const _zvp973HydraVs2starCorsair = ScenarioScript(
  id: 'zvp_973_hydra_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra', 'zvp_973_hydra', 'zvp_9pool'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '973 히드라 vs 2스타 커세어 — 히드라 타이밍이 커세어 물량보다 빠르다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9서플라이에서 스포닝풀을 올리고 앞마당을 확보합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 9풀에 앞마당까지! 973 빌드의 시작입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 2개 건설합니다! 커세어 대량 생산 빌드!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 2스타게이트! 커세어를 빠르게 모으려는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설하며 히드라 타이밍을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 커세어 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '히드라의 대공 능력 vs 커세어의 공중 장악! 타이밍 경쟁이 시작됩니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 타이밍 경쟁 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 편대가 저그 진영으로 날아옵니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'harass',
          altText: '{away}, 커세어가 오버로드를 향해 출격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크가 생산되기 시작합니다! 대공 준비!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 오버로드를 2기 격추합니다!',
          owner: LogOwner.away,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크가 커세어를 향해 사격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -2,
          favorsStat: 'control',
          altText: '{home}, 히드라의 대공 사격! 커세어가 맞고 있습니다!',
        ),
        ScriptEvent(
          text: '히드라의 대공 화력이 커세어를 잡을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 커세어 지배 vs 히드라 대공 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 계속 사냥합니다! 시야가 줄어듭니다!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -1, homeResource: -15, favorsStat: 'harass',
          altText: '{away}, 오버로드가 계속 격추됩니다! 보급이 위험합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대를 모아서 프로토스 앞마당으로 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'attack',
          altText: '{home}, 히드라 타이밍 어택! 커세어 투자로 지상이 약합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이의 질럿과 캐논으로 수비를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '히드라 타이밍 vs 커세어의 오버로드 사냥! 무엇이 먼저 효과를 낼까요?',
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
              text: '{home} 선수 히드라 부대가 프로토스 앞마당을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 히드라가 캐논을 넘어서 진입합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 지상 병력이 부족합니다! 커세어만으로는 막을 수 없어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 넥서스를 공격합니다! 일꾼도 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '히드라 타이밍 성공! 커세어로는 지상을 막을 수 없었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논과 질럿으로 히드라 공격을 저지합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 캐논 화력이 히드라를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어로 오버로드를 전멸시킵니다! 시야가 사라졌어요!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -1,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 손실이 큽니다! 후속 타이밍이 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '히드라 타이밍 실패! 커세어의 공중 장악이 승리를 가져옵니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
