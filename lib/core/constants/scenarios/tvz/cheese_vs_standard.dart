part of '../../scenario_scripts.dart';

// 3. 치즈 vs 스탠다드 (초반 승부)
// ----------------------------------------------------------
const _tvzCheeseVsStandard = ScenarioScript(
  id: 'tvz_cheese_vs_standard',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_12pool', 'zvt_12hatch'],
  description: '센터 8배럭 벙커 vs 스탠다드 저그',
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
          text: '{away} 선수 해처리에서 드론을 뽑고 있습니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 생산!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.3,
          altText: '{away}, 앞마당 확장! 해처리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 15-21)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터 배럭에서 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          altText: '{home}, 센터 배럭 마린 2기! 본진에서도 마린이 나오고 있구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 끌고 상대 진영으로 이동합니다!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'attack',
          altText: '{home}, SCV 4기가 마린과 함께 출발합니다! 공격적인데요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산에 집중하는 중인데... 발견할 수 있을까요?',
          owner: LogOwner.away,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 정찰 SCV가 상대 앞마당에 도착! 벙커 자리를 잡습니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 앞마당에 벙커 건설 시작합니다!',
        ),
      ],
    ),
    // Phase 2: 발견 여부 분기 (lines 22-30)
    ScriptPhase(
      name: 'detection',
      startLine: 22,
      branches: [
        ScriptBranch(
          id: 'zerg_detects_bunker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 오버로드가 SCV를 포착했습니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
            ),
            ScriptEvent(
              text: '{away}, 드론 모아서 SCV를 쫓아냅니다! 벙커 건설 방해!',
              owner: LogOwner.away,
              homeArmy: -1,
              altText: '{away} 선수 드론으로 SCV 견제! 벙커를 못 짓게 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 올라가지 않습니다! 플랜이 흔들리는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 성큰 완성! 완벽한 대응입니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
              altText: '{away} 선수 성큰 올리면서 마린을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 벙커 전략을 간파합니다! 완벽한 대응!',
              owner: LogOwner.away,
            ),
            ScriptEvent(
              text: '벙커 러시가 실패했습니다! GG!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -20,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bunker_complete',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 건설 성공! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15, favorsStat: 'control',
              altText: '{home}, 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 발견! 저글링으로 대응하려 하는데요!',
              owner: LogOwner.away,
              awayArmy: 3,
            ),
            ScriptEvent(
              text: '{home}, SCV 수리! 벙커가 버티고 있습니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home} 선수 SCV 수리 컨트롤! 벙커를 살립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 벙커를 뚫지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -4, homeArmy: -1,
              altText: '{away}, 저글링 피해만 커지고 있습니다!',
            ),
            ScriptEvent(
              text: '{home}, 추가 마린 도착! 벙커 압박 강화!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 압박이 거세집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

