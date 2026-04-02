part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 2스타 커세어: 뮤탈 vs 커세어 공중전
// ----------------------------------------------------------
const _zvpMukerjiVs2starCorsair = ScenarioScript(
  id: 'zvp_mukerji_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '뮤탈과 저글링 vs 더블 스타게이트 커세어 — 공중 제공권 다툼',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 늘리며 앞마당 확장을 준비합니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 드론 풀가동! 앞마당 해처리도 건설 중입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트 2개를 연달아 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 더블 스타게이트! 커세어를 대량 생산할 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드를 시작합니다. 스파이어가 목표!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 첫 기가 나옵니다! 오버로드 사냥에 나섭니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '더블 스타게이트! 커세어 물량으로 제공권을 잡으려는 전략!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 공중전 전개 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 하나씩 잡아냅니다! 보급이 막힐 수 있어요!',
          owner: LogOwner.away,
          homeResource: -10,
          awayArmy: 2,
          favorsStat: 'harass',
          altText: '{away}, 오버로드 사냥! 저그 시야가 줄어듭니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 완성! 뮤탈리스크를 뽑기 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스커지를 섞어서 커세어에 대응합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          favorsStat: 'control',
          altText: '{home}, 스커지 생산! 커세어를 잡기 위한 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 편대가 뮤탈리스크를 추격합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -2,
          favorsStat: 'control',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '뮤탈리스크 vs 커세어! 하늘의 주인은 누구인가!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 지상 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크로 프로토스 일꾼을 견제합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크가 프로브를 찍고 빠집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어를 모아 뮤탈리스크를 쫓아냅니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          homeArmy: -2,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 대량 생산! 프로토스 확장기지를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '공중에서는 커세어, 지상에서는 저글링! 양면 작전이 펼쳐집니다!',
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
              text: '{home} 선수 스커지가 커세어 편대를 강타합니다!',
              owner: LogOwner.home,
              awayArmy: -5,
              homeArmy: -1,
              favorsStat: 'control',
              altText: '{home}, 스커지 돌진! 커세어가 한 번에 3기 폭발!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 자유롭게 프로토스 본진을 유린합니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 앞마당 넥서스를 때립니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '공중과 지상 동시 공격! 프로토스가 GG를 선언합니다!',
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
              altText: '{away}, 커세어 뉴트론 플레어! 뮤탈리스크가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 지상 병력도 합류! 사이버네틱스 코어의 드라군이 저글링을 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 공중 병력을 잃고 지상도 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '제공권 장악 완료! 커세어가 하늘을 지배합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
