part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 530 뮤탈 — 대공 투자 vs 럴커 타이밍
// ----------------------------------------------------------
const _tvzValkyrieVs530Mutal = ScenarioScript(
  id: 'tvz_valkyrie_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_trans_530_mutal'],
  description: '발키리 대공 vs 1해처리 럴커 타이밍 공격',
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
          text: '{away} 선수 스포닝풀 건설! 1해처리 공격 빌드!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당 없이 스포닝풀! 공격적인 선택입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올립니다! 스타포트를 향합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 생산하면서 테크를 진행합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 럴커 타이밍 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 히드라리스크 생산! 럴커 업그레이드 연구!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          altText: '{away}, 히드라가 빠르게 나옵니다! 럴커 전환 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트를 올립니다! 하지만 시간이 촉박합니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 럴커로 변태! 테란 앞마당을 향합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          altText: '{away}, 럴커가 나왔습니다! 바로 공격 갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린으로 방어를 준비합니다! 시즈탱크가 없어요!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '럴커 타이밍이 들어옵니다! 발키리로는 럴커를 잡을 수 없습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 방어 시도 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 럴커가 버로우! 마린이 다가갈 수 없습니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 사이언스 퍼실리티를 급히 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이언스 베슬이 필요합니다! 급하게 테크!',
        ),
        ScriptEvent(
          text: '{home} 선수 벙커를 건설해서 방어선을 구축합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          homeArmy: 1,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '대공 투자가 지상 방어를 약하게 만들었습니다!',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커와 마린으로 럴커를 막아냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'defense',
              altText: '{home}, 벙커 라인에서 럴커를 저지합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬 합류! 럴커 위치를 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 타이밍을 놓쳤습니다! 1해처리라 후속이 없어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '럴커 타이밍 실패! 테란이 버텨냈습니다! GG!',
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
              text: '{away} 선수 럴커가 마린을 갈아버립니다! 스파인이 너무 강해요!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 럴커 스파인에 마린이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 하늘에서 지켜볼 수밖에 없습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라와 럴커가 테란 본진까지 밀어넣습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍 성공! 대공 투자가 화를 불렀습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
