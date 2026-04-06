part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 쓰리게이트 스피드질럿 미러
// ----------------------------------------------------------
const _pvp3gateSpeedzealotMirror = ScenarioScript(
  id: 'pvp_3gate_speedzealot_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '쓰리게이트 스피드질럿 미러 - 스피드 질럿 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 질럿 다리 업그레이드를 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아둔! 스피드 질럿을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아둔! 양쪽 스피드 질럿!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아둔! 미러 스피드 질럿 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가! 3게이트!',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수도 3게이트! 양쪽 물량 경쟁!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '양쪽 쓰리게이트 스피드질럿! 물량 싸움!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 스피드 질럿 생산 (lines 10-22)
    ScriptPhase(
      name: 'speedzealot_production',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '양측 질럿 다리 업그레이드 완료! 스피드 질럿이 쏟아집니다!',
          owner: LogOwner.system,
          homeArmy: 5, awayArmy: 5, homeResource: -25, awayResource: -25,
          altText: '{home}과 {away}, 스피드 질럿 동시 생산!',
        ),
        ScriptEvent(
          text: '{home}, 질럿이 전진합니다! 상대 앞마당을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 스피드 질럿 전진! {away}도 맞불!',
        ),
        ScriptEvent(
          text: '양측 스피드 질럿이 교차합니다! 견제와 방어의 판단!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 질럿 교전 결과 (lines 23-38)
    ScriptPhase(
      name: 'zealot_clash',
      startLine: 23,
      branches: [
        ScriptBranch(
          id: 'home_zealot_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스피드 질럿이 상대 프로브를 사냥합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 질럿 견제! 프로브가 달아납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿으로 방어! 하지만 프로브 피해가 있습니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 프로브 피해를 입혔습니다! 자원 이점!',
              owner: LogOwner.home,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '질럿 견제가 성공! 자원 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_zealot_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스피드 질럿이 상대 프로브를 사냥합니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 질럿 견제! 프로브가 달아납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿으로 방어! 하지만 프로브 피해가 있습니다!',
              owner: LogOwner.home,
              awayArmy: -1, homeArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away}, 프로브 피해를 입혔습니다! 자원 이점!',
              owner: LogOwner.away,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '질럿 견제가 성공! 자원 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 드라군 전환 (lines 39-50)
    ScriptPhase(
      name: 'dragoon_transition',
      startLine: 39,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드라군 생산을 병행합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 드라군을 섞어 편대를 구성합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 생산! 질럿과 함께!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔에서 템플러 아카이브! 하이 템플러 준비!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 템플러 아카이브! 스톰 경쟁!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양측 스피드 질럿에 드라군, 하이 템플러까지! 전면전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 51-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 51,
      branches: [
        ScriptBranch(
          id: 'home_storm_zealot_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스톰! 밀집한 질럿과 드라군이 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -4, favorsStat: 'strategy',
              altText: '{home} 선수 스톰 명중! 상대 병력이 증발!',
            ),
            ScriptEvent(
              text: '{home}, 스피드 질럿이 남은 병력을 추격합니다!',
              owner: LogOwner.home,
              awayArmy: -5, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰과 질럿의 조합! 결정적인 전투!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_storm_zealot_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스톰! 밀집한 질럿과 드라군이 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스톰 명중! 상대 병력이 증발!',
            ),
            ScriptEvent(
              text: '{away}, 스피드 질럿이 남은 병력을 추격합니다!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스톰과 질럿의 조합! 결정적인 전투!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
