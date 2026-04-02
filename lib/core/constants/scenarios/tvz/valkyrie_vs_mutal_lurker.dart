part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 뮤탈 럴커 — 대공 vs 공중+지상 분산
// ----------------------------------------------------------
const _tvzValkyrieVsMutalLurker = ScenarioScript(
  id: 'tvz_valkyrie_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '발키리 대공 vs 뮤탈리스크 럴커 분산 운영',
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
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당부터 확장합니다! 매크로 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 발키리를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 팩토리가 올라갑니다! 스타포트 테크로!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 가스를 채취합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '양쪽 모두 중반 테크를 준비하고 있습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 테크 진행 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 붙입니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리고 스파이어 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어가 올라갑니다! 뮤탈이 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리 생산 시작! 대공 스플래시 준비!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 생산하면서 히드라덴도 올립니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '뮤탈과 럴커를 동시에 준비하고 있습니다! 이중 위협!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 양면 공격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 뮤탈이 테란 본진을 견제합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈 편대가 SCV를 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리가 뮤탈을 요격합니다! 스플래시!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -3,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커로 변태! 지상에서 압박을 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '공중은 막았지만 지상에서 럴커가 옵니다! 양면 작전!',
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
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 발키리로 뮤탈을 소탕하고 시즈탱크를 추가합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬로 럴커를 탐지! 시즈탱크 포격!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'sense',
              altText: '{home}, 디텍팅에 시즈 모드! 럴커가 터집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 공중도 지상도 막혔습니다! 병력이 소진됐어요!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '공중과 지상 모두 제압! 발키리+시즈 조합이 빛납니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈이 한쪽, 럴커가 반대쪽! 동시 공격!',
              owner: LogOwner.away,
              homeResource: -20,
              homeArmy: -2,
              favorsStat: 'harass',
              altText: '{away}, 양면 공격! 테란이 대응할 수 없습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 뮤탈을 쫓지만 럴커가 본진을 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 분산 운영이 완벽합니다! 테란이 무너집니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '뮤탈+럴커 양면 작전 성공! 대응이 불가능했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
