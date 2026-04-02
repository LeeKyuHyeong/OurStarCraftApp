part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 울트라 하이브 — 치즈 vs 후반 빌드
// ----------------------------------------------------------
const _tvzBunkerVsUltraHive = ScenarioScript(
  id: 'tvz_bunker_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_ultra_hive'],
  description: '벙커 러시 vs 울트라 하이브 — 초반 올인 vs 최후반 빌드',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터에 배럭을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 배럭이 센터 쪽에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리부터 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 SCV가 저그 진영으로 출발합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다. 드론도 계속 뽑구요.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀과 함께 드론 생산을 이어갑니다.',
        ),
        ScriptEvent(
          text: '테란이 빠르게 움직이고 있습니다! 저그는 확장에 집중하네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벙커 공격 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 SCV가 저그 앞마당에 도착! 벙커 건설 시작!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 막으려 합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 저글링을 급히 뽑아서 벙커를 막습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV 수리로 벙커를 올립니다!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 드론까지 동원합니다! 필사적으로 막네요!',
          owner: LogOwner.away,
          awayResource: -10,
          homeArmy: -1,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '이 벙커가 완성되면 테란이 유리합니다! 저그에겐 일꾼 피해가 치명적!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 수비 정리 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 성큰을 건설합니다! 수비를 단단히 합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 마린을 보냅니다! 한 번 더 밀어야 합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 마린을 추가로 이동시킵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 울트라리스크를 목표로 하고 있습니다!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '지금 끝내지 못하면 울트라리스크가 나옵니다! 테란에겐 시간이 없어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 벙커에서 마린이 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰이 부족합니다! 앞마당이 무너지네요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당을 부수고 본진까지 밀고 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라 전에 끝냈습니다! 벙커 러시 성공! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 성큰과 저글링으로 벙커를 완벽히 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 자원이 쌓이고 있습니다! 드론 수 차이가 벌어지네요!',
              owner: LogOwner.away,
              awayResource: 30,
            ),
            ScriptEvent(
              text: '{away}, 테란 병력이 고갈됩니다! 올인이 실패했습니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              awayArmy: 3,
              favorsStat: 'macro',
              altText: '{away} 선수 드론이 가득합니다! 테란은 자원이 바닥이에요!',
            ),
            ScriptEvent(
              text: '벙커 러시 실패! 자원 차이가 압도적입니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
