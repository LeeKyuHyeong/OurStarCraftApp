part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 드라군 푸시: 중반 정면 충돌
// ----------------------------------------------------------
const _zvp973HydraVsDragoonPush = ScenarioScript(
  id: 'zvp_973_hydra_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_trans_dragoon_push'],
  description: '973 히드라 vs 드라군 푸시 — 히드라 물량 vs 드라군 물량, 정면 승부',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9풀로 스포닝풀을 올리고 앞마당을 확보합니다.',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 건설하고 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 게이트웨이와 사이버네틱스 코어! 드라군을 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설합니다! 973 히드라 빌드!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'macro',
          altText: '{home}, 히드라덴이 올라갑니다! 히드라 타이밍을 노리는군요.',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 생산을 시작합니다! 물량을 모으고 있어요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '히드라 vs 드라군! 중반 정면 승부가 예상됩니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 병력 축적 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 대량 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 히드라리스크가 물밀 듯이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 6기를 모아서 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 사거리 업그레이드를 연구합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 저그 앞마당으로 접근합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          favorsStat: 'attack',
          altText: '{away}, 드라군 부대가 전진합니다! 교전이 임박했어요!',
        ),
        ScriptEvent(
          text: '히드라와 드라군이 곧 정면으로 부딪힙니다! 물량 싸움!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 정면 교전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 부대가 성큰 뒤에서 대기합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
          altText: '{home}, 성큰 라인 뒤에 히드라를 배치합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 게이트웨이에서 드라군을 보충합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 섞어서 드라군 진형을 흐트러뜨릴 준비!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '양쪽 병력이 충돌 직전입니다! 컨트롤이 승패를 가릅니다!',
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
              text: '{home} 선수 저글링이 드라군 사이로 파고들어 진형을 깨뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'control',
              altText: '{home}, 저글링 서라운드! 드라군이 흩어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라리스크가 집중 사격! 드라군이 녹아냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 전멸합니다! 후속 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '히드라의 물량과 저글링 서라운드! 드라군을 압도합니다! GG!',
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
              text: '{away} 선수 드라군의 집중 사격이 히드라를 녹입니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 드라군 화력이 히드라를 순식간에 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 앞마당 해처리를 공격합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 손실이 너무 큽니다! 재생산할 자원이 없어요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '드라군 화력의 승리! 히드라를 정면에서 격파합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
