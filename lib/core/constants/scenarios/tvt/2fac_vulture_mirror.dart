part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 15. 투팩벌처 미러 (벌처 컨트롤 대결)
// ----------------------------------------------------------
const _tvt2facVultureMirror = ScenarioScript(
  id: 'tvt_2fac_vulture_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_vulture'],
  awayBuildIds: ['tvt_2fac_vulture'],
  description: '투팩 벌처 미러 컨트롤 대결',
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
          text: '{home} 선수 가스 채취! 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스와 팩토리! 빠른 메카닉!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취! 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 팩토리 건설! 벌처 속업 연구!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 투팩! 벌처 대량 생산 체제!',
        ),
        ScriptEvent(
          text: '{away} 선수도 두 번째 팩토리! 벌처 속업 연구 시작!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 투팩 미러! 벌처 속업 타이밍 경쟁!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작! 2기씩 뽑습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 생산! 양측 벌처가 쏟아집니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '투팩 벌처 미러! 벌처 컨트롤이 승부를 결정합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 벌처 컨트롤 대결 (lines 12-21)
    ScriptPhase(
      name: 'vulture_control',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 벌처 4기로 센터 장악! 마인을 깔면서 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'strategy',
          altText: '{home} 선수 벌처 4기 센터 진출! 마인 매설!',
        ),
        ScriptEvent(
          text: '{away}, 벌처 4기로 맞대응! 마인을 피하면서 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10, favorsStat: 'control',
          altText: '{away} 선수 벌처 4기! 마인을 피해 기동!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 상대 앞마당 SCV를 노립니다! 견제 시도!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, SCV 견제! 상대 앞마당 침투!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 상대 앞마당을 벌처로 찌릅니다! 맞견제!',
          owner: LogOwner.away,
          favorsStat: 'harass',
          altText: '{away}, 맞견제! 벌처로 상대 일꾼 라인을 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 벌처가 교차하며 견제전! 컨트롤이 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 벌처 교전 결과 - 분기 (lines 22-35)
    ScriptPhase(
      name: 'vulture_clash',
      startLine: 22,
      branches: [
        // 분기 A: 홈 벌처 컨트롤 승
        ScriptBranch(
          id: 'home_vulture_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 컨트롤이 한 수 위입니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 벌처 컨트롤 차이! 상대 벌처 격파!',
            ),
            ScriptEvent(
              text: '{home}, 마인 매설로 맵 전체를 장악합니다!',
              owner: LogOwner.home,
              homeResource: -10, favorsStat: 'strategy',
              altText: '{home} 선수 마인 매설! 맵 컨트롤을 가져갑니다!',
            ),
            ScriptEvent(
              text: '{home}, 벌처로 상대 앞마당 SCV에 피해를 입힙니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 SCV 견제 성공! 일꾼이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처 손실이 큽니다! 탱크로 빨리 전환해야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '벌처 싸움에서 밀리면 맵 컨트롤과 일꾼을 동시에 잃습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 벌처 컨트롤 승
        ScriptBranch(
          id: 'away_vulture_control',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 속업 타이밍이 더 빠릅니다! 상대 벌처를 따라잡아 격파!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 속업 차이! 상대 벌처를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 상대 앞마당으로 침투합니다! SCV 대량 학살!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 앞마당 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처를 잃고 앞마당 SCV까지 피해! 상당히 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 마인 매설로 맵 장악! 상대 이동을 봉쇄합니다!',
              owner: LogOwner.away,
              awayResource: -10, favorsStat: 'strategy',
              altText: '{away} 선수 마인으로 맵 봉쇄! 상대가 갇혔습니다!',
            ),
            ScriptEvent(
              text: '벌처 컨트롤 차이가 게임을 결정짓고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 전환 (lines 36-54)
    ScriptPhase(
      name: 'tank_transition',
      startLine: 36,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크로 전환! 시즈 연구 중!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 전환! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 아머리가 올라갑니다! 골리앗 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 골리앗이 합류합니다! 화력이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트! 드랍십으로 후방을 노린다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 드랍십 경쟁입니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '탱크, 골리앗, 드랍십! 후반 결전이 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원! 결전을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 승부!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 배치! 최종 교전 준비!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력 집중! 상대 라인이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 반격! 끝까지 싸웁니다!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 69+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 69,
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

