part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 3. 9풀 vs 포지더블 (초반 압박)
// ----------------------------------------------------------
const _zvp9poolVsForge = ScenarioScript(
  id: 'zvp_9pool_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_9pool', 'zvp_9overpool'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_trans_forge_expand'],
  description: '9풀 저글링 vs 포지더블 초반 압박',
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
          text: '{away} 선수 포지 건설합니다.',
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
          text: '{away} 선수 게이트웨이와 앞마당 넥서스 건설 시작합니다.',
          owner: LogOwner.away,
          awayResource: -30,
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
          text: '{away} 선수 캐논이 완성됐을까요? 아직 건설 중인데!',
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
        // 분기 A: 저글링 돌파 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'ling_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 캐논 완성 전에 도착! 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -1, homeArmy: -1, favorsStat: 'attack',
              altText: '{home} 선수 저글링 진입! 캐논이 아직 미완성!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 막으려 하지만 프로브가 속도를 못 따라갑니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
              altText: '{away}, 프로브가 쓰러집니다! 속도를 따라갈 수가 없어요!',
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
        // 분기 B: 캐논 수비 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'cannon_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논 완성! 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 캐논이 제때 완성! 캐논이 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 피해가 큽니다! 캐논에 막히는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 질럿까지 나오면서 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '캐논 수비 성공! 저그가 자원이 뒤처집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

