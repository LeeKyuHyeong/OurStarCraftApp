part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 2. 원겟 드라군 넥서스 vs 노겟 넥서스 (밸런스 vs 수비)
// ----------------------------------------------------------
const _pvpDragoonVsNogate = ScenarioScript(
  id: 'pvp_dragoon_vs_nogate',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_dragoon'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '원겟 드라군 넥서스 vs 노겟 넥서스',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스를 먼저 건설합니다! 노겟 넥서스!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 넥서스 퍼스트! 확장을 가져가겠다는 배짱!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 한 기 생산! 상대를 향해 이동합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -10,
          altText: '{home} 선수, 질럿이 나옵니다! 노겟 넥서스를 괴롭히러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 겨우 게이트웨이를 건설합니다. 질럿이 올 텐데요!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 질럿 견제 (lines 17-24)
    ScriptPhase(
      name: 'zealot_harass',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수, 질럿이 상대 앞마당에 도착합니다! 프로브를 노립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 질럿이 프로브를 베기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브와 질럿으로 질럿을 막으려 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 4,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군도 바로 출발! 압박을 이어갑니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 1, homeResource: -15,
        ),
      ],
    ),
    // Phase 2: 초반 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'early_pressure_result',
      branches: [
        // 분기 A: 프로브 피해 성공
        ScriptBranch(
          id: 'zealot_probe_damage',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home} 선수, 질럿이 프로브 3기를 잡습니다! 일꾼 타격!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,              altText: '{home} 선수 질럿 컨트롤! 프로브 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 크네요! 노겟 넥서스의 이점이 줄어듭니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -5,
            ),
            ScriptEvent(
              text: '{home} 선수, 드라군까지 도착! 노겟 넥서스를 흔듭니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3,            ),
            ScriptEvent(
              text: '질럿 견제 성공! 노겟 넥서스의 이점이 사라지고 있습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
            ),
          ],
        ),
        // 분기 B: 프로브 방어 성공
        ScriptBranch(
          id: 'probe_defense_hold',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수, 프로브와 질럿의 협공으로 적 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -1,              altText: '{away} 선수 프로브 컨트롤! 질럿을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿을 잃었습니다! 견제 실패!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수, 게이트가 빠르게 늘어납니다! 넥서스의 자원이 빛을 발합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: 10,
              altText: '{away} 선수 게이트 추가! 자원 이점을 병력으로 전환!',
            ),
            ScriptEvent(
              text: '프로브 수비 성공! 노겟 넥서스의 이점이 살아있습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 셔틀 리버 대결 (lines 41-54)
    ScriptPhase(
      name: 'reaver_battle',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 로보틱스에 서포트 베이 건설! 셔틀 리버를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스에 서포트 베이 건설! 리버 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수, 셔틀 리버 출격! 프로브를 노립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -25,          altText: '{home} 선수 셔틀 리버! PvP의 꽃!',
        ),
        ScriptEvent(
          text: '{away} 선수, 드라군이 셔틀을 노립니다! 격추 시도!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 1, homeArmy: -2,          altText: '{away} 선수 드라군 집중! 셔틀을 노립니다!',
        ),
        ScriptEvent(
          text: '셔틀의 생존이 핵심! PvP를 가르는 순간!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 55-65)
    ScriptPhase(
      name: 'decisive_clash',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러를 병력에 섞습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러 합류!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전 병력이 충돌합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 5: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      branches: [
        ScriptBranch(
          id: 'home_storm_wins',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{home} 선수, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -8, homeArmy: -3,              altText: '{home} 선수 스톰! 드라군 편대가 무너집니다!',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 전장을 지배합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_harass_wins',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{away} 선수, 셔틀에 하이 템플러를 태워서 본진 견제!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15, homeArmy: -3,              altText: '{away} 선수 셔틀 하이 템플러! 본진 스톰!',
            ),
            ScriptEvent(
              text: '본진 견제가 결정적! 판을 뒤집습니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

