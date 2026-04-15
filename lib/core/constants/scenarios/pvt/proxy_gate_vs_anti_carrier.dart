part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 골리앗 대공형 테란
// ----------------------------------------------------------
const _pvtProxyGateVsAntiCarrier = ScenarioScript(
  id: 'pvt_proxy_gate_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_anti_carrier', 'tvp_anti_carrier'],
  description: '프록시 게이트 질럿 러시 vs 골리앗 대공형',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터 방향으로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 가스를 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 상대 진영 근처에 게이트웨이를 숨겨서 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 숨겨진 게이트웨이! 발각되지 않았습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다! 아머리를 이어서 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리 아머리! 골리앗을 준비하는 빌드!',
        ),
        ScriptEvent(
          text: '전진 게이트웨이 vs 아머리 골리앗 준비! 초반 결전이 되겠습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 상대 쪽으로 바로 출발!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 12-19)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 테란 본진에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
          altText: '{home}, 질럿 돌진! 골리앗 나오기 전에 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 2기로 막습니다! 아머리에 투자해서 마린이 적어요!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 마린을 밀어내고 SCV를 공격합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          awayArmy: -1,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 올리려 합니다! SCV 수리도 시작!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 긴급 벙커! 질럿을 막아야 합니다!',
        ),
      ],
    ),
    // Phase 2: 본진 공방 (lines 22-28)
    ScriptPhase(
      name: 'base_fight',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 추가! 3기로 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 마린을 추가 생산하면서 벙커에 넣습니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
          altText: '{away}, 마린이 벙커에 들어갑니다!',
        ),
        ScriptEvent(
          text: '{home}, 질럿이 벙커를 공격합니다! SCV 수리가 간당간당!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 질럿이 벙커에 달라붙었습니다!',
        ),
        ScriptEvent(
          text: '골리앗이 나오면 질럿으로는 힘듭니다! 시간 싸움!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 질럿이 골리앗 전에 결정타
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커를 부숩니다! SCV가 부족해요!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 벙커 파괴! 질럿이 밀려들어갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 아직 나오지 않았습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 질럿이 SCV를 전멸시킵니다!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '골리앗 나오기 전에 끝장입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 전진 게이트웨이 대성공! 테란이',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 질럿이 테란 본진을 초토화합니다!',
            ),
          ],
        ),
        // 분기 B: 벙커 방어 → 골리앗 등장 → 역전
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커가 버팁니다! 마린 화력으로 질럿을 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              awayArmy: 3,
              favorsStat: 'defense',
              altText: '{away}, 벙커 방어 성공! 질럿 손실!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 줄어들고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 골리앗이 나옵니다! 지상 화력이 강력합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
              altText: '{away} 선수 골리앗 등장! 질럿 상대로도 강합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린 골리앗 편대로 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '전진 게이트웨이를 막아냈습니다! 테란의 화력이 압도적!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 화력으로 밀어냅니다! 프로토스가',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 골리앗이 프로토스 진영까지 밀어붙입니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
