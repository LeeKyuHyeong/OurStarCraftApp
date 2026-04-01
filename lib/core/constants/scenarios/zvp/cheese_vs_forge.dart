part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 11. 4풀/5드론 vs 포지더블 (치즈 vs 표준)
// ----------------------------------------------------------
const _zvpCheeseVsForge = ScenarioScript(
  id: 'zvp_cheese_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool', 'zvp_5drone'],
  awayBuildIds: ['pvz_forge_cannon'],
  description: '저그 올인 러시 vs 포지더블 표준 방어',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 바로 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 바로 올라갑니다! 4풀 올인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 대량 생산! 6마리가 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
          altText: '{home}, 저글링이 쏟아집니다! 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 앞마당에 캐논을 건설합니다! 포지더블!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 게이트웨이와 캐논이 올라갑니다! 제때 완성될까요?',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 11-16)
    ScriptPhase(
      name: 'ling_rush',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 앞마당에 도착합니다! 건물이 미완성!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 저글링 돌진! 캐논이 아직 완성 전!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브로 막으면서 캐논 완성을 기다립니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 프로브 방어! 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '캐논 완성이 늦으면 그대로 무너집니다! 타이밍 싸움!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 초반 결과 - 분기 (lines 17-30)
    ScriptPhase(
      name: 'rush_result',
      startLine: 17,
      branches: [
        // 분기 A: 저글링 돌파 성공
        ScriptBranch(
          id: 'ling_rush_success',
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 캐논 완성 전에 진입! 프로브를 노립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 저글링이 난입합니다! 일꾼이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 프로브로 버텨보지만 프로브가 쓰러집니다!',
              owner: LogOwner.away,
              awayResource: -10, homeArmy: -1,
              altText: '{away}, 프로브가 녹고 있습니다! 캐논이 1초 늦었어요!',
            ),
            ScriptEvent(
              text: '{home}, 저글링이 넥서스까지 공격합니다! 앞마당 포기?',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 저글링이 포지더블을 흔들고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 캐논+프로브 방어 성공
        ScriptBranch(
          id: 'forge_defense_hold',
          baseProbability: 1.3,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 간신히 완성! 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayResource: -10, favorsStat: 'defense',
              altText: '{away}, 캐논 완성! 캐논이 저글링을 잡기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 캐논에 막힙니다! 추가 저글링을 보냅니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 게이트웨이에서 질럿까지 나옵니다! 완벽한 수비!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 질럿 합류! 질럿이 저글링을 전부 잡아냅니다!',
            ),
            ScriptEvent(
              text: '포지더블 수비 성공! 4풀 러시를 막아냈습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 - 분기 (lines 31-44)
    ScriptPhase(
      name: 'aftermath',
      startLine: 31,
      branches: [
        // 분기 A: 러시 실패 후 자원 격차
        ScriptBranch(
          id: 'economy_gap',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 드론이 4마리뿐입니다! 일꾼이 바닥!',
              owner: LogOwner.home,
              homeResource: -10,
              altText: '{home}, 4풀의 대가! 드론이 너무 적습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 넥서스에서 프로브를 계속 뽑습니다! 일꾼 격차!',
              owner: LogOwner.away,
              awayResource: 20,
              altText: '{away}, 프로브가 쌓입니다! 자원 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '{away}, 사이버네틱스 코어 완성 후 드라군을 생산하면서 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 5, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 실패! 자원 격차를 극복할 수 없습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 피해를 주고 후속 올인
        ScriptBranch(
          id: 'follow_up_allin',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링을 계속 보냅니다! 2차 러시!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'attack',
              altText: '{home}, 추가 저글링! 한 번 더 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논은 있지만 질럿이 아직 적습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 발업 연구 완료! 저글링이 더 빨라졌습니다!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'control',
              altText: '{home} 선수 발업 저글링! 캐논 사이를 파고듭니다!',
            ),
            ScriptEvent(
              text: '2차 저글링 러시! 포지더블이 버틸 수 있을까요?',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
