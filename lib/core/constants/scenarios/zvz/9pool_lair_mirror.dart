part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 레어 미러 — 레어 직행 → 가스 2회차 발업 → 뮤탈 경쟁
// 저글링 견제 후 뮤탈전이 메인 이벤트
// ----------------------------------------------------------
const _zvz9poolLairMirror = ScenarioScript(
  id: 'zvz_9pool_lair_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_lair'],
  awayBuildIds: ['zvz_9pool_lair'],
  description: '9풀 레어 미러 — 발업 스킵 후 뮤탈 선점 경쟁',
  phases: [
    // Phase 0: 오프닝 — 레어 직행 + 저글링 + 발업 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀, 가스도 같이 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀에 가스! 빠른 테크를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 9풀에 가스! 레어 미러입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 똑같이 9풀 가스! 양쪽 다 레어 직행!',
        ),
        ScriptEvent(
          text: '{home}, 가스 100이 모이자마자 레어 진화! 발업보다 테크를 우선합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home} 선수 레어 직행! 공중 유닛을 최대한 빨리 뽑겠다는 판단!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어 진화 시작! 양쪽 다 테크 경쟁!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어 직행! 동일한 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home}, 저글링 6기 생산하면서 두 번째 가스 100으로 발업도 눌러줍니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home} 선수 저글링 생산! 가스 2회차로 발업도 시작!',
        ),
        ScriptEvent(
          text: '{away}, 저글링 6기! 발업도 같이 돌립니다! 레어가 올라가는 동안 견제!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -15,
          altText: '{away} 선수도 저글링에 발업! 양쪽 동일한 타이밍!',
        ),
        ScriptEvent(
          text: '양쪽 다 레어 직행 후 발업! 테크 타이밍이 동일합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '레어 미러! 발업도 같은 타이밍에 끝납니다!',
        ),
      ],
    ),
    // Phase 1: 발업 저글링 견제 분기 (lines 11-18)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 11,
      branches: [
        // ── 분기 A: 홈 발업 저글링 견제 성공 ──
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 0.6,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home}, 발업 저글링이 상대 미네랄 라인에 침투! 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 발업 저글링 견제! 빠른 속도로 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away}, 발업 저글링으로 맞받지만 드론 피해가 있습니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -5, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 드론 피해를 줬습니다! 중반전에서 자원 차이가 날 수 있어요!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ── 분기 B: 어웨이 발업 저글링 견제 성공 ──
        ScriptBranch(
          id: 'away_ling_harass',
          baseProbability: 0.6,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 발업 저글링이 상대 미네랄 라인에 침투! 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
              altText: '{away} 선수 발업 저글링 견제! 빠른 속도로 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{home}, 발업 저글링으로 맞받지만 드론 피해가 있습니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeResource: -5, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해를 줬습니다! 중반전에서 자원 차이가 날 수 있어요!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // ── 분기 C: 비등 — 뮤탈전으로 넘어감 ──
        ScriptBranch(
          id: 'ling_even',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '양쪽 발업 저글링이 센터에서 마주칩니다! 소규모 교전!',
              owner: LogOwner.system,
              homeArmy: -2, awayArmy: -2,
              altText: '발업 저글링끼리 교전! 비등하게 교환됩니다!',
            ),
            ScriptEvent(
              text: '양쪽 발업이 같으니 결정적인 차이가 안 납니다! 중반전으로 넘어갑니다!',
              owner: LogOwner.system,
              altText: '저글링 교전은 비등! 승부는 중반전에서 갈립니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 2: 레어 완성 → 스파이어 건설 (lines 19-26)
    ScriptPhase(
      name: 'spire_race',
      startLine: 19,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어 완성! 스파이어를 바로 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 레어 완성 즉시 스파이어! 뮤탈까지 얼마 안 남았습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어 완성! 스파이어 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어! 뮤탈 타이밍이 동일합니다!',
        ),
        ScriptEvent(
          text: '스파이어가 올라가는 동안이 가장 위험한 시간! 성큰으로 수비를 보강합니다!',
          owner: LogOwner.system,
          homeArmy: 2, awayArmy: 2, homeResource: -10, awayResource: -10,
          skipChance: 0.3,
          altText: '양쪽 성큰 건설! 스파이어 완성까지 버텨야 합니다!',
        ),
      ],
    ),
    // Phase 3: 뮤탈전 (lines 27-50)
    ScriptPhase(
      name: 'muta_war',
      startLine: 27,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      branches: [
        // ── A: 뮤탈 견제 여러 라운드 → 홈 견제 우위 ──
        ScriptBranch(
          id: 'muta_harass_home',
          baseProbability: 0.8,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수도 스파이어 완성! 뮤탈 수가 동일합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈 미러 시작! 드론 견제를 주고받으면서 서서히 차이가 벌어집니다!',
              owner: LogOwner.system,
              altText: '양쪽 뮤탈이 동수! 여기서부터 긴 싸움입니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 미네랄 라인 급습! 드론 2기를 잡습니다!',
              owner: LogOwner.home,
              awayResource: -8, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 견제! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away}, 스커지로 대응! 뮤탈 1기를 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              altText: '{away} 선수 스커지! 뮤탈 1기 격추!',
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈로 역습! 서로 견제를 주고받습니다!',
              owner: LogOwner.away,
              homeResource: -5, favorsStat: 'harass',
              altText: '{away}, 뮤탈 역습! 드론을 끊으면서 자원 차이를 줄입니다!',
            ),
            ScriptEvent(
              text: '{home}, 추가 뮤탈 합류! 스커지를 피하면서 또 미네랄 라인으로!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -8, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 추가! 견제 효율이 앞서기 시작합니다!',
            ),
            ScriptEvent(
              text: '몇 차례 견제를 주고받았지만 {home} 선수 쪽이 드론을 더 많이 끊었습니다!',
              owner: LogOwner.system,
              altText: '{home} 선수 견제 효율이 앞섭니다! 드론 수 차이!',
            ),
            ScriptEvent(
              text: '{away}, 드론이 부족해 뮤탈 추가 생산이 늦어집니다!',
              owner: LogOwner.away,
              homeArmy: 2, awayResource: -10,
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {home} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── B: 뮤탈 견제 여러 라운드 → 어웨이 견제 우위 ──
        ScriptBranch(
          id: 'muta_harass_away',
          baseProbability: 0.8,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수도 스파이어 완성! 뮤탈 수가 동일합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈 미러 시작! 드론 견제를 주고받으면서 서서히 차이가 벌어집니다!',
              owner: LogOwner.system,
              altText: '양쪽 뮤탈이 동수! 여기서부터 긴 싸움입니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 미네랄 라인 급습! 드론 2기를 잡습니다!',
              owner: LogOwner.away,
              homeResource: -8, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지로 대응! 뮤탈 1기를 잡습니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              altText: '{home} 선수 스커지! 뮤탈 1기 격추!',
            ),
            ScriptEvent(
              text: '{home} 선수도 뮤탈로 역습! 서로 견제를 주고받습니다!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'harass',
              altText: '{home}, 뮤탈 역습! 드론을 끊으면서 자원 차이를 줄입니다!',
            ),
            ScriptEvent(
              text: '{away}, 추가 뮤탈 합류! 스커지를 피하면서 또 미네랄 라인으로!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -8, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 추가! 견제 효율이 앞서기 시작합니다!',
            ),
            ScriptEvent(
              text: '몇 차례 견제를 주고받았지만 {away} 선수 쪽이 드론을 더 많이 끊었습니다!',
              owner: LogOwner.system,
              altText: '{away} 선수 견제 효율이 앞섭니다! 드론 수 차이!',
            ),
            ScriptEvent(
              text: '{home}, 드론이 부족해 뮤탈 추가 생산이 늦어집니다!',
              owner: LogOwner.home,
              awayArmy: 2, homeResource: -10,
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {away} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── C: 스커지 한방 → 홈 승리 (낮은 확률) ──
        ScriptBranch(
          id: 'muta_scourge_home',
          baseProbability: 0.3,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈 동수! 양쪽 스커지를 섞으면서 견제를 주고받습니다!',
              owner: LogOwner.system,
              homeResource: -5, awayResource: -5,
              altText: '뮤탈 미러! 스커지 운용이 승부를 가릅니다!',
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
              text: '{home}, 남은 뮤탈로 드론을 자유롭게 견제합니다!',
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
        // ── D: 스커지 한방 → 어웨이 승리 (낮은 확률) ──
        ScriptBranch(
          id: 'muta_scourge_away',
          baseProbability: 0.3,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈 동수! 양쪽 스커지를 섞으면서 견제를 주고받습니다!',
              owner: LogOwner.system,
              homeResource: -5, awayResource: -5,
              altText: '뮤탈 미러! 스커지 운용이 승부를 가릅니다!',
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
              text: '{away}, 남은 뮤탈로 드론을 자유롭게 견제합니다!',
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
        // ── E: 초반 드론 피해 → 홈 뮤탈 물량 우위 ──
        ScriptBranch(
          id: 'drone_lead_home',
          baseProbability: 0.5,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 나오지만!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 3, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 초반 드론 피해가 적었던 덕분에 뮤탈 추가 생산이 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 2, favorsStat: 'macro',
              altText: '{home} 선수 자원이 넉넉합니다! 뮤탈을 더 빨리 뽑습니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 수가 밀리기 시작합니다! 스커지로 버팁니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: 1,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 수 차이로 드론 견제가 일방적입니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '초반 드론 관리의 차이가 뮤탈전에서 결정적으로 드러났습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── F: 초반 드론 피해 → 어웨이 뮤탈 물량 우위 ──
        ScriptBranch(
          id: 'drone_lead_away',
          baseProbability: 0.5,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 나오지만!',
              owner: LogOwner.system,
              homeArmy: 3, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 초반 드론 피해가 적었던 덕분에 뮤탈 추가 생산이 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'macro',
              altText: '{away} 선수 자원이 넉넉합니다! 뮤탈을 더 빨리 뽑습니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 수가 밀리기 시작합니다! 스커지로 버팁니다!',
              owner: LogOwner.home,
              awayArmy: -1, homeArmy: 1,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 드론 견제가 일방적입니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '초반 드론 관리의 차이가 뮤탈전에서 결정적으로 드러났습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── G: 뮤탈 발업 저글링 2정면 공격 → 홈 승리 ──
        ScriptBranch(
          id: 'two_front_home',
          baseProbability: 0.5,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 동시에 나옵니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 본진 드론을 견제하면서 동시에 발업 저글링을 앞마당으로 보냅니다!',
              owner: LogOwner.home,
              awayResource: -8, favorsStat: 'sense',
              altText: '{home} 선수 2정면 공격! 뮤탈은 본진, 저글링은 앞마당!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈과 저글링이 동시에! 어디를 먼저 막아야 할지!',
              owner: LogOwner.away,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{away} 선수 양쪽을 동시에 대응해야 합니다!',
            ),
            ScriptEvent(
              text: '{home}, 상대가 뮤탈을 막는 사이 저글링이 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -12, favorsStat: 'control',
              altText: '{home} 선수 저글링이 미네랄 라인을 초토화! 멀티태스킹 차이!',
            ),
            ScriptEvent(
              text: '2정면 공격의 멀티태스킹 차이! 한쪽만 막으면 반대쪽이 뚫립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 멀티태스킹으로 상대를 완전히 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── H: 뮤탈 발업 저글링 2정면 공격 → 어웨이 승리 ──
        ScriptBranch(
          id: 'two_front_away',
          baseProbability: 0.5,
          conditionStat: 'sense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 동시에 나옵니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 본진 드론을 견제하면서 동시에 발업 저글링을 앞마당으로 보냅니다!',
              owner: LogOwner.away,
              homeResource: -8, favorsStat: 'sense',
              altText: '{away} 선수 2정면 공격! 뮤탈은 본진, 저글링은 앞마당!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈과 저글링이 동시에! 어디를 먼저 막아야 할지!',
              owner: LogOwner.home,
              homeArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 양쪽을 동시에 대응해야 합니다!',
            ),
            ScriptEvent(
              text: '{away}, 상대가 뮤탈을 막는 사이 저글링이 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -12, favorsStat: 'control',
              altText: '{away} 선수 저글링이 미네랄 라인을 초토화! 멀티태스킹 차이!',
            ),
            ScriptEvent(
              text: '2정면 공격의 멀티태스킹 차이! 한쪽만 막으면 반대쪽이 뚫립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 멀티태스킹으로 상대를 완전히 압도합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── I: 양쪽 앞마당 확장 → 장기전 → 홈 매크로 우위 ──
        ScriptBranch(
          id: 'both_expand_home',
          baseProbability: 0.4,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 나오지만 견제가 비등합니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 견제가 비등하자 앞마당 해처리를 올립니다!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home} 선수 앞마당 확장! 라바 회전을 늘리겠다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당! 양쪽 다 확장하면서 장기전!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 앞마당! 상대만 확장하게 둘 수 없습니다!',
            ),
            ScriptEvent(
              text: '양쪽 앞마당! 라바 회전이 2배! 뮤탈 물량전입니다!',
              owner: LogOwner.system,
              homeArmy: 3, awayArmy: 3, homeResource: 15, awayResource: 15,
              altText: '장기전 돌입! 드론 관리와 라바 운용이 승부를 가릅니다!',
            ),
            ScriptEvent(
              text: '{home}, 라바 운용이 앞섭니다! 뮤탈 스커지 비율을 잘 조절합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -2, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '장기전에서 매크로 차이가 결정적! {home} 선수 물량으로 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── J: 양쪽 앞마당 확장 → 장기전 → 어웨이 매크로 우위 ──
        ScriptBranch(
          id: 'both_expand_away',
          baseProbability: 0.4,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈이 나오지만 견제가 비등합니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 견제가 비등하자 앞마당 해처리를 올립니다!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away} 선수 앞마당 확장! 라바 회전을 늘리겠다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 앞마당! 양쪽 다 확장하면서 장기전!',
              owner: LogOwner.home,
              homeResource: -25,
              altText: '{home}, 앞마당! 상대만 확장하게 둘 수 없습니다!',
            ),
            ScriptEvent(
              text: '양쪽 앞마당! 라바 회전이 2배! 뮤탈 물량전입니다!',
              owner: LogOwner.system,
              homeArmy: 3, awayArmy: 3, homeResource: 15, awayResource: 15,
              altText: '장기전 돌입! 드론 관리와 라바 운용이 승부를 가릅니다!',
            ),
            ScriptEvent(
              text: '{away}, 라바 운용이 앞섭니다! 뮤탈 스커지 비율을 잘 조절합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '장기전에서 매크로 차이가 결정적! {away} 선수 물량으로 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── K: 홈만 앞마당 → 라바 차이로 홈 승리 ──
        ScriptBranch(
          id: 'home_expand_wins',
          baseProbability: 0.3,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈 견제가 비등합니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 견제하면서 앞마당 해처리를 슬쩍 올립니다!',
              owner: LogOwner.home,
              homeResource: -25, favorsStat: 'strategy',
              altText: '{home} 선수 앞마당 확장! 상대는 아직 본진 1해처리!',
            ),
            ScriptEvent(
              text: '{away}, 앞마당을 올린 걸 늦게 발견! 뮤탈로 해처리를 노리지만!',
              owner: LogOwner.away,
              homeResource: -5,
              altText: '{away} 선수 해처리를 끊으려 하지만 성큰이 막습니다!',
            ),
            ScriptEvent(
              text: '{home}, 앞마당이 살아남습니다! 라바 회전이 2배!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 15, favorsStat: 'macro',
              altText: '{home} 선수 앞마당 가동! 뮤탈 물량이 쏟아집니다!',
            ),
            ScriptEvent(
              text: '라바 차이가 벌어집니다! 뮤탈 물량을 따라잡을 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── L: 어웨이만 앞마당 → 라바 차이로 어웨이 승리 ──
        ScriptBranch(
          id: 'away_expand_wins',
          baseProbability: 0.3,
          conditionStat: 'strategy',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '양쪽 스파이어 완성! 뮤탈 견제가 비등합니다!',
              owner: LogOwner.system,
              homeArmy: 4, awayArmy: 4, homeResource: -15, awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 견제하면서 앞마당 해처리를 슬쩍 올립니다!',
              owner: LogOwner.away,
              awayResource: -25, favorsStat: 'strategy',
              altText: '{away} 선수 앞마당 확장! 상대는 아직 본진 1해처리!',
            ),
            ScriptEvent(
              text: '{home}, 앞마당을 올린 걸 늦게 발견! 뮤탈로 해처리를 노리지만!',
              owner: LogOwner.home,
              awayResource: -5,
              altText: '{home} 선수 해처리를 끊으려 하지만 성큰이 막습니다!',
            ),
            ScriptEvent(
              text: '{away}, 앞마당이 살아남습니다! 라바 회전이 2배!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: 15, favorsStat: 'macro',
              altText: '{away} 선수 앞마당 가동! 뮤탈 물량이 쏟아집니다!',
            ),
            ScriptEvent(
              text: '라바 차이가 벌어집니다! 뮤탈 물량을 따라잡을 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
