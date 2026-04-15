part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 하이브 디파일러 vs 2스타게이트 커세어: 스커지 수비가 관건
// ----------------------------------------------------------
const _zvpHiveDefilerVs2starCorsair = ScenarioScript(
  id: 'zvp_hive_defiler_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hive_defiler', 'zvp_scourge_defiler', 'zvp_3hatch_nopool'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '하이브 디파일러 vs 2스타 커세어 — 오버로드 사냥 vs 스커지 수비',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올리며 드론을 늘립니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스 뒤에 스타게이트를 2개 건설합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 스타게이트가 2개 올라갑니다! 커세어를 대량 생산하려는 모습!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성 후 레어를 올리기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 커세어 생산을 시작합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '프로토스가 2스타게이트 커세어를 선택했습니다! 공중 장악이 목표겠죠.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 커세어 사냥 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 편대가 저그 진영으로 출격합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'harass',
          altText: '{away}, 커세어가 오버로드를 향해 날아갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 오버로드 2기를 격추합니다! 시야가 줄어듭니다!',
          owner: LogOwner.away,
          homeArmy: -1,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어를 올립니다! 스커지로 대응할 준비를 합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'macro',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 스커지를 생산해서 커세어를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'control',
          altText: '{home}, 스커지가 커세어를 향해 돌진합니다!',
        ),
        ScriptEvent(
          text: '스커지와 커세어의 공중전! 컨트롤 싸움이 시작됩니다!',
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
          text: '{home} 선수 하이브를 올립니다! 디파일러 테크를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 하이브가 올라갑니다! 디파일러가 곧 나오겠네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어로 계속 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 퀸즈네스트를 건설하며 디파일러를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '디파일러의 플레이그가 나오면 커세어 편대가 위험해집니다!',
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
              text: '{home} 선수 디파일러가 완성됩니다! 플레이그를 커세어에 뿌립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 플레이그! 커세어 편대가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 플레이그에 큰 피해를 입습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 울트라리스크와 저글링이 프로토스 진영을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '디파일러의 활약! 커세어가 무력화되고 저그가 밀어냅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 오버로드를 전멸시킵니다! 저그 시야가 사라졌어요!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'harass',
              altText: '{away}, 오버로드가 전부 격추됩니다! 시야가 완전히 사라졌네요!',
            ),
            ScriptEvent(
              text: '{away} 선수 게이트웨이와 템플러 아카이브를 거친 하이템플러가 합류합니다! 사이오닉 스톰!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home} 선수 디파일러 마운드의 디파일러가 나오기 전에 병력이 녹아버렸습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '커세어의 시야 장악! 프로토스가 경기를 가져갑니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
