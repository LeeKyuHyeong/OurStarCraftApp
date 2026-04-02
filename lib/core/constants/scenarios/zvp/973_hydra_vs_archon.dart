part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 973 히드라 vs 아콘 질럿: 스톰 전에 히드라로 끝내야 한다
// ----------------------------------------------------------
const _zvp973HydraVsArchon = ScenarioScript(
  id: 'zvp_973_hydra_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_trans_archon'],
  description: '973 히드라 vs 아콘 질럿 — 스톰이 나오면 히드라가 녹는다',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9풀로 스포닝풀을 올립니다! 973 빌드!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 빠른 스포닝풀! 히드라 타이밍을 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당을 확보하고 히드라덴을 건설합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔을 건설합니다! 템플러 테크를 향해 가는군요.',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 아둔이 올라갑니다! 하이템플러를 준비합니다.',
        ),
        ScriptEvent(
          text: '히드라 타이밍이 아콘 완성보다 빨라야 합니다! 시간 싸움입니다.',
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
          text: '{home} 선수 히드라리스크를 대량 생산합니다! 빠른 타이밍!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 템플러 아카이브를 건설합니다! 스톰 연구 시작!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'strategy',
          altText: '{away}, 템플러 아카이브가 올라갑니다! 스톰이 곧 완성!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라 부대를 모아서 프로토스로 출격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'attack',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿과 드라군으로 수비를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 질럿과 드라군이 앞마당을 지키고 있습니다.',
        ),
        ScriptEvent(
          text: '스톰이 완성되기 전에 히드라가 도착해야 합니다! 타이밍 경쟁!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 히드라 어택 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 부대가 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'attack',
          altText: '{home}, 히드라 대군이 프로토스 앞에 도착했습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이템플러가 거의 완성됩니다! 조금만 더 버텨야 해요!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 측면으로 보내 견제합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '스톰이 먼저냐 히드라가 먼저냐! 이 경기의 분수령!',
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
              text: '{home} 선수 히드라가 스톰 완성 전에 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 히드라 타이밍 성공! 스톰보다 빨랐습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿만으로는 히드라 물량을 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 넥서스를 공격합니다! 프로토스가 무너지고 있어요!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰 전에 끝냈습니다! 히드라 타이밍의 승리! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{away} 선수 사이오닉 스톰! 히드라 무리가 녹아내립니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -5,
              favorsStat: 'strategy',
              altText: '{away}, 스톰이 터집니다! 히드라가 한 방에 전멸!',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘과 질럿이 남은 히드라를 정리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 전멸했습니다! 재생산할 여력이 없어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '스톰의 위력! 히드라 뭉치가 한 방에 사라졌습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
