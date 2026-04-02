part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 질럿 오프닝 vs BBS 마린 러시
// ----------------------------------------------------------
const _pvt2gateOpenVsBbs = ScenarioScript(
  id: 'pvt_2gate_open_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_2gate_open', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_bbs'],
  description: '투게이트 질럿 오프닝 vs BBS 마린 러시 — 초반 공격 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 빠르게 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 첫 게이트웨이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 배럭 건설! 공격적인 시작입니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 게이트웨이까지! 투게이트입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 투게이트 확정! 질럿을 모으겠다는 겁니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 본진 배럭까지! BBS입니다! 양쪽 다 공격 빌드네요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 센터배럭에 본진배럭까지! BBS 올인!',
        ),
        ScriptEvent(
          text: '양쪽 모두 초반부터 공격적입니다! 질럿 vs 마린, 정면충돌이 예상됩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 나옵니다! 센터로 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 초반 교전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 마린 5기를 모아 전진합니다! SCV도 끌고 갑니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 마린과 SCV 전진! 벙커를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿이 마린을 만납니다! 센터에서 부딪힙니다!',
          owner: LogOwner.home,
          homeArmy: -1,
          awayArmy: -2,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 질럿이 합류합니다! 게이트웨이 2개의 힘이죠!',
          owner: LogOwner.home,
          homeArmy: 2,
          altText: '{home}, 질럿이 계속 나옵니다! 투게이트의 장점!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 올리려 합니다! 마린이 들어가면 상황이 달라지죠!',
          owner: LogOwner.away,
          favorsStat: 'attack',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '질럿과 마린의 대결! 체력 관리가 핵심입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 중반 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 전환을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다! 드라군이 나오면 판이 바뀝니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스도 없이 마린만 뽑고 있습니다! BBS의 한계죠!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 넥서스 건설! 자원 확보에 나섭니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 넥서스! 투게이트로 상대를 막고 확장까지!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 나오기 시작합니다! 사정거리의 차이가 느껴지죠!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '프로토스 드라군이 합류하면 마린으로는 상대하기 어렵습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 프로토스 드라군 전환 성공 → 홈 승리
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드라군이 마린을 쏘아냅니다! 사정거리가 깁니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 드라군 사격! 상대 병력이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린이 줄어듭니다! 벙커 없이는 버틸 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿과 드라군이 함께 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '프로토스 병력이 압도합니다! 테란은 테크가 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 투게이트 드라군 물량! BBS를 완전히 제압합니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 드라군이 쏟아집니다! BBS는 답이 없습니다!',
            ),
          ],
        ),
        // 분기 B: BBS 초반 피해 유지 → 어웨이 승리
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린 화력이 질럿을 녹입니다! 체력이 낮은 상대 병력이 쓰러집니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -4,
              favorsStat: 'control',
              altText: '{away}, 마린 집중사격! 상대 병력이 접근 전에 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커를 완성합니다! 프로토스 진입로를 막습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브 피해가 심각합니다! 일꾼이 많이 줄었습니다!',
              owner: LogOwner.home,
              homeResource: -30,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: 'BBS 공격이 프로토스 확장을 완전히 차단했습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 물량으로 밀어냅니다! 프로토스가 회복할 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 BBS 올인 성공! 프로토스를 제압합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
