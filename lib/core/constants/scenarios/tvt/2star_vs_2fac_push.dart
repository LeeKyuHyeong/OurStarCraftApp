part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 클로킹 vs 투팩 벌처
// ----------------------------------------------------------
const _tvt2starVs2facPush = ScenarioScript(
  id: 'tvt_wraith_vs_2fac_vulture',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '투스타 레이스 vs 투팩 벌처 공중 vs 지상',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -150, // 배럭(150)
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150, // 배럭(150)
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설합니다. 빠른 테크.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300, // 팩토리(300)
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 두 번째 팩토리도 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -600, // 팩토리x2(600)
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 두 개에서 벌처 생산 시작.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, // 벌처 2기 (2sup x2)
          awayResource: -150, // 벌처2(150)
          altText: '{away} 선수 벌처가 물 밀듯이! 지상을 장악합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -250, // 스타포트(250)
          altText: '{home} 선수 스타포트가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 정찰합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, // 벌처 2기 추가 (2sup x2)
          awayResource: -150, // 벌처2(150)
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산합니다. 2번째 스타포트도 올립니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, // 레이스 1기 (2sup)
          homeResource: -500, // 레이스(250) + 스타포트(250)
          altText: '{home} 선수 레이스가 나옵니다. 두 번째 스타포트도 건설합니다.',
        ),
        ScriptEvent(
          text: '양쪽 다 공격적인 선택입니다! 공중과 지상의 대결이네요!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
          altText: '공격적인 빌드 선택! 피해를 얼마나 줄 수 있을까요?',
        ),
      ],
    ),
    // Phase 1: 초반 레이스 견제 (lines 12-18) - recovery 150/1
    ScriptPhase(
      name: 'early_wraith_harass',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스가 상대 본진으로! SCV를 노립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 레이스 출격! 상대 SCV를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 짓는 SCV를 노립니다! 스캔을 늦추려는 의도.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{home} 선수 아카데미 건설 SCV를 쫓아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 짓는 SCV도 공격! 골리앗 생산을 늦추려는 의도.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{home} 선수 아머리 건설 SCV까지 괴롭힙니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 SCV까지 노립니다! 터렛 건설도 지연시킵니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{home} 선수 엔지니어링 베이 짓는 SCV도 쫓습니다! 터렛이 늦어지네요!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '공중 유닛 한두 기로는 건설을 완전히 막을 수는 없지만 SCV 피해가 계속 쌓이고 있습니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 건물 옆에 붙여놓고 끈질기게 건설을 시도합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{away} 선수 SCV를 계속 붙이면서 건물을 올립니다! 포기하지 않습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 견제를 이어가면서 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -400, // CC(400)
          altText: '{home} 선수 견제와 동시에 앞마당 확장. 멀티를 챙깁니다.',
        ),
        ScriptEvent(
          text: '피해는 누적되고 있지만 {away} 선수 벌처 물량으로 지상을 장악합니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 클로킹 완성 + 침투 - 분기 (lines 18+) - recovery 200/2
    ScriptPhase(
      name: 'cloak_infiltrate',
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 완성! 레이스 3기가 침투합니다! 아카데미가 늦어서 스캔이 안 됩니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -2,              altText: '{home} 선수 클로킹 레이스 침투! 컴샛스테이션이 없어 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아카데미가 이제야 완성. 컴샛스테이션을 급히 올립니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -150, // 아카데미(150)
              awayArmy: -1,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              awayResource: 0,
              homeArmy: 2, // 레이스 1기 (2sup)
              homeResource: -250, // 레이스(250)
              awayArmy: -2,              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 치명적입니다.',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 올리려 하지만 SCV가 부족합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -150, // 아머리(150)
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_no_antiair',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 아카데미는 올렸습니다. 컴샛스테이션 부착. 스캔은 가능합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -150, // 아카데미(150)
              altText: '{away} 선수 아카데미 완성. 스캔은 달리지만 아머리가 문제입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔에 걸리지만 아머리 짓는 SCV를 집요하게 노립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,              altText: '{home} 선수 아머리 건설을 끈질기게 방해합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 다시 올리지만 또 SCV가 잡힙니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -150, // 아머리(150) 재시도
              awayArmy: -1,
              altText: '{away} 선수 아머리 재건설 시도! 하지만 공중 유닛이 놓아주질 않습니다!',
            ),
            ScriptEvent(
              text: '스캔은 달리는데 골리앗이 없습니다. 마린만으로는 공중 유닛을 잡기 어렵습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 5기 이상. 스타포트 두 개에서 쉬지 않고 뽑아냅니다.',
              owner: LogOwner.home,
              homeArmy: 4, // 레이스 2기 (2sup x2)
              homeResource: -500, // 레이스2(500)
              awayArmy: -2, awayResource: -15,              altText: '{home} 선수 레이스 물량이 쌓입니다! SCV가 녹아내리고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처는 많지만 공중 유닛을 잡을 수가 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -15, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 편대로 상대 본진을 초토화합니다! 대공유닛 없이는 막을 수가 없습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 레이스 물량 앞에 속수무책! 아머리가 끝내 올라오지 못했습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 끈질기게 버텨서 아카데미와 아머리를 모두 완성합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300, // 아카데미(150) + 아머리(150)
              altText: '{away} 선수 피해를 입었지만 핵심 건물을 모두 올렸습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 컴샛스테이션 완성. 스캔으로 클로킹을 잡고 골리앗까지 생산.',
              owner: LogOwner.away,
              homeResource: 0,
              homeArmy: -4, // 레이스 2기 격추 (2sup x2)
              awayArmy: 2, // 골리앗 1기 (2sup)
              awayResource: -150, // 골리앗(150)
              altText: '{away} 선수 스캔과 골리앗! 공중 유닛을 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 하지만 대공 화력이 대기 중!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, // 레이스 1기 손실 (2sup)
            ),
            ScriptEvent(
              text: '{away} 선수 공중 견제를 막아냅니다! 하지만 SCV 피해가 좀 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '공중 견제가 막혔습니다. 팩토리 두 개의 지상 병력이 맵을 장악합니다.',
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
    // Phase 3: 중반 전환 (lines 26-34) - recovery 200/2
    ScriptPhase(
      name: 'mid_transition',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 올립니다. 탱크 생산 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 머신샵(100)
          altText: '{home} 선수 머신샵 부착. 탱크를 준비합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 두 개에서 탱크 벌처가 쏟아집니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -250, // 탱크(250)
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워 건설. 드랍십을 노립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100, // 컨트롤타워(100)
          altText: '{home} 선수 컨트롤타워 완성. 드랍십이 가능합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설. 터렛으로 공중 유닛을 대비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -200, // 엔지니어링베이(125) + 터렛(75)
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산합니다. 기동전을 노리는 운영.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, // 드랍십 1기 (2sup)
          homeResource: -200, // 드랍십(200)
        ),
        ScriptEvent(
          text: '{away} 선수 물량으로 탱크 라인 구축. 방어 태세.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, // 탱크 1기 (2sup)
          awayResource: -250, // 탱크(250)
          altText: '{away} 선수 생산력이 높아 탱크 라인이 두껍습니다.',
        ),
        ScriptEvent(
          text: '중반 전환기. 공중 vs 지상 물량 대결.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 교전 강화 (공격 능력치 유리)
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -2,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -2,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움.',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다. 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 4: 후속 전개 - 분기 (lines 36+) - recovery 300/3
    ScriptPhase(
      name: 'post_defense',
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'good_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크 벌처를 싣습니다. 뒤쪽으로 우회합니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 2,              altText: '{home} 선수 드랍 출격! 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에서 탱크를 내립니다! 미네랄 라인 공격!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -2, awayResource: -15,              altText: '{home} 선수 드랍 견제! 일꾼을 솎아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤를 잡혔습니다! 터렛이 없는 곳입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 동시 전진! 양쪽에서 압박합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3, homeArmy: -1,            ),
            ScriptEvent(
              text: '{home} 선수 레이스 견제로 상대 일꾼을 초토화합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 클로킹 레이스! 스캔 없는 상대를 초토화합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'minimal_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 팩토리 두 개 풀가동. 탱크 벌처가 압도적입니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 4,              altText: '{away} 선수 생산시설 풀가동! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상병력이 부족합니다. 스타포트 투자가 무겁습니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 물량으로 전진합니다.',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,            ),
            ScriptEvent(
              text: '{away} 선수 탱크 시즈 포격! 라인을 밀어냅니다.',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗과 터렛으로 공중 유닛을 격추! 지상전 승리!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 대공 수비 성공! 물량으로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
