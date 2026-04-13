part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 16. 원팩확장 미러 (마인 기반 수비적 TvT)
// ----------------------------------------------------------
const _tvt1facDoubleMirror = ScenarioScript(
  id: 'tvt_1fac_double_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_double'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '원팩확장 마인 기반 장기전',
  phases: [
    // ── Phase 0: 오프닝 (배럭 → 가스 → 팩토리 → 벌처와 마인 → CC) ──
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 배럭을 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수도 배럭을 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -100,
          fixedCost: true,
          altText: '{home} 선수 리파이너리 건설, 가스 채취를 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 리파이너리, 가스 채취 시작.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올리면서 가스에서 SCV를 빼 미네랄로 돌립니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 팩토리 건설 시작, 가스 조절로 미네랄을 확보합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올리면서 가스 조절을 합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 팩토리 건설, 가스에서 SCV를 빼 미네랄 확보.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산, 가스 SCV를 다시 투입합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75,
          fixedCost: true,
          altText: '{home} 선수 첫 벌처가 나왔습니다, 가스 재채취 시작.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산, 정찰을 보냅니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75,
          fixedCost: true,
          altText: '{away} 선수도 벌처를 내보냅니다, 상대를 확인합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵을 건설합니다.',
          owner: LogOwner.home,
          fixedCost: true,
          altText: '{home} 선수 머신샵을 올립니다, 연구 선택이 관건입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵을 건설합니다.',
          owner: LogOwner.away,
          fixedCost: true,
          altText: '{away} 선수도 머신샵을 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
          altText: '{home} 선수 앞마당 확장, 원팩 더블입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 앞마당 확장합니다.',
        ),
        ScriptEvent(
          text: '머신샵 연구 선택이 관건입니다. 운영 싸움이 중요하겠습니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
          altText: '마인이냐 속업이냐 시즈냐. 작은 실수도 크게 벌어질 수 있는게 같은 빌드 싸움이죠.',
        ),
      ],
    ),
    // ── Phase 1: 머신샵 연구 선택 - 분기 (어차피 다 올릴 거라 크리티컬하지 않음) ──
    ScriptPhase(
      name: 'research_choice',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 양측 마인 → 수비적 전개
        ScriptBranch(
          id: 'both_mine',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 마인 연구를 먼저 선택합니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 머신샵에서 마인 연구부터.',
            ),
            ScriptEvent(
              text: '{away} 선수도 마인 연구를 먼저 돌립니다.',
              owner: LogOwner.away,
              altText: '{away} 선수도 마인부터, 같은 선택입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 추가 생산, 마인을 매설하면서 정찰합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75,
              fixedCost: true,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 추가, 마인 매설하면서 이동합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처 추가, 마인을 깔면서 정찰합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '양측 마인 먼저, 수비적인 초반 전개입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '마인부터 선택, 조심스러운 벌처전이 예상됩니다.',
            ),
          ],
        ),
        // 분기 B: 홈 속업 / 어웨이 마인
        ScriptBranch(
          id: 'home_speed_away_mine',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 속업 연구를 먼저 선택합니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 머신샵에서 속업부터.',
            ),
            ScriptEvent(
              text: '{away} 선수는 마인 연구를 먼저 돌립니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 마인부터, 순서가 다릅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 속업 벌처가 센터를 먼저 장악합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75,
              fixedCost: true,
              favorsStat: 'scout',
              altText: '{home} 선수 속업 벌처! 기동력이 빠릅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 마인 매설로 앞마당을 방어합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'defense',
            ),
          ],
        ),
        // 분기 C: 홈 마인 / 어웨이 속업
        ScriptBranch(
          id: 'home_mine_away_speed',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마인 연구를 먼저 선택합니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 머신샵에서 마인부터.',
            ),
            ScriptEvent(
              text: '{away} 선수는 속업 연구를 먼저 선택합니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 속업부터, 순서가 다릅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 속업 벌처가 센터를 먼저 장악합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'scout',
              altText: '{away} 선수 속업 벌처! 기동력이 빠릅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마인 매설로 앞마당을 방어합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75,
              fixedCost: true,
              favorsStat: 'defense',
            ),
          ],
        ),
        // 분기 D: 양측 속업 → 벌처 기동전
        ScriptBranch(
          id: 'both_speed',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home} 선수 속업 연구를 먼저 선택합니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 머신샵에서 속업부터.',
            ),
            ScriptEvent(
              text: '{away} 선수도 속업 연구를 먼저! 벌처 기동전!',
              owner: LogOwner.away,
              altText: '{away} 선수도 속업부터, 양측 공격적입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 속업 벌처로 센터를 향합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75,
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 추가! 센터에서 격돌 준비.',
            ),
            ScriptEvent(
              text: '{away} 선수도 속업 벌처 출격! 센터에서 마주칩니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'control',
              altText: '{away} 선수도 벌처 출격! 양쪽 속업 벌처전.',
            ),
            ScriptEvent(
              text: '양측 속업 먼저! 벌처 기동전이 벌어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '속업부터 선택, 공격적인 벌처전입니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 2: 벌처 교전 결과 - 분기 ──
    ScriptPhase(
      name: 'vulture_result',
      startLine: 26,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 홈 벌처 우세 (마인 활용)
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 컨트롤이 좋습니다! 상대 벌처를 압도합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 벌처를 격파합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마인으로 맵 컨트롤을 잡습니다.',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 마인을 깔아 상대 이동 경로를 차단합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 앞마당 SCV를 괴롭힙니다!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 벌처 견제! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '벌처전에서 밀리면 맵 컨트롤이 넘어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 근거리 맵이라 벌처가 바로 앞마당에 도착! 추가 SCV 피해!',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              requiresMapTag: 'rushShort',
            ),
          ],
        ),
        // 어웨이 벌처 우세
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 컨트롤이 앞섭니다! 상대 벌처를 격파합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 컨트롤 차이! 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마인 매설로 맵 컨트롤을 확보합니다.',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 마인을 깔아 상대 병력 이동을 제한합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 앞마당으로 침투! SCV 견제!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 벌처 침투! SCV를 솎아냅니다!',
            ),
            ScriptEvent(
              text: '벌처전에서 밀린 쪽이 SCV 피해를 입었습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 근거리 맵이라 벌처가 바로 도착! SCV 피해가 더 큽니다!',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              requiresMapTag: 'rushShort',
            ),
          ],
        ),
        // 홈 벌처 압살 → 조기 종료
        ScriptBranch(
          id: 'home_vulture_crush',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처가 상대 벌처를 전멸시킵니다! 벌처 컨트롤이 완벽합니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 압도! 상대 벌처가 전멸!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처가 상대 앞마당으로 돌진합니다! SCV를 대량 학살!',
              owner: LogOwner.home,
              awayResource: -400,
              favorsStat: 'harass',
              altText: '{home} 선수 벌처 난입! SCV가 줄줄이 터집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진까지 침투! SCV가 녹아내립니다!',
              owner: LogOwner.home,
              awayResource: -300,
              favorsStat: 'attack',
              altText: '{home} 선수 본진 SCV까지 타격! 자원 채취가 마비됩니다!',
            ),
            ScriptEvent(
              text: '벌처에 SCV를 너무 많이 잃었습니다! 회복이 불가능합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 견제가 치명적입니다! 상대 자원 채취가 마비됩니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 난동이 계속됩니다! SCV가 일할 수 없습니다!',
            ),
          ],
        ),
        // 어웨이 벌처 압살 → 조기 종료
        ScriptBranch(
          id: 'away_vulture_crush',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 상대 벌처를 전멸시킵니다! 마인밭을 돌파!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 컨트롤 압도! 상대 벌처가 전멸!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 상대 앞마당 SCV를 대량으로 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -400,
              favorsStat: 'harass',
              altText: '{away} 선수 벌처 난입! SCV가 줄줄이 터집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진까지 침투! SCV가 녹아내립니다!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'attack',
              altText: '{away} 선수 본진 SCV까지 타격! 자원 채취가 마비됩니다!',
            ),
            ScriptEvent(
              text: '벌처에 SCV를 너무 많이 잃었습니다! 회복이 불가능합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 견제가 치명적입니다! 상대 자원 채취가 마비됩니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 벌처 난동이 계속됩니다! SCV가 일할 수 없습니다!',
            ),
          ],
        ),
        // 교착 (마인밭 대치)
        ScriptBranch(
          id: 'vulture_stalemate',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 벌처가 비등합니다, 서로 마인만 깔고 물러납니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '마인밭 대치, 양측 마인을 깔며 영역만 확보합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 마인 위치를 탐색합니다.',
              owner: LogOwner.home,
              awayResource: -100,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 견제, SCV 몇 기를 잡습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처로 반대편을 찌릅니다.',
              owner: LogOwner.away,
              homeResource: -100,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{away} 선수도 벌처 견제, 서로 SCV를 교환합니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 탱크와 벌처 (시즈 모드 연구 전) ──
    ScriptPhase(
      name: 'tank_vulture',
      startLine: 38,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크가 나옵니다, 벌처와 함께 센터로 이동합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250,
          fixedCost: true,
          altText: '{home} 선수 첫 탱크 생산, 벌처와 합류합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산, 벌처 뒤에 탱크를 붙입니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 탱크 합류, 양측 탱크와 벌처가 섞입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야를 확보하고 탱크가 한 발 쏩니다! 상대 벌처가 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 벌처 시야 확보, 탱크 포격으로 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 빼면서 탱크로 맞포격합니다.',
          owner: LogOwner.away,
          homeArmy: -1,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{away} 선수 탱크 맞포격, {home} 벌처에 피해를 줍니다.',
        ),
        ScriptEvent(
          text: '아직 시즈 모드가 없어서 탱크가 직접 이동하며 싸우는 구간입니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '시즈 모드 연구 전, 탱크와 벌처가 섞여서 기동전을 벌입니다.',
        ),
        // 팩토리 추가 (2팩)
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설, 병력이 더 빨리 늘어납니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 팩토리 추가, 생산이 빨라집니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 추가 팩토리 건설, 생산을 맞춥니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 팩토리 추가.',
        ),
      ],
    ),
    // ── Phase 3.5: 탱크 전환 직후 밀어붙이기 체크 ──
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 46,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 대부분: 양측 비등, 시즈 모드 기다림
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크와 벌처가 대치합니다. 시즈 모드 연구를 기다립니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '탱크가 나왔지만 시즈 모드가 없습니다. 기동전이 이어집니다.',
            ),
          ],
        ),
        // 홈 탱크 우세 → 벌처전 이긴 쪽이 탱크와 벌처로 밀어붙이기
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처전 우세로 탱크가 먼저 나왔습니다! 벌처 호위 아래 전진!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -250,
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처로 상대 앞마당을 압박합니다!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -200,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력으로 밀어붙입니다! 상대 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 부족합니다! 벌처만으로는 버틸 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '��처전 열세가 탱크 수 열세로 이어집니다!',
              owner: LogOwner.system,
              altText: '자원 격차가 병력 격차로! 탱크가 모자란 쪽이 무너지고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처 압박! 상대가 버틸 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 화력 차이! 상대 앞마당이 무너집니다!',
            ),
          ],
        ),
        // 어웨이 탱크 우세
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처전 우세로 탱크가 먼저 나옵니다! 벌처 호위 아래 전진!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -250,
              fixedCost: true,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 벌처로 상대 앞마당을 압박합니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력으로 밀어붙입니다! 상대 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 부족합니다! 벌처만으로는 버틸 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '벌처전 열세가 탱크 수 열세로 이어집니다!',
              owner: LogOwner.system,
              altText: '자원 격차가 병력 격차로! 탱크가 모자란 쪽이 무너지고 있습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 벌처 압박! 상대가 버틸 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 탱크 화력 차이! 상대 앞마당이 무너집니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 4: 시즈탱크와 벌처 (거리재기 시작) ──
    ScriptPhase(
      name: 'siege_vulture',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 완료, 탱크를 시즈 모드로 전환합니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 시즈 모드 완료, 탱크가 자리를 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구 완료, 라인이 형성됩니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 시즈 모드, 양측 탱크 라인이 만들어집니다.',
        ),
        ScriptEvent(
          text: '시즈 모드가 완료됐습니다, 마인밭 사이에서 거리재기가 시작됩니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '양측 시즈 탱크 대치, 마인밭을 넘어 사거리 싸움입니다.',
        ),
        // 거리재기
        ScriptEvent(
          text: '{home} 선수 벌처를 앞세워 시야를 밝히고 시즈 포격! 상대 탱크 한 대가 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 벌처 시야 확보 후 시즈 포격! 상대 탱크를 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크를 살짝 전진시켜 사거리를 잡습니다, 시즈 한 방! {home} 탱크가 터집니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{away} 선수 사거리 끝에서 포격! {home} 탱크를 잡습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 측면을 돌아 상대 탱크 뒤쪽으로 내려갑니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{home} 선수 벌처가 상대 병력 뒤쪽으로 침투합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 상대 라인 뒤를 찌릅니다, SCV를 잡습니다.',
          owner: LogOwner.away,
          homeResource: -150,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{away} 선수 벌처 침투, 상대 후방 SCV에 피해를 줍니다.',
        ),
        ScriptEvent(
          text: '시즈 탱크 거리재기가 계속됩니다, 한 대씩 깎이는 신경전입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '사거리 싸움이 치열합니다, 탱크 한 대 차이가 승부를 가릅니다.',
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
          altText: '{home} 선수 지형을 활용한 시즈 배치! 상대가 올라올 수 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다! 지형 싸움!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
          altText: '{away} 선수 고지대 시즈로 응수! 서로 고지를 점령합니다!',
        ),
        // 근거리 맵: 시즈 거리재기 강화
        ScriptEvent(
          text: '{home} 선수 근거리라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
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
        // 원거리 맵: 멀티 확장 여유
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 4.5: 트리플 확장 타이밍 - 분기 ──
    ScriptPhase(
      name: 'triple_expansion',
      startLine: 58,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 분기 A: 양측 비슷한 타이밍에 확장
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 세 번째 커맨드센터를 건설합니다. 자원 라인을 넓힙니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 트리플 커맨드센터, 자원 확보에 나섭니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 세 번째 커맨드센터를 올립니다. 같은 타이밍입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수도 트리플 확장, 양측 자원 싸움입니다.',
            ),
            ScriptEvent(
              text: '양측 트리플 확장, 자원 확보를 위한 투자입니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '같은 타이밍에 트리플, 양쪽 빌드가 맞물려 진행됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 직후 벌처로 상대 SCV를 노립니다!',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{home} 선수 확장 틈을 노린 벌처 견제! SCV를 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처를 보내 상대 확장기지 SCV를 괴롭힙니다!',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{away} 선수 벌처 견제! 확장기지 SCV에 피해를 줍니다!',
            ),
          ],
        ),
        // 분기 B: 홈이 먼저 확장 → 어웨이 압박
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 세 번째 커맨드센터를 건설합니다. 과감한 투자입니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 빠른 트리플 확장, 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 상대가 확장을 올린 것을 확인합니다. 병력이 얇을 때입니다.',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away} 선수 상대 확장 타이밍을 포착합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 대신 탱크를 추가 생산합니다. 병력으로 압박합니다.',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 확장을 미루고 병력에 투자합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 전진! 확장에 자원을 쓴 틈을 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away} 선수 병력 우위로 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크로 버팁니다. 확장 자원이 돌아올 때까지 방어합니다.',
              owner: LogOwner.home,
              favorsStat: 'defense',
              altText: '{home} 선수 라인을 유지하며 시간을 벌어봅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              skipChance: 0.3,
              altText: '{away} 선수도 트리플 커맨드센터를 건설합니다.',
            ),
          ],
        ),
        // 분기 C: 어웨이가 먼저 확장 → 홈 압박
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 세 번째 커맨드센터를 건설합니다. 자원 우위를 노립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 빠른 트리플 확장, 과감한 투자입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 상대의 확장을 확인합니다. 병력이 빠진 시점입니다.',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 상대 확장 타이밍을 포착합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 대신 탱크를 추가로 뽑습니다. 병력 차이를 만듭니다.',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -250,
              fixedCost: true,
              altText: '{home} 선수 확장을 미루고 병력에 집중합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 전진! 확장 자원이 묶인 틈!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home} 선수 병력 우위로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크로 라인을 유지합니다. 확장이 완성될 때까지 버팁니다.',
              owner: LogOwner.away,
              favorsStat: 'defense',
              altText: '{away} 선수 방어에 집중하며 시간을 끕니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              skipChance: 0.3,
              altText: '{home} 선수도 트리플 커맨드센터를 건설합니다.',
            ),
          ],
        ),
        // 분기 D: 홈이 확장 포기, 병력으로 공격
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드센터를 건설합니다. 자원 라인을 넓힙니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 트리플 확장, 자원을 확보합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 대신 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -300,
              fixedCost: true,
              altText: '{home} 선수 확장을 포기하고 생산시설을 늘립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 골리앗을 한꺼번에 밀어붙입니다! 확장에 자원을 쓴 상대를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1,
              favorsStat: 'attack',
              altText: '{home} 선수 전 병력 전진! 상대 병력이 얇습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장에 자원이 묶여서 병력이 부족합니다! 시즈로 버텨야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              favorsStat: 'defense',
              altText: '{away} 선수 탱크 수가 부족합니다! 라인이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격이 집중됩니다! 상대 라인을 뚫어냅니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 병력 차이를 앞세워 라인을 무너뜨립니다!',
            ),
          ],
        ),
        // 분기 E: 어웨이가 확장 포기, 병력으로 공격
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 세 번째 커맨드센터를 건설합니다. 자원 확보를 시도합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 트리플 확장, 자원 라인을 늘립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 대신 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 확장을 포기하고 생산시설을 늘립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 골리앗을 밀어붙입니다! 상대가 확장에 자원을 쓴 틈!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1,
              favorsStat: 'attack',
              altText: '{away} 선수 전 병력 전진! 확장 타이밍을 정확히 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 투자로 병력이 부족합니다! 탱크가 모자랍니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 병력이 얇습니다! 라인이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격이 집중됩니다! 상대 라인이 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 병력 차이를 앞세워 상대를 압도합니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 탱크 라인 압도 → 조기 종료 가능 ──
    ScriptPhase(
      name: 'siege_dominance',
      startLine: 60,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 시즈 거리재기에서 큰 차이 없이 계속 진행
        ScriptBranch(
          id: 'siege_continues',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크 라인이 팽팽합니다, 골리앗 전환으로 넘어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '시즈 대치가 이어집니다, 다음 테크가 관건입니다.',
            ),
          ],
        ),
        // 홈 탱크 라인 압도 → 밀어붙여서 끝냄
        ScriptBranch(
          id: 'home_siege_crush',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 거리재기에서 탱크 수 차이가 벌어졌습니다! 라인을 밀어붙입니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 라인 우위! 상대 탱크를 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 상대 앞마당까지 진입합니다! 시즈 포격!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -300,
              favorsStat: 'attack',
              altText: '{home} 선수 앞마당까지 시즈! 상대가 무너집니다!',
            ),
            ScriptEvent(
              text: '탱크 라인에서 밀리면 회복이 안 됩니다! 탱크 수 차이가 너무 큽니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 상대 진영을 압박합니다! 탱크 수 차이가 큽니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 시즈 화력 우위! 상대가 라인을 유지하기 어렵습니다!',
            ),
          ],
        ),
        // 어웨이 탱크 라인 압도 → 밀어붙여서 끝냄
        ScriptBranch(
          id: 'away_siege_crush',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 거리재기에서 탱크 수가 앞섭니다! 라인을 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 라인 우위! 상대 탱크를 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인이 상대 앞마당까지 진입! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -300,
              favorsStat: 'attack',
              altText: '{away} 선수 앞마당까지 시즈! 상대가 무너집니다!',
            ),
            ScriptEvent(
              text: '탱크 라인에서 밀리면 회복이 안 됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인이 상대 진영을 압박합니다! 탱크 수 차이가 큽니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 시즈 화력 우위! 상대가 라인을 유지하기 어렵습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 6: 시즈탱크와 골리앗 (아머리, 골리앗 전환) ──
    ScriptPhase(
      name: 'siege_goliath',
      startLine: 66,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설, 골리앗 생산을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, homeArmy: 2,
          fixedCost: true,
          altText: '{home} 선수 아머리를 올리고 골리앗으로 전환합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리, 골리앗 체제로 넘어갑니다.',
          owner: LogOwner.away,
          awayResource: -300, awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수도 골리앗 생산, 화력이 두꺼워집니다.',
        ),
        ScriptEvent(
          text: '양측 골리앗이 합류하면서 라인이 두꺼워집니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '시즈 탱크에 골리앗이 합류, 정면 화력이 올라갑니다.',
        ),
        // 거리재기 - 골리앗 합류 후
        ScriptEvent(
          text: '{home} 선수 탱크 한 칸 전진, 시즈 포격! 상대 골리앗이 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 거리재기! 사거리 끝에서 상대 골리앗을 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 재배치 후 포격! {home} 탱크를 잡습니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{away} 선수 맞포격! 탱크 사거리 싸움에서 한 대를 잡습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗을 앞으로 내밀어 상대 탱크 사거리를 확인합니다.',
          owner: LogOwner.home,
          favorsStat: 'strategy',
          skipChance: 0.5,
          altText: '{home} 선수 골리앗으로 상대 탱크 라인 위치를 탐색합니다.',
        ),
        // 팩토리 추가 (3팩)
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설, 병력 보충이 빨라집니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          skipChance: 0.4,
          altText: '{home} 선수 팩토리 추가, 물량이 더 빨리 늘어납니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 추가 팩토리 건설.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          skipChance: 0.4,
          altText: '{away} 선수도 팩토리 추가, 생산을 맞춥니다.',
        ),
      ],
    ),
    // ── Phase 7: 풀 메카닉 (스타포트, 드랍십) ──
    ScriptPhase(
      name: 'full_mech',
      startLine: 80,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설, 드랍십을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -250,
          fixedCost: true,
          altText: '{home} 선수 스타포트를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 올립니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 스타포트 건설, 드랍 준비입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산, 벌처로 시야를 확보하면서 타이밍을 재고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200,
          fixedCost: true,
          altText: '{home} 선수 드랍십 완성, 언제 출격할지 보고 있습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 드랍십 생산, 골리앗을 대공 위치에 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -200,
          fixedCost: true,
          altText: '{away} 선수도 드랍십, 양측 풀 메카닉 체제입니다.',
        ),
        ScriptEvent(
          text: '시즈탱크, 골리앗, 드랍십, 풀 메카닉 체제입니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '양측 풀 메카닉, 이제 드랍이냐 정면이냐가 관건입니다.',
        ),
        // 공중 개방 맵: 드랍 경로 다양
        ScriptEvent(
          text: '공중이 열린 맵입니다, 드랍 경로가 다양해서 골리앗 배치가 어렵습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'airHigh',
        ),
        // 원거리 맵: 드랍 이동 시간이 길어서 탐지 가능
        ScriptEvent(
          text: '원거리 맵이라 드랍십 이동이 오래 걸립니다, 정찰할 시간이 있습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 8: 드랍/정면 - 분기 ──
    ScriptPhase(
      name: 'drop_or_frontal',
      startLine: 92,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 홈 드랍 성공
        ScriptBranch(
          id: 'home_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 출격! 상대 확장기지에 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -300,
              favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 확장기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지 SCV가 큰 피해! 병력을 돌려야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -200,
              altText: '{away} 선수 확장기지에 탱크가 내려왔습니다! SCV 피해!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍 혼란 틈타 정면 탱크도 전진! 시즈 포격!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 정면에서도 시즈 포격! 상대 탱크가 터집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 라인을 전진시킵니다! 멀티포인트 공격!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '드랍과 정면 동시 공격! 수비가 분산됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            // 공중 개방 맵: 추가 드랍 피해
            ScriptEvent(
              text: '공중이 열린 맵이라 드랍십이 다른 경로로 한 번 더 들어갑니다! 추가 피해!',
              owner: LogOwner.home,
              awayResource: -200,
              requiresMapTag: 'airHigh',
              favorsStat: 'harass',
            ),
          ],
        ),
        // 어웨이 드랍 성공
        ScriptBranch(
          id: 'away_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십으로 상대 본진을 기습합니다! 탱크 투하!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'strategy',
              altText: '{away} 선수 본진 드랍! 생산시설이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진이 위협받고 있습니다! 탱크를 돌려야!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -200,
              altText: '{home} 선수 본진에 탱크가 내려왔습니다! 병력을 빼야!',
            ),
            ScriptEvent(
              text: '{away} 선수 {home} 탱크가 빠진 라인에 시즈 포격! 골리앗을 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 라인 빈틈을 노린 포격! {home} 병력이 줄어듭니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대가 흔들리는 사이 정면 탱크 라인도 전진!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 견제와 정면 동시! 상대가 갈립니다!',
            ),
            ScriptEvent(
              text: '본진 견제 성공! 생산력에 타격이 갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            // 공중 개방 맵: 추가 드랍 피해
            ScriptEvent(
              text: '공중이 열린 맵이라 드랍십이 우회해서 한 번 더 진입합니다! 추가 피해!',
              owner: LogOwner.away,
              homeResource: -200,
              requiresMapTag: 'airHigh',
              favorsStat: 'harass',
            ),
          ],
        ),
        // 정면 교전
        ScriptBranch(
          id: 'frontal_clash',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 드랍을 경계하며 골리앗을 대공 위치에 배치합니다, 정면 승부입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍 없이 정면 승부, 탱크 라인 싸움입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 한 칸 전진! 시즈 포격! {away} 탱크가 맞습니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 거리재기! 상대 탱크를 한 대 깎습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 재배치 후 맞포격! {home} 골리앗이 터집니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 맞포격! {home} 병력을 깎습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크, 골리앗 라인을 전진시킵니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{home} 선수 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 화력으로 맞섭니다! 정면 교전!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{away} 선수 정면에서 맞받습니다!',
            ),
            ScriptEvent(
              text: '정면 라인전! 시즈 포격 범위가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 홈 불리 → 본진 한방 뒤집기 드랍
        ScriptBranch(
          id: 'home_desperate_drop',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다! 병력 차이가 벌어지고 있습니다!',
              owner: LogOwner.system,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 가득 싣습니다! 본진을 노립니다!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 대규모 드랍! 상대 본진 뒤를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 본진에 탱크 투하! 시즈 모드 전환! 팩토리가 터집니다!',
              owner: LogOwner.home,
              awayResource: -500, awayArmy: -4,
              favorsStat: 'harass',
              altText: '{home} 선수 본진 드랍 성공! 생산 라인을 타격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 병력을 돌리지만 이미 피해가 큽니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 본진 생산 건물이 파괴됩니다! 생산이 끊깁니다!',
            ),
            ScriptEvent(
              text: '한방 드랍이 전세를 뒤집었습니다! 생산력 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 어웨이 불리 → 본진 한방 뒤집기 드랍
        ScriptBranch(
          id: 'away_desperate_drop',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 밀리고 있습니다! 탱크 수가 부족합니다!',
              owner: LogOwner.system,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로 향합니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 대규모 드랍! 승부수를 던집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 본진에 탱크 투하! 시즈 모드! 생산시설이 터집니다!',
              owner: LogOwner.away,
              homeResource: -500, homeArmy: -4,
              favorsStat: 'harass',
              altText: '{away} 선수 본진 드랍 성공! 상대 팩토리를 부숩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력을 돌리지만 생산시설 피해가 심각합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 본진 생산 건물이 파괴됩니다! 생산이 끊깁니다!',
            ),
            ScriptEvent(
              text: '역전 드랍! 불리했던 쪽이 생산력을 뒤집었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ── Phase 9: 결전 ──
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 106,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        // 결전 직전 거리재기
        ScriptEvent(
          text: '{home} 선수 벌처로 시야를 밝히고 탱크 포격! 상대 골리앗이 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.5,
          altText: '{home} 선수 결전 직전 거리재기! 시즈 포격으로 상대 병력을 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 위치를 조정합니다, 포격! {home} 탱크가 터집니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.5,
          altText: '{away} 선수 맞포격! 사거리 끝에서 {home} 탱크를 잡습니다!',
        ),
        // 결전 전 대규모 교전
        ScriptEvent(
          text: '{home} 선수 탱크 라인을 전진시킵니다! 상대 골리앗과 정면 포격전!',
          owner: LogOwner.home,
          awayArmy: -8, homeArmy: -6,
          favorsStat: 'attack',
          skipChance: 0.3,
          altText: '{home} 선수 라인 전진! 상대 병력과 정면으로 부딪힙니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 포격으로 응사합니다! 양측 병력이 크게 줄어듭니다!',
          owner: LogOwner.away,
          homeArmy: -8, awayArmy: -6,
          favorsStat: 'attack',
          skipChance: 0.3,
          altText: '{away} 선수 맞포격! 양측 탱크가 대거 터집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 전 병력 총동원! 최종 결전!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -400,
          fixedCost: true,
          altText: '{home} 선수 전 병력 결집! 마지막 승부입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 투입! 결전입니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 전 병력 배치! 마지막 한판!',
        ),
        ScriptEvent(
          text: '양측 전 병력 충돌! 여기서 밀리면 끝입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '전 병력이 정면에서 부딪힙니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격 집중! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -20, homeArmy: -10,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 탱크를 집중 타격합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -20, awayArmy: -10,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗으로 끝까지 저항합니다!',
        ),
      ],
    ),
    // ── Phase 10: 결전 판정 ──
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 120,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 밀어붙입니다! 상대 라인이 흔들립니다!',
              altText: '{home} 선수 탱크 수에서 앞서기 시작합니다! 라인을 압박합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 라인을 밀어붙입니다! 상대 라인이 흔들립니다!',
              altText: '{away} 선수 탱크 수에서 앞서기 시작합니다! 라인을 압박합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
