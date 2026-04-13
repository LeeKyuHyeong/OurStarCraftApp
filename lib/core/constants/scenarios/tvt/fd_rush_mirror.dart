part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// FD 러쉬 미러 (탱크 시즈 거리재기)
// ----------------------------------------------------------
const _tvtFdRushMirror = ScenarioScript(
  id: 'tvt_fd_rush_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_fd_rush'],
  awayBuildIds: ['tvt_fd_rush'],
  description: 'FD 러쉬 탱크 대결',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-8) ── recovery 100/줄
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
          text: '{home} 선수 가스를 올리고 마린을 계속 뽑습니다.',
          owner: LogOwner.home,
          homeResource: -100, // 리파이너리 100
          homeArmy: 2, // 마린 생산 시작
          fixedCost: true,
          altText: '{home} 선수 리파이너리 건설, 마린 생산이 계속됩니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스를 올리고 마린을 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -100,
          awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수도 리파이너리, 마린 연속 생산.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 마린은 계속 생산합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 팩토리 300
          homeArmy: 2, // 마린 추가
          fixedCost: true,
          altText: '{home} 선수 팩토리를 올리면서 마린을 모읍니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리를 올립니다. 마린도 계속 생산.',
          owner: LogOwner.away,
          awayResource: -300,
          awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수도 팩토리 건설, 마린 물량이 늘어납니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착. 벌처를 건너뛰고 바로 탱크를 노립니다.',
          owner: LogOwner.home,
          homeResource: -100, // 머신샵 100
          fixedCost: true,
          altText: '{home} 선수 머신샵을 올립니다, 빠른 탱크 체제입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착. 벌처 없이 바로 탱크입니다.',
          owner: LogOwner.away,
          awayResource: -100,
          fixedCost: true,
          altText: '{away} 선수도 머신샵, 탱크를 뽑을 준비입니다.',
        ),
        ScriptEvent(
          text: '마린을 모으면서 팩토리 머신샵까지, 컨트롤 싸움이 중요하겠습니다.',
          owner: LogOwner.system,
          altText: '벌처를 건너뛰고 바로 탱크, 마린과 함께 밀겠다는 빌드입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산과 시즈모드 연구를 동시에 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 시즈탱크 250 + 시즈모드 300
          fixedCost: true,
          altText: '{home} 선수 탱크와 시즈모드를 동시에 돌립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크와 시즈모드를 동시에 시작합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          altText: '{away} 선수도 탱크 생산과 시즈모드 동시 진행.',
        ),
      ],
    ),
    // ── Phase 1: 마린+탱크 전진 (lines 12-20) ── recovery 150/줄
    ScriptPhase(
      name: 'marine_tank_push',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈모드 완료! 마린 6기와 탱크를 앞세워 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, // 마린 추가 완성분
          favorsStat: 'attack',
          altText: '{home} 선수 마린 물량에 탱크까지! 전진 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수도 마린과 탱크로 전진합니다! 센터에서 마주칩니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'attack',
          altText: '{away} 선수도 마린과 탱크가 합류! 센터로 향합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 뒤에서 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.home,
          homeResource: -400, // CC 400
          fixedCost: true,
          altText: '{home} 선수 압박하면서 앞마당 확장을 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터를 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 전진하면서 뒤에서 확장.',
        ),
        ScriptEvent(
          text: '양측 마린과 탱크가 센터에서 마주칩니다! 컨트롤 싸움이 중요하겠습니다.',
          owner: LogOwner.system,
          altText: '마린 물량에 시즈탱크까지, 초반부터 치열한 교전입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 고지를 먼저 잡으려 합니다, 시즈 거리가 중요합니다.',
          owner: LogOwner.home,
          favorsStat: 'control',
          altText: '{home} 선수 고지 선점 시도.',
        ),
        ScriptEvent(
          text: '{away} 선수도 고지를 노립니다, 탱크 배치 싸움입니다.',
          owner: LogOwner.away,
          favorsStat: 'control',
          altText: '{away} 선수 고지 확보 시도, 먼저 잡는 쪽이 유리합니다.',
        ),
      ],
    ),
    // ── Phase 2: 시즈 대치 분기 (lines 22-32) ── recovery 150/줄
    ScriptPhase(
      name: 'siege_standoff',
      startLine: 22,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 고지 선점
        ScriptBranch(
          id: 'home_high_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 고지를 먼저 잡았습니다! 시즈 모드!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 추가
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 고지 선점! 시즈 화력이 내려다봅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아래에서 시즈를 잡지만 사거리가 불리합니다.',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -2, // 탱크 교전
              altText: '{away} 선수 저지대에서 시즈 모드, 사거리 열세입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 상대 탱크를 직격합니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 고지 시즈 포격! 상대 탱크가 폭발합니다!',
            ),
            ScriptEvent(
              text: '고지 선점 차이! 시즈 대결에서 위치가 결정적입니다.',
              owner: LogOwner.system,
              altText: '고지를 먼저 잡은 차이가 크게 벌어지고 있습니다.',
            ),
          ],
        ),
        // 분기 B: 어웨이 고지 선점
        ScriptBranch(
          id: 'away_high_ground',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 고지를 먼저 잡았습니다! 시즈 모드!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              favorsStat: 'control',
              altText: '{away} 선수 고지 선점! 시즈 사거리 우위!',
            ),
            ScriptEvent(
              text: '{home} 선수 아래에서 올려다보는 형국, 불리합니다.',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -2,
              altText: '{home} 선수 저지대에서 시즈, 화력이 불리합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 고지에서 포격! 상대 탱크를 맞춥니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 고지 시즈! 상대 탱크가 무너집니다!',
            ),
            ScriptEvent(
              text: '고지 선점! 한 발 빠른 배치가 판도를 가릅니다.',
              owner: LogOwner.system,
              altText: '위치 선점 차이로 전세가 기울고 있습니다.',
            ),
          ],
        ),
        // 분기 C: 양쪽 교착
        ScriptBranch(
          id: 'siege_stalemate',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 탱크가 비슷한 거리에서 시즈를 잡습니다, 교착 상태입니다.',
              owner: LogOwner.system,
              altText: '양측 탱크 대치, 시즈 사거리가 맞물립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처를 생산해 우회를 시도합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75, // 벌처 75/2sup
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 벌처 추가, 옆길로 돌아갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처로 대응, 마인을 매설합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -75,
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 벌처 마인 매설, 우회 경로를 차단합니다.',
            ),
            ScriptEvent(
              text: '시즈 교착! 누가 먼저 실수하느냐가 관건입니다.',
              owner: LogOwner.system,
              skipChance: 0.2,
              altText: '교착 상태가 길어집니다, 집중력 싸움입니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 탱크 푸시 체크 (lines 30-38) ── recovery 150/줄
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 30,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 탱크 비등 → 게임 계속
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크 물량이 비등합니다, 시즈 라인 교착이 이어집니다.',
              owner: LogOwner.system,
              altText: '양쪽 탱크 수가 비슷합니다, 쉽게 밀어붙이기 어렵습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 추가 생산합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250,
              fixedCost: true,
              altText: '{home} 선수 탱크 한 대가 더 합류합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 탱크를 추가 생산합니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수도 탱크 보충.',
            ),
            ScriptEvent(
              text: '물량전으로 가고 있습니다, 확장이 필요한 시점입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '탱크 수 싸움이 치열합니다, 자원 확보가 관건입니다.',
            ),
          ],
        ),
        // 분기 B: 홈 탱크 푸시 → decisive
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 모드를 풀고 전진합니다! 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250,
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 상대 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 유리한 각도에서 시즈 포격! 상대 탱크를 제압합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 시즈 집중 포격! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 푸시로 시즈 라인을 돌파합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 운용이 한 수 위였습니다!',
            ),
          ],
        ),
        // 분기 C: 어웨이 탱크 푸시 → decisive
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 모드를 풀고 전진합니다! 밀어붙입니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 전진! 상대 라인으로 밀고 갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 유리한 각도에서 포격! 상대 탱크를 날립니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 시즈 집중 포격! 상대 라인이 붕괴합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 푸시로 시즈 라인을 돌파합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 압도적인 탱크 운용으로 제압합니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 4: 확장 타이밍 분기 (lines 36-46) ── recovery 200/줄
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 36,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 분기 A: 동시 확장 (가장 빈번)
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
              altText: '{home} 선수 앞마당 확장.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장.',
            ),
            ScriptEvent(
              text: '{home} 선수 두 번째 팩토리를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -300, // 팩토리 300
              fixedCost: true,
              altText: '{home} 선수 투팩 체제로 전환합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 팩토리를 추가합니다.',
              owner: LogOwner.away,
              awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수도 투팩 전환.',
            ),
            ScriptEvent(
              text: '양측 확장과 투팩 체제, 물량전으로 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '양쪽 다 확장을 올렸습니다, 자원 싸움이 본격화됩니다.',
            ),
          ],
        ),
        // 분기 B: 홈 빠른 확장
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 선 확장, 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 추가 생산, 상대 확장을 노립니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 확장 대신 탱크 물량을 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격으로 확장을 압박합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 확장 타이밍을 노려 시즈 포격!',
            ),
            ScriptEvent(
              text: '{home} 선수 버텨냅니다, 확장이 완성되면 자원 우위입니다.',
              owner: LogOwner.home,
              favorsStat: 'defense',
              altText: '{home} 선수 수비 성공, 확장 자원이 들어오기 시작합니다.',
            ),
          ],
        ),
        // 분기 C: 어웨이 빠른 확장
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 선 확장, 자원 우위를 가져가려 합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 추가 생산, 상대 확장을 압박합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250,
              fixedCost: true,
              altText: '{home} 선수 확장 대신 탱크 물량.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격으로 확장을 공격합니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 확장 타이밍에 시즈 포격!',
            ),
            ScriptEvent(
              text: '{away} 선수 버텨냅니다, 확장이 돌아가면 유리합니다.',
              owner: LogOwner.away,
              favorsStat: 'defense',
              altText: '{away} 선수 수비 성공, 자원이 들어오기 시작합니다.',
            ),
          ],
        ),
        // 분기 D: 홈 확장 스킵 공격 → decisive
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 확장을 포기하고 탱크를 더블 생산합니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -500, // 탱크 2기
              fixedCost: true,
              altText: '{home} 선수 확장 없이 올인, 탱크 물량을 올립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수는 확장을 시도합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 앞마당 확장, 그런데 상대가 밀고 옵니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 물량으로 밀어붙입니다! 확장 타이밍을 잡았습니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 올인 시즈 포격! 상대 확장이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 포기 올인으로 밀어붙여 승리합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 확장 없이 탱크 올인으로 제압합니다!',
            ),
          ],
        ),
        // 분기 E: 어웨이 확장 스킵 공격 → decisive
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 확장을 포기하고 탱크를 더블 생산합니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -500,
              fixedCost: true,
              altText: '{away} 선수 확장 없이 올인, 탱크 물량.',
            ),
            ScriptEvent(
              text: '{home} 선수는 확장을 시도합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장, 상대가 밀고 옵니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 물량으로 밀어붙입니다! 확장 타이밍을 잡았습니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 올인 시즈 포격! 상대 확장이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 포기 올인으로 밀어붙여 승리합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 확장 없이 탱크 올인으로 제압합니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 스타포트 + 드랍 준비 (lines 48-54) ── recovery 200/줄
    ScriptPhase(
      name: 'starport_prep',
      startLine: 48,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 스타포트.',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 더블 생산, 물량을 올립니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -500, // 탱크 2기
          fixedCost: true,
          altText: '{home} 선수 탱크 2기 추가 생산.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 더블 생산.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -500,
          fixedCost: true,
          altText: '{away} 선수도 탱크 2기 추가.',
        ),
        ScriptEvent(
          text: '양측 스타포트 완성, 드랍과 우회가 승부를 가를 수 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '스타포트가 올라왔습니다, 드랍 운영이 중요해집니다.',
        ),
        // ── 맵 특성 이벤트 ──
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
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다, 지형 싸움입니다.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '원거리 맵이라 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 6: 드랍 운영 다양성 분기 (lines 56+) ── recovery 200/줄
    ScriptPhase(
      name: 'drop_operations',
      startLine: 56,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 분기 A: 게릴라 드랍 (확장 견제 후 회수)
        ScriptBranch(
          id: 'guerrilla',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -200, // 드랍십 200
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격, 상대 확장을 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 기지에 탱크 투하! SCV를 잡고 회수합니다!',
              owner: LogOwner.home,
              awayResource: -200, // 일꾼 피해
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 일꾼 피해를 주고 빠져나갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 도착했지만 이미 빠져나간 뒤입니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -150, // 골리앗 150/2sup
              fixedCost: true,
              altText: '{away} 선수 대응이 늦었습니다, 피해가 남았습니다.',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 자잘한 피해가 쌓이고 있습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍으로 시선을 끈 사이 정면 거리재기가 이어집니다.',
            ),
          ],
        ),
        // 분기 B: 마무리 드랍 → decisive
        ScriptBranch(
          id: 'finishing',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대를 출격시킵니다!',
              owner: LogOwner.home,
              homeResource: -400, // 드랍십 2기
              fixedCost: true,
              altText: '{home} 선수 드랍 두 방향으로 나갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진과 확장에 동시 투하! 정면 탱크도 전진합니다!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -300,
              favorsStat: 'strategy',
              altText: '{home} 선수 양면 공격! 드랍과 정면 동시 압박!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 분산됩니다! 세 방향 공격입니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 병력을 나눌 수밖에 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격으로 제압합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 양면작전 성공으로 승리합니다!',
            ),
          ],
        ),
        // 분기 C: 정면 시즈 교전 (드랍 없이)
        ScriptBranch(
          id: 'frontal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 시즈 라인이 정면에서 맞붙습니다! 포격전입니다!',
              owner: LogOwner.system,
              homeArmy: -2, awayArmy: -2,
              altText: '정면 시즈전! 탱크끼리 포격을 주고받습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 마인을 매설, 상대 탱크 이동 경로를 차단합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -75,
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 마인 매설, 탱크 전진 경로를 막습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 마인을 밟습니다! 탱크 한 대가 터집니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 탱크가 마인에 피격! 한 대를 잃습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 마인 피해와 겹쳐 상대 라인이 약해집니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 마인과 시즈 연계 포격! 상대 전선이 밀립니다!',
            ),
          ],
        ),
        // 분기 D: 역전 드랍 (불리한 쪽 승부수)
        ScriptBranch(
          id: 'desperate',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 밀리고 있습니다! 승부수를 던집니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 전선이 불리합니다! 드랍으로 승부합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.away,
              awayResource: -400, // 드랍십 2기
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{away} 선수 올인 드랍! 본진에 탱크를 투하합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeResource: -400, homeArmy: -2, // 생산시설+병력 피해
              favorsStat: 'attack',
              altText: '{away} 선수 본진 시즈! 팩토리와 탱크에 피해를 줍니다!',
            ),
            ScriptEvent(
              text: '역전 드랍! 피해가 크면 경기가 뒤집힐 수 있습니다!',
              owner: LogOwner.system,
              altText: '본진 드랍 피해가 상당합니다! 경기가 요동칩니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 7: 최종 결전 (lines 64+) ── recovery 200/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 64,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 뒤쪽 고지로!',
              owner: LogOwner.home,
              awayResource: -300, awayArmy: -2, // 후방 피해
              favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 후방 고지에 시즈!',
            ),
            ScriptEvent(
              text: '{home} 선수 양면 시즈 포격! 정면과 후방 동시 공격!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 정면과 드랍 양면 공격! 상대가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 대결에서 위치 선점과 드랍으로 승리합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 탱크 운용이 한 수 위였습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처로 마인을 매설, 상대 이동 경로를 차단합니다.',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 마인 매복! 상대 탱크가 밟습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 유리한 위치에서 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 시즈 집중 포격! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 배치와 마인 운용으로 대결을 제압합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 시즈 거리재기에서 승리합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
