part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 하이브 디파일러 vs 아콘 질럿: 울트라+디파일러 vs 아콘+질럿
// ----------------------------------------------------------
const _zvpHiveDefilerVsArchon = ScenarioScript(
  id: 'zvp_hive_defiler_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hive_defiler'],
  awayBuildIds: ['pvz_trans_archon'],
  description: '하이브 디파일러 vs 아콘 질럿 — 다크 스웜으로 아콘 사거리를 차단한다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올리며 자원 확보에 나섭니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 기본 테크 건물을 빠르게 올리는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성 후 저글링을 소량 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 아둔을 건설합니다! 템플러 테크를 올리는군요!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 아둔이 올라갑니다! 하이템플러 길이네요.',
        ),
        ScriptEvent(
          text: '프로토스가 템플러 테크를 선택했습니다. 아콘이 나오겠네요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 테크 경쟁 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 템플러 아카이브를 건설합니다! 하이템플러 생산 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올리며 하이브를 향한 테크 트리를 탑니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 레어를 올립니다! 하이브까지 가야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이템플러 2기를 합체! 아콘이 탄생합니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -20,
          favorsStat: 'strategy',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 생산하며 중반 수비를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '아콘의 강력한 화력! 저그가 디파일러 없이 상대할 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 하이브 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이브를 건설합니다! 디파일러가 곧 나옵니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 하이브가 올라갑니다! 울트라리스크도 기대되네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 아콘과 질럿을 모아서 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 울트라리스크 동굴을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '울트라리스크와 디파일러가 합류하면 저그의 후반이 강해집니다!',
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
              text: '{home} 선수 다크 스웜을 깔아줍니다! 아콘의 사거리 공격이 차단됩니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -2,
              favorsStat: 'strategy',
              altText: '{home}, 다크 스웜! 아콘이 공격을 못 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 울트라리스크가 아콘을 향해 돌진합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘이 다크 스웜 안에서 무력화됩니다! 질럿도 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '다크 스웜이 아콘을 완벽 봉쇄! 울트라가 짓밟습니다! GG!',
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
              text: '{away} 선수 아콘의 스플래시 데미지가 저글링을 녹입니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 아콘 한 방에 저글링이 전멸합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 저그 진영으로 밀고 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 디파일러가 나오기 전에 병력이 소진되었습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '아콘의 화력 앞에 저그가 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
