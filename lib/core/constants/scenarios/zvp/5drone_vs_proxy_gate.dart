part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 프록시 게이트 (치즈 vs 치즈)
// ----------------------------------------------------------
const _zvp5droneVsProxyGate = ScenarioScript(
  id: 'zvp_5drone_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_8gat'],
  description: '9투 올인 저글링 vs 프록시 게이트 질럿 - 올인 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 5마리까지 뽑고 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 스포닝풀 건설! 빠른 저글링을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 보내 전진 파일런을 세웁니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,
          altText: '{away}, 전진 파일런! 앞에서 게이트웨이를 올리려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 발업도 함께 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 전진 게이트웨이에서 질럿이 나옵니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -15,
          altText: '{away}, 전진 질럿 완성! 저그 본진을 향합니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 올인! 누가 더 많은 피해를 주느냐 싸움이죠!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 베이스 레이스 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 본진을 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home} 선수 발업 저글링 진입! 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 질럿이 저그 본진에 도착! 드론을 공격합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,          altText: '{away} 선수 질럿 진입! 드론이 잡히기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발업이 있어 프로브를 빠르게 잡습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10, homeArmy: 1,        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 드론을 하나씩 정리합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -10,
          altText: '{away}, 드론이 줄어듭니다! 질럿의 공격력이 높죠!',
        ),
        ScriptEvent(
          text: '베이스 레이스! 서로의 일꾼을 파괴하고 있습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 승부처 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 추가 저글링을 뽑아서 프로토스 건물을 공격합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: 2, awayResource: -10,          altText: '{home} 선수 저글링 보충! 건물을 부수기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 해처리를 공격합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,        ),
        ScriptEvent(
          text: '{home} 선수 발업 저글링의 속도로 프로브를 계속 추격합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home}, 저글링이 일꾼을 추격합니다! 발업이라 도망칠 수 없어요!',
        ),
        ScriptEvent(
          text: '양쪽 일꾼이 거의 남지 않았습니다! 건물 경쟁!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
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
              text: '{home}, 저글링이 넥서스를 파괴하고 게이트웨이까지 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -3, awayResource: -20,              altText: '{home} 선수 건물 파괴! 프로토스가 무너집니다!',
            ),
            ScriptEvent(
              text: '발업 저글링의 속도 차이! 저글링 러시 성공!',
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
              text: '{away}, 질럿이 해처리를 파괴하고 스포닝풀까지 부숩니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -3, homeResource: -20,              altText: '{away} 선수 해처리 파괴! 저그 건물이 남지 않았습니다!',
            ),
            ScriptEvent(
              text: '전진 질럿이 저그 본진을 완파! 질럿의 화력 승!',
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
