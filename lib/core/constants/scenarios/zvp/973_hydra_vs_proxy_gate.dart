part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 프록시 게이트: 양쪽 모두 공격적 빌드
// ----------------------------------------------------------
const _zvp973HydraVsProxyGate = ScenarioScript(
  id: 'zvp_973_hydra_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra', 'zvp_973_hydra', 'zvp_9pool'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_8gat'],
  description: '973 히드라 vs 프록시 게이트 — 공격형 vs 공격형 극초반 충돌',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀을 올립니다! 빠른 스포닝풀이군요!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9드론에 스포닝풀! 빠르게 저글링을 뽑으려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 파일런을 상대 본진 근처에 숨깁니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 게이트웨이를 건설합니다! 질럿 러시!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 게이트웨이가 저그 앞에서 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 생산하며 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 오프닝입니다! 누가 먼저 타격을 줄까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 초반 충돌 (lines 12-21)
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
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 질럿을 둘러싸서 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -2,
          favorsStat: 'control',
          altText: '{home}, 저글링이 질럿을 감싸고 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설합니다! 히드라리스크 타이밍 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 질럿을 보내지만 저글링에 막힙니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          homeArmy: -1,
          favorsStat: 'attack',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '전진 질럿이 막혔습니다! 히드라 타이밍이 오면 역전될 수 있어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 히드라 타이밍 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크 대량 생산! 타이밍 어택 준비!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 히드라리스크가 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 본진에서 사이버네틱스 코어를 올리고 있습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대를 모아서 프로토스 진영으로 출격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '전진 게이트웨이에 자원을 썼기 때문에 프로토스 본진 수비가 약합니다!',
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
              text: '{home} 선수 히드라 부대가 프로토스 앞마당을 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 히드라리스크의 집중 사격! 캐논이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 병력이 부족합니다! 전진 게이트웨이에 자원을 너무 썼어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 넥서스를 직접 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -30,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '히드라 타이밍 성공! 초반 질럿 러시 실패 후 복구가 안 됩니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논과 질럿으로 히드라 공격을 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 캐논 화력과 질럿이 히드라를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군을 합류시키며 반격을 준비합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              awayResource: -15,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 손실이 큽니다! 후속 물량이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '히드라 타이밍 실패! 프로토스가 수비 후 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
