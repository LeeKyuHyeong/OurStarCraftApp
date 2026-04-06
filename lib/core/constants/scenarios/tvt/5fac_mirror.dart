part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 13. 5팩토리 미러 (올인 미러)
// ----------------------------------------------------------
const _tvt5facMirror = ScenarioScript(
  id: 'tvt_5fac_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_5fac'],
  description: '5팩토리 미러 올인 대결',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-13) - recovery 100/줄 ──
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다. {away} 선수도 배럭을 올립니다.',
          owner: LogOwner.system,
          homeResource: -150, // 배럭 150
          awayResource: -150,
          fixedCost: true,
          altText: '양쪽 배럭이 동시에 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올리고 팩토리 건설을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          awayResource: -400,
          fixedCost: true,
          altText: '{home} 선수 가스 채취와 동시에 팩토리.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설, 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 연달아 증설합니다. 벌써 세 번째.',
          owner: LogOwner.home,
          homeResource: -600, // 팩토리 x2 추가 (300+300)
          awayResource: -600,
          fixedCost: true,
          altText: '{home} 선수 팩토리가 쭉쭉 올라갑니다. 5팩 체제로.',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설, 확장 없이 올인하겠다는 의도.',
          owner: LogOwner.away,
          altText: '{away} 선수 확장 없이 팩토리만 짓습니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 건설, 시즈 모드 연구를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 머신샵(100) + 시즈모드(300)
          awayResource: -400,
          fixedCost: true,
          altText: '{home} 선수 머신샵에서 시즈 모드 연구.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착. 시즈 모드 연구 시작.',
          owner: LogOwner.away,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처와 시즈탱크 대량 생산을 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -325, // 벌처(75) + 탱크(250)
          awayArmy: 4, awayResource: -325,
          fixedCost: true,
          altText: '{home} 선수 탱크와 벌처가 쏟아지기 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구 완료, 5팩 물량으로 맞섭니다.',
          owner: LogOwner.away,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 5팩토리, 확장 없는 올인 미러입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '5팩 미러! 확장 없이 물량으로 맞붙는 구조입니다.',
        ),
      ],
    ),
    // ── Phase 1: 물량 축적 + 시야 경쟁 (lines 14-23) - recovery 150/줄 ──
    ScriptPhase(
      name: 'buildup',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 4기로 센터 시야를 확보합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -150, // 벌처 2기 (75x2)
          awayArmy: 4, awayResource: -150,
          fixedCost: true,
          altText: '{home} 선수 벌처가 센터를 장악합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 기동, 이동 경로에 마인을 깔아둡니다.',
          owner: LogOwner.away,
          altText: '{away} 선수 마인 매설, 탱크 전환 이후를 대비합니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 3기 배치, 센터 라인을 잡습니다.',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -750, // 탱크 3기 (250x3)
          awayArmy: 6, awayResource: -750,
          fixedCost: true,
          altText: '{home} 선수 탱크 라인이 센터에 자리를 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 배치, 양쪽 탱크가 마주 보고 있습니다.',
          owner: LogOwner.away,
          skipChance: 0.3,
          altText: '양쪽 탱크 라인이 센터에서 대치하고 있습니다.',
        ),
        ScriptEvent(
          text: '5팩 미러에서는 시야 확보가 곧 승부! 벌처로 눈을 뜨고 탱크로 때려야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '시야가 곧 화력! 벌처 컨트롤이 탱크 교전의 승패를 가릅니다!',
        ),
      ],
    ),
    // ── Phase 2: 탱크 푸시 체크 (lines 24-33) - recovery 150/줄 ──
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 24,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 양측 비등 → 시즈 거리재기
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크와 벌처가 대치합니다. 시즈 사거리 밖에서 거리재기가 시작됩니다.',
              owner: LogOwner.system,
              altText: '양쪽 탱크 라인이 팽팽하게 맞서고 있습니다. 함부로 전진할 수 없습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 시야를 잡으며 탱크 위치를 노출시키려 합니다.',
              owner: LogOwner.home,
              favorsStat: 'scout',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 정찰, 상대 탱크 배치를 확인합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처로 맞정찰, 양쪽 탱크 위치가 드러납니다.',
              owner: LogOwner.away,
              favorsStat: 'scout',
              skipChance: 0.4,
              altText: '{away} 선수 벌처 정찰, 상대 배치를 읽습니다.',
            ),
          ],
        ),
        // 홈 탱크 푸시 → 조기 종료
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처전에서 앞서며 탱크가 더 빨리 모였습니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -250,
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{home} 선수 물량 우위! 벌처 호위 아래 탱크가 전진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처로 상대 라인을 밀어붙입니다!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -200,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력으로 압박합니다! 상대 라인이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 부족합니다! 벌처만으로는 탱크를 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 탱크 수 열세! 라인이 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격이 쏟아집니다! 상대가 버틸 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 물량 차이를 앞세워 라인을 무너뜨립니다!',
            ),
          ],
        ),
        // 어웨이 탱크 푸시 → 조기 종료
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처전에서 앞서며 탱크 물량이 더 두껍습니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -250,
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 탱크 물량 우위! 벌처 호위 아래 전진합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 벌처로 상대 라인을 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력으로 압박합니다! 상대 라인이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 부족합니다! 물량에서 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 탱크 수 열세! 라인이 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격이 쏟아집니다! 상대가 버틸 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 물량 차이를 앞세워 라인을 무너뜨립니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 탱크 교전 - 분기 (lines 34-47) - recovery 150/줄 ──
    ScriptPhase(
      name: 'tank_clash',
      startLine: 34,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 시야 우위
        ScriptBranch(
          id: 'home_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처로 시야를 잡았습니다. 상대 탱크 위치가 보입니다.',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 시야 확보, 상대 탱크 배치를 읽었습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 선제 포격! 상대 탱크가 터집니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 선제 포격! 상대 탱크 라인에 직격!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 먼저 맞습니다! 시야 싸움에서 밀렸습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 시야가 없는 상태에서 포격을 받습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 잔여 병력 추격, 탱크 잔해를 정리합니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 벌처 추격! 남은 병력까지 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '시야 싸움에서 앞선 쪽이 탱크 교전을 지배합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '시야가 곧 화력! 상대 탱크를 보는 쪽이 유리합니다!',
            ),
          ],
        ),
        // 분기 B: 어웨이 시야 우위
        ScriptBranch(
          id: 'away_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 포격으로 상대 벌처를 잡습니다! 시야가 끊겼습니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 포격 명중! 상대 벌처가 시야를 잃습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크를 우회시켜 측면에서 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 측면 우회! 탱크가 상대 라인을 측면에서 때립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 측면에서 포격을 받습니다! 탱크가 큰 피해를 입습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 측면 포격에 탱크 라인이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 후속 추격, 잔여 탱크를 정리합니다.',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 추격! 남은 병력을 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '측면 포격으로 탱크 라인이 무너집니다! 시야가 곧 승부!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '시야 없는 탱크는 표적일 뿐입니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 4: 아머리 + 골리앗 전환 (lines 48-57) - recovery 200/줄 ──
    ScriptPhase(
      name: 'armory_transition',
      startLine: 48,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설합니다. 골리앗 생산도 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -300, // 아머리(150) + 골리앗(150/2sup)
          awayArmy: 2, awayResource: -300,
          fixedCost: true,
          altText: '{home} 선수 아머리 건설. 골리앗으로 화력을 보강합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설, 골리앗이 합류합니다.',
          owner: LogOwner.away,
          skipChance: 0.3,
          altText: '{away} 선수도 아머리에서 골리앗을 뽑기 시작합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 잔여 병력 총동원. 탱크 골리앗 재배치합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -400, // 탱크(250/2sup) + 골리앗(150/2sup)
          awayArmy: 4, awayResource: -400,
          fixedCost: true,
          altText: '{home} 선수 탱크 골리앗 총출동, 최종 진형을 갖춥니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 재배치. 맞붙을 준비를 마칩니다.',
          owner: LogOwner.away,
          skipChance: 0.3,
          altText: '{away} 선수 탱크 골리앗 재배치, 결전 준비 완료.',
        ),
      ],
    ),
    // ── Phase 5: 확장 타이밍 분기 (lines 58-70) - recovery 200/줄 ──
    // 5팩 미러에서도 교전이 길어지면 한쪽이 확장을 시도할 수 있다
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 58,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 양쪽 동시 확장 (가장 빈번 - 교전이 소강상태)
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '교전이 소강상태입니다. 양쪽 자원이 바닥나기 시작합니다.',
              owner: LogOwner.system,
              altText: '5팩 올인이 길어지면서 자원이 고갈되고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당에 커맨드센터를 건설합니다. 자원 보충이 필요합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장, 자원 라인을 넓힙니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 커맨드센터를 건설합니다. 같은 판단입니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장, 양쪽 자원 경쟁입니다.',
            ),
            ScriptEvent(
              text: '양쪽 확장을 올립니다. 올인 미러가 장기전으로 넘어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '5팩 올인이 자원전으로 전환되고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 확장기지 SCV를 노립니다!',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{home} 선수 벌처 견제! 확장기지 SCV를 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처를 보내 상대 확장기지 SCV를 괴롭힙니다!',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              skipChance: 0.5,
              altText: '{away} 선수 벌처 견제! SCV에 피해를 줍니다!',
            ),
          ],
        ),
        // 홈이 먼저 확장 → 어웨이 병력 압박
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 앞마당에 커맨드센터를 건설합니다. 자원 우위를 노립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 빠른 앞마당 확장, 과감한 투자입니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 상대가 확장을 올린 것을 확인합니다. 병력이 얇아질 때입니다.',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away} 선수 상대 확장 타이밍을 포착합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 대신 탱크를 추가 생산합니다. 병력으로 밀어붙입니다.',
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
              awayExpansion: true,
              skipChance: 0.3,
              altText: '{away} 선수도 앞마당 커맨드센터를 건설합니다.',
            ),
          ],
        ),
        // 어웨이가 먼저 확장 → 홈 병력 압박
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 앞마당 커맨드센터를 건설합니다. 자원 우위를 노립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 빠른 앞마당 확장, 과감한 투자입니다.',
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
              homeExpansion: true,
              skipChance: 0.3,
              altText: '{home} 선수도 앞마당 커맨드센터를 건설합니다.',
            ),
          ],
        ),
        // 홈 확장 스킵 → 올인 공격
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드센터를 건설합니다. 자원을 확보합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 앞마당 확장, 자원 라인을 넓힙니다.',
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
        // 어웨이 확장 스킵 → 올인 공격
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 건설합니다. 자원 확보를 시도합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장, 자원 라인을 늘립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 대신 팩토리를 추가합니다. 병력에 올인합니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -300,
              fixedCost: true,
              altText: '{away} 선수 확장을 포기하고 생산시설을 늘립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 골리앗을 밀어붙입니다! 확장 타이밍을 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1,
              favorsStat: 'attack',
              altText: '{away} 선수 전 병력 전진! 상대 병력이 얇습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장에 자원이 묶여 병력이 부족합니다! 시즈로 버텨야!',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 탱크 수가 부족합니다! 라인이 흔들립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격이 집중됩니다! 상대 라인을 뚫어냅니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 병력 차이를 앞세워 라인을 무너뜨립니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 6: 결전 (lines 71-85) - recovery 200/줄 ──
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '양측 탱크, 골리앗, 벌처가 정면 충돌합니다!',
          owner: LogOwner.system,
          altText: '전 병력이 한 곳에 모입니다! 정면 대결!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력 집중! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞서 싸웁니다!',
        ),
        // 근거리 맵: 벌처/탱크 교전 강화
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
          altText: '근거리 맵에서 탱크 포격이 더욱 치명적입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
          altText: '{away} 선수 탱크도 바로 사거리! 맞포격!',
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
          altText: '{home} 선수 고지대 시즈! 지형 이점을 확보합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움입니다.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
          altText: '{away} 선수 고지대 확보! 양쪽 지형 경쟁입니다.',
        ),
        // 원거리 맵: 자원 보충 여유
        ScriptEvent(
          text: '원거리 맵이라 재정비 시간이 있습니다. 양쪽 자원이 보충됩니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
          altText: '원거리 맵에서 양쪽 병력을 재정비합니다.',
        ),
      ],
    ),
    // ── Phase 7: 드랍 운영 다양성 - 분기 (lines 86-100) - recovery 200/줄 ──
    ScriptPhase(
      name: 'drop_diversity',
      startLine: 86,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 게릴라 드랍 (자잘한 피해 축적)
        ScriptBranch(
          id: 'guerrilla',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트를 건설합니다. 드랍십 생산을 준비합니다.',
              owner: LogOwner.home,
              homeResource: -250, // 스타포트(250)
              awayResource: -250,
              fixedCost: true,
              altText: '{home} 선수 스타포트 건설, 드랍 운영을 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              homeResource: -200, // 드랍십(200)
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격, 확장기지 견제를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내려 SCV를 잡습니다! 바로 회수!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제 성공! SCV 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗을 보냈지만 이미 빠져나갔습니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
              altText: '{away} 선수 대응이 늦었습니다. 이미 수송선이 떠났습니다.',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 시선을 끈 사이 정면에서 거리재기가 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '자잘한 피해가 쌓이면 결국 큰 차이가 됩니다.',
            ),
            // 공중 개방 맵: 추가 드랍 경로
            ScriptEvent(
              text: '공중이 열린 맵이라 드랍십이 다른 경로로 한 번 더 진입합니다!',
              owner: LogOwner.home,
              awayResource: -150,
              requiresMapTag: 'airHigh',
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 우회 드랍! 추가 SCV 피해!',
            ),
          ],
        ),
        // 마무리 드랍 (유리한 쪽이 끝내기)
        ScriptBranch(
          id: 'finishing',
          baseProbability: 0.7,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트 건설, 드랍십 두 대를 생산합니다.',
              owner: LogOwner.home,
              homeResource: -650, // 스타포트(250) + 드랍십 x2(400)
              awayResource: -250,
              fixedCost: true,
              altText: '{home} 선수 스타포트에서 드랍십 두 대 생산, 마무리를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 본진과 확장에 동시 투하!',
              owner: LogOwner.home,
              awayResource: -300,
              favorsStat: 'strategy',
              altText: '{home} 선수 멀티포인트 드랍! 본진과 확장을 동시에 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 세 방향에서 공격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 어디를 막아야 할지 판단이 필요합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              favorsStat: 'defense',
              altText: '{away} 선수 세 곳에서 공격이 들어옵니다! 대응이 어렵습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍과 정면 동시 공격! 수비가 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 멀티포인트 공격으로 상대를 무너뜨립니다!',
            ),
          ],
        ),
        // 정면 승부 (드랍 없이)
        ScriptBranch(
          id: 'frontal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 드랍을 경계하며 골리앗을 대공 위치에 배치합니다. 정면 승부입니다.',
              owner: LogOwner.system,
              altText: '드랍 없이 정면 승부, 탱크 라인 싸움입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 한 칸 전진! 시즈 포격으로 상대 탱크를 깎습니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 거리재기 승리! 상대 탱크를 한 대 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 재배치 후 맞포격! 골리앗을 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 맞포격! 병력을 깎습니다!',
            ),
            ScriptEvent(
              text: '탱크 라인 거리재기가 계속됩니다. 한 대 차이가 승패를 가릅니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '시즈 포격 한 방 한 방이 무겁습니다.',
            ),
          ],
        ),
        // 역전 드랍 (불리한 쪽의 승부수)
        ScriptBranch(
          id: 'desperate',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away} 선수 스타포트를 올립니다. 드랍십으로 승부수를 던집니다.',
              owner: LogOwner.away,
              awayResource: -450, // 스타포트(250) + 드랍십(200)
              fixedCost: true,
              altText: '{away} 선수 스타포트 건설. 드랍 역전을 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로 향합니다!',
              owner: LogOwner.away,
              awayResource: -200, // 드랍십 추가(200)
              fixedCost: true,
              favorsStat: 'strategy',
              altText: '{away} 선수 본진 기습 드랍! 탱크를 본진에 내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진에 탱크를 투하합니다! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeResource: -400, homeArmy: -2,
              favorsStat: 'harass',
              altText: '{away} 선수 본진 탱크 투하! 생산시설에 큰 피해!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진이 위험합니다! 병력을 돌려야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 본진에 탱크가 내려왔습니다! 대응이 급합니다!',
            ),
            ScriptEvent(
              text: '역전 드랍! 피해가 충분하면 경기가 뒤집힐 수 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '본진 드랍으로 생산력에 타격! 경기 흐름이 바뀌고 있습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 8: 결전 판정 - 분기 (lines 101+) - recovery 200/줄 ──
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 101,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시야 확보 성공! 측면 탱크 포격으로 상대 라인을 무너뜨립니다!',
              altText: '{home} 선수 벌처 컨트롤로 상대 벌처를 잡고 탱크로 밀어냅니다!',
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
              text: '{away} 선수 측면 포격! 시야가 끊긴 상대 탱크를 직격합니다!',
              altText: '{away} 선수 포격으로 상대 벌처를 제거! 시야 없는 탱크를 포격합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
