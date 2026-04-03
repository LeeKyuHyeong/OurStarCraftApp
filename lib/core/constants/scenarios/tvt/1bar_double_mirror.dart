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
    // Phase 0: 오프닝 (lines 1-13)
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
          text: '{home} 선수 마린을 뽑으면서 앞마당 커맨드센터를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 커맨드! 배럭 더블입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터! 미러 오프닝!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 같은 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 가스를 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! SCV 정찰을 보냅니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리! SCV로 상대 타이밍을 확인!',
        ),
        ScriptEvent(
          text: '양측 배럭 더블! 가장 대표적인 테테전 전개입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 벌처 싸움 (lines 14-25)
    ScriptPhase(
      name: 'vulture_battle',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작! 센터로 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 첫 벌처가 센터로!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산! 맞붙을 준비!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 배럭을 앞마당 앞에 떨어뜨립니다! 상대 빌드 정찰!',
          owner: LogOwner.home,
          favorsStat: 'scout',
          altText: '{home}, 배럭 플로팅! 상대 진영을 정찰합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 속업 연구 시작!',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          altText: '{away}, 벌처 속업! 기동력을 높입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 벌처 속업! 타이밍 경쟁입니다!',
          owner: LogOwner.home,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양측 벌처가 센터에서 마주칩니다! 벌처 싸움의 시작!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벌처 교전 결과 - 분기 (lines 26-39)
    ScriptPhase(
      name: 'vulture_result',
      startLine: 26,
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
              text: '{home}, 마인 매설로 맵 컨트롤! 상대 이동을 제한합니다!',
              owner: LogOwner.home,
              homeResource: -10, favorsStat: 'strategy',
              altText: '{home} 선수 마인 매설! 상대 벌처 이동 경로를 차단!',
            ),
            ScriptEvent(
              text: '{home}, 벌처로 상대 앞마당 SCV를 괴롭힙니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 벌처 견제! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '벌처 싸움에서 밀리면 맵 컨트롤을 잃습니다! 집중해야 할 순간이네요!',
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
              text: '{away}, 빠른 속업으로 상대 벌처를 따라잡습니다! 벌처 격파!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 속업 타이밍! 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 마인 매설로 맵 컨트롤! 상대 이동을 제한합니다!',
              owner: LogOwner.away,
              awayResource: -10, favorsStat: 'strategy',
              altText: '{away} 선수 마인 매설! 상대 벌처 이동 경로를 차단!',
            ),
            ScriptEvent(
              text: '{away}, 상대 앞마당으로 침투합니다! SCV 견제!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 벌처 침투! SCV를 솎아냅니다!',
            ),
            ScriptEvent(
              text: '벌처 컨트롤에서 밀린 쪽이 SCV 피해! 자원 격차가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 교착
        ScriptBranch(
          id: 'vulture_stalemate',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 벌처가 비등합니다! 서로 마인만 깔고 물러납니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크로 전환합니다! 벌처전은 무승부!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
              altText: '{home}, 탱크로 전환! 라인 대치를 준비합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 탱크 전환! 양쪽 마인밭 사이로 라인이 형성됩니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -15,
            ),
            ScriptEvent(
              text: '벌처전 무승부! 시즈 탱크 대치로 넘어갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 대치 (lines 40-54)
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 40,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산! 시즈 모드 연구 완료!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나옵니다! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 탱크 배치! 시즈 모드 연구 완료! 라인 대치가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 드랍!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗 생산 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 아머리! 골리앗으로 전환합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 벌처로 시야를 확보하면서 드랍 타이밍을 재고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십이 나옵니다! 상대 후방을 노리나?',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 골리앗도 생산!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 스타포트에 골리앗! 후반 교전 준비!',
        ),
        ScriptEvent(
          text: '탱크, 골리앗, 드랍십! 시야 싸움과 견제가 동시에 진행됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 드랍 전쟁 - 분기 (lines 55-71)
    ScriptPhase(
      name: 'drop_war',
      startLine: 55,
      branches: [
        // 분기 A: 홈 드랍 성공
        ScriptBranch(
          id: 'home_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십 출격! 상대 확장기지에 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 확장기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지 SCV가 큰 피해! 병력을 돌려야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 탱크 라인을 전진시킵니다! 멀티포인트 공격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드랍과 정면 동시 공격! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '드랍과 정면 동시 공격! 수비가 분산됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 드랍 성공
        ScriptBranch(
          id: 'away_drop_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드랍십으로 상대 본진을 기습합니다! 탱크 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 본진 드랍! 생산시설이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 생산시설이 위협받고 있습니다! 탱크를 돌려야!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 상대가 흔들리는 사이 정면 탱크 라인도 전진!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 견제와 정면 동시! 상대가 갈립니다!',
            ),
            ScriptEvent(
              text: '본진 견제 성공! 생산력에 타격이 갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 정면 교전
        ScriptBranch(
          id: 'frontal_clash',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 드랍을 경계하며 골리앗을 배치합니다! 드랍 없이 정면 승부!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 탱크 라인을 밀어올립니다! 시즈 재배치!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 전진! 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗 화력으로 맞섭니다! 정면 교전!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'attack',
              altText: '{away} 선수 골리앗으로 정면 대응! 화력전!',
            ),
            ScriptEvent(
              text: '정면 탱크 골리앗 라인전! 시즈 포격 범위가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 72-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 72,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원! 최종 결전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 승부!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력 배치! 결전입니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전 병력이 정면 충돌합니다! 집중력 싸움!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격 집중! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 반격! 끝까지 맞섭니다!',
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

