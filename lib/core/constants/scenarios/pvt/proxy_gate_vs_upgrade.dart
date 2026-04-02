part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 업그레이드형 테란
// ----------------------------------------------------------
const _pvtProxyGateVsUpgrade = ScenarioScript(
  id: 'pvt_proxy_gate_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '프록시 게이트 질럿 러시 vs 더블 업그레이드 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브가 출발합니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 앞마당 커맨드센터를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 더블! 욕심 많은 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 근처에 게이트웨이 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 프록시 게이트웨이! 테란이 더블을 갔는데!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이를 올립니다! 업그레이드를 노리는 빌드!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '더블 업그레이드 vs 프록시 게이트! 욕심을 부린 대가가 올까요?',
          owner: LogOwner.system,
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
          text: '{home} 선수 질럿 2기가 테란 앞마당으로 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          altText: '{home}, 질럿 러시! 더블을 간 테란에게 치명적!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 1기밖에 없습니다! 더블이라 병력이 늦어요!',
          owner: LogOwner.away,
          awayArmy: 1,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 앞마당 SCV를 공격합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'attack',
          altText: '{home} 선수 질럿이 일꾼을 베기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 급하게 벙커를 올립니다! 마린이 부족해요!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 긴급 벙커 건설! 시간이 촉박합니다!',
        ),
        ScriptEvent(
          text: '더블 빌드가 프록시에 잡혔습니다! 벙커가 제때 올라올까요?',
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
        ),
        ScriptEvent(
          text: '{away} 선수 마린을 추가 생산! 벙커에 넣으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
          altText: '{away}, 마린이 겨우 나옵니다! 벙커에 투입!',
        ),
        ScriptEvent(
          text: '{home}, 질럿 추가 합류! 4기가 됩니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '업그레이드가 완료되기 전에 게임이 끝날 수도 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 질럿이 더블 파괴
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커를 부숩니다! SCV 수리가 부족해요!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 질럿 4기의 화력! 벙커가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 후퇴하지만 질럿에 잡힙니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 질럿이 앞마당 커맨드센터를 공격합니다!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '업그레이드가 완료될 때쯤이면 이미 앞마당이 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당을 파괴! 더블 빌드가 완전히 무너졌습니다!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 더블을 간 테란에 대한 완벽한 징벌!',
            ),
          ],
        ),
        // 분기 B: 테란 방어 성공 → 업그레이드 완료
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 완성! 마린 4기로 질럿을 막습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              favorsStat: 'defense',
              altText: '{away}, 벙커 방어 성공! 상대 병력이 막힙니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커를 깨지 못하고 손실만 납니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 1-1 업그레이드 완료! 마린 메딕 편대가 강해집니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -15,
              altText: '{away} 선수 업그레이드 마린! 화력이 다릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 마린 메딕으로 전진! 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '프록시에 모든 자원을 쏟은 프로토스에 대응할 수단이 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 화력으로 밀어냅니다! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 더블 자원 + 업그레이드! 프록시를 완벽히 막아냈습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
