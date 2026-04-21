part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 질럿 러시 (1:1)
// ----------------------------------------------------------
const _pvpDarkVsZealotRushSingle = ScenarioScript(
  id: 'pvp_dark_vs_zealot_rush_single',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_zealot_rush'],
  description: '다크 올인 vs 질럿 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
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
          text: '{away} 선수 프로브를 앞으로 보냅니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크 테크!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home}, 아둔! 다크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 게이트웨이! 질럿 러시입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 센터에 게이트웨이! 질럿을 쏟아냅니다!',
        ),
        ScriptEvent(
          text: '치즈 vs 치즈! 다크 올인과 질럿 러시의 대결!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 13-20)
    ScriptPhase(
      name: 'zealot_rush_arrives',
      linearEvents: [
        ScriptEvent(
          text: '{away}, 질럿 3기가 상대 진영으로 돌진합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 4,          altText: '{away} 선수 질럿 러시! 다크가 나오기 전에 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 1기로 막으면서 다크를 기다립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 3,
          altText: '{home}, 질럿 한 기로 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설 중! 다크까지 버틸 수 있을까요?',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'cheese_result',
      branches: [
        // 분기 A: 질럿 러시가 다크 전에 밀어버림
        ScriptBranch(
          id: 'zealot_overruns',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 게이트웨이를 부수고 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -2, homeResource: -10,              altText: '{away} 선수 질럿이 건물을 부수기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브가 잡히고 있습니다! 다크가 아직이에요!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 추가 질럿 합류! 템플러 아카이브도 위험합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              awayArmy: 2, homeResource: -10,            ),
            ScriptEvent(
              text: '질럿 러시가 다크보다 빨랐습니다! 본진이 무너집니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 다크가 나오면서 역전
        ScriptBranch(
          id: 'dark_comes_out',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 다크 템플러가 나옵니다! 질럿 러시를 버텨냈습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3,              altText: '{home} 선수 다크 등장! 보이지 않는 반격!',
            ),
            ScriptEvent(
              text: '{away} 선수 다크가 질럿을 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,
              altText: '{away}, 질럿이 다크에 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{home}, 다크를 상대 본진으로 보냅니다! 역습!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,            ),
            ScriptEvent(
              text: '다크 템플러가 판을 뒤집습니다! 질럿 러시 실패!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
