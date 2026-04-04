part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 11. 원팩원스타 미러 (공격적 미러)
// ----------------------------------------------------------
const _tvt1fac1starMirror = ScenarioScript(
  id: 'tvt_1fac_1star_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_1fac_1star'],
  description: '원팩원스타 미러 벌처 탱크 드랍 대결',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-11) ── recovery 100/줄
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
          awayResource: -150,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올리고 팩토리를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 올리고 팩토리를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수 팩토리 건설. 원팩원스타 미러가 예상됩니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다. 원팩원스타 운영입니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 올립니다. 원팩원스타 미러 확정입니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수 스타포트 건설. 양쪽 원팩원스타 미러입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산을 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -75, // 벌처 75/2sup
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처를 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -75,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '원팩원스타 미러! 벌처 교전부터 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // ── Phase 1: 벌처 교전 (lines 12-21) ── recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'vulture_skirmish',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처로 센터를 장악합니다. 마인 매설.',
          owner: LogOwner.home,
          favorsStat: 'control',
          altText: '{home} 선수 벌처 기동. 마인을 깔아둡니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 맞대응. 마인 매설 경쟁입니다.',
          owner: LogOwner.away,
          favorsStat: 'control',
          altText: '{away} 선수 마인 매설. 양쪽 마인밭입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 교전! 컨트롤 대결!',
          owner: LogOwner.home,
          awayArmy: -2, // 벌처 1기 격파 (2sup)
          favorsStat: 'control',
          altText: '{home} 선수 벌처 컨트롤! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 반격! 상대 벌처를 잡아냅니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'control',
          altText: '{away} 선수 벌처 맞교환! 컨트롤 싸움입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크를 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -250, // 시즈탱크 250/2sup
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크를 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 시즈모드 연구 300
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 연구를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '벌처전이 끝나고 탱크 대치로 전환됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '양측 탱크 체제 진입, 시즈 모드 연구를 기다립니다.',
        ),
      ],
    ),
    // ── Phase 2: 탱크 대치 - 분기 (lines 22-37) ── recovery 150/줄
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 22,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 탱크 우위
        ScriptBranch(
          id: 'home_tank_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 시야로 상대 탱크 위치를 포착! 선제 포격!',
              owner: LogOwner.home,
              awayArmy: -4, // 탱크와 벌처 피해 (4sup)
              favorsStat: 'scout+attack',
              altText: '{home} 선수 시야 싸움에서 앞섭니다! 탱크 직격!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 시야가 안 잡힌 사이 맞았습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 차이를 살려 라인을 밀어갑니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 추가 (250/2sup)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 라인 전진. 상대를 밀어붙입니다.',
            ),
            ScriptEvent(
              text: '탱크 수 차이! 시즈 화력에서 밀리면 뒤집기 어렵습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 탱크 우위
        ScriptBranch(
          id: 'away_tank_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 시야 확보! 상대 탱크를 먼저 포착합니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'scout+attack',
              altText: '{away} 선수 시야 싸움 승리! 상대 탱크를 직격!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 잃습니다! 화력 열세!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 차이로 라인을 밀어갑니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 라인 전진. 밀어붙입니다.',
            ),
            ScriptEvent(
              text: '탱크 수 차이가 결정적입니다. 라인이 밀립니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ── Phase 2.5: 탱크 전환 직후 밀어붙이기 체크 ──
    // 원팩원스타는 공격적 빌드 → 탱크 푸시 빈도 중간
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 34,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크와 벌처가 대치합니다. 시즈 모드를 기다리며 거리재기입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '탱크가 나왔지만 시즈 모드가 아직입니다. 기동전이 계속됩니다.',
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
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
              altText: '{home} 선수 탱크 화력으로 밀어붙입니다! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 부족합니다! 벌처만으로는 버틸 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '벌처전 열세가 탱크 수 열세로 이어집니다!',
              owner: LogOwner.system,
              altText: '탱크가 모자란 쪽이 무너지고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처 압박! 상대가 버틸 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 화력 차이! 라인이 무너집니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
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
              text: '{away} 선수 탱크와 벌처로 상대를 압박합니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력으로 밀어붙입니다! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 부족합니다! 벌처만으로는 막을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '벌처전 열세가 탱크 수 열세로 이어집니다!',
              owner: LogOwner.system,
              altText: '탱크가 모자란 쪽이 무너지고 있습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 벌처 압박! 상대가 버틸 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 탱크 화력 차이! 라인이 무너집니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 드랍 준비 (lines 38-48) ── recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'drop_preparation',
      startLine: 38,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드랍십을 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200, // 드랍십 200/2sup
          fixedCost: true,
          altText: '{home} 선수 드랍십 생산. 상대 후방을 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 드랍십을 생산합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -200,
          fixedCost: true,
          altText: '{away} 선수 드랍십 생산. 양쪽 드랍 체제입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리를 올립니다. 골리앗 생산 준비입니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아머리 150
          fixedCost: true,
          altText: '{home} 선수 아머리 건설. 골리앗으로 대공 화력을 갖춥니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 드랍십이 나왔습니다. 멀티포인트 견제전이 시작됩니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '드랍 체제 진입. 어디를 노리느냐가 관건입니다.',
        ),
      ],
    ),
    // ── Phase 3.5: 확장 타이밍 분기 (lines 49-60) ── recovery 200/줄
    // 원팩원스타 미러에서 앞마당 확장 타이밍
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 49,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 양측 동시 확장 (가장 일반적)
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당에 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400, // CC 400
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장. 자원 라인을 늘립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 커맨드센터를 올립니다. 비슷한 타이밍입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장. 양측 동시 확장입니다.',
            ),
            ScriptEvent(
              text: '양측 비슷한 타이밍에 앞마당을 가져갑니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '동시 확장, 이제 드랍 견제전이 본격화됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 앞마당 SCV를 견제합니다!',
              owner: LogOwner.home,
              awayResource: -100,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{home} 선수 벌처 견제! 새 확장기지 일꾼을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처를 보내 상대 앞마당을 견제합니다!',
              owner: LogOwner.away,
              homeResource: -100,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{away} 선수도 벌처 견제! SCV를 잡습니다!',
            ),
          ],
        ),
        // 홈 선확장 (리스크 감수, 후반 자원 우위)
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 앞마당 커맨드센터를 올립니다. 과감한 확장입니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 선확장. 자원 우위를 노립니다.',
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
              text: '{away} 선수 벌처로 SCV를 잡으며 확장을 방해합니다!',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{away} 선수 벌처 견제! 새 확장기지 SCV에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뒤늦게 앞마당을 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장. 자원 격차를 줄입니다.',
            ),
          ],
        ),
        // 어웨이 선확장 (홈 선확장의 미러)
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 앞마당 커맨드센터를 올립니다. 과감한 확장입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 선확장. 자원 우위를 노립니다.',
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
              text: '{home} 선수 벌처로 SCV를 잡으며 확장을 방해합니다!',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 견제! 새 확장기지 SCV에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 뒤늦게 앞마당을 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수도 앞마당 확장. 자원 격차를 줄입니다.',
            ),
          ],
        ),
        // 홈 확장 포기 + 공격 (decisive)
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 확장을 포기하고 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.home,
              homeResource: -300, homeArmy: 3, // 팩토리(300) + 생산 유닛
              fixedCost: true,
              altText: '{home} 선수 확장 대신 팩토리 추가. 공격 준비입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드센터를 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 앞마당 확장을 올립니다.',
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
              altText: '{home} 선수 탱크 라인이 상대를 짓누릅니다! 병력이 없습니다!',
            ),
          ],
        ),
        // 어웨이 확장 포기 + 공격 (decisive, 홈의 미러)
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 확장을 포기하고 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.away,
              awayResource: -300, awayArmy: 3,
              fixedCost: true,
              altText: '{away} 선수 확장 대신 팩토리 추가. 공격 준비입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장을 올립니다.',
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
              altText: '{away} 선수 탱크 라인이 상대를 짓누릅니다! 병력이 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 4: 결전 전 교전 (lines 61-75) ── recovery 200/줄
    ScriptPhase(
      name: 'pre_decisive',
      startLine: 61,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 편성을 완료합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -400, // 탱크(250/2sup) + 골리앗(150/2sup)
          fixedCost: true,
          altText: '{home} 선수 탱크와 골리앗 조합. 전 병력 결집입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 조합을 완료합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -400,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 마주합니다. 시즈 포격 사거리 싸움입니다.',
          owner: LogOwner.system,
          altText: '탱크 골리앗 대치. 먼저 시야를 밝히는 쪽이 유리합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'control',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'control',
          altText: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 벌처/탱크 교전 강화
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
        // 원거리 맵: 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 확장이 안전합니다. 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 5: 드랍/정면 다양성 - 분기 (lines 76-92) ── recovery 200/줄
    ScriptPhase(
      name: 'drop_or_frontal',
      startLine: 76,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 홈 게릴라 드랍 (경미한 피해, 시선 끌기, decisive 아님)
        ScriptBranch(
          id: 'home_guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크 한 대를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 게릴라 드랍. 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내립니다! 시즈 모드! SCV가 위험합니다!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 탱크 투하! 상대 SCV를 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗을 보내 드랍을 처리합니다. 피해가 크진 않습니다.',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{away} 선수 빠르게 대응. 탱크를 잡습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍으로 시선을 끈 사이 정면 라인에서 거리재기를 합니다.',
              owner: LogOwner.home,
              skipChance: 0.3,
              altText: '드랍은 회수하고, 정면 거리재기가 이어집니다.',
            ),
          ],
        ),
        // 어웨이 게릴라 드랍 (미러)
        ScriptBranch(
          id: 'away_guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크 한 대를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 게릴라 드랍. 확장기지를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지에 탱크를 내립니다! 시즈 모드! SCV가 위험합니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 탱크 투하! 상대 SCV를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗을 보내 드랍을 처리합니다. 피해가 크진 않습니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 빠르게 대응. 탱크를 잡습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍으로 시선을 끈 사이 정면 라인에서 거리재기를 합니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
              altText: '드랍은 회수하고, 정면 거리재기가 이어집니다.',
            ),
          ],
        ),
        // 홈 마무리 드랍 (유리한 쪽이 드랍과 정면 동시, decisive)
        ScriptBranch(
          id: 'home_finishing_drop',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 앞서고 있습니다. 드랍십 두 대 출격!',
              owner: LogOwner.home,
              favorsStat: 'sense',
              altText: '{home} 선수 드랍십 두 대를 띄웁니다. 마무리를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 본진과 확장 동시 투하! 정면 탱크 라인도 전진합니다!',
              owner: LogOwner.home,
              awayResource: -400, awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 세 방향 공격! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 정면과 후방 동시에 무너집니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격이 성공합니다! 상대가 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 멀티포인트 공격! 더 이상 막을 수가 없습니다!',
            ),
          ],
        ),
        // 어웨이 마무리 드랍 (미러)
        ScriptBranch(
          id: 'away_finishing_drop',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 앞서고 있습니다. 드랍십 두 대 출격!',
              owner: LogOwner.away,
              favorsStat: 'sense',
              altText: '{away} 선수 드랍십 두 대를 띄웁니다. 마무리를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 본진과 확장 동시 투하! 정면 탱크 라인도 전진합니다!',
              owner: LogOwner.away,
              homeResource: -400, homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 세 방향 공격! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비가 갈립니다! 정면과 후방 동시에 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 드랍과 정면 동시 공격이 성공합니다! 상대가 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 멀티포인트 공격! 더 이상 막을 수가 없습니다!',
            ),
          ],
        ),
        // 정면 교전 (드랍 없이 정면 승부)
        ScriptBranch(
          id: 'frontal_clash',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 드랍을 경계하며 골리앗을 대공 위치에 배치합니다. 정면 승부입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍 없이 정면 승부. 탱크 라인 싸움입니다.',
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
              text: '{home} 선수 탱크와 골리앗 라인을 전진시킵니다!',
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
              text: '정면 라인전! 시즈 포격 범위가 승부를 가릅니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '탱크 일점사! 상대 탱크를 줄이는 데 집중합니다.',
            ),
          ],
        ),
        // 홈 역전 드랍 (불리한 쪽 올인)
        ScriptBranch(
          id: 'home_desperate_drop',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다! 병력 차이가 벌어집니다!',
              owner: LogOwner.system,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 가득 싣습니다! 본진을 노립니다!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 대규모 드랍! 승부수를 던집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 본진에 탱크 투하! 시즈 모드! 팩토리가 터집니다!',
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
              text: '역전 드랍! 불리했던 경기를 드랍십 한 방으로 뒤집습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍십 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
        // 어웨이 역전 드랍 (미러)
        ScriptBranch(
          id: 'away_desperate_drop',
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
              altText: '드랍십 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 6: 결전 판정 - 분기 (lines 93+) ── recovery 200/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 93,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시야 확보! 선제 시즈 포격으로 상대 탱크를 격파합니다!',
              altText: '{home} 선수 드랍 견제 성공! 상대 후방을 초토화합니다!',
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
              text: '{away} 선수 벌처 시야로 상대 탱크 위치를 포착! 선제 포격 성공!',
              altText: '{away} 선수 탱크 드랍으로 상대 본진을 기습합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
