part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 15. 투팩벌처 미러 (벌처 컨트롤 대결)
// ----------------------------------------------------------
const _tvt2facPushMirror = ScenarioScript(
  id: 'tvt_2fac_push_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_push'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '투팩 벌처 같은 빌드 컨트롤 대결',
  phases: [
    // ── Phase 0: 오프닝 (배럭, 가스, 팩토리x2, 속업) ──
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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수도 배럭을 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취 후 팩토리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          fixedCost: true,
          altText: '{home} 선수 가스와 팩토리. 빠른 메카닉입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취, 팩토리 건설.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 가스와 팩토리를 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리 건설. 벌처 속업 연구.',
          owner: LogOwner.home,
          homeResource: -500, // 팩토리(300) + 벌처 속업(200)
          fixedCost: true,
          altText: '{home} 선수 투팩. 벌처 대량 생산 체제.',
        ),
        ScriptEvent(
          text: '{away} 선수도 두 번째 팩토리. 벌처 속업 연구 시작.',
          owner: LogOwner.away,
          awayResource: -500,
          fixedCost: true,
          altText: '{away} 선수도 투팩 같은 빌드. 속업 타이밍 싸움입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작. 2기씩 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -150, // 벌처 2기 (75x2, 2sup x2=4)
          fixedCost: true,
          altText: '{home} 선수 벌처 양산. 팩토리 두 개가 풀가동입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산. 양측 벌처가 쏟아집니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150,
          fixedCost: true,
          altText: '{away} 선수도 벌처 양산. 속업 타이밍이 관건입니다.',
        ),
        ScriptEvent(
          text: '투팩 벌처 같은 빌드! 속업 타이밍과 컨트롤이 승부를 결정합니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '양측 투팩 같은 빌드. 확장 없이 벌처 싸움부터 가겠다는 거죠.',
        ),
        ScriptEvent(
          text: '투팩은 벌처가 빠른 대신 확장이 늦습니다. 벌처전에서 밀리면 치명적이에요.',
          owner: LogOwner.system,
          skipChance: 0.6,
          altText: '속업이 먼저 끝나는 쪽이 주도권을 잡습니다.',
        ),
      ],
    ),
    // ── Phase 1: 벌처 센터 장악 + 마인 플레이 ──
    ScriptPhase(
      name: 'vulture_center',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 4기로 센터 진출. 마인을 깔면서 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -150, // 벌처 2기 추가 (75x2)
          fixedCost: true,
          favorsStat: 'strategy',
          altText: '{home} 선수 벌처 4기 센터 장악. 마인 매설.',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 4기로 맞대응. 마인을 피하면서 기동합니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -150,
          fixedCost: true,
          favorsStat: 'control',
          altText: '{away} 선수 벌처 4기. 마인을 피해 우회 기동.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 상대 앞마당 SCV를 노립니다. 견제 시도.',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 SCV 견제! 상대 앞마당 침투!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 상대 앞마당을 벌처로 찌릅니다. 맞견제.',
          owner: LogOwner.away,
          favorsStat: 'harass',
          altText: '{away} 선수 맞견제. 벌처로 상대 일꾼을 노립니다.',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 벌처가 교차하며 견제전! 컨트롤이 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
          altText: '투팩 같은 빌드의 꽃, 벌처 교차 견제전입니다.',
        ),
        // 마인 플레이
        ScriptEvent(
          text: '{home} 선수 마인을 상대 이동 경로에 심어둡니다. 나중에 탱크가 밟으면 큰일입니다.',
          owner: LogOwner.home,
          favorsStat: 'strategy',
          skipChance: 0.4,
          altText: '{home} 선수 마인 매설. 탱크 전환 이후를 노리는 포석입니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 마인으로 응수. 양측 맵 곳곳에 마인이 깔립니다.',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          skipChance: 0.4,
          altText: '{away} 선수도 마인 매설. 서로 이동 경로를 제한합니다.',
        ),
        ScriptEvent(
          text: '마인 싸움이 치열합니다. 탱크가 나오면 마인 위치가 승부를 가릅니다.',
          owner: LogOwner.system,
          skipChance: 0.5,
          altText: '마인은 벌처는 못 잡지만, 탱크와 골리앗에게는 치명적이죠.',
        ),
      ],
    ),
    // ── Phase 2: 벌처 교전 결과 - 분기 ──
    ScriptPhase(
      name: 'vulture_clash',
      startLine: 28,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 홈 벌처 우세
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벌처 컨트롤이 한 수 위입니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, // 벌처 2기 vs 1기 교환
              favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 벌처 격파!',
            ),
            ScriptEvent(
              text: '{home} 선수 마인 매설로 맵 전체를 장악합니다.',
              owner: LogOwner.home,
              favorsStat: 'strategy',
              altText: '{home} 선수 마인 매설. 맵 컨트롤을 가져갑니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 앞마당 SCV에 피해를 입힙니다.',
              owner: LogOwner.home,
              awayResource: -250, // SCV 견제 피해
              favorsStat: 'harass',
              altText: '{home} 선수 SCV 견제 성공! 일꾼을 솎아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 손실이 큽니다. 빨리 수습해야 합니다.',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '벌처 싸움에서 밀리면 맵 컨트롤과 일꾼을 동시에 잃습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '투팩 같은 빌드에서 벌처전 열세는 곧바로 자원 열세로 이어집니다.',
            ),
            // 근거리 맵: 벌처 견제 도착 빨라서 추가 피해
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
              text: '{away} 선수 속업 타이밍이 더 빠릅니다! 상대 벌처를 따라잡아 격파!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 속업 차이! 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 앞마당으로 침투! SCV를 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -250,
              favorsStat: 'harass',
              altText: '{away} 선수 앞마당 침투! SCV 대량 학살!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처를 잃고 앞마당 SCV까지 피해! 상당히 밀립니다.',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 마인 매설로 맵 장악. 상대 이동을 봉쇄합니다.',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 마인으로 맵 봉쇄! 상대가 갇혔습니다.',
            ),
            ScriptEvent(
              text: '벌처 컨트롤 차이가 게임을 결정짓고 있습니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처전에서 밀리면 확장도 못 가고 갇히게 됩니다.',
            ),
            // 근거리 맵: 벌처 견제 도착 빨라서 추가 피해
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
              text: '벌처에 SCV를 너무 많이 잃었습니다! 회복이 불가능합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 견제가 치명적입니다! 상대가 버틸 수 없습니다!',
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
              text: '벌처에 SCV를 너무 많이 잃었습니다! 회복이 불가능합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 견제가 치명적입니다! 상대가 버틸 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 벌처 난동이 계속됩니다! SCV가 일할 수 없습니다!',
            ),
          ],
        ),
        // 교착
        ScriptBranch(
          id: 'vulture_stalemate',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 벌처가 비등합니다. 서로 마인만 깔고 물러납니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '벌처전 교착. 양측 마인을 깔며 견제합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 상대 앞마당을 찔러봅니다.',
              owner: LogOwner.home,
              awayResource: -100,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 견제. SCV 몇 기를 잡습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처로 반대편을 찌릅니다.',
              owner: LogOwner.away,
              homeResource: -100,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{away} 선수도 벌처 견제. 서로 SCV를 교환합니다.',
            ),
            ScriptEvent(
              text: '투팩 같은 빌드 교착. 탱크 전환 타이밍이 관건입니다.',
              owner: LogOwner.system,
              skipChance: 0.5,
              altText: '벌처전이 비등하면 탱크를 먼저 내는 쪽이 유리합니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 탱크 전환 ──
    ScriptPhase(
      name: 'tank_transition',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작. 시즈 모드 연구.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -550, // 시즈탱크(250/2sup) + 시즈모드 연구(300)
          fixedCost: true,
          altText: '{home} 선수 탱크로 전환. 시즈 연구 중.',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 전환. 시즈 모드 연구.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          altText: '{away} 선수도 시즈 탱크 생산. 양측 탱크 싸움.',
        ),
        ScriptEvent(
          text: '양측 탱크가 나오기 시작합니다. 확장 타이밍이 관건입니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '탱크 전환과 확장, 어느 쪽을 먼저 가느냐가 승부입니다.',
        ),
      ],
    ),
    // ── Phase 4: 확장 타이밍 분기 ──
    // 미러전이라도 확장 타이밍에 차이가 생길 수 있음
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 46,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // ── 동시 확장: 양측 비슷한 타이밍에 앞마당 ──
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 앞마당 확장. 벌처전이 정리되니 확장을 갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당을 확장합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수도 앞마당 커맨드. 자원 싸움입니다.',
            ),
            ScriptEvent(
              text: '양측 비슷한 타이밍에 확장을 갔습니다. 탱크 수 싸움으로 넘어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '동시 확장. 자원이 비등하니 컨트롤이 승부를 가릅니다.',
            ),
            // 벌처 견제
            ScriptEvent(
              text: '{home} 선수 벌처를 보내 상대 확장을 견제합니다. SCV를 괴롭힙니다.',
              owner: LogOwner.home,
              awayResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{home} 선수 벌처 견제. 상대 앞마당 SCV를 잡습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 벌처 견제. 상대 확장 SCV를 노립니다.',
              owner: LogOwner.away,
              homeResource: -150,
              favorsStat: 'harass',
              skipChance: 0.4,
              altText: '{away} 선수 벌처로 상대 앞마당을 찌릅니다.',
            ),
          ],
        ),
        // ── 홈 빠른 확장: 일찍 확장하지만 어웨이가 병력 우위로 공격 ──
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크보다 확장을 먼저 올립니다! 위험하지만 자원을 확보하려 합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 빠른 앞마당! 병력이 얇아지지만 자원을 확보합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 대신 탱크를 추가 생산합니다! 병력 차이를 만듭니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 확장을 미루고 탱크와 벌처를 더 뽑습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 확장 타이밍을 노립니다! 탱크와 벌처로 전진!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 병력 우위로 밀어붙입니다! 확장에 투자한 자원이 아깝습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장을 갔지만 병력이 부족합니다! 수비가 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 확장 비용만큼 병력이 모자랍니다!',
            ),
            ScriptEvent(
              text: '빠른 확장의 대가! 병력이 얇은 틈을 찔립니다!',
              owner: LogOwner.system,
              altText: '확장을 서두른 대가가 크네요. 병력 차이가 벌어집니다.',
            ),
          ],
        ),
        // ── 어웨이 빠른 확장: 일찍 확장하지만 홈이 병력 우위로 공격 ──
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크보다 확장을 먼저 선택합니다! 자원 확보를 서두릅니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 빠른 앞마당! 위험하지만 장기전을 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 대신 탱크를 추가합니다! 병력 우위를 만듭니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -250,
              fixedCost: true,
              altText: '{home} 선수 확장을 미루고 병력을 더 뽑습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대가 확장에 자원을 쓴 틈! 탱크와 벌처로 전진!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -200,
              favorsStat: 'attack',
              altText: '{home} 선수 병력 우위로 밀어붙입니다! 확장 직후 약한 틈!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장은 올렸지만 병력이 부족합니다! 수비가 위험합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 확장 비용만큼 병력이 모자랍니다!',
            ),
            ScriptEvent(
              text: '빠른 확장의 대가! 병력이 얇은 틈을 찔립니다!',
              owner: LogOwner.system,
              altText: '확장을 서두른 대가가 크네요. 병력 차이가 벌어집니다.',
            ),
          ],
        ),
        // ── 홈 확장 스킵 공격: 확장 안 하고 병력으로 상대 확장 파괴 → 조기 종료 ──
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 확장을 안 갑니다! 탱크와 벌처를 계속 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -500,
              fixedCost: true,
              altText: '{home} 선수 확장 포기! 올인 병력 생산!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당을 확장합니다. 상대가 확장을 안 간 걸 모릅니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              altText: '{away} 선수 앞마당 확장. 아직 상대 빌드를 모르고 있습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처 물량으로 상대 앞마당을 급습합니다!',
              owner: LogOwner.home,
              awayArmy: -6, awayResource: -300,
              favorsStat: 'attack',
              altText: '{home} 선수 확장 포기한 만큼의 병력! 앞마당을 밀어버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 압도적으로 부족합니다! 확장에 자원을 쏟아서 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 확장 비용이 발목을 잡습니다! 탱크가 너무 적습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 포기 올인! 상대 앞마당이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 병력 차이가 압도적입니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
        // ── 어웨이 확장 스킵 공격: 확장 안 하고 올인 ──
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 확장을 안 갑니다! 탱크와 벌처를 계속 뽑습니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -500,
              fixedCost: true,
              altText: '{away} 선수 확장 포기! 올인 병력 생산!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당을 확장합니다. 상대 빌드를 아직 확인 못 했습니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 앞마당 커맨드. 상대가 확장을 안 간 걸 모릅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크와 벌처 물량으로 상대 앞마당을 급습합니다!',
              owner: LogOwner.away,
              homeArmy: -6, homeResource: -300,
              favorsStat: 'attack',
              altText: '{away} 선수 확장 포기한 만큼의 병력! 앞마당을 밀어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력이 압도적으로 부족합니다! 확장에 자원을 써서 탱크가 모자랍니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 확장 비용이 발목을 잡습니다! 수비가 불가능합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 포기 올인! 상대 앞마당이 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 병력 차이가 압도적입니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 시즈 모드 완료 + 거리재기 ──
    ScriptPhase(
      name: 'siege_mode',
      startLine: 52,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 완료. 탱크가 자리를 잡습니다.',
          owner: LogOwner.home,
          altText: '{home} 선수 시즈 모드 완료. 센터에 라인을 긋습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 완료. 양측 탱크 라인이 형성됩니다.',
          owner: LogOwner.away,
          altText: '{away} 선수도 시즈 라인. 센터에서 거리재기가 시작됩니다.',
        ),
        ScriptEvent(
          text: '시즈 모드가 완료됐습니다. 거리재기 시작입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '테테전의 꽃, 시즈 탱크 라인 긋기 싸움입니다.',
        ),
        // 거리재기
        ScriptEvent(
          text: '{home} 선수 벌처로 시야를 밝히고 시즈 포격! 상대 탱크가 맞습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.4,
          altText: '{home} 선수 벌처 시야 확보 후 시즈 포격! 상대 탱크를 깎습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크를 전진시켜 사거리를 잡습니다. 포격! {home} 탱크가 터집니다!',
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
          altText: '{home} 선수 벌처가 상대 라인 뒤쪽으로 침투합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 상대 라인 뒤를 찌릅니다. SCV를 잡습니다.',
          owner: LogOwner.away,
          homeResource: -150,
          favorsStat: 'harass',
          skipChance: 0.5,
          altText: '{away} 선수 벌처 침투. 상대 후방 SCV에 피해를 줍니다.',
        ),
        ScriptEvent(
          text: '사거리 싸움이 치열합니다. 탱크 한 대 차이가 승부를 가릅니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '먼저 자리 잡는 쪽이 센터의 주인입니다.',
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '언덕 위 시즈모드. 테테전에서 가장 무서운 지형지물이죠.',
          owner: LogOwner.system,
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
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
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
          altText: '{away} 선수 고지대 시즈로 응수! 서로 고지를 점령합니다.',
        ),
        // 근거리 맵: 시즈 거리재기가 더 치열
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
          text: '원거리 맵이라 멀티 확장이 안전합니다. 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 5: 탱크 라인 압도 → 조기 종료 가능 ──
    ScriptPhase(
      name: 'siege_dominance',
      startLine: 62,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 시즈 거리재기에서 큰 차이 없이 계속 진행
        ScriptBranch(
          id: 'siege_continues',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '양측 탱크 라인이 팽팽합니다. 골리앗 전환으로 넘어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '시즈 대치가 이어집니다. 다음 테크가 관건입니다.',
            ),
          ],
        ),
        // 홈 탱크 라인 압도 → 밀어붙여서 끝냄
        ScriptBranch(
          id: 'home_siege_crush',
          baseProbability: 0.5,
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
              text: '탱크 라인에서 밀리면 회복이 안 됩니다!',
              owner: LogOwner.system,
              altText: '조이기 라인이 풀리지 않습니다. 서서히 말라 죽어가네요.',
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
          baseProbability: 0.5,
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
              altText: '압도적인 화력! 이건 컨트롤로 극복이 안 됩니다.',
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
    // ── Phase 6: 아머리 + 골리앗 전환 ──
    ScriptPhase(
      name: 'siege_goliath',
      startLine: 68,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설. 골리앗 생산을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -300, // 아머리(150) + 골리앗(150)
          homeArmy: 2,
          fixedCost: true,
          altText: '{home} 선수 아머리를 올리고 골리앗으로 전환합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리. 골리앗 체제로 넘어갑니다.',
          owner: LogOwner.away,
          awayResource: -300,
          awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수도 골리앗 생산. 화력이 두꺼워집니다.',
        ),
        ScriptEvent(
          text: '시즈 탱크에 골리앗이 합류하면서 정면 화력이 올라갑니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '인구수가 올라갑니다. 곧 한 방이 터질 수 있습니다.',
        ),
        // 거리재기 - 골리앗 합류 후
        ScriptEvent(
          text: '{home} 선수 탱크 한 칸 전진. 시즈 포격! 상대 골리앗이 맞습니다!',
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
        // 트리플 확장
        ScriptEvent(
          text: '{home} 선수 세 번째 확장을 올립니다. 자원을 확보하려 합니다.',
          owner: LogOwner.home,
          homeResource: -400,
          fixedCost: true,
          altText: '{home} 선수 트리플 커맨드. 자원 라인을 늘립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 확장 타이밍을 노립니다! 병력이 빠진 틈을 찌릅니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'sense',
          skipChance: 0.5,
          altText: '{away} 선수 확장 직후를 노린 포격! 병력이 얇은 틈!',
        ),
        ScriptEvent(
          text: '{away} 선수도 세 번째 확장을 올립니다.',
          owner: LogOwner.away,
          awayResource: -400,
          fixedCost: true,
          altText: '{away} 선수도 트리플. 자원을 확보합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 확장 타이밍에 벌처를 보냅니다! SCV 견제!',
          owner: LogOwner.home,
          awayResource: -150,
          favorsStat: 'sense',
          skipChance: 0.5,
          altText: '{home} 선수 확장 틈을 노린 견제! SCV를 잡습니다!',
        ),
        // 팩토리 추가
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설. 병력 보충이 빨라집니다.',
          owner: LogOwner.home,
          homeResource: -300,
          fixedCost: true,
          skipChance: 0.4,
          altText: '{home} 선수 팩토리 추가. 물량이 더 빨리 늘어납니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 추가 팩토리 건설.',
          owner: LogOwner.away,
          awayResource: -300,
          fixedCost: true,
          skipChance: 0.4,
          altText: '{away} 선수도 팩토리 추가. 생산을 맞춥니다.',
        ),
      ],
    ),
    // ── Phase 7: 풀 메카닉 (스타포트 + 드랍십) ──
    ScriptPhase(
      name: 'full_mech',
      startLine: 82,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설. 드랍십을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -250, // 스타포트 250
          fixedCost: true,
          altText: '{home} 선수 스타포트를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트를 올립니다.',
          owner: LogOwner.away,
          awayResource: -250,
          fixedCost: true,
          altText: '{away} 선수도 스타포트 건설. 드랍 준비입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산. 벌처로 시야를 확보하면서 타이밍을 재고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -200,
          fixedCost: true,
          altText: '{home} 선수 드랍십 완성. 출격 시점을 노리고 있습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수도 드랍십 생산. 골리앗을 대공 위치에 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -200,
          fixedCost: true,
          altText: '{away} 선수도 드랍십. 양측 풀 메카닉 체제입니다.',
        ),
        ScriptEvent(
          text: '시즈탱크, 골리앗, 드랍십. 풀 메카닉 체제입니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
          altText: '양측 풀 메카닉. 드랍이냐 정면이냐가 관건입니다.',
        ),
        ScriptEvent(
          text: '골리앗 비율을 높여서 드랍십을 원천 봉쇄합니다.',
          owner: LogOwner.system,
          skipChance: 0.6,
          altText: '팩토리가 쉴 새 없이 돌아갑니다. 물량전 예고입니다.',
        ),
        // 공중 개방 맵: 드랍 경로가 다양해서 드랍 위협 증가
        ScriptEvent(
          text: '공중이 열린 맵입니다. 드랍 경로가 다양해서 골리앗 배치가 어렵습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'airHigh',
        ),
        // 원거리 맵: 드랍 이동 시간이 길어서 탐지 가능
        ScriptEvent(
          text: '원거리 맵이라 드랍십 이동이 오래 걸립니다. 정찰할 시간이 있습니다.',
          owner: LogOwner.system,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 9: 드랍 운영 + 교전 - 분기 ──
    // 드랍은 항상 올인이 아님: 게릴라 견제 / 유리한 쪽 마무리 / 불리한 쪽 역전 / 정면
    ScriptPhase(
      name: 'drop_warfare',
      startLine: 94,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // ── 게릴라 드랍 (홈): 확장 견제 후 회수, 자잘한 피해 ──
        ScriptBranch(
          id: 'home_guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크 한 대를 싣고 상대 확장기지로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격. 상대 확장을 견제합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크를 내리고 SCV를 잡습니다! 바로 회수!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 확장 드랍 성공! SCV 피해를 주고 빠집니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗을 돌렸지만 이미 드랍십이 빠져나갑니다.',
              owner: LogOwner.away,
              altText: '{away} 선수 수비를 왔지만 드랍십은 이미 회수 완료.',
            ),
            ScriptEvent(
              text: '게릴라 드랍! 큰 피해는 아니지만 상대 시선을 분산시킵니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍 견제로 상대 병력이 분산됩니다. 정면이 얇아지는 틈!',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍으로 시선을 끈 사이 정면 탱크를 한 칸 전진시킵니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{home} 선수 드랍 타이밍에 맞춰 거리재기! 상대 탱크를 잡습니다!',
            ),
            // 공중 개방 맵: 드랍 경로가 다양
            ScriptEvent(
              text: '공중이 열린 맵이라 드랍 경로를 바꿔가며 계속 견제합니다.',
              owner: LogOwner.system,
              requiresMapTag: 'airHigh',
              skipChance: 0.5,
            ),
          ],
        ),
        // ── 게릴라 드랍 (어웨이): 확장 견제 후 회수 ──
        ScriptBranch(
          id: 'away_guerrilla_drop',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십에 탱크를 싣고 상대 트리플 확장으로 향합니다.',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍십 출격. 상대 확장을 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지에 탱크를 내려 SCV를 태웁니다! 빠르게 회수!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 확장 드랍! SCV를 잡고 바로 탈출합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 뒤늦게 도착합니다. 이미 피해는 입었습니다.',
              owner: LogOwner.home,
              altText: '{home} 선수 수비했지만 SCV 몇 기는 이미 잃었습니다.',
            ),
            ScriptEvent(
              text: '자잘한 드랍 견제가 쌓이면 자원 차이로 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '게릴라 운영! 드랍으로 상대 자원을 조금씩 깎아냅니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍으로 시선을 끈 사이 정면에서 탱크 포격!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'sense',
              skipChance: 0.4,
              altText: '{away} 선수 드랍 타이밍에 거리재기! 상대 탱크를 깎습니다!',
            ),
            // 공중 개방 맵
            ScriptEvent(
              text: '공중이 열린 맵이라 드랍 경로가 다양합니다. 수비가 어렵습니다.',
              owner: LogOwner.system,
              requiresMapTag: 'airHigh',
              skipChance: 0.5,
            ),
          ],
        ),
        // ── 마무리 드랍 (홈 유리): 유리한 쪽이 드랍과 정면 동시로 끝냄 ──
        ScriptBranch(
          id: 'home_finishing_drop',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 앞서고 있습니다. 드랍십으로 확실하게 끝내려 합니다.',
              owner: LogOwner.system,
              altText: '{home} 선수 병력 우위! 드랍과 정면 동시 공격을 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격! 상대 본진과 확장에 동시 투하!',
              owner: LogOwner.home,
              awayResource: -300, awayArmy: -2,
              favorsStat: 'strategy',
              altText: '{home} 선수 멀티 드랍! 본진과 확장을 동시에 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 정면 탱크 라인도 전진! 수비할 곳이 세 군데입니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시! 상대가 수비를 나눠야 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력을 나눠야 합니다! 어디를 먼저 막을지 결정해야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away} 선수 수비 분산! 모든 곳을 막을 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 멀티 포인트 공격으로 상대를 완전히 무너뜨립니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 드랍과 정면 동시 공격! 수비가 붕괴됩니다!',
            ),
          ],
        ),
        // ── 마무리 드랍 (어웨이 유리): 유리한 쪽이 드랍과 정면 동시로 끝냄 ──
        ScriptBranch(
          id: 'away_finishing_drop',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 정면에서 앞서고 있습니다. 드랍으로 마무리하려 합니다.',
              owner: LogOwner.system,
              altText: '{away} 선수 병력 우위! 드랍과 정면을 동시에 준비합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대 출격! 본진과 확장을 동시에 타격!',
              owner: LogOwner.away,
              homeResource: -300, homeArmy: -2,
              favorsStat: 'strategy',
              altText: '{away} 선수 멀티 드랍! 상대 후방을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 정면에서도 탱크 라인을 밀어붙입니다! 세 방향 공격!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 드랍과 정면 동시! 상대가 갈립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비를 나눠야 하지만 병력이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 모든 곳을 막기 어렵습니다! 수비가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 멀티 포인트 공격! 상대가 완전히 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 드랍과 정면 동시 공격으로 경기를 끝냅니다!',
            ),
          ],
        ),
        // ── 정면 교전: 드랍 없이 라인 싸움 ──
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
              altText: '탱크 일점사! 상대 탱크 숫자 줄이는 데 집중합니다.',
            ),
          ],
        ),
        // ── 역전 드랍 (홈 불리): 올인 본진 드랍 ──
        ScriptBranch(
          id: 'home_desperate_drop',
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
              text: '대역전극! 불리하던 경기를 드랍쉽 한 방으로 뒤집습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '드랍쉽 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
        // ── 역전 드랍 (어웨이 불리): 올인 본진 드랍 ──
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
              altText: '드랍쉽 한 대의 기적! 본진 팩토리 라인이 마비됐습니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 9: 결전 ──
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 108,
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
          text: '{away} 선수도 탱크 위치를 조정합니다. 포격! {home} 탱크가 터집니다!',
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
          altText: '모든 병력 쏟아붓습니다! 마지막 결전이에요.',
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
      startLine: 122,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크와 벌처로 상대 라인을 돌파합니다! {away} 선수 앞마당에서 본진까지 밀립니다!',
              altText: '{home} 선수 마인 활용이 적절합니다! 상대 탱크를 잡아냅니다!',
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
              text: '{away} 선수 탱크와 벌처로 수비 라인 돌파! {home} 선수 앞마당에서 본진까지 밀립니다!',
              altText: '{away} 선수 마인 매설로 맵을 장악! 상대 이동을 봉쇄합니다.',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
