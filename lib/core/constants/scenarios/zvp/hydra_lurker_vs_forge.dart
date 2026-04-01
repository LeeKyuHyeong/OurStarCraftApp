part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 10. 히드라 럴커 vs 포지더블 (럴커 운영)
// ----------------------------------------------------------
const _zvpHydraLurkerVsForge = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_trans_forge_expand',
                 'pvz_trans_dragoon_push'],
  description: '히드라 럴커 운영 vs 포지더블 드라군 푸시',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 확장을 챙기는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스! 게이트웨이와 포지더블입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 건설! 포지와 게이트웨이로 입구를 막습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 히드라덴이 올라갑니다! 히드라 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
      ],
    ),
    // Phase 1: 히드라 생산 + 럴커 변태 (lines 17-28)
    ScriptPhase(
      name: 'hydra_lurker_tech',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 속업 연구도 진행합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 히드라가 나옵니다! 업그레이드도 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 드라군 생산과 동시에 스타게이트, 로보틱스와 옵저버터리를 준비합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 사이버네틱스 코어에서 드라군! 스타게이트와 로보틱스에 옵저버터리 건설도 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올립니다! 럴커 변태를 노립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어 진행! 럴커를 준비하는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 오버로드를 사냥하러 갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'harass',
          altText: '{away}, 커세어 출격! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{home}, 히드라가 럴커로 변태합니다! 입구를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home} 선수 럴커 변태 완료! 진지를 구축합니다!',
        ),
        ScriptEvent(
          text: '럴커가 버로우하면 옵저버 없이는 공격할 수 없습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 럴커 포진 결과 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'lurker_position',
      startLine: 29,
      branches: [
        // 분기 A: 럴커 포진 성공 (입구 장악)
        ScriptBranch(
          id: 'lurker_lockdown',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 럴커가 앞마당 입구에 포진합니다! 상대가 접근 불가!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'defense',
              altText: '{home} 선수 럴커 포진! 프로토스가 전진할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 아직 없습니다! 드라군이 보이지 않는 공격에 당합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 드라군이 그대로 녹습니다! 드라군이 보이지 않는 적을 상대할 수 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 럴커 뒤에서 히드라가 지원 사격합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 히드라 조합이 입구를 완벽하게 틀어막고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 옵저버 대응 성공
        ScriptBranch(
          id: 'observer_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 로보틱스에서 옵저버터리를 올려 옵저버 생산! 옵저버가 럴커를 포착합니다! 드라군 사격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'strategy',
              altText: '{away}, 로보틱스와 옵저버터리 완성! 옵저버가 럴커를 비춥니다! 드라군 집중 사격!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 잡히고 있습니다! 탐지기가 치명적!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 옵저버에 포착! 수비가 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군 편대가 전진합니다! 럴커 제거 후 밀어붙이기!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '옵저버가 럴커를 무력화! 프로토스가 전진합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 45-58)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 45,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 멀티를 추가하면서 럴커 히드라를 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 확장! 럴커 물량을 계속 보충합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군 푸시를 준비합니다! 옵저버와 함께!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 드라군에 옵저버! 럴커를 잡으면서 전진!',
        ),
        ScriptEvent(
          text: '{home}, 럴커가 새로운 포지션에 버로우합니다! 길목을 막습니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'defense',
          altText: '{home} 선수 럴커 재배치! 드라군을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away}, 아둔과 템플러 아카이브를 올려 하이 템플러가 합류합니다! 스톰 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
        ),
        ScriptEvent(
          text: '럴커 진지전 vs 드라군 옵저버 밀어붙이기! 치열한 공방!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 59-74)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 59,
      branches: [
        // 분기 A: 럴커 물량으로 진지 유지
        ScriptBranch(
          id: 'lurker_holds_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커를 대량으로 깔아둡니다! 전장이 가시밭!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'defense',
              altText: '{home}, 럴커가 5기 이상! 상대가 접근할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버를 잃었습니다! 드라군이 다시 앞이 보이지 않습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 옵저버 격추! 드라군이 적 위치를 알 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 빈 틈을 노려 견제합니다! 프로브가 위험!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 퀸즈네스트와 하이브 완성! 디파일러 마운드에서 디파일러까지 추가합니다! 다크 스웜!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home}, 하이브 테크! 디파일러 마운드 완성! 다크 스웜 속에서 무적입니다!',
            ),
            ScriptEvent(
              text: '럴커 진지가 난공불락! 프로토스가 돌파하지 못합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 프로토스 한방 병력 돌파
        ScriptBranch(
          id: 'protoss_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스톰! 히드라 편대가 녹아내립니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'strategy',
              altText: '{away}, 스톰 명중! 스톰이 히드라를 증발시킵니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 럴커를 하나씩 제거합니다! 옵저버 시야 확보!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 다 잡히고 있습니다! 수비가 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 럴커 진지가 붕괴됩니다! 스톰에 이어 드라군 화력!',
            ),
            ScriptEvent(
              text: '{away}, 전 병력 전진! 저그 본진을 향합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '프로토스 한방 병력이 럴커 진지를 돌파합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

