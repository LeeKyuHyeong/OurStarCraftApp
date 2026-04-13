part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 미러 — 발업 대기 → 상대 발업 확인 → 싸움/전환/올인 분기
// ----------------------------------------------------------
const _zvz9poolSpeedMirror = ScenarioScript(
  id: 'zvz_9pool_speed_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_9pool_speed'],
  description: '9풀 발업 미러 — 발업 대기 후 컨트롤 싸움 or 뮤탈 전환 or 저글링 올인',
  phases: [
    // Phase 0: 오프닝 — 발업 대기하며 저글링 축적 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀, 가스도 같이 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀에 가스까지! 발업이 핵심입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 9풀, 가스 동시 진입!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 똑같이 9풀 발업! 라바 분배 싸움입니다!',
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기 생산! 발업이 끝나면 바로 압박하겠다는 의도!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -8,
          altText: '{home} 선수 저글링부터! 발업 끝나면 돌진할 준비!',
        ),
        ScriptEvent(
          text: '{away}, 저글링 6기! 양쪽 다 발업을 기다리면서 저글링을 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -8,
        ),
        ScriptEvent(
          text: '상대방이 드러눕는 빌드를 허용 안 하겠다는 양 선수! 발업이 끝나면 승부를 보겠다는 겁니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '양쪽 다 공격적인 빌드! 상대가 확장할 줄 알았는데 같은 생각이었네요!',
        ),
        ScriptEvent(
          text: '{home}, 라바가 나올 때마다 저글링을 추가합니다! 눈치 싸움!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
          altText: '{home} 선수 저글링을 계속 추가하면서 발업을 기다립니다!',
        ),
        ScriptEvent(
          text: '{away}, 저글링을 늘리면서 발업 완료를 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 발업 완료 + 상대도 발업 확인 (lines 11-16)
    ScriptPhase(
      name: 'speed_done',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 완료! 저글링이 빨라집니다! 상대 진영으로!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 발업 완료! 저글링을 몰고 나갑니다!',
        ),
        ScriptEvent(
          text: '{away}, 발업 완료! 상대도 저글링이 빠릅니다!',
          owner: LogOwner.away,
          altText: '{away} 선수도 발업 끝! 저글링 속도가 같습니다!',
        ),
        ScriptEvent(
          text: '상대도 발업입니다! 양쪽 저글링 속도가 비슷합니다! 여기서 판단이 갈립니다!',
          owner: LogOwner.system,
          altText: '상대도 발업! 확장이 아닙니다! 어떻게 대응할 것인가!',
        ),
      ],
    ),
    // Phase 2: 판단 분기 — 싸움(decisive) or 전환(non-decisive) (lines 17-36)
    ScriptPhase(
      name: 'decision',
      startLine: 17,
      branches: [
        // ── 분기 A: 센터 저글링 싸움 → 홈 컨트롤 승리 (decisive) ──
        ScriptBranch(
          id: 'center_home_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home}, 그래도 밀어붙입니다! 컨트롤로 이기겠다!',
              owner: LogOwner.home,
              altText: '{home} 선수 발업 저글링으로 교전 강행!',
            ),
            ScriptEvent(
              text: '{away} 선수도 받아줍니다! 발업 저글링 대 저글링!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -2,
              altText: '{away}, 맞붙습니다! 발업 저글링끼리 교전!',
            ),
            ScriptEvent(
              text: '{home}, 저글링 컨트롤로 교환 우위! 상대보다 저글링을 더 남깁니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 저글링 컨트롤! 효율적으로 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 물량 차이가 벌어집니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 라바를 저글링에! 물량으로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '첫 교전의 저글링 수 차이가 결정적! 수비 붕괴!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 B: 센터 저글링 싸움 → 어웨이 컨트롤 승리 (decisive) ──
        ScriptBranch(
          id: 'center_away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 그래도 밀어붙입니다! 컨트롤로 이기겠다!',
              owner: LogOwner.away,
              altText: '{away} 선수 발업 저글링으로 교전 강행!',
            ),
            ScriptEvent(
              text: '{home} 선수도 받아줍니다! 발업 저글링 대 저글링!',
              owner: LogOwner.home,
              homeArmy: -2, awayArmy: -2,
              altText: '{home}, 맞붙습니다! 발업 저글링끼리 교전!',
            ),
            ScriptEvent(
              text: '{away}, 저글링 컨트롤로 교환 우위! 상대보다 저글링을 더 남깁니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 저글링 컨트롤! 효율적으로 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링 합류! 물량 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 라바를 저글링에! 물량으로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '첫 교전의 저글링 수 차이가 결정적! 수비 붕괴!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 C: 엇갈림 → 홈 멀티태스킹 승리 (decisive) ──
        ScriptBranch(
          id: 'cross_home_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '발업 저글링이 엇갈립니다! 서로의 본진으로 직행!',
              owner: LogOwner.system,
              altText: '양쪽 발업 저글링이 서로를 지나칩니다! 본진 급습!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 {home} 본진에 도착! 드론을 노립니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 드론 뭉치기! 추가 저글링도 합류해서 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 상대 본진 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 수비하면서 상대 드론까지 잡아냅니다! 멀티태스킹 차이!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'sense',
              altText: '{home}, 양쪽 전선을 동시에 관리합니다! 컨트롤의 차이!',
            ),
            ScriptEvent(
              text: '멀티태스킹 차이가 승부를 갈랐습니다! 수비 붕괴!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 D: 엇갈림 → 어웨이 멀티태스킹 승리 (decisive) ──
        ScriptBranch(
          id: 'cross_away_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '발업 저글링이 엇갈립니다! 서로의 본진으로 직행!',
              owner: LogOwner.system,
              altText: '양쪽 발업 저글링이 서로를 지나칩니다! 본진 급습!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 {away} 본진에 도착! 드론을 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 뭉치기! 추가 저글링도 합류해서 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 본진 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비하면서 상대 드론까지 잡아냅니다! 멀티태스킹 차이!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -10, favorsStat: 'sense',
              altText: '{away}, 양쪽 전선을 동시에 관리합니다! 컨트롤의 차이!',
            ),
            ScriptEvent(
              text: '멀티태스킹 차이가 승부를 갈랐습니다! 수비 붕괴!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 E: 양쪽 후퇴 → 레어 전환 (non-decisive → Phase 3) ──
        ScriptBranch(
          id: 'both_transition',
          baseProbability: 0.8,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home}, 상대도 발업인 걸 확인하고 저글링을 뺍니다! 싸워봤자 비등!',
              owner: LogOwner.home,
              altText: '{home} 선수 저글링 후퇴! 중반 전환을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 저글링을 빼면서 드론을 찍기 시작합니다!',
              owner: LogOwner.away,
              homeResource: 10, awayResource: 10,
              altText: '{away}, 저글링 후퇴! 양쪽 다 중반으로 넘어갑니다!',
            ),
            ScriptEvent(
              text: '양쪽 다 싸움을 피합니다! 레어로 전환하면서 공중전 돌입!',
              owner: LogOwner.system,
              altText: '저글링 싸움 대신 빠른 테크를 선택! 중반전입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레어 진화 시작! 빠른 테크를 노립니다!',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수도 레어! 테크 타이밍이 비슷합니다!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
          ],
        ),
        // ── 분기 F: 홈 저글링 올인 vs 어웨이 레어 (non-decisive → Phase 3) ──
        // 레어 150원 = 저글링 6기 차이를 노리는 타이밍 공격
        ScriptBranch(
          id: 'home_ling_allin',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away}, 상대도 발업! 싸워봤자 비등하니 레어로 전환합니다!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away} 선수 저글링을 빼고 레어! 공중전을 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 상대가 레어를 올린다! 지금이 타이밍! 저글링을 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -15,
              altText: '{home} 선수 레어 대신 저글링! 150원 차이를 노립니다!',
            ),
            ScriptEvent(
              text: '레어에 투자한 150원, 저글링 6기 차이! {home} 선수가 이 타이밍을 노립니다!',
              owner: LogOwner.system,
              altText: '{home} 선수 저글링 물량으로 밀어붙이겠다는 판단!',
            ),
          ],
        ),
        // ── 분기 G: 어웨이 저글링 올인 vs 홈 레어 (non-decisive → Phase 3) ──
        ScriptBranch(
          id: 'away_ling_allin',
          baseProbability: 0.4,
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home}, 상대도 발업! 싸워봤자 비등하니 레어로 전환합니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home} 선수 저글링을 빼고 레어! 공중전을 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 상대가 레어를 올린다! 지금이 타이밍! 저글링을 모읍니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -15,
              altText: '{away} 선수 레어 대신 저글링! 150원 차이를 노립니다!',
            ),
            ScriptEvent(
              text: '레어에 투자한 150원, 저글링 6기 차이! {away} 선수가 이 타이밍을 노립니다!',
              owner: LogOwner.system,
              altText: '{away} 선수 저글링 물량으로 밀어붙이겠다는 판단!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 해결 — 뮤탈 경쟁 or 올인 결과 (lines 37-60)
    // 병력 상태로 자연 분기: 동일(양쪽 레어) / 홈 우세(홈 올인) / 어웨이 우세(어웨이 올인)
    ScriptPhase(
      name: 'midgame_resolution',
      startLine: 37,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      branches: [
        // ── 양쪽 레어 → 뮤탈전 여러 라운드 → 홈 견제 우위 → 홈 승리 ──
        ScriptBranch(
          id: 'both_muta_home_wins',
          baseProbability: 0.8,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어 건설! 뮤탈이 곧 나옵니다!',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 스파이어! 뮤탈 타이밍이 비슷합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '양쪽 뮤탈이 나옵니다! 3기 대 3기, 초반 뮤탈전 시작!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4,
              altText: '뮤탈 싸움! 먼저 드론을 더 많이 끊는 쪽이 유리합니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 미네랄 라인 급습! 드론 2기를 잡습니다!',
              owner: LogOwner.home,
              awayResource: -8, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈이 상대 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away}, 스커지를 보내 견제를 끊으려 합니다! 뮤탈 1기 격추!',
              owner: LogOwner.away,
              homeArmy: -2,
              altText: '{away} 선수 스커지로 뮤탈 1기를 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈로 반대편 드론을 노립니다! 서로 견제를 주고받습니다!',
              owner: LogOwner.away,
              homeResource: -5, favorsStat: 'harass',
              altText: '{away}, 뮤탈로 역습! 드론을 끊으면서 자원 차이를 줄입니다!',
            ),
            ScriptEvent(
              text: '{home}, 추가 뮤탈 합류! 스커지를 피하면서 다시 미네랄 라인으로!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -8, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 추가 생산! 드론을 또 잡습니다!',
            ),
            ScriptEvent(
              text: '몇 차례 견제를 주고받았지만 {home} 선수 쪽이 드론을 더 많이 끊었습니다!',
              owner: LogOwner.system,
              altText: '뮤탈 견제 효율 차이! {home} 선수가 드론 수에서 앞서기 시작합니다!',
            ),
            ScriptEvent(
              text: '{away}, 드론이 부족해 뮤탈 추가 생산이 늦어집니다! 수 차이가 벌어집니다!',
              owner: LogOwner.away,
              homeArmy: 2, awayResource: -10,
              altText: '{away} 선수 자원이 딸립니다! 뮤탈 보충이 안 됩니다!',
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {home} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 양쪽 레어 → 뮤탈전 여러 라운드 → 어웨이 견제 우위 → 어웨이 승리 ──
        ScriptBranch(
          id: 'both_muta_away_wins',
          baseProbability: 0.8,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 스파이어 건설! 뮤탈이 곧 나옵니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수도 스파이어! 뮤탈 타이밍이 비슷합니다!',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '양쪽 뮤탈이 나옵니다! 3기 대 3기, 초반 뮤탈전 시작!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4,
              altText: '뮤탈 싸움! 먼저 드론을 더 많이 끊는 쪽이 유리합니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 미네랄 라인 급습! 드론 2기를 잡습니다!',
              owner: LogOwner.away,
              homeResource: -8, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈이 상대 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지를 보내 견제를 끊으려 합니다! 뮤탈 1기 격추!',
              owner: LogOwner.home,
              awayArmy: -2,
              altText: '{home} 선수 스커지로 뮤탈 1기를 잡습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 뮤탈로 반대편 드론을 노립니다! 서로 견제를 주고받습니다!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'harass',
              altText: '{home}, 뮤탈로 역습! 드론을 끊으면서 자원 차이를 줄입니다!',
            ),
            ScriptEvent(
              text: '{away}, 추가 뮤탈 합류! 스커지를 피하면서 다시 미네랄 라인으로!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -8, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 추가 생산! 드론을 또 잡습니다!',
            ),
            ScriptEvent(
              text: '몇 차례 견제를 주고받았지만 {away} 선수 쪽이 드론을 더 많이 끊었습니다!',
              owner: LogOwner.system,
              altText: '뮤탈 견제 효율 차이! {away} 선수가 드론 수에서 앞서기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home}, 드론이 부족해 뮤탈 추가 생산이 늦어집니다! 수 차이가 벌어집니다!',
              owner: LogOwner.home,
              awayArmy: 2, homeResource: -10,
              altText: '{home} 선수 자원이 딸립니다! 뮤탈 보충이 안 됩니다!',
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {away} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 양쪽 레어 → 뮤탈 동수 → 스커지 한방 → 홈 승리 (낮은 확률) ──
        ScriptBranch(
          id: 'both_muta_scourge_home',
          baseProbability: 0.3,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 스파이어 완성! 뮤탈 수가 엇비슷합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20,
            ),
            ScriptEvent(
              text: '뮤탈 수가 엇비슷합니다! 스커지를 섞으면서 견제를 주고받습니다!',
              owner: LogOwner.system,
              homeResource: -5, awayResource: -5,
              altText: '뮤탈 싸움! 스커지를 생산하면서 기회를 노립니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지 2기가 상대 뮤탈 뭉치에 정확히 꽂힙니다! 뮤탈 2기 격추!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 스커지가 뮤탈 뭉치를 관통! 대박입니다!',
            ),
            ScriptEvent(
              text: '한 번의 스커지 컨트롤로 뮤탈 수가 크게 벌어졌습니다!',
              owner: LogOwner.system,
              altText: '스커지 한방! 이 차이를 뒤집기 어렵습니다!',
            ),
            ScriptEvent(
              text: '{home}, 남은 뮤탈로 드론을 자유롭게 견제합니다! 상대는 방법이 없습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '스커지 컨트롤 한 방이 경기를 결정지었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 양쪽 레어 → 뮤탈 동수 → 스커지 한방 → 어웨이 승리 (낮은 확률) ──
        ScriptBranch(
          id: 'both_muta_scourge_away',
          baseProbability: 0.3,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수도 스파이어 완성! 뮤탈 수가 엇비슷합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
            ),
            ScriptEvent(
              text: '뮤탈 수가 엇비슷합니다! 스커지를 섞으면서 견제를 주고받습니다!',
              owner: LogOwner.system,
              homeResource: -5, awayResource: -5,
              altText: '뮤탈 싸움! 스커지를 생산하면서 기회를 노립니다!',
            ),
            ScriptEvent(
              text: '{away}, 스커지 2기가 상대 뮤탈 뭉치에 정확히 꽂힙니다! 뮤탈 2기 격추!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 스커지가 뮤탈 뭉치를 관통! 대박입니다!',
            ),
            ScriptEvent(
              text: '한 번의 스커지 컨트롤로 뮤탈 수가 크게 벌어졌습니다!',
              owner: LogOwner.system,
              altText: '스커지 한방! 이 차이를 뒤집기 어렵습니다!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 자유롭게 견제합니다! 상대는 방법이 없습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '스커지 컨트롤 한 방이 경기를 결정지었습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 홈 올인 성공: 저글링 물량으로 레어 건설 중인 어웨이 붕괴 ──
        ScriptBranch(
          id: 'home_ling_crush',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home}, 저글링을 몰고 들어갑니다! 레어에 자원을 쓴 상대는 저글링이 부족!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌진! 6기 차이가 보입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 모자랍니다! 드론으로 막아야 해요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '레어에 투자한 150원이 발목을 잡았습니다! 저글링 물량 차이!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 홈 올인 실패: 어웨이가 수비 → 빠른 뮤탈 → 스커지 저격 ──
        ScriptBranch(
          id: 'home_allin_fails',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home}, 저글링을 몰고 들어가지만!',
              owner: LogOwner.home,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 저글링과 드론으로 입구를 막습니다! 6기 차이지만 수비는 가능!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 드론까지 동원! 입구에서 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 레어가 먼저 완성! 테크가 앞서갑니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 빠르게 올립니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away} 선수 수비 성공 후 스파이어 건설!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 먼저 나옵니다! 상대는 아직 레어도 없어요!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 선점! 드론을 하나씩 끊습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 레어를 올리지만 너무 늦었습니다!',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어까지 따라가지만 격차가 너무 큽니다!',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 스커지를 상대 해처리 앞에 대기! 뮤탈이 나오는 즉시 저격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'control',
              altText: '{away} 선수 스커지가 해처리 앞에서 대기! 뮤탈이 모이질 못합니다!',
            ),
            ScriptEvent(
              text: '수비 성공에서 뮤탈 선점, 스커지 저격까지! 완벽한 역전!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 홈 올인 비등 교환 → 레어 차이로 어웨이 뮤탈 선점 ──
        ScriptBranch(
          id: 'home_allin_even',
          baseProbability: 0.6,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home}, 저글링을 몰고 들어갑니다!',
              owner: LogOwner.home,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away}, 저글링과 드론으로 맞받아칩니다! 치열한 교전!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -4, awayResource: -10,
              favorsStat: 'defense',
              altText: '{away} 선수 드론까지 동원해서 저글링을 잡습니다! 하지만 드론 피해도 큽니다!',
            ),
            ScriptEvent(
              text: '비등한 교환! 양쪽 다 피해가 크지만 결판이 안 났습니다!',
              owner: LogOwner.system,
              altText: '저글링이 비등하게 교환됐습니다! 올인이 통하지 않았어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 레어 진화를 시작합니다!',
              owner: LogOwner.home,
              homeResource: -25,
            ),
            ScriptEvent(
              text: '{away}, 레어가 이미 진행 중! 테크가 앞서갑니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어를 바로 올립니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away} 선수 스파이어 건설! 테크 격차가 벌어집니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 먼저 합류! 상대 뮤탈이 나오기 전에 드론을 끊습니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '비등한 저글링 교환이었지만 레어 차이가 결정적! 뮤탈 타이밍 차이!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 어웨이 올인 성공: 저글링 물량으로 레어 건설 중인 홈 붕괴 ──
        ScriptBranch(
          id: 'away_ling_crush',
          baseProbability: 1.0,
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 저글링을 몰고 들어갑니다! 레어에 자원을 쓴 상대는 저글링이 부족!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌진! 6기 차이가 보입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 모자랍니다! 드론으로 막아야 해요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '레어에 투자한 150원이 발목을 잡았습니다! 저글링 물량 차이!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 어웨이 올인 실패: 홈이 수비 → 빠른 뮤탈 → 스커지 저격 ──
        ScriptBranch(
          id: 'away_allin_fails',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away}, 저글링을 몰고 들어가지만!',
              owner: LogOwner.away,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home}, 저글링과 드론으로 입구를 막습니다! 6기 차이지만 수비는 가능!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'defense',
              altText: '{home} 선수 드론까지 동원! 입구에서 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home}, 레어가 먼저 완성! 테크가 앞서갑니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 빠르게 올립니다!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home} 선수 수비 성공 후 스파이어 건설!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 먼저 나옵니다! 상대는 아직 레어도 없어요!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 드론을 하나씩 끊습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 레어를 올리지만 너무 늦었습니다!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어까지 따라가지만 격차가 너무 큽니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 스커지를 상대 해처리 앞에 대기! 뮤탈이 나오는 즉시 저격!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: 2, favorsStat: 'control',
              altText: '{home} 선수 스커지가 해처리 앞에서 대기! 뮤탈이 모이질 못합니다!',
            ),
            ScriptEvent(
              text: '수비 성공에서 뮤탈 선점, 스커지 저격까지! 완벽한 역전!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 어웨이 올인 비등 교환 → 레어 차이로 홈 뮤탈 선점 ──
        ScriptBranch(
          id: 'away_allin_even',
          baseProbability: 0.6,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away}, 저글링을 몰고 들어갑니다!',
              owner: LogOwner.away,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home}, 저글링과 드론으로 맞받아칩니다! 치열한 교전!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -4, homeResource: -10,
              favorsStat: 'defense',
              altText: '{home} 선수 드론까지 동원해서 저글링을 잡습니다! 하지만 드론 피해도 큽니다!',
            ),
            ScriptEvent(
              text: '비등한 교환! 양쪽 다 피해가 크지만 결판이 안 났습니다!',
              owner: LogOwner.system,
              altText: '저글링이 비등하게 교환됐습니다! 올인이 통하지 않았어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 레어 진화를 시작합니다!',
              owner: LogOwner.away,
              awayResource: -25,
            ),
            ScriptEvent(
              text: '{home}, 레어가 이미 진행 중! 테크가 앞서갑니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 바로 올립니다!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home} 선수 스파이어 건설! 테크 격차가 벌어집니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 먼저 합류! 상대 뮤탈이 나오기 전에 드론을 끊습니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '비등한 저글링 교환이었지만 레어 차이가 결정적! 뮤탈 타이밍 차이!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
