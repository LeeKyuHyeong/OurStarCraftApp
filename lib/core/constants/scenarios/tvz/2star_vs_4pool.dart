part of '../../scenario_scripts.dart';

const _tvz2starVs4pool = ScenarioScript(
  id: 'tvz_2star_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_2star'],
  awayBuildIds: ['zvt_4pool'],
  description: '2스타포트 vs 4풀',
  phases: [
    // Phase 0: 테란 오프닝 + 4풀 러쉬
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 80,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설을 시작합니다.',
          owner: LogOwner.home,
          homeResource: -150,
          fixedCost: true,
          altText: '{home} 선수 배럭을 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설을 시작합니다! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -200,
          fixedCost: true,
          altText: '{away} 선수 즉시 스포닝풀! 4풀 올인!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6마리가 쏟아져 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          fixedCost: true,
          altText: '{away} 선수 저글링이 터져 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 생산하기 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          fixedCost: true,
          altText: '{home} 선수 마린이 나옵니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 상대 본진으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          fixedCost: true,
          altText: '{away} 선수 저글링 전부 돌진! 4풀 올인!',
        ),
        ScriptEvent(
          text: '4풀입니다! 저글링이 벌써 테란 본진에 도착했습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '4풀 러쉬! 마린 생산이 간당간당합니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 러쉬 결과
    ScriptPhase(
      name: 'rush_result',
      startLine: 8,
      recoveryResourcePerLine: 80,
      recoveryArmyPerLine: 1,
      branches: [
        ScriptBranch(
          id: 'terran_hold',
          baseProbability: 1.5,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 마린으로 저글링을 막아냅니다! SCV도 수리에 동원!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1,
              favorsStat: 'defense',
              altText: '{home} 선수 마린 화력! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커를 올려 방어선을 구축합니다!',
              owner: LogOwner.home,
              homeResource: -100,
              homeArmy: 2,
              fixedCost: true,
              altText: '{home} 선수 벙커 건설! 저글링을 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '4풀 수비 성공! 테란이 앞서 나갑니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '저글링을 막아냈습니다! 테란이 여유롭습니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 팩토리 건설을 시작합니다. 여유롭게 운영합니다.',
              owner: LogOwner.home,
              homeResource: -300,
              fixedCost: true,
              altText: '{home} 선수 팩토리를 올립니다, 안정적인 운영입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 병력을 모아 반격합니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -3,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 병력 반격! 저그가 할 수 있는 게 없습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_breaks',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 마린을 포위합니다! 서라운드!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 저글링으로 마린을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 SCV를 학살합니다!',
              owner: LogOwner.away,
              homeResource: -350,
              favorsStat: 'attack',
              altText: '{away} 선수 SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 저글링이 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              fixedCost: true,
              altText: '{away} 선수 저글링이 끊임없이 나옵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 본진을 유린합니다!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 본진 초토화! 4풀 올인 성공!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'close_fight',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 마린과 치열하게 교전합니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -3,
              favorsStat: 'control',
              altText: '{away} 선수 저글링이 마린에 돌진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV를 동원해 저글링에 맞섭니다!',
              owner: LogOwner.home,
              homeResource: -200, awayArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 SCV까지 합세! 필사의 방어!',
            ),
            ScriptEvent(
              text: '치열한 접전입니다!',
              owner: LogOwner.system,
              skipChance: 0.4,
              altText: '양측 피해가 극심합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 추가 생산! 저글링을 정리합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -3,
              favorsStat: 'macro',
              decisive: true,
              altText: '{home} 선수 마린 물량으로 저글링을 격파합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
