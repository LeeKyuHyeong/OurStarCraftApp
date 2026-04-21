part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 쓰리게이트 스피드질럿 vs 원게이트 로보 (물량 압박 vs 테크)
// ----------------------------------------------------------
const _pvp3gateSpeedzealotVs1gateRobo = ScenarioScript(
  id: 'pvp_3gate_speedzealot_vs_1gate_robo',
  matchup: 'PvP',
  homeBuildIds: ['pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_1gate_robo'],
  description: '쓰리게이트 스피드질럿 vs 원게이트 로보',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어! 아둔 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 아둔! 스피드 질럿!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어! 로보틱스 건설!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away}, 로보틱스! 리버를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 세 번째 게이트웨이를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 서포트 베이! 리버 준비!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -10, awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 다리 업그레이드 시작!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 다리 업그레이드! 스피드 질럿을 만듭니다!',
        ),
        ScriptEvent(
          text: '스피드질럿 물량 vs 로보틱스 테크! 속도 vs 테크의 대결!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 스피드 질럿 압박 (lines 15-22)
    ScriptPhase(
      name: 'speedzealot_pressure',
      linearEvents: [
        ScriptEvent(
          text: '{home}, 스피드 질럿이 전진합니다! 빠릅니다!',
          owner: LogOwner.home,
          awayResource: 0,
          homeArmy: 5, awayArmy: 2, homeResource: -25,          altText: '{home} 선수 스피드 질럿! 빠른 속도로 돌진!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군과 질럿으로 막습니다! 리버가 나와야!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 1, awayResource: -15,
          altText: '{away}, 수비! 리버까지 버텨야 합니다!',
        ),
        ScriptEvent(
          text: '스피드 질럿 물량 vs 로보 테크! 시간 싸움!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 교전 결과 (lines 23-38)
    ScriptPhase(
      name: 'clash_result',
      branches: [
        ScriptBranch(
          id: 'speedzealot_overwhelm',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 스피드 질럿이 프로브를 사냥합니다! 빠른 속도!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,              altText: '{home} 선수 질럿이 프로브에 도달! 수비가 안 돼요!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 부족합니다! 질럿 속도를 따라갈 수 없어요!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 추가 질럿이 합류합니다! 물량이 밀려옵니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -15,            ),
            ScriptEvent(
              text: '스피드 질럿이 압도합니다! 테크 전에 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'reaver_holds',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{away}, 드라군으로 질럿을 잡습니다! 리버가 합류!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,              altText: '{away} 선수 수비 성공! 리버가 나왔습니다!',
            ),
            ScriptEvent(
              text: '{away}, 리버 스캐럽! 밀집한 질럿이 터집니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: 2,              altText: '{away} 선수 리버 스캐럽! 질럿이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 리버 화력에 녹고 있습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '리버가 전세를 뒤집습니다! 질럿으로는 상대할 수 없어요!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 39-48)
    ScriptPhase(
      name: 'late_game',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드라군을 섞어 편대를 구성합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 셔틀 리버로 견제! 프로브를 노립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러 준비! 스톰 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 하이 템플러! 스톰 대결!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 하이 템플러까지 합류! 전면전!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 49-60)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_storm_zealot_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰에 스피드 질럿 돌진! 상대 병력을 녹입니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10, homeArmy: -5,              altText: '{home} 선수 스톰! 질럿이 남은 병력을 추격!',
            ),
            ScriptEvent(
              text: '스톰과 질럿의 조합! 결정적!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_reaver_storm_combo',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰에 리버 화력! 상대 병력이 녹습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10, awayArmy: -5,              altText: '{away} 선수 스톰과 리버! 이중 화력!',
            ),
            ScriptEvent(
              text: '리버와 스톰이 결정적! 전장을 지배합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
