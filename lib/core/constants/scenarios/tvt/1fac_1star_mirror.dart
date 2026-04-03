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
    // Phase 0: 오프닝 (lines 1-11)
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
          text: '{home} 선수 가스 채취! 팩토리 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취! 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리! 원팩원스타 미러가 예상됩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 원팩원스타!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 원팩원스타 미러 확정!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타포트! 양쪽 원팩원스타 미러입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '원팩원스타 미러! 벌처 교전부터 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 벌처 교전 (lines 12-21)
    ScriptPhase(
      name: 'vulture_skirmish',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 벌처로 센터를 장악합니다! 마인 매설!',
          owner: LogOwner.home,
          favorsStat: 'control', homeResource: -5,
          altText: '{home} 선수 벌처 기동! 마인을 깝니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 맞대응! 마인 매설 경쟁!',
          owner: LogOwner.away,
          favorsStat: 'control', awayResource: -5,
          altText: '{away}, 마인 매설! 양쪽 마인밭입니다!',
        ),
        ScriptEvent(
          text: '{home}, 벌처 교전! 컨트롤 대결!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 벌처 컨트롤! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 반격! 마인에 걸립니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
          altText: '{away}, 상대 벌처도 마인에 걸립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산! 시즈 모드 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산! 시즈 연구!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '벌처전이 끝나고 탱크 대치로 전환됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 탱크 대치 - 분기 (lines 22-37)
    ScriptPhase(
      name: 'tank_standoff',
      startLine: 22,
      branches: [
        // 분기 A: 홈 탱크 우위
        ScriptBranch(
          id: 'home_tank_advantage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 시야로 상대 탱크 위치를 포착! 선제 포격!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'scout+attack',
              altText: '{home} 선수 시야 싸움에서 앞섭니다! 탱크 직격!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 시야가 안 잡힌 사이 맞았습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크 차이를 살려 라인을 밀어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 라인 전진! 상대를 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '탱크 수 차이! 시즈 화력에서 밀리면 뒤집기 어렵습니다!',
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
              text: '{away}, 벌처 시야 확보! 상대 탱크를 먼저 포착합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'scout+attack',
              altText: '{away} 선수 시야 싸움 승리! 상대 탱크를 직격!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 잃습니다! 화력 열세!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 차이로 라인을 밀어갑니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 라인 전진! 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '탱크 수 차이가 결정적! 라인이 밀립니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드랍전 (lines 38-54)
    ScriptPhase(
      name: 'drop_war',
      startLine: 38,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 상대 후방을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십 출격! 멀티 견제!',
        ),
        ScriptEvent(
          text: '{away} 선수도 드랍십! 양쪽 드랍 견제전!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 드랍십 출격! 양쪽 드랍전입니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크를 실어서 상대 확장기지에 내립니다!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'strategy',
          altText: '{home} 선수 탱크 드랍! 상대 SCV가 위험합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 드랍! 상대 본진을 공격!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'strategy',
          altText: '{away}, 탱크 드랍! 양쪽 후방이 불탑니다!',
        ),
        ScriptEvent(
          text: '양쪽 드랍 견제전! 먼저 유의미한 피해를 주는 쪽이 유리합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산 준비!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리! 골리앗으로 대공 화력!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 총동원! 최종 교전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력! 정면 충돌!',
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
          awayArmy: -5, homeArmy: -5, favorsStat: 'control',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'control',
          altText: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 66+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 66,
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

