part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 원게이트 멀티
// ----------------------------------------------------------
const _pvpZealotRushVs1gateMulti = ScenarioScript(
  id: 'pvp_zealot_rush_vs_1gate_multi',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '질럿 러시 vs 원게이트 멀티',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이! 질럿 러시입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 게이트! 빠른 질럿을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스를 빠르게 건설합니다! 원게이트 멀티!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 빠른 확장! 자원 이점을 노립니다!',
        ),
        ScriptEvent(
          text: '질럿 러시 vs 멀티! 확장을 짓는 상대에게 질럿이 갑니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿 3기가 앞마당 넥서스를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 1기와 프로브로 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '멀티를 간 상대에게 질럿 러시! 앞마당이 위험합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 19-34)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        // 분기 A: 앞마당 파괴
        ScriptBranch(
          id: 'nexus_destroyed',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 앞마당 넥서스를 공격합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 넥서스를 직접 공격! 확장을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브를 동원하지만 질럿이 너무 많습니다!',
              owner: LogOwner.away,
              awayArmy: -1, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿이 합류합니다! 넥서스가 무너집니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시가 멀티를 파괴합니다! 자원 투자가 물거품!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 수비 성공 후 역전
        ScriptBranch(
          id: 'multi_survives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브 협공으로 적 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 질럿 러시를 막았습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 녹고 있습니다! 러시 실패!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 사이버네틱스 코어 건설! 드라군으로 전환합니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 멀티 자원으로 드라군을 빠르게 보충합니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15,
            ),
            ScriptEvent(
              text: '멀티가 살아남았습니다! 자원 차이로 역전합니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
