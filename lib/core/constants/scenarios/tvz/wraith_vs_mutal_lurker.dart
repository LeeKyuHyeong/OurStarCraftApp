part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 vs 뮤탈 럴커 — 클로킹 vs 공중+지상 이중 위협
// ----------------------------------------------------------
const _tvzWraithVsMutalLurker = ScenarioScript(
  id: 'tvz_wraith_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '레이스 클로킹 견제 vs 뮤탈리스크 럴커 이중 위협',
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
          altText: '{away}, 앞마당부터 확장! 뮤탈+럴커를 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 스타포트 레이스를 향합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 팩토리가 올라갑니다! 레이스 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란은 레이스를 준비합니다. 저그는 어떤 조합으로 나올까요?',
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
          text: '{home} 선수 스타포트 건설! 레이스 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리고 스파이어 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어가 올라갑니다! 뮤탈이 나올 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구! 투명 레이스를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈과 히드라를 동시에 생산합니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '뮤탈+럴커 조합! 공중과 지상 양면 위협입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공중 교전 + 럴커 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스로 오버로드를 잡습니다!',
          owner: LogOwner.home,
          awayResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈이 레이스와 공중 교전! 스포어로 지원!',
          owner: LogOwner.away,
          homeArmy: -1,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{away}, 뮤탈과 스포어가 레이스를 요격합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커로 변태! 지상 공격도 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '레이스와 뮤탈이 하늘에서 싸우는 동안 럴커가 지상을 노립니다!',
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
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스가 뮤탈을 피해 드론을 잡습니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 레이스가 저그 후방 일꾼을 초토화합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크로 럴커를 정리합니다! 사이언스 베슬 디텍팅!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 자원이 고갈됐습니다! 병력 보충이 안 돼요!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '레이스 견제가 자원을 말리고 지상도 정리! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈이 레이스를 격추합니다! 스포어 콜로니 지원!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'control',
              altText: '{away}, 뮤탈+스포어 콜로니가 레이스를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 테란 앞마당을 뚫습니다! 지상 붕괴!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 공중도 지상도 밀립니다! 대응할 수 없어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '뮤탈+럴커 이중 위협! 레이스만으로는 감당 불가! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
