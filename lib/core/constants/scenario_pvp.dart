part of 'scenario_scripts.dart';

// ============================================================
// PvP 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

// ----------------------------------------------------------
// 1. 원겟 드라군 넥서스 미러 (가장 대표적인 PvP)
// ----------------------------------------------------------
const _pvpDragoonNexusMirror = ScenarioScript(
  id: 'pvp_dragoon_nexus_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_2gate_dragoon'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '원겟 드라군 넥서스 미러',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 파일런 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작! 사거리 업그레이드!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 드라군이 나옵니다! 사업 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 생산! 사업 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 초반 질럿/드라군 교전 (lines 17-26)
    ScriptPhase(
      name: 'early_skirmish',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 한 기로 상대를 정찰합니다!',
          owner: LogOwner.home,
          favorsStat: 'scout',
          altText: '{home}, 질럿 정찰! 상대 빌드를 확인하러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 질럿으로 정찰!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 확장! 드라군으로 커버하면서!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '양측 모두 확장을 올립니다! 빌드가 동일한데요, 운영 싸움이 중요하겠습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 테크 분기 (lines 27-42)
    ScriptPhase(
      name: 'tech_choice',
      startLine: 27,
      branches: [
        // 분기 A: 로보틱스 (리버)
        ScriptBranch(
          id: 'home_robo_away_dark',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 로보틱스 건설! 서포트 베이까지 이어갑니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home}, 로보틱스에 서포트 베이! 리버를 노리는 건가요?',
            ),
            ScriptEvent(
              text: '{away} 선수 아둔 건설! 질럿 발업을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 아둔! 하이 템플러를 준비하는 건가요?',
            ),
            ScriptEvent(
              text: '{home}, 옵저버터리도 완성! 옵저버를 먼저 뽑을까 리버를 먼저 뽑을까?',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
            ScriptEvent(
              text: '{home} 선수 리버를 먼저 생산! 공격적인 선택입니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -15, favorsStat: 'harass',
              altText: '{home}, 리버 먼저! 견제를 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 그런데 다크 템플러가 잠입합니다! 디텍이 없습니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 B: 양쪽 로보틱스
        ScriptBranch(
          id: 'double_robo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 로보틱스에 서포트 베이 건설!',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수도 로보틱스에 서포트 베이 건설! 셔틀 리버 경쟁!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 셔틀에 리버를 태웁니다! 견제 출발!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 셔틀 리버 출격!',
            ),
            ScriptEvent(
              text: '{away} 선수도 셔틀 리버 출격! 서로 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25,
            ),
            ScriptEvent(
              text: '양측 셔틀 리버가 교차합니다! PvP의 꽃입니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 셔틀 리버 교전 (lines 43-58)
    ScriptPhase(
      name: 'shuttle_reaver_battle',
      startLine: 43,
      branches: [
        // 분기 A: 셔틀 리버 견제 성공
        ScriptBranch(
          id: 'reaver_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 셔틀이 상대 프로브에 리버를 내립니다! 스캐럽!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 리버 투하! 프로브가 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 크네요! 드라군이 달려옵니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 셔틀이 리버를 태우고 안전하게 빠집니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home} 선수 셔틀 컨트롤! 리버를 살립니다!',
            ),
            ScriptEvent(
              text: '리버 견제가 성공! 프로브 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 셔틀 격추
        ScriptBranch(
          id: 'shuttle_shot_down',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 상대 수송선을 집중 사격합니다! 격추!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 드라군 집중 사격! 수송선이 격추됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 셔틀이 떨어집니다! 리버가 고립!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 셔틀 폭사! 리버도 잃을 위기!',
            ),
            ScriptEvent(
              text: '{away}, 고립된 유닛을 잡아냅니다! 드라군 화력!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '셔틀 격추! PvP에서 가장 뼈아픈 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 하이 템플러 준비 (lines 59-66)
    ScriptPhase(
      name: 'ht_prepare',
      startLine: 59,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 하이 템플러가 나왔습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 연구 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 질럿 하이 템플러! 전면전입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 5: 결전 분기 (lines 67-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 67,
      branches: [
        ScriptBranch(
          id: 'home_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 상대 드라군 편대에 떨어집니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 투하! 드라군이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away}, 맞스톰! 하지만 타이밍이 늦었습니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3,
              altText: '{away} 선수도 스톰! 하지만 이미 병력이 부족합니다!',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 상대 드라군 편대에 떨어집니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 투하! 드라군이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 맞스톰! 하지만 타이밍이 늦었습니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3,
              altText: '{home} 선수도 스톰! 하지만 이미 병력이 부족합니다!',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스를 먼저 건설합니다! 노겟 넥서스!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스 퍼스트! 확장을 가져가겠다는 배짱!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 한 기 생산! 상대를 향해 이동합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다! 노겟 넥서스를 괴롭히러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 겨우 게이트웨이를 건설합니다. 질럿이 올 텐데요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 질럿 견제 (lines 17-24)
    ScriptPhase(
      name: 'zealot_harass',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿이 상대 앞마당에 도착합니다! 프로브를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'harass',
          altText: '{home} 선수 질럿이 프로브를 베기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브로 질럿을 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군도 바로 출발! 압박을 이어갑니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
      ],
    ),
    // Phase 2: 초반 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'early_pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 프로브 피해 성공
        ScriptBranch(
          id: 'zealot_probe_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브 3기를 잡습니다! 일꾼 타격!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 질럿 컨트롤! 프로브 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 크네요! 노겟 넥서스의 이점이 줄어듭니다!',
              owner: LogOwner.away,
              awayResource: -5,
            ),
            ScriptEvent(
              text: '{home}, 드라군까지 도착! 노겟 넥서스를 흔듭니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 견제 성공! 노겟 넥서스의 이점이 사라지고 있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 프로브 방어 성공
        ScriptBranch(
          id: 'probe_defense_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 프로브와 질럿의 협공으로 적 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 프로브 컨트롤! 질럿을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿을 잃었습니다! 견제 실패!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 게이트가 빠르게 늘어납니다! 넥서스의 자원이 빛을 발합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: 10,
              altText: '{away} 선수 게이트 추가! 자원 이점을 병력으로 전환!',
            ),
            ScriptEvent(
              text: '프로브 수비 성공! 노겟 넥서스의 이점이 살아있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 셔틀 리버 대결 (lines 41-54)
    ScriptPhase(
      name: 'reaver_battle',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 로보틱스에 서포트 베이 건설! 셔틀 리버를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스에 서포트 베이 건설! 리버 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home}, 셔틀 리버 출격! 프로브를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버! PvP의 꽃!',
        ),
        ScriptEvent(
          text: '{away}, 드라군이 셔틀을 노립니다! 격추 시도!',
          owner: LogOwner.away,
          homeArmy: -2, favorsStat: 'defense',
          altText: '{away} 선수 드라군 집중! 셔틀을 노립니다!',
        ),
        ScriptEvent(
          text: '셔틀의 생존이 핵심! PvP를 가르는 순간!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 55-65)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러를 병력에 섞습니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러 합류!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전 병력이 충돌합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 5: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 66,
      branches: [
        ScriptBranch(
          id: 'home_storm_wins',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰! 드라군 편대가 무너집니다!',
            ),
            ScriptEvent(
              text: '스톰이 결정적! 전장을 지배합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_harass_wins',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away}, 셔틀에 하이 템플러를 태워서 본진 견제!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -3, favorsStat: 'harass',
              altText: '{away} 선수 셔틀 하이 템플러! 본진 스톰!',
            ),
            ScriptEvent(
              text: '본진 견제가 결정적! 판을 뒤집습니다!',
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

// ----------------------------------------------------------
// 3. 투겟 리버 vs 투겟 드라군 (공격적 대결)
// ----------------------------------------------------------
const _pvpRoboVs2gateDragoon = ScenarioScript(
  id: 'pvp_robo_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  awayBuildIds: ['pvp_2gate_dragoon', 'pvp_4gate_dragoon'],
  description: '원겟 로보 리버 vs 투겟 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 테크를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 로보틱스! 테크를 올리는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 추가! 드라군을 빠르게 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 투게이트! 드라군 물량으로 밀어붙이려는 의도!',
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이 건설! 셔틀과 리버를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 서포트 베이! 리버를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 빠르게 모입니다! 사업 완료!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 드라군 편대가 두꺼워지고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 셔틀과 리버 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 셔틀에 리버를 태울 준비를 합니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 압박 vs 리버 등장 (lines 17-26)
    ScriptPhase(
      name: 'dragoon_push_vs_reaver',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 드라군 편대가 전진합니다! 테크 전에 밀어야 합니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'attack',
          altText: '{away} 선수 드라군 전진! 상대 테크가 완성되기 전에!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 적지만 리버가 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 리버가 합류! 화력이 보강됩니다!',
        ),
        ScriptEvent(
          text: '드라군 물량 vs 리버 화력! 어느 쪽이 유리할까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'clash_result',
      startLine: 27,
      branches: [
        // 분기 A: 드라군 물량이 밀어냄
        ScriptBranch(
          id: 'dragoon_overwhelm',
          baseProbability: 0.93,
          events: [
            ScriptEvent(
              text: '{away}, 드라군 물량이 상대 테크 전에 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 드라군이 압도합니다! 수가 너무 많아요!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 부족합니다! 리버도 보호가 안 돼요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 상대 핵심 유닛을 잡아냅니다! 드라군 집중 사격!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '드라군 물량 차이가 결정적! 상대 테크를 압도합니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 리버가 화력으로 역전
        ScriptBranch(
          id: 'reaver_turns_tide',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 리버 스캐럽! 드라군 2기가 한 번에!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 스캐럽 명중! 드라군이 터집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 상대 화력에 녹고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 상대 화력을 감당 못 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버 컨트롤! 내렸다 태웠다! 완벽합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '리버 화력이 드라군 물량을 압도합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 43-52)
    ScriptPhase(
      name: 'late_game',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 넥서스 건설! 확장을 가져갑니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 넥서스! 비슷한 구성으로 전환!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home}, 하이 템플러 준비! 스톰 연구!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰 대결!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 리버 하이 템플러! 전면전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_storm_reaver_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰과 리버 화력! 드라군이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -10, homeArmy: -5, favorsStat: 'strategy',
              altText: '{home} 선수 스톰에 스캐럽 이중 화력!',
            ),
            ScriptEvent(
              text: '스톰과 리버가 결정적! 전장을 지배합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 맞스톰! 양쪽 병력이 동시에 소멸합니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -8, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '맞스톰 이후 병력 운용이 결정적! 판을 뒤집습니다!',
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

// ----------------------------------------------------------
// 4. 다크 올인 vs 드라군 (치즈)
// ----------------------------------------------------------
const _pvpDarkVsDragoon = ScenarioScript(
  id: 'pvp_dark_vs_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_2gate_dragoon', 'pvp_1gate_robo', 'pvp_1gate_multi'],
  description: '다크 올인 vs 스탠다드 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크를 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 다크 더블! 올인 빌드입니다!',
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대 진영으로!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 다크 2기 출발! 보이지 않는 칼!',
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스에 옵저버터리를 지었을까요? 드라군을 뽑고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '다크 템플러가 접근합니다! 디텍이 있느냐 없느냐!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-36)
    ScriptPhase(
      name: 'dark_result',
      startLine: 23,
      branches: [
        ScriptBranch(
          id: 'dark_massacre',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 프로브를 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 다크 성공! 프로브가 몰살당합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디텍이 없습니다! 다크에 속수무책!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 디텍이 전혀 없습니다! 다크를 막을 수가 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 다크가 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 올인 대성공! 프로토스 일꾼이 파괴됐습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'dark_blocked',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 옵저버가 다크를 포착합니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'scout',
              altText: '{away}, 옵저버 있습니다! 다크가 보여요!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 다크를 집중 사격! 격파!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 다크를 잡아냅니다! 완벽한 대응!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 막혔습니다! 올인이 실패하면 위기!',
              owner: LogOwner.home,
              homeResource: -15, homeArmy: -1,
            ),
            ScriptEvent(
              text: '다크 올인이 막혔습니다! 병력과 테크 모두 뒤처지는 상황!',
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

// ----------------------------------------------------------
// 5. 센터 99게이트 vs 스탠다드 (질럿 러시)
// ----------------------------------------------------------
const _pvpZealotRush = ScenarioScript(
  id: 'pvp_zealot_rush',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush', 'pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_2gate_dragoon', 'pvp_1gate_robo', 'pvp_1gate_multi'],
  description: '센터 게이트 질럿 러시 vs 스탠다드',
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
          text: '{home} 선수 센터에 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터에 게이트웨이! 질럿 러시입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 질럿이 나옵니다!',
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿 3기가 상대 진영으로 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 1기로 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '센터 게이트 질럿 러시! 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 19-32)
    ScriptPhase(
      name: 'rush_result',
      startLine: 19,
      branches: [
        ScriptBranch(
          id: 'zealot_rush_wins',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 잡습니다! 수적 우위!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브 피해가 큽니다! 자원이 흔들립니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿까지 합류! 상대 본진 초토화!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 프로토스가 무너지고 있습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'rush_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브로 협공! 적 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 완벽한 수비! 질럿 러시를 막습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 녹고 있습니다! 러시 실패!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 드라군이 나오면서 반격 준비!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15,
            ),
            ScriptEvent(
              text: '질럿 러시가 막혔습니다! 테크 차이가 벌어집니다!',
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

// ----------------------------------------------------------
// 6. 다크 올인 vs 질럿 러시 (치즈 vs 치즈)
// ----------------------------------------------------------
const _pvpDarkVsZealotRush = ScenarioScript(
  id: 'pvp_dark_vs_zealot_rush',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_zealot_rush', 'pvp_3gate_speedzealot'],
  description: '다크 올인 vs 질럿 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 앞으로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 게이트웨이! 질럿 러시입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 센터에 게이트웨이! 질럿을 쏟아냅니다!',
        ),
        ScriptEvent(
          text: '양쪽 다 치즈 빌드! 올인 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-20)
    ScriptPhase(
      name: 'zealot_rush_arrives',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 질럿 3기가 상대 진영으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'attack',
          altText: '{away} 선수 질럿 러시! 다크가 나오기 전에 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 1기로 막으면서 다크를 기다립니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          altText: '{home}, 질럿 한 기로 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설 중! 다크까지 버틸 수 있을까요?',
          owner: LogOwner.home,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'cheese_result',
      startLine: 21,
      branches: [
        // 분기 A: 질럿 러시가 다크 전에 밀어버림
        ScriptBranch(
          id: 'zealot_overruns',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 게이트웨이를 부수고 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, favorsStat: 'attack',
              altText: '{away} 선수 질럿이 건물을 부수기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브가 잡히고 있습니다! 다크가 아직이에요!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 추가 질럿 합류! 템플러 아카이브도 위험합니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시가 다크보다 빨랐습니다! 본진이 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 다크가 나오면서 역전
        ScriptBranch(
          id: 'dark_comes_out',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 다크 템플러가 나옵니다! 질럿 러시를 버텨냈습니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'defense',
              altText: '{home} 선수 다크 등장! 보이지 않는 반격!',
            ),
            ScriptEvent(
              text: '{away} 선수 다크가 질럿을 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 질럿이 다크에 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{home}, 다크를 상대 본진으로 보냅니다! 역습!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 템플러가 판을 뒤집습니다! 치즈 vs 치즈의 결말!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 7. 로보 미러 (리버 대결)
// ----------------------------------------------------------
const _pvpRoboMirror = ScenarioScript(
  id: 'pvp_robo_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  awayBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  description: '로보틱스 미러 - 셔틀 리버 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군을 뽑습니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 서포트 베이까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스에 서포트 베이! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스에 서포트 베이! 양쪽 테크 경쟁입니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 로보틱스에 서포트 베이! 테크 경쟁!',
        ),
      ],
    ),
    // Phase 1: 셔틀 리버 출격 (lines 17-26)
    ScriptPhase(
      name: 'shuttle_reaver_deploy',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 셔틀에 리버를 태웁니다! 출격!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25, favorsStat: 'harass',
          altText: '{home} 선수 셔틀 리버 출격! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 셔틀 리버! 교차 견제!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25, favorsStat: 'harass',
          altText: '{away}, 셔틀 리버 출발! 양쪽 리버가 교차합니다!',
        ),
        ScriptEvent(
          text: '양측 셔틀 리버 교차! 누가 먼저 피해를 입힐까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 셔틀 리버 견제 결과 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'reaver_harass_result',
      startLine: 27,
      branches: [
        // 분기 A: 홈 리버 견제 성공 + 어웨이 셔틀 격추
        ScriptBranch(
          id: 'home_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 리버가 프로브 쪽에 착지! 스캐럽!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 리버 투하! 프로브가 날아갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 상대 셔틀을 노립니다! 격추!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 셔틀 격추! 하지만 프로브 피해가 크네요!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀은 잃었지만 프로브 피해를 더 많이 줬습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '리버 교환이 끝났습니다! 프로브 피해 차이가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 리버 견제 성공 + 홈 셔틀 격추
        ScriptBranch(
          id: 'away_reaver_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 리버가 프로브 쪽에 투하! 스캐럽 명중!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 리버 투하! 프로브가 쓸려갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군으로 상대 셔틀을 잡습니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{home}, 셔틀을 잡긴 했지만 프로브 피해가!',
            ),
            ScriptEvent(
              text: '{away}, 프로브 피해를 더 많이 입혔습니다! 자원 이점!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '리버 견제 교환! 프로브 피해가 핵심이었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 하이 템플러 준비 (lines 43-50)
    ScriptPhase(
      name: 'ht_prepare',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 하이 템플러! 스톰 연구 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 양쪽 스톰 대결!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 드라군 리버 하이 템플러! 전면전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 분기 (lines 51-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 51,
      branches: [
        ScriptBranch(
          id: 'home_storm_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 스톰! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '{away}, 맞스톰! 하지만 이미 병력 차이가 벌어졌습니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3,
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_dominates',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 상대 드라군이 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 스톰! 드라군 편대가 증발!',
            ),
            ScriptEvent(
              text: '{home}, 맞스톰! 하지만 이미 병력 차이가 벌어졌습니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3,
            ),
            ScriptEvent(
              text: '결정적인 순간입니다!',
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

// ----------------------------------------------------------
// 8. 4게이트 드라군 vs 원겟 멀티 (공격 vs 운영)
// ----------------------------------------------------------
const _pvp4gateVsMulti = ScenarioScript(
  id: 'pvp_4gate_vs_multi',
  matchup: 'PvP',
  homeBuildIds: ['pvp_4gate_dragoon'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '4게이트 드라군 vs 원겟 멀티',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 드라군 사업!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어 건설!',
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스를 빠르게 건설합니다! 원겟 멀티!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 빠른 확장! 자원 이점을 가져가겠다는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 빠르게 추가합니다! 3게이트!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 게이트웨이 추가! 드라군을 빠르게 모읍니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 압박 (lines 15-24)
    ScriptPhase(
      name: 'dragoon_pressure',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 드라군 편대가 전진합니다! 멀티를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20, favorsStat: 'attack',
          altText: '{home} 선수 드라군 전진! 확장을 흔들어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 아직 적습니다! 멀티 자원을 믿고 버팁니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 드라군 수가 부족합니다! 시간을 벌어야 해요!',
        ),
        ScriptEvent(
          text: '4게이트 물량 vs 멀티 확장! 시간이 핵심입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 드라군 물량이 밀어냄
        ScriptBranch(
          id: 'dragoon_rush_wins',
          baseProbability: 0.3,
          events: [
            ScriptEvent(
              text: '{home}, 드라군 물량으로 상대 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 드라군이 밀려옵니다! 수가 너무 많아요!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 부족합니다! 게이트가 아직 안 돌아요!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 넥서스를 공격합니다! 확장을 무너뜨립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4게이트 타이밍! 멀티가 자리잡기 전에 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 멀티가 버텨내며 역전
        ScriptBranch(
          id: 'multi_holds',
          baseProbability: 1.7,
          events: [
            ScriptEvent(
              text: '{away}, 드라군과 질럿으로 앞마당을 지켜냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 드라군을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군을 많이 잃었습니다! 압박 실패!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 게이트웨이가 추가로 돌아갑니다! 멀티 자원이 빛을 발합니다!',
              owner: LogOwner.away,
              awayArmy: 7, awayResource: 20,
              altText: '{away} 선수 병력이 쏟아져 나옵니다! 멀티의 힘!',
            ),
            ScriptEvent(
              text: '멀티가 버텨냈습니다! 자원 차이로 병력이 역전됩니다!',
              owner: LogOwner.away,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 41-52)
    ScriptPhase(
      name: 'late_game',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수도 앞마당 확장! 장기전으로 전환!',
          owner: LogOwner.home,
          homeResource: -30,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 멀티 자원으로 병력을 빠르게 보충합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15,
          altText: '{away}, 멀티의 자원이 빛을 발합니다! 병력 보충이 빠릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 병력을 모읍니다. 하지만 자원이 부족합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away}, 드라군 편대가 전진합니다! 멀티의 힘!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: 10, favorsStat: 'attack',
          altText: '{away} 선수 멀티 자원으로 압도합니다!',
        ),
        ScriptEvent(
          text: '멀티가 살아남으면서 자원 차이가 결정적입니다!',
          owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 9. 질럿 러시 vs 리버 (올인 vs 테크)
// ----------------------------------------------------------
const _pvpZealotRushVsReaver = ScenarioScript(
  id: 'pvp_zealot_rush_vs_reaver',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush', 'pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_1gate_robo', 'pvp_2gate_reaver'],
  description: '질럿 러시 vs 로보 리버',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
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
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 게이트웨이! 질럿 러시!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터에 게이트웨이! 질럿을 빠르게 뽑겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 로보틱스 건설! 테크를 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 추가 질럿 생산! 빠르게 공격 준비!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10,
          altText: '{home}, 질럿이 계속 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 서포트 베이 건설! 셔틀과 리버를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -10, awayArmy: 2,
          altText: '{away}, 서포트 베이! 리버를 노립니다!',
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-20)
    ScriptPhase(
      name: 'zealot_charge',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿이 상대 진영으로 돌진합니다! 테크 전에 끝내야 합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 질럿 러시! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군과 질럿으로 막습니다! 리버까지 버텨야!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 수비! 리버가 나올 때까지!',
        ),
        ScriptEvent(
          text: '질럿 러시 vs 로보 테크! 시간 싸움입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'rush_vs_tech_result',
      startLine: 21,
      branches: [
        // 분기 A: 질럿이 리버 전에 밀어냄
        ScriptBranch(
          id: 'zealot_before_reaver',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 프로브를 잡습니다! 상대 테크가 아직이에요!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 프로브를 베어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 리버가 생산 중이지만 시간이 부족합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿 합류! 로보틱스까지 위협합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '질럿 러시 성공! 상대 테크가 완성되기 전에 밀어냈습니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 리버가 나오면서 역전
        ScriptBranch(
          id: 'reaver_saves',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿과 프로브로 버팁니다! 리버가 곧!',
              owner: LogOwner.away,
              homeArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 수비! 리버만 나오면!',
            ),
            ScriptEvent(
              text: '{away}, 리버가 나왔습니다! 스캐럽! 질럿이 터집니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: 2, favorsStat: 'control',
              altText: '{away} 선수 리버 등장! 스캐럽 한 방에 질럿이!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 상대 화력에 녹고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '상대 화력이 판을 뒤집습니다! 질럿으로는 감당할 수 없습니다!',
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

// ----------------------------------------------------------
// 10. 다크 올인 미러 (다크 vs 다크)
// ----------------------------------------------------------
const _pvpDarkMirror = ScenarioScript(
  id: 'pvp_dark_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_dark_allin'],
  description: '다크 올인 미러',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔! 다크를 노립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아둔! 양쪽 다 다크를 노리는 상황입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아둔! 양쪽 다 다크를 노리네요!',
        ),
        ScriptEvent(
          text: '양측 다크 올인! 서로 상대 다크를 모르는 상황!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_deploy',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대 진영으로!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 다크 출발! 보이지 않는 칼!',
        ),
        ScriptEvent(
          text: '{away} 선수도 다크 2기! 교차 투입!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 다크 출발! 서로 다크를 보냅니다!',
        ),
        ScriptEvent(
          text: '양쪽 다크가 교차합니다! 디텍은 누구에게도 없습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'dark_result',
      startLine: 23,
      branches: [
        // 분기 A: 홈 다크가 더 큰 피해
        ScriptBranch(
          id: 'home_dark_more_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 프로브에 도착! 학살!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 다크 성공! 프로브가 몰살!',
            ),
            ScriptEvent(
              text: '{away}, 다크가 상대 프로브도 베고 있습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 다크 컨트롤! 프로브를 더 많이 잡았습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '다크 교환! 프로브 피해 차이가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 어웨이 다크가 더 큰 피해
        ScriptBranch(
          id: 'away_dark_more_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 다크가 프로브를 베기 시작합니다! 큰 피해!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 다크 대성공! 프로브가 녹습니다!',
            ),
            ScriptEvent(
              text: '{home}, 다크가 프로브를 잡고는 있지만 피해가 적습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 다크 컨트롤! 더 많은 프로브를 잡습니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '다크 교환에서 밀렸습니다! 프로브 차이가 크네요!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 복구전 (lines 39-52)
    ScriptPhase(
      name: 'recovery_battle',
      startLine: 39,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 캐논을 건설합니다! 추가 다크에 대비!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 캐논! 양쪽 다크 대비!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어! 드라군 테크!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스에 옵저버터리, 서포트 베이까지! 옵저버와 리버를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 로보틱스에 서포트 베이, 옵저버터리까지! 다크 교환 이후 테크 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스에 서포트 베이, 옵저버터리! 셔틀 리버 경쟁!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home}, 드라군을 모아 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home} 선수 드라군 편대 전진!',
        ),
        ScriptEvent(
          text: '{away}, 드라군으로 맞대응! 병력을 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수도 드라군 편대를 구성합니다!',
        ),
      ],
    ),
    // Phase 4: 결전 분기 (lines 53-65)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'home_recovers_faster',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 프로브를 먼저 복구! 자원이 돌아옵니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: 10, favorsStat: 'macro',
              altText: '{home} 선수 일꾼 복구가 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버 출격! 남은 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 교환 이후 복구전에서 앞섭니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_recovers_faster',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 프로브를 먼저 복구! 자원이 돌아옵니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: 10, favorsStat: 'macro',
              altText: '{away} 선수 일꾼 복구가 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away}, 셔틀 리버 출격! 남은 프로브를 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 교환 이후 복구전에서 앞섭니다!',
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
