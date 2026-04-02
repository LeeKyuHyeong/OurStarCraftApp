part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 야바위 vs 캐논 러시: 캐논 실패 시 다면 기만 공격
// ----------------------------------------------------------
const _zvpYabarwiVsCannonRush = ScenarioScript(
  id: 'zvp_yabarwi_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_yabarwi'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '야바위 기만 전술 vs 캐논 러시 — 캐논 실패 후 다면 파괴',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑으며 자원을 모읍니다.',
          owner: LogOwner.home,
          homeResource: 10,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 올리고 프로브를 저그 진영으로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 포지 건설! 캐논 러시를 준비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저그 앞마당 옆에 파일런을 세웁니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 드론이 이상한 위치의 파일런을 발견합니다!',
          owner: LogOwner.home,
          favorsStat: 'scout',
          altText: '{home}, 파일런 발견! 캐논 러시가 예상됩니다!',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '캐논 러시입니다! 저그가 빠르게 대응해야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 캐논 대응 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논을 올립니다! 해처리 사정거리를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 캐논 건설 중! 해처리를 위협합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 프로브를 잡으며 캐논 건설을 방해합니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          homeResource: -10,
          favorsStat: 'control',
          altText: '{home}, 드론 몰이! 프로브를 쫓아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 나옵니다! 캐논 주변 프로브를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설을 시작합니다. 럴커 전환 준비!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '캐논을 막아내면 저그의 역습이 시작됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 야바위 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크와 럴커 편대를 구성합니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
          altText: '{home}, 럴커 합류! 공격 준비 완료!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 3방향으로 분산시킵니다! 어디가 진짜인가!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논 러시 실패 후 드라군을 뽑으려 합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '캐논 러시 실패! 야바위 전술이 시작됩니다!',
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
          conditionStat: 'strategy',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 3방향에서 동시에 돌격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayResource: -15,
              favorsStat: 'harass',
              altText: '{home}, 야바위! 어디가 진짜 공격인지 모릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 프로토스 앞마당을 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논에 자원을 너무 쓴 상태! 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '야바위 전술 대성공! 캐논 러시의 실패가 결정적이었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'strategy',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 핵심 위치에 완성됩니다! 해처리가 맞습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeResource: -20,
              favorsStat: 'strategy',
              altText: '{away}, 캐논 완성! 해처리 체력이 빠르게 줄어듭니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 캐논에 녹아내립니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논으로 앞마당을 완전히 봉쇄합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '캐논 러시 성공! 저그 앞마당이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
