part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 럴커 디파일러 — 대공 투자 vs 지상 위협
// ----------------------------------------------------------
const _tvzValkyrieVsLurkerDefiler = ScenarioScript(
  id: 'tvz_valkyrie_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie', 'tvz_valkyrie'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '발키리 대공 투자 vs 럴커 디파일러 지상 압박',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올리는 안정적인 시작이구요.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올립니다! 스타포트를 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 히드라덴을 준비합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라리스크 테크를 서두르고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린으로 앞마당을 정찰합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크 생산 시작! 레어를 올립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
          altText: '{away}, 히드라리스크가 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커 업그레이드를 연구합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '발키리가 나왔지만 상대는 지상군입니다! 대공이 필요없는 상황!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 압박 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 럴커가 테란 앞마당으로 이동합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          favorsStat: 'attack',
          altText: '{away}, 럴커가 버로우! 테란 진영을 위협합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 베슬이 필요합니다! 급히 생산!',
          owner: LogOwner.home,
          homeResource: -15,
          homeArmy: 1,
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 완성! 디파일러 준비! 다크스웜을 연구합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '발키리가 럴커를 잡을 수 없습니다! 지상 전환이 시급합니다!',
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
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈탱크를 긴급 생산합니다! 럴커 대비!',
              owner: LogOwner.home,
              homeArmy: 4,
              homeResource: -20,
              favorsStat: 'sense',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬이 럴커 위치를 잡아냅니다! 시즈 모드!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 디텍팅으로 럴커를 발견! 시즈탱크가 포격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 터집니다! 디파일러 합류 전에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '빠른 전환 성공! 럴커를 잡아냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커가 테란 진영을 갈아버립니다! 디파일러 다크스웜!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 다크스웜 아래 럴커가 무적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 할 수 있는 게 없습니다! 지상이 뚫렸어요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 럴커와 저글링이 테란 본진까지 밀어넣습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '대공 투자가 독이 됐습니다! 지상이 무너졌어요! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
