part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 캐논 러시: 히드라 사거리로 캐논을 아웃레인지
// ----------------------------------------------------------
const _zvp973HydraVsCannonRush = ScenarioScript(
  id: 'zvp_973_hydra_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '973 히드라 vs 캐논 러시 — 히드라 사거리가 캐논을 아웃레인지한다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9서플라이에 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 건설합니다! 캐논 러시일까요?',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지부터 올립니다! 수상한 빌드입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브가 저그 진영으로 이동합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설을 서두릅니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
          altText: '{home}, 히드라덴이 올라갑니다! 히드라를 빨리 뽑아야 합니다!',
        ),
        ScriptEvent(
          text: '프로토스가 캐논 러시를 준비합니다! 저그의 히드라가 빨리 나와야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 캐논 vs 히드라 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 파일런을 숨기고 캐논을 건설합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'control',
          altText: '{away}, 캐논이 저그 앞마당 근처에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 캐논 건설을 방해합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          awayArmy: -1,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 프로브를 쫓아냅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 첫 기가 나옵니다! 캐논 사거리 밖에서 공격!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -1,
          favorsStat: 'attack',
          altText: '{home}, 히드라가 나왔습니다! 캐논보다 사거리가 깁니다!',
        ),
        ScriptEvent(
          text: '히드라의 긴 사거리! 캐논 밖에서 안전하게 공격할 수 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 히드라 반격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 추가 생산합니다! 캐논을 하나씩 파괴합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 캐논을 올리려 하지만 히드라에 막힙니다!',
          owner: LogOwner.away,
          awayResource: -15,
          awayArmy: -1,
          altText: '{away}, 캐논을 더 올리려 하지만 히드라 사거리에 걸립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대가 캐논을 정리하고 전진 준비를 합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '캐논이 히드라 사거리에 밀리고 있습니다! 프로토스가 위험합니다!',
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
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라 부대가 캐논을 전부 파괴합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home}, 히드라 사거리로 캐논을 하나씩 녹입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 프로토스 본진으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 유닛이 없습니다! 캐논에 모든 자원을 썼어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '히드라의 사거리 승리! 캐논 러시를 완벽하게 격파했습니다! GG!',
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
              text: '{away} 선수 캐논이 핵심 위치에 완성됩니다! 해처리를 직접 공격!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeResource: -30,
              favorsStat: 'control',
              altText: '{away}, 캐논이 해처리를 때리고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 해처리가 무너집니다! 히드라 생산 기지가 사라졌어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논으로 본진까지 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '캐논이 해처리를 먼저 밀었습니다! 프로토스 승리! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
