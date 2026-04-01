part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 9풀/9오버풀 vs 비치즈 테란 (초반 압박)
// ----------------------------------------------------------
const _tvz9poolVsStandard = ScenarioScript(
  id: 'tvz_standard_vs_9pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk', 'tvz_4rax_enbe', 'tvz_111', 'tvz_3fac_goliath',
                 'tvz_valkyrie', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_9pool', 'zvt_9overpool'],
  description: '스탠다드 테란 vs 9풀/9오버풀 초반 압박',
  phases: [
    // Phase 0: 오프닝 (lines 1-13)
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
          text: '{away} 선수 스포닝풀을 일찍 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 빠릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산 시작! 빠르게 뽑고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -5,
          altText: '{away}, 저글링이 벌써 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린이 나오고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테란 오프닝 vs 빠른 저글링 (lines 14-20)
    ScriptPhase(
      name: 'early_pressure',
      startLine: 14,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 일찍 올라갑니다! 빠른 저글링 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 빠릅니다! 저글링을 일찍 뽑으려는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설 중인데... 저글링이 오고 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 발업 저글링 6기 출발! 상대 진영으로 달려갑니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15, favorsStat: 'attack',
          altText: '{away} 선수 발업 완료된 저글링이 달려나갑니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 도착 - 분기 (lines 21-32)
    ScriptPhase(
      name: 'ling_rush_response',
      startLine: 21,
      branches: [
        ScriptBranch(
          id: 'terran_scouted',
          baseProbability: 1.0,
          conditionStat: 'scout',
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV 정찰로 9풀을 확인했습니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 정찰 성공! 빠른 풀을 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 벙커 건설! 저글링에 대비합니다!',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 도착하지만 벙커가 이미 있습니다!',
              owner: LogOwner.away,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{away}, 저글링 도착! 하지만 벙커에 막힙니다!',
            ),
            ScriptEvent(
              text: '정찰이 빛났습니다! 테란이 완벽하게 대비했네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'ling_rush_success',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away}, 발업 저글링이 진영 입구에 도착! 마린이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
              altText: '{away} 선수 저글링 기습! 테란이 대비를 못 했어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 1기뿐입니다! 저글링 물량을 막을 수 없어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, SCV까지 물어뜯습니다! 일꾼 피해가 크겠는데요!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 저글링이 일꾼을 초토화!',
            ),
            ScriptEvent(
              text: '9풀 저글링 러시가 효과적입니다! 테란이 흔들리는데요!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 33-46)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 33,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 추가 생산! 수비를 안정시킵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 마린 물량이 쌓이기 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 추가 생산하면서 앞마당을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 압박을 유지하면서 앞마당 건설!',
        ),
        ScriptEvent(
          text: '{home}, 벙커 건설! 저글링 진입로를 차단합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 테크 올립니다! 스파이어 건설 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 가스 넣고 레어 진화 시작! 스파이어 준비!',
        ),
        ScriptEvent(
          text: '초반 러시가 마무리되고 중반으로 넘어갑니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 후반 전개 - 분기 (lines 47-62)
    ScriptPhase(
      name: 'late_development',
      startLine: 47,
      branches: [
        ScriptBranch(
          id: 'terran_recovers',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 일꾼 복구 완료! 병력 생산이 정상화됩니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 15, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕 조합으로 전진! 앞마당을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 3, favorsStat: 'attack',
              altText: '{home} 선수 바이오닉 출진! 저그 앞마당을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 9풀 이후 자원이 부족합니다! 테크가 느려요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '초반 올인 이후 자원 차이가 결정적입니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_leverages_lead',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 등장! 초반 이득을 살립니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'strategy',
              altText: '{away}, 뮤탈이 떴습니다! 초반 피해를 발판으로!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 견제하면서 세 번째 해처리까지!',
              owner: LogOwner.away,
              awayResource: 20, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 초반 피해 복구가 안 되고 있습니다! 뮤탈까지!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 초반 저글링 피해에 뮤탈 견제까지! 이중고!',
            ),
            ScriptEvent(
              text: '초반 러시의 효과가 중반까지 이어집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

