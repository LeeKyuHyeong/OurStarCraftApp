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
  homeBuildIds: ['tvt_cc_first', 'tvt_2fac_vulture'],
  awayBuildIds: ['tvt_2fac_vulture', 'tvt_cc_first', 'tvt_1fac_expand'],
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
          text: '{home} 선수 SCV 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeResource: -3,
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
          altText: '{home}, 빠른 앞마당! 경제를 가져가겠다는 의도!',
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
              text: '벌처 싸움에서 밀리면 큰일! TvT의 핵심입니다!',
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
              text: '{away}, 벌처 속업이 먼저 완료! 속도 차이로 압도합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 벌처 속업 타이밍! 상대 벌처를 잡습니다!',
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
              text: '벌처 싸움에서 앞서면 TvT는 유리해집니다!',
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
          text: '양측 탱크가 라인을 형성합니다. 신중한 대치!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 견제를 노리는 건가요?',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 드랍십이 나옵니다! 상대 후방을 노릴 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 드랍십 대비!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '팽팽한 탱크 라인 대치가 이어집니다.',
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
              text: '{home}, 드랍십 출격! 상대 멀티에 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 드랍! 상대 멀티가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 멀티가 박살나고 있습니다! 탱크를 돌려야 해요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 그 틈에 정면에서도 전진! 멀티포인트 공격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드랍+정면 동시 공격! 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '드랍 견제가 판을 뒤집고 있습니다!',
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
              text: '{away} 선수 탱크 라인을 밀어냅니다! 골리앗도 합류!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 시즈 포격! 상대 탱크 라인을 뚫습니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 탱크 화력! 상대 라인이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 밀립니다! 후퇴하면서 재배치!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '탱크 라인이 뚫렸습니다! TvT의 결정적 순간!',
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
          text: '{home} 선수 남은 병력 총동원! 탱크 골리앗 벌처!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 결집! 최종 교전!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 라인이 정면 충돌합니다!',
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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 배럭! 공격적인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 커맨드 센터를 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노배럭 더블! 경제를 가져가겠다는 선택!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, BBS 확정! 마린을 빠르게 모읍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 10-12, recovery 7-9: +3 army each)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 2기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 마린+SCV 전진! 벙커를 노립니다!',
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
      ],
    ),
    // Phase 2: 정찰 여부 - 분기 (lines 15+, recovery 13-14: +2 army each)
    // Before branch: homeArmy ~8, awayArmy ~7
    ScriptPhase(
      name: 'scout_check',
      startLine: 15,
      branches: [
        ScriptBranch(
          id: 'scouted_bbs',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV 정찰로 센터 배럭을 발견했습니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 정찰 성공! BBS를 읽었습니다!',
            ),
            ScriptEvent(
              text: '{away}, SCV를 뭉쳐서 센터 마린을 끊으러 갑니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 SCV로 마린 견제! 마린을 끊습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 줄어들고 있습니다! BBS가 흔들립니다!',
              owner: LogOwner.home,
              homeArmy: -3, skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{away} 선수 벙커까지 때리면서 완전 봉쇄합니다!',
              owner: LogOwner.away,
              homeArmy: -3, skipChance: 0.4,
              altText: '{away}, 마린과 SCV로 총공세! BBS 완전 차단!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 경제 손실이 크겠는데요.',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away}, BBS를 막아냈습니다! 앞마당 경제가 돌아가기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 15,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bunker_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 건설 성공! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -10, favorsStat: 'control',
              altText: '{home} 선수 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 발견! 마린과 SCV를 모아서 대응합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
            ),
            ScriptEvent(
              text: '{home}, 벙커 화력! 하지만 {away}도 SCV 수리로 맞섭니다!',
              owner: LogOwner.home,
              awayArmy: -1, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 마린 추가 생산! 수비가 안정되기 시작합니다!',
              owner: LogOwner.away,
              awayArmy: 1, awayResource: -10,
            ),
            ScriptEvent(
              text: 'BBS 압박! 벙커를 깨뜨릴 수 있을까요?',
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
// 3. 투스타 레이스 vs 배럭 더블 (공중 견제)
// ----------------------------------------------------------
const _tvtWraithVsRaxDouble = ScenarioScript(
  id: 'tvt_wraith_vs_rax_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_wraith_cloak', 'tvt_1fac_push'],
  awayBuildIds: ['tvt_cc_first', 'tvt_2fac_vulture', 'tvt_1fac_expand'],
  description: '투스타 레이스/드랍 vs 배럭 더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-7)
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
          text: '{home} 선수 스타포트 건설! 레이스를 노리는 건가요?',
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
          text: '{home} 선수 레이스 생산! 클로킹 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 레이스 생산! 클로킹까지!',
        ),
      ],
    ),
    // Phase 1: 레이스 견제 (lines 11+, recovery 8-10: +3 army each)
    ScriptPhase(
      name: 'wraith_harass',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 클로킹 레이스가 상대 본진으로 향합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 클로킹 레이스 침투! SCV를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설 중이구요. 앞마당 경제가 돌아가고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '레이스가 침투했습니다! 디텍이 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 클로킹 견제 결과 - 분기 (lines 16+, recovery 14-15: +2 army each)
    // Before branch: homeArmy ~7, awayArmy ~8
    ScriptPhase(
      name: 'cloak_result',
      startLine: 16,
      branches: [
        ScriptBranch(
          id: 'cloak_devastation',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 레이스가 SCV를 학살합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -25, awayArmy: -3, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 견제! SCV가 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 급히 스캔! 하지만 이미 SCV 피해가 큽니다!',
              owner: LogOwner.away,
              awayResource: -10, awayArmy: -3, skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home}, 추가 레이스까지! 견제가 이어집니다!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -3, favorsStat: 'harass',
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '클로킹 견제가 대성공! 경제 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 견제로 주도권! 지상군 전환합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'cloak_defended',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 터렛을 미리 건설해 놨습니다! 레이스를 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 터렛이 레이스를 포착! 격추합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스를 잃었습니다! 투자 대비 효과가 없어요!',
              owner: LogOwner.home,
              homeArmy: -3, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 그 사이 탱크 생산! 벌처도 나오고 있구요!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 경제도 병력도 앞섭니다! 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -2, skipChance: 0.4,
              altText: '{away}, 탱크 라인이 전진! {home} 선수가 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '레이스 견제가 막혔습니다! 경제 차이가 게임을 결정합니다!',
              owner: LogOwner.system,
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
          text: '{away} 선수 앞마당 확장 후 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 마인 매설! 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 5개 체제! 탱크 벌처 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -30,
          altText: '{home}, 5팩토리 풀가동! 병력이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드 센터! 마인으로 시간을 벌면서!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 트리플 확장! 경제를 최대한 끌어올립니다!',
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
              text: '{away}, 트리플 경제로 역전 준비! 병력이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: 20,
            ),
            ScriptEvent(
              text: '마인 수비 성공! 경제 차이로 역전을 노립니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
