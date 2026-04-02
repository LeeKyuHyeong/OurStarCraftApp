part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 커세어: 뮤탈 vs 커세어 + 저글링 런바이
// ----------------------------------------------------------
const _zvpMukerjiVsCorsair = ScenarioScript(
  id: 'zvp_mukerji_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '뮤탈과 저글링 vs 커세어+지상 — 오버로드 사냥 vs 저글링 런바이',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올리고 드론을 늘려갑니다.',
          owner: LogOwner.home,
          homeResource: 10,
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 건설합니다! 커세어 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스타게이트 건설! 커세어 체제로 전환합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 첫 기가 나옵니다! 저그 진영으로 향합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '커세어가 출격합니다! 오버로드 사냥이 시작될 겁니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 중반 전개 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 잡습니다! 저그 정찰력이 떨어집니다!',
          owner: LogOwner.away,
          homeResource: -10,
          favorsStat: 'harass',
          altText: '{away}, 오버로드 격추! 저그의 눈이 사라집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 완성! 뮤탈리스크 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 프로토스 확장기지 방향으로 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'harass',
          altText: '{home}, 저글링 런바이! 프로토스 뒤를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이에서 드라군을 추가 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '하늘에서는 커세어, 땅에서는 저글링! 서로 다른 전장!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 견제전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크가 프로토스 본진 일꾼을 기습합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크가 기습합니다! 일꾼 피해가 심각합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 뮤탈리스크를 추격합니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          awayArmy: 2,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 프로토스 앞마당 프로브를 잡아냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '뮤탈리스크는 본진을, 저글링은 앞마당을! 다방면 견제!',
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
          conditionStat: 'harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈과 저글링 동시 투입! 프로토스가 양쪽을 못 막습니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -4,
              favorsStat: 'harass',
              altText: '{home}, 다방면 공격! 프로토스 진영이 혼란에 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 뮤탈리스크를 쫓지만 저글링이 넥서스를 때립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: 2,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 프로토스 일꾼을 모두 잡아냅니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '뮤커지의 다면 공격이 프로토스를 무너뜨립니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 뮤탈리스크를 전멸시킵니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -5,
              favorsStat: 'control',
              altText: '{away}, 커세어 집중 공격! 뮤탈리스크가 전멸합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 사이버네틱스 코어의 드라군이 저글링을 막아내며 반격합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 공중 병력을 잃고 지상에서도 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '커세어와 드라군 조합이 뮤커지를 완벽히 봉쇄합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
