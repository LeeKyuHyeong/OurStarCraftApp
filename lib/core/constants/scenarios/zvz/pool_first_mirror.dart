part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 미러 (극초반 올인 미러)
// ----------------------------------------------------------
const _zvzPoolFirstMirror = ScenarioScript(
  id: 'zvz_pool_first_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_pool_first'],
  awayBuildIds: ['zvz_pool_first'],
  description: '4풀 미러 극초반 저글링 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 극초반 스포닝풀입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 4드론에 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀! 양쪽 다 올인입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 바로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링 6기 생산! 서로를 향해 출발!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -15,
          altText: '{away}, 저글링이 쏟아집니다! 4풀 미러!',
        ),
        ScriptEvent(
          text: '4풀 미러! 극초반 저글링 싸움이 모든 걸 결정합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 맞교전 (lines 11-18)
    ScriptPhase(
      name: 'ling_clash',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 센터에서 마주칩니다! 수가 같습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
          altText: '{home} 선수 저글링 교전! 컨트롤이 전부입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링도 맞붙습니다! 드론 수가 적어서 이게 전부예요!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'control',
          altText: '{away}, 저글링 맞대결! 한 기 차이가 승패를 가릅니다!',
        ),
        ScriptEvent(
          text: '4풀 미러에서는 저글링 컨트롤이 곧 승패입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 저글링 교전 결과 - 분기 (lines 19-30)
    ScriptPhase(
      name: 'ling_result',
      startLine: 19,
      branches: [
        // 분기 A: 홈 저글링 컨트롤 승리
        ScriptBranch(
          id: 'home_ling_wins',
          baseProbability: 1.15,
          events: [
            ScriptEvent(
              text: '{home}, 저글링 컨트롤 차이! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 저글링 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 녹습니다! 드론으로 막아야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 남은 저글링으로 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 공격합니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이가 승부를 갈랐습니다! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 저글링 컨트롤 승리
        ScriptBranch(
          id: 'away_ling_wins',
          baseProbability: 0.85,
          events: [
            ScriptEvent(
              text: '{away}, 저글링 컨트롤 차이! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 저글링 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 녹습니다! 드론으로 막아야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 남은 저글링으로 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 드론을 공격합니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이가 승부를 갈랐습니다! 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
