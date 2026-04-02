part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 아콘: 뮤탈 견제 + 크래클링 vs 아콘과 질럿+스톰
// ----------------------------------------------------------
const _zvpMukerjiVsArchon = ScenarioScript(
  id: 'zvp_mukerji_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji', 'zvp_mukerji'],
  awayBuildIds: ['pvz_trans_archon', 'pvz_corsair_reaver'],
  description: '뮤탈+크래클링 vs 아콘과 질럿+사이오닉 스톰 — 견제 vs 한방',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설하고 드론을 풀가동합니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 드론 생산에 집중! 앞마당이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 뒤로 아둔을 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 게이트웨이 뒤에 아둔 건설! 하이 템플러를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀에서 저글링 생산 후 레어 업그레이드! 스파이어를 올립니다.',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
          altText: '{home}, 스포닝풀 완성 후 레어와 스파이어를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 템플러 아카이브까지 건설! 아콘과 스톰 체제!',
          owner: LogOwner.away,
          awayResource: -15,
          awayArmy: 2,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '프로토스가 후반 한방 병력을 준비합니다! 하이 템플러와 아콘!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 뮤탈 견제 vs 테크업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 3기가 나옵니다! 프로토스 본진으로!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크 출격! 프로브 사냥에 나섭니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크가 프로브를 잡습니다! 자원 확보를 방해!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 하이 템플러가 나옵니다! 아콘 합체를 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'strategy',
          altText: '{away}, 하이 템플러 합체! 아콘이 탄생합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 업그레이드를 완료합니다! 크래클링 전환!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '뮤탈리스크 견제 vs 아콘 완성! 시간 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결전 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 아콘과 질럿 편대를 이끌고 저그 진영으로 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 아콘이 선두에 섭니다! 결전 병력 출발!',
        ),
        ScriptEvent(
          text: '{home} 선수 크래클링을 대량 생산합니다! 측면 돌파를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -10,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크로 프로토스 확장기지를 견제합니다!',
          owner: LogOwner.home,
          awayResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '아콘 스톰 조합 vs 뮤탈 크래클링 조합! 대규모 교전이 임박합니다!',
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
          conditionStat: 'control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 크래클링이 아콘을 우회해 프로브를 잡습니다!',
              owner: LogOwner.home,
              awayResource: -20,
              homeArmy: 3,
              favorsStat: 'control',
              altText: '{home}, 크래클링이 아콘을 피해 뒤로 돌아갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 하이 템플러를 집중 공격합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 스톰을 쓰지만 크래클링이 너무 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '뮤탈과 크래클링의 속도전! 프로토스 병력이 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'attack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 사이오닉 스톰이 저글링 뭉치를 강타합니다!',
              owner: LogOwner.away,
              homeArmy: -6,
              favorsStat: 'attack',
              altText: '{away}, 스톰! 크래클링이 한 번에 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘이 뮤탈리스크를 스플래시로 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 병력이 전멸합니다! 재생산할 자원도 부족해요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '아콘과 사이오닉 스톰, 한방 병력의 위력! 저그가 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
