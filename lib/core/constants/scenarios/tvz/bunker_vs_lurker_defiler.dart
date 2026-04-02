part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 럴커 디파일러 — 치즈 vs 수비형 매크로
// ----------------------------------------------------------
const _tvzBunkerVsLurkerDefiler = ScenarioScript(
  id: 'tvz_bunker_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '벙커 러시 vs 럴커 디파일러 — 초반 올인 vs 수비 매크로',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 센터에 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 해처리를 올립니다. 안정적인 빌드구요.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리부터 올립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 저그 쪽으로 보내고 있네요.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설! 드론 생산도 병행합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란이 빠르게 움직이고 있습니다! 벙커를 노리는 것 같네요!',
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
          text: '{home} 선수 저그 앞마당에 도착! 벙커를 올립니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'attack',
          altText: '{home}, 마린과 SCV가 도착했습니다! 벙커 건설 시작!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 뽑아서 벙커를 막습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV가 수리하면서 벙커를 지킵니다!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 건설합니다! 히드라리스크 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴이 올라갑니다! 럴커를 준비하는군요!',
        ),
        ScriptEvent(
          text: '벙커가 막히면 럴커가 나옵니다! 테란에겐 시간이 없어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 등장 위협 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 럴커 변태 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 추가로 보냅니다! 밀어야 합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 추가합니다! 앞마당 수비가 단단해지네요.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '럴커가 나오면 벙커 러시는 끝입니다! 시간 싸움이 치열하네요!',
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
              text: '{home} 선수 벙커가 완성됩니다! 마린 화력을 집중합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 벙커 완성! 마린이 저글링을 녹입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 무너집니다! 성큰도 부족해요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리를 때립니다! 저그가 견디지 못합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 러시 성공! 저그 테크업 전에 끝냈습니다! GG!',
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
              text: '{away} 선수 저글링과 성큰으로 벙커를 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커 변태 완료! 벙커 앞에 럴커가 자리 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              awayResource: -15,
              altText: '{away}, 럴커가 나왔습니다! 마린이 접근하지 못합니다!',
            ),
            ScriptEvent(
              text: '{away}, 럴커 스파인이 마린을 전멸시킵니다! 테란이 무너지네요!',
              owner: LogOwner.away,
              homeArmy: -4,
              homeResource: -20,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커에 테란이 무너집니다! 수비형 저그의 승리! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
