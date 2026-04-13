part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원팩원스타 미러 (스타포트 유닛 운용이 핵심)
// 드랍쉽 견제 vs 레이스 압박, 첫 드랍쉽 성공 여부가 판도를 가름
// ----------------------------------------------------------
const _tvt1fac1starMirror = ScenarioScript(
  id: 'tvt_1fac_1star_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_1star'],
  awayBuildIds: ['tvt_1fac_1star'],
  description: '원팩원스타 드랍쉽 레이스 대결',
  phases: [
    // ── Phase 0: 오프닝 (배럭→팩토리→스타포트→벌처+탱크) ──
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
          altText: '{away} 선수 팩토리 건설. 원팩원스타가 예상됩니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 올립니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 스타포트 건설합니다.',
        ),
        // 벌처 + 탱크 생산 시작
        ScriptEvent(
          text: '{home} 선수 벌처를 뽑으면서 머신샵을 부착합니다. 탱크도 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -175, // 벌처(75) + 머신샵(100)
          fixedCost: true,
          altText: '{home} 선수 벌처 생산, 머신샵을 올립니다. 탱크 체제 진입입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처와 머신샵. 탱크를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -175,
          fixedCost: true,
          altText: '{away} 선수도 벌처 생산, 머신샵 부착합니다.',
        ),
        ScriptEvent(
          text: '작은 실수도 크게 벌어질 수 있는게 같은 빌드 싸움이죠.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '컨트롤 싸움이 중요하겠습니다.',
        ),
      ],
    ),
    // ── Phase 1: 첫 드랍쉽/레이스 선택 분기 ──
    // 원팩원스타의 핵심: 스타포트에서 드랍쉽이냐 레이스냐
    ScriptPhase(
      name: 'starport_choice',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 생산을 시작합니다. 시즈모드 연구도 들어갑니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 탱크(250) + 시즈모드(300)
          fixedCost: true,
          altText: '{home} 선수 탱크와 시즈모드를 동시에 돌립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크와 시즈모드 연구를 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          altText: '{away} 선수도 탱크와 시즈모드를 동시에 시작합니다.',
        ),
        ScriptEvent(
          text: '스타포트가 완성됐습니다. 드랍쉽이냐 레이스냐, 선택이 갈립니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '원팩원스타의 핵심, 스타포트 유닛 선택 타이밍입니다.',
        ),
      ],
    ),
    // ── Phase 2: 첫 드랍쉽 견제 결과 - 분기 ──
    ScriptPhase(
      name: 'first_drop',
      startLine: 20,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // ── 분기 A: 홈 드랍쉽 견제 성공 + 어웨이 수비됨 ──
        ScriptBranch(
          id: 'home_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양쪽 드랍쉽이 나왔습니다! 원팩원스타의 꽃, 드랍 타이밍입니다!',
              owner: LogOwner.system,
              homeArmy: 1, homeResource: -200, // 드랍쉽 200
              awayArmy: 1, awayResource: -200,
              fixedCost: true,
              altText: '양 선수 모두 드랍쉽을 뽑았습니다. 견제전이 시작됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 탱크 한 기와 벌처 두 기를 태워 상대 본진으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽이 상대 본진을 향합니다! 탱크와 벌처를 싣고!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 본진에 내립니다! 탱크 시즈 모드! SCV가 터집니다!',
              owner: LogOwner.home,
              awayResource: -300, awayArmy: -2,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 성공! SCV를 잡아냅니다! 벌처가 쫓아다닙니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍쉽에서 벌처를 내리지만, {home} 선수 SCV 빼주기와 추가 생산된 탱크 컨트롤로 막힙니다!',
              owner: LogOwner.away,
              altText: '{away} 선수 드랍쉽에서 탱크와 벌처가 내렸지만, {home} 선수 추가 벌처가 빠르게 정리합니다!',
            ),
            ScriptEvent(
              text: '한쪽만 드랍이 통했습니다! SCV 피해 차이가 이후 운영에 직결됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍 견제 차이! 이 피해가 확장 타이밍을 가릅니다!',
            ),
          ],
        ),
        // ── 분기 B: 어웨이 드랍쉽 견제 성공 + 홈 수비됨 ──
        ScriptBranch(
          id: 'away_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양쪽 드랍쉽이 나왔습니다! 어디로 보내느냐가 관건입니다!',
              owner: LogOwner.system,
              homeArmy: 1, homeResource: -200,
              awayArmy: 1, awayResource: -200,
              fixedCost: true,
              altText: '양 선수 모두 드랍쉽을 선택했습니다. 견제 싸움입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽에 벌처 네 기를 태워 상대 본진으로 향합니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 벌처 가득 실은 드랍쉽이 상대 본진을 향합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 본진에 벌처 투하! SCV를 쫓아다니며 학살합니다!',
              owner: LogOwner.away,
              homeResource: -300, homeArmy: -2,
              favorsStat: 'harass',
              altText: '{away} 선수 벌처 견제 성공! SCV 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 드랍쉽에서 탱크와 벌처를 내리지만, {away} 선수 SCV 빼주기와 추가 생산된 벌처 컨트롤로 막힙니다!',
              owner: LogOwner.home,
              altText: '{home} 선수 드랍쉽에서 벌처가 내렸지만, {away} 선수 추가 탱크가 빠르게 정리합니다!',
            ),
            ScriptEvent(
              text: '드랍 견제 차이가 벌어졌습니다! 이 SCV 피해가 중반 운영을 좌우합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '한쪽만 드랍이 통했습니다! 자원 차이가 벌어집니다!',
            ),
          ],
        ),
        // ── 분기 C: 양쪽 드랍 다 어느 정도 통함 ──
        ScriptBranch(
          id: 'both_drop_damage',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '양쪽 드랍쉽이 나왔습니다! 서로의 후방을 노립니다!',
              owner: LogOwner.system,
              homeArmy: 1, homeResource: -200,
              awayArmy: 1, awayResource: -200,
              fixedCost: true,
              altText: '양 선수 모두 드랍쉽 선택! 동시에 견제에 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에 탱크와 벌처를 태워 상대 본진으로!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 탱크 한 기와 벌처를 실은 드랍쉽이 상대 본진으로!',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍쉽에 벌처를 가득 태워 상대 본진을 기습합니다! SCV를 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수도 탱크와 벌처를 실은 드랍쉽으로 상대 본진 기습! SCV에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 생산된 탱크와 벌처로 상대 드랍 병력을 처리합니다.',
              owner: LogOwner.home,
              awayArmy: -1,
              favorsStat: 'defense',
              altText: '{home} 선수 SCV를 빼면서 팩토리 병력으로 수비합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 수비 후 드랍쉽을 회수합니다.',
              owner: LogOwner.away,
              homeArmy: -1,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '양쪽 다 견제가 통했습니다! SCV 피해를 주고받았습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '서로 드랍 피해를 입었습니다. 어느 쪽 피해가 더 클까요.',
            ),
          ],
        ),
        // ── 분기 D: 양쪽 드랍 다 수비됨 ──
        ScriptBranch(
          id: 'both_drop_defended',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 드랍쉽이 나왔습니다! 드랍 견제가 시작됩니다!',
              owner: LogOwner.system,
              homeArmy: 1, homeResource: -200,
              awayArmy: 1, awayResource: -200,
              fixedCost: true,
              altText: '양 선수 모두 드랍쉽을 뽑았습니다. 견제에 들어갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽에서 탱크와 벌처를 내리지만, {away} 선수 SCV를 재빨리 빼고 추가 벌처가 정리합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 시도! 하지만 상대가 SCV를 잘 빼서 피해가 적습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍쉽에서 벌처를 내리지만, {home} 선수도 SCV를 빼고 탱크로 수비합니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수도 드랍 시도! 하지만 수비가 단단합니다!',
            ),
            ScriptEvent(
              text: '양쪽 다 드랍이 막혔습니다! 피해 없이 정면 싸움으로 전환됩니다!',
              owner: LogOwner.system,
              altText: '드랍이 통하지 않았습니다. 탱크 라인 싸움이 관건입니다.',
            ),
          ],
        ),
        // ── 분기 E: 홈 드랍쉽 / 어웨이 레이스 선택 ──
        ScriptBranch(
          id: 'home_drop_away_wraith',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽을 생산합니다. 견제를 시도합니다.',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -200, // 드랍쉽 200
              awayResource: -150,
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽으로 상대 후방을 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수는 레이스를 뽑습니다! 대공이 부족한 상대를 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -250, // 레이스 250
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{away} 선수 레이스 선택! 하늘에서 상대를 압박합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 상대 탱크 라인 위를 날아다닙니다! 골리앗이 없으면 속수무책!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 레이스 공중 압박! 상대 대공이 부족합니다!',
            ),
            ScriptEvent(
              text: '드랍쉽 견제 vs 레이스 압박! 전혀 다른 선택이 맞붙습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ── 분기 F: 어웨이 드랍쉽 / 홈 레이스 선택 ──
        ScriptBranch(
          id: 'away_drop_home_wraith',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍쉽을 생산합니다. 견제를 시도합니다.',
              owner: LogOwner.away,
              awayArmy: 1, awayResource: -200, // 드랍쉽 200
              homeResource: -150,
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍쉽으로 상대 후방을 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수는 레이스를 선택합니다! 소수 레이스로 상대를 압박!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -250, // 레이스 250
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{home} 선수 레이스 운용! 대공이 부족한 상대를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 상대 벌처와 탱크 위를 날아다닙니다! 골리앗 없이는 막을 수 없습니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 레이스 압박! 상대가 골리앗을 급히 뽑아야 합니다!',
            ),
            ScriptEvent(
              text: '레이스 압박 vs 드랍쉽 견제! 선택이 엇갈렸습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 중반 전환 (확장 + 추가 드랍쉽/레이스 운용) ──
    ScriptPhase(
      name: 'mid_transition',
      startLine: 30,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 커맨드센터를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
          homeExpansion: true,
          altText: '{home} 선수 앞마당 확장. 자원 라인을 늘립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 확장을 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          awayExpansion: true,
          altText: '{away} 선수도 앞마당 커맨드센터를 건설하죠.',
        ),
        ScriptEvent(
          text: '양쪽 확장이 가동됩니다. 초반 스타포트 운용 차이가 중반 운영을 좌우합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '확장은 갔습니다. 이제 탱크 라인과 견제전이 본격화됩니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리를 올리고 골리앗 생산을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 아머리 건설. 골리앗으로 대공을 보강합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설. 골리앗 체제 전환입니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수도 아머리. 골리앗으로 넘어갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스캔을 뿌려 상대 진형을 확인합니다.',
          owner: LogOwner.home,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 스캔으로 상대 병력 배치를 살핍니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스캔으로 상대 라인을 확인합니다.',
          owner: LogOwner.away,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{away} 선수 스캔을 뿌립니다. 상대 탱크 위치를 잡습니다.',
        ),
      ],
    ),
    // ── Phase 4: 추가 드랍쉽 운용 + 탱크 라인전 - 분기 ──
    ScriptPhase(
      name: 'drop_operations',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // ── 홈 드랍쉽 편대로 상대 확장 견제 ──
        ScriptBranch(
          id: 'home_multi_drop',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍쉽 세 대에 병력을 나눠 태웁니다! 상대 확장기지를 노립니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍쉽 편대가 상대 멀티를 향합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내립니다! 시즈 모드! SCV가 큰 피해!',
              owner: LogOwner.home,
              awayResource: -250,
              favorsStat: 'harass',
              altText: '{home} 선수 확장 견제 성공! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력을 돌리지만 드랍쉽이 병력을 회수해서 빠집니다!',
              owner: LogOwner.away,
              altText: '{away} 선수 대응이 늦습니다! 드랍쉽이 이미 빠져나갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽이 살아서 돌아옵니다! 다시 견제를 준비합니다!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              skipChance: 0.3,
              altText: '{home} 선수 드랍쉽 재활용! 다른 곳을 노립니다!',
            ),
          ],
        ),
        // ── 어웨이 드랍쉽 편대로 상대 확장 견제 ──
        ScriptBranch(
          id: 'away_multi_drop',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍쉽 세 대에 병력을 태워 상대 확장기지로 향합니다!',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍쉽 편대가 상대 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지에 벌처를 내립니다! SCV를 쫓아다니며 잡습니다!',
              owner: LogOwner.away,
              homeResource: -250,
              favorsStat: 'harass',
              altText: '{away} 선수 멀티 견제! SCV 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗으로 대응하지만 드랍쉽이 빠르게 회수합니다!',
              owner: LogOwner.home,
              altText: '{home} 선수 수비하지만 드랍쉽이 이미 빠졌습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽이 살아 돌아옵니다! 다음 견제를 노립니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              skipChance: 0.3,
              altText: '{away} 선수 드랍쉽 재활용! 이번엔 다른 방향!',
            ),
          ],
        ),
        // ── 홈 드랍쉽 합공 (방어병력 위 드랍 + 정면 동시) ──
        ScriptBranch(
          id: 'home_drop_attack',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 스캔으로 상대 탱크 라인을 확인합니다!',
              owner: LogOwner.home,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍쉽 편대가 상대 탱크 라인 위로! 동시에 정면 탱크도 전진!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 드랍쉽과 정면 동시 공격! 상대가 양면에서 끼입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 시즈 라인 뒤에 병력 투하! 앞뒤로 포격!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 합공! 상대 방어가 무너집니다!',
            ),
            ScriptEvent(
              text: '드랍쉽 합공! 앞뒤에서 포격이 들어갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ── 어웨이 드랍쉽 합공 ──
        ScriptBranch(
          id: 'away_drop_attack',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 스캔으로 상대 방어 라인을 확인합니다!',
              owner: LogOwner.away,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍쉽 편대가 상대 방어 병력 위로! 정면에서도 밀어붙입니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 드랍쉽과 지상 동시 공격! 상대가 갈립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 탱크 뒤에 착지! 정면에서도 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 양면 합공! 상대 시즈 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '양면 합공! 방어 병력이 녹아내립니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ── 정면 탱크 라인전 ──
        ScriptBranch(
          id: 'frontal_siege',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 스캔을 뿌려 상대 라인을 확인합니다! 시즈 포격!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 스캔 후 시즈 포격! 상대 탱크를 깎습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 전진시켜 맞포격합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 맞포격! 탱크 사거리 싸움입니다!',
            ),
            ScriptEvent(
              text: '골리앗까지 합류한 라인전! 시즈 포격 범위가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 결전 ──
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 편성을 완료합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -400,
          fixedCost: true,
          altText: '{home} 선수 탱크와 골리앗 조합. 전 병력 결집입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 조합을 완료합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 탱크 골리앗 편성. 결전을 준비합니다.',
        ),
        ScriptEvent(
          text: '탱크 골리앗 대치. 먼저 시야를 밝히는 쪽이 유리합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '양쪽 풀 메카닉 편성. 최종 결전이 다가옵니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 병력이 무너집니다!',
          owner: LogOwner.home,
          awayArmy: -8, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
          owner: LogOwner.away,
          homeArmy: -8, awayArmy: -4,
          favorsStat: 'attack',
          altText: '{away} 선수 골리앗 화력으로 반격합니다!',
        ),
      ],
    ),
    // ── Phase 6: 결전 판정 ──
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 60,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 시야 확보! 선제 시즈 포격으로 상대 탱크를 격파합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'sense',
              altText: '{home} 선수 스캔으로 상대 탱크를 잡습니다! 화력 우위!',
            ),
            ScriptEvent(
              text: '{home} 선수 다방면 공격! {away} 선수 앞마당까지 밀리며 본진이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 후방 기습으로 {away} 선수 본진 장악, 남은 병력 싸움에서 우위!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처 시야로 상대 탱크 위치를 포착! 선제 포격 성공!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'sense',
              altText: '{away} 선수 스캔으로 상대 라인을 잡습니다! 시즈 포격!',
            ),
            ScriptEvent(
              text: '{away} 선수 승부수! 후방 기습으로 {home} 선수 본진 장악, 남은 병력싸움에서 우위!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 다방면 공격! {home} 선수 앞마당까지 밀리며 본진이 무너집니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
