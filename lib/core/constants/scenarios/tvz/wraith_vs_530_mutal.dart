part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 견제 vs 530 뮤탈 — 공중 견제 vs 럴커 타이밍
// ----------------------------------------------------------
const _tvzWraithVs530Mutal = ScenarioScript(
  id: 'tvz_wraith_vs_530_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_trans_530_mutal', 'zvt_1hatch_allin'],
  description: '레이스 클로킹 견제 vs 1해처리 럴커 타이밍 공격',
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
          altText: '{away}, 앞마당 없이 바로 스포닝풀! 공격적이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 넣고 팩토리를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴을 빠르게 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 히드라덴이 올라갑니다! 럴커를 노리는 빌드!',
        ),
        ScriptEvent(
          text: '테란은 레이스, 저그는 럴커! 서로 다른 무기를 준비합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 양측 공격 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 레이스 생산!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크 생산! 럴커 업그레이드 연구!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          altText: '{away}, 히드라가 쏟아집니다! 럴커 변태 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커로 변태! 테란 앞마당을 향합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '레이스 클로킹 vs 럴커 타이밍! 서로 다른 축의 공격!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 교차 공격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스가 저그 후방으로! 드론을 노립니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 투명 레이스가 저그 일꾼을 급습!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 테란 앞마당에 버로우! 마린이 녹습니다!',
          owner: LogOwner.away,
          homeArmy: -3,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 벙커를 건설해서 럴커를 막으려 합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '서로 다른 방향에서 공격! 누가 더 큰 피해를 줄까요?',
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
              text: '{home} 선수 레이스가 드론을 다 잡았습니다! 1해처리라 치명적!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home} 선수 레이스가 저그 일꾼을 전멸시킵니다! 1해처리라 치명적!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 앞마당을 밀었지만 후속이 없습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크로 럴커를 정리! 역습 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '레이스 견제가 1해처리의 급소를 찔렀습니다! GG!',
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
              text: '{away} 선수 럴커가 테란 본진까지 뚫었습니다! 지상군이 전멸!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 럴커가 스파인으로 지상군을 녹입니다! 테란이 붕괴!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스 견제가 효과가 있었지만 본진이 위험!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 히드라와 럴커가 테란 시설을 파괴합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '럴커 타이밍이 본진을 뚫었습니다! 레이스로는 막을 수 없었어요! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
