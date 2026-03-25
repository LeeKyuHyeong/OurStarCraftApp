part of 'scenario_scripts.dart';

// ============================================================
// TvZ 시나리오 스크립트
// ============================================================
// 모든 스크립트는 startLine: 1 부터 시작하여
// 빌드오더 텍스트 없이 시나리오가 경기 전체를 담당합니다.
// ============================================================

// ----------------------------------------------------------
// 1. 바이오 러시 vs 뮤탈 (가장 대표적인 TvZ)
// ----------------------------------------------------------
const _tvzBioVsMutal = ScenarioScript(
  id: 'tvz_bio_vs_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk', 'tvz_4rax_enbe', 'tvz_trans_bionic_push', 'tvz_trans_enbe_push'],
  awayBuildIds: ['zvt_2hatch_mutal', 'zvt_3hatch_mutal',
                 'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra'],
  description: '바이오닉 러시 vs 뮤탈리스크',
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
          text: '{home} 선수 배럭을 추가합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.2,
          altText: '{home}, 배럭 하나 더 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아카데미가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 메딕 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 스팀팩 연구!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 조합이 갖춰졌습니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home}, 마린 메딕 완성! 스팀팩까지 달렸습니다!',
        ),
      ],
    ),
    // Phase 1: 전개 (lines 17-24)
    ScriptPhase(
      name: 'deployment',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 메딕 편대가 맵 중앙으로 이동합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 병력을 모아서 전진 준비! 중앙을 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산하면서 레어 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away} 선수 가스 넣으면서 레어 테크 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 저글링 깔아놓고 스파이어 올립니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 스파이어가 올라가고 있습니다! 뮤탈 타이밍이 다가옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵 부착까지 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 팩토리에 머신샵! 시즈 탱크 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설 시작합니다.',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 접촉 - 분기 (lines 25-34)
    ScriptPhase(
      name: 'first_contact',
      startLine: 25,
      branches: [
        // 분기 A: 마린 메딕 앞마당 압박 성공
        ScriptBranch(
          id: 'terran_push_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 앞마당으로 전진합니다! 스팀팩 ON!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              altText: '{home}, 스팀팩 밟고 앞마당 압박! 마린이 드론을 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 대응이 늦습니다! 성큰 뒤에서 버텨보지만!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
              altText: '{away}, 앞마당 드론 피해가 큽니다! 대응이 늦었어요!',
            ),
            ScriptEvent(
              text: '{away}, 앞마당 드론이 큰 피해를 입었습니다! 가까스로 성큰으로 마린을 밀어냅니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away} 선수 앞마당이 초토화! 겨우 막아냈지만 자원 손실이 크네요!',
            ),
            ScriptEvent(
              text: '마린 메딕 압박이 효과적이었습니다! 뮤탈 타이밍이 밀리겠는데요.',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
            ScriptEvent(
              text: '{home}, 추가 마린 합류! 이 타이밍을 놓치지 않습니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 앞마당 피해를 준 뒤 후속 병력까지 합류합니다!',
            ),
          ],
        ),
        // 분기 B: 뮤탈 빠른 등장
        ScriptBranch(
          id: 'zerg_fast_mutal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 전진하는데, 저글링 무리를 뚫어야 합니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크 등장! 빠른 타이밍입니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'control',
              altText: '{away} 선수 뮤탈이 떴습니다! 절묘한 타이밍이구요!',
            ),
            ScriptEvent(
              text: '{away} 뮤탈이 바로 SCV 라인을 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크 컨트롤! 일꾼 라인 초토화!',
            ),
            ScriptEvent(
              text: '{home} 선수 급히 터렛 올리면서 전진을 멈춥니다!',
              owner: LogOwner.home,
              homeResource: -15,
            ),
          ],
        ),
        // 분기 C: 저글링 기습
        ScriptBranch(
          id: 'zerg_ling_ambush',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 맵 중앙을 지나는 순간! 저글링 매복에 걸립니다!',
              owner: LogOwner.home,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{home}, 이동 중 저글링 서라운드에 걸렸습니다!',
            ),
            ScriptEvent(
              text: '{away}, 매복 저글링이 서라운드! 상대 병력을 감싸 안습니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 저글링 컨트롤! 마린을 감싸 안습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 메딕만 남았습니다! 급히 후퇴!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home}, 전진 실패! 병력 손실이 크네요!',
            ),
            ScriptEvent(
              text: '마린 메딕 전진이 좌절됐습니다! 테란이 수비 체제로 전환해야 합니다.',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 D: 스파이어 발견
        ScriptBranch(
          id: 'terran_scout_spire',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 정찰 SCV가 스파이어를 발견했습니다! 빠른 대비!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 정찰 성공! 뮤탈 준비를 미리 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 터렛을 미리 건설합니다! 뮤탈에 대비하는 모습!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 일꾼 라인에 터렛 선제 건설! 철벽 수비!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 나왔지만 터렛에 막힙니다! 견제 효과가 반감!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
              altText: '{away}, 뮤탈 등장! 하지만 터렛이 이미 깔려있어요!',
            ),
            ScriptEvent(
              text: '{home}, 터렛 덕분에 전진을 유지합니다! 탱크까지 합류!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -15, favorsStat: 'attack',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 35-50)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 35,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 압박을 이어가면서 팩토리를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home} 선수 팩토리 건설! 탱크 테크를 올리는군요!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산 들어갑니다! 팩토리 가동!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          skipChance: 0.2,
          altText: '{home}, 첫 시즈 탱크가 나옵니다! 화력이 보강되네요!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크로 견제하면서 저글링 물량을 모읍니다.',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15,
          altText: '{away} 선수 뮤탈 견제와 동시에 저글링 대량 생산!',
        ),
        ScriptEvent(
          text: '{home}, 마린 메딕 탱크 조합으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home} 선수 시즈 탱크 모드 전환! 전진 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 달려나옵니다! 탱크 라인을 노리는데요!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -3, favorsStat: 'control',
          altText: '{away}, 발업 저글링 돌진! 시즈 라인 돌파 시도!',
        ),
        ScriptEvent(
          text: '양측 병력 교환이 일어나고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 마인 매설! 저글링 이동 경로를 차단합니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'strategy',
          skipChance: 0.3,
          requiresMapTag: 'terrainHigh',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로 후방 일꾼을 계속 물어뜯습니다!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'harass',
          altText: '{away} 선수 뮤탈 기동! 본진 일꾼을 또 물어뜯습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워 부착에 사이언스 퍼실리티까지!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스타포트 컨트롤타워 사이언스 퍼실리티! 고급 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 테크를 올리면서 디파일러 마운드 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 하이브 완성! 디파일러 마운드까지!',
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 51-65)
    ScriptPhase(
      name: 'transition',
      startLine: 51,
      branches: [
        // 분기 A: 테란 타이밍 공격
        ScriptBranch(
          id: 'terran_timing_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 사이언스 퍼실리티 완성! 사이언스베슬이 합류합니다! 이레디에이트 준비!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 이레디에이트! 뭉쳐있던 뮤탈리스크에 연쇄 피해!',
              owner: LogOwner.home,
              awayArmy: -8, favorsStat: 'strategy',
              altText: '{home} 선수 이레디에이트가 작렬! 뮤탈 편대를 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 산개! 하지만 이미 3기가 떨어졌습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 산개가 늦었습니다! 뭉쳐있던 뮤탈이 큰 피해를 입었어요!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈을 빼면서 급히 럴커 전환을 시도합니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 그 틈을 놓치지 않습니다! 앞마당 압박!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 전진! 상대 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '테란 타이밍이 절묘하게 맞아 떨어지고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 저그 물량 전환
        ScriptBranch(
          id: 'zerg_macro_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 3번째 해처리 올립니다! 자원이 터지기 시작하는데요!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: 30,
            ),
            ScriptEvent(
              text: '{away}, 럴커 변태 시작! 럴커가 앞마당 입구에 자리잡습니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 럴커 포진! 방어선 구축!',
            ),
            ScriptEvent(
              text: '{home} 선수 전진이 막힙니다! 럴커를 못 잡고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -3, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away}, 그 사이 디파일러 테크! 다크스웜이 준비됩니다!',
              owner: LogOwner.away,
              awayResource: -25,
              skipChance: 0.2,
            ),
            ScriptEvent(
              text: '저그의 물량이 점점 테란을 압도하기 시작합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 테란 드랍십 견제
        ScriptBranch(
          id: 'terran_dropship_raid',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 마린 메딕을 태웁니다! 후방을 노리는 건가요?',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -20, favorsStat: 'strategy',
              altText: '{home}, 드랍십 출발! 저그 멀티를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 드랍! 저그 세 번째 해처리에 마린이 내립니다! 드론이 당합니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'strategy',
              altText: '{home} 선수 드랍 성공! 일꾼 라인 초토화!',
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
              text: '드랍십 견제가 판을 뒤집고 있습니다! 저그가 양쪽을 다 막기 어려운 상황!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 - 분기 (lines 66-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 66,
      branches: [
        // 분기 A: 정면 전면전 (기본)
        ScriptBranch(
          id: 'standard_clash',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 총공격 준비! 남은 병력을 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 8, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 저글링 뮤탈 럴커 총동원! 전면전 준비!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -25,
              altText: '{away}, 뮤탈 럴커 저글링 풀가동! 병력을 최대한 모읍니다!',
            ),
            ScriptEvent(
              text: '양측 풀 병력 전면전이 시작됩니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕이 앞에서 탱크가 뒤에서! 바이오닉 탱크 조합 총공격!',
              owner: LogOwner.home,
              awayArmy: -25, homeArmy: -12, favorsStat: 'attack',
              altText: '{home} 선수 바이오닉 + 탱크 화력! 저그 병력이 쓸려나갑니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 마린 대열을 뚫고 들어갑니다! 메딕이 쓰러지고 있어요!',
              owner: LogOwner.away,
              homeArmy: -20, awayArmy: -10, favorsStat: 'control',
              altText: '{away} 선수 저글링이 마린 뒤로 파고듭니다! 메딕부터 잡습니다!',
            ),
            ScriptEvent(
              text: '결정적인 순간입니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 디파일러 다크스웜
        ScriptBranch(
          id: 'defiler_darkswarm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 디파일러가 전선에 합류합니다! 다크스웜 준비!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -25, favorsStat: 'strategy',
              altText: '{away}, 디파일러 등장! 전장의 흐름이 바뀔 수 있습니다!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜! 시즈 탱크 포격이 완전히 무력화됩니다!',
              owner: LogOwner.away,
              homeArmy: -10, favorsStat: 'strategy',
              altText: '{away} 선수 다크스웜 깔아줍니다! 포격을 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 이레디에이트로 디파일러를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeResource: -15,
              altText: '{home}, 사이언스베슬이 이레디를 쏩니다! 하지만 스웜은 이미 깔렸습니다!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜 속에서 럴커 저글링이 돌진합니다! 마린이 쏟아져 나가요!',
              owner: LogOwner.away,
              homeArmy: -18, awayArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 스웜 속 럴커가 작렬! 상대 병력을 녹여냅니다!',
            ),
            ScriptEvent(
              text: '다크스웜이 전장을 뒤덮었습니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 최후의 드랍 올인
        ScriptBranch(
          id: 'last_drop_allin',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 정면이 불리합니다! 드랍십이 마지막으로 출격합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'sense',
              altText: '{home}, 최후의 승부수! 드랍 올인!',
            ),
            ScriptEvent(
              text: '{home}, 본진 드랍! 해처리를 직접 노립니다!',
              owner: LogOwner.home,
              awayResource: -30, favorsStat: 'sense',
              altText: '{home} 선수 기습 드랍! 저그 본진이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진이 불타고 있습니다! 뮤탈이 급히 돌아오는데요!',
              owner: LogOwner.away,
              awayArmy: -10,
              altText: '{away}, 본진 드론이 당합니다! 뮤탈이 돌아올 수 있을까요!',
            ),
            ScriptEvent(
              text: '{away}, 정면에서 남은 병력 총공격! 테란 본진도 불탑니다!',
              owner: LogOwner.away,
              homeArmy: -15, awayArmy: -8, favorsStat: 'attack',
              altText: '{away} 선수 정면 돌파! 서로 본진이 무너지고 있습니다!',
            ),
            ScriptEvent(
              text: '양측 본진이 불타고 있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 2. 메카닉 vs 럴커/디파일러 (장기전)
// ----------------------------------------------------------
const _tvzMechVsLurker = ScenarioScript(
  id: 'tvz_mech_vs_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_3fac_goliath', 'tvz_valkyrie', 'tvz_trans_mech_goliath', 'tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_2hatch_lurker', 'zvt_1hatch_allin', 'zvt_trans_lurker_defiler', 'zvt_trans_530_mutal', 'zvt_trans_ultra_hive'],
  description: '메카닉 vs 럴커/디파일러 장기전',
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
          text: '{away} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 드론 생산에 집중하고 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.2,
          altText: '{away}, 앞마당 확장! 확장을 가져가려는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵까지! 메카닉 테크로 가는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리에 머신샵! 메카닉 테크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 유닛 생산이 시작됩니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 첫 메카닉 유닛이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 넣으면서 테크를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스 채취 시작! 상위 테크 준비!',
        ),
      ],
    ),
    // Phase 1: 내정 확장 (lines 17-28)
    ScriptPhase(
      name: 'buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 증설! 본격적인 메카닉 체제입니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 팩토리 2개째 올라갑니다! 메카닉 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라 생산 시작합니다. 가스 비중을 높이는 모습이구요.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 히드라리스크 뽑기 시작! 수비 준비!',
        ),
        ScriptEvent(
          text: '{home}, 아머리 건설! 골리앗 1기 생산! 대공까지 가능한 조합이구요.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 완성! 럴커 변태가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 럴커 아스펙트 연구 들어갑니다!',
        ),
        ScriptEvent(
          text: '양측 모두 내정에 집중하는 모습입니다. 아직은 고요하구요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 사이언스 퍼실리티까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타포트에서 사이언스 퍼실리티까지! 고급 테크!',
        ),
      ],
    ),
    // Phase 2: 럴커 포진 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'lurker_positioning',
      startLine: 29,
      branches: [
        ScriptBranch(
          id: 'terran_scan_lurker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 4기 완성! 앞마당 입구에 매복시킵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
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
              text: '{away} 선수 럴커가 당했습니다! 수비 라인에 구멍이 생겼는데요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '테란의 정찰이 빛나는 순간이었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_lurker_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 포진! 입구를 완벽하게 틀어막습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 럴커 매복! 완벽한 위치선정입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 전진하는데... 럴커에 마린이 녹습니다!',
              owner: LogOwner.home,
              homeArmy: -4, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 급히 후퇴! 시즈 탱크를 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home} 선수 전진을 멈추고 탱크를 앞세웁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 세 번째 해처리! 자원이 돌아가기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 25,
            ),
            ScriptEvent(
              text: '럴커 수비가 완벽했습니다. 저그가 시간을 벌었네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중후반 전투 (lines 43-60)
    ScriptPhase(
      name: 'mid_late_battle',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 대량 생산! 5팩토리 풀가동입니다!',
          owner: LogOwner.home,
          homeArmy: 8, homeResource: -30, favorsStat: 'macro',
          altText: '{home}, 골리앗 물량이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away}, 하이브 완성! 디파일러 마운드 건설하면서 다크스웜 연구 들어갑니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away} 선수 하이브에서 디파일러 마운드까지! 다크스웜 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 골리앗 조합으로 전진!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away}, 다크스웜 깔아줍니다! 탱크 포격이 무력화됩니다!',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          altText: '{away} 선수 다크스웜! 포격을 완전히 무력화시킵니다!',
        ),
        ScriptEvent(
          text: '{home}, 사이언스 베슬 이레디에이트! 디파일러를 노립니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'strategy',
          altText: '{home} 선수 이레디! 디파일러 잡을 수 있을까요!',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '다크스웜 속에서 치열한 접전이 벌어지고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 61-72)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 61,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 울트라리스크 캐번에서 울트라리스크 등장! 전면전 태세입니다!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -30,
          altText: '{away}, 울트라리스크 캐번 완성! 울트라가 나왔습니다!',
        ),
        ScriptEvent(
          text: '{home}, 골리앗 편대로 맞섭니다! 화력전입니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away}, 울트라 저글링 돌진! 탱크 라인 정면 돌파!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -4, favorsStat: 'attack',
          altText: '{away} 선수 울트라가 탱크 라인을 뚫습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗이 울트라를 집중 포화!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -3, favorsStat: 'defense',
          altText: '{home}, 골리앗 화력으로 울트라를 잡아냅니다!',
        ),
      ],
    ),
    // Phase 5: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 73,
      branches: [
        ScriptBranch(
          id: 'terran_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗 화력이 울트라를 잡아냈습니다! 메카닉 라인 유지!',
              owner: LogOwner.home,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '메카닉 화력이 저그를 밀어냅니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 울트라가 탱크 라인을 완전히 뚫었습니다! 저그 물량이 밀려옵니다!',
              owner: LogOwner.away,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '저그 물량이 메카닉을 압도합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 3. 치즈 vs 스탠다드 (초반 승부)
// ----------------------------------------------------------
const _tvzCheeseVsStandard = ScenarioScript(
  id: 'tvz_cheese_vs_standard',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_12pool', 'zvt_12hatch'],
  description: '센터 8배럭 벙커 vs 스탠다드 저그',
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
          text: '{away} 선수 해처리에서 드론을 뽑고 있습니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.3,
          altText: '{away}, 스포닝풀 건설합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 15-21)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터 배럭에서 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          altText: '{home}, 센터 배럭 마린 2기! 본진에서도 마린이 나오고 있구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 끌고 상대 진영으로 이동합니다!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'attack',
          altText: '{home}, SCV 4기가 마린과 함께 출발합니다! 공격적인데요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산에 집중하는 중인데... 발견할 수 있을까요?',
          owner: LogOwner.away,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 정찰 SCV가 상대 앞마당에 도착! 벙커 자리를 잡습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 앞마당에 벙커 건설 시작합니다!',
        ),
      ],
    ),
    // Phase 2: 발견 여부 분기 (lines 22-30)
    ScriptPhase(
      name: 'detection',
      startLine: 22,
      branches: [
        ScriptBranch(
          id: 'zerg_detects_bunker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 오버로드가 SCV를 포착했습니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{away}, 드론 모아서 SCV를 쫓아냅니다! 벙커 건설 방해!',
              owner: LogOwner.away,
              homeArmy: -1,
              altText: '{away} 선수 드론으로 SCV 견제! 벙커를 못 짓게 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 올라가지 않습니다! 플랜이 흔들리는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 성큰 완성! 완벽한 대응입니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 성큰 올리면서 마린을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 벙커 전략을 간파합니다! 완벽한 대응!',
              owner: LogOwner.away,
            ),
            ScriptEvent(
              text: '벙커 러시가 실패했습니다! GG!',
              owner: LogOwner.system,
              homeArmy: -4, homeResource: -20,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bunker_complete',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 건설 성공! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'control',
              altText: '{home}, 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 발견! 저글링으로 대응하려 하는데요!',
              owner: LogOwner.away,
              awayArmy: 3,
            ),
            ScriptEvent(
              text: '{home}, SCV 수리! 벙커가 버티고 있습니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home} 선수 SCV 수리 컨트롤! 벙커를 살립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 벙커를 뚫지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -1,
              altText: '{away}, 저글링 피해만 커지고 있습니다!',
            ),
            ScriptEvent(
              text: '{home}, 추가 마린 도착! 벙커 압박 강화!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 압박이 거세집니다! GG!',
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
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_mass_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 하이브 완성! 울트라리스크가 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -30,
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
              text: '저그의 물량이 승부를 가르고 있습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 5. 투스타 레이스 vs 뮤탈 (공중전)
// ----------------------------------------------------------
const _tvzWraithVsMutal = ScenarioScript(
  id: 'tvz_wraith_vs_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_2star_wraith', 'tvz_trans_wraith'],
  awayBuildIds: ['zvt_2hatch_mutal', 'zvt_3hatch_mutal',
                 'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra'],
  description: '투스타 레이스 vs 뮤탈리스크 공중전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 앞마당 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 일찍 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착! 테크를 서두르고 있습니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다! 빠른 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산하면서 레어 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 공중 유닛을 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 건설 준비! 뮤탈 타이밍이 다가옵니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 테크 빌드업 (lines 17-24)
    ScriptPhase(
      name: 'tech_buildup',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 공중 테크로 갑니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 레이스 생산을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 저글링 깔아놓습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 가스 넣고 레어 테크 올리는 중입니다.',
        ),
        ScriptEvent(
          text: '{home}, 레이스 1기 생산! 클로킹 연구도 시작합니다!',
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
      ],
    ),
    // Phase 2: 레이스 견제 vs 뮤탈 등장 - 분기 (lines 25-36)
    ScriptPhase(
      name: 'air_first_contact',
      startLine: 25,
      branches: [
        ScriptBranch(
          id: 'wraith_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 레이스가 저그 본진으로 침투합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
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
              text: '레이스 견제가 효과적입니다! 뮤탈 타이밍이 크게 밀리겠는데요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'mutal_fast_response',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 빠르게 등장합니다! 레이스를 쫓아갑니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'control',
              altText: '{away}, 뮤탈 타이밍이 절묘합니다! 레이스를 견제하러 갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 뮤탈에 쫓기고 있습니다! 수적 열세!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 레이스가 열세입니다! 뮤탈 물량에 밀려요!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 바로 SCV 라인을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 기동! 일꾼부터 노립니다!',
            ),
            ScriptEvent(
              text: '뮤탈 물량에 레이스가 밀리기 시작합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 공중전 본격화 (lines 37-50)
    ScriptPhase(
      name: 'air_battle',
      startLine: 37,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 추가 생산! 편대가 두꺼워집니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 레이스 3기째 나옵니다! 공중 화력이 강해지고 있어요!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크로 SCV 라인을 물어뜯습니다!',
          owner: LogOwner.away,
          homeResource: -20, favorsStat: 'harass',
          altText: '{away} 선수 뮤짤! 일꾼 라인이 초토화!',
        ),
        ScriptEvent(
          text: '{home}, 레이스가 뮤탈을 쫓아갑니다! 공중 추격전!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤! 뮤탈을 하나씩 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스커지 생산! 레이스를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayResource: -15, favorsStat: 'strategy',
          altText: '{away}, 스커지가 레이스에 돌진합니다!',
        ),
        ScriptEvent(
          text: '공중에서 치열한 전투가 벌어지고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛 보강하면서 뮤탈 견제에 대비합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 51-65)
    ScriptPhase(
      name: 'transition',
      startLine: 51,
      branches: [
        ScriptBranch(
          id: 'terran_ground_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 견제 유지하면서 지상 병력 전환!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home}, 아머리에서 골리앗 생산! 시즈 탱크와 합류합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home} 선수 지상 메카닉 합류! 화력이 두꺼워집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 견제하려 하지만 대공이 촘촘합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '레이스+지상 복합 편성! 테란의 전환이 빛나는 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_mutal_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 3해처리 풀가동! 뮤탈이 끝없이 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20, favorsStat: 'macro',
              altText: '{away}, 뮤탈 12기 돌파! 물량이 압도적!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 편대가 본진과 앞마당을 동시에 노립니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스만으로 막기 어렵습니다! 터렛이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 뮤탈 물량에 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 물량이 레이스를 압도하기 시작합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 전개 (lines 66-78)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 66,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 남은 공중 병력 총동원! 최후의 공습!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 레이스 편대 전원 출격!',
        ),
        ScriptEvent(
          text: '{away} 선수도 뮤탈 스커지 풀가동! 공중 결전입니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -20,
          altText: '{away}, 뮤탈 스커지 총출동! 하늘의 승부!',
        ),
        ScriptEvent(
          text: '양측 공중 병력이 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 레이스가 포격합니다! 뮤탈 편대를 격추시킵니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 레이스가 집중 사격! 공중 유닛을 격추합니다!',
        ),
        ScriptEvent(
          text: '{away}, 스커지가 자폭합니다! 상대 공중 유닛 격추!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -3, favorsStat: 'control',
          altText: '{away} 선수 스커지가 레이스를 잡아냅니다!',
        ),
      ],
    ),
    // Phase 6: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 79,
      branches: [
        ScriptBranch(
          id: 'terran_air_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스가 뮤탈을 제압했습니다! 제공권 장악!',
              owner: LogOwner.home,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '제공권을 장악합니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_air_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 물량이 레이스를 압도합니다! 저그의 하늘!',
              owner: LogOwner.away,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '공중 유닛 물량이 제공권을 차지합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 6. 치즈 vs 치즈: 벙커 vs 4풀 (극초반 승부)
// ----------------------------------------------------------
const _tvzCheeseVsCheese = ScenarioScript(
  id: 'tvz_cheese_vs_cheese',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_4pool'],
  description: '센터 8배럭 벙커 vs 4풀 극초반 승부',
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
          text: '{away} 선수 스포닝풀을 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 정말 빠르구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 일찍 보내고 있습니다.',
          owner: LogOwner.home,
          homeResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: 양쪽 올인 준비 (lines 12-16)
    ScriptPhase(
      name: 'dual_cheese_opening',
      startLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV가 일찍 센터로 이동합니다! 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, SCV가 벌써 센터로 나갔습니다! 빠른 배럭이구요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론 4기만에 스포닝풀 건설! 정말 빠릅니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 아주 일찍 올라갑니다! 공격적인 선택!',
        ),
        ScriptEvent(
          text: '양쪽 모두 초반 승부수를 띄웠습니다! 빠른 전개가 예상됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 서로 엇갈리는 공격 - 분기 (lines 17-26)
    ScriptPhase(
      name: 'cross_attack',
      startLine: 17,
      branches: [
        ScriptBranch(
          id: 'lings_hit_terran_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 6기 테란 본진에 도착합니다! 일꾼이 빠져있어요!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away} 선수 저글링이 텅 빈 본진에 도착! 일꾼이 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV를 끌고 나간 상태! 본진이 비어있습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 본진 SCV가 거의 없는 상황! 저글링이 마음껏 뜯습니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 남은 SCV를 잡아냅니다! 본진이 초토화!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -1, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '테란 본진이 큰 피해를 입고 있습니다! 하지만 저그 본진도 위험한데요!',
              owner: LogOwner.system,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_hits_zerg_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 SCV가 저그 앞마당에 도착! 벙커 건설 시작!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'control',
              altText: '{home}, 마린과 SCV가 저그 진영에 도착합니다! 벙커 올립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 4기뿐입니다! 저글링은 상대 본진으로 갔구요!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 저글링이 엇갈렸습니다! 본진에 병력이 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 벙커 건설 중! 드론으로 막으려 하지만 역부족입니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '서로 본진을 공격하는 상황! 누가 더 빨리 피해를 줄 수 있을까요!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 치즈 대결 결말 (lines 27-35)
    ScriptPhase(
      name: 'cheese_resolution',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'bunker_crushes_zerg',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -10, favorsStat: 'control',
              altText: '{home} 선수 벙커 완성시켰습니다! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론으로 막아보려 하지만 벙커 화력에 녹습니다!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -15,
              altText: '{away}, 드론이 벙커 앞에서 쓰러집니다! 자원이 바닥!',
            ),
            ScriptEvent(
              text: '{home}, 추가 마린 도착! 저그 본진을 완전히 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 압박이 성공했습니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'lings_destroy_terran',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 테란 본진 SCV를 전부 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'control',
              altText: '{away} 선수 저글링이 본진 일꾼을 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 돌아갈 자원이 없습니다! 본진이 괴멸했어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링까지 합류! 테란 앞마당도 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 저글링이 계속 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '본진이 무너졌습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 7. 9풀/9오버풀 vs 비치즈 테란 (초반 압박)
// ----------------------------------------------------------
const _tvz9poolVsStandard = ScenarioScript(
  id: 'tvz_standard_vs_9pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk', 'tvz_4rax_enbe', 'tvz_111', 'tvz_3fac_goliath',
                 'tvz_valkyrie', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_9pool', 'zvt_9overpool'],
  description: '스탠다드 테란 vs 9풀/9오버풀 초반 압박',
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
          text: '{away} 선수 스포닝풀을 일찍 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 빠릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산 시작! 빠르게 뽑고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -5,
          altText: '{away}, 저글링이 벌써 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린이 나오고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테란 오프닝 vs 빠른 저글링 (lines 14-20)
    ScriptPhase(
      name: 'early_pressure',
      startLine: 14,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 일찍 올라갑니다! 빠른 저글링 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 빠릅니다! 저글링을 일찍 뽑으려는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설 중인데... 저글링이 오고 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 발업 저글링 6기 출발! 상대 진영으로 달려갑니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15, favorsStat: 'attack',
          altText: '{away} 선수 발업 완료된 저글링이 달려나갑니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 도착 - 분기 (lines 21-32)
    ScriptPhase(
      name: 'ling_rush_response',
      startLine: 21,
      branches: [
        ScriptBranch(
          id: 'terran_scouted',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV 정찰로 9풀을 확인했습니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 정찰 성공! 빠른 풀을 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 벙커 건설! 저글링에 대비합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 도착하지만 벙커가 이미 있습니다!',
              owner: LogOwner.away,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{away}, 저글링 도착! 하지만 벙커에 막힙니다!',
            ),
            ScriptEvent(
              text: '정찰이 빛났습니다! 테란이 완벽하게 대비했네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'ling_rush_success',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away}, 발업 저글링이 진영 입구에 도착! 마린이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
              altText: '{away} 선수 저글링 기습! 테란이 대비를 못 했어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 1기뿐입니다! 저글링 물량을 막을 수 없어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, SCV까지 물어뜯습니다! 일꾼 피해가 크겠는데요!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 저글링이 일꾼 라인을 초토화!',
            ),
            ScriptEvent(
              text: '9풀 저글링 러시가 효과적입니다! 테란이 흔들리는데요!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 33-46)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 33,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 추가 생산! 수비를 안정시킵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 마린 물량이 쌓이기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 추가 생산하면서 앞마당을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 압박을 유지하면서 앞마당 건설!',
        ),
        ScriptEvent(
          text: '{home}, 벙커 건설! 저글링 진입로를 차단합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 테크 올립니다! 스파이어 건설 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 가스 넣고 레어 진화 시작! 스파이어 준비!',
        ),
        ScriptEvent(
          text: '초반 러시가 마무리되고 중반으로 넘어갑니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 47-62)
    ScriptPhase(
      name: 'late_development',
      startLine: 47,
      branches: [
        ScriptBranch(
          id: 'terran_recovers',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 일꾼 복구 완료! 병력 생산이 정상화됩니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 15, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕 조합으로 전진! 앞마당을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home} 선수 바이오닉 출진! 저그 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 9풀 이후 자원이 부족합니다! 테크가 느려요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '초반 올인 이후 자원 차이가 결정적입니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_leverages_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 등장! 초반 이득을 살립니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'strategy',
              altText: '{away}, 뮤탈이 떴습니다! 초반 피해를 발판으로!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 견제하면서 세 번째 해처리까지!',
              owner: LogOwner.away,
              awayResource: 20, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 초반 피해 복구가 안 되고 있습니다! 뮤탈까지!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 초반 저글링 피해에 뮤탈 견제까지! 이중고!',
            ),
            ScriptEvent(
              text: '초반 러시의 효과가 중반까지 이어집니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 8. 발키리 바이오닉 vs 뮤탈 (대공 특화)
// ----------------------------------------------------------
const _tvzValkyrieVsMutal = ScenarioScript(
  id: 'tvz_valkyrie_vs_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_valkyrie', 'tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_2hatch_mutal', 'zvt_3hatch_mutal',
                 'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra'],
  description: '발키리 대공 vs 뮤탈리스크',
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
          text: '{away} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 앞마당 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착하면서 테크를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리 머신샵! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산하면서 레어 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워 부착에 아머리까지!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 스타포트 컨트롤타워 아머리가 동시에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 올립니다! 뮤탈 준비!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 소량 뽑아두면서 방어 체제를 갖춥니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
          altText: '{home}, 마린 소량 생산! 수비 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 깔아놓으면서 버팁니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 테크를 올리면서 본격적인 대결을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 발키리 생산 vs 뮤탈 등장 (lines 17-26)
    ScriptPhase(
      name: 'valkyrie_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트에서 발키리 생산 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 발키리가 나옵니다! 대공 특화 유닛!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 3기 등장합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 뮤탈이 떴습니다! 견제를 나갈 텐데요.',
        ),
        ScriptEvent(
          text: '{home}, 마린 메딕도 생산하면서 복합 편성 준비!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈이 테란 본진을 정찰합니다! 발키리를 확인!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 뮤탈 정찰! 발키리를 확인했습니다!',
        ),
      ],
    ),
    // Phase 2: 뮤탈 견제 대응 - 분기 (lines 27-38)
    ScriptPhase(
      name: 'mutal_harass_response',
      startLine: 27,
      branches: [
        // 분기 A: 발키리 대공 성공
        ScriptBranch(
          id: 'valkyrie_counter_mutal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈이 SCV를 노리고 들어오는데! 발키리가 대응합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home}, 발키리 스플래시 데미지! 뭉쳐있던 뮤탈에 큰 피해!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'defense',
              altText: '{home} 선수 발키리가 범위 공격! 공중 유닛을 한꺼번에 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 산개! 하지만 이미 3기가 빠졌습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 뮤탈을 빼지만 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '발키리 대공이 빛나는 순간입니다! 뮤탈이 자유롭게 움직이지 못합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 뮤탈 소수 견제 후 물량전 전환
        ScriptBranch(
          id: 'mutal_avoid_valkyrie',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 발키리를 확인하고 뮤탈을 다른 곳으로 빼줍니다!',
              owner: LogOwner.away,
              favorsStat: 'strategy',
              altText: '{away}, 발키리를 피해서 앞마당 쪽으로 뮤탈 기동!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 발키리 없는 앞마당 SCV를 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 뮤짤! 앞마당이 비어있어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 달려오지만 이미 뮤탈이 빠졌습니다.',
              owner: LogOwner.home,
              homeResource: -5,
              altText: '{home}, 발키리 대응이 늦었습니다! SCV 피해가 크네요.',
            ),
            ScriptEvent(
              text: '뮤탈이 발키리를 피해 기동하면서 견제를 이어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 병력 운용 (lines 39-52)
    ScriptPhase(
      name: 'mid_game',
      startLine: 39,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 발키리 추가 생산! 골리앗도 섞어줍니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 발키리 골리앗 조합! 대공 화력이 엄청납니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로는 정면 교전이 불리합니다. 저글링 물량을 늘립니다.',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15,
          altText: '{away} 선수 뮤탈 대신 지상 물량으로 전환!',
        ),
        ScriptEvent(
          text: '{home}, 바이오닉과 발키리 복합 편성으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home} 선수 마린 메딕 발키리 출진! 저그 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈이 후방에서 견제하면서 저글링이 정면에서 막습니다!',
          owner: LogOwner.away,
          homeArmy: -2, awayArmy: -3, favorsStat: 'control',
          altText: '{away} 선수 뮤탈 견제와 저글링 수비 동시에!',
        ),
        ScriptEvent(
          text: '대공이 완벽한 테란 vs 기동성의 뮤탈! 어디서 교전하느냐가 관건입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 53-66)
    ScriptPhase(
      name: 'transition',
      startLine: 53,
      branches: [
        // 분기 A: 테란 발키리 밀어붙이기
        ScriptBranch(
          id: 'terran_valkyrie_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발키리 3기! 하늘을 완전히 장악합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'defense',
              altText: '{home}, 발키리 편대가 하늘을 지배합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 더 이상 견제를 나가지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 안전하게 확장하면서 화력을 키워갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: 15,
              altText: '{home} 선수 발키리 덕에 안정적! 멀티까지!',
            ),
            ScriptEvent(
              text: '대공 장악이 완벽합니다! 뮤탈이 갈 곳이 없네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 저그 럴커 전환
        ScriptBranch(
          id: 'zerg_lurker_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈이 막히니까 럴커로 전환합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -25, favorsStat: 'strategy',
              altText: '{away}, 히드라덴 건설! 럴커로 노선 변경!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 앞마당 입구에 포진! 발키리로는 못 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'defense',
              altText: '{away} 선수 럴커 매복! 지상에서 막겠다는 의도!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 지상은 못 치죠! 탱크를 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '발키리의 약점이 드러납니다. 지상 화력이 부족한 상황!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 전개 (lines 67-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 67,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 총 병력을 모읍니다! 바이오닉 발키리 탱크 복합!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -25,
          altText: '{home}, 최종 편성 완료! 공중 지상 모두 갖췄습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 남은 뮤탈과 저글링 럴커를 총동원합니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -20,
          altText: '{away}, 공중 지상 총출동! 전면전 준비!',
        ),
        ScriptEvent(
          text: '양측 풀 병력 전면전입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 발키리가 뮤탈을 잡고 마린이 저글링을 잡습니다! 체계적인 전투!',
          owner: LogOwner.home,
          awayArmy: -20, homeArmy: -10, favorsStat: 'attack',
          altText: '{home} 선수 발키리 대공 + 바이오닉 지상! 역할 분담이 완벽합니다!',
        ),
        ScriptEvent(
          text: '{away}, 럴커가 마린을 녹이고 저글링이 탱크를 덮칩니다!',
          owner: LogOwner.away,
          homeArmy: -18, awayArmy: -8, favorsStat: 'control',
          altText: '{away} 선수 럴커 저글링 합동! 바이오닉이 녹아내립니다!',
        ),
      ],
    ),
    // Phase 6: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 81,
      branches: [
        ScriptBranch(
          id: 'terran_complex_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발키리 탱크 복합이 저그를 제압합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '복합 편성의 위력! 승리를 거둡니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_overwhelms',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 럴커 저글링 물량이 테란 전선을 무너뜨립니다!',
              owner: LogOwner.away,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '물량이 상대를 압도합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 9. 배럭더블 vs 노풀 3해처리 (후반 매크로전)
// ----------------------------------------------------------
const _tvzDoubleVs3Hatch = ScenarioScript(
  id: 'tvz_double_vs_3hatch',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk'],
  awayBuildIds: ['zvt_3hatch_nopool'],
  description: '배럭더블 vs 노풀 3해처리 매크로전',
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
          text: '{away} 선수 해처리를 올립니다! 앞마당 확장!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 배럭! 배럭더블로 가는 모습입니다.',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 배럭 2개째! 투배럭 체제입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리까지! 노풀로 3해처리입니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 풀도 안 짓고 해처리 3개! 올인 매크로!',
        ),
        ScriptEvent(
          text: '양쪽 모두 눕는 빌드입니다! 매크로 대결이 예상되는데요.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 최대한 뽑고 있습니다. 자원이 쌓여가는 모습이구요.',
          owner: LogOwner.away,
          awayResource: 15,
          altText: '{away}, 드론 풀가동! 미네랄이 폭발적입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 내정 경쟁 (lines 17-28)
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
          text: '{home} 선수 앞마당 커맨드센터 건설! 배럭더블 이후 확장!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 커맨드센터가 올라갑니다! 테란도 확장을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 소량 생산하면서 가스를 넣습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣으면서 팩토리 건설! 머신샵 부착하고 탱크 테크를 올립니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리에 머신샵! 시즈 탱크 준비!',
        ),
        ScriptEvent(
          text: '양쪽 모두 내정에 집중하는 고요한 전개입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 3가스 타이밍 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'gas_timing',
      startLine: 29,
      branches: [
        // 분기 A: 테란 초반 소수 마린 압박
        ScriptBranch(
          id: 'terran_marine_poke',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 소수가 앞마당 정찰을 갑니다.',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'scout',
              altText: '{home}, 마린 4기가 정찰 나갑니다!',
            ),
            ScriptEvent(
              text: '{home}, 3해처리를 확인합니다! 일꾼 수가 엄청나네요!',
              owner: LogOwner.home,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰으로 마린을 밀어냅니다. 아직 저글링이 적습니다.',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
              altText: '{away}, 성큰이 마린을 잡아줍니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 3해처리를 확인하고 앞마당 가스를 안 주려고 합니다!',
              owner: LogOwner.home,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: 'TvZ의 핵심! 가스를 주느냐 마느냐가 승부를 결정합니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 저그 빠른 레어 진화
        ScriptBranch(
          id: 'zerg_fast_lair',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화 시작! 자원이 넉넉하니까요!',
              owner: LogOwner.away,
              awayResource: -20, favorsStat: 'macro',
              altText: '{away}, 3해처리 자원으로 빠른 레어!',
            ),
            ScriptEvent(
              text: '{away}, 스파이어 건설 들어갑니다! 뮤탈 타이밍이 빠르겠는데요!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home} 선수 아직 탱크가 안 나왔습니다. 배럭더블이라 테크가 느려요.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 3기 등장! 3해처리 자원 덕분에 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 뮤탈이 빨리 나왔습니다!',
            ),
            ScriptEvent(
              text: '3해처리의 자원이 빛나는 순간입니다! 테크가 빠르네요!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 한방 병력 빌드업 (lines 43-58)
    ScriptPhase(
      name: 'army_buildup',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 생산! 사이언스 퍼실리티도 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 탱크에 베슬 테크! 한방 병력 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴에서 럴커 변태! 저글링 뮤탈 럴커 조합입니다!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -25,
          altText: '{away}, 히드라덴 완성 후 럴커 전환! 물량이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{home}, 사이언스 베슬 생산! 한방 병력의 핵심이 합류합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수 베슬이 나옵니다! 이레디에이트 준비!',
        ),
        ScriptEvent(
          text: '{away}, 하이브 진화! 디파일러 마운드 건설 시작합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away} 선수 하이브에서 디파일러 마운드까지! 다크스웜 준비!',
        ),
        ScriptEvent(
          text: '양쪽 모두 후반 한방 병력을 모으고 있습니다! 누가 먼저 완성할까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 베슬 바이오닉이 모입니다! 한방 준비!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -15, favorsStat: 'macro',
          altText: '{home}, 한방 병력이 완성되어 갑니다!',
        ),
      ],
    ),
    // Phase 4: 한방 교전 - 분기 (lines 59-80)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 59,
      branches: [
        // 분기 A: 테란 한방 성공
        ScriptBranch(
          id: 'terran_one_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 탱크 베슬 바이오닉 총출격! 한방 갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home}, 한방 병력 전진! 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 시즈 모드! 앞마당 포격 시작! 베슬 이레디까지!',
              owner: LogOwner.home,
              awayArmy: -6, favorsStat: 'strategy',
              altText: '{home} 선수 탱크 포격에 이레디까지! 저그가 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커로 막아보지만 베슬 스캔에 위치가 드러납니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 럴커가 스캔에 걸렸습니다! 탱크 포격에 녹아요!',
            ),
            ScriptEvent(
              text: '{home}, 한방 병력이 앞마당을 밀어붙입니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '한방이 들어갔습니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 디파일러 다크스웜으로 한방 저지
        ScriptBranch(
          id: 'defiler_stops_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 디파일러가 전선에 도착합니다! 다크스웜!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'strategy',
              altText: '{away}, 다크스웜! 테란 한방을 무력화합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 포격이 다크스웜에 막힙니다! 한방이 불발!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 다크스웜 속에서 탱크가 무용지물입니다!',
            ),
            ScriptEvent(
              text: '{away}, 스웜 속에서 저글링 럴커가 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -4, favorsStat: 'attack',
              altText: '{away} 선수 다크스웜 속 저글링이 돌진! 상대 병력을 녹여냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 한방이 실패했습니다! 테란이 큰 피해를 입었는데요!',
              owner: LogOwner.home,
              homeArmy: -3, homeResource: -15,
            ),
            ScriptEvent(
              text: '다크스웜이 한방을 막아냈습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 C: 후반 대규모 교환전 (양측 균등 소모 → 병력 우세 쪽 승리)
        ScriptBranch(
          id: 'massive_trade',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 풀 병력이 정면에서 부딪칩니다! 대규모 교전!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 탱크가 포격합니다! 저그 물량을 쓸어내지만 끝이 없습니다!',
              owner: LogOwner.home,
              awayArmy: -6, homeArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 하지만 저그 물량이 끝이 없습니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 후방을 물어뜯으면서 정면에서도 밀어붙입니다!',
              owner: LogOwner.away,
              homeArmy: -5, homeResource: -15, awayArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 정면과 후방 동시 공격! 테란이 갈립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 베슬 이레디로 뮤탈을 잡습니다! 하지만 정면이 뚫리는데요!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -4, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '양측 병력이 크게 소모됩니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 10. 원해처리 올인 vs 스탠다드 테란 (초중반 승부)
// ----------------------------------------------------------
const _tvzStandardVs1HatchAllin = ScenarioScript(
  id: 'tvz_standard_vs_1hatch_allin',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk', 'tvz_4rax_enbe'],
  awayBuildIds: ['zvt_1hatch_allin', 'zvt_trans_530_mutal'],
  description: '스탠다드 테란 vs 원해처리 럴커 올인',
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
          text: '{away} 선수 해처리 하나로 시작합니다. 앞마당을 안 올리네요!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 원해처리 운영! 확장 없이 가는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀에 이어 가스를 일찍 넣습니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스를 빠르게 올립니다! 테크 빌드인데요!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 추가합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 진화 시작합니다! 원해처리에서 바로 테크!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어가 올라갑니다! 빠른 테크!',
        ),
      ],
    ),
    // Phase 1: 럴커 올인 준비 (lines 15-24)
    ScriptPhase(
      name: 'lurker_allin_prep',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설! 럴커를 노리는 건가요?',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴이 올라갑니다! 럴커 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설하면서 스팀팩 연구합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아카데미에 스팀팩! 바이오닉 완성 단계!',
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
    // Phase 2: 럴커 올인 돌입 - 분기 (lines 25-38)
    ScriptPhase(
      name: 'lurker_allin',
      startLine: 25,
      branches: [
        // 분기 A: 럴커 올인 성공
        ScriptBranch(
          id: 'lurker_allin_success',
          baseProbability: 1.0,
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
              text: '{away}, 럴커가 입구에 자리잡습니다! 상대 보병을 녹여냅니다!',
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
              text: '올인이 성공하고 있습니다! GG!',
              owner: LogOwner.system,
              decisive: true,
              skipChance: 0.15,
            ),
          ],
        ),
        // 분기 B: 테란이 럴커를 읽고 대비
        ScriptBranch(
          id: 'terran_reads_lurker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV 정찰로 원해처리 럴커를 확인했습니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 정찰 성공! 럴커 올인을 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 팩토리에 머신샵 부착! 시즈 탱크로 럴커를 잡겠다는 판단!',
              owner: LogOwner.home,
              homeResource: -20, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 전진하지만 시즈 모드 포격에 당합니다!',
              owner: LogOwner.away,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{away}, 럴커가 탱크 사거리에 들어갑니다! 스캔!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 포격! 럴커를 하나씩 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: 2, favorsStat: 'attack',
              altText: '{home} 선수 시즈 탱크로 럴커 정밀 포격!',
            ),
            ScriptEvent(
              text: '올인이 막혔습니다!',
              owner: LogOwner.system,
              skipChance: 0.15,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 올인 이후 (lines 39-50)
    ScriptPhase(
      name: 'post_allin',
      startLine: 39,
      branches: [
        // 분기 A: 올인 실패 후 자원 차이
        ScriptBranch(
          id: 'allin_failed_resource_gap',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 올인이 실패했습니다! 원해처리라 자원이 없어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 확장하면서 병력을 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 15, favorsStat: 'macro',
              altText: '{home}, 자원 차이를 벌립니다! 테란이 유리해요!',
            ),
            ScriptEvent(
              text: '{away}, 급히 앞마당을 올리지만 이미 자원 차이가 크네요.',
              owner: LogOwner.away,
              awayResource: -30,
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕 탱크 조합으로 전진! 저그가 막기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 총공격! 올인 실패한 저그를 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '올인 실패 후 자원 차이가 결정적입니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 올인 성공 후 마무리
        ScriptBranch(
          id: 'allin_success_finish',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 올인 성공! 테란 앞마당이 무너졌습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 본진으로 후퇴! 수비를 재건하려 합니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 앞마당을 포기하고 본진 수비!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 본진 입구에도 자리잡습니다! 탈출구가 없는데요!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away}, 스파이어에서 뮤탈까지 추가! 530 전환으로 마무리합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 스파이어 완성! 럴커에 뮤탈까지!',
            ),
            ScriptEvent(
              text: '원해처리 올인 성공!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
// 11. 메카닉 vs 하이브 운영 (후반 대규모 전면전)
// ----------------------------------------------------------
const _tvzMechVsHive = ScenarioScript(
  id: 'tvz_mech_vs_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_3fac_goliath', 'tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_trans_lurker_defiler'],
  description: '메카닉 vs 하이브 울트라/디파일러 후반전',
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
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 일찍 넣으면서 팩토리에 머신샵까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리 머신샵! 메카닉 테크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 증설! 메카닉 체제를 확립합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리 2개! 본격 메카닉 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 소량 생산하면서 앞마당 가스를 넣습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 첫 시즈 탱크 생산! 골리앗도 곧 나옵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나왔습니다! 골리앗도 생산 대기 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.2,
          altText: '{away}, 3번째 해처리! 자원을 벌려갑니다!',
        ),
      ],
    ),
    // Phase 1: 중반 내정 확장 (lines 17-30)
    ScriptPhase(
      name: 'mid_expansion',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 대량 생산 시작! 아머리 업그레이드도!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 골리앗이 쏟아져 나옵니다! 업그레이드도 진행 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설! 레어 올리면서 럴커 테크 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 히드라덴에 레어까지! 럴커 준비!',
        ),
        ScriptEvent(
          text: '{home}, 앞마당 커맨드센터 건설! 테란도 확장합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 진화 시작합니다! 디파일러 마운드와 울트라리스크 캐번 건설!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 하이브에서 디파일러 마운드와 울트라리스크 캐번까지!',
        ),
        ScriptEvent(
          text: '양쪽 모두 후반 빌드업 중입니다. 고요하지만 긴장감이 있는 전개!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 중반 교전 (lines 31-44)
    ScriptPhase(
      name: 'mid_clash',
      startLine: 31,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 탱크 조합으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home}, 메카닉 부대 전진! 탱크 시즈 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 앞마당 입구에 포진합니다! 막아내려는 모습!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'defense',
          altText: '{away}, 럴커 포진! 메카닉 전진을 저지합니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 럴커를 스캔으로 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'strategy',
          altText: '{home} 선수 스캔 + 탱크 포격! 럴커를 하나씩 제거합니다!',
        ),
        ScriptEvent(
          text: '{away}, 저글링이 탱크 사이로 파고듭니다! 시즈 라인을 흔들어요!',
          owner: LogOwner.away,
          homeArmy: -2, awayArmy: -3, favorsStat: 'control',
          altText: '{away} 선수 저글링 돌진! 탱크 뒤를 칩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗으로 저글링을 정리합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '중반 교전을 치렀습니다! 이제 후반 테크 싸움이 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 하이브 테크 등장 - 분기 (lines 45-60)
    ScriptPhase(
      name: 'hive_tech',
      startLine: 45,
      branches: [
        // 분기 A: 울트라 등장
        ScriptBranch(
          id: 'ultra_arrives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 등장합니다! 최종 병기!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30,
              altText: '{away}, 울트라가 나왔습니다! 거대한 병기!',
            ),
            ScriptEvent(
              text: '{away}, 울트라가 골리앗 라인을 향해 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 울트라 돌진! 골리앗 라인이 밀립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 울트라를 집중 사격합니다! 골리앗이 울트라에 강하죠!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'defense',
              altText: '{home}, 골리앗이 집중 포화! 상대 지상 유닛을 격파합니다!',
            ),
            ScriptEvent(
              text: '{away}, 하지만 뒤이어 저글링이 쏟아져 나옵니다! 물량 압박!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -2, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '골리앗이 울트라를 잡았지만 뒤따르는 물량이 문제입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 디파일러 다크스웜
        ScriptBranch(
          id: 'defiler_darkswarm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 디파일러가 전선에 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25, favorsStat: 'strategy',
              altText: '{away}, 디파일러 등장! 다크스웜 준비!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜! 디파일러가 상대 화력을 완전히 무력화시킵니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스웜! 메카닉 화력이 의미를 잃습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬 이레디에이트로 디파일러를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeResource: -15, favorsStat: 'strategy',
              altText: '{home}, 이레디! 디파일러를 잡을 수 있을까요!',
            ),
            ScriptEvent(
              text: '{away}, 디파일러가 컨슘으로 에너지를 채우면서 스웜을 계속 깔아줍니다!',
              owner: LogOwner.away,
              favorsStat: 'control',
              altText: '{away} 선수 컨슘! 디파일러 에너지 회복! 스웜이 끊이질 않습니다!',
            ),
            ScriptEvent(
              text: '다크스웜 vs 이레디에이트! 마법 대결이 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 최종 결전 (lines 61-80)
    ScriptPhase(
      name: 'final_battle',
      startLine: 61,
      branches: [
        // 분기 A: 메카닉 물량으로 밀어붙이기
        ScriptBranch(
          id: 'mech_overwhelm',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home} 선수 5팩토리 풀가동! 골리앗이 끝없이 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 9, homeResource: -30, favorsStat: 'macro',
              altText: '{home}, 골리앗 물량! 메카닉 재생산이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home}, 골리앗 탱크 편대가 저그 4번째 확장을 노립니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 확장이 하나씩 무너지고 있어요!',
              owner: LogOwner.away,
              awayArmy: -4, awayResource: -20,
              altText: '{away}, 멀티가 밀리고 있습니다! 자원이 끊겨요!',
            ),
            ScriptEvent(
              text: '{home}, 메카닉 물량으로 저그 확장을 하나씩 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '메카닉 물량이 확장을 무너뜨립니다! GG!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 하이브 유닛 총공격
        ScriptBranch(
          id: 'hive_all_out',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라 디파일러 저글링 총동원! 전면전 태세!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30,
              altText: '{away}, 하이브 유닛 풀가동! 최종 결전 준비!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜 깔면서 울트라가 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 스웜 속 울트라가 돌진! 상대 화력을 무력화시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗으로 울트라를 잡으려 하지만 스웜에 화력이 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{home}, 다크스웜 속에서 골리앗이 제 화력을 못 냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 탱크 라인 뒤로 파고듭니다! 전선이 무너지는데요!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -5, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '최종 병기 총공격!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 C: 접전 끝 재건 경쟁
        ScriptBranch(
          id: 'rebuild_race',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '양측 모두 큰 전투 후 병력이 바닥났습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5팩토리에서 골리앗을 재생산합니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25, favorsStat: 'macro',
              altText: '{home}, 메카닉 재생산! 팩토리 풀가동!',
            ),
            ScriptEvent(
              text: '{away} 선수 3해처리에서 저글링 울트라를 다시 뽑습니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -25, favorsStat: 'macro',
              altText: '{away}, 다해처리 재생산! 물량을 다시 채웁니다!',
            ),
            ScriptEvent(
              text: '재건 속도 대결!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);

