part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 10. 원해처리 올인 vs 스탠다드 테란 (초중반 승부)
// ----------------------------------------------------------
const _tvzStandardVs1HatchAllin = ScenarioScript(
  id: 'tvz_standard_vs_1hatch_allin',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_sk', 'tvz_4rax_enbe'],
  awayBuildIds: ['zvt_1hatch_allin', 'zvt_trans_530_mutal'],
  description: '스탠다드 테란 vs 원해처리 럴커 올인',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
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
          text: '{away} 선수 해처리 하나로 시작합니다. 앞마당을 안 올리네요!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 원해처리 운영! 확장 없이 가는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀에 이어 가스를 일찍 넣습니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스를 빠르게 올립니다! 테크 빌드인데요!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 추가합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 진화 시작합니다! 원해처리에서 바로 테크!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어가 올라갑니다! 빠른 테크!',
        ),
      ],
    ),
    // Phase 1: 럴커 올인 준비 (lines 15-24)
    ScriptPhase(
      name: 'lurker_allin_prep',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설! 럴커를 노리는 건가요?',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 히드라덴이 올라갑니다! 럴커 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설하면서 스팀팩 연구합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아카데미에 스팀팩! 바이오닉 완성 단계!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라 생산! 바로 럴커 변태 들어갑니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20, favorsStat: 'strategy',
          altText: '{away}, 히드라가 나오자마자 럴커로 변태합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 조합이 갖춰지고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '저그가 원해처리에서 럴커를 뽑았습니다! 올인 타이밍입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 럴커 올인 돌입 - 분기 (lines 25-38)
    ScriptPhase(
      name: 'lurker_allin',
      startLine: 25,
      branches: [
        // 분기 A: 럴커 올인 성공
        ScriptBranch(
          id: 'lurker_allin_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 4기가 테란 앞마당으로 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 3, favorsStat: 'attack',
              altText: '{away}, 럴커 전진! 올인입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스캔이 없습니다! 럴커 위치를 모르는 상황!',
              owner: LogOwner.home,
              homeArmy: -3,
              altText: '{home}, 디텍터가 부족합니다! 럴커에 마린 녹아요!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 입구에 자리잡습니다! 상대 보병을 녹여냅니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'strategy',
              altText: '{away} 선수 럴커 포진! 테란 입구가 완전히 막혔습니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링까지 합류! 럴커 뒤에서 달려나옵니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '올인이 성공하고 있습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
              skipChance: 0.15,
            ),
          ],
        ),
        // 분기 B: 테란이 럴커를 읽고 대비
        ScriptBranch(
          id: 'terran_reads_lurker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 SCV 정찰로 원해처리 럴커를 확인했습니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home}, 정찰 성공! 럴커 올인을 읽었습니다!',
            ),
            ScriptEvent(
              text: '{home}, 팩토리에 머신샵 부착! 시즈 탱크로 럴커를 잡겠다는 판단!',
              owner: LogOwner.home,
              homeResource: -20, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 전진하지만 시즈 모드 포격에 당합니다!',
              owner: LogOwner.away,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{away}, 럴커가 탱크 사거리에 들어갑니다! 스캔!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 포격! 럴커를 하나씩 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: 2, favorsStat: 'attack',
              altText: '{home} 선수 시즈 탱크로 럴커 정밀 포격!',
            ),
            ScriptEvent(
              text: '올인이 막혔습니다!',
              owner: LogOwner.system,
              skipChance: 0.15,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 올인 이후 (lines 39-50)
    ScriptPhase(
      name: 'post_allin',
      startLine: 39,
      branches: [
        // 분기 A: 올인 실패 후 자원 차이
        ScriptBranch(
          id: 'allin_failed_resource_gap',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 올인이 실패했습니다! 원해처리라 자원이 없어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 확장하면서 병력을 모읍니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: 15, favorsStat: 'macro',
              altText: '{home}, 자원 차이를 벌립니다! 테란이 유리해요!',
            ),
            ScriptEvent(
              text: '{away}, 급히 앞마당을 올리지만 이미 자원 차이가 크네요.',
              owner: LogOwner.away,
              awayResource: -30,
            ),
            ScriptEvent(
              text: '{home}, 팩토리에서 시즈 탱크 생산! 마린 메딕과 합류해 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 총공격! 올인 실패한 저그를 밀어붙입니다!',
            ),
            ScriptEvent(
              text: '올인 실패 후 자원 차이가 결정적입니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 올인 성공 후 마무리
        ScriptBranch(
          id: 'allin_success_finish',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 올인 성공! 테란 앞마당이 무너졌습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 본진으로 후퇴! 수비를 재건하려 합니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 앞마당을 포기하고 본진 수비!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 본진 입구에도 자리잡습니다! 탈출구가 없는데요!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away}, 스파이어에서 뮤탈까지 추가! 530 전환으로 마무리합니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20, homeArmy: -5, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 스파이어 완성! 럴커에 뮤탈까지!',
            ),
            ScriptEvent(
              text: '원해처리 올인 성공! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

