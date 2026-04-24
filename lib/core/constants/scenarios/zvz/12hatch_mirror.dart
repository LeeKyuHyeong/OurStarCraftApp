part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12앞마당 미러 (수비형 미러)
// 12앞 미러전
// 오프닝 : 9개드론, 오버로드생산, 드론3기 추가, 앞마당 해처리 건설, 스포닝풀 건설, 가스 건설, 스포닝완성 후 4저글링 뽑는 것 까지 동일
//
// phase1 (저글링 페이즈)
// 	분기1-A : '방심'(이건 멘트에만 추가) 과 '컨트롤 차이' 로 서로 부유한 빌드지만 초반 저글링 싸움에서 home 승리 하며 away 앞마당 해처리 취소 or 파괴 > home 승 (control)  (희박확률)
// 	분기1-B : '방심'(이건 멘트에만 추가) 과 '컨트롤 차이' 로 서로 부유한 빌드지만 초반 저글링 싸움에서 away 승리 하며 home 앞마당 해처리 취소 or 파괴 > away 승 (control)		(희박확률)
// 	분기1-C : 서로 앞마당 확인하고 레어 올리면서 뮤탈 싸움 준비하며 다음 페이즈
// 								- home 저글링 소수로 상대방 앞마당 or 본진 드론 견제 (skipChance)
// 								- away 저글링 소수로 상대방 앞마당 or 본진 드론 견제 (skipChance)
//
// phase2 (중반 뮤탈 페이즈)
// 	분기2-A : home 뮤탈 싸움에서 스커지 컨트롤 까지 더해지며 교전 승리 > home 승 (control+harass)
// 								- home의 소수 저글링이 상대방 본진 진입하여 드론 2기 제거 (skipChance)
// 								- home의 뮤탈이 상대방 오버로드 1기 제거 (skipChance)
// 	분기2-B : away 가 오버로드 피해, 드론 피해를 조금씩 축적시키며 뮤탈 싸움에서 스커지 컨트롤 까지 더해지며 교전 승리 > away 승 (control+harass)
// 								- away의 소수 저글링이 상대방 본진 진입하여 드론 2기 제거 (skipChance)
// 								- away의 뮤탈이 상대방 오버로드 1기 제거 (skipChance)
// 	분기2-C : 비등비등하게 견제 서로 주고 받으면서 뮤탈을 모으고 뮤탈 업그레이드 (공중 업그레이드라고 해도 되고) 서로 진행하며 다음 페이즈
// 								- home의 소수 저글링이 상대방 앞마당 진입하여 드론 2기 제거 (skipChance)
// 								- away의 소수 저글링이 상대방 본진 진입하여 드론 2기 제거 (skipChance)
//
// phase3 (후반 뮤탈 페이즈)
// 	분기3-A : home이 약간 더 빠른 업그레이드 완료 및 해당 타이밍에 대규모 뮤탈 교전 승리 > home 승 (strategy+sense)
// 								- home의 스커지가 away 뮤탈에 적중 (skipChance)
// 	분기3-B : away가 약간 더 빠른 업그레이드 완료 및 해당 타이밍에 대규모 뮤탈 교전 승리 > away 승 (strategy+sense)
// 								- away의 스커지가 home 뮤탈에 적중 (skipChance)
// 	분기3-C : 업그레이드 속도 차이가 벌어지지 않으며 유지됨, 디바우러를 위해 그레이트 스파이어 진화하고 본진 해처리 추가하며(home과 away가 동일하게 안했으면, home-그레이트스파이어/본진해처리추가, away-본진해처리추가/그레이트스파이어 이런식으로) 다음 페이즈
//
// phase4 (디바우러 페이즈)
// 	분기4-A : 더이상 미룰 수 없는 대규모 뮤탈,스커지,디바우러 싸움을 통해 한끗차이로 home이 교전 승리 및 추가 병력 계속 합류하며 최종 승리 > home 승(control)
// 	분기4-B : 더이상 미룰 수 없는 대규모 뮤탈,스커지,디바우러 싸움을 통해 한끗차이로 away가 교전 승리 및 추가 병력 계속 합류하며 최종 승리 > away 승(control)
//
// ----------------------------------------------------------
const _zvz12hatchMirror = ScenarioScript(
  id: 'zvz_12hatch_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch'],
  awayBuildIds: ['zvz_12hatch'],
  description: '12앞마당 미러 후반 대결',
  phases: [
    // ── Phase 0: 오프닝 ──
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 9개까지 뽑습니다.',
          altText: '{home} 선수, 9드론까지 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100,
        ),
        ScriptEvent(
          text: '{away} 선수도 드론 9개까지 찍습니다.',
          altText: '{away} 선수, 9드론까지 생산합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100,
        ),
        ScriptEvent(
          text: '{home} 선수 오버로드를 올립니다!',
          altText: '{home} 선수, 오버로드 생산!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -100,
        ),
        ScriptEvent(
          text: '{away} 선수도 오버로드 생산!',
          altText: '{away} 선수, 역시 오버로드!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100,
        ),
        ScriptEvent(
          text: '{home} 선수 드론을 3기 더 뽑아 12드론에 앞마당 해처리 건설!',
          altText: '{home} 선수, 드론 3기를 추가한 뒤 앞마당 해처리를 먼저 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -300,
          homeExpansion: true,
        ),
        ScriptEvent(
          text: '{away} 선수도 드론 3기 추가 후 12드론에 앞마당 해처리!',
          altText: '{away} 선수도 드론 3기를 추가해서 앞마당부터 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -300,
          awayExpansion: true,
        ),
        ScriptEvent(
          text: '상대가 빠른 풀이면 큰일인데 배짱이 대단합니다!',
          altText: '상대가 빠른 풀을 올리는 빌드였으면 큰일날 뻔했는데 배짱이 좋습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설! 저글링을 준비합니다.',
          altText: '{home} 선수, 앞마당 올리고 스포닝풀! 스탠다드한 흐름!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -200,
        ),
        ScriptEvent(
          text: '{away} 선수도 스포닝풀! 저글링 생산에 들어갑니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -200,
        ),
        ScriptEvent(
          text: '{home} 선수 익스트랙터 건설! 가스를 채취합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3,
          homeResource: -150,
        ),
        ScriptEvent(
          text: '{away} 선수도 가스! 저글링 6기 생산합니다!',
          owner: LogOwner.away,
          homeArmy: 3,
          homeResource: 0,
          awayArmy: 3,
          awayResource: -150,
        ),
      ],
    ),

    // ── Phase 1: 저글링 페이즈 ──
    ScriptPhase(
      name: 'ling_fight',
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 1-A: home 저글링 컨트롤 → away 앞마당 파괴 → home 승 (희박)
        ScriptBranch(
          id: 'home_ling_crush',
          description: '(phase1) 분기A - 저글링 홈 승',
          baseProbability: 0.2,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 드론에 집중하느라 저글링 관리가 소홀합니다!',
              altText: '{away} 선수 방심한 틈! 저글링이 제 위치에 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: -1,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 컨트롤! 상대 저글링을 각개격파합니다!',
              altText: '{home} 선수, 저글링 수 차이를 만들어냅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: -2,
              homeResource: 0,
              awayResource: -100,
            ),
            ScriptEvent(
              text: '{home} 선수 남은 저글링이 앞마당 해처리를 부숩니다! 드론까지 잡아냅니다!',
              altText: '{home} 선수, 앞마당 해처리가 무너집니다! 일꾼까지 쓸어갑니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              text: '앞마당 투자가 전부 날아갔습니다! {away} 선수 회복이 불가능합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 1-B: away 저글링 컨트롤 → home 앞마당 파괴 → away 승 (희박)
        ScriptBranch(
          id: 'away_ling_crush',
          description: '(phase1) 분기B - 저글링 어웨이 승',
          baseProbability: 0.2,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 드론에 집중하느라 저글링 관리가 소홀합니다!',
              altText: '{home} 선수 방심한 틈! 저글링이 제 위치에 없습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 컨트롤! 상대 저글링을 각개격파합니다!',
              altText: '{away} 선수, 저글링 수 차이를 만들어냅니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              awayArmy: 0,
              homeResource: -100,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 남은 저글링이 앞마당 해처리를 부숩니다! 드론까지 잡아냅니다!',
              altText: '{away} 선수, 앞마당 해처리가 무너집니다! 일꾼까지 쓸어갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: -1,
              homeResource: -300,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '앞마당 투자가 전부 날아갔습니다! {home} 선수 회복이 불가능합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 1-C: 비등, 레어로
        ScriptBranch(
          id: 'ling_even',
          description: '(phase1) 분기C - 저글링 비등',
          baseProbability: 1.2,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '오버로드로 서로의 빌드를 확인합니다!',
              altText: '오버로드로 상대 빌드가 보입니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '양쪽 저글링이 센터에서 맞붙습니다! 비슷한 피해를 주고받습니다!',
              altText: '저글링 소모전! 큰 이득 없이 서로 소비합니다!',
              owner: LogOwner.system,
              homeArmy: -1,
              awayArmy: -1,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링으로 상대 앞마당 드론을 물어뜯습니다!',
              altText: '{home} 선수, 저글링 견제! 드론 피해를 줍니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 본진으로 침투합니다! 드론을 괴롭힙니다!',
              altText: '{away} 선수, 저글링 견제로 상대 드론을 잡습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -100,
              awayResource: 0,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '비등한 저글링 싸움! 양쪽 레어 진화를 시작합니다!',
              altText: '이제 테크 싸움입니다! 양쪽 레어 진화!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -250,
              awayResource: -250,
            ),
          ],
        ),
      ],
    ),

    // ── Phase 2: 스파이어 + 뮤탈 생산 (linear) ──
    ScriptPhase(
      name: 'spire_build',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어 완성! 스파이어를 바로 올립니다!',
          altText: '{home} 선수, 레어 완성! 테크가 올라갑니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -350,
        ),
        ScriptEvent(
          text: '{away} 선수도 레어 완성! 스파이어 건설!',
          altText: '{away} 선수, 레어에 이어 스파이어! 양쪽 공중전이 본격화됩니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -350,
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 생산 시작! 스커지도 섞습니다!',
          altText: '{home} 선수, 뮤탈에 스커지까지! 공중 편대를 구성합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6,
          homeResource: -500,
        ),
        ScriptEvent(
          text: '{away} 선수도 뮤탈 편대 완성! 스커지도 섞습니다!',
          altText: '{away} 선수 뮤탈리스크와 스커지! 공중전 준비 완료!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 6,
          awayResource: -500,
        ),
      ],
    ),

    // ── Phase 3: 중반 뮤탈 (주석 Phase 2) ──
    ScriptPhase(
      name: 'mid_mutal',
      branches: [
        // 분기 2-A: home 뮤탈+스커지 교전 승리 → home 승
        ScriptBranch(
          id: 'home_mutal_win',
          description: '(phase3) 분기A - 뮤탈 홈 승',
          baseProbability: 0.5,
          conditionStat: 'control+harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 상대 본진에 침투합니다! 드론을 잡아냅니다!',
              altText: '{home} 선수, 소수 저글링으로 본진 드론 견제!',
              owner: LogOwner.home,
              homeArmy: -1,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈로 오버로드를 잡습니다! 보급이 막힙니다!',
              altText: '{home} 선수, 뮤탈이 오버로드를 격추! 보급에 타격!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: -1,
              homeResource: 0,
              awayResource: -50,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈과 스커지로 정면 교전! 스커지가 정확히 적중합니다!',
              altText: '{home} 선수, 스커지 컨트롤이 빛납니다! 상대 뮤탈이 녹습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              awayArmy: -4,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '뮤탈 수 차이가 결정적! {home} 선수 남은 뮤탈로 드론을 쓸어갑니다!',
              altText: '제공권을 잡았습니다! {home} 선수, 뮤탈로 상대를 초토화합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -200,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-B: away 뮤탈+스커지 교전 승리 → away 승
        ScriptBranch(
          id: 'away_mutal_win',
          description: '(phase3) 분기B - 뮤탈 어웨이 승',
          baseProbability: 0.5,
          conditionStat: 'control+harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 본진에 침투합니다! 드론을 잡아냅니다!',
              altText: '{away} 선수, 소수 저글링으로 본진 드론 견제!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: -1,
              homeResource: -100,
              awayResource: 0,
              skipChance: 0.4,
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 오버로드를 잡습니다! 보급이 막힙니다!',
              altText: '{away} 선수, 뮤탈이 오버로드를 격추! 보급에 타격!',
              owner: LogOwner.away,
              homeArmy: -1,
              awayArmy: 0,
              homeResource: -50,
              awayResource: 0,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈과 스커지로 정면 교전! 스커지가 정확히 적중합니다!',
              altText: '{away} 선수, 스커지 컨트롤이 빛납니다! 상대 뮤탈이 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              awayArmy: -2,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '뮤탈 수 차이가 결정적! {away} 선수 남은 뮤탈로 드론을 쓸어갑니다!',
              altText: '제공권을 잡았습니다! {away} 선수, 뮤탈로 상대를 초토화합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -200,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-C: 비등, 뮤탈 업그레이드로
        ScriptBranch(
          id: 'mutal_even',
          description: '(phase3) 분기C - 뮤탈 비등',
          baseProbability: 0.6,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '뮤탈 교전! 양쪽 스커지가 서로를 노립니다!',
              altText: '뮤탈과 스커지가 뒤엉킵니다! 치열한 공중전!',
              owner: LogOwner.system,
              homeArmy: -2,
              awayArmy: -2,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 상대 앞마당에 침투! 드론을 물어뜯습니다!',
              altText: '{home} 선수, 저글링 견제! 앞마당 드론 피해!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 본진을 노립니다! 드론을 잡아냅니다!',
              altText: '{away} 선수, 저글링으로 본진 드론 견제!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -100,
              awayResource: 0,
              skipChance: 0.5,
            ),
            ScriptEvent(
              text: '비등한 뮤탈 싸움! 양쪽 이볼루션챔버에서 공중 공격력 업그레이드를 시작합니다!',
              altText: '뮤탈 교전이 비등합니다! 양쪽 공중 업그레이드 진행!',
              owner: LogOwner.system,
              homeArmy: 2,
              awayArmy: 2,
              homeResource: -275,
              awayResource: -275,
            ),
          ],
        ),
      ],
    ),

    // ── Phase 4: 후반 뮤탈 (주석 Phase 3) ──
    ScriptPhase(
      name: 'late_mutal',
      branches: [
        // 분기 3-A: home 업그레이드 빠름 → 대규모 교전 승리
        ScriptBranch(
          id: 'home_upgrade_win',
          description: '(phase4) 분기A - 업그레이드 홈 승',
          baseProbability: 0.5,
          conditionStat: 'strategy+sense',
          events: [
            ScriptEvent(
              text: '{home} 선수 공중 업그레이드가 먼저 완료됩니다! 타이밍을 노립니다!',
              altText: '{home} 선수, 업그레이드 차이! 지금이 교전 타이밍!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: 0,
              homeResource: -300,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 스커지가 상대 뮤탈에 적중합니다! 뮤탈 2기가 떨어집니다!',
              altText: '{home} 선수, 스커지 명중! 한 순간에 뮤탈 수가 뒤집힙니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              awayArmy: -4,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 업그레이드 차이로 대규모 뮤탈 교전 승리! 상대 뮤탈이 녹습니다!',
              altText: '{home} 선수, 한 방 차이가 누적됩니다! 뮤탈이 하나씩 떨어집니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              awayArmy: -3,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '제공권 장악! {home} 선수 남은 뮤탈로 상대를 마무리합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              decisive: true,
            ),
          ],
        ),
        // 분기 3-B: away 업그레이드 빠름 → 대규모 교전 승리
        ScriptBranch(
          id: 'away_upgrade_win',
          description: '(phase4) 분기B - 업그레이드 어웨이 승',
          baseProbability: 0.5,
          conditionStat: 'strategy+sense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 공중 업그레이드가 먼저 완료됩니다! 타이밍을 노립니다!',
              altText: '{away} 선수, 업그레이드 차이! 지금이 교전 타이밍!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 3,
              homeResource: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              text: '{away} 선수 스커지가 상대 뮤탈에 적중합니다! 뮤탈 2기가 떨어집니다!',
              altText: '{away} 선수, 스커지 명중! 한 순간에 뮤탈 수가 뒤집힙니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              awayArmy: -2,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 차이로 대규모 뮤탈 교전 승리! 상대 뮤탈이 녹습니다!',
              altText: '{away} 선수, 한 방 차이가 누적됩니다! 뮤탈이 하나씩 떨어집니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              awayArmy: -1,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '제공권 장악! {away} 선수 남은 뮤탈로 상대를 마무리합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -300,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 3-C: 비등, 그레이트 스파이어 + 본진 해처리
        ScriptBranch(
          id: 'upgrade_even',
          description: '(phase4) 분기C - 업그레이드 비등',
          baseProbability: 0.5,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '업그레이드 속도가 비슷합니다! 뮤탈 교전이 길어집니다!',
              altText: '양쪽 업그레이드가 엇비슷합니다! 소모전이 계속됩니다!',
              owner: LogOwner.system,
              homeArmy: -2,
              awayArmy: -2,
              homeResource: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 그레이트 스파이어 진화를 시작합니다! 디바우러를 노리는데요!',
              altText: '{home} 선수, 그레이트 스파이어! 디바우러 생산을 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -250,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 본진에 해처리를 추가합니다! 라바를 늘립니다!',
              altText: '{home} 선수, 본진 해처리 추가! 물량전을 준비합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: -300,
              awayResource: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 본진 해처리를 추가합니다! 이어서 그레이트 스파이어도 진화!',
              altText: '{away} 선수, 본진 해처리와 그레이트 스파이어! 후반을 준비합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -550,
            ),
          ],
        ),
      ],
    ),

    // ── Phase 5: 디바우러 (주석 Phase 4) ──
    ScriptPhase(
      name: 'devourer_clash',
      branches: [
        // 분기 4-A: home 디바우러 싸움 승리
        ScriptBranch(
          id: 'home_devourer_win',
          description: '(phase5) 분기A - 디바우러 홈 승',
          baseProbability: 0.5,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 그레이트 스파이어 완성! 뮤탈이 디바우러로 변태합니다!',
              altText: '{home} 선수, 디바우러 변태! 강력한 공대공 유닛이 합류합니다!',
              owner: LogOwner.home,
              awayArmy: 0, awayResource: 0,
              homeArmy: 3, homeResource: -400,
            ),
            ScriptEvent(
              text: '{away} 선수도 디바우러 변태! 대규모 공중전이 펼쳐집니다!',
              altText: '{away} 선수, 디바우러 합류! 뮤탈과 스커지까지 뒤섞입니다!',
              owner: LogOwner.away,
              homeArmy: 0, homeResource: 0,
              awayArmy: 3, awayResource: -400,
            ),
            ScriptEvent(
              text: '디바우러와 뮤탈과 스커지가 뒤엉킵니다! 대규모 공중전!',
              altText: '전 병력이 맞붙습니다! ZvZ 최후반 공중 대전투!',
              owner: LogOwner.system,
              homeArmy: -3, awayArmy: -3,
              homeResource: 0, awayResource: 0,
            ),
            ScriptEvent(
              text: '{home} 선수 디바우러 산성 포자가 상대 뮤탈을 녹입니다! 한끗 차이!',
              altText: '{home} 선수, 디바우러 위치 선점! 상대 공중 병력이 무너집니다!',
              owner: LogOwner.home,
              homeArmy: -1, awayArmy: -3,
              homeResource: 0, awayResource: -200,
            ),
            ScriptEvent(
              text: '추가 병력이 계속 합류합니다! {home} 선수 최종 승리!',
              altText: '라바에서 쏟아지는 추가 뮤탈! {home} 선수가 제공권을 가져갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: 0,
              homeResource: -200, awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 4-B: away 디바우러 싸움 승리
        ScriptBranch(
          id: 'away_devourer_win',
          description: '(phase5) 분기B - 디바우러 어웨이 승',
          baseProbability: 0.5,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 그레이트 스파이어 완성! 뮤탈이 디바우러로 변태합니다!',
              altText: '{away} 선수, 디바우러 변태! 강력한 공대공 유닛이 합류합니다!',
              owner: LogOwner.away,
              homeArmy: 0, homeResource: 0,
              awayArmy: 3, awayResource: -400,
            ),
            ScriptEvent(
              text: '{home} 선수도 디바우러 변태! 대규모 공중전이 펼쳐집니다!',
              altText: '{home} 선수, 디바우러 합류! 뮤탈과 스커지까지 뒤섞입니다!',
              owner: LogOwner.home,
              awayArmy: 0, awayResource: 0,
              homeArmy: 3, homeResource: -400,
            ),
            ScriptEvent(
              text: '디바우러와 뮤탈과 스커지가 뒤엉킵니다! 대규모 공중전!',
              altText: '전 병력이 맞붙습니다! ZvZ 최후반 공중 대전투!',
              owner: LogOwner.system,
              homeArmy: -3, awayArmy: -3,
              homeResource: 0, awayResource: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 디바우러 산성 포자가 상대 뮤탈을 녹입니다! 한끗 차이!',
              altText: '{away} 선수, 디바우러 위치 선점! 상대 공중 병력이 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1,
              homeResource: -200, awayResource: 0,
            ),
            ScriptEvent(
              text: '추가 병력이 계속 합류합니다! {away} 선수 최종 승리!',
              altText: '라바에서 쏟아지는 추가 뮤탈! {away} 선수가 제공권을 가져갑니다!',
              owner: LogOwner.away,
              homeArmy: 0, awayArmy: 3,
              homeResource: 0, awayResource: -200,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
