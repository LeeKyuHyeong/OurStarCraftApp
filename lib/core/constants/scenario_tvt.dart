part of 'scenario_scripts.dart';

// ============================================================
// TvT 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

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
          text: '{home} 선수 앞마당에 커맨드 센터를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 빠른 앞마당! 확장을 가져가겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 팩토리 건설! 가스를 넣습니다.',
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
      recoveryResourcePerLine: 12,
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
          awayArmy: 2, favorsStat: 'control',
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
              text: '{home}, 벌처로 상대 SCV 라인을 괴롭힙니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '벌처 싸움에서 크게 밀리는 순간 패배와 직결! 테테전의 핵심!',
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
              text: '{away}, 마인 매설로 맵 컨트롤을 가져갑니다!',
              owner: LogOwner.away,
              awayResource: -10, favorsStat: 'strategy',
              altText: '{away} 선수 마인 매설! 상대 이동 경로를 차단!',
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
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 시작! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나옵니다! 시즈 모드 연구 중!',
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
          text: '{home} 선수 스타포트 건설! 드랍십을 노립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 견제를 노리는 건가요?',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십이 나옵니다! 상대 후방을 노릴 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗도 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 생산 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보! 시즈 탱크 거리재기! 상대는 암흑 시야인데 우리 탱크가 먼저 때립니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'strategy+scout',
          altText: '{home}, 시야 싸움에서 앞섭니다! 상대 탱크가 안 보이는 사이 선제 포격!',
          skipChance: 0.4,
        ),
        ScriptEvent(
          text: '탱크+골리앗+드랍십! 후반 집중력 싸움이 시작됩니다!',
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
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 확장기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지가 박살나고 있습니다! 병력을 돌려야 해요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 상대 확장기지를 타격하면서 자기 확장기지는 방어! 멀티포인트 공격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드랍+정면 동시 공격! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '상대 확장기지 타격 + 자기 확장기지 방어! 승리로 직결됩니다!',
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
              text: '{away} 선수 탱크+골리앗 라인을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'attack',
              altText: '{away}, 탱크 골리앗 전진! 라인을 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away}, 시즈 포격! 유지하던 라인을 파괴합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 밀립니다! 병력이 괴멸하고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '라인을 파괴하며 병력을 괴멸! 승리로 직결됩니다!',
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
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 집중력 싸움!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 탱크 골리앗 벌처 총출동! 마지막 결전!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력 결집! 최종 교전!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗 라인이 정면 충돌합니다! 집중력 싸움!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -12, homeArmy: -8, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 포화! 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: -6, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 화력으로 맞섭니다!',
        ),
        ScriptEvent(
          text: '결정적인 순간입니다!',
          owner: LogOwner.system,
          decisive: true,
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 2. BBS vs 노배럭 더블 (초반 공격)
// ----------------------------------------------------------
const _tvtBbsVsDouble = ScenarioScript(
  id: 'tvt_bbs_vs_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_cc_first', 'tvt_1fac_expand'],
  description: 'BBS 센터 배럭 vs 노배럭 더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-7)
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
          text: '{away} 선수 앞마당에 커맨드 센터를 먼저 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노배럭 더블! 배럭 없이 커맨드 먼저 짓습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 배럭! 공격적인 빌드입니다!',
        ),
        ScriptEvent(
          text: '빌드가 극과극으로 나뉘었는데요! {away} 선수가 피해 없이 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, BBS 확정! 센터 마린3, 본진 마린2를 모읍니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 센터배럭 마린 3기, 본진배럭 마린 2기 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 11-14)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 5기에 본진 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 마린+SCV 전진! 상대 앞마당에 벙커를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭이 완성됩니다! 마린 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2,
          altText: '{away}, 마린 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home}, 상대 앞마당에 벙커 건설 시작!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 벙커 올립니다! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '벙커링이 시작됐습니다! 마린이 벙커에 들어가기 전에 끊을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: SCV 컨트롤로 마린 끊기 - 분기 (lines 17+)
    // 수비쪽 defense+control이 높으면 마린을 끊어냄
    ScriptPhase(
      name: 'marine_cut',
      startLine: 17,
      branches: [
        // 분기 A: 수비쪽 SCV가 마린을 끊어냄 → 벙커에 마린 못 들어감
        ScriptBranch(
          id: 'scv_cuts_marines',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV를 뭉쳐서 마린을 끊습니다! 벙커에 마린이 못 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense+control',
              altText: '{away}, SCV 컨트롤! 마린이 벙커에 못 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 줄어들고 있습니다! BBS가 흔들립니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원 손실이 크겠는데요.',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드를 지켜냅니다! 앞마당이 가동됩니다!',
              owner: LogOwner.away,
              awayResource: -5,
            ),
          ],
        ),
        // 분기 B: 마린이 벙커에 들어감 → 벙커 완성
        // 배럭 없이 CC부터 올린 상대, 벙커에 취약
        ScriptBranch(
          id: 'bunker_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV로 막으려 하지만 벙커를 건설하는 SCV를 제거하지 못합니다!',
              owner: LogOwner.away,
              favorsStat: 'attack+control',
            ),
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린으로 벙커를 공격합니다! 하지만 쉽지 않습니다!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, SCV 수리까지! {away} 선수 벙커를 못 부수고 있습니다!',
              owner: LogOwner.home,
              awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 상대방 앞마당 커맨드를 끝내 파괴시킵니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 3. 투스타 레이스 vs 배럭 더블 (공중 견제)
// ----------------------------------------------------------
const _tvtWraithVsRaxDouble = ScenarioScript(
  id: 'tvt_wraith_vs_rax_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_wraith_cloak', 'tvt_1fac_push'],
  awayBuildIds: ['tvt_cc_first', 'tvt_2fac_vulture', 'tvt_1fac_expand'],
  description: '투스타 레이스/드랍 vs 배럭 더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
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
          text: '{home} 선수 팩토리 건설! 빠른 테크!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드 센터 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 생산하면서 벙커를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산! 2번째 스타포트도 올립니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -25,
          altText: '{home}, 레이스가 나옵니다! 스타포트가 하나 더!',
        ),
        ScriptEvent(
          text: '투스타포트! 레이스를 대량으로 뽑겠다는 의도!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 초반 레이스 견제 - 디텍 SCV 방해 (lines 12-15)
    ScriptPhase(
      name: 'early_wraith_harass',
      startLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 레이스가 상대 본진으로! SCV를 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 레이스 출격! 상대 SCV를 공격합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설하려는데 레이스가 방해합니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 디텍 올리는 SCV를 집요하게 쫓습니다!',
          owner: LogOwner.home,
          favorsStat: 'harass', awayArmy: -1,
          altText: '{home} 선수 아머리 SCV를 노립니다! 디텍을 막으려는 의도!',
        ),
        ScriptEvent(
          text: '클로킹이 완성되기 전에 디텍을 올려야 하는데요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 클로킹 완성 + 3기 침투 - 분기 (lines 18+)
    ScriptPhase(
      name: 'cloak_infiltrate',
      startLine: 18,
      branches: [
        // 분기 A: 디텍 준비 안 됨 → SCV 학살
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스 3기가 침투합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -3, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 스캔! 하지만 이미 SCV 피해가 큽니다!',
              owner: LogOwner.away,
              awayResource: -10, awayArmy: -2,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home}, 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -3, favorsStat: 'harass',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 치명적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗 나오기 전에 밀어붙입니다! 패배 직결!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 본진+앞마당 분산 건설 → 골리앗/스캔으로 대응
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away} 선수 아머리를 본진과 앞마당에 나눠 짓습니다! 레이스를 피합니다!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 분산 건설! 아머리를 나눠서 짓습니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗 생산 시작! 레이스를 격추합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2,
              altText: '{away} 선수 골리앗! 레이스를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 하지만 골리앗이 대기 중!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 레이스를 잡아냅니다! 하지만 SCV 피해가 좀 있습니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '레이스 견제가 막혔습니다! 하지만 투스타 측은 드랍십이 빠릅니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 - 분기 (lines 26+)
    // 대학살은 Phase 2에서 decisive로 종료되므로 방어 성공 시만 도달
    ScriptPhase(
      name: 'post_defense',
      startLine: 26,
      branches: [
        // 분기 A: SCV 피해를 상당히 줌 + 드랍십 전환
        ScriptBranch(
          id: 'good_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십 전환! 투스타포트의 장점이 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십으로 전환! 투스타의 이점!',
            ),
            ScriptEvent(
              text: '{home}, 드랍십으로 뒤쪽 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 미네랄 라인을 노립니다!',
            ),
            ScriptEvent(
              text: 'SCV 피해 + 드랍 견제! 레이스 측이 주도권을 잡고 있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 피해 적음 → 배럭더블 운영 우위
        ScriptBranch(
          id: 'minimal_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 앞마당이 풀가동! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'macro',
              altText: '{away} 선수 앞마당 풀가동! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상병력이 부족합니다! 레이스 투자 회수가 안 됩니다!',
              owner: LogOwner.home,
              homeArmy: -3, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 물량으로 압도! 따라잡기 힘듭니다!',
              owner: LogOwner.away,
              decisive: true,
              skipChance: 0.65,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 4. 5팩 타이밍 vs 마인 트리플 (타이밍 공격)
// ----------------------------------------------------------
const _tvt5facVsMineTriple = ScenarioScript(
  id: 'tvt_5fac_vs_mine_triple',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac', 'tvt_1fac_push'],
  awayBuildIds: ['tvt_1fac_expand', 'tvt_cc_first'],
  description: '5팩 타이밍 vs 마인 트리플 공수 대결',
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
          text: '{home} 선수 팩토리를 빠르게 증설합니다! 3개째!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 팩토리가 빠르게 늘어납니다! 타이밍을 노리나요?',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 앞마당 확장도 가져갑니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리가 올라갑니다! 확장도 같이!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 마인 매설! 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 시작! 팩토리 5개 체제! 탱크 벌처 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -30,
          altText: '{home}, 시즈 모드 연구와 5팩토리 풀가동! 병력이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드 센터! 마인으로 시간을 벌면서!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 트리플 확장! 자원을 최대한 끌어올립니다!',
        ),
      ],
    ),
    // Phase 1: 5팩 타이밍 (lines 17-26)
    ScriptPhase(
      name: 'timing_push',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 5팩토리 물량이 전진합니다! 탱크 8기!',
          owner: LogOwner.home,
          homeArmy: 5, favorsStat: 'attack',
          altText: '{home} 선수 대규모 전진! 탱크 라인이 밀려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 지대에서 수비 준비! 탱크도 배치!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보! 상대 탱크 위치를 먼저 파악합니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'strategy+scout',
          altText: '{home}, 시즈 탱크 거리재기! 시야 싸움에서 앞서갑니다!',
          skipChance: 0.4,
        ),
        ScriptEvent(
          text: '5팩 타이밍 vs 마인 트리플! 공수 대결의 시작!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 교전 - 분기 (lines 27-42)
    ScriptPhase(
      name: 'clash',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'timing_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 진입! 5팩 물량으로 밀어냅니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5팩 타이밍이 마인 수비를 뚫었습니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'mine_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인에 벌처가 터집니다! 진격이 멈추는데요!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 벌처가 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실! 마인 지대를 뚫기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리 건설! 골리앗을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 트리플 확장으로 역전 준비! 탱크+골리앗이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: 20,
            ),
            ScriptEvent(
              text: '마인 수비 성공! 자원 차이로 역전을 노립니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 5. BBS vs 테크 빌드 (팩토리 유닛 전 공격)
// ----------------------------------------------------------
const _tvtBbsVsTech = ScenarioScript(
  id: 'tvt_bbs_vs_tech',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_wraith_cloak', 'tvt_2fac_vulture', 'tvt_5fac', 'tvt_1fac_push'],
  description: 'BBS vs 테크 빌드 (팩토리 유닛 전 공격)',
  phases: [
    // Phase 0: 오프닝 (lines 1-6)
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
          text: '{away} 선수 배럭 건설, 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 배럭! 공격적인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 테크를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, BBS 확정! 마린을 모읍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: BBS 돌진 (lines 10-12)
    ScriptPhase(
      name: 'bbs_rush',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 3기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 마린+SCV 돌진! 빠른 공격!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 첫 유닛이 나오고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 상대 진지에 벙커 건설 시도!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 벙커를 올립니다!',
        ),
      ],
    ),
    // Phase 2: 결과 분기 (lines 15+)
    ScriptPhase(
      name: 'rush_result',
      startLine: 15,
      branches: [
        // 분기 A: 팩토리 유닛 방어 성공
        ScriptBranch(
          id: 'tech_defends',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 팩토리 유닛이 가동됩니다! 마린을 상대합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 팩토리 유닛으로 마린 격퇴!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 팩토리 유닛을 못 뚫어요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 추가 유닛까지 생산! 벌처가 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2,
              altText: '{away} 선수 벌처 합류! BBS를 완전히 막아냅니다!',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{away}, 테크 우위를 살려 병력을 늘립니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10,
              altText: '{away} 선수 병력 추가!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: 'BBS가 막혔습니다! 테크 차이가 결정적입니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: BBS가 테크 전에 압도
        ScriptBranch(
          id: 'bbs_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 화력 집중!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린밖에 없습니다! 팩토리 유닛이 너무 늦어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 마린으로 밀어붙입니다! SCV 수리까지!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 마린 화력! {away} 선수가 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 대응이 늦었습니다! 테크 투자가 발목을 잡네요.',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: 'BBS가 테크를 앞질렀습니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 6. 공격적 빌드 대결 (타이밍 싸움)
// ----------------------------------------------------------
const _tvtAggressiveMirror = ScenarioScript(
  id: 'tvt_aggressive_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_push', 'tvt_5fac'],
  awayBuildIds: ['tvt_wraith_cloak', 'tvt_2fac_vulture'],
  description: '공격적 빌드 대결 타이밍 싸움',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
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
          text: '{home} 선수 팩토리 건설! 공격적인 운영!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 테크 경쟁입니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 유닛 생산! 양쪽 다 공격적입니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '양측 다 확장 없이 병력에 집중하고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 준비 (lines 12-18)
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설! 물량을 늘립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 팩토리 추가! 물량 싸움을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 병력 증강! 시즈 탱크도 합류!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 아머리도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 시즈 연구와 아머리! 후반 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 맞대응! 벌처 컨트롤 대결!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보! 시즈 탱크 거리재기! 상대는 암흑 시야인데 우리 탱크가 먼저 때립니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'strategy+scout',
          altText: '{home}, 시야 싸움에서 앞섭니다! 선제 포격!',
          skipChance: 0.4,
        ),
        ScriptEvent(
          text: '공격적인 빌드 대결! 먼저 밀리면 끝입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 타이밍 교전 - 분기 (lines 22+)
    ScriptPhase(
      name: 'timing_clash',
      startLine: 22,
      branches: [
        // 분기 A: 홈 타이밍 성공
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 탱크+골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '타이밍 공격 성공! 병력 차이가 벌어집니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 역습 성공
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 병력이 더 빠르게 모입니다! 역습!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 역습! 상대 탱크 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 탱크+골리앗으로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '역습 성공! 생산력 차이로 결정됩니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 7. 배럭 더블 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvtCcFirstVs1facExpand = ScenarioScript(
  id: 'tvt_cc_first_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_cc_first'],
  awayBuildIds: ['tvt_1fac_expand'],
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
          text: '{home} 선수 앞마당에 커맨드 센터를 올립니다!',
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
          text: '{away} 선수 앞마당에 커맨드 센터! 원팩 확장입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 원팩으로 확장까지! 수비적인 운영!',
        ),
      ],
    ),
    // Phase 1: 초반 마린 벌처 압박 (lines 15-24)
    ScriptPhase(
      name: 'early_pressure',
      startLine: 15,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린+벌처로 상대 앞마당을 정찰합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'harass',
          altText: '{home}, 마린 벌처 전진! 상대 빌드를 확인합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 매설 완료! 벙커도 건설합니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -15,
          altText: '{away}, 마인+벙커! 수비를 단단히 합니다!',
        ),
        ScriptEvent(
          text: '{home}, 벌처로 견제! SCV 라인을 노리는데요!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 벌처 기동! 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인에 벌처가 걸립니다! 하지만 {home} 선수 피해도 줍니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '배럭 더블의 조기 압박 vs 원팩 확장의 수비! 구도가 나왔습니다!',
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
              awayResource: -20, favorsStat: 'control+harass',
              altText: '{home} 선수 벌처 컨트롤! 상대 앞마당 SCV 피해!',
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 가동이 늦어집니다! 확장 이득을 못 보고 있어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 시즈 탱크 생산 시작! 앞마당 이득을 살려 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home} 선수 탱크 합류! 압박이 강해집니다!',
            ),
            ScriptEvent(
              text: '압박이 효과를 봤습니다! 확장 투자를 회수하지 못하면 치명적!',
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
              text: '{away}, 마인+벙커로 견제를 막아냅니다! 앞마당이 안정됩니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 벌처 견제를 무력화!',
            ),
            ScriptEvent(
              text: '{away} 선수 세 번째 커맨드 센터! 트리플 확장입니다!',
              owner: LogOwner.away,
              awayResource: -30,
              altText: '{away}, 트리플! 자원 우위를 끌어올립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 실패했습니다! 상대 확장이 늘어나는데요!',
              owner: LogOwner.home,
              homeResource: -10,
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
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
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
          text: '{home} 선수 스타포트 건설! 드랍십을 노립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트! 드랍십으로 견제를 노리는 건가요?',
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
              text: '{home}, 드랍십에 탱크를 싣고 상대 후방을 공격합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 확장기지가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 후방이 뚫립니다! 병력을 돌려야 해요!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 정면 탱크 라인도 전진! 드랍+정면 동시 공격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 멀티포인트 공격! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '드랍 견제+정면 밀기! 주도권을 잡았습니다!',
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
              text: '{away}, 트리플 확장의 자원 우위! 병력이 빠르게 늘어납니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이! 자원 우위가 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인을 유지하지만 물량 차이가 있습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 골리앗+탱크 대군으로 역습! 숫자가 다릅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 물량으로 역공! 상대 라인이 밀립니다!',
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
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 마지막 결전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력! 라인을 형성합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗 라인이 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 라인을 뚫습니다!',
          owner: LogOwner.home,
          awayArmy: -12, homeArmy: -8, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력 집중! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 화력! 반격에 나섭니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: -6, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 화력으로 맞섭니다!',
        ),
        ScriptEvent(
          text: '결정적인 순간입니다!',
          owner: LogOwner.system,
          decisive: true,
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 8. 투팩 벌처 vs 원팩 확장 (밸런스 vs 수비적)
// ----------------------------------------------------------
const _tvtTwofacVs1facExpand = ScenarioScript(
  id: 'tvt_2fac_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2fac_vulture'],
  awayBuildIds: ['tvt_1fac_expand'],
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
          text: '{away} 선수 앞마당 커맨드 센터! 원팩으로 확장을 가져갑니다!',
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
      recoveryResourcePerLine: 12,
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
          altText: '{away}, 마인+벙커! 벌처 견제에 대비합니다!',
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
              text: '{home}, 벌처가 마인을 피해 돌아서 SCV 라인에 침투합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass+control',
              altText: '{home} 선수 벌처 우회 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 앞마당 가동이 흔들립니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 추가 벌처까지 합류! 상대 일꾼 라인을 계속 괴롭힙니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'harass',
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
              awayResource: -25,
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
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
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
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 뒤쪽을 기습!',
            ),
            ScriptEvent(
              text: '{away} 선수 후방 피해! 골리앗을 돌리지만 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 탱크 라인을 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드랍+정면 동시 공격! 상대가 흔들립니다!',
            ),
            ScriptEvent(
              text: '견제+정면 동시 공격! 수비가 갈립니다!',
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
              awayArmy: 5, favorsStat: 'macro',
              altText: '{away} 선수 자원 우위! 병력이 빠르게 늘어납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 투팩 체제로는 물량을 따라잡기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크+골리앗 대군으로 역공! 숫자로 압도!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
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
          text: '{home} 선수 탱크+골리앗 총동원! 마지막 전투를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력 배치! 정면 교전 준비!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -12, homeArmy: -8, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -10, awayArmy: -6, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 맞섭니다!',
        ),
        ScriptEvent(
          text: '결정적인 순간입니다!',
          owner: LogOwner.system,
          decisive: true,
        ),
      ],
    ),
  ],
);
