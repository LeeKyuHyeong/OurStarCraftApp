part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 5팩토리 물량 테란
// ----------------------------------------------------------
const _pvtProxyGateVs5facMass = ScenarioScript(
  id: 'pvt_proxy_gate_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_5fac_mass', 'tvp_5fac_timing', 'tvp_11up_8fac'],
  description: '프록시 게이트 질럿 러시 vs 5팩토리 물량',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 보냅니다! 빠른 정찰!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다. 가스도 빠르게 올려요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 상대 근처에 게이트웨이를 세웁니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 프록시 게이트웨이! 테란이 눈치채지 못했습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 빠르게 올립니다! 이후 팩토리를 추가할 계획!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리 건설! 5팩을 향한 첫걸음!',
        ),
        ScriptEvent(
          text: '5팩토리 빌드는 초반이 취약합니다! 질럿이 도착하면?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 질럿 공격 (lines 12-19)
    ScriptPhase(
      name: 'zealot_attack',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 2기 생산! 빠르게 테란으로!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          altText: '{home}, 질럿 출발! 팩토리가 올라오기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 2기뿐입니다! 팩토리에 투자해서 병력이 적어요!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 본진에 진입합니다! 마린이 부족!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'attack',
          altText: '{home} 선수 질럿이 마린을 밀어냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 동원합니다! 벙커를 올리기엔 늦었어요!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '5팩 빌드의 약점! 초반 방어가 취약합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
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
          text: '{home} 선수 질럿이 SCV를 잡으면서 팩토리도 공격합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'attack',
          altText: '{home}, 질럿이 SCV를 베면서 팩토리를 때립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 겨우 1기 나왔습니다!',
          owner: LogOwner.away,
          awayArmy: 1,
        ),
        ScriptEvent(
          text: '{home}, 질럿 추가! 4기가 됩니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '팩토리에 투자한 자원이 위기를 불렀습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 질럿이 5팩 완성 전에 파괴
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 팩토리를 부숩니다! 탱크 생산이 불가!',
              owner: LogOwner.home,
              awayArmy: -3,
              awayResource: -20,
              favorsStat: 'attack',
              altText: '{home}, 팩토리가 무너집니다! 5팩 꿈은 사라졌습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 질럿을 상대하지만 수가 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 질럿이 SCV까지 전멸시킵니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5팩토리를 노렸지만 프록시에 무너졌습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿 러시 대성공! 테란이 GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 프록시가 5팩의 취약한 초반을 정확히 찔렀습니다!',
            ),
          ],
        ),
        // 분기 B: 벌처+탱크로 방어 후 5팩 가동
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 질럿을 끌어내면서 시간을 법니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away}, 벌처 기동력! 질럿을 피하면서 견제!',
            ),
            ScriptEvent(
              text: '{away}, 탱크가 나옵니다! 시즈 모드!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 탱크 화력에 녹아내립니다!',
              owner: LogOwner.home,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리를 추가합니다! 5팩 가동 시작!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -20,
              altText: '{away}, 팩토리 5개! 물량이 쏟아집니다!',
            ),
            ScriptEvent(
              text: '프록시를 막아내고 5팩이 가동됩니다! 물량 차이는 시간 문제!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 물량! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 5팩토리 화력! 프로토스가 버틸 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
