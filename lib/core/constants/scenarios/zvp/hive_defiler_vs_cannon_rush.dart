part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 하이브 디파일러 vs 캐논 러시: 후반 파워 vs 초반 치즈
// ----------------------------------------------------------
const _zvpHiveDefilerVsCannonRush = ScenarioScript(
  id: 'zvp_hive_defiler_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hive_defiler', 'zvp_scourge_defiler', 'zvp_3hatch_nopool'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '하이브 디파일러 vs 캐논 러시 — 캐논을 막으면 하이브가 지배한다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리를 올리며 일꾼을 늘려갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 올립니다! 캐논 러시 준비인가요?',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지부터 건설합니다! 수상한 움직임이네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브가 저그 앞마당으로 이동합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 중입니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '프로토스가 포지를 먼저 올렸습니다! 캐논 러시일까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 캐논 건설 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 저그 앞마당에 파일런을 숨겨놓습니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'control',
          altText: '{away}, 파일런이 저그 진영 구석에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논을 건설합니다! 해처리를 노리고 있어요!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 캐논 건설을 방해합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{home}, 드론이 캐논 건설 중인 프로브를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 나왔습니다! 프로브를 잡으러 갑니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '캐논이 완성되느냐 저글링이 먼저 잡느냐! 타이밍 싸움입니다!',
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
          text: '{home} 선수 성큰을 세워 캐논에 대응합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 캐논을 올리려 합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          awayResource: -15,
          altText: '{away}, 캐논을 한 기 더 올립니다! 집요한 공격이에요!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올리며 테크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '캐논 러시가 실패하면 프로토스는 크게 뒤처집니다!',
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
              text: '{home} 선수 저글링으로 프로브를 잡아냅니다! 캐논 추가 건설 불가!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 저글링이 프로브를 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 하이브 테크를 향해 달려갑니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeArmy: 3,
            ),
            ScriptEvent(
              text: '{away} 선수 캐논만 남았습니다! 후속 전력이 없어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '캐논 러시 실패! 하이브 디파일러가 경기를 지배합니다! GG!',
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
              text: '{away} 선수 캐논이 완성됩니다! 해처리를 직접 때리고 있어요!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away}, 캐논 화력이 해처리를 녹이고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 해처리가 무너집니다! 자원 수급이 끊겼어요!',
              owner: LogOwner.home,
              homeResource: -30,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논으로 본진까지 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -20,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '캐논 러시 성공! 저그가 무너졌습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
