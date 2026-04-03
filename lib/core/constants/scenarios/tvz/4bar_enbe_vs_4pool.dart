part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 4풀 — 공격형 vs 치즈
// ----------------------------------------------------------
const _tvz4barEnbeVs4pool = ScenarioScript(
  id: 'tvz_4bar_enbe_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4bar_enbe'],
  awayBuildIds: ['zvt_4pool'],
  description: '선엔베 4배럭 vs 4풀 — 공격형 빌드 vs 극초반 치즈',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 4기만에 스포닝풀! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀이 올라갑니다! 초반 러시 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 테란 본진을 향합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '4풀 저글링이 달려옵니다! 테란 본진이 위험할 수 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 저글링 침투 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 저글링이 테란 본진에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          favorsStat: 'harass',
          altText: '{away}, 저글링 6기가 본진 입구에 몰려옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 2기로 입구를 막습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV까지 동원해서 저글링을 잡습니다!',
          owner: LogOwner.home,
          homeResource: -5,
          awayArmy: -2,
          favorsStat: 'control',
          altText: '{home}, SCV와 마린이 협공으로 저글링을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 생산합니다! 계속 밀어야 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '입구에서 치열한 전투가 벌어지고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 4배럭 가동 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 추가합니다! 4배럭 체제로 전환!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭을 계속 올립니다! 마린 물량이 쏟아질 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 계속 나옵니다! 저글링을 막아내고 있어요!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 더 이상 들어가지 못합니다!',
          owner: LogOwner.away,
          awayArmy: -1,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '4풀이 막혔습니다! 이제 테란의 반격이 시작될까요!',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 물량이 쏟아집니다! 4배럭 가동!',
              owner: LogOwner.home,
              homeArmy: 5,
              homeResource: -15,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링만으로는 마린 물량을 못 막습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 저그 본진으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 마린 메딕 부대가 저그를 밀어냅니다!',
            ),
            ScriptEvent(
              text: '4풀을 막고 반격! 마린 물량에 저그가 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 입구를 뚫었습니다! SCV를 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeResource: -20,
              favorsStat: 'attack',
              altText: '{away}, 저글링이 일꾼을 잡아내고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 부족합니다! 일꾼 피해가 너무 크네요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 저글링이 합류합니다! 본진을 초토화시킵니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 저글링이 테란을 무너뜨렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
