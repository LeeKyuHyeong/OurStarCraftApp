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
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 빠른 앞마당! 확장을 가져가겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설합니다. 머신샵도 바로 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리+머신샵! 빠른 테크!',
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
              text: '{away}, 벌처로 상대 SCV 라인을 노립니다!',
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
          altText: '{home}, 스타포트+컨트롤타워! 드랍십을 노립니다!',
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
              altText: '{home} 선수 드랍+정면 동시 공격! 수비가 갈립니다!',
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
              text: '{away} 선수 탱크+골리앗 라인을 밀어냅니다!',
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
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 올립니다!',
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
        // 분기 A: 수비쪽 SCV가 마린을 끊어냄 → BBS 방어
        ScriptBranch(
          id: 'scv_cuts_marines',
          baseProbability: 1.1,
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
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원 손실이 크겠는데요.',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드를 지켜냅니다! BBS 완전 차단!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: 10,
              altText: '{away}, 앞마당이 가동됩니다! BBS를 막아냈습니다!',
            ),
            ScriptEvent(
              text: 'BBS 방어 성공! 더블 측이 자원 우위를 확보합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 마린이 벙커에 들어감 → 벙커 완성
        ScriptBranch(
          id: 'bunker_success',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV로 막으려 하지만 벙커를 건설하는 SCV를 제거하지 못합니다!',
              owner: LogOwner.away,
              favorsStat: 'attack+control',
            ),
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린으로 벙커를 공격합니다! 하지만 쉽지 않습니다!',
              owner: LogOwner.away,
              awayArmy: -1, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, SCV 수리까지! 벙커가 버팁니다!',
              owner: LogOwner.home,
              awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 위협합니다! 커맨드에 피해가 갑니다!',
              owner: LogOwner.home,
              awayResource: -20,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 (lines 25-35)
    ScriptPhase(
      name: 'post_rush',
      startLine: 25,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리+머신샵! 탱크를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리에 머신샵! 본격적인 메카닉 체제!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산! 속업까지!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 벌처로 맵 컨트롤을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 더블 자원으로 탱크+벌처가 빠르게 모입니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'macro',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트+컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: 'BBS 이후 전환기에 접어들었습니다! 양쪽 다 테크업!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 중반 결전 - 분기 (lines 38+)
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 38,
      branches: [
        ScriptBranch(
          id: 'home_recovers',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크를 태워서 뒤로 보냅니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 뒤를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤쪽 미네랄 라인에 탱크가 내려옵니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 탱크 시즈! 양쪽에서 압박합니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 이후 완벽한 전환! 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_advantage',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 더블 자원으로 병력이 압도적! 탱크 라인이 두텁습니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이가 나기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 초반 투자가 발목을 잡네요! 물량이 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 더블의 힘! 자원 우위로 밀어냅니다!',
              owner: LogOwner.away,
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
          text: '{away} 선수 앞마당 커맨드센터 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 벌처를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 팩토리가 올라갑니다!',
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
          text: '{away} 선수 아머리 건설하려는데 공중 견제에 방해받습니다!',
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
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스 3기가 침투합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 스캔! 하지만 이미 SCV 피해가 큽니다!',
              owner: LogOwner.away,
              awayResource: -10, awayArmy: -1,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home}, 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -2, favorsStat: 'harass',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 치명적입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리를 올리려 하지만 SCV가 부족합니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
          ],
        ),
        // 분기 B: 본진+앞마당 분산 건설 → 골리앗/스캔으로 대응
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 아머리를 본진과 앞마당에 나눠 짓습니다! 공중 견제를 피합니다!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 분산 건설! 아머리를 나눠서 짓습니다!',
            ),
            ScriptEvent(
              text: '{away}, 골리앗 생산 시작! 공중 유닛을 격추합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2,
              altText: '{away} 선수 골리앗! 공중 유닛을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스 침투! 하지만 대공 화력이 대기 중!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 공중 견제를 막아냅니다! 하지만 SCV 피해가 좀 있습니다!',
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
    // Phase 3: 중반 전환 (lines 26-34)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 26,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 올립니다! 탱크 생산 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 머신샵 부착! 탱크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵 부착! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워 건설! 드랍십을 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 컨트롤타워 완성! 드랍십이 가능합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 터렛으로 공중 유닛을 대비합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 기동전을 노리는 운영!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 탱크가 모이고 있습니다! 라인 방어 태세!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 탱크 라인 구축! 수비가 단단합니다!',
        ),
        ScriptEvent(
          text: '중반 전환기! 양쪽 다 메카닉 체제에 들어갑니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 후속 전개 - 분기 (lines 36+)
    ScriptPhase(
      name: 'post_defense',
      startLine: 36,
      branches: [
        // 분기 A: 드랍 견제 성공
        ScriptBranch(
          id: 'good_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크+벌처! 뒤쪽으로 우회합니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'strategy',
              altText: '{home} 선수 드랍 출격! 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 드랍십에서 탱크를 내립니다! 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 일꾼이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤를 잡혔습니다! 터렛이 없는 곳이에요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 동시 전진! 양쪽에서 압박!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍 견제 성공! 주도권을 잡았습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 배럭더블 물량 우위
        ScriptBranch(
          id: 'minimal_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 앞마당이 풀가동! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 앞마당 풀가동! 물량이 쌓입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상병력이 부족합니다! 스타포트 투자가 무겁네요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크+골리앗 물량으로 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 탱크 시즈 포격! 라인을 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 물량으로 압도! 따라잡기 힘듭니다!',
              owner: LogOwner.away,
              decisive: true,
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
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구 시작! 팩토리 5개 체제! 탱크 벌처 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 머신샵+시즈 연구! 5팩토리 풀가동! 병력이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드센터! 마인으로 시간을 벌면서!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 트리플 확장! 자원을 최대한 끌어올립니다!',
        ),
      ],
    ),
    // Phase 1: 중반 준비 (lines 17-24)
    ScriptPhase(
      name: 'mid_preparation',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 머신샵에서 시즈 연구! 탱크가 본격 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착! 벌처 마인도 연구합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 머신샵에서 마인 연구! 수비 준비!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 생산이 시작됩니다! 팩토리 5개에서 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -30,
          altText: '{home} 선수 5팩 풀가동! 탱크가 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 장악합니다! 마인 매설!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 컨트롤타워 올립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타포트+컨트롤타워! 드랍십을 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 터렛을 올립니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 엔지니어링 베이+터렛! 드랍 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 병력이 모이고 있습니다! 곧 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아머리에서 메카닉 업그레이드!',
        ),
      ],
    ),
    // Phase 2: 5팩 타이밍 (lines 26-30)
    ScriptPhase(
      name: 'timing_push',
      startLine: 26,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 5팩토리 물량이 전진합니다! 탱크 8기!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
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
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 보내 상대 병력을 확인합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 벌처 정찰! 상대 병력을 파악합니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 포격 사거리 안에 들어왔습니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 탱크 시즈! 사거리 안에 들어왔습니다!',
        ),
        ScriptEvent(
          text: '5팩 타이밍 vs 마인 트리플! 공수 대결의 시작!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: 교전 - 분기 (lines 32+)
    ScriptPhase(
      name: 'clash',
      startLine: 32,
      branches: [
        ScriptBranch(
          id: 'timing_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 마인 지대를 정찰합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 정찰! 마인 위치를 확인합니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 탱크 라인 전진! 시즈 모드로 상대 건물까지 포격!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 상대 앞마당을 위협합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 녹고 있습니다! 탱크 물량 차이가 납니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처를 보내 역습을 시도하지만 마인에 벌처가 터집니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 진입! 5팩 물량으로 밀어냅니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
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
              text: '{home} 선수 병력 손실! 탱크도 피해를 입었습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리 건설! 골리앗을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 트리플 확장의 자원 우위! 탱크+골리앗이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 반격! 마인 수비 성공 이후 물량으로 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -3,
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
          altText: '{home} 선수 벙커를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린+SCV로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
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
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 추가 유닛까지 생산! 벌처가 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1,
              altText: '{away} 선수 벌처 합류! BBS를 완전히 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: 'BBS가 막혔습니다! 전환기에 들어갑니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: BBS가 초반 피해를 줌
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
              altText: '{home} 선수 마린 화력! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 일꾼이 많이 죽었습니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: 'BBS 공격이 큰 피해를 줬습니다! 하지만 끝나진 않았습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 24-32)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 24,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리+머신샵! 메카닉 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산 시작! BBS 이후 전환!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 탱크 체제로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크+벌처가 모입니다! 테크 빌드의 장점이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트+컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산 시작! 기동전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 1,
        ),
        ScriptEvent(
          text: '전환기에 들어갑니다! 양쪽 모두 메카닉 체제!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 중반 결전 - 분기 (lines 34+)
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 34,
      branches: [
        ScriptBranch(
          id: 'bbs_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크를 싣고 뒤쪽으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 미네랄 라인을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크를 내립니다! 뒤쪽 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 시즈! 양면 공격!',
              owner: LogOwner.home,
              homeArmy: -1, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 이후 완벽한 전환! 승리가 보입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'tech_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 테크 우위! 탱크+벌처 물량이 압도적입니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이! 테크 빌드의 힘!',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 투자가 무겁습니다! 따라잡기 힘들어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 테크 빌드의 승리! BBS를 극복했습니다!',
              owner: LogOwner.away,
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
    // Phase 1: 중반 교전 준비 (lines 12-22)
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 팩토리+머신샵 추가! 물량 싸움을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착! 시즈 모드 연구!',
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
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트+컨트롤타워! 드랍십을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 컨트롤타워 올리고 있습니다!',
          owner: LogOwner.away,
          awayResource: -25,
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
          text: '{home} 선수 드랍십 생산! 기동전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '공격적인 빌드 대결! 먼저 밀리면 끝입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+)
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      branches: [
        ScriptBranch(
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 컨트롤이 앞섭니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 벌처 싸움 승리! 맵 컨트롤!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 녹았습니다! 시야가 불리해지네요!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 센터 장악! 마인까지 깔면서!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'harass',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벌처 컨트롤이 더 좋습니다! 선제 타격!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 벌처 싸움 승리!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 피해! 맵 컨트롤을 뺏겼습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 정찰하면서 상대 움직임을 파악합니다!',
              owner: LogOwner.away,
              awayArmy: 1, favorsStat: 'scout',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 교전 (lines 32-38)
    ScriptPhase(
      name: 'tank_battle',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          altText: '{home}, 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈! 맞서는 모양새!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 뒤쪽을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 드랍 견제! 뒤를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 마인 매설! 진격로를 차단합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+)
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      branches: [
        // 분기 A: 홈 타이밍 성공
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크+골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 타이밍 공격 성공! 병력 차이가 벌어집니다!',
              owner: LogOwner.home,
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
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 역습! 상대 탱크 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크+골리앗으로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 역습 성공! 생산력 차이로 결정됩니다!',
              owner: LogOwner.away,
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
          text: '{home} 선수 마린+벌처로 상대 앞마당을 정찰합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'harass',
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
              text: '{away}, 마인+벙커로 견제를 막아냅니다! 앞마당이 안정됩니다!',
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
              altText: '{home} 선수 벌처 견제! 상대 일꾼 라인을 공격!',
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
          text: '{home} 선수 탱크+골리앗+벌처 총동원! 마지막 결전!',
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
              awayResource: -15, favorsStat: 'harass+control',
              altText: '{home} 선수 벌처 우회 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 앞마당 가동이 흔들립니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 벌처까지 합류! 상대 일꾼 라인을 계속 괴롭힙니다!',
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
              awayArmy: 4, favorsStat: 'macro',
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

// ----------------------------------------------------------
// 9. 원팩원스타 vs 5팩토리 (비대칭 공격 대결)
// ----------------------------------------------------------
const _tvt1facPushVs5fac = ScenarioScript(
  id: 'tvt_1fac_push_vs_5fac',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_push'],
  awayBuildIds: ['tvt_5fac'],
  description: '원팩원스타 소수정예 vs 5팩토리 물량 올인',
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
          text: '{home} 선수 가스 채취! 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취! 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 빠른 테크입니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 원팩원스타!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2팩... 3팩!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, 팩토리가 계속 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처+탱크 소수 생산! 시즈 모드 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 벌처와 탱크가 나옵니다! 시즈 연구까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 4팩, 5팩! 벌처+탱크 대량 생산 체제!',
          owner: LogOwner.away,
          awayResource: -40, awayArmy: 2,
          altText: '{away}, 5팩토리! 물량으로 밀어붙이겠다는 의도!',
        ),
        ScriptEvent(
          text: '원팩원스타의 기술 vs 5팩의 물량! 극과극 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 원팩 선제공격 (lines 14-21)
    ScriptPhase(
      name: 'early_clash',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 벌처+탱크 소수정예로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 소수정예 출격! 5팩이 완성되기 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아직 물량이 덜 모였습니다! 팩토리에서 유닛이 나오는 중!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈! 상대 앞마당을 포격합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 시즈 포격! 상대 병력이 나오기 전에 밀어야!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 나오면서 마인을 깝니다! 시간을 끕니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 마인으로 시간 벌기! 물량이 모이길 기다립니다!',
        ),
        ScriptEvent(
          text: '5팩 물량이 도착하기 전에 끝내야 합니다! 시간이 없어요!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 선제공격 결과 - 분기 (lines 22-34)
    ScriptPhase(
      name: 'clash_result',
      startLine: 22,
      branches: [
        // 분기 A: 원팩 선제 성공 - 드랍+정면 돌파
        ScriptBranch(
          id: 'push_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처+탱크로 상대 팩토리 라인을 향해 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 정면 돌파! 상대 생산시설을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리가 파괴됩니다! 생산력이 줄어들고 있어요!',
              owner: LogOwner.away,
              awayResource: -20, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드랍십으로 후방 기습! 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십 출격! 상대 후방이 불바다!',
            ),
            ScriptEvent(
              text: '정면+후방 동시 공격! 5팩의 생산력을 꺾었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 5팩 물량 도달 - 숫자로 압도
        ScriptBranch(
          id: 'mass_arrives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 5팩토리에서 탱크+벌처가 쏟아집니다! 물량이 도착했습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25, favorsStat: 'macro',
              altText: '{away} 선수 물량 폭발! 5팩의 위력이 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 소수정예로는 숫자를 감당할 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 탱크+벌처 대군으로 역공! 숫자가 힘!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 물량 공세! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '5팩 물량 앞에 소수정예가 한계를 드러냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반전 (lines 35-54)
    ScriptPhase(
      name: 'late_fight',
      startLine: 35,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 생산! 공중에서 견제를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 레이스 출격! 드랍+레이스 투트랙 견제!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗으로 대공 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 생산!',
        ),
        ScriptEvent(
          text: '{home}, 드랍십으로 상대 확장기지를 노립니다!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'harass',
          altText: '{home} 선수 드랍 견제! 상대 SCV를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산 시작! 탱크+골리앗 조합으로 전환!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗이 합류합니다! 물량이 더 두터워집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 물량으로 벌처를 대량 보냅니다! 마인으로 상대 이동을 봉쇄!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'macro',
          skipChance: 0.3,
          altText: '{away}, 벌처 물량! 마인 매설로 상대 기동을 제한합니다!',
        ),
        ScriptEvent(
          text: '기술 vs 물량! 결전의 시간이 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 마지막 승부!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 풀가동 물량! 탱크+골리앗+벌처 대군!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 총동원! 기술과 물량의 최종 대결!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격+드랍 동시 투입! 상대 라인을 흔듭니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 멀티포인트 공격! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 물량으로 밀어붙입니다! 골리앗 화력 집중!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 숫자의 힘!',
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
          altText: '{home}, 센터+본진 배럭! BBS입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 센터에 배럭! 본진 배럭도 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, BBS! 양쪽 다 BBS입니다!',
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
    // Phase 1: 마린+SCV 전진 (lines 10-17)
    ScriptPhase(
      name: 'marine_clash',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린+SCV를 뭉쳐서 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -5, favorsStat: 'attack',
          altText: '{home} 선수 마린+SCV 전진! 센터를 장악하려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 마린+SCV 전진! 센터에서 마주칩니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -5, favorsStat: 'attack',
          altText: '{away}, 마린+SCV 맞전진! 정면 충돌!',
        ),
        ScriptEvent(
          text: '센터에서 마린+SCV 대결! 누가 먼저 벙커를 올리느냐!',
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
              altText: '{away}, 벙커 완성이 늦습니다! 마린이 쓰러지고 있어요!',
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
              altText: '{away}, 마린+SCV로 버팁니다!',
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

// ----------------------------------------------------------
// 11. 원팩원스타 미러 (공격적 미러)
// ----------------------------------------------------------
const _tvt1facPushMirror = ScenarioScript(
  id: 'tvt_1fac_push_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_push'],
  awayBuildIds: ['tvt_1fac_push'],
  description: '원팩원스타 미러 벌처+탱크+드랍 대결',
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
          altText: '{home}, 아머리! 골리앗으로 대공+화력!',
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
          text: '{home} 선수 탱크+골리앗 총동원! 최종 교전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력! 정면 충돌!',
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

// ----------------------------------------------------------
// 12. 투스타 레이스 미러 (공중전)
// ----------------------------------------------------------
const _tvtWraithMirror = ScenarioScript(
  id: 'tvt_wraith_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_wraith_cloak'],
  awayBuildIds: ['tvt_wraith_cloak'],
  description: '투스타 레이스 미러 클로킹 공중전',
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
          text: '{away} 선수도 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 그리고 2번째 스타포트도!',
          owner: LogOwner.home,
          homeResource: -50,
          altText: '{home}, 투스타포트! 레이스를 대량 생산하겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수도 투스타포트! 레이스 대량 생산!',
          owner: LogOwner.away,
          awayResource: -50,
          altText: '{away}, 투스타포트! 양쪽 투스타 레이스 미러입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산 시작! 클로킹 연구도 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 생산! 클로킹 연구!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '투스타 레이스 미러! 클로킹 타이밍이 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 레이스 공중전 (lines 12-19)
    ScriptPhase(
      name: 'wraith_clash',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 레이스 3기로 상대 진영 정찰! 공중전 시작!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'control',
          altText: '{home} 선수 레이스 출격! 상대 레이스와 마주칩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 맞대응! 공중에서 교전!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'control',
          altText: '{away}, 레이스 대 레이스! 공중전입니다!',
        ),
        ScriptEvent(
          text: '레이스 대 레이스! 컨트롤 대결이 펼쳐집니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 레이스 컨트롤! 상대 레이스를 집중 공격!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤이 좋습니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 컨트롤! 맞교환!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 클로킹 연구가 곧 완성됩니다! 타이밍이 중요해요!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 클로킹 전쟁 - 분기 (lines 20-31)
    ScriptPhase(
      name: 'cloak_war',
      startLine: 20,
      branches: [
        // 분기 A: 홈 클로킹 먼저
        ScriptBranch(
          id: 'home_cloak_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스가 투명해집니다! 상대 진영 침투!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디텍이 늦습니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 SCV를 학살합니다! 대참사!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 레이스 학살! 일꾼이 전멸 직전!',
            ),
            ScriptEvent(
              text: '클로킹 한 발 차이! 디텍이 늦으면 이렇게 됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 클로킹 먼저
        ScriptBranch(
          id: 'away_cloak_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 클로킹 완성! 레이스가 상대 진영에 침투합니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! SCV를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 디텍이 없습니다! SCV가 쓰러지고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 클로킹 레이스로 SCV 학살! 상대 경제가 무너집니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 레이스 학살! 상대 일꾼이 녹습니다!',
            ),
            ScriptEvent(
              text: '클로킹 타이밍 차이! 한 발 빠른 쪽이 크게 앞섭니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 양쪽 클로킹 동시
        ScriptBranch(
          id: 'both_cloak',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 클로킹이 거의 동시에 완성됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 상대 레이스와 공중전! 보이지 않는 전투!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 클로킹 레이스 대 레이스! 컨트롤 대결!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 컨트롤로 반격! 치열한 공중전!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'control',
              altText: '{away}, 레이스 컨트롤! 클로킹 공중전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '클로킹 레이스 대 클로킹 레이스! 순수 컨트롤 대결!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 지상전 전환 (lines 32-49)
    ScriptPhase(
      name: 'ground_transition',
      startLine: 32,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산 시작!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리! 골리앗으로 대공+지상 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리! 골리앗 생산!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗+탱크 생산! 시즈 모드 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 골리앗+탱크! 시즈 연구까지! 지상 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 골리앗+탱크 생산! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 탱크+골리앗 조합! 라인을 잡아갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈! 라인 대치!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '레이스 교전이 끝나고 지상전으로! 레이스를 잃은 쪽이 불리합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 50-60)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 50,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크+골리앗 총동원! 최종 교전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 전투!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력 배치! 정면 교전!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞섭니다!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 61+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 61,
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

// ----------------------------------------------------------
// 13. 5팩토리 미러 (올인 미러)
// ----------------------------------------------------------
const _tvt5facMirror = ScenarioScript(
  id: 'tvt_5fac_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_5fac'],
  description: '5팩토리 미러 올인 대결',
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
          text: '{home} 선수 가스를 넣고 팩토리 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 가스 채취와 동시에 팩토리!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 가스를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 연달아 증설합니다! 벌써 세 번째!',
          owner: LogOwner.home,
          homeResource: -40,
          altText: '{home}, 팩토리가 쭉쭉 올라갑니다! 5팩 체제로!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 증설! 확장 없이 올인하겠다는 의도!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, 확장 없이 팩토리만 짓습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구 시작! 벌처+탱크 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 시즈 연구! 탱크와 벌처가 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 시즈 모드 연구! 5팩 물량으로 맞섭니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '양측 5팩토리! 확장 없는 올인 미러입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 물량 축적 + 시야 경쟁 (lines 14-23)
    ScriptPhase(
      name: 'buildup',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 벌처 4기로 센터 시야를 확보합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 벌처가 센터를 장악합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처 기동! 마인을 매설하며 이동 경로를 차단!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 마인 매설! 상대 벌처 접근을 차단!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 3기 배치! 센터 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 배치! 양쪽 탱크가 마주 보고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '5팩 미러에서는 시야 확보가 곧 승부! 벌처로 눈을 뜨고 탱크로 때려야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 탱크 교전 - 분기 (lines 24-37)
    ScriptPhase(
      name: 'tank_clash',
      startLine: 24,
      branches: [
        // 분기 A: 홈 시야 우위
        ScriptBranch(
          id: 'home_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 시야를 잡았습니다! 상대 탱크 위치가 보입니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 시야 확보! 상대 탱크 배치를 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 시즈 탱크 선제 포격! 상대 탱크가 터집니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 탱크 선제 포격! 상대 탱크 라인에 직격!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 먼저 맞습니다! 시야 싸움에서 밀렸어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 벌처로 잔여 병력 추격! 탱크 잔해를 정리합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 벌처 추격! 남은 병력까지 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '시야 싸움에서 앞선 쪽이 탱크 교전을 지배합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 시야 우위
        ScriptBranch(
          id: 'away_vision_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인으로 상대 벌처를 잡습니다! 시야가 끊겼어요!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 마인 폭발! 상대 벌처가 시야를 잃습니다!',
            ),
            ScriptEvent(
              text: '{away}, 탱크를 우회시켜 측면에서 포격합니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 측면 우회! 탱크가 상대 라인을 측면에서 때립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 측면에서 포격을 받습니다! 탱크가 큰 피해!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 벌처로 후속 추격! 잔여 탱크를 정리합니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 벌처 추격! 남은 병력을 쓸어냅니다!',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '측면 포격으로 탱크 라인이 무너집니다! 시야가 곧 승부!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 결전 (lines 38-50)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 38,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 아머리! 골리앗으로 화력을 보강합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗이 합류합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 아머리! 골리앗까지! 최종 결전 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 잔여 병력 총동원! 탱크+골리앗 재배치합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
          altText: '{home}, 탱크+골리앗 총출동! 마지막 공세!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 재배치! 결전 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -5,
          altText: '{away}, 탱크+골리앗 재배치! 맞붙을 준비!',
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗+벌처가 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격합니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력 집중! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞서 싸웁니다!',
        ),
      ],
    ),
    // Phase 4: 결전 판정 - 분기 (lines 51+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 51,
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

// ----------------------------------------------------------
// 14. 배럭더블 미러 (가장 대표적인 TvT)
// ----------------------------------------------------------
const _tvtCcFirstMirror = ScenarioScript(
  id: 'tvt_cc_first_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_cc_first'],
  awayBuildIds: ['tvt_cc_first'],
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
              altText: '{home} 선수 벌처 견제! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '벌처 싸움에서 밀리면 맵 컨트롤을 잃습니다! 테테전의 핵심!',
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
              altText: '{away} 선수 벌처 침투! SCV가 쓰러집니다!',
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
          altText: '{away}, 스타포트+골리앗! 후반 교전 준비!',
        ),
        ScriptEvent(
          text: '탱크+골리앗+드랍십! 시야 싸움과 견제가 동시에 진행됩니다!',
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
              altText: '{home} 선수 드랍+정면 동시 공격! 수비가 갈립니다!',
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
              altText: '{away} 선수 견제+정면 동시! 상대가 갈립니다!',
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
              text: '정면 탱크+골리앗 라인전! 시즈 포격 범위가 승부를 가릅니다!',
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
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 최종 결전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 승부!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크+골리앗 전 병력 배치! 결전입니다!',
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
          text: '탱크+골리앗+드랍십! 후반 결전이 다가옵니다!',
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
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 결전을 준비합니다!',
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
          text: '양측 탱크+골리앗이 정면 충돌합니다!',
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

// ----------------------------------------------------------
// 16. 원팩확장 미러 (장기전)
// ----------------------------------------------------------
const _tvt1facExpandMirror = ScenarioScript(
  id: 'tvt_1fac_expand_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_expand'],
  awayBuildIds: ['tvt_1fac_expand'],
  description: '원팩확장 미러 장기전',
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
          text: '{home} 선수 팩토리 건설! 가스를 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산! 마인 연구를 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 벌처+마인! 수비적 세팅!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처+마인 연구! 수비적 오프닝!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 확장! 원팩 확장입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터! 미러 오프닝!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 같은 빌드!',
        ),
        ScriptEvent(
          text: '양측 원팩 확장! 수비적인 미러, 장기전이 예상됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 마인 수비 + 소규모 교전 (lines 14-23)
    ScriptPhase(
      name: 'mine_defense',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마인을 앞마당 주변에 매설합니다! 영역 확보!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'defense',
          altText: '{home}, 마인 매설! 앞마당을 철통 방어!',
        ),
        ScriptEvent(
          text: '{away} 선수도 마인으로 이동 경로를 차단합니다!',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 센터를 정찰합니다! 소규모 교전!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'scout',
          altText: '{home}, 벌처 정찰! 상대 타이밍을 확인합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 맞정찰! 양측 조심스럽습니다!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 수비적! 마인밭 사이로 벌처만 소규모 교전합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 트리플 확장 경쟁 - 분기 (lines 24-37)
    ScriptPhase(
      name: 'triple_race',
      startLine: 24,
      branches: [
        // 분기 A: 홈 트리플 먼저
        ScriptBranch(
          id: 'home_triple_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 세 번째 확장을 올립니다! 트리플 커맨드!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 트리플! 자원 우위를 확보하려 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 트리플이 늦습니다! 마인으로 시간을 벌어봅니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 세 번째 확장이 가동됩니다! 자원이 쏟아집니다!',
              owner: LogOwner.home,
              homeResource: 20, favorsStat: 'macro',
              altText: '{home} 선수 트리플 풀가동! 자원 격차!',
            ),
            ScriptEvent(
              text: '트리플을 먼저 잡은 쪽이 물량에서 앞서게 됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 트리플 먼저
        ScriptBranch(
          id: 'away_triple_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 세 번째 확장을 올립니다! 빠른 트리플!',
              owner: LogOwner.away,
              awayResource: -30,
              altText: '{away}, 트리플! 자원을 먼저 확보합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 트리플이 늦었습니다! 마인으로 시간을 벌어봅니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 세 번째 확장이 풀가동! 자원 우위를 확보!',
              owner: LogOwner.away,
              awayResource: 20, favorsStat: 'macro',
              altText: '{away} 선수 트리플 풀가동! 자원이 풍부합니다!',
            ),
            ScriptEvent(
              text: '트리플 확장 먼저! 자원 우위가 물량으로 이어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 동시 트리플
        ScriptBranch(
          id: 'simultaneous_triple',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 거의 동시에 세 번째 확장을 올립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 트리플 커맨드 건설!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 트리플! 상대도 같은 타이밍!',
            ),
            ScriptEvent(
              text: '{away} 선수도 트리플! 동등한 자원 경쟁!',
              owner: LogOwner.away,
              awayResource: -30,
            ),
            ScriptEvent(
              text: '동시 트리플! 자원은 동등, 이후 교전 실력이 관건!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크+골리앗 대량 생산 (lines 38-51)
    ScriptPhase(
      name: 'buildup',
      startLine: 38,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 대량 생산! 시즈 모드 연구 완료!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 탱크가 쏟아집니다! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 대량 생산! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 공방 업그레이드를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리! 공방업으로 화력을 높입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트! 드랍십으로 견제를 노린다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트! 드랍십 대비까지 갖춥니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗+드랍십! 후반 집중력 싸움이 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 드랍 견제 - 분기 (lines 52-67)
    ScriptPhase(
      name: 'drop_harass',
      startLine: 52,
      branches: [
        // 분기 A: 홈 드랍 견제 성공
        ScriptBranch(
          id: 'home_drop_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십 출격! 상대 확장기지에 탱크를 투하합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 드랍! 상대 확장기지 SCV가 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지 SCV 피해! 골리앗을 돌리지만 이미 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 드랍 성공! 자원 격차가 벌어집니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 대성공! SCV 대량 피해!',
            ),
            ScriptEvent(
              text: '확장기지 타격! 자원 격차가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 드랍 견제 성공
        ScriptBranch(
          id: 'away_drop_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드랍십으로 상대 본진을 기습합니다! 탱크 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 본진 드랍! 생산시설이 위협받습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 피해! 팩토리가 타격을 받습니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 본진 기습 성공! 생산력에 타격!',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍 성공! 생산시설 피해!',
            ),
            ScriptEvent(
              text: '본진 견제 성공! 생산력 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 68-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 68,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크+골리앗+드랍십 총동원! 최종 결전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 집중력 싸움!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 배치! 정면 교전 준비!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크+골리앗이 정면 충돌! 집중력 싸움입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격 집중! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 포화로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 반격! 마지막까지 맞섭니다!',
        ),
      ],
    ),
    // Phase 6: 결전 판정 - 분기 (lines 81+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 81,
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
