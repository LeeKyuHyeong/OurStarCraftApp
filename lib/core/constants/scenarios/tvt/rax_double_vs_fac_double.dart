part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 1. 배럭 더블 vs 팩토리 더블 (가장 대표적인 TvT)
// ----------------------------------------------------------
const _tvtRaxDoubleVsFacDouble = ScenarioScript(
  id: 'tvt_rax_double_vs_fac_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_cc_first'],
  awayBuildIds: ['tvt_2fac_vulture'],
  description: '배럭 더블 vs 팩토리 더블 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{home} 선수 마린을 뽑으면서 SCV 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeResource: -3,
          altText: '{home}, SCV 정찰! 상대 빌드를 확인합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 빠른 앞마당! 확장을 가져가겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다. 머신샵도 바로 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 빠른 테크!',
        ),
        ScriptEvent(
          text: '{home} 선수도 팩토리 건설! 머신샵 부착합니다.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 첫 벌처가 나옵니다!',
        ),
      ],
    ),
    // Phase 1: 벌처 싸움 (lines 17-28)
    ScriptPhase(
      name: 'vulture_battle',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 벌처가 상대 앞마당을 정찰합니다! SCV를 노리는데요!',
          owner: LogOwner.away,
          favorsStat: 'harass',
          altText: '{away} 선수 벌처 기동! 앞마당 SCV를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벙커 건설로 앞마당을 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 앞마당에 벙커! 벌처를 막아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 벌처 생산! 벌처 속업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 벌처 나옵니다! 속업까지!',
        ),
        ScriptEvent(
          text: '{away}, 벌처 속업 완료! 속도가 빠릅니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'control',
          altText: '{away} 선수 벌처 속업! 기동력이 올라갑니다!',
        ),
        ScriptEvent(
          text: '양측 벌처가 센터에서 마주칩니다! 벌처 싸움의 시작!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벌처 교전 결과 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'vulture_clash',
      startLine: 29,
      branches: [
        // 분기 A: 홈 벌처 우세
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 컨트롤이 좋습니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 벌처를 격파!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 피해가 큽니다! 시즈 탱크를 기다려야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 벌처로 상대 SCV를 괴롭힙니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '벌처 싸움에서 크게 밀리는 순간 패배와 직결! 컨트롤에 신경써야 합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 벌처 우세
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벌처 컨트롤! 속도 차이로 상대 벌처를 따라잡습니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 벌처가 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처를 잃고 후퇴! 앞마당 벙커에 의지합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 벌처로 상대 SCV를 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 벌처 견제! 상대 일꾼을 공격!',
            ),
            ScriptEvent(
              text: '벌처 싸움에서 크게 밀리면 패배 직결! 벌처 컨트롤이 테테전의 메인 이벤트!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 대치 (lines 43-58)
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 43,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구 시작!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 머신샵에서 시즈 연구! 탱크가 본격 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착! 탱크 생산 시작!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크! 라인을 유지하면서 배치합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '양측 시즈 탱크 배치 완료! 라인 대치가 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 업그레이드를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트 건설 후 컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗도 준비합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 생산 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 견제를 노리는 건가요?',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십이 나옵니다! 상대 후방을 노릴 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 시야 확보! 상대 드랍 경로를 감시합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 시야 싸움! 벌처로 드랍을 경계합니다!',
          skipChance: 0.4,
        ),
        ScriptEvent(
          text: '탱크, 골리앗, 드랍십! 후반 집중력 싸움이 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 드랍 + 후반 전환 - 분기 (lines 59-74)
    ScriptPhase(
      name: 'drop_transition',
      startLine: 59,
      branches: [
        // 분기 A: 드랍 성공
        ScriptBranch(
          id: 'drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십 출격! 상대 확장기지에 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 확장기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지가 박살나고 있습니다! 병력을 돌려야 해요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 상대 확장기지를 타격하면서 정면 전진! 멀티포인트 공격!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시 공격! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '상대 확장기지 타격 + 정면 전진! 승리로 직결됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 정면 돌파
        ScriptBranch(
          id: 'frontal_break',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 라인을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -15, favorsStat: 'attack',
              altText: '{away}, 탱크 골리앗 전진! 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 포격! 유지하던 라인을 파괴합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 밀립니다! 병력이 피해를 받고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '라인을 파괴하며 전진! 승리로 직결됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 75-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 75,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원! 집중력 싸움!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 탱크 골리앗 벌처 총출동! 마지막 결전!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력 결집! 최종 교전!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗 라인이 정면 충돌합니다! 집중력 싸움!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 포화! 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 화력으로 맞섭니다!',
        ),
      ],
    ),
    // Phase 6: 결전 판정 - 분기 (lines 86+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 86,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수가 결정적인 한 방을 날립니다!',
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
              text: '{away} 선수가 결정적인 한 방을 날립니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

