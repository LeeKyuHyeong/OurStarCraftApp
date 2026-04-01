part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9. 마인 트리플 수비전 (프로토스 확장 vs 테란 수비적 운영)
// ----------------------------------------------------------
const _pvtMineTriple = ScenarioScript(
  id: 'pvt_mine_triple',
  matchup: 'PvT',
  homeBuildIds: ['pvt_1gate_expand', 'pvt_1gate_obs',
                 'pvt_trans_5gate_arbiter', 'pvt_trans_5gate_carrier'],
  awayBuildIds: ['tvp_mine_triple', 'tvp_1fac_gosu',
                 'tvp_trans_tank_defense', 'tvp_trans_upgrade'],
  description: '프로토스 확장 vs 마인 트리플 수비전',
  phases: [
    // Phase 0: 오프닝 (lines 1-18)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 파일런 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설! 가스도 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 게이트웨이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵! 탱크 준비도 합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵까지! 탱크 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산! 마인 업그레이드 연구 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 벌처가 나옵니다! 마인까지 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다! 확장!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 그리고 자연스럽게 세 번째 커맨드로!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당에 이어 세 번째 확장까지! 마인 트리플!',
        ),
      ],
    ),
    // Phase 1: 마인 영역 확보 (lines 19-30)
    ScriptPhase(
      name: 'mine_control',
      startLine: 19,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 벌처가 맵 곳곳에 마인을 뿌립니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
          altText: '{away} 선수 마인 매설! 프로토스 이동 경로를 차단!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 사거리 업그레이드 완료!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 로보틱스 건설! 옵저버터리도 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home} 선수 로보틱스에 옵저버터리! 옵저버로 마인을 잡으려는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드센터에서 자원이 들어옵니다! 시즈 탱크 추가 생산!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 트리플 자원으로 탱크를 찍어냅니다!',
        ),
        ScriptEvent(
          text: '테란이 마인으로 영역을 확보하며 수비적으로 운영합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 옵저버 vs 마인 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'observer_vs_mine',
      startLine: 31,
      branches: [
        // 분기 A: 옵저버로 마인 무력화
        ScriptBranch(
          id: 'observer_clears_mines',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 옵저버 출격! 마인 위치를 밝혀냅니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 옵저버 정찰! 마인이 다 보입니다!',
            ),
            ScriptEvent(
              text: '{home}, 드라군이 마인을 하나씩 처리합니다! 안전하게 전진!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 마인 방어선이 뚫리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 마인이 무력화됩니다! 영역이 뚫려요!',
            ),
            ScriptEvent(
              text: '옵저버가 마인을 무력화! 프로토스가 전진할 길이 열렸습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 마인에 드라군 피해
        ScriptBranch(
          id: 'mine_damage',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드라군이 전진하는데 마인에 걸립니다!',
              owner: LogOwner.home,
              homeArmy: -3, favorsStat: 'scout',
              altText: '{home}, 드라군이 마인에 터집니다! 옵저버가 늦었어요!',
            ),
            ScriptEvent(
              text: '{away}, 벌처가 마인 위치로 유인! 추가 피해를 줍니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실이 큽니다! 재정비가 필요합니다.',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '마인에 드라군이 당했습니다! 테란 영역 확보가 효과적!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 테크 전환 (lines 45-58)
    ScriptPhase(
      name: 'late_tech',
      startLine: 45,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브 건설! 하이 템플러를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 아둔에서 템플러 아카이브까지! 스톰 연구 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리 건설! 메카닉 업그레이드!',
        ),
        ScriptEvent(
          text: '{home}, 드라군 추가 생산! 게이트웨이 추가!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away}, 시즈 탱크 편대가 정비를 마쳤습니다! 골리앗도 합류!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away} 선수 탱크 골리앗 편대! 화력이 막강합니다!',
        ),
        ScriptEvent(
          text: '양측 후반 병력이 완성되어 갑니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 59-75)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 59,
      branches: [
        // 분기 A: 프로토스 스톰으로 돌파
        ScriptBranch(
          id: 'protoss_storm_break',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이 템플러 합류! 사이오닉 스톰!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -10, favorsStat: 'strategy',
              altText: '{home}, 스톰 투하! 테란 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 스톰에 쓸려나갑니다!',
              owner: LogOwner.away,
              awayArmy: -6,
              altText: '{away}, 스톰에 바이오닉이 증발!',
            ),
            ScriptEvent(
              text: '{home}, 드라군 총공격! 탱크 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 트리플 체제를 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 테란 화력으로 수비
        ScriptBranch(
          id: 'terran_firepower_hold',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 시즈 탱크가 집중 포격! 프로토스 병력을 날려버립니다!',
              owner: LogOwner.away,
              homeArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 탱크가 포격! 프로토스 전선을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗까지 합류! 지상 화력이 압도적입니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 병력이 녹고 있습니다! 트리플 자원 차이가 크네요!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 자원 차이가 결국 병력 차이로! 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '트리플 자원의 화력이 프로토스를 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

