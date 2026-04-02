part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 메카닉 골리앗 vs 뮤탈 울트라: 골리앗 대공 vs 뮤탈, 시즈탱크 vs 울트라
// ----------------------------------------------------------
const _tvzMechGoliathVsMutalUltra = ScenarioScript(
  id: 'tvz_mech_goliath_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '메카닉 골리앗 vs 뮤탈 울트라 — 골리앗 사거리 업 vs 뮤탈+울트라 조합',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 팩토리를 빠르게 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 해처리를 올리면서 드론을 늘립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장부터 가져갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 벌처 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 팩토리가 완성됐습니다! 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 완성 후 저글링으로 정찰합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '테란이 메카닉 체제를 준비하고 있습니다.',
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
          text: '{home} 선수 머신샵 추가! 시즈모드 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 시즈탱크 준비에 들어갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 완성! 뮤탈리스크 생산 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -25,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 추가하면서 골리앗 생산 체제를 갖춥니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 테란 일꾼을 견제합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈리스크가 테란 확장기지를 급습합니다!',
        ),
        ScriptEvent(
          text: '골리앗 사거리 업그레이드가 관건이 되겠습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리에서 골리앗 사거리 업그레이드 시작!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 후반 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 부대가 시즈탱크와 함께 라인을 형성합니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 울트라리스크 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브가 올라갑니다! 울트라리스크가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 울트라리스크 생산 시작! 뮤탈리스크와 함께 투탑 체제!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '골리앗이 뮤탈을 잡고, 시즈탱크가 울트라를 잡을 수 있을까요?',
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
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗 사거리 업 완료! 뮤탈리스크를 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 골리앗이 뮤탈리스크를 집중 사격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크 포격으로 울트라리스크를 저지합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 녹아내립니다! 울트라도 접근이 어렵습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '메카닉 화력이 저그 병력을 압도합니다! GG!',
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
              text: '{away} 선수 뮤탈리스크가 골리앗 라인 뒤를 급습합니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크가 시즈탱크 후방을 파고듭니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 시즈탱크 라인을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 고립됩니다! 시즈탱크도 밟혔습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '울트라리스크가 메카닉 라인을 부숩니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
