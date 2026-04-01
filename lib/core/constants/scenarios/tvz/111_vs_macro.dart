part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4. 111 밸런스 vs 매크로 (중반 집중)
// ----------------------------------------------------------
const _tvz111VsMacro = ScenarioScript(
  id: 'tvz_111_vs_macro',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_111', 'tvz_trans_111_balance'],
  awayBuildIds: ['zvt_3hatch_nopool', 'zvt_trans_ultra_hive'],
  description: '111 밸런스 vs 노풀 3해처리 매크로',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 해처리를 빠르게 추가합니다! 자원 우선!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 매크로 운영이구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 일찍 시작합니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다.',
          owner: LogOwner.away,
          awayResource: 10,
          altText: '{away}, 드론 생산에 올인하는 모습이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 테크를 올리는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭 하나에 팩토리! 테크 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리까지! 자원이 폭발적입니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.2,
          altText: '{away}, 해처리 3개 체제! 드론이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 111 체제로 가는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아직 스포닝풀을 안 올렸습니다! 노풀 운영!',
          owner: LogOwner.away,
          awayResource: 15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크 vs 경제 (lines 17-26)
    ScriptPhase(
      name: 'tech_vs_economy',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 이제 스포닝풀 건설합니다! 노풀 체제에서 전환!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 뒤늦게 스포닝풀이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착! 스타포트까지! 111 체제입니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리 머신샵 + 스타포트! 111 테크트리로 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 3해처리 풀가동! 드론 30기 넘어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: 30,
          altText: '{away}, 해처리 3개에서 드론이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '자원 차이가 벌어지고 있습니다. 테란이 빨리 움직여야 할 텐데요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 레이스 생산! 정찰 나갑니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15, favorsStat: 'scout',
        ),
      ],
    ),
    // Phase 2: 레이스 정찰 - 분기 (lines 27-38)
    ScriptPhase(
      name: 'wraith_scout',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'wraith_overlord_hunt',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 레이스가 오버로드를 발견! 격추합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 레이스로 오버로드 저격!',
            ),
            ScriptEvent(
              text: '{away} 선수 오버로드 피해! 서플라이가 막히는데요!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 추가 오버로드까지 격추! 저그 생산이 멈춥니다!',
              owner: LogOwner.home,
              awayArmy: -1, awayResource: -10, favorsStat: 'harass',
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 정찰로 저그 빌드를 완벽히 읽었습니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '오버로드 손실이 뼈아픕니다. 저그 자원에 타격이 가는데요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_overlord_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 오버로드 위치 관리! 레이스를 피합니다!',
              owner: LogOwner.away,
              favorsStat: 'defense',
              altText: '{away}, 오버로드를 안전한 곳으로 빼놓았습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 빈손으로 돌아옵니다.',
              owner: LogOwner.home,
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이에도 드론 생산 계속! 자원 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: 20, favorsStat: 'macro',
              altText: '{away}, 드론 40기 돌파! 자원이 폭발적입니다!',
            ),
            ScriptEvent(
              text: '레이스 견제가 실패했습니다. 테란이 빨리 전환해야 하는데요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 푸시 타이밍 (lines 39-54)
    ScriptPhase(
      name: 'tank_push',
      startLine: 39,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 시즈 탱크 2기 생산! 바이오닉과 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home} 선수 탱크 합류! 푸시 준비 완료!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 완성! 뮤탈리스크 생산 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 스파이어에서 뮤탈이 뜹니다! 저그의 눈!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 바이오닉 전진! 저그 앞마당을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home}, 본격적인 전진 시작! 앞마당 압박!',
        ),
        ScriptEvent(
          text: '{away}, 저글링 물량으로 막아냅니다! 수비 라인 구축!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -2, favorsStat: 'defense',
          altText: '{away} 선수 저글링 성큰으로 탱크 푸시 저지!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 앞마당을 포격합니다!',
          owner: LogOwner.home,
          awayArmy: -3, awayResource: -15, favorsStat: 'attack',
          altText: '{home} 선수 시즈 모드! 저그 앞마당에 포탄이 떨어집니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈이 돌아와서 탱크 뒤를 칩니다!',
          owner: LogOwner.away,
          homeArmy: -2, homeResource: -10, favorsStat: 'harass',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '탱크 타이밍과 저그 물량의 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 후반 전환 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'late_transition',
      startLine: 55,
      branches: [
        ScriptBranch(
          id: 'terran_second_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 2차 공격 준비! 병력을 다시 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 멀티 포인트 공격! 저그 수비가 분산됩니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 양쪽에서 동시 압박!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 양쪽을 다 막기 어려운 상황!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '테란의 멀티 공격이 효과를 보고 있습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_mass_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 하이브 완성! 울트라리스크 캐번 건설!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 울트라리스크 생산! 최종 병기 등장!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -15,
              altText: '{away}, 울트라 등장! 최종 병기!',
            ),
            ScriptEvent(
              text: '{away}, 울트라 저글링 대규모 돌진! 물량이 압도적입니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이가 벌어집니다! 테란이 밀리기 시작!',
            ),
            ScriptEvent(
              text: '{home} 선수 수비하려 하지만 물량 차이가 너무 큽니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '저그의 물량이 승부를 가르고 있습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

