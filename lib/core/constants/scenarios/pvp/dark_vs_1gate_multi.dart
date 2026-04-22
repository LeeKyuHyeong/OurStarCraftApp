part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 원게이트 멀티
// ----------------------------------------------------------
const _pvpDarkVs1gateMulti = ScenarioScript(
  id: 'pvp_dark_vs_1gate_multi',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '다크 올인 vs 원게이트 멀티',
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
          text: '{home} 선수 아둔 건설! 다크를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 아둔! 다크 올인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 하나 짓고 바로 넥서스를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 빠른 확장! 멀티를 먼저 가져갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 템플러 아카이브! 멀티 상대로 다크 올인!',
        ),
        ScriptEvent(
          text: '멀티 상대로 다크! 디텍이 없으면 양쪽 기지 모두 위험합니다!',
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
      name: 'dark_rush',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 멀티부터 노립니다!',
          owner: LogOwner.home,
          awayResource: 0,
          homeArmy: 3, awayArmy: 2, homeResource: -20,
          altText: '{home} 선수, 다크 출격! 확장 기지 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 프로브가 많습니다! 디텍이 있을까요?',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '멀티를 간 상황에서 다크가 들어갑니다! 디텍 준비가 핵심!',
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
        // 분기 A: 멀티에 디텍 없어 다크 성공
        ScriptBranch(
          id: 'dark_destroys_multi',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 다크가 앞마당 프로브를 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -30,              altText: '{home} 선수 다크 대성공! 앞마당 프로브가 학살됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논을 짓지만 다크가 너무 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수, 본진 프로브까지 노립니다! 다크 컨트롤!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -15,            ),
            ScriptEvent(
              text: '멀티의 일꾼이 전멸! 다크 올인이 확장을 무너뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 캐논으로 다크 차단
        ScriptBranch(
          id: 'cannon_defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 앞마당에 캐논이 있습니다! 다크를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 2,              altText: '{away} 선수, 캐논으로 다크를 포착! 수비 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 캐논에 잡힙니다! 올인 실패!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away} 선수, 프로브 피해 최소화! 멀티 자원이 살아있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 10,
            ),
            ScriptEvent(
              text: '{away} 선수 드라군을 모아 반격합니다! 멀티 자원의 힘!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 5, awayResource: -15,
            ),
            ScriptEvent(
              text: '다크 올인 실패! 멀티 자원 차이로 병력이 앞섭니다!',
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
