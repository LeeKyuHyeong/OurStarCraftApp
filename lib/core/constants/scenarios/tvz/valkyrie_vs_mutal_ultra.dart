part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 뮤탈 울트라 — 스플래시 대공 vs 지상 전환
// ----------------------------------------------------------
const _tvzValkyrieVsMutalUltra = ScenarioScript(
  id: 'tvz_valkyrie_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '발키리 스플래시 대공 vs 뮤탈리스크 울트라리스크 전환',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 안정적으로 앞마당부터 확장합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 스타포트를 향한 테크!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 팩토리가 올라갑니다! 발키리를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 드론을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린으로 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크 레이스 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설합니다! 컨트롤타워까지!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타포트에 컨트롤타워를 붙입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리고 스파이어 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 발키리 생산을 시작합니다! 대공 스플래시!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 편대 생산! 견제 나갑니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          altText: '{away}, 뮤탈리스크가 나왔습니다! 견제 시작!',
        ),
        ScriptEvent(
          text: '발키리 vs 뮤탈리스크! 공중 대전이 예고됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공중전 + 울트라 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 발키리가 뮤탈 편대를 요격합니다! 스플래시!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -4,
          favorsStat: 'control',
          altText: '{home}, 발키리 스플래시가 뮤탈을 녹입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 울트라리스크 전환!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 추가 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '뮤탈이 발키리에 막히고 있습니다! 저그가 울트라로 전환합니다!',
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
              text: '{home} 선수 발키리가 뮤탈 편대를 완전히 소탕합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 발키리 스플래시에 뮤탈이 전멸합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕으로 지상군도 확보합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 울트라가 나오기 전에 밀립니다! 병력이 부족해요!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '발키리가 제공권을 장악! 울트라 전에 승부를 결정짓습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 등장합니다! 지상이 뚫립니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -25,
              favorsStat: 'macro',
              altText: '{away}, 울트라리스크가 나왔습니다! 마린이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리로는 울트라를 잡을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수 울트라가 테란 진영을 돌파합니다! 발키리가 무용지물!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              homeResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라 전환 성공! 대공은 무의미했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
