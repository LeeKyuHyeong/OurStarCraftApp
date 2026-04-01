part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. 스탠다드 T vs 노풀 3해처리 (오프닝 매칭 + 트랜지션 분기)
// 기존: double_vs_3hatch, 111_vs_macro 통합
// ----------------------------------------------------------
const _tvzStandardVs3Hatch = ScenarioScript(
  id: 'tvz_standard_vs_3hatch',
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
    'zvt_3hatch_nopool',
    'zvt_trans_ultra_hive',
  ],
  description: '스탠다드 테란 vs 노풀 3해처리 매크로전',
  phases: [
    // ============================================================
    // Phase 0: 3해처리 오프닝 (lines 1-16)
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
          text: '{away} 선수 해처리를 올립니다! 앞마당 확장!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리까지! 노풀로 3해처리입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 풀도 안 짓고 해처리 3개! 확장에 올인합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론만 뽑고 있습니다. 스포닝풀이 없어 저글링도 못 뽑아요!',
          owner: LogOwner.away,
          awayResource: 15,
          altText: '{away}, 드론 풀가동! 노풀이라 수비 유닛이 없습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 모아서 앞마당을 찌릅니다! 노풀이라 수비 유닛이 없어요!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home}, 마린이 앞마당으로! 수비 유닛이 없는 저그를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막아봅니다! 하지만 드론이 죽으면 자원 손해가 크죠!',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'defense',
          altText: '{away}, 드론으로 마린을 둘러쌉니다! 일꾼 피해가 나오고 있어요!',
        ),
      ],
    ),
    // ============================================================
    // Phase 1: 마린 압박 + 내정 확장 (lines 17-28)
    // ============================================================
    ScriptPhase(
      name: 'macro_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 뒤늦게 스포닝풀 건설합니다. 노풀이었으니까요.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 이제야 스포닝풀이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링과 성큰으로 마린을 밀어냅니다!',
          owner: LogOwner.away,
          awayArmy: 3, homeArmy: -1, awayResource: -10, favorsStat: 'defense',
          altText: '{away}, 성큰 완성! 마린 압박은 막았지만 자원을 쓸 수밖에 없었죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 테크를 올리기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 가스를 넣으면서 테크 건설 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 3해처리 풀가동! 드론 30기 넘어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: 25,
          altText: '{away}, 해처리 3개에서 드론이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '자원 차이가 벌어지고 있습니다. 테란이 빨리 움직여야 할 텐데요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // ============================================================
    // Phase 2: 트랜지션 분기 (lines 29-42)
    // ============================================================
    ScriptPhase(
      name: 'transition_branch',
      startLine: 29,
      branches: [
        // ----- 분기 A: 바이오닉 압박 -----
        ScriptBranch(
          id: 'bionic_pressure',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_sk', 'tvz_4rax_enbe',
            'tvz_trans_bionic_push', 'tvz_trans_enbe_push',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 배럭 추가! 아카데미에 스팀팩 연구까지!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
              altText: '{home}, 바이오닉 체제 완성! 스팀팩까지!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕 편대가 전진합니다! 3해처리를 안 주겠다는 의지!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'attack',
              altText: '{home}, 마린 메딕이 앞마당을 압박합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링으로 막지만 마린 메딕 스팀팩에 녹습니다!',
              owner: LogOwner.away,
              awayArmy: -2, homeArmy: -1, favorsStat: 'defense',
              altText: '{away}, 저글링이 스팀팩 마린에 맞서지만 힘듭니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰 추가 건설! 레어 진화도 시작합니다.',
              owner: LogOwner.away,
              awayResource: -20, awayArmy: 2,
              altText: '{away}, 성큰을 더 지으면서 레어를 올립니다!',
            ),
            ScriptEvent(
              text: '노풀 3해처리의 약점이 드러납니다! 초반 수비 유닛이 부족했죠!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 B: 111 레이스 정찰 -----
        ScriptBranch(
          id: 'one_one_one_scout',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_111', 'tvz_trans_111_balance',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리에 머신샵 부착! 스타포트까지! 111 체제입니다.',
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
              text: '오버로드 손실이 뼈아픕니다. 저그 자원에 타격이 가는데요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 C: 메카닉 빌드업 -----
        ScriptBranch(
          id: 'mech_buildup',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_3fac_goliath', 'tvz_trans_mech_goliath',
            'tvz_valkyrie', 'tvz_trans_valkyrie',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 팩토리 증설! 본격적인 메카닉 체제입니다.',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -25,
              altText: '{home}, 팩토리 2개째 올라갑니다! 메카닉 가동!',
            ),
            ScriptEvent(
              text: '{home}, 아머리 건설! 골리앗 생산 시작!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 레어 진화에 스파이어 건설! 3해처리 물량이 뒷받침됩니다!',
              owner: LogOwner.away,
              awayResource: -25, favorsStat: 'macro',
              altText: '{away}, 레어에서 스파이어까지! 뮤탈 준비에 들어갑니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크 등장! 3해처리라 물량이 두텁습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 뮤탈이 나옵니다! 3해처리의 물량이 빛나네요!',
            ),
            ScriptEvent(
              text: '3해처리의 물량이 빛나는 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 D: 레이스 빌드업 -----
        ScriptBranch(
          id: 'wraith_buildup',
          baseProbability: 1.0,
          conditionHomeBuildIds: [
            'tvz_2star_wraith', 'tvz_trans_wraith',
          ],
          events: [
            ScriptEvent(
              text: '{home} 선수 스타포트 건설! 레이스를 노립니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 스타포트가 올라갑니다!',
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스가 저그 본진으로 침투합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 클로킹! 레이스가 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 오버로드 격추! 서플라이가 막히는데요!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 대공이 없습니다! 드론이 당하고 있어요!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 오버로드도 빠지고 드론도 당합니다!',
            ),
            ScriptEvent(
              text: '레이스 견제가 효과적입니다! 3해처리의 약점이 드러나네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ----- 분기 E: 폴백 일반 전개 -----
        ScriptBranch(
          id: 'generic_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 정찰로 스파이어를 확인합니다! 터렛을 미리 건설해두는군요!',
              owner: LogOwner.home,
              homeResource: -15, favorsStat: 'scout',
              altText: '{home}, 스파이어를 읽었습니다! 터렛을 선제 배치!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크 등장! 3해처리라 물량이 두텁습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 뮤탈이 나옵니다! 하지만 터렛이 이미 깔려있어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 견제하면서 저글링 물량을 모읍니다.',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 병력을 모아서 전진 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
            ),
            ScriptEvent(
              text: '중반 전개가 본격화됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // ============================================================
    // Phase 3: 럴커 베슬 빌드업 (lines 43-58)
    // ============================================================
    ScriptPhase(
      name: 'army_buildup',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트에 컨트롤타워! 사이언스 퍼실리티까지 올립니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 스타포트 컨트롤타워에 사이언스 퍼실리티! 고급 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴에서 럴커 변태! 저글링 뮤탈 럴커 조합입니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -25,
          altText: '{away}, 럴커 전환! 테란 전진을 막아서겠다는 의도!',
        ),
        ScriptEvent(
          text: '{home}, 사이언스 베슬 생산! 이레디에이트 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수 베슬이 나옵니다! 럴커를 잡을 핵심 유닛이죠!',
        ),
        ScriptEvent(
          text: '{away} 선수 스커지를 생산합니다! 베슬을 잡아야 럴커가 살 수 있죠!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 스커지 생산! 베슬을 향해 돌진 준비!',
        ),
        ScriptEvent(
          text: '{away}, 하이브 진화! 디파일러 마운드 건설 시작합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away} 선수 하이브에서 디파일러 마운드까지! 다크스웜 준비!',
        ),
        ScriptEvent(
          text: '럴커 스커지 디파일러 조합에 가스가 빠르게 빠지고 있습니다! 4가스를 먹어야 유지가 됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 한방 병력이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -15, favorsStat: 'macro',
          altText: '{home}, 한방 병력이 완성되어 갑니다!',
        ),
      ],
    ),
    // ============================================================
    // Phase 4: 스커지 vs 베슬 + 확장 전쟁 (lines 59-74)
    // ============================================================
    ScriptPhase(
      name: 'vessel_scourge',
      startLine: 59,
      branches: [
        // 분기 A: 베슬이 스커지를 피함 → 이레디에이트 성공
        ScriptBranch(
          id: 'vessel_survives',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 스커지가 베슬을 향해 돌진합니다!',
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
              text: '{home}, 이레디에이트! 럴커를 녹입니다! 베슬이 살아있으니까요!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'strategy',
              altText: '{home} 선수 이레디에이트 적중! 럴커가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '베슬이 살아있으면 럴커를 잡을 수 있습니다! 스커지 요격이 실패했어요!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 스커지가 베슬을 잡음 → 저그 4가스 확보
        ScriptBranch(
          id: 'scourge_kills_vessel',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 스커지가 베슬에 적중합니다! 베슬이 터집니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'control',
              altText: '{away}, 스커지 명중! 베슬이 떨어졌습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 베슬을 잃었습니다! 럴커를 잡을 수가 없어요!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 네 번째 확장을 올립니다! 4가스 체제!',
              owner: LogOwner.away,
              awayResource: 20, favorsStat: 'macro',
              altText: '{away}, 4번째 해처리! 가스가 넉넉해집니다!',
            ),
            ScriptEvent(
              text: '4가스 저그는 럴커 스커지 디파일러를 계속 뽑아낼 수 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 C: 테란 드랍 견제
        ScriptBranch(
          id: 'terran_drop_raid',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 마린 메딕을 태워 본진을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'harass',
              altText: '{home}, 드랍십 출격! 저그 본진을 찌릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 드랍십을 쫓습니다! 하지만 이미 투하를 시작했어요!',
              owner: LogOwner.away,
              awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 드랍을 늦게 발견했습니다! 일꾼 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 일꾼을 솎아냅니다! 가스 일꾼도 날아갔어요!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '가스 일꾼이 날아가면 럴커 스커지 디파일러 조합 유지가 안 됩니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // ============================================================
    // Phase 5: 결전 (lines 75-90)
    // ============================================================
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 75,
      branches: [
        // 분기 A: 테란 4가스 차단 → 저그 가스 고갈
        ScriptBranch(
          id: 'terran_deny_expansion',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 네 번째 확장을 차단합니다! 4가스를 안 주겠다는 의지!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home}, 확장 기지를 부숩니다! 저그 4가스를 막았습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커도 뽑아야 하고 스커지도 뽑아야 하고 디파일러까지! 3가스로는 돌아가질 않습니다!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 이레디에이트로 디파일러를 잡아냅니다! 저그 가스에 큰 타격!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'strategy',
              altText: '{home}, 베슬 이레디! 디파일러가 녹습니다!',
            ),
            ScriptEvent(
              text: '가스가 말라버린 저그! 결전의 순간입니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 디파일러 다크스웜으로 밀어붙이기
        ScriptBranch(
          id: 'defiler_push',
          baseProbability: 1.0,
          conditionStat: 'strategy',
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
              text: '{away}, 4가스 저그는 디파일러를 계속 뽑아냅니다! 스웜 속에서 럴커 저글링이 돌진!',
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
        // 분기 C: 대규모 교환전 (양측 소모 → 병력 우세 승)
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
              text: '{home} 선수 베슬 이레디로 럴커를 잡습니다! 하지만 정면이 뚫리는데요!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -4, favorsStat: 'strategy',
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
