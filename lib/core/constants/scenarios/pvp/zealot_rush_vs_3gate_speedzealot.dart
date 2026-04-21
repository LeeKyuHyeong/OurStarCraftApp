part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 vs 쓰리게이트 스피드질럿
// ----------------------------------------------------------
const _pvpZealotRushVs3gateSpeedzealot = ScenarioScript(
  id: 'pvp_zealot_rush_vs_3gate_speedzealot',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '질럿 러시 vs 쓰리게이트 스피드질럿',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
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
          text: '{home} 선수 센터에 게이트웨이! 빠른 질럿 러시!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 센터 게이트! 질럿을 빠르게 보냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔 건설! 스피드질럿을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 아둔! 각속 업그레이드를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 게이트웨이를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '질럿 러시 vs 스피드질럿! 질럿 대 질럿 승부!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 질럿 러시 돌진 (lines 13-18)
    ScriptPhase(
      name: 'zealot_rush',
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿 3기가 돌진합니다! 각속 전에 끝내야 합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 4,          altText: '{home} 선수 질럿 러시! 스피드질럿이 나오기 전에!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿으로 막으면서 각속을 기다립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 3,
        ),
        ScriptEvent(
          text: '센터 질럿이 먼저 도착! 각속이 완료되기 전에 밀 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 19-34)
    ScriptPhase(
      name: 'zealot_clash',
      branches: [
        // 분기 A: 러시가 먼저 밀어냄
        ScriptBranch(
          id: 'rush_overwhelms',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 질럿이 상대 질럿을 밀어냅니다! 수적 우위!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,              altText: '{home} 선수 질럿 교전 승리! 프로브를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 밀리고 있습니다! 각속이 아직입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 프로브까지 잡습니다! 러시 성공!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -15,            ),
            ScriptEvent(
              text: '질럿 러시가 각속보다 빨랐습니다! 본진이 무너집니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 각속 완료 후 역전
        ScriptBranch(
          id: 'speedzealot_counter',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 각속 완료! 스피드질럿이 쏟아집니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 4,              altText: '{away} 선수 각속 업그레이드 완료! 빠른 질럿!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 밀립니다! 스피드질럿이 빠릅니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 게이트웨이 세 개에서 스피드질럿이 끊임없이 나옵니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 3, awayResource: -15,
            ),
            ScriptEvent(
              text: '스피드질럿 물량! 센터 러시를 역전합니다!',
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
