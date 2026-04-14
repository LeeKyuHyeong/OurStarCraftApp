part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 하이브 디파일러 vs 프록시 게이트: 후반 올인 vs 초반 치즈
// ----------------------------------------------------------
const _zvpHiveDefilerVsProxyGate = ScenarioScript(
  id: 'zvp_hive_defiler_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hive_defiler', 'zvp_scourge_defiler', 'zvp_3hatch_nopool'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_8gat'],
  description: '하이브 디파일러 vs 프록시 게이트 — 후반 테크 vs 초반 치즈',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리를 올리며 드론 생산에 집중합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리부터 올리는 모습이네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 파일런을 상대 본진 근처에 숨겨놓습니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 게이트웨이 건설! 질럿 러시를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당 근처에 게이트웨이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 올리면서 드론을 계속 뽑고 있습니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '프로토스가 전진 게이트웨이를 올렸습니다! 저그가 발견할 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 질럿 공격 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 질럿 2기가 저그 본진에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 질럿이 저그 진영으로 돌진합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 소량으로 질럿을 막아봅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 질럿이 합류합니다! 드론을 노리고 있어요!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeResource: -15,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 드론까지 동원해 질럿을 잡으려 합니다!',
          owner: LogOwner.home,
          homeArmy: -1,
          homeResource: -10,
          favorsStat: 'control',
          altText: '{home}, 드론을 빼서 질럿을 둘러싸고 있습니다!',
        ),
        ScriptEvent(
          text: '질럿이 드론을 얼마나 잡느냐가 이 경기의 관건입니다!',
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
          text: '{home} 선수 성큰을 세워서 추가 질럿을 차단합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away} 선수 본진에서 사이버네틱스 코어를 올리고 있습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올리며 테크를 서두릅니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 레어가 올라갑니다! 빠르게 복구하려는 모습이네요.',
        ),
        ScriptEvent(
          text: '저그가 초반 치즈를 막아냈다면 하이브 테크로 갈 수 있습니다!',
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
              text: '{home} 선수 성큰과 저글링으로 질럿을 모두 잡아냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{home}, 성큰 화력이 질럿을 녹이고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 하이브를 올리며 디파일러 마운드를 건설하여 디파일러를 준비합니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeArmy: 2,
            ),
            ScriptEvent(
              text: '{away} 선수 후속 병력이 부족합니다! 치즈가 실패했어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '전진 질럿 러시 실패! 저그가 하이브 테크로 압도합니다! GG!',
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
              text: '{away} 선수 질럿이 드론을 대량으로 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -30,
              favorsStat: 'attack',
              altText: '{away}, 질럿이 일꾼 라인을 초토화시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 부족합니다! 드론 피해가 너무 큽니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 질럿으로 본진까지 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '전진 질럿이 저그를 무너뜨렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
