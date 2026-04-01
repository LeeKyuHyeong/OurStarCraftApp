part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 3. 9풀/9오버풀 vs P 스탠다드 (초반 압박 vs 표준 전개)
// ----------------------------------------------------------
const _zvp9poolVsStandard = ScenarioScript(
  id: 'zvp_9pool_vs_standard',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_9pool', 'zvp_9overpool'],
  awayBuildIds: [
    'pvz_forge_cannon', 'pvz_corsair_reaver', 'pvz_2gate_zealot',
    'pvz_2star_corsair', 'pvz_trans_forge_expand', 'pvz_trans_corsair',
  ],
  description: '9풀 저글링 초반 압박 vs 프로토스 스탠다드',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 빠르게 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 빠릅니다! 공격적인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 건물을 올리기 시작합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업도 연구합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 저글링 나옵니다! 발업까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스와 게이트웨이 건설을 시작합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 넥서스와 게이트웨이가 올라갑니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 13-18)
    ScriptPhase(
      name: 'ling_arrival',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 프로토스 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 수비 준비가 됐을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 모아서 저글링을 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          altText: '{away}, 프로브 동원! 시간을 벌어야 합니다!',
        ),
      ],
    ),
    // Phase 2: 수비 여부 - 분기 (lines 19-32)
    ScriptPhase(
      name: 'defense_check',
      startLine: 19,
      branches: [
        // 분기 A: 저글링 돌파
        ScriptBranch(
          id: 'ling_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 수비 유닛 완성 전에 도착! 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -1, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 저글링 진입! 수비가 완성되기 전!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 저글링 속도를 따라갈 수 없습니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
              altText: '{away}, 프로브가 쓰러집니다! 속도를 못 따라가요!',
            ),
            ScriptEvent(
              text: '{home}, 본진까지 침투! 일꾼이 줄어들고 있습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '저글링이 프로토스 일꾼을 파괴하고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 프로토스 수비 성공
        ScriptBranch(
          id: 'protoss_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논과 질럿으로 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 수비 유닛이 제때 완성! 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 피해가 큽니다! 수비에 막히는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 추가 유닛까지 나오면서 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '수비 성공! 저그가 자원에서 뒤처집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 33-46) - 저글링 압박 이후 전개
    ScriptPhase(
      name: 'mid_transition',
      startLine: 33,
      branches: [
        // 분기 A: 저글링 피해를 주고 히드라 전환
        ScriptBranch(
          id: 'ling_damage_to_hydra',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라덴을 올리면서 중반을 준비합니다!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 히드라덴 건설! 히드라로 전환합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라가 합류합니다! 지상 전력 강화!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 사이버네틱스 코어 완성! 드라군과 하이 템플러를 준비합니다.',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
            ),
            ScriptEvent(
              text: '9풀의 초반 피해 위에 히드라까지! 저그가 주도권을 잡았습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 수비 후 프로토스 역공
        ScriptBranch(
          id: 'protoss_counterattack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드라군을 모아서 반격합니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away}, 드라군 편대! 저글링 공격을 막고 역공!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론이 부족합니다! 9풀의 대가!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home}, 드론이 너무 적습니다! 일꾼 차이가 납니다!',
            ),
            ScriptEvent(
              text: '{away}, 드라군이 저그 앞마당을 공격합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '9풀 실패! 프로토스가 역공합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
