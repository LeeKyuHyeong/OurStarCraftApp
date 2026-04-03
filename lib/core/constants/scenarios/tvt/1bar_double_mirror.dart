part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 14. 배럭더블 미러 (가장 대표적인 TvT)
// ----------------------------------------------------------
const _tvt1barDoubleMirror = ScenarioScript(
  id: 'tvt_1bar_double_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1bar_double'],
  awayBuildIds: ['tvt_1bar_double'],
  description: '배럭더블 미러 정석 대결',
  phases: [
    // ── Phase 0: 오프닝 (배럭, CC, 팩토리) ──
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
          text: '{home} 선수 마린을 뽑으면서 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeResource: -450, // 마린(50) + CC(400)
          homeArmy: 1,
          fixedCost: true,
          altText: '{home} 선수 앞마당 커맨드, 배럭 더블입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터, 배럭 더블 미러입니다.',
          owner: LogOwner.away,
          awayResource: -450,
          awayArmy: 1,
          fixedCost: true,
          altText: '{away} 선수도 앞마당 확장, 같은 빌드입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설, 가스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 가스와 팩토리를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 팩토리, SCV 정찰을 보냅니다.',
        ),
        ScriptEvent(
          text: '양측 배럭 더블 미러, 정석적인 테테전 전개입니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
          altText: '배럭 더블 미러, 이제 벌처 싸움이 관건입니다.',
        ),
      ],
    ),
    // ── Phase 1: 벌처 싸움 ──
    ScriptPhase(
      name: 'vulture_battle',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산, 센터로 내보냅니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75,
          fixedCost: true,
          altText: '{home} 선수 첫 벌처가 나왔습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산, 센터로 향합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75,
          fixedCost: true,
          altText: '{away} 선수도 벌처를 내보냅니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 플로팅으로 상대 진영을 정찰합니다.',
          owner: LogOwner.home,
          favorsStat: 'scout',
          skipChance: 0.3,
          altText: '{home} 선수 배럭을 띄워서 상대 빌드를 확인합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 속업 연구를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -200,
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{away} 선수 속업 연구, 벌처 기동력을 높입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수도 벌처 속업, 타이밍 경쟁입니다.',
          owner: LogOwner.home,
          homeResource: -200,
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수도 속업 연구, 누가 먼저 완료하느냐.',
        ),
        ScriptEvent(
          text: '양측 벌처가 센터에서 조우합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '센터에서 벌처가 마주칩니다, 벌처전이 시작됩니다.',
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
        // 홈 벌처 우세
        ScriptBranch(
          id: 'home_vulture_win',
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
              text: '벌처전에서 밀리면 맵 컨트롤을 잃게 됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 어웨이 벌처 우세
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 빠른 속업으로 상대 벌처를 따라잡습니다! 벌처 격파!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 속업 타이밍! 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마인 매설로 맵 컨트롤을 확보합니다.',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 마인을 깔아 상대 벌처 이동을 제한합니다.',
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
          ],
        ),
        // 교착
        ScriptBranch(
          id: 'vulture_stalemate',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 벌처가 비등합니다, 서로 마인만 깔고 물러납니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처전 교착, 양측 마인을 깔며 견제합니다.',
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
    // ── Phase 3: 탱크+벌처 (시즈 모드 연구 전) ──
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
          altText: '{away} 선수도 탱크 합류, 양측 탱크+벌처 조합입니다.',
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
      ],
    ),
    // ── Phase 4: 시즈탱크+벌처 (시즈 모드 완료, 거리재기 시작) ──
    ScriptPhase(
      name: 'siege_vulture',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 완료, 탱크를 시즈 모드로 전환합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 시즈모드 연구
          fixedCost: true,
          altText: '{home} 선수 시즈 모드 완료, 탱크가 자리를 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구 완료, 라인이 형성됩니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          altText: '{away} 선수도 시즈 모드, 양측 시즈 라인이 만들어집니다.',
        ),
        ScriptEvent(
          text: '시즈 모드가 완료됐습니다, 이제부터 거리재기가 시작됩니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '양측 시즈 탱크 대치, 사거리 싸움이 시작됩니다.',
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
          text: '{home} 선수 벌처로 측면을 돌아 상대 탱크 뒤를 찌릅니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{home} 선수 벌처 우회 견제! 상대 탱크 후방을 노립니다!',
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
      ],
    ),
    // ── Phase 5: 시즈탱크+골리앗 (아머리 건설, 골리앗 전환) ──
    ScriptPhase(
      name: 'siege_goliath',
      startLine: 66,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설, 골리앗 생산을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 아머리(150) + 골리앗(150)
          homeArmy: 2,
          fixedCost: true,
          altText: '{home} 선수 아머리를 올리고 골리앗으로 전환합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리, 골리앗 체제로 넘어갑니다.',
          owner: LogOwner.away,
          awayResource: -300,
          awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수도 골리앗 생산, 화력이 두꺼워집니다.',
        ),
        ScriptEvent(
          text: '양측 골리앗이 합류하면서 라인이 두꺼워집니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '시즈탱크+골리앗 조합, 정면 화력이 올라갑니다.',
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
          altText: '{home} 선수 골리앗으로 상대 시즈 라인 위치를 탐색합니다.',
        ),
      ],
    ),
    // ── Phase 6: 시즈탱크+골리앗+드랍십 - 분기 ──
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
      ],
    ),
    // ── Phase 7: 드랍/정면 - 분기 ──
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
              altText: '드랍 없이 정면 승부, 시즈 라인 싸움입니다.',
            ),
            // 거리재기
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
              text: '{home} 선수 탱크+골리앗 라인을 전진시킵니다!',
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
      ],
    ),
    // ── Phase 8: 결전 ──
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
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 탱크를 집중 타격합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗으로 끝까지 저항합니다!',
        ),
      ],
    ),
    // ── Phase 9: 결전 판정 ──
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
              text: '{home} 선수 벌처 컨트롤 차이! 상대 SCV를 솎아냅니다!',
              altText: '{home} 선수 드랍 견제 성공! 상대 생산시설을 타격합니다!',
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
              text: '{away} 선수 벌처 컨트롤 승리! 맵 장악으로 밀어냅니다!',
              altText: '{away} 선수 드랍십 기습! 상대 후방을 초토화합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
