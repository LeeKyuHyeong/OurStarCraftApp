part of '../../scenario_scripts.dart';

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
          text: '{home} 선수 소수 마린으로 앞마당을 찔러봅니다! 메딕 없이 압박!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          skipChance: 0.4,
          altText: '{home}, 마린 3기가 앞마당으로! 드론을 위협합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 급히 뽑아서 마린을 쫓아냅니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링 생산! 마린 압박에 자원을 쓸 수밖에 없네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스 넣으면서 레어를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어 테크를 올립니다! 스파이어를 노리는 모습!',
        ),
        ScriptEvent(
          text: '{home} 선수 메딕 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 성큰을 심습니다! 추가 마린 압박 대비!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 성큰 건설! 마린메딕에 대비합니다!',
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
          text: '{away} 선수 스파이어 건설 시작! 뮤탈 타이밍이 다가옵니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어가 올라가고 있습니다! 곧 뮤탈이 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 편대가 맵 중앙으로 이동합니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 병력을 모아서 전진 준비! 스파이어 완성 전에 압박!',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰 뒤에 저글링을 깔아놓고 스파이어 완성을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -5,
          altText: '{away}, 성큰과 저글링으로 시간을 벌면서 스파이어를 기다리는 모습!',
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
              text: '{away} 뮤탈이 바로 SCV를 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away}, 뮤탈리스크 컨트롤! 일꾼을 솎아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 급히 터렛 올리면서 전진을 멈춥니다!',
              owner: LogOwner.home,
              homeResource: -15,
            ),
          ],
        ),
        // 분기 C: 마린 전멸 + 저글링 역습
        ScriptBranch(
          id: 'marine_wipeout',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 전진하는데 저글링 무리가 사방에서 달려옵니다!',
              owner: LogOwner.home,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{home}, 전진하다 저글링 서라운드에 걸렸습니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 마린을 완전히 감쌉니다! 마린이 녹아내립니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 서라운드 완벽! 마린 편대가 전멸합니다!',
            ),
            ScriptEvent(
              text: '{away}, 살아남은 저글링이 그대로 테란 본진으로 역습합니다!',
              owner: LogOwner.away,
              homeResource: -15, awayArmy: 2, favorsStat: 'attack',
              altText: '{away} 선수 마린을 잡고 남은 저글링으로 바로 역습!',
            ),
            ScriptEvent(
              text: '마린 편대가 전멸했습니다! 테란이 큰 위기를 맞았는데요!',
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
              altText: '{home}, 일꾼 사이에 터렛 선제 건설! 철벽 수비!',
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
          text: '{away} 선수 히드라가 럴커로 변태합니다! 앞마당 입구에 배치!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 럴커 등장! 테란 전진을 막아서겠다는 의도!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워 부착에 사이언스 퍼실리티까지!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스타포트 컨트롤타워 사이언스 퍼실리티! 고급 테크!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스베슬이 나옵니다! 이레디에이트 준비!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 첫 사이언스베슬 합류! 럴커를 잡을 수 있게 되었습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스커지를 생산합니다! 베슬을 잡아야 럴커가 살 수 있습니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 스커지 생산! 사이언스베슬을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 스커지가 베슬을 향해 돌진합니다! {home} 선수 베슬을 빼는데!',
          owner: LogOwner.away,
          favorsStat: 'control',
          skipChance: 0.3,
          altText: '{away} 선수 스커지 컨트롤! 베슬을 잡을 수 있을까요!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 테크를 올리면서 디파일러 마운드 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 하이브 완성! 디파일러 마운드까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 디파일러가 전선에 합류합니다! 럴커 스커지 디파일러 조합에 가스가 빠르게 빠지고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          skipChance: 0.3,
          altText: '{away}, 디파일러까지 합류! 가스 소모가 상당한 조합이네요!',
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 51-65)
    ScriptPhase(
      name: 'transition',
      startLine: 51,
      branches: [
        // 분기 A: 베슬 생존 + 이레디에이트 타이밍
        ScriptBranch(
          id: 'vessel_survives',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away}, 스커지가 베슬을 향해 돌진합니다! {home} 선수 베슬을 마린 뒤로 빼줍니다!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'control',
              altText: '{home} 선수 베슬 컨트롤! 스커지를 마린이 잡아줍니다!',
            ),
            ScriptEvent(
              text: '{home}, 이레디에이트! 럴커에 명중! 럴커가 녹아내립니다!',
              owner: LogOwner.home,
              awayArmy: -6, favorsStat: 'strategy',
              altText: '{home} 선수 이레디에이트가 작렬! 럴커를 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 빠지니까 방어선에 구멍이 뚫립니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
              altText: '{away} 선수 럴커 손실! 수비가 불안해집니다!',
            ),
            ScriptEvent(
              text: '{home}, 그 틈을 놓치지 않습니다! 앞마당 압박!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 전진! 상대 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '스커지를 막아내고 베슬이 살아있습니다! 베슬이 모이면 저그는 답이 없어요!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 스커지로 베슬 격추 → 저그 확장
        ScriptBranch(
          id: 'scourge_kills_vessel',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away}, 스커지 2기가 베슬을 향해 돌진! {home} 선수 빼려 하지만!',
              owner: LogOwner.away,
              favorsStat: 'control',
              altText: '{away} 선수 스커지가 베슬을 노립니다! 잡을 수 있을까요!',
            ),
            ScriptEvent(
              text: '{away}, 스커지 명중! 사이언스베슬이 격추됩니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 스커지가 베슬을 잡았습니다! 큰 교환!',
            ),
            ScriptEvent(
              text: '베슬이 모이질 않습니다! 스커지에 계속 격추되니 럴커를 잡을 수가 없어요!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
            ScriptEvent(
              text: '{away}, 베슬이 없는 틈에 네 번째 해처리를 올립니다! 4가스 확보!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: 20,
              altText: '{away} 선수 4가스 확장 성공! 럴커 스커지 디파일러를 마음껏 운영할 수 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 두 번째 베슬을 급히 생산하지만 또 스커지가 기다리고 있습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 베슬을 뽑아도 스커지가 잡아갑니다! 악순환이에요!',
            ),
          ],
        ),
        // 분기 C: 저그 물량 전환
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
              text: '{away}, 럴커를 추가 변태! 앞마당 입구에 촘촘하게 배치합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 럴커 추가 배치! 방어선이 더 두꺼워집니다!',
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
        // 분기 A: 이레디에이트 + 확장 차단 소모전
        ScriptBranch(
          id: 'terran_deny_expansion',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 이레디에이트! 디파일러에 명중! 비싼 유닛을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'strategy',
              altText: '{home}, 이레디에이트로 디파일러 격파! 저그 가스에 큰 타격!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커도 뽑아야 하고 스커지도 뽑아야 하고 디파일러까지! 3가스로는 돌아가질 않습니다!',
              owner: LogOwner.away,
              awayResource: -25, homeArmy: -5, favorsStat: 'defense',
              altText: '{away}, 럴커 스커지 디파일러 조합에 가스가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home}, 네 번째 확장을 차단합니다! 4가스를 못 먹으면 저그 조합이 유지가 안 됩니다!',
              owner: LogOwner.home,
              awayResource: -20, homeArmy: 3, favorsStat: 'strategy',
              altText: '{home} 선수 확장 저지! 3가스로 럴커 스커지 디파일러를 다 돌릴 수는 없어요!',
            ),
            ScriptEvent(
              text: '{away}, 가스가 바닥납니다! 스커지도 못 뽑고 디파일러도 못 뽑고! 저글링 럴커만으로 총돌격!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -8, favorsStat: 'attack',
              altText: '{away} 선수 가스 고갈! 저글링 럴커만 남았습니다! 마지막 승부!',
            ),
            ScriptEvent(
              text: '가스가 말라버린 저그! 테란이 밀어붙이는데 저그도 남은 병력으로 저항합니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 다크스웜 전선 밀어올리기
        ScriptBranch(
          id: 'defiler_push_forward',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 다크스웜을 깔면서 럴커 저글링이 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -5, favorsStat: 'strategy',
              altText: '{away}, 다크스웜 속에서 럴커가 전진! 테란 라인이 밀리기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 이레디에이트로 디파일러를 잡지만 가스가 넉넉한 저그! 바로 다음 디파일러가!',
              owner: LogOwner.home,
              awayArmy: -3, homeResource: -15, favorsStat: 'defense',
              altText: '{home}, 이레디로 잡아도 4가스 저그는 디파일러를 계속 뽑아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜이 테란 앞마당까지 깔립니다! 지상 병력이 무력화!',
              owner: LogOwner.away,
              homeArmy: -10, favorsStat: 'strategy',
              altText: '{away} 선수 스웜이 앞마당까지 도달! 테란 수비가 마비됩니다!',
            ),
            ScriptEvent(
              text: '{away}, 럴커 저글링이 수비 병력 위에 올라탑니다! 테란 방어선 붕괴!',
              owner: LogOwner.away,
              homeArmy: -15, awayArmy: -6, favorsStat: 'attack',
              altText: '{away} 선수 스웜 속 돌진! 테란 수비가 무너집니다!',
            ),
            ScriptEvent(
              text: '다크스웜 속 결전! 승부가 갈립니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 드랍 기습 + 다크스웜 교환
        ScriptBranch(
          id: 'drop_and_swarm',
          baseProbability: 0.7,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십으로 저그 세 번째 가스를 노립니다! 기습!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'sense',
              altText: '{home}, 드랍십 출발! 저그 가스 기지를 직접 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 드론을 잡으면서 익스트렉터까지 파괴합니다! 가스가 끊깁니다!',
              owner: LogOwner.home,
              awayResource: -30, favorsStat: 'sense',
              altText: '{home} 선수 드랍 성공! 가스 기지 파괴!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 급히 대응하지만 이미 가스 피해가 크네요!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 뮤탈이 돌아왔지만 익스트렉터가 이미 무너졌습니다!',
            ),
            ScriptEvent(
              text: '{away}, 남은 디파일러로 다크스웜! 가스가 끊겨서 스커지도 못 뽑지만 승부를 겁니다!',
              owner: LogOwner.away,
              homeArmy: -10, awayArmy: -5, favorsStat: 'attack',
              altText: '{away} 선수 가스 기지가 날아가서 조합 유지가 안 됩니다! 남은 병력으로 정면 승부!',
            ),
            ScriptEvent(
              text: '드랍과 다크스웜이 뒤엉킨 혼전! 승패가 갈립니다!',
              owner: LogOwner.system,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

