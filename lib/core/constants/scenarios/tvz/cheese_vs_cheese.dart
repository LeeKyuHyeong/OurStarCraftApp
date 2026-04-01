part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. 치즈 vs 치즈: 벙커 vs 4풀 (극초반 승부)
// ----------------------------------------------------------
const _tvzCheeseVsCheese = ScenarioScript(
  id: 'tvz_cheese_vs_cheese',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_4pool'],
  description: '센터 8배럭 벙커 vs 4풀 극초반 승부',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀을 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 정말 빠르구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 일찍 보내고 있습니다.',
          owner: LogOwner.home,
          homeResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: 양쪽 올인 준비 (lines 12-16)
    ScriptPhase(
      name: 'dual_cheese_opening',
      startLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV가 일찍 센터로 이동합니다! 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, SCV가 벌써 센터로 나갔습니다! 빠른 배럭이구요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론 4기만에 스포닝풀 건설! 정말 빠릅니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 아주 일찍 올라갑니다! 공격적인 선택!',
        ),
        ScriptEvent(
          text: '양쪽 모두 초반 승부수를 띄웠습니다! 빠른 전개가 예상됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 서로 엇갈리는 공격 - 분기 (lines 17-26)
    ScriptPhase(
      name: 'cross_attack',
      startLine: 17,
      branches: [
        ScriptBranch(
          id: 'lings_hit_terran_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 6기 테란 본진에 도착합니다! 일꾼이 빠져있어요!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away} 선수 저글링이 텅 빈 본진에 도착! 일꾼이 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV를 끌고 나간 상태! 본진이 비어있습니다!',
              owner: LogOwner.home,
              homeResource: -20,
              altText: '{home}, 본진 SCV가 거의 없는 상황! 저글링이 마음껏 뜯습니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 남은 SCV를 잡아냅니다! 본진이 초토화!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -1, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '테란 본진이 큰 피해를 입고 있습니다! 하지만 저그 본진도 위험한데요!',
              owner: LogOwner.system,
            ),
          ],
        ),
        ScriptBranch(
          id: 'terran_hits_zerg_base',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 마린 SCV가 저그 앞마당에 도착! 벙커 건설 시작!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'control',
              altText: '{home}, 마린과 SCV가 저그 진영에 도착합니다! 벙커 올립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 4기뿐입니다! 저글링은 상대 본진으로 갔구요!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 저글링이 엇갈렸습니다! 본진에 병력이 없어요!',
            ),
            ScriptEvent(
              text: '{home}, 벙커 건설 중! 드론으로 막으려 하지만 역부족입니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '서로 본진을 공격하는 상황! 누가 더 빨리 피해를 줄 수 있을까요!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 치즈 대결 결말 (lines 27-35)
    ScriptPhase(
      name: 'cheese_resolution',
      startLine: 27,
      branches: [
        ScriptBranch(
          id: 'bunker_crushes_zerg',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -10, favorsStat: 'control',
              altText: '{home} 선수 벙커 완성시켰습니다! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론으로 막아보려 하지만 벙커 화력에 녹습니다!',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -15,
              altText: '{away}, 드론이 벙커 앞에서 쓰러집니다! 자원이 바닥!',
            ),
            ScriptEvent(
              text: '{home}, 추가 마린 도착! 저그 본진을 완전히 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 압박이 성공했습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'lings_destroy_terran',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 테란 본진 SCV를 전부 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'control',
              altText: '{away} 선수 저글링이 본진 일꾼을 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 돌아갈 자원이 없습니다! 본진이 괴멸했어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링까지 합류! 테란 앞마당도 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 저글링이 계속 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '본진이 무너졌습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

