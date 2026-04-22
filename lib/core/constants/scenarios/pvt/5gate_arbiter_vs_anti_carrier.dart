part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 아비터 vs 안티 캐리어 (골리앗 대공)
// ----------------------------------------------------------
const _pvt5gateArbiterVsAntiCarrier = ScenarioScript(
  id: 'pvt_5gate_arbiter_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_arbiter', 'pvt_1gate_expand', 'pvt_1gate_obs'],
  awayBuildIds: ['tvp_trans_anti_carrier', 'tvp_anti_carrier'],
  description: '5게이트 아비터 vs 골리앗 대공 — 스테이시스+리콜 vs 골리앗 편대',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 배럭에서 팩토리! 아머리도 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 팩토리에 아머리까지! 골리앗을 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 넥서스를 올립니다! 확장을 가져가고요.',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산 시작! 대공에 특화된 편성입니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수, 골리앗이 나옵니다! 공중 유닛을 잡겠다는 의지!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가하면서 드라군을 뽑습니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 골리앗 중심 빌드를 가져갑니다. 공중 유닛에 대비하는 모습.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 골리앗을 대량 생산합니다! 사거리 업그레이드도 연구 중!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -20,          altText: '{away} 선수, 골리앗 물량! 사거리 업그레이드까지 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 템플러 아카이브로 스톰을 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 아둔에서 템플러 아카이브! 하이 템플러가 필요하죠.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트에 아비터 트리뷰널 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 탱크와 골리앗 혼합 편성으로 전진합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 3,          altText: '{away} 선수, 탱크 골리앗 편대가 이동합니다!',
        ),
        ScriptEvent(
          text: '골리앗 대공 편성에 아비터가 살아남을 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 5개 가동! 드라군 질럿 물량을 확보합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아비터 생산! 스테이시스 필드를 준비합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수, 아비터 등장! 스테이시스로 골리앗을 묶어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 사거리 업그레이드 완료! 아비터가 접근하기 힘들어졌습니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수, 골리앗 사거리가 길어졌습니다! 공중 유닛 접근 불가!',
        ),
        ScriptEvent(
          text: '{home} 선수 하이 템플러도 합류! 스톰과 리콜 이중 전술!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -15,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 아비터 스테이시스! 골리앗 편대 절반이 얼어붙습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,              altText: '{home} 선수, 스테이시스 필드! 아비터가 스테이시스! 상대 병력을 멈춥니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 얼어붙지 않은 병력에 스톰! 그리고 드라군 돌격!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -6, homeArmy: -2,              altText: '{home} 선수 스톰에 드라군 총공격! 남은 병력을 정리합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 리콜로 테란 본진까지 급습! 일꾼을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -25,            ),
            ScriptEvent(
              text: '스테이시스로 병력을 분리하고 각개 격파! 아비터의 진가!',
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
              text: '{away} 선수 골리앗이 아비터를 집중 포화! 사거리가 깁니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,              altText: '{away} 선수, 골리앗 대공! 아비터가 접근도 못합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 아비터 격추! 리콜도 스테이시스도 쓰지 못합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: 1,
              altText: '{away} 선수 아비터를 잡았습니다! 핵심 유닛 손실!',
            ),
            ScriptEvent(
              text: '{away} 선수, 탱크 골리앗 총공격! 프로토스 전선을 밀어냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -6, awayArmy: -2,            ),
            ScriptEvent(
              text: '골리앗 대공이 아비터를 완봉! 안티 캐리어 전술의 승리!',
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
