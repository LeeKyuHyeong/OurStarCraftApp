part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 하이브 디파일러 vs 포지 확장: 클래식 ZvP 후반전
// ----------------------------------------------------------
const _zvpHiveDefilerVsForgeExpand = ScenarioScript(
  id: 'zvp_hive_defiler_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hive_defiler', 'zvp_scourge_defiler', 'zvp_3hatch_nopool'],
  awayBuildIds: ['pvz_trans_forge_expand', 'pvz_forge_cannon'],
  description: '하이브 디파일러 vs 포지 확장 — 다크 스웜 vs 사이오닉 스톰, 클래식 후반전',
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
          altText: '{home}, 해처리부터 올리는 안정적인 시작입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 올리고 넥서스 확장을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 포지 확장! 국룰 빌드를 선택했습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 올리고 드론 생산을 계속합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 캐논을 세우고 게이트웨이와 사이버네틱스 코어를 올리며 앞마당을 확보합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 게이트웨이와 사이버네틱스 코어! 캐논과 함께 앞마당을 지킵니다.',
        ),
        ScriptEvent(
          text: '양측 모두 확장을 선택했습니다! 장기전이 예상됩니다.',
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
          text: '{home} 선수 3번째 해처리를 올리며 자원 수급을 극대화합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          favorsStat: 'macro',
          altText: '{home}, 3해처리 체제! 자원이 풍부해지겠네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트에서 커세어를 생산하며 오버로드 사냥을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올리며 하이브를 향한 테크를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 건설합니다! 스톰 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'strategy',
          altText: '{away}, 템플러 아카이브가 올라갑니다! 사이오닉 스톰이 곧 나오겠네요.',
        ),
        ScriptEvent(
          text: '양측 모두 후반 핵심 테크를 올리고 있습니다! 후반 대전이 기대됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 후반 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이브를 완성하고 디파일러 마운드에서 디파일러를 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -25,
          altText: '{home}, 디파일러 마운드 완성! 디파일러가 나왔습니다! 다크 스웜 준비 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이템플러를 생산합니다! 사이오닉 스톰 준비!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 4번째 해처리를 올리며 순환 병력을 늘립니다.',
          owner: LogOwner.home,
          homeResource: 15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 퀸즈네스트와 하이브 업그레이드를 준비합니다! 최종 테크를 향해 달립니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
          altText: '{home}, 하이브 테크! 최종 병기를 향해 올라가는군요!',
        ),
        ScriptEvent(
          text: '다크 스웜 vs 사이오닉 스톰! ZvP 후반전의 꽃이 피려 합니다!',
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
              text: '{home} 선수 디파일러가 다크 스웜을 넓게 깔아줍니다! 원거리 공격이 무력화됩니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -2,
              favorsStat: 'strategy',
              altText: '{home}, 다크 스웜! 프로토스 원거리 유닛이 무력화됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 울트라리스크 캐번에서 울트라리스크가 출격! 저글링과 프로토스 진영을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 사이오닉 스톰을 쓰지만 다크 스웜 안 유닛은 잡을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '다크 스웜이 스톰을 이겼습니다! 저그의 후반 파워! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 사이오닉 스톰이 저글링 무리를 전멸시킵니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -5,
              favorsStat: 'strategy',
              altText: '{away}, 스톰 투하! 저그 병력이 한 방에 녹아버렸습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군과 질럿이 다크 스웜 밖에서 포지션을 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 대형 유닛이 고립됩니다! 지원 병력이 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '스톰의 위력! 프로토스 한방 병력이 저그를 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
