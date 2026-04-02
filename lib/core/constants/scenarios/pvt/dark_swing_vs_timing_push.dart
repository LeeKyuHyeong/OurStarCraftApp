part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs 타이밍 푸시 - DT 견제로 푸시 지연
// ----------------------------------------------------------
const _pvtDarkSwingVsTimingPush = ScenarioScript(
  id: 'pvt_dark_swing_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_trans_timing_push'],
  description: '다크 스윙 vs 타이밍 푸시 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설 후 팩토리를 올립니다! 공격적인 빌드!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 빠른 팩토리! 타이밍 공격을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어에 이어 아둔을 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔 건설! 다크를 노리고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구! 탱크를 모읍니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '타이밍 푸시 vs 다크 스윙! 먼저 결정타를 날리는 쪽이 유리!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양측 준비 (lines 12-19)
    ScriptPhase(
      name: 'preparation',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크를 뽑습니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 템플러 아카이브! 다크가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 탱크를 모으면서 전진 준비합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 상대를 견제하러 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 2기 출발! 타이밍 푸시를 지연시켜야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미를 올립니다! 컴샛을 준비해요!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '다크가 먼저 도착할까, 타이밍 푸시가 먼저일까!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 다크 잠입 + 푸시 대치 (lines 22-28)
    ScriptPhase(
      name: 'dt_vs_push',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크가 테란 본진에 접근합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 다크가 잠입! 타이밍 푸시를 방해합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 3기, 마린 8기로 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home}, 드라군도 모으면서 방어 라인을 구축합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '다크의 견제 효과가 타이밍 푸시를 얼마나 늦출 수 있을까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 다크 견제 성공 → 타이밍 지연 → 프로토스 승리
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'harass',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크가 SCV를 베어냅니다! 디텍이 늦었어요!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 다크 성공! SCV가 잡혀나갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 타이밍 푸시를 포기하고 본진으로 돌아갑니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home}, 다크가 일꾼을 정리하면서 드라군으로 탱크를 노립니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -5,
              favorsStat: 'strategy',
              altText: '{home} 선수 다크 견제 + 드라군 합류! 테란이 양면 공격!',
            ),
            ScriptEvent(
              text: '타이밍 푸시가 좌절됐습니다! 프로토스가 주도권을 잡았어요!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군 편대로 밀어냅니다! 테란이 GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 견제가 완벽! 타이밍 푸시를 무력화!',
            ),
          ],
        ),
        // 분기 B: 디텍 성공 → 타이밍 푸시 관철
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 컴샛! 다크를 포착합니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 스캔으로 다크를 찾아냅니다! 마린이 잡아요!',
            ),
            ScriptEvent(
              text: '{away}, 마린이 다크를 처리하고 바로 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 프로토스 앞에 배치! 시즈 모드!',
              owner: LogOwner.away,
              awayArmy: 5,
              favorsStat: 'attack',
              altText: '{away}, 탱크 시즈! 드라군이 접근할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크 화력에 녹아내립니다!',
              owner: LogOwner.home,
              homeArmy: -8,
            ),
            ScriptEvent(
              text: '타이밍 푸시 성공! 다크가 막힌 프로토스에 대안이 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크 푸시! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 타이밍 공격 완수! 프로토스를 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
