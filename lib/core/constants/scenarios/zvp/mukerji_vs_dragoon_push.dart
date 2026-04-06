part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 드라군 푸시: 뮤탈 견제 + 저글링 측면 vs 드라군 정면 돌파
// ----------------------------------------------------------
const _zvpMukerjiVsDragoonPush = ScenarioScript(
  id: 'zvp_mukerji_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji', 'zvp_mukerji'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '뮤탈과 저글링 vs 드라군 타이밍 푸시 — 견제와 정면의 대결',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설하며 자원을 확보합니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 앞마당 해처리 완성! 드론을 돌립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어를 올리고 드라군 생산을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 사이버네틱스 코어 건설! 드라군 체제로 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가하며 드라군 물량을 늘려갑니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 센터 정찰에 나섭니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '프로토스가 드라군 물량을 모으고 있습니다! 타이밍 푸시가 올 수 있어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 드라군 진군 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드라군 8기를 모아 저그 진영으로 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 드라군 편대가 출발합니다! 타이밍 푸시!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 완성! 뮤탈리스크를 급히 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크로 프로토스 본진을 기습합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크가 프로브를 찍습니다! 후방 견제!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 앞마당에 도착합니다! 성큰과 저글링이 맞섭니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          awayArmy: 1,
          favorsStat: 'attack',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '앞에서는 드라군, 뒤에서는 뮤탈! 양쪽 모두 위험합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 교전 확대 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 측면으로 돌려 드라군을 포위합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          awayArmy: -2,
          favorsStat: 'control',
          altText: '{home}, 저글링 서라운드! 드라군이 갇힙니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군의 사정거리를 살려 저글링을 녹입니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -3,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크가 돌아와 드라군 후방을 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -2,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '뮤탈과 저글링의 협공! 드라군이 양쪽에서 공격받고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'control',
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링 서라운드가 성공합니다! 드라군이 움직이질 못합니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -5,
              favorsStat: 'control',
              altText: '{home}, 완벽한 서라운드! 드라군이 포위당합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 후방 프로브까지 정리합니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 전멸합니다! 후속 병력이 없어요!',
              owner: LogOwner.away,
              awayArmy: -5,
            ),
            ScriptEvent(
              text: '뮤탈과 저글링의 다면 공격에 드라군 푸시가 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'attack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드라군이 성큰을 파괴하고 앞마당으로 진입합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 드라군이 성큰을 부수고 돌파합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 드라군 사정거리에 녹아내립니다!',
              owner: LogOwner.home,
              homeArmy: -5,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 해처리를 공격합니다! 저그 자원줄이 끊깁니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '드라군 타이밍 푸시 대성공! 저그가 GG! ',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
