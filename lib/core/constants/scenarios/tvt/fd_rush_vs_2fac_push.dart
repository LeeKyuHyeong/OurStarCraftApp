part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 vs 투팩타이밍 (탱크 시즈 vs 벌처 물량)
// ----------------------------------------------------------
const _tvtFdRushVs2facPush = ScenarioScript(
  id: 'tvt_fd_rush_vs_2fac_push',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_2fac_push'],
  description: 'FD 러쉬 vs 투팩타이밍 벌처 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-8) - recovery 100/0
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭 150
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 머신샵 부착.',
          owner: LogOwner.home,
          homeResource: -400, // 팩토리 300 + 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 팩토리에 머신샵. 시즈 모드를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 바로 두 번째 팩토리도.',
          owner: LogOwner.away,
          awayResource: -600, // 팩토리 x2 (300+300)
          fixedCost: true,
          altText: '{away} 선수 팩토리 투팩. 벌처를 대량 생산할 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작. 시즈 모드 연구도.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 탱크 250 + 시즈모드 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 쏟아져 나옵니다! 속업 연구.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -350, // 벌처 2기 (75x2) + 속업 200
          fixedCost: true,
          altText: '{away} 선수 벌처 속업. 투팩에서 벌처가 물 밀듯이!',
        ),
        ScriptEvent(
          text: '탱크 시즈 vs 벌처 물량! 정면 대결이 예고됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벌처 vs 탱크 초기 교전 (lines 12-20) - recovery 150/1
    ScriptPhase(
      name: 'vulture_vs_tank',
      startLine: 12,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 벌처 4기로 센터를 장악합니다! 마인 매설!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150, // 벌처 2기 (75x2)
          fixedCost: true,
          favorsStat: 'control',
          altText: '{away} 선수 벌처 센터 장악! 마인도 깝니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈 모드! 센터에 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수 시즈 모드. 벌처 접근을 차단합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 시즈 탱크를 우회하려 합니다!',
          owner: LogOwner.away,
          favorsStat: 'harass',
          altText: '{away} 선수 벌처 우회! 탱크 옆을 돌아갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린과 벌처로 시즈 탱크를 호위합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -125, // 마린 1기 50 + 벌처 1기 75
          fixedCost: true,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '벌처의 기동력 vs 탱크의 화력! 치열한 공방!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 중반 충돌 분기 (lines 24-36) - recovery 150/1
    ScriptPhase(
      name: 'mid_clash',
      startLine: 24,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 탱크 시즈가 벌처를 잡음
        ScriptBranch(
          id: 'siege_kills_vultures',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 포격! 벌처가 직격탄에 폭발합니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 벌처 2기가 한번에!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 손실이 심각합니다! 시즈 사거리가 넓어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 전진 배치합니다. 라인을 밀어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 1기 250
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 시즈 라인이 압박합니다!',
            ),
            ScriptEvent(
              text: '시즈 탱크 앞에서 벌처가 무력합니다!',
              owner: LogOwner.system,
              skipChance: 0.25,
            ),
          ],
        ),
        // 분기 B: 벌처가 탱크 라인을 우회
        ScriptBranch(
          id: 'vulture_flank',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 마인을 피하며 옆길로 침투합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'control',
              altText: '{away} 선수 벌처 우회! SCV를 급습!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 시즈 모드라 돌아서 대응이 늦습니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 벌처까지! 상대 일꾼을 쓸어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -150, // 벌처 2기 (75x2)
              fixedCost: true,
              homeResource: -10, favorsStat: 'harass',
              altText: '{away} 선수 벌처 물량! 일꾼 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '벌처 기동력! 시즈 탱크를 무시하고 후방을 공격!',
              owner: LogOwner.system,
              skipChance: 0.25,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 38-46) - recovery 200/2
    ScriptPhase(
      name: 'late_game',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당에서 탱크를 추가 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -500, // 탱크 2기 (250x2)
          fixedCost: true,
          altText: '{home} 선수 더블 팩토리에서 탱크가 쏟아집니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산 시작. 벌처만으로는 한계.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -350, // 머신샵 100 + 탱크 250
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 FD 러쉬 준비 완료. 탱크 라인 전진!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 탱크 1기 250
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 대군! 전진합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설. 드랍십을 준비합니다. 정면은 피하고 뒤를 칩니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -450, // 스타포트 250 + 드랍십 200
          fixedCost: true,
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 교전 강화 (공격 능력치 유리)
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다! 지형 싸움!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 3b: 중반 탱크 푸시 분기 (lines 46-50) - recovery 200/2
    ScriptPhase(
      name: 'mid_tank_push',
      startLine: 46,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 - 소규모 피해 후 회수
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 벌처를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 SCV를 잡아냅니다! 빠르게 회수!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드랍 견제 성공! 일꾼 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 벌처 기동력으로 피해를 주고 빠집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 마무리 탱크 푸시 - FD 측 정면 공격
        ScriptBranch(
          id: 'finishing_push',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 전진시킵니다! 정면 돌파!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 시즈 포격! 상대 벌처 라인을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로는 탱크 라인을 뚫을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 화력이 벌처 물량을 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 시즈가 모든 것을 결정합니다!',
            ),
          ],
        ),
        // 벌처 역습 - 투팩 측 반격
        ScriptBranch(
          id: 'vulture_counterattack',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 대군으로 탱크 라인을 우회합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'control',
              altText: '{away} 선수 벌처 대군! 탱크를 무시하고 후방을 칩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후방이 뚫립니다! 일꾼 피해가 심각합니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '벌처 기동력이 탱크 화력을 넘어섭니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 필사적 역전 - 밀리는 쪽의 승부수
        ScriptBranch(
          id: 'desperate_counter',
          baseProbability: 0.6,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{away} 선수 물량을 쏟아붓습니다! 벌처와 탱크를 동시에!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500, // 탱크 250 + 벌처 2기 150 + 잔여
              fixedCost: true,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{away} 선수 정면과 측면 동시 공격! 상대 라인이 흔들립니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'sense',
              altText: '{away} 선수 양면 공격! 탱크 라인이 갈립니다!',
            ),
            ScriptEvent(
              text: '투팩의 물량이 한꺼번에 몰려옵니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 (lines 52+) - recovery 300/3
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 52,
      recoveryResourcePerLine: 300,
      recoveryArmyPerLine: 3,
      branches: [
        ScriptBranch(
          id: 'fd_rush_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시즈 라인이 상대 앞마당까지 도달합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 탱크 포격! 상대 앞마당이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로는 탱크 라인을 뚫을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크의 화력이 벌처를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 물량으로 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'vulture_mass_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 견제가 누적됩니다! 상대 자원이 바닥!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 벌처 견제! 자원 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 보충이 안 됩니다! 일꾼 피해가 너무 큽니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 기동력으로 탱크 체제를 무너뜨립니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 견제와 우회로 승리를 가져갑니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
