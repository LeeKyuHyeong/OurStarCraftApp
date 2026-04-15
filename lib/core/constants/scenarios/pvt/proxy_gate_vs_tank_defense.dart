part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 탱크 수비형 테란
// ----------------------------------------------------------
const _pvtProxyGateVsTankDefense = ScenarioScript(
  id: 'pvt_proxy_gate_vs_tank_defense',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_tank_defense', 'tvp_double', 'tvp_mine_triple', 'tvp_fd'],
  description: '프록시 게이트 질럿 러시 vs 탱크 수비형 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 앞으로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 가스를 올립니다. 안정적인 오프닝!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭 가스! 팩토리를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 근처에 게이트웨이를 숨겨서 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 숨겨진 게이트웨이! 발각되지 않았습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다. 머신샵을 붙이고 있습니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 질럿이 나옵니다! 테란이 아직 모르고 있어요!',
        ),
        ScriptEvent(
          text: '전진 게이트웨이! 테란이 정찰하지 못하면 위험합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 질럿 공격 (lines 12-20)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 테란 본진으로 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
          altText: '{home}, 질럿 러시! 테란 앞마당으로!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 2기와 SCV로 방어합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 마린을 쫓습니다! 마린이 도망가면서 사격!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{home} 선수 질럿 돌진! 상대 병력 한 기를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 올리려 합니다! SCV가 달려갑니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 벙커 건설 시도! 완성되면 질럿을 막을 수 있습니다!',
        ),
        ScriptEvent(
          text: '벙커가 올라오고 있습니다! 질럿이 끊을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벙커 공방 (lines 22-28)
    ScriptPhase(
      name: 'bunker_fight',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿이 벙커 짓는 SCV를 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 질럿이 SCV를 공격! 벙커 건설을 방해합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 마린 생산! 벙커에 마린을 넣으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home}, 질럿 추가 합류! 3기가 됐습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home} 선수 질럿이 계속 합류합니다!',
        ),
        ScriptEvent(
          text: '탱크가 나오기 전에 끝장을 내야 합니다! 시간이 없어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 벙커 전 돌파 → 질럿 승리
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커 짓는 SCV를 잡아냅니다! 벙커가 안 올라갑니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home}, SCV 격파! 벙커 건설 실패!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린만으로는 질럿을 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 질럿이 SCV를 추가로 잡아내면서 라인을 밀어냅니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '탱크가 나오기 전에 승부가 결정됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 커맨드센터까지 도달! 테란이',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 전진 게이트웨이 성공! 질럿이 테란을 초토화!',
            ),
          ],
        ),
        // 분기 B: 벙커 완성 + 탱크 → 테란 방어 성공
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              favorsStat: 'defense',
              altText: '{away}, 벙커에 마린 투입! 상대 병력이 막힙니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커를 깨지 못합니다! SCV 수리까지!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크가 나옵니다! 질럿은 탱크 상대가 안 됩니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
              altText: '{away} 선수 탱크 등장! 질럿에 대한 완벽한 대응!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 전멸합니다! 탱크 시즈 화력에 녹아내려요!',
              owner: LogOwner.home,
              homeArmy: -8,
            ),
            ScriptEvent(
              text: '전진 게이트웨이 실패! 프로토스에 남은 게 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 앞세워 전진! 프로토스가',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 탱크 시즈 모드! 전진 질럿을 완벽히 막아냈습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
