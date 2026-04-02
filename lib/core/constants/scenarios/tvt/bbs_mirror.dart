part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 10. BBS 미러 (치즈 미러)
// ----------------------------------------------------------
const _tvtBbsMirror = ScenarioScript(
  id: 'tvt_bbs_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_bbs'],
  description: 'BBS 미러 센터 배럭 치즈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-9)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수도 SCV를 센터로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설! 본진에도 배럭!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 센터와 본진 배럭! BBS입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 센터에 배럭! 본진 배럭도 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 센터 배럭! BBS! 양쪽 다 BBS입니다!',
        ),
        ScriptEvent(
          text: '양쪽 BBS! 센터 배럭 치즈 미러가 나왔습니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작! 센터 마린 3기를 빠르게 모읍니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수도 마린 생산! 센터에서 마린 집결!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -5,
        ),
      ],
    ),
    // Phase 1: 마린과 SCV 전진 (lines 10-17)
    ScriptPhase(
      name: 'marine_clash',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린과 SCV를 뭉쳐서 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -5, favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 전진! 센터를 장악하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 마린과 SCV 전진! 센터에서 마주칩니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -5, favorsStat: 'attack',
          altText: '{away}, 마린과 SCV 맞전진! 정면 충돌!',
        ),
        ScriptEvent(
          text: '센터에서 마린과 SCV 대결! 누가 먼저 벙커를 올리느냐!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 벙커 건설 시도! SCV가 짓기 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15, favorsStat: 'control',
          altText: '{home} 선수 벙커 건설! 마린을 넣을 수 있을까요?',
        ),
        ScriptEvent(
          text: '{away} 선수도 벙커 건설 시도! 양쪽 벙커 경쟁!',
          owner: LogOwner.away,
          awayResource: -15, favorsStat: 'control',
          altText: '{away}, 벙커 건설! 양쪽 벙커가 동시에 올라갑니다!',
        ),
      ],
    ),
    // Phase 2: 벙커 전쟁 - 분기 (lines 18-27)
    ScriptPhase(
      name: 'bunker_war',
      startLine: 18,
      branches: [
        // 분기 A: 홈 벙커 선점
        ScriptBranch(
          id: 'home_bunker_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 먼저 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'control',
              altText: '{home} 선수 벙커 선점! 마린이 투입됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커가 아직 짓는 중! 마린으로 공격하지만 벙커 화력이 세요!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1,
              altText: '{away}, 벙커 완성이 늦습니다! 마린이 녹고 있어요!',
            ),
            ScriptEvent(
              text: '{home}, SCV 수리! 벙커가 안 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커 선점 차이! 먼저 완성한 쪽이 크게 유리합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 벙커 선점
        ScriptBranch(
          id: 'away_bunker_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 먼저 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'control',
              altText: '{away} 선수 벙커 선점! 마린 투입!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 늦습니다! 마린이 상대 벙커에 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -1,
              altText: '{home}, 벙커 완성이 늦어서 마린 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away}, SCV 수리까지! 벙커를 지켜냅니다!',
              owner: LogOwner.away,
              homeArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커 선점! 한 발 빠른 완성이 승부를 결정합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 양쪽 벙커 교착
        ScriptBranch(
          id: 'both_bunkers',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 벙커가 거의 동시에 완성됩니다! 교착 상태!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 추가 마린으로 상대 벙커를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 추가 마린 투입! 상대 벙커를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 추가 마린! SCV로 벙커를 수리합니다!',
              owner: LogOwner.away,
              awayArmy: 1, homeArmy: -1, favorsStat: 'defense',
              altText: '{away}, 마린과 SCV로 버팁니다!',
            ),
            ScriptEvent(
              text: '양쪽 벙커 교착! 후반전으로 넘어갑니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반전 - 팩토리 전환 (lines 28-40)
    ScriptPhase(
      name: 'aftermath',
      startLine: 28,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 가스를 넣고 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다! 벌처로 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 벌처 생산 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리! 벌처로 판을 뒤집으려 합니다!',
        ),
        ScriptEvent(
          text: '{home}, 벌처 생산 시작! 센터에서 벌처 교전!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'control',
          altText: '{home} 선수 벌처 출격! 기동전으로 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 맞대응! 마인 매설도 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home}, 탱크 생산! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home} 선수 탱크가 나옵니다! 시즈 연구!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 생산! 시즈 모드!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '양측 탱크가 충돌합니다! 최종 교전!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크를 직격!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 벌처로 우회! 탱크 포격에 맞섭니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 벌처 우회 공격! 반격!',
        ),
      ],
    ),
    // Phase 4: 결전 판정 - 분기 (lines 41+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 41,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 센터 벙커전 승리! 마린 컨트롤 차이가 결정적입니다!',
              altText: '{home} 선수 추가 마린이 합류하며 상대 벙커를 무너뜨립니다!',
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
              text: '{away} 선수 센터 벙커전 승리! 마린 수싸움에서 앞섭니다!',
              altText: '{away} 선수 SCV 수리 타이밍이 적절했습니다! 벙커를 사수합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

