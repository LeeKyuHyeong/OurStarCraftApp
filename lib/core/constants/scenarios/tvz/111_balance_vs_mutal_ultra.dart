part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 111 밸런스 vs 뮤탈 울트라: 레이스 vs 뮤탈, 마인 vs 울트라
// ----------------------------------------------------------
const _tvz111BalanceVsMutalUltra = ScenarioScript(
  id: 'tvz_111_balance_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_111_balance'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '111 밸런스 vs 뮤탈 울트라 — 레이스 정찰+벌처 마인 vs 뮤탈 견제+울트라 돌진',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭, 팩토리, 스타포트 순서로 건설합니다. 111 빌드!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 111 빌드를 올립니다! 균형잡힌 테크입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올리면서 드론을 늘립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에서 레이스를 생산합니다! 정찰 나갑니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
          altText: '{home}, 레이스가 나왔습니다! 저그 진영을 확인합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 완성 후 스파이어를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란 레이스가 저그 빌드를 확인하러 갑니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 뮤탈 vs 레이스 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스가 스파이어를 확인합니다! 뮤탈리스크가 나올 것을 파악!',
          owner: LogOwner.home,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 출격합니다! 레이스를 쫓아냅니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'control',
          altText: '{away}, 뮤탈리스크 편대가 레이스를 추격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 마인을 깔면서 저글링 견제를 차단합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크로 테란 일꾼을 견제합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 세우면서 시즈탱크를 배치합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, 터렛과 시즈탱크로 수비 체제를 갖춥니다!',
        ),
      ],
    ),
    // Phase 2: 울트라 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 울트라리스크 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 하이브 테크! 울트라리스크가 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 마인을 대량으로 깔면서 울트라 돌진을 대비합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 울트라리스크 등장! 저글링과 함께 돌진 준비!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '마인 필드가 울트라 돌진을 막을 수 있을지가 이 경기의 분수령!',
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
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 마인이 울트라리스크 앞에서 연쇄 폭발합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home}, 마인 필드에 울트라리스크가 걸렸습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크 포격으로 남은 저글링을 정리합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크로 역습을 시도하지만 터렛에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '마인+시즈탱크 조합이 울트라를 저지했습니다! GG!',
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
              text: '{away} 선수 울트라리스크가 마인을 밟으며 돌진합니다! 체력이 남았습니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away}, 울트라리스크가 마인 필드를 돌파합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 시즈탱크 후방을 공격합니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              homeResource: -15,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크가 밟혔습니다! 방어선이 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '울트라+뮤탈 양면 공격에 111 빌드가 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
