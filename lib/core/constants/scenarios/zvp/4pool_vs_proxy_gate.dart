part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 프록시 게이트 (치즈 vs 치즈)
// ----------------------------------------------------------
const _zvp4poolVsProxyGate = ScenarioScript(
  id: 'zvp_4pool_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_8gat'],
  description: '4풀 저글링 vs 프록시 게이트 질럿 - 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 바로 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀 건설 시작! 극초반부터 공격적입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 보내 전진 파일런과 게이트웨이를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 전진 파일런과 게이트웨이! 앞에서 질럿을 뽑으려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리가 부화합니다! 즉시 출발!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 전진 게이트웨이에서 질럿이 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15,
          altText: '{away}, 전진 게이트웨이에서 질럿 완성! 저그 본진을 향합니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 올인입니다! 누가 먼저 도착하느냐가 관건이죠!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 본진에 도착! 프로브를 노립니다!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 저글링 진입! 일꾼을 공격합니다!',
        ),
        ScriptEvent(
          text: '{away}, 질럿이 저그 본진에 도착합니다! 드론을 공격!',
          owner: LogOwner.away,
          homeResource: -10, favorsStat: 'attack',
          altText: '{away} 선수 질럿이 드론을 잡기 시작합니다!',
        ),
        ScriptEvent(
          text: '베이스 레이스입니다! 서로의 일꾼을 파괴하고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 생산하면서 프로브를 계속 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayResource: -10,
          altText: '{home}, 저글링이 추가 투입됩니다! 일꾼이 녹고 있어요!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 드론을 하나씩 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: -10, awayArmy: 1,
        ),
      ],
    ),
    // Phase 2: 후반 정리 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 프로브를 거의 다 잡았습니다!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'harass',
          altText: '{home} 선수 저글링이 일꾼을 거의 전멸시켰습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 해처리를 공격합니다!',
          owner: LogOwner.away,
          homeResource: -15, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '양쪽 모두 일꾼이 거의 없습니다! 누가 먼저 건물을 부수느냐!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 라바에서 저글링을 계속 보충합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 보충! 수적 우위를 노립니다!',
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 넥서스를 파괴합니다! 프로토스 건물이 남지 않았습니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 넥서스 파괴! 전진 게이트웨이의 한계입니다!',
            ),
            ScriptEvent(
              text: '저글링이 남은 건물을 정리합니다! 극초반 러시의 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿이 해처리를 부수고 스포닝풀까지 공격합니다!',
              owner: LogOwner.away,
              homeArmy: -3, homeResource: -20, favorsStat: 'attack',
              altText: '{away} 선수 해처리 파괴! 저그 건물이 무너집니다!',
            ),
            ScriptEvent(
              text: '전진 질럿이 저그 본진을 완전히 파괴했습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
