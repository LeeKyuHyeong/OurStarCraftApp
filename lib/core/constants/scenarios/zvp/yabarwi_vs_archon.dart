part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 야바위 vs 아콘: 다면 기만 공격 vs 아콘과 스톰 방어
// ----------------------------------------------------------
const _zvpYabarwiVsArchon = ScenarioScript(
  id: 'zvp_yabarwi_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_yabarwi', 'zvp_yabarwi'],
  awayBuildIds: ['pvz_trans_archon', 'pvz_corsair_reaver'],
  description: '야바위 다면 기만 공격 vs 아콘과 질럿+스톰 방어 — 분산 vs 집중',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설하며 자원을 확보합니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 앞마당 해처리 건설! 드론 생산 집중!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 뒤에 아둔을 건설합니다! 하이 템플러 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 게이트웨이와 아둔 건설! 템플러 아카이브로 이어집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 올립니다. 럴커를 만들 준비!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 템플러 아카이브 완성! 하이 템플러 생산을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '프로토스가 하이 템플러와 아콘 체제를 준비합니다! 강력한 후반 병력!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 야바위 견제 시작 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 프로토스 센터 쪽으로 보냅니다! 가짜 공격!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
          altText: '{home}, 저글링 기습! 하지만 이것은 페이크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러를 합체! 아콘이 탄생합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'strategy',
          altText: '{away}, 아콘 합체! 스플래시 공격이 준비됩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 럴커를 생산합니다! 히드라리스크와 합류!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 양쪽으로 분산! 어디가 본공격인가!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'harass',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '야바위 전술이 시작됩니다! 아콘과 스톰이 이걸 막아낼 수 있을까!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 본격 교전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 아콘과 질럿 편대를 이끌고 진군합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 아콘이 선봉에 섭니다! 결전 병력 출발!',
        ),
        ScriptEvent(
          text: '{home} 선수 3방향에서 동시에 저글링과 럴커를 투입합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러가 스톰을 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'sense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '다면 공격 vs 스톰! 분산과 집중의 대결!',
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
          conditionStat: 'strategy',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커가 아콘을 우회해 프로브를 잡습니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'strategy',
              altText: '{home}, 럴커가 방어선을 뚫고 일꾼을 공격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 3방향에서 동시 돌격! 스톰이 분산됩니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -4,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 스톰을 한 곳에만 쓸 수 있습니다! 나머지가 뚫려요!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '야바위의 다면 공격이 아콘과 스톰을 분산시킵니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'sense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스톰이 저글링 뭉치를 정확히 강타합니다!',
              owner: LogOwner.away,
              homeArmy: -6,
              favorsStat: 'sense',
              altText: '{away}, 사이오닉 스톰! 저글링이 한 번에 전멸합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘의 스플래시가 럴커까지 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 분산 공격이 모두 막혔습니다! 재생산할 여력이 없어요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '아콘과 스톰의 범위 공격! 야바위가 통하지 않았습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
