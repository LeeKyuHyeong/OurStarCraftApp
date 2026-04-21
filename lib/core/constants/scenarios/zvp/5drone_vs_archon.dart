part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 아콘 조합 (올인 vs 밸런스)
// ----------------------------------------------------------
const _zvp5droneVsArchon = ScenarioScript(
  id: 'zvp_5drone_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_trans_archon', 'pvz_corsair_reaver'],
  description: '9투 올인 저글링 vs 하이템플러와 아콘 조합',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 올립니다! 빠른 저글링을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 드론 5마리 후 스포닝풀 건설! 빠른 저글링!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 건물 건설! 하이템플러를 향한 테크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 발업도 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿을 먼저 생산하면서 아둔 건설을 시작합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 질럿 생산! 아둔까지 시간을 벌어야 합니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 입구에 도착합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 도착! 질럿이 막고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿으로 입구를 봉쇄합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,          altText: '{away}, 입구 막기! 저글링을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 질럿을 에워싸면서 공격합니다!',
          owner: LogOwner.home,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -1, homeArmy: -1,          altText: '{home}, 서라운드 시도! 질럿을 포위합니다!',
        ),
        ScriptEvent(
          text: '{away}, 프로브까지 동원해서 시간을 법니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,
        ),
        ScriptEvent(
          text: '하이템플러까지는 아직 시간이 필요합니다! 질럿으로 버텨야 하죠!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 보냅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 웨이브! 아콘이 나오기 전에 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔이 완성되고 템플러 아카이브를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 템플러 아카이브 건설! 하이템플러가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{home}, 시간이 흐를수록 불리해집니다! 빠르게 끝내야!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,        ),
        ScriptEvent(
          text: '{away}, 질럿을 모아서 저글링을 잡으면서 하이템플러를 기다립니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2, homeArmy: -2,        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 하이템플러 나오기 전에 프로브를 전멸시킵니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -3,              altText: '{home} 선수 프로브 전멸! 아콘이 나오기 전에 끝냈습니다!',
            ),
            ScriptEvent(
              text: '템플러 테크가 완성되기 전에 승부가 결정됩니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 하이템플러가 나와서 사이오닉 스톰으로 저글링을 녹입니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 4,              altText: '{away} 선수 스톰! 저글링이 한 번에 전멸합니다!',
            ),
            ScriptEvent(
              text: '하이템플러와 아콘! 저글링을 완전히 제압합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
