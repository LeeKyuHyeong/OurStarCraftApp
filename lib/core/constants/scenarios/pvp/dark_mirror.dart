part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 10. 다크 올인 미러 (다크 vs 다크)
// ----------------------------------------------------------
const _pvpDarkMirror = ScenarioScript(
  id: 'pvp_dark_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_dark_allin'],
  description: '다크 올인 미러',
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
          text: '{home} 선수 아둔! 다크를 노립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -20,
          altText: '{home} 선수, 아둔! 다크 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아둔! 양쪽 다 다크를 노리는 상황입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 아둔! 양쪽 다 다크를 노리네요!',
        ),
        ScriptEvent(
          text: '양측 다크 올인! 서로 상대 다크를 모르는 상황!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_deploy',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대 진영으로!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -20,
          altText: '{home} 선수, 다크 출발! 보이지 않는 칼!',
        ),
        ScriptEvent(
          text: '{away} 선수도 다크 2기! 교차 투입!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 다크 출발! 서로 다크를 보냅니다!',
        ),
        ScriptEvent(
          text: '양쪽 다크가 교차합니다! 디텍은 누구에게도 없습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'dark_result',
      branches: [
        // 분기 A: 홈 다크가 더 큰 피해
        ScriptBranch(
          id: 'home_dark_more_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 다크가 프로브에 도착! 학살!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -25,              altText: '{home} 선수 다크 성공! 프로브가 몰살!',
            ),
            ScriptEvent(
              text: '{away} 선수, 다크가 상대 프로브도 베고 있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,            ),
            ScriptEvent(
              text: '{home} 선수 다크 컨트롤! 프로브를 더 많이 잡았습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,            ),
            ScriptEvent(
              text: '다크 교환! 프로브 피해 차이가 승부를 가릅니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 어웨이 다크가 더 큰 피해
        ScriptBranch(
          id: 'away_dark_more_damage',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수, 다크가 프로브를 베기 시작합니다! 큰 피해!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -25,              altText: '{away} 선수 다크 대성공! 프로브가 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 다크가 프로브를 잡고는 있지만 피해가 적습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,            ),
            ScriptEvent(
              text: '{away} 선수 다크 컨트롤! 더 많은 프로브를 잡습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -10,            ),
            ScriptEvent(
              text: '다크 교환에서 밀렸습니다! 프로브 차이가 크네요!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 복구전 (lines 39-52)
    ScriptPhase(
      name: 'recovery_battle',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 캐논을 건설합니다! 추가 다크에 대비!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 캐논! 양쪽 다크 대비!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어! 드라군 테크!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 다크 교환 이후 테크 전환입니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 로보틱스를 올립니다! 테크를 전환하는 모습!',
        ),
        ScriptEvent(
          text: '{home} 선수 서포트 베이에 옵저버터리까지! 리버를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,
          altText: '{home} 선수, 옵저버터리와 서포트 베이 건설! 리버를 노리고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 로보틱스 건설! 테크 경쟁입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 옵저버터리에 서포트 베이까지! 셔틀 리버 경쟁!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수, 드라군을 모아 전진합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -15,
          altText: '{home} 선수 드라군 편대 전진!',
        ),
        ScriptEvent(
          text: '{away} 선수, 드라군으로 맞대응! 병력을 모읍니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수도 드라군 편대를 구성합니다!',
        ),
      ],
    ),
    // Phase 4: 결전 분기 (lines 53-65)
    ScriptPhase(
      name: 'decisive_clash',
      branches: [
        ScriptBranch(
          id: 'home_recovers_faster',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 프로브를 먼저 복구! 자원이 돌아옵니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: 10,              altText: '{home} 선수 일꾼 복구가 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 셔틀 리버 출격! 남은 프로브를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,            ),
            ScriptEvent(
              text: '다크 교환 이후 복구전에서 앞섭니다!',
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
          id: 'away_recovers_faster',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수, 프로브를 먼저 복구! 자원이 돌아옵니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: 10,              altText: '{away} 선수 일꾼 복구가 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 셔틀 리버 출격! 남은 프로브를 노립니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,            ),
            ScriptEvent(
              text: '다크 교환 이후 복구전에서 앞섭니다!',
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
