part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4. 스탠다드 T vs 스탠다드 Z (오프닝 매칭 + 트랜지션 분기)
// 기존: bio_vs_mutal, wraith_vs_mutal, valkyrie_vs_mutal,
//       standard_vs_1hatch_allin, mech_vs_lurker 통합
// ----------------------------------------------------------
const _tvzStandardVsStandard = ScenarioScript(
  id: 'tvz_standard_vs_standard',
  matchup: 'TvZ',
  homeBuildIds: [
    // 기본 빌드
    'tvz_sk', 'tvz_4rax_enbe', 'tvz_111',
    'tvz_3fac_goliath', 'tvz_valkyrie', 'tvz_2star_wraith',
    // 트랜지션 빌드
    'tvz_trans_bionic_push', 'tvz_trans_mech_goliath',
    'tvz_trans_111_balance', 'tvz_trans_valkyrie',
    'tvz_trans_wraith', 'tvz_trans_enbe_push',
  ],
  awayBuildIds: [
    // 기본 빌드
    'zvt_12pool', 'zvt_12hatch',
    // 특화 빌드
    'zvt_3hatch_mutal', 'zvt_2hatch_mutal', 'zvt_2hatch_lurker',
    'zvt_1hatch_allin',
    // 트랜지션 빌드
    'zvt_trans_mutal_ultra', 'zvt_trans_2hatch_mutal',
    'zvt_trans_lurker_defiler', 'zvt_trans_530_mutal',
    'zvt_trans_mutal_lurker', 'zvt_trans_ultra_hive',
  ],
  description: '스탠다드 테란 vs 스탠다드 저그 (트랜지션 분기)',
  phases: [
    // ============================================================
    // Phase 0: 공통 오프닝 (lines 1-16)
    // ============================================================
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
          text: '{away} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 앞마당 확장을 가져가는군요.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
          altText: '{home}, 가스를 일찍 넣습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 소량 생산하면서 드론을 계속 뽑습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
          altText: '{away}, 저글링 깔아놓으면서 드론 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 소수 마린으로 저글링과 초반 교전을 벌입니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          skipChance: 0.3,
          altText: '{home}, 마린 3기가 앞마당으로! 드론을 위협합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 마린을 쫓아냅니다!',
          owner: LogOwner.away,
          awayArmy: 1, homeArmy: -1, favorsStat: 'defense',
          skipChance: 0.3,
          altText: '{away}, 저글링이 마린을 밀어냅니다!',
        ),
      ],
    ),
    // ============================================================
    // Phase 1: 테크 빌드업 (lines 17-26)
    // ============================================================
    ScriptPhase(
      name: 'tech_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 테크를 올리기 시작합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 테크 건물이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 진화 시작합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어가 올라갑니다! 상위 테크 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
          altText: '{home}, 앞마당 확장! 커맨드센터가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 앞마당에 심습니다. 마린 압박 대비!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 성큰 건설! 마린메딕에 대비합니다!',
        ),
        ScriptEvent(
          text: '양측 모두 내정에 집중하는 고요한 전개입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // ============================================================
    // Phase 2: 트랜지션 분기 (lines 27-42)
    // conditionHomeBuildIds / conditionAwayBuildIds로 빌드별 분기
    // ============================================================
    ScriptPhase(
      name: 'transition_branch',
      startLine: 27,
      branches: [
        // ----- 분기 A: 바이오닉 vs 뮤탈 -----
        ScriptBranch(
          id: 'bionic_vs_mutal',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_sk', 'tvz_4rax_enbe',
            'tvz_trans_bionic_push', 'tvz_trans_enbe_push',
          ],
          conditionAwayBuildIds: [
            'zvt_2hatch_mutal', 'zvt_3hatch_mutal',
            'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra',
            'zvt_12pool', 'zvt_12hatch',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 배럭을 추가합니다! 아카데미도 건설!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
              altText: '{home}, 배럭 추가에 아카데미! 바이오닉 체제!',
            ),
            ScriptEvent(
              text: '{home} 선수 스팀팩 연구!',
              owner: LogOwner.home,
              homeResource: -15,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 건설 시작! 뮤탈 타이밍이 다가옵니다!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 스파이어가 올라가고 있습니다! 곧 뮤탈이 나옵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕 조합이 갖춰졌습니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home}, 마린 메딕 완성! 스팀팩까지 달렸습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 앞마당으로 전진합니다! 스팀팩 ON!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home}, 스팀팩 밟고 앞마당 압박! 마린이 드론을 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크 등장! 빠른 타이밍입니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'control',
              altText: '{away} 선수 뮤탈이 떴습니다! 절묘한 타이밍이구요!',
            ),
            ScriptEvent(
              text: '바이오닉 vs 뮤탈! 가장 익숙한 TvZ 전개입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 B: 메카닉 vs 럴커 -----
        ScriptBranch(
          id: 'mech_vs_lurker',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_3fac_goliath', 'tvz_trans_mech_goliath',
          ],
          conditionAwayBuildIds: [
            'zvt_2hatch_lurker', 'zvt_trans_lurker_defiler',
            'zvt_trans_ultra_hive', 'zvt_12pool', 'zvt_12hatch',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리 증설! 본격적인 메카닉 체제입니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -25,
              altText: '{home}, 팩토리 2개째 올라갑니다! 메카닉 가동!',
            ),
            ScriptEvent(
              text: '{home}, 아머리 건설! 골리앗 생산! 대공까지 가능한 조합이구요.',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라덴 건설 시작합니다. 히드라 테크를 노리는 모습!',
              owner: LogOwner.away,
              awayResource: -15,
              altText: '{away}, 히드라덴이 올라갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레어 완성! 럴커 변태가 시작됩니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20,
              altText: '{away}, 럴커 아스펙트 연구 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 사이언스 퍼실리티까지 올립니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 스타포트에서 사이언스 퍼실리티까지! 고급 테크!',
            ),
            ScriptEvent(
              text: '메카닉 vs 럴커! 장기전으로 가는 전개입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 C: 레이스 vs 뮤탈 -----
        ScriptBranch(
          id: 'wraith_vs_mutal',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_2star_wraith', 'tvz_trans_wraith',
          ],
          conditionAwayBuildIds: [
            'zvt_2hatch_mutal', 'zvt_3hatch_mutal',
            'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra',
            'zvt_12pool', 'zvt_12hatch',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리에 머신샵 부착! 테크를 서두르고 있습니다.',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 팩토리가 올라갑니다! 빠른 테크!',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 공중 유닛을 노리는 건가요?',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스타포트가 올라갑니다!',
            ),
            ScriptEvent(
              text: '{home}, 레이스 생산! 클로킹 연구도 시작합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home} 선수 첫 레이스가 나옵니다! 클로킹까지!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 건설 들어갑니다! 뮤탈 타이밍이 다가오는데요.',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 스파이어 올라갑니다! 뮤탈 준비!',
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스가 저그 본진으로 침투합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 클로킹! 레이스가 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '레이스 vs 뮤탈! 하늘의 주도권을 놓고 싸우게 됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 D: 발키리 vs 뮤탈 -----
        ScriptBranch(
          id: 'valkyrie_vs_mutal',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_valkyrie', 'tvz_trans_valkyrie',
          ],
          conditionAwayBuildIds: [
            'zvt_2hatch_mutal', 'zvt_3hatch_mutal',
            'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra',
            'zvt_12pool', 'zvt_12hatch',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리에 머신샵 부착하면서 테크를 올립니다.',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 팩토리 머신샵! 테크를 올립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 컨트롤타워 부착에 아머리까지!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 스타포트 컨트롤타워 아머리가 동시에 올라갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스타포트에서 발키리 생산 시작합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home}, 발키리가 나옵니다! 대공 특화 유닛!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 3기 등장합니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20,
              altText: '{away}, 뮤탈이 떴습니다! 견제를 나갈 텐데요.',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 테란 본진을 정찰합니다! 발키리를 확인!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away} 선수 뮤탈 정찰! 발키리를 확인했습니다!',
            ),
            ScriptEvent(
              text: '발키리 vs 뮤탈! 대공 특화 매치업입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 E: 111 vs 매크로 -----
        ScriptBranch(
          id: 'one_one_one_vs_macro',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_111', 'tvz_trans_111_balance',
          ],
          conditionAwayBuildIds: [
            'zvt_12pool', 'zvt_12hatch',
            'zvt_3hatch_mutal', 'zvt_2hatch_mutal',
            'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra',
            'zvt_trans_ultra_hive',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리 건설! 머신샵 부착에 스타포트까지! 111 체제입니다.',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 팩토리 머신샵 + 스타포트! 111 테크트리로 갑니다!',
            ),
            ScriptEvent(
              text: '{home}, 레이스 생산! 정찰 나갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15, favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{away} 선수 드론을 계속 뽑으면서 자원을 벌립니다.',
              owner: LogOwner.away,
              awayResource: 15, favorsStat: 'macro',
              altText: '{away}, 드론 생산에 올인하는 모습이네요!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스로 오버로드를 저격합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'harass',
              altText: '{home}, 레이스가 오버로드를 격추합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 건설하면서 뮤탈을 준비합니다.',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 스파이어가 올라갑니다!',
            ),
            ScriptEvent(
              text: '111 밸런스 체제! 레이스 정찰이 승부의 열쇠입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 F: 스탠다드 T vs 원해처리 올인 -----
        ScriptBranch(
          id: 'standard_vs_1hatch_allin',
          baseProbability: 1.0,
          conditionAwayBuildIds: [
            'zvt_1hatch_allin', 'zvt_trans_530_mutal',
          ],
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리 하나로 시작합니다. 앞마당을 안 올리네요!',
              owner: LogOwner.away,
              awayResource: -5,
              altText: '{away}, 원해처리 운영! 확장 없이 가는 건가요?',
            ),
            ScriptEvent(
              text: '{away} 선수 가스를 일찍 넣고 히드라덴 건설! 럴커를 노리는 건가요?',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 히드라덴이 올라갑니다! 원해처리 럴커 올인!',
            ),
            ScriptEvent(
              text: '{away} 선수 히드라 생산! 바로 럴커 변태 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20, favorsStat: 'strategy',
              altText: '{away}, 히드라가 나오자마자 럴커로 변태합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕 조합이 갖춰지고 있습니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10,
            ),
            ScriptEvent(
              text: '저그가 원해처리에서 럴커를 뽑았습니다! 올인 타이밍입니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // ----- 분기 G: 폴백 (조건 없음) -----
        ScriptBranch(
          id: 'generic_mid',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 테크를 올리면서 병력을 모읍니다.',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home}, 병력 생산 가속! 중반 준비!',
            ),
            ScriptEvent(
              text: '{away} 선수도 레어에서 상위 테크를 올리고 있습니다.',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
              altText: '{away}, 레어 테크 완성! 상위 유닛 생산 준비!',
            ),
            ScriptEvent(
              text: '{home} 선수 전진을 준비합니다.',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 물량을 깔아놓으면서 버팁니다.',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '양측 중반 전개가 본격화됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ============================================================
    // Phase 3: 중반 교전 (lines 43-58)
    // ============================================================
    ScriptPhase(
      name: 'mid_battle',
      startLine: 43,
      branches: [
        // ----- 분기 A: 바이오닉 앞마당 압박 -----
        ScriptBranch(
          id: 'bionic_push',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_sk', 'tvz_4rax_enbe',
            'tvz_trans_bionic_push', 'tvz_trans_enbe_push',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 메딕 탱크 조합으로 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'attack',
              altText: '{home}, 마린 메딕 탱크 전진! 저그 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 견제하면서 저글링 물량을 모읍니다.',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15,
              altText: '{away} 선수 뮤탈 견제와 동시에 저글링 대량 생산!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 시즈 모드! 앞마당을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 시즈 모드! 저그 앞마당에 포탄이 떨어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 달려나옵니다! 탱크 라인을 노리는데요!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -3, favorsStat: 'control',
              altText: '{away}, 발업 저글링 돌진! 시즈 라인 돌파 시도!',
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
        // ----- 분기 B: 메카닉 vs 럴커 대치 -----
        ScriptBranch(
          id: 'mech_vs_lurker_clash',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_3fac_goliath', 'tvz_trans_mech_goliath',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗 대량 생산! 팩토리 풀가동입니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -30, favorsStat: 'macro',
              altText: '{home}, 골리앗 물량이 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커 포진! 입구를 완벽하게 틀어막습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 럴커 매복! 완벽한 위치선정입니다!',
            ),
            ScriptEvent(
              text: '{home}, 스캔! 럴커 위치를 정확히 포착합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 컴샛 스테이션으로 럴커 위치 확인!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크로 럴커 위치를 정밀 포격!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'strategy',
              altText: '{home}, 탱크 포격! 럴커를 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 세 번째 해처리! 자원이 돌아가기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 20,
            ),
            ScriptEvent(
              text: '메카닉 화력 vs 럴커 수비! 지루하지만 치열한 공방입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 C: 공중전 (레이스/발키리 vs 뮤탈) -----
        ScriptBranch(
          id: 'air_battle',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_2star_wraith', 'tvz_trans_wraith',
            'tvz_valkyrie', 'tvz_trans_valkyrie',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 공중 유닛 추가 생산! 편대가 두꺼워집니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -25,
              altText: '{home}, 공중 화력이 강해지고 있어요!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크로 SCV를 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 뮤짤! 일꾼을 솎아냅니다!',
            ),
            ScriptEvent(
              text: '{home}, 공중 유닛이 뮤탈을 쫓아갑니다! 공중 추격전!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 공중 컨트롤! 뮤탈을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지 생산! 상대 공중 유닛을 노립니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -15, favorsStat: 'strategy',
              altText: '{away}, 스커지가 공중 유닛에 돌진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 터렛 보강하면서 뮤탈 견제에 대비합니다.',
              owner: LogOwner.home,
              homeResource: -10,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '공중에서 치열한 전투가 벌어지고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 D: 럴커 올인 돌입 -----
        ScriptBranch(
          id: 'lurker_allin_rush',
          baseProbability: 1.0,
          conditionAwayBuildIds: [
            'zvt_1hatch_allin', 'zvt_trans_530_mutal',
          ],
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 4기가 테란 앞마당으로 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
              altText: '{away}, 럴커 전진! 올인입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔이 없습니다! 럴커 위치를 모르는 상황!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 디텍터가 부족합니다! 럴커에 마린이 녹아요!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 입구에 자리잡습니다! 보병을 녹여냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 럴커 포진! 테란 입구가 완전히 막혔습니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링까지 합류! 럴커 뒤에서 달려나옵니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '올인 타이밍! 테란이 막을 수 있을까요?',
              owner: LogOwner.system,
            ),
          ],
        ),
        // ----- 분기 E: 111 탱크 푸시 -----
        ScriptBranch(
          id: 'one_one_one_push',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_111', 'tvz_trans_111_balance',
          ],
          events: [
            ScriptEvent(
              text: '{home}, 시즈 탱크 2기 생산! 바이오닉과 합류합니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25,
              altText: '{home} 선수 탱크 합류! 푸시 준비 완료!',
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
              awayArmy: 3, homeArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 저글링 성큰으로 탱크 푸시 저지!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 시즈 모드! 앞마당을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 시즈 모드! 저그 앞마당에 포탄이 떨어집니다!',
            ),
            ScriptEvent(
              text: '111 탱크 푸시! 정면 돌파 시도입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 F: 폴백 일반 교전 -----
        ScriptBranch(
          id: 'generic_clash',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 병력을 모아서 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20, favorsStat: 'attack',
              altText: '{home}, 총공격 준비! 전진합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 물량으로 수비합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 전진 중! 저그 앞마당을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 후방을 치면서 정면에서도 막아냅니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '양측 병력 교환이 일어나고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ============================================================
    // Phase 4: 후반 전환 (lines 59-74)
    // ============================================================
    ScriptPhase(
      name: 'late_transition',
      startLine: 59,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      branches: [
        // ----- 분기 A: 테란 드랍십 견제 -----
        ScriptBranch(
          id: 'terran_dropship_raid',
          baseProbability: 1.0,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 마린 메딕을 태웁니다! 후방을 노리는 건가요?',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20, favorsStat: 'strategy',
              altText: '{home}, 드랍십 출발! 저그 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 드랍! 저그 해처리에 마린이 내립니다! 드론이 당합니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 드랍 성공! 일꾼 초토화!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 급히 대응하러 갑니다! 전선이 비는데요!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 뮤탈이 돌아가는 사이 정면이 약해집니다!',
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 동시 전진! 멀티 포인트 공격입니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 드랍 + 정면 동시 압박! 저그 수비가 갈립니다!',
            ),
            ScriptEvent(
              text: '드랍십 견제가 판을 뒤집고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 B: 베슬 vs 스커지 대결 -----
        ScriptBranch(
          id: 'vessel_vs_scourge',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬 생산! 이레디에이트 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
              altText: '{home}, 베슬이 나옵니다! 럴커를 잡을 핵심 유닛이죠!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지를 생산합니다! 베슬을 잡아야 럴커가 살 수 있죠!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10,
              altText: '{away}, 스커지 생산! 베슬을 향해 돌진 준비!',
            ),
            ScriptEvent(
              text: '{away}, 스커지가 베슬을 향해 돌진합니다!',
              owner: LogOwner.away,
              awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 베슬을 빼면서 스커지를 피합니다! 컨트롤이 좋습니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home}, 베슬 컨트롤! 스커지가 허공을 찌릅니다!',
            ),
            ScriptEvent(
              text: '베슬과 스커지의 긴장감 넘치는 대결입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 C: 저그 하이브 전환 -----
        ScriptBranch(
          id: 'zerg_hive_tech',
          baseProbability: 1.0,
          conditionAwayBuildIds: [
            'zvt_trans_ultra_hive', 'zvt_trans_lurker_defiler',
            'zvt_trans_mutal_ultra',
          ],
          events: [
            ScriptEvent(
              text: '{away} 선수 하이브 진화! 디파일러 마운드 건설 시작합니다!',
              owner: LogOwner.away,
              awayResource: -30,
              altText: '{away}, 하이브 완성! 디파일러 마운드까지!',
            ),
            ScriptEvent(
              text: '{away}, 울트라리스크 캐번 건설! 울트라 준비에 들어갑니다!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 울트라리스크 캐번까지! 후반 준비 완료!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 팩토리 건설! 화력을 끌어올립니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -25, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜 깔아줍니다! 탱크 포격이 무력화됩니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away} 선수 다크스웜! 포격을 완전히 무력화시킵니다!',
            ),
            ScriptEvent(
              text: '하이브 테크가 전장을 바꾸고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 D: 올인 후 마무리 -----
        ScriptBranch(
          id: 'post_allin_resolution',
          baseProbability: 1.0,
          conditionAwayBuildIds: [
            'zvt_1hatch_allin', 'zvt_trans_530_mutal',
          ],
          events: [
            ScriptEvent(
              text: '{away} 선수 올인이 막힐 조짐입니다! 원해처리라 자원이 없어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 확장하면서 병력을 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 10, favorsStat: 'macro',
              altText: '{home}, 자원 차이를 벌립니다! 테란이 유리해요!',
            ),
            ScriptEvent(
              text: '{away}, 급히 앞마당을 올리지만 이미 자원 차이가 크네요.',
              owner: LogOwner.away,
              awayResource: -30,
            ),
            ScriptEvent(
              text: '{away}, 스파이어에서 뮤탈 추가! 530 전환을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 스파이어 완성! 럴커에 뮤탈까지!',
            ),
            ScriptEvent(
              text: '올인 이후 전환 타이밍! 승부가 갈리는 순간입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 E: 폴백 일반 전환 -----
        ScriptBranch(
          id: 'generic_late',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 추가 생산 시설을 올리면서 화력을 보강합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20, favorsStat: 'macro',
              altText: '{home}, 생산 시설 증설! 병력이 두꺼워집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 해처리를 올리면서 물량을 키웁니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home}, 전진을 준비하면서 앞마당을 확보합니다.',
              owner: LogOwner.home,
              homeResource: 10,
            ),
            ScriptEvent(
              text: '{away}, 저글링 물량이 점점 쌓이고 있습니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '후반 체제 구축! 결전이 다가옵니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ============================================================
    // Phase 5: 결전 (lines 75-90)
    // ============================================================
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 75,
      branches: [
        // ----- 분기 A: 테란 확장 차단 승리 -----
        ScriptBranch(
          id: 'terran_deny_expansion',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 저그 확장을 차단합니다! 4가스를 안 주겠다는 의지!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home}, 확장 기지를 부숩니다! 저그 가스를 끊습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 가스가 부족합니다! 고급 유닛 생산이 어려워요!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 이레디에이트로 핵심 유닛을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'strategy',
              altText: '{home} 선수 이레디에이트 적중! 저그 핵심 유닛이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '확장을 차단당한 저그! 결전의 순간입니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // ----- 분기 B: 다크스웜 밀어붙이기 -----
        ScriptBranch(
          id: 'defiler_push',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          conditionAwayBuildIds: [
            'zvt_trans_lurker_defiler', 'zvt_trans_ultra_hive',
            'zvt_trans_mutal_ultra', 'zvt_2hatch_lurker',
          ],
          events: [
            ScriptEvent(
              text: '{away} 선수 디파일러가 전선에 도착합니다! 다크스웜!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'strategy',
              altText: '{away}, 다크스웜! 테란 한방을 무력화합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 포격이 다크스웜에 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 다크스웜 속에서 탱크가 무용지물입니다!',
            ),
            ScriptEvent(
              text: '{away}, 스웜 속에서 럴커 저글링이 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -6, awayArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 다크스웜이 끊이질 않습니다! 럴커 저글링이 돌진합니다!',
            ),
            ScriptEvent(
              text: '다크스웜이 전선을 뒤덮었습니다! 결전의 순간!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // ----- 분기 C: 테란 바이오닉 총공격 -----
        ScriptBranch(
          id: 'terran_bionic_final',
          baseProbability: 1.0,
          conditionStat: 'attack',
          conditionHomeBuildIds: [
            'tvz_sk', 'tvz_4rax_enbe',
            'tvz_trans_bionic_push', 'tvz_trans_enbe_push',
            'tvz_111', 'tvz_trans_111_balance',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 멀티 포인트 공격! 저그 수비가 분산됩니다!',
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
              text: '{home}, 드랍십 견제와 정면 전진을 동시에! 저그가 대응 불가!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'sense',
              altText: '{home} 선수 드랍 + 정면 동시 공격!',
            ),
            ScriptEvent(
              text: '테란의 멀티 공격이 효과를 보고 있습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ----- 분기 D: 저그 물량 압도 -----
        ScriptBranch(
          id: 'zerg_mass_overwhelm',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리 풀가동! 저글링이 끝없이 쏟아져 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -20, favorsStat: 'macro',
              altText: '{away}, 다해처리 풀가동! 물량이 압도적!',
            ),
            ScriptEvent(
              text: '{away}, 정면과 후방을 동시에 공격합니다!',
              owner: LogOwner.away,
              homeArmy: -5, homeResource: -15, favorsStat: 'control',
              altText: '{away} 선수 양면 공격! 테란이 갈립니다!',
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
        // ----- 분기 E: 공중 제공권 결전 -----
        ScriptBranch(
          id: 'air_supremacy',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_2star_wraith', 'tvz_trans_wraith',
            'tvz_valkyrie', 'tvz_trans_valkyrie',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 남은 공중 병력 총동원! 최후의 공습!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 공중 편대 전원 출격!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 스커지 풀가동! 공중 결전입니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
              altText: '{away}, 뮤탈 스커지 총출동! 하늘의 승부!',
            ),
            ScriptEvent(
              text: '{home}, 공중 유닛이 뮤탈을 격추시킵니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 집중 사격! 공중 유닛을 격추합니다!',
            ),
            ScriptEvent(
              text: '{away}, 스커지가 자폭합니다! 상대 공중 유닛 격추!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 스커지 명중!',
            ),
            ScriptEvent(
              text: '제공권을 둘러싼 최후의 결전! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // ----- 분기 F: 대규모 교환전 (폴백) -----
        ScriptBranch(
          id: 'massive_trade',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 풀 병력이 정면에서 부딪칩니다! 대규모 교전!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 화력을 집중합니다! 저그 물량을 쓸어내지만 끝이 없습니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 화력 집중! 하지만 저그 물량이 끝이 없습니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 후방을 물어뜯으면서 정면에서도 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -5, homeResource: -15, awayArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 정면과 후방 동시 공격! 테란이 갈립니다!',
            ),
            ScriptEvent(
              text: '양측 병력이 크게 소모됩니다! 결전의 순간!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
