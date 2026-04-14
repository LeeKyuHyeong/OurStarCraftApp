part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 노배럭더블 미러
// 양측 모두 배럭 없이 앞마당 → 벌처 싸움 → 탱크 라인전 → 장기전
// 가장 수비적인 TvT, 초반 교전 거의 없이 자원 경쟁
// ----------------------------------------------------------
const _tvtNobarDoubleMirror = ScenarioScript(
  id: 'tvt_nobar_double_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_nobar_double'],
  awayBuildIds: ['tvt_nobar_double'],
  description: '노배럭더블 자원 싸움 장기전',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-12) ── recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '양 선수 모두 배럭 없이 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.system,
          altText: '배럭 없이 커맨드센터부터 짓기 시작합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
          homeExpansion: true,
          altText: '{home} 선수 배럭 없이 커맨드센터를 먼저 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          awayExpansion: true,
          altText: '{away} 선수도 배럭 없이 커맨드센터를 먼저 올립니다.',
        ),
        ScriptEvent(
          text: '대규모 물량전이 펼쳐지겠는데요! 하지만 상대방 빌드를 아직까지는 모릅니다.',
          owner: LogOwner.system,
          altText: '양쪽 모두 앞마당을 올렸습니다, 서로 어떤 운영을 할지 아직 모르는 상황이죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭 건설.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -100,
          fixedCost: true,
          altText: '{home} 선수 리파이너리 건설, 가스 채취 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 리파이너리, 가스 채취 시작.',
        ),
        ScriptEvent(
          text: '초반 교전 없이 자원 싸움이 될 전망입니다. 운영 싸움이 중요하겠습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '가장 수비적인 테테전입니다. 작은 실수도 크게 벌어질 수 있는게 같은 빌드 싸움이죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 팩토리를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 팩토리 건설.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵을 건설합니다.',
          owner: LogOwner.home,
          homeResource: -100,
          fixedCost: true,
          altText: '{home} 선수 머신샵을 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵을 건설합니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 머신샵을 올립니다.',
        ),
        ScriptEvent(
          text: '배럭도 없이 시작한 게임, 이제 팩토리까지 올라왔습니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
          altText: '양측 자원은 풍부한데 병력이 없습니다. 이제부터가 시작이죠.',
        ),
      ],
    ),
    // ── Phase 1: 벌처 싸움 (lines 14-25) ── recovery 150/줄
    ScriptPhase(
      name: 'vulture_battle',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산, 센터로 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75,
          fixedCost: true,
          altText: '{home} 선수 첫 벌처가 나왔습니다, 정찰 나갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산, 센터로 정찰을 보냅니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75,
          fixedCost: true,
          altText: '{away} 선수도 벌처를 내보냅니다, 상대를 확인합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마인 연구를 시작합니다.',
          owner: LogOwner.home,
          favorsStat: 'strategy',
          altText: '{home} 선수 머신샵에서 마인 연구부터.',
        ),
        ScriptEvent(
          text: '{away} 선수도 마인 연구를 돌립니다.',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          altText: '{away} 선수도 마인 연구, 같은 선택입니다.',
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
          text: '양측 벌처가 센터에서 조우합니다. 마인을 경계하며 움직입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '배럭 없이 확장을 했기 때문에 벌처가 늦게 나왔습니다. 조심스러운 초반입니다.',
        ),
      ],
    ),
    // ── Phase 2: 벌처 교전 결과 - 분기 (crush 포함) ──
    ScriptPhase(
      name: 'vulture_result',
      startLine: 26,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 홈 벌처 우세
        ScriptBranch(
          id: 'home_vulture_win',
          description: '홈 벌처 컨트롤 우세, SCV 견제 성공',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 컨트롤이 좋습니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 벌처를 격파!',
            ),
            ScriptEvent(
              text: '{home} 선수 마인 매설로 맵 컨트롤을 잡습니다.',
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
              text: '배럭 없이 확장한 만큼 앞마당 방어가 특히 취약합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처전에서 밀리면 앞마당 SCV가 위험합니다.',
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
          description: '어웨이 벌처 컨트롤 우세, SCV 견제 성공',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 컨트롤이 앞섭니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 컨트롤 차이! 상대 벌처를 격파합니다!',
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
              text: '배럭 없이 확장해서 벌처 견제에 특히 약합니다.',
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
          description: '홈 벌처 압도, SCV 대량 피해 decisive',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처가 상대 벌처를 전멸시킵니다!',
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
              text: '마린 수비가 전혀 없습니다! 벌처에 속수무책!',
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
          description: '어웨이 벌처 압도, SCV 대량 피해 decisive',
          baseProbability: 0.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 상대 벌처를 전멸시킵니다!',
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
              text: '마린 수비가 없는 약점! 벌처에 속수무책!',
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
        // 교착
        ScriptBranch(
          id: 'vulture_stalemate',
          description: '벌처 교착, 서로 마인만 깔고 물러남',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 벌처가 비등합니다, 서로 마인만 깔고 물러납니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처전 교착, 양측 마인을 깔며 영역을 확보합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 앞마당을 찔러봅니다.',
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
    // ── Phase 3: 탱크 전환 (lines 38-46) ── recovery 150/줄
    ScriptPhase(
      name: 'tank_transition',
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
          text: '{home} 선수 시즈모드 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          altText: '{home} 선수 시즈모드 연구, 탱크가 자리 잡을 준비를 합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈모드 연구를 돌립니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 시즈모드 연구, 비슷한 타이밍입니다.',
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
    // ── Phase 4: 탱크 푸시 체크 (lines 46-52) ── recovery 200/줄
    // 노배럭더블은 가장 수비적 → tank_even이 높음 (2.0), 푸시는 드묾 (0.5)
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 46,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'tank_even',
          description: '탱크 비등, 시즈모드 대기',
          baseProbability: 2.0,
          events: [
            ScriptEvent(
              text: '양측 탱크와 벌처가 대치합니다. 시즈 모드 연구를 기다립니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '자원이 비슷해서 탱크 수도 비등합니다. 운영 싸움이 중요하겠습니다.',
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_tank_push',
          description: '홈 탱크+벌처 전진 decisive',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처전 우세로 탱크가 먼저 모였습니다! 벌처 호위 아래 전진!',
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
              text: '벌처전 열세가 탱크 수 열세로 이어집니다!',
              owner: LogOwner.system,
              altText: '자원은 비슷한데 벌처전에서 밀려서 탱크 수가 모자랍니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처 압박! 상대가 버틸 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 화력 차이! 상대 앞마당이 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_tank_push',
          description: '어웨이 탱크+벌처 전진 decisive',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처전 우세로 탱크가 먼저 모였습니다! 벌처 호위 아래 전진!',
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
              altText: '자원은 비슷한데 벌처전에서 밀려서 탱크 수가 모자랍니다.',
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
    // ── Phase 5: 시즈 모드 + 거리재기 (lines 52-60) ── recovery 200/줄
    ScriptPhase(
      name: 'siege_mode',
      startLine: 52,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 완료, 탱크를 시즈 모드로 전환합니다.',
          owner: LogOwner.home,
          altText: '{home} 선수 시즈 모드 완료, 탱크가 자리를 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구 완료, 라인이 형성됩니다.',
          owner: LogOwner.away,
          altText: '{away} 선수도 시즈 모드, 양측 탱크 라인이 만들어집니다.',
        ),
        ScriptEvent(
          text: '시즈 모드가 완료됐습니다, 이제부터 거리재기가 시작됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '테테전의 꽃, 시즈 탱크 라인 긋기 싸움입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처를 앞세워 시야를 밝히고 시즈 포격! 상대 탱크 한 대가 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 벌처 시야 확보 후 시즈 포격! 상대 탱크를 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크를 살짝 전진시켜 사거리를 잡습니다. 시즈 한 방! {home} 탱크가 터집니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{away} 선수 사거리 끝에서 포격! {home} 탱크를 잡습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 측면을 돌아 상대 탱크 뒤를 찌릅니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{home} 선수 벌처가 상대 병력 뒤쪽으로 내려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 상대 라인 뒤를 찌릅니다. SCV를 잡습니다.',
          owner: LogOwner.away,
          homeResource: -150,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{away} 선수 벌처 침투, 상대 후방 SCV에 피해를 줍니다.',
        ),
        ScriptEvent(
          text: '사거리 싸움이 치열합니다, 탱크 한 대 차이가 승부를 가릅니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '먼저 자리 잡는 쪽이 센터의 주인입니다.',
        ),
        // 맵 특성 이벤트
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
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 6: 트리플 확장 타이밍 분기 (lines 58-68) ── recovery 200/줄
    ScriptPhase(
      name: 'triple_expansion',
      startLine: 58,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 양측 동시 확장 (가장 일반적)
        ScriptBranch(
          id: 'both_expand',
          description: '양측 트리플 확장',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 세 번째 커맨드센터를 올립니다. 자원 라인을 늘립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 트리플 커맨드센터, 자원을 확보합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 세 번째 확장을 올립니다. 비슷한 타이밍입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 트리플 커맨드센터, 양측 자원 확보에 나섭니다.',
            ),
            ScriptEvent(
              text: '양측 트리플 확장, 자원 싸움이 치열합니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '서로 비슷한 타이밍에 세 번째 확장을 가져갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 트리플 SCV를 찌릅니다.',
              owner: LogOwner.home,
              awayResource: -100,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{home} 선수 벌처 견제, 새 확장기지 SCV를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처를 보내 상대 트리플을 견제합니다.',
              owner: LogOwner.away,
              homeResource: -100,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{away} 선수도 벌처로 상대 확장기지 SCV를 잡습니다.',
            ),
          ],
        ),
        // 홈 선확장
        ScriptBranch(
          id: 'home_fast_expand',
          description: '홈 선 트리플, 어웨이 병력 압박',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 세 번째 커맨드센터를 올립니다. 과감한 확장입니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 트리플 커맨드센터를 선행합니다. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 확장 타이밍을 포착합니다! 병력이 얇은 틈을 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'sense',
              altText: '{away} 선수 확장 직후를 노린 포격! 탱크가 전진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 비용 때문에 병력이 잠깐 부족합니다. 시즈로 버팁니다.',
              owner: LogOwner.home,
              favorsStat: 'defense',
              altText: '{home} 선수 탱크 라인으로 수비합니다. 확장 비용이 부담입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 SCV를 잡으며 상대 확장을 방해합니다!',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{away} 선수 벌처 견제! 새 확장기지 SCV에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뒤늦게 트리플 확장을 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 세 번째 확장, 자원 격차를 줄입니다.',
            ),
          ],
        ),
        // 어웨이 선확장
        ScriptBranch(
          id: 'away_fast_expand',
          description: '어웨이 선 트리플, 홈 병력 압박',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 세 번째 커맨드센터를 올립니다. 과감한 확장입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 트리플 커맨드센터를 선행합니다. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 확장 타이밍을 포착합니다! 병력이 얇은 틈을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'sense',
              altText: '{home} 선수 확장 직후를 노린 포격! 탱크가 전진합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 비용 때문에 병력이 잠깐 부족합니다. 시즈로 버팁니다.',
              owner: LogOwner.away,
              favorsStat: 'defense',
              altText: '{away} 선수 탱크 라인으로 수비합니다. 확장 비용이 부담입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 SCV를 잡으며 상대 확장을 방해합니다!',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 견제! 새 확장기지 SCV에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 뒤늦게 트리플 확장을 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수도 세 번째 확장, 자원 격차를 줄입니다.',
            ),
          ],
        ),
        // 홈 확장 포기 + 공격 (decisive)
        ScriptBranch(
          id: 'home_skip_expand_attack',
          description: '홈 확장 포기 올인 decisive',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 트리플을 포기하고 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.home,
              homeResource: -300, homeArmy: 3,
              fixedCost: true,
              altText: '{home} 선수 확장 대신 팩토리 추가, 공격 준비입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드센터를 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 트리플 커맨드센터를 올립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 상대가 확장하는 틈을 노립니다! 탱크와 벌처가 전진합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1,
              favorsStat: 'attack',
              altText: '{home} 선수 확장 타이밍에 전면 공격! 탱크가 밀고 들어갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 비용 때문에 병력이 부족합니다! 탱크 라인이 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              favorsStat: 'defense',
              altText: '{away} 선수 병력이 모자랍니다! 확장 투자가 독이 됩니다!',
            ),
            ScriptEvent(
              text: '확장을 포기하고 병력에 집중한 {home} 선수! 탱크 수 차이가 결정적입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격이 상대 진영을 초토화합니다! 병력 차이가 너무 큽니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 라인이 상대를 짓누릅니다! 자원이 있어도 병력이 없습니다!',
            ),
          ],
        ),
        // 어웨이 확장 포기 + 공격 (decisive)
        ScriptBranch(
          id: 'away_skip_expand_attack',
          description: '어웨이 확장 포기 올인 decisive',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 트리플을 포기하고 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.away,
              awayResource: -300, awayArmy: 3,
              fixedCost: true,
              altText: '{away} 선수 확장 대신 팩토리 추가, 공격 준비입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 세 번째 커맨드센터를 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 트리플 커맨드센터를 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 상대가 확장하는 틈을 노립니다! 탱크와 벌처가 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1,
              favorsStat: 'attack',
              altText: '{away} 선수 확장 타이밍에 전면 공격! 탱크가 밀고 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 비용 때문에 병력이 부족합니다! 탱크 라인이 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{home} 선수 병력이 모자랍니다! 확장 투자가 독이 됩니다!',
            ),
            ScriptEvent(
              text: '확장을 포기하고 병력에 집중한 {away} 선수! 탱크 수 차이가 결정적입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격이 상대 진영을 초토화합니다! 병력 차이가 너무 큽니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 탱크 라인이 상대를 짓누릅니다! 자원이 있어도 병력이 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 7: 시즈 라인 압도 분기 (lines 66-76) ── recovery 200/줄
    ScriptPhase(
      name: 'siege_dominance',
      startLine: 66,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 시즈 거리재기에서 큰 차이 없이 계속 진행
        ScriptBranch(
          id: 'siege_continues',
          description: '시즈 교착 지속, 골리앗 전환',
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
        // 홈 시즈 압도 → decisive
        ScriptBranch(
          id: 'home_siege_crush',
          description: '홈 탱크 라인 압도 decisive',
          baseProbability: 0.6,
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
              altText: '조이기 라인이 풀리지 않습니다. 서서히 밀리고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인이 상대 진영을 압박합니다! 병력 차이가 큽니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 시즈 화력 우위! 상대가 라인을 유지하기 어렵습니다!',
            ),
          ],
        ),
        // 어웨이 시즈 압도 → decisive
        ScriptBranch(
          id: 'away_siege_crush',
          description: '어웨이 탱크 라인 압도 decisive',
          baseProbability: 0.6,
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
              altText: '압도적인 화력! 이건 컨트롤로 극복이 안 됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인이 상대 진영을 압박합니다! 병력 차이가 큽니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 시즈 화력 우위! 상대가 라인을 유지하기 어렵습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 8: 골리앗 + 풀 메카닉 전환 (lines 76-90) ── recovery 200/줄
    ScriptPhase(
      name: 'goliath_full_mech',
      startLine: 76,
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
          text: '시즈 탱크에 골리앗이 합류하면서 정면 화력이 올라갑니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '인구수가 올라갑니다, 이제 곧 한 방이 터질 수 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 한 칸 전진, 시즈 포격! 상대 골리앗이 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 거리재기! 사거리 끝에서 상대 골리앗을 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 재배치 후 포격! {home} 탱크가 터집니다!',
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
        // 공중 개방 맵
        ScriptEvent(
          text: '공중이 열린 맵입니다, 드랍 경로가 다양해서 골리앗 배치가 어렵습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'airHigh',
        ),
        // 원거리 맵
        ScriptEvent(
          text: '원거리 맵이라 드랍십 이동이 오래 걸립니다, 정찰할 시간이 있습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 8.5: 배틀크루저 전환 (lines 89-92) ── 희박한 장기전 분기
    ScriptPhase(
      name: 'battlecruiser_war',
      startLine: 89,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        // 홈 먼저 배틀크루저 완성 → 야마토로 탱크 점진 제거
        ScriptBranch(
          id: 'home_bc_first',
          description: '홈 배틀크루저 먼저 완성, 야마토로 탱크 라인 붕괴 decisive',
          baseProbability: 0.08,
          conditionStat: 'macro',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 사이언스 퍼실리티를 건설합니다. 피직스 랩까지 달아놓습니다.',
              owner: LogOwner.home,
              homeResource: -300,
              fixedCost: true,
              altText: '{home} 선수 사이언스 퍼실리티 건설, 장기전 준비 완료입니다.',
            ),
            ScriptEvent(
              text: '이 장기전, 끝이 보이질 않습니다!',
              owner: LogOwner.system,
              altText: '노배럭더블의 극한 장기전! 아직도 더 남았습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 배틀크루저 완성! {away} 선수보다 한발 앞섰습니다!',
              owner: LogOwner.home,
              homeArmy: 6,
              altText: '{home} 선수 배틀크루저가 나왔습니다! 먼저 뽑았습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 야마토 충전, 상대 탱크를 조준합니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '야마토 발사! 상대 시즈탱크 한 대가 터집니다!',
              owner: LogOwner.system,
              awayArmy: -3,
              altText: '야마토 명중! 상대 탱크가 한 방에 폭발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 계속 야마토! 탱크가 하나씩 사라집니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home} 선수 야마토를 연속으로 사용합니다! 탱크 라인이 줄어들고 있습니다!',
            ),
            ScriptEvent(
              text: '탱크 수가 줄어들면서 {away} 선수 라인이 흔들리기 시작합니다.',
              owner: LogOwner.system,
              altText: '{away} 선수 탱크가 계속 터집니다! 라인 유지가 점점 어렵습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상 병력도 전진! 배틀크루저와 함께 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 배틀크루저와 지상 병력이 동시에 쏟아집니다!',
            ),
          ],
        ),
        // 어웨이 먼저 배틀크루저 완성 → 야마토로 탱크 점진 제거
        ScriptBranch(
          id: 'away_bc_first',
          description: '어웨이 배틀크루저 먼저 완성, 야마토로 탱크 라인 붕괴 decisive',
          baseProbability: 0.08,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 사이언스 퍼실리티를 건설합니다. 피직스 랩까지 달아놓습니다.',
              owner: LogOwner.away,
              awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 사이언스 퍼실리티 건설, 장기전 준비 완료입니다.',
            ),
            ScriptEvent(
              text: '이 장기전, 끝이 보이질 않습니다!',
              owner: LogOwner.system,
              altText: '노배럭더블의 극한 장기전! 아직도 더 남았습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 배틀크루저 완성! {home} 선수보다 한발 앞섰습니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              altText: '{away} 선수 배틀크루저가 나왔습니다! 먼저 뽑았습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 야마토 충전, 상대 탱크를 조준합니다!',
              owner: LogOwner.away,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '야마토 발사! 상대 시즈탱크 한 대가 터집니다!',
              owner: LogOwner.system,
              homeArmy: -3,
              altText: '야마토 명중! 상대 탱크가 한 방에 폭발합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 계속 야마토! 탱크가 하나씩 사라집니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'control',
              altText: '{away} 선수 야마토를 연속으로 사용합니다! 탱크 라인이 줄어들고 있습니다!',
            ),
            ScriptEvent(
              text: '탱크 수가 줄어들면서 {home} 선수 라인이 흔들리기 시작합니다.',
              owner: LogOwner.system,
              altText: '{home} 선수 탱크가 계속 터집니다! 라인 유지가 점점 어렵습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 지상 병력도 전진! 배틀크루저와 함께 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 배틀크루저와 지상 병력이 동시에 쏟아집니다!',
            ),
          ],
        ),
        // 양측 배틀크루저 동시 등장 → 야마토 교환 → 홈 승리
        ScriptBranch(
          id: 'bc_home_wins',
          description: '양측 배틀크루저 등장, 야마토 교환 후 홈 승리 decisive',
          baseProbability: 0.06,
          conditionStat: 'control',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 사이언스 퍼실리티를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -250,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수도 사이언스 퍼실리티! 눈치를 챘습니다!',
              owner: LogOwner.away,
              awayResource: -250,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '양측 배틀크루저를 준비하고 있습니다! 이 경기, 끝까지 갑니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 배틀크루저 완성!',
              owner: LogOwner.home,
              homeArmy: 6,
            ),
            ScriptEvent(
              text: '{away} 선수도 배틀크루저 완성! 거의 동시입니다!',
              owner: LogOwner.away,
              awayArmy: 6,
            ),
            ScriptEvent(
              text: '배틀크루저 vs 배틀크루저! 공중전이 시작됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 야마토 발사! 상대 배틀크루저에 명중!',
              owner: LogOwner.home,
              awayArmy: -6,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수도 야마토! {home} 배틀크루저에 직격!',
              owner: LogOwner.away,
              homeArmy: -6,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '야마토 교환! 양측 배틀크루저가 크게 흔들립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 배틀크루저 수에서 앞서기 시작합니다! 추가 야마토!',
              owner: LogOwner.home,
              awayArmy: -4,
              decisive: true,
              altText: '{home} 선수 배틀크루저가 남습니다! 야마토 한 방 더!',
            ),
          ],
        ),
        // 양측 배틀크루저 동시 등장 → 야마토 교환 → 어웨이 승리
        ScriptBranch(
          id: 'bc_away_wins',
          description: '양측 배틀크루저 등장, 야마토 교환 후 어웨이 승리 decisive',
          baseProbability: 0.06,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 사이언스 퍼실리티를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -250,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수도 사이언스 퍼실리티! 눈치를 챘습니다!',
              owner: LogOwner.away,
              awayResource: -250,
              fixedCost: true,
            ),
            ScriptEvent(
              text: '양측 배틀크루저를 준비하고 있습니다! 이 경기, 끝까지 갑니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 배틀크루저 완성!',
              owner: LogOwner.home,
              homeArmy: 6,
            ),
            ScriptEvent(
              text: '{away} 선수도 배틀크루저 완성! 거의 동시입니다!',
              owner: LogOwner.away,
              awayArmy: 6,
            ),
            ScriptEvent(
              text: '배틀크루저 vs 배틀크루저! 공중전이 시작됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 야마토 발사! 상대 배틀크루저에 명중!',
              owner: LogOwner.home,
              awayArmy: -6,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수도 야마토! {home} 배틀크루저에 직격!',
              owner: LogOwner.away,
              homeArmy: -6,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '야마토 교환! 양측 배틀크루저가 크게 흔들립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 배틀크루저 수에서 앞서기 시작합니다! 추가 야마토!',
              owner: LogOwner.away,
              homeArmy: -4,
              decisive: true,
              altText: '{away} 선수 배틀크루저가 남습니다! 야마토 한 방 더!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 9: 드랍 운영 분기 (lines 92-110) ── recovery 200/줄
    ScriptPhase(
      name: 'drop_warfare',
      startLine: 92,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 (확장 견제 후 회수)
        ScriptBranch(
          id: 'home_guerrilla_drop',
          description: '홈 게릴라 드랍, 확장기지 SCV 피해',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크 한 대를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 소규모 드랍! 상대 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내려 SCV를 잡습니다! 바로 회수!',
              owner: LogOwner.home,
              awayResource: -250,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 성공! SCV를 잡고 재빨리 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 도착했지만 이미 빠져나갔습니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 병력을 돌렸지만 드랍십은 이미 회수됐습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍으로 시선을 끈 사이 정면에서 한 칸 전진합니다.',
              owner: LogOwner.home,
              awayArmy: -1,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 견제와 정면 거리재기를 동시에 합니다.',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 자잘한 피해가 쌓이면 후반에 차이가 납니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍십 한 대의 견제가 자원 흐름을 흔들고 있습니다.',
            ),
          ],
        ),
        // 어웨이 게릴라 드랍
        ScriptBranch(
          id: 'away_guerrilla_drop',
          description: '어웨이 게릴라 드랍, 확장기지 SCV 피해',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크 한 대를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 소규모 드랍! 상대 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지에 탱크를 내려 SCV를 잡습니다! 바로 회수!',
              owner: LogOwner.away,
              homeResource: -250,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍 성공! SCV를 잡고 재빨리 빠집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 도착했지만 이미 빠져나갔습니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 병력을 돌렸지만 드랍십은 이미 회수됐습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍으로 시선을 끈 사이 정면에서 한 칸 전진합니다.',
              owner: LogOwner.away,
              homeArmy: -1,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 견제와 정면 거리재기를 동시에 합니다.',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 자잘한 피해가 쌓이고 있습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍십 한 대의 견제가 자원 흐름을 흔들고 있습니다.',
            ),
          ],
        ),
        // 마무리 드랍 (유리한 쪽이 드랍과 정면으로 끝냄) → decisive
        ScriptBranch(
          id: 'home_finishing_drop',
          description: '홈 마무리 드랍, 정면 동시 압박 decisive',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 앞서고 있습니다. 드랍으로 확실하게 끝내려 합니다.',
              owner: LogOwner.system,
              altText: '{home} 선수 물량 우위를 확인하고 마무리 드랍을 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 본진과 확장 동시 투하!',
              owner: LogOwner.home,
              awayResource: -400, awayArmy: -4,
              favorsStat: 'harass',
              altText: '{home} 선수 대규모 드랍! 두 곳을 동시에 타격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진합니다! 세 방향 공격!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면을 동시에! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 어디부터 막아야 할지 모릅니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 멀티포인트 공격! 상대 수비가 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 드랍과 정면 동시! 상대가 수비할 수 없습니다!',
            ),
          ],
        ),
        // 어웨이 마무리 드랍 → decisive
        ScriptBranch(
          id: 'away_finishing_drop',
          description: '어웨이 마무리 드랍, 정면 동시 압박 decisive',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 앞서고 있습니다. 드랍으로 확실하게 끝내려 합니다.',
              owner: LogOwner.system,
              altText: '{away} 선수 물량 우위를 확인하고 마무리 드랍을 준비합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대 출격! 본진과 확장 동시 투하!',
              owner: LogOwner.away,
              homeResource: -400, homeArmy: -4,
              favorsStat: 'harass',
              altText: '{away} 선수 대규모 드랍! 두 곳을 동시에 타격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 정면 탱크 라인도 전진합니다! 세 방향 공격!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 드랍과 정면을 동시에! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비가 갈립니다! 어디부터 막아야 할지 모릅니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 멀티포인트 공격! 상대 수비가 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 드랍과 정면 동시! 상대가 수비할 수 없습니다!',
            ),
          ],
        ),
        // 정면 교전
        ScriptBranch(
          id: 'frontal_clash',
          description: '드랍 없이 정면 라인전',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 드랍을 경계하며 골리앗을 대공 위치에 배치합니다. 정면 승부입니다.',
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
              altText: '탱크 일점사! 상대 탱크 숫자 줄이는 데 집중합니다!',
            ),
          ],
        ),
        // 홈 역전 드랍 (불리한 쪽이 올인 본진 드랍)
        ScriptBranch(
          id: 'home_desperate_drop',
          description: '홈 불리, 역전 본진 드랍 승부수',
          baseProbability: 0.6,
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
              text: '역전 드랍! 불리하던 경기를 드랍 한 방으로 뒤집습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
        // 어웨이 역전 드랍
        ScriptBranch(
          id: 'away_desperate_drop',
          description: '어웨이 불리, 역전 본진 드랍 승부수',
          baseProbability: 0.6,
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
              altText: '드랍 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 10: 결전 (lines 110-125) ── recovery 300/줄 (late)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 110,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
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
          text: '{away} 선수도 탱크 위치를 조정합니다. 포격! {home} 탱크가 터집니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.5,
          altText: '{away} 선수 맞포격! 사거리 끝에서 {home} 탱크를 잡습니다!',
        ),
        // 대규모 교전
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
          altText: '모든 병력 쏟아붓습니다! 마지막 결전이에요!',
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
    // ── Phase 11: 결전 판정 (lines 125+) ── recovery 300/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 125,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          description: '홈 최종 결전 승리',
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
          description: '어웨이 최종 결전 승리',
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
