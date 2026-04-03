part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 8. 투팩 벌처 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvt2facPushVs1facDouble = ScenarioScript(
  id: 'tvt_2fac_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_push'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '투팩 벌처 vs 원팩 확장 밸런스전',
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
          text: '{home} 선수 가스 채취 후 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취! 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리 건설! 투팩 체제입니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 하나 더! 투팩 벌처 체제!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드센터! 원팩으로 확장을 가져갑니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 원팩 확장! 안정적인 운영을 선택합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 2기 생산 시작! 속업 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 벌처가 나옵니다! 속업 연구 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산과 마인 연구를 동시에!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 벌처 센터 장악 (lines 15-24)
    ScriptPhase(
      name: 'vulture_control',
      startLine: 15,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 벌처 속업 완료! 센터로 벌처를 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
          altText: '{home} 선수 벌처 속업! 기동력이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인을 앞마당 입구에 깝니다! 벙커도 건설!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -15,
          altText: '{away}, 마인과 벙커! 벌처 견제에 대비합니다!',
        ),
        ScriptEvent(
          text: '{home}, 투팩 벌처 4기가 센터를 장악합니다! 상대 이동 경로를 차단!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'harass',
          altText: '{home} 선수 벌처 4기! 센터 맵 컨트롤을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 생산 시작! 수비를 강화합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 시즈 탱크! 벌처 견제를 막아낼 준비!',
        ),
        ScriptEvent(
          text: '투팩 벌처의 기동력 vs 원팩 확장의 수비! 견제 싸움이 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벌처 견제 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'harass_result',
      startLine: 25,
      branches: [
        // 분기 A: 벌처 견제 대성공 → SCV 피해
        ScriptBranch(
          id: 'harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처가 마인을 피해 돌아서 SCV에 침투합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass+control',
              altText: '{home} 선수 벌처 우회 침투! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 앞마당 가동이 흔들립니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 벌처까지 합류! 상대 일꾼을 계속 괴롭힙니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -5, favorsStat: 'harass',
              altText: '{home} 선수 벌처 추가! 견제가 이어집니다!',
            ),
            ScriptEvent(
              text: '벌처 견제 대성공! SCV 피해로 자원 격차가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 마인에 벌처 피해 → 수비 안정
        ScriptBranch(
          id: 'mine_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인에 벌처가 터집니다! 투팩 벌처에 큰 피해!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 벌처가 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 손실이 큽니다! 투팩 투자가 아까운데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 확장이 안정됩니다! 트리플 확장도 노립니다!',
              owner: LogOwner.away,
              awayResource: -25, awayArmy: 2,
              altText: '{away}, 수비 성공! 세 번째 확장을 가져갑니다!',
            ),
            ScriptEvent(
              text: '마인에 벌처 궤멸! 원팩 확장 측이 안정을 찾았습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드랍십 등장 + 시즈 탱크 대치 (lines 41-54)
    ScriptPhase(
      name: 'dropship_tank',
      startLine: 41,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 드랍십!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작! 드랍용 탱크!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나옵니다! 드랍 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크 추가! 라인 대치가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 상대 후방을 노릴 준비!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십이 나옵니다!',
        ),
        ScriptEvent(
          text: '드랍십 등장! 시즈 탱크 라인 대치와 견제전이 동시에!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'late_clash',
      startLine: 55,
      branches: [
        // 분기 A: 홈 주도권 유지 + 드랍 견제
        ScriptBranch(
          id: 'home_initiative',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십으로 상대 확장기지 뒤를 공격합니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 뒤쪽을 기습!',
            ),
            ScriptEvent(
              text: '{away} 선수 후방 피해! 골리앗을 돌리지만 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -5,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 탱크 라인을 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시 공격! 상대가 흔들립니다!',
            ),
            ScriptEvent(
              text: '견제와 정면 동시 공격! 수비가 갈립니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 확장 유리 → 물량 역전
        ScriptBranch(
          id: 'away_mass_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 확장 기지들이 풀가동! 물량이 쏟아집니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 자원 우위! 병력이 빠르게 늘어납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 투팩 체제로는 물량을 따라잡기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 골리앗 대군으로 역공! 숫자로 압도!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 물량 공세! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '확장의 자원 우위가 드러납니다! 물량 차이!',
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
          text: '{home} 선수 탱크 골리앗 총동원! 마지막 전투를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력 배치! 정면 교전 준비!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
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
              text: '{home} 선수 투팩 벌처 견제 성공! 상대 일꾼을 초토화합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 벌처 물량으로 맵을 장악하며 밀어냅니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 확장 자원이 본격 가동! 물량으로 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 마인과 탱크로 벌처 견제를 막아내고 반격합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);

