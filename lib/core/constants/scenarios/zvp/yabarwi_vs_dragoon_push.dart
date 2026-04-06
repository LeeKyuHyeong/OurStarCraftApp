part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 야바위 vs 드라군 푸시: 가짜 공격으로 드라군을 분산시키고 확장 타격
// ----------------------------------------------------------
const _zvpYabarwiVsDragoonPush = ScenarioScript(
  id: 'zvp_yabarwi_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_yabarwi', 'zvp_yabarwi'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '야바위 기만 전술 vs 드라군 타이밍 푸시 — 가짜 공격으로 드라군 분산',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다. 드론을 늘려갑니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 앞마당 확장! 자원 확보 우선!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 드라군 생산을 시작합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          awayArmy: 2,
          altText: '{away}, 사이버네틱스 코어 완성! 드라군 체제 전환!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀에서 저글링 발업을 연구합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가하며 드라군 물량을 늘립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '프로토스가 드라군을 모으고 있습니다! 타이밍 푸시가 임박!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 드라군 진군 vs 기만전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드라군 10기를 모아 저그 앞마당으로 진군합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          altText: '{away}, 드라군 편대 출발! 정면 돌파를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 센터와 프로토스 본진 두 방향으로 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
          altText: '{home}, 저글링 분산! 가짜 공격을 섞습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 일부를 본진 방어로 돌립니다!',
          owner: LogOwner.away,
          awayArmy: -2,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크와 럴커를 앞마당에 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'defense',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '야바위 전술로 드라군이 분산됩니다! 타이밍 푸시에 영향을 주고 있어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 교전 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 럴커를 앞마당 입구에 매복시킵니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
          altText: '{home}, 럴커 매복! 드라군이 접근하면 큰 피해를 입습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 저그 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 프로토스 확장기지를 기습합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '앞에서는 럴커, 뒤에서는 저글링! 프로토스가 양면 공격을 받습니다!',
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
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커가 드라군 편대를 관통합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -5,
              favorsStat: 'attack',
              altText: '{home}, 럴커의 스파인 공격! 드라군을 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 프로토스 넥서스를 때립니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 분산된 상태! 집중력이 흐트러졌습니다!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '야바위 전술 대성공! 드라군 푸시가 분산되어 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'attack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드라군이 럴커를 사정거리 밖에서 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -5,
              favorsStat: 'control',
              altText: '{away}, 드라군 마이크로! 럴커 사정거리를 벗어나 사격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.away,
              homeResource: -20,
              awayArmy: 3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 가짜 공격에 저글링을 너무 많이 보냈습니다! 본진이 텅 비어요!',
              owner: LogOwner.home,
              homeArmy: -4,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '드라군의 정면 돌파! 야바위가 통하지 않았습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
