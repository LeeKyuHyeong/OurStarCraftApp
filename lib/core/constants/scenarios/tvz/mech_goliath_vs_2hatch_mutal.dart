part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 2해처리 뮤탈: 골리앗 대공 vs 빠른 뮤탈
// ----------------------------------------------------------
const _tvzMechGoliathVs2hatchMutal = ScenarioScript(
  id: 'tvz_mech_goliath_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath', 'tvz_3fac_goliath'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '메카닉 골리앗 vs 2해처리 뮤탈 — 골리앗 사거리 업 타이밍 vs 빠른 뮤탈 견제',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 가스를 빠르게 넣습니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 2해처리 체제! 앞마당 해처리를 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리 두 개로 드론 생산을 극대화합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 메카닉 체제 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 완성! 저글링 소량 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '테란은 팩토리, 저그는 빠른 뮤탈을 노리고 있습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 뮤탈 등장 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처를 생산하면서 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어가 빨리 올라갑니다! 2해처리 뮤탈리스크!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어 완성이 빠릅니다! 뮤탈리스크가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산을 시작합니다! 대공 준비!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 편대가 출격합니다! 테란 확장기지를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크가 빠르게 나왔습니다! 견제 시작!',
        ),
        ScriptEvent(
          text: '뮤탈리스크 타이밍이 골리앗보다 빠릅니다! 골리앗이 충분히 모일까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 골리앗 대응 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 터렛을 세우면서 골리앗을 모읍니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, 터렛과 골리앗으로 대공 방어를 구축합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 일꾼을 계속 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리에서 골리앗 사거리 업그레이드 연구!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '골리앗 사거리 업이 완성되면 뮤탈리스크가 접근하기 어려워집니다!',
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
              text: '{home} 선수 골리앗이 사거리 업 완료! 뮤탈리스크를 접근 전에 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{home}, 골리앗 화력이 뮤탈리스크를 격추시킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 피해가 큽니다! 스커지를 섞어보지만...',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크와 골리앗으로 저그 앞마당을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '골리앗 대공 화력이 뮤탈을 압도합니다! GG!',
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
              text: '{away} 선수 뮤탈리스크가 골리앗 합류 전에 일꾼을 초토화합니다!',
              owner: LogOwner.away,
              homeResource: -25,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크 견제가 치명적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗 수가 부족합니다! 뮤탈리스크를 막지 못해요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링까지 합류! 테란 확장기지가 무너집니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '빠른 뮤탈리스크가 메카닉 체제를 완성 전에 무너뜨렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
