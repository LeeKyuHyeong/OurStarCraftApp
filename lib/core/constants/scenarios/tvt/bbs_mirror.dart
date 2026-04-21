part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS 미러 (치즈 미러)
// 양쪽 센터 2배럭 → 마린 SCV 컨트롤 싸움
// BBS 미러는 벙커를 짓기 애매 (서로 정찰로 확인됨)
// 순수 마린+SCV 교전으로 승부가 결정됨
// ----------------------------------------------------------
const _tvtBbsMirror = ScenarioScript(
  id: 'tvt_bbs_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_bbs'],
  description: 'BBS 마린 SCV 컨트롤전',
  phases: [
    // Phase 0: 오프닝 (lines 1-9) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 SCV가 센터로 향합니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '양 선수 SCV를 센터로 보냅니다. 센터 배럭을 노립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설. {away} 선수도 센터 배럭을 올립니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: -150, // 센터 배럭
          awayResource: -150,
          altText: '양쪽 센터에 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 두 번째 배럭을 올립니다. {away} 선수도 센터에 두 번째 배럭.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: -150, // 센터 두 번째 배럭
          awayResource: -150,
          altText: '양쪽 센터에 두 번째 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV 정찰이 센터에서 상대 배럭 두 개를 확인합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 센터를 지나가다 상대 배럭 두 개를 발견합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 정찰 SCV로 확인합니다. 상대도 배럭 두 개!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{away} 선수도 상대 빌드를 확인합니다. 서로 같은 빌드네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린 3기 생산. {away} 선수 배럭에서도 마린 3기.',
          owner: LogOwner.system,
          homeArmy: 3, homeResource: -150, // 마린 3기 (50x3)
          awayArmy: 3, awayResource: -150,
          altText: '양쪽 배럭에서 마린이 쏟아집니다! 센터에서 곧 마주칩니다!',
        ),
      ],
    ),
    // Phase 1: 마린 SCV 전진 + 초기 교전 (lines 10-17) - recovery 100/줄
    ScriptPhase(
      name: 'marine_scv_clash',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린과 SCV를 뭉쳐서 전진! {away} 선수도 전진! 센터에서 마주칩니다!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -100, // 마린 2기 추가 (50x2)
          awayArmy: 2, awayResource: -100,
          altText: '양쪽 마린과 SCV가 센터에서 정면으로 부딪칩니다!',
        ),
        ScriptEvent(
          text: '서로 같은 빌드를 확인한 상황! 벙커를 지을 틈이 없습니다! 순수 마린 싸움!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '양쪽 다 마린에 올인한 상황이라 벙커를 세울 여유가 없습니다! 마린 컨트롤이 전부!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 흩뿌리면서 상대 마린을 집중 사격합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -1,
          skipChance: 0.4,
          altText: '{home} 선수 마린 분산! 상대 마린에 화력을 집중합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 앞세워 마린을 보호합니다! 체력 방패 역할!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -1,
          skipChance: 0.4,
          altText: '{away} 선수 SCV 벽! 마린이 안전하게 사격합니다!',
        ),
        ScriptEvent(
          text: '추가 마린이 합류합니다! 양쪽 마린 수가 계속 늘어나고 있어요!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -100,
          awayArmy: 2, awayResource: -100,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 마린 SCV 컨트롤 결과 - 분기 (lines 18-30) - recovery 100/줄
    ScriptPhase(
      name: 'control_battle',
      branches: [
        // 분기 A: 홈 마린 컨트롤 우세
        ScriptBranch(
          id: 'home_marine_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 컨트롤이 한 수 위입니다! 상대 마린을 집중 사격!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,
              altText: '{home} 선수 마린 분산이 좋습니다! 피해를 줄이면서 상대를 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 줄어듭니다! SCV로 버텨보지만 밀리고 있어요!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
              altText: '{away} 선수 마린 수가 부족합니다! 전선이 밀립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV로 수리하면서 마린을 유지합니다! 상대 쪽이 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -1,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '마린 컨트롤 차이! 한 기 한 기가 승부를 가릅니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.4,
              altText: '이런 빌드에서는 마린 한 기 차이가 곧 승패입니다!',
            ),
          ],
        ),
        // 분기 B: 어웨이 마린 컨트롤 우세
        ScriptBranch(
          id: 'away_marine_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린 컨트롤이 좋습니다! 상대 마린을 하나씩 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
              altText: '{away} 선수 마린 집중 사격! 상대 마린이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 줄고 있습니다! SCV로 막아보지만 역부족!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{home} 선수 마린 수가 모자랍니다! 전선이 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV로 체력 방패를 만들면서 마린을 살립니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -1,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '마린 컨트롤 차이가 벌어지고 있습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.4,
              altText: 'SCV와 마린의 합이 승부를 가릅니다!',
            ),
          ],
        ),
        // 분기 C: 홈 SCV 활용 우세 (SCV 수리+벽)
        ScriptBranch(
          id: 'home_scv_play',
          baseProbability: 0.8,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV를 앞세워 상대 마린 사격을 흡수합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
              altText: '{home} 선수 SCV 벽이 탄탄합니다! 마린이 뒤에서 안전하게 사격!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 잡으려 하지만 마린이 밀려납니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -1, awayArmy: -2,
              altText: '{away} 선수 SCV를 노리지만 마린 화력에 밀립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV 활용이 뛰어납니다! 상대 병력이 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
          ],
        ),
        // 분기 D: 어웨이 SCV 활용 우세
        ScriptBranch(
          id: 'away_scv_play',
          baseProbability: 0.8,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV를 앞세워 상대 마린 화력을 흡수합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{away} 선수 SCV 벽! 마린이 안전하게 사격을 퍼붓습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV를 뚫으려 하지만 마린 화력에 밀립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -1, homeArmy: -2,
              altText: '{home} 선수 SCV에 막혀서 마린이 제대로 사격을 못 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 운용이 압도적! 상대 병력이 무너지고 있어요!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
          ],
        ),
        // 분기 E: 교착 - 양쪽 비등
        ScriptBranch(
          id: 'marine_stalemate',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '양쪽 마린과 SCV가 치열하게 싸우지만 비등합니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '마린 교환이 계속됩니다! 누가 먼저 틸트하느냐!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 한 기를 잡지만 SCV도 잃습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -1, homeArmy: -1,
              altText: '{home} 선수 마린 교환! 양쪽 피해가 비슷합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 반격합니다! 마린 한 기를 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -1, awayArmy: -1,
              altText: '{away} 선수 맞교환! 서로 마린이 줄어듭니다!',
            ),
            ScriptEvent(
              text: '센터에서 치열한 마린전! 한 기 차이가 승부를 가릅니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 본진 침투 시도 - 분기 (lines 26-35) - recovery 100/줄
    ScriptPhase(
      name: 'base_push',
      branches: [
        // 홈이 상대 본진 쪽으로 밀어붙임
        ScriptBranch(
          id: 'home_push_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린과 SCV를 이끌고 상대 본진 방향으로 밀어갑니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -100, // 마린 추가
              altText: '{home} 선수 병력을 모아서 상대 본진으로 전진합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 입구에서 마린과 SCV로 방어합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -100,
              altText: '{away} 선수 본진 방어! SCV를 동원해서 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 SCV를 노립니다! 일꾼을 잡으면 끝입니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -200,
              altText: '{home} 선수 SCV를 향해 마린을 보냅니다! 일꾼이 죽어갑니다!',
            ),
            ScriptEvent(
              text: '본진까지 밀려들어갑니다! SCV 피해가 심각합니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
        // 어웨이가 상대 본진 쪽으로 밀어붙임
        ScriptBranch(
          id: 'away_push_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린과 SCV를 뭉쳐 상대 본진으로 밀고 갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -100,
              altText: '{away} 선수 병력을 모아 상대 본진 방향으로!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 입구에서 필사적으로 방어합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -100,
              altText: '{home} 선수 SCV까지 동원해서 방어! 마린이 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 SCV를 잡기 시작합니다! 일꾼이 줄어듭니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -200,
              altText: '{away} 선수 SCV를 노립니다! 자원 채취가 마비됩니다!',
            ),
            ScriptEvent(
              text: '본진이 뚫리고 있습니다! SCV 피해가 치명적이에요!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
        // 센터에서 계속 교전 (본진 침투까지는 안 감)
        ScriptBranch(
          id: 'center_grind',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 센터에서 계속 마린을 교환합니다! 본진까지는 못 밀어갑니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '센터에서 소모전이 이어집니다! 마린이 계속 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 추가 생산! 센터에서 밀어냅니다!',
              owner: LogOwner.home,
              awayResource: 0,
              homeArmy: 2, homeResource: -100,
              awayArmy: -2,
              altText: '{home} 선수 추가 마린이 합류! 조금씩 앞서갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 마린 추가! 밀리지 않으려 안간힘을 씁니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayArmy: 2, awayResource: -100,
              homeArmy: -2,
              altText: '{away} 선수도 추가 마린! 센터를 사수합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 판정 - 분기 (lines 32+) - recovery 100/줄
    ScriptPhase(
      name: 'decisive_outcome',
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 수에서 앞섭니다! 상대 마린이 전멸 직전!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,
              altText: '{home} 선수 마린 컨트롤 승리! 상대 병력이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 상대 SCV까지 잡아냅니다! 자원 채취가 불가능합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              skipChance: 0.3,
              altText: '{home} 선수 SCV까지 학살! 게임이 끝나가고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 컨트롤 차이가 결정적입니다!',
              altText: '{home} 선수 추가 마린이 합류하며 상대를 완전히 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린 수싸움에서 앞섭니다! 상대 마린이 녹고 있습니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
              altText: '{away} 선수 마린 컨트롤 승리! 상대 병력이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 상대 SCV까지 잡습니다! 자원이 끊깁니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -300,
              skipChance: 0.3,
              altText: '{away} 선수 SCV 학살! 생산이 마비됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 수리 타이밍이 적절했습니다! 마린 수싸움 승리!',
              altText: '{away} 선수 마린 컨트롤이 한 수 위! 완벽한 승리입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
