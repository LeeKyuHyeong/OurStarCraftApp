part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 원게이트 멀티 vs 쓰리게이트 스피드질럿
// ----------------------------------------------------------
const _pvp1gateMultiVs3gateSpeedzealot = ScenarioScript(
  id: 'pvp_1gate_multi_vs_3gate_speedzealot',
  matchup: 'PvP',
  homeBuildIds: ['pvp_1gate_multi'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '원게이트 멀티 vs 쓰리게이트 스피드질럿',
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
          text: '{home} 선수 게이트웨이 하나만 짓고 바로 넥서스를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home}, 빠른 확장! 자원을 먼저 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔 건설! 각속 업그레이드를 노립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 아둔! 스피드질럿을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 게이트웨이를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away}, 게이트웨이가 벌써 세 개! 질럿 물량이 나오겠네요!',
        ),
        ScriptEvent(
          text: '운영형 멀티 vs 공격형 스피드질럿! 앞마당이 위험합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 스피드질럿 돌진 (lines 15-20)
    ScriptPhase(
      name: 'speedzealot_attack',
      linearEvents: [
        ScriptEvent(
          text: '{away}, 각속 업그레이드 완료! 스피드질럿이 앞마당으로!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 5, homeArmy: 2,          altText: '{away} 선수 스피드질럿 돌진! 멀티를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿과 프로브로 앞마당을 지킵니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,
        ),
        ScriptEvent(
          text: '멀티를 간 상태에서 스피드질럿! 앞마당을 지킬 수 있을까?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'attack_result',
      branches: [
        // 분기 A: 앞마당 파괴
        ScriptBranch(
          id: 'multi_destroyed',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 스피드질럿이 앞마당 넥서스를 공격합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,              altText: '{away} 선수 넥서스를 직접 공격! 확장이 위험!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브를 동원하지만 스피드질럿이 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 추가 질럿 합류! 프로브까지 잡습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              awayArmy: 2, homeResource: -15,            ),
            ScriptEvent(
              text: '스피드질럿이 멀티를 파괴합니다! 자원 투자가 물거품!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 수비 성공 후 역전
        ScriptBranch(
          id: 'multi_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 질럿과 프로브 협공으로 스피드질럿을 잡습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4, homeArmy: -1,              altText: '{home} 선수 수비 성공! 스피드질럿을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 녹고 있습니다! 돌파 실패!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 사이버네틱스 코어 건설! 드라군으로 전환합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 멀티 자원으로 드라군을 빠르게 모읍니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 5, homeResource: -15,
            ),
            ScriptEvent(
              text: '멀티가 살아남았습니다! 자원 차이가 병력으로 이어집니다!',
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
