part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs 안티 캐리어
// ----------------------------------------------------------
const _pvt5gatePushVsAntiCarrier = ScenarioScript(
  id: 'pvt_5gate_push_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_1gate_expand'],
  awayBuildIds: ['tvp_trans_anti_carrier', 'tvp_anti_carrier'],
  description: '5게이트 지상 푸시 vs 골리앗 대공 편성',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 올립니다! 사이버네틱스 코어도 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 게이트웨이에 사이버네틱스 코어!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭과 팩토리를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 생산하면서 게이트웨이를 추가합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올립니다! 골리앗 생산을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아머리 건설! 골리앗 체제로 가는 겁니다!',
        ),
        ScriptEvent(
          text: '골리앗 편성은 대공에 특화되지만 지상전에서도 무시할 수 없습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 3개까지 완성!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 5게이트 빌드업 vs 골리앗 생산 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 질럿 스피드를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗이 생산됩니다! 지상 화력도 강합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 골리앗 합류! 대공뿐 아니라 지상에서도 쓸만합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 다섯 개 완성! 드라군과 질럿이 본격적으로 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          altText: '{home}, 게이트웨이 다섯 개 가동! 공중 유닛 대신 지상 물량으로 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크도 섞습니다! 골리앗과 탱크의 조합!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '골리앗은 캐리어 대비 편성인데 프로토스가 지상으로 옵니다! 대응이 어떻게 될까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 5게이트 물량 집결 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스피드 질럿 완료! 게이트웨이 물량이 모였습니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 물량을 모읍니다! 대공 사거리 업그레이드도 연구합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 전군 전진합니다! 지상전에서 승부를 봅니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 전군 전진! 공중 없이 지상으로만 밀어붙입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 건설합니다! 골리앗 물량을 더 뽑아야 합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 확장! 골리앗 추가 생산을 위한 자원 확보!',
        ),
        ScriptEvent(
          text: '프로토스 지상 푸시! 골리앗 편성이 지상전에서도 통할까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          events: [
            ScriptEvent(
              text: '{home} 선수 스피드 질럿이 골리앗에 돌진합니다! 근접전에서 유리!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 질럿이 골리앗에 달라붙습니다! 근접에서 질럿이 강합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 근접전에서 밀립니다! 사거리 장점을 못 살립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 후방에서 포격합니다! 전후방 협공!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '골리앗이 지상 물량에 밀립니다! 대공 특화의 약점이 드러납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 게이트웨이 물량으로 골리앗 편성을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 지상 물량 압도! 골리앗 편성으로는 막을 수 없습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗과 탱크 조합! 사거리에서 드라군을 먼저 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'defense',
              altText: '{away}, 골리앗이 탱크와 합동 사격! 상대 병력이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 탱크에 달라붙지만 골리앗이 막습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처까지 합류합니다! 프로토스 확장을 급습합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '골리앗 편성이 지상에서도 통합니다! 프로토스가 밀립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 대군으로 프로토스를 제압합니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 골리앗 물량! 프로토스 지상 푸시를 막아냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
