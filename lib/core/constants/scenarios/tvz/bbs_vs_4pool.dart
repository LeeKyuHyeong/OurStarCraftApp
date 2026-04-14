part of '../../scenario_scripts.dart';

const _tvzBbsVs4pool = ScenarioScript(
  id: 'tvz_bbs_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bbs'],
  awayBuildIds: ['zvt_4pool'],
  description: 'BBS vs 4풀',
  phases: [
    // Phase 0: 양측 올인 오프닝
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 50,
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
          text: '{away} 선수 스포닝풀 건설을 시작합니다! 4드론입니다!',
          owner: LogOwner.away,
          awayResource: -200,
          fixedCost: true,
          altText: '{away} 선수 즉시 스포닝풀! 저글링을 계속 모으고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 배럭을 올립니다! 배럭을 두 개 올립니다!',
          owner: LogOwner.home,
          homeResource: -150,
          homeArmy: 2,
          fixedCost: true,
          altText: '{home} 선수 배럭 두 개에서 마린이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6마리가 쏟아져 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 6,
          fixedCost: true,
          altText: '{away} 선수 저글링이 터져 나옵니다!',
        ),
        ScriptEvent(
          text: '양쪽 다 공격적입니다! 어느 쪽이 먼저 무너질까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '양쪽 다 올인입니다! 살벌한 초반 대결입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 모아 방어 준비를 합니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          fixedCost: true,
          altText: '{home} 선수 마린 생산에 집중합니다.',
        ),
      ],
    ),
    // Phase 1: 올인 충돌
    ScriptPhase(
      name: 'allin_clash',
      startLine: 8,
      recoveryResourcePerLine: 30,
      recoveryArmyPerLine: 1,
      branches: [
        ScriptBranch(
          id: 'terran_hold',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 마린이 저글링을 막아냅니다! SCV를 수리로 돌립니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 마린 화력으로 저글링을 제압합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커를 올려 방어선을 구축합니다!',
              owner: LogOwner.home,
              homeResource: -100,
              homeArmy: 2,
              fixedCost: true,
              altText: '{home} 선수 급하게 벙커를 건설합니다!',
            ),
            ScriptEvent(
              text: '저글링이 마린 화력에 맞서지 못합니다!',
              owner: LogOwner.system,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '마린의 집중 화력! 저글링이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 물량이 쌓입니다! 저글링을 격파합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 마린이 저글링을 전멸시킵니다! 테란 승리!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_breaks',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 마린 사이를 파고듭니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 저글링 서라운드! 마린을 포위합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 SCV를 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'attack',
              altText: '{away} 선수 SCV를 학살합니다!',
            ),
            ScriptEvent(
              text: '마린 생산이 저글링 물량을 따라가지 못합니다!',
              owner: LogOwner.system,
              homeArmy: -3,
              altText: '마린이 부족합니다! 저글링을 막을 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 본진을 유린합니다! 테란이 무너집니다!',
              owner: LogOwner.away,
              homeResource: -400,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 저글링 돌파! 테란 본진이 초토화됩니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'mutual_damage',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 마린과 접전을 벌입니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -3,
              favorsStat: 'control',
              altText: '{away} 선수 저글링이 마린에 돌진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV를 끌어 저글링에 맞섭니다!',
              owner: LogOwner.home,
              homeResource: -150, awayArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 SCV까지 동원해 방어합니다!',
            ),
            ScriptEvent(
              text: '양측 피해가 극심합니다! 누가 먼저 회복하느냐가 관건!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 마린을 추가 생산하며 반격합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -2,
              favorsStat: 'macro',
              altText: '{home} 선수 마린 물량으로 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링을 정리하고 역공을 갑니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 저글링을 전멸시키고 반격!',
            ),
          ],
        ),
      ],
    ),
  ],
);
