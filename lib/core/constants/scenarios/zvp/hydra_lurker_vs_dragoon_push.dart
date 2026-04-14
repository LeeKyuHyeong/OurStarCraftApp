part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 히드라 럴커 vs 드라군 푸시: 럴커 매몰 vs 옵저버 감지
// ----------------------------------------------------------
const _zvpHydraLurkerVsDragoonPush = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_12pool'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '히드라 럴커 vs 드라군 푸시 — 럴커 매몰과 옵저버 감지가 승부를 가르는 구도',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리 앞마당을 빠르게 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 앞마당 해처리가 건설됩니다. 안정적인 오프닝이네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성 후 히드라덴으로 넘어갑니다.',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'strategy',
          altText: '{home}, 히드라덴을 올립니다! 히드라리스크를 준비하는군요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 생산이 시작됩니다. 물량을 모으고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 모두 안정적인 구성입니다. 중반 교전이 기대되네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 드라군 어택과 히드라 대응 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드라군 부대가 전진합니다! 저그 앞마당을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 드라군이 진격합니다! 물량이 꽤 모였네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크로 맞불을 놓습니다! 사거리 교환이에요!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스에서 옵저버를 생산합니다! 럴커를 대비하는 거죠!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'scout',
          altText: '{away}, 옵저버터리에서 옵저버 생산! 럴커가 나올 것을 대비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드 시작! 럴커 진화를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '옵저버가 럴커를 잡아낼 수 있을까요? 핵심 대결이 다가옵니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 등장과 옵저버 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 럴커 진화 완료! 전방에 매몰합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'control',
          altText: '{home}, 럴커가 매몰됩니다! 드라군이 접근하면 큰 피해를 입어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 옵저버를 전방으로 보냅니다! 럴커를 찾아야 합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 추가 생산하며 병력을 강화합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 드라군 물량을 더 모읍니다. 옵저버 앞세워 진격할 겁니다.',
        ),
        ScriptEvent(
          text: '럴커 매몰 vs 옵저버 감지! 이 승부의 핵심입니다!',
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
          baseProbability: 2.5,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커 가시가 드라군 부대를 꿰뚫습니다! 엄청난 스파이크 데미지!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -5,
              favorsStat: 'control',
              altText: '{home}, 럴커 매몰에 드라군을 녹여버립니다! 위치 선정이 완벽해요!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 히드라리스크에 격추됩니다! 럴커가 안 보여요!',
              owner: LogOwner.away,
              awayArmy: -2,
              homeArmy: 1,
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 럴커 조합이 프로토스 진영까지 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              awayResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 스파이크 데미지! 옵저버 없이는 답이 없습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'scout',
          events: [
            ScriptEvent(
              text: '{away} 선수 옵저버가 럴커 위치를 정확히 포착합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              favorsStat: 'scout',
              altText: '{away}, 옵저버가 럴커를 찾아냈습니다! 이제 보입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 럴커를 집중 사격합니다! 하나씩 정리해요!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 정리당합니다! 히드라만으로는 물량이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '옵저버 감지 성공! 드라군이 럴커를 모두 처리합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
