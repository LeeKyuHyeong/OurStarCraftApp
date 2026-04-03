part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 배럭 더블 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvt1barDoubleVs1facDouble = ScenarioScript(
  id: 'tvt_1bar_double_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1bar_double'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '배럭 더블 vs 원팩 확장 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 빠른 앞마당! 안정적인 운영을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스 채취 시작! 팩토리 건설합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리가 올라갑니다! 원팩 체제!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산하면서 벙커를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산 시작! 마인 연구도 같이 돌립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 벌처가 나옵니다! 마인 연구 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터! 원팩 확장입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 원팩으로 확장까지! 수비적인 운영!',
        ),
      ],
    ),
    // Phase 1: 초반 벌처 교환 (lines 15-24)
    ScriptPhase(
      name: 'early_pressure',
      startLine: 15,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 벌처로 상대 앞마당을 정찰합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'harass',
          altText: '{home}, 마린 벌처 전진! 상대 빌드를 확인합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 매설 완료! 벙커도 건설합니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -15,
          altText: '{away}, 마인과 벙커! 수비를 단단히 합니다!',
        ),
        ScriptEvent(
          text: '{home}, 벌처로 견제! 일꾼을 노리는데요!',
          owner: LogOwner.home,
          awayResource: -5, favorsStat: 'harass',
          altText: '{home} 선수 벌처 기동! 일꾼을 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 마인에 벌처가 걸립니다! {home} 선수 벌처 피해!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 빌드 스타일이 극명하게 갈립니다! 이 싸움은 오래 갈 겁니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 홈 압박 성공 → 확장 피해
        ScriptBranch(
          id: 'pressure_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처가 마인을 피하면서 SCV를 잡습니다! 앞마당 가동이 늦어지고 있어요!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'control+harass',
              altText: '{home} 선수 벌처 컨트롤! 상대 앞마당 SCV 피해!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 가동이 늦어집니다! 확장 이득을 못 보고 있어요!',
              owner: LogOwner.away,
              awayResource: -5,
            ),
            ScriptEvent(
              text: '{home}, 시즈 탱크 생산 시작! 앞마당 이득을 살려 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home} 선수 탱크 합류! 압박이 강해집니다!',
            ),
            ScriptEvent(
              text: '압박이 효과를 봤습니다! 하지만 원팩 측 테크 우위가 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 수비 성공 → 트리플 확장
        ScriptBranch(
          id: 'defense_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인과 벙커로 견제를 막아냅니다! 앞마당이 안정됩니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 벌처 견제를 무력화!',
            ),
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드센터! 트리플 확장입니다!',
              owner: LogOwner.away,
              awayResource: -30, awayArmy: 2,
              altText: '{away}, 트리플! 자원 우위를 끌어올립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 실패했습니다! 상대 확장이 늘어나는데요!',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '수비 성공 후 트리플 확장! 자원 격차가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 라인 대치 (lines 41-54)
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 41,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 배치! 라인을 밀어갑니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크 라인 전진! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크 배치! 라인 대치가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗도 준비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리가 올라갑니다! 골리앗 생산 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산에 들어갑니다!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타포트! 드랍십을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '양측 시즈 탱크 대치! 라인 싸움의 시작입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'late_transition',
      startLine: 55,
      branches: [
        // 분기 A: 홈 탱크 라인 밀기 성공
        ScriptBranch(
          id: 'tank_push_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 상대 후방을 견제합니다! SCV를 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 벌처 견제! 상대 일꾼을 공격!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처를 막느라 병력이 분산됩니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 정면 탱크 라인도 전진! 압박이 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 정면 전진! 상대 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '배럭 더블의 조기 확장 이득이 나타납니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 자원 우위로 역전
        ScriptBranch(
          id: 'resource_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 확장 기지들의 자원 우위! 병력이 빠르게 늘어납니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이! 자원 우위가 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 유지하지만 물량 차이가 있습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 드랍십으로 상대 확장기지를 습격합니다!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'strategy',
              altText: '{away} 선수 탱크 드랍! 상대 후방이 위험합니다!',
            ),
            ScriptEvent(
              text: '자원 우위가 병력 차이로! 역전의 흐름입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 71-82)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 벌처 총동원! 마지막 결전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력! 라인을 형성합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗 라인이 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 라인을 뚫습니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력 집중! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 화력! 반격에 나섭니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 화력으로 맞섭니다!',
        ),
      ],
    ),
    // Phase 6: 결전 판정 - 분기 (lines 83+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 83,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 더블 자원 우위! 탱크 물량으로 상대를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 견제로 상대 확장 가동을 늦추며 승기를 잡습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 원팩 테크 우위! 탱크 시즈로 라인을 뚫습니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 확장 자원이 뒤늦게 가동되며 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);

