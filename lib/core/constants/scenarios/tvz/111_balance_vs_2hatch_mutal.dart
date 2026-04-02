part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 2해처리 뮤탈: 레이스+터렛 vs 빠른 뮤탈 견제
// ----------------------------------------------------------
const _tvz111BalanceVs2hatchMutal = ScenarioScript(
  id: 'tvz_111_balance_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance', 'tvz_111'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '111 밸런스 vs 2해처리 뮤탈 — 레이스+터렛 대공 vs 빠른 뮤탈 물량',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리, 스타포트를 차례로 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 2해처리 체제로 드론을 빠르게 늘립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리 두 개로 자원을 빠르게 확보합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스가 나옵니다! 저그 진영 정찰!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 건설! 2해처리에서 뮤탈리스크를 대량 생산하려 합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어가 올라갑니다! 뮤탈 물량이 많을 겁니다!',
        ),
        ScriptEvent(
          text: '레이스가 스파이어를 확인했습니다! 뮤탈리스크 대비가 필요합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 뮤탈 견제 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 터렛을 세우면서 마인 연구를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 대편대가 출격합니다! 2해처리라 물량이 많습니다!',
          owner: LogOwner.away,
          awayArmy: 6,
          awayResource: -25,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크가 쏟아져 나옵니다! 2해처리 위력이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 마인을 깔면서 저글링 침투를 막습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 터렛 없는 곳을 찾아 급습합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크가 터렛 사각지대를 파고듭니다!',
        ),
        ScriptEvent(
          text: '뮤탈리스크 물량이 상당합니다! 터렛만으로 충분할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 마인필드 구축 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 마인을 대량으로 깝니다! 마인 필드 구축!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'strategy',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 배치하면서 방어 라인을 강화합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 계속 견제하면서 앞마당을 압박합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeResource: -10,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크 견제가 쉬지 않습니다!',
        ),
        ScriptEvent(
          text: '테란이 마인과 터렛으로 버텨낼 수 있을지가 관건입니다!',
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
              text: '{home} 선수 터렛과 레이스로 뮤탈리스크를 요격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{home}, 대공 화력이 뮤탈리스크를 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 마인 위로 저글링을 유인합니다! 마인 폭발!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 피해가 큽니다! 보충이 따라가지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '대공 방어 성공! 뮤탈 물량을 막아냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 터렛 사이를 뚫고 일꾼을 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -25,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크 견제가 치명적입니다! 일꾼 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 마인 필드를 우회해서 앞마당을 공격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 자원이 부족합니다! 병력 보충이 안 됩니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '2해처리 뮤탈 물량이 111 빌드를 압도했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
