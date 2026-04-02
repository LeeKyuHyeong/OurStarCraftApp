part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 견제 vs 럴커 디파일러 — 공중 견제 vs 지상 방어
// ----------------------------------------------------------
const _tvzWraithVsLurkerDefiler = ScenarioScript(
  id: 'tvz_wraith_vs_lurker_defiler',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_trans_lurker_defiler', 'zvt_2hatch_lurker'],
  description: '레이스 클로킹 견제 vs 럴커 디파일러 지상 방어',
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
          altText: '{away}, 해처리부터 올리구요. 안정적인 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 건설합니다! 레이스를 노립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 히드라덴을 서둘러 올립니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라리스크 테크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 소량 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 서로 다른 축 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 레이스 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
          altText: '{home}, 스타포트에서 레이스! 클로킹 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라리스크 생산! 럴커 업그레이드 연구!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커로 변태! 테란 진영을 향합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          altText: '{away}, 럴커가 나왔습니다! 지상 압박 시작!',
        ),
        ScriptEvent(
          text: '공중과 지상! 완전히 다른 축에서 게임이 진행됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 평행 게임 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스가 드론과 오버로드를 사냥합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 투명 레이스가 저그 후방을 급습합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 테란 앞마당에서 버로우! 마린이 접근 불가!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 올리고 디파일러를 준비합니다! 다크스웜 연구!',
          owner: LogOwner.away,
          awayResource: -15,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '레이스는 하늘에서, 럴커는 땅에서! 누가 먼저 이길까요?',
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
              text: '{home} 선수 레이스가 드론을 전멸시킵니다! 자원이 끊겼어요!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'harass',
              altText: '{home}, 클로킹 레이스가 일꾼을 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니가 너무 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈탱크로 럴커를 처리하고 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '공중 견제가 저그의 자원을 말렸습니다! GG!',
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
              text: '{away} 선수 럴커와 디파일러가 합류! 다크스웜!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away} 선수 디파일러가 다크스웜을 뿌립니다! 테란 보병이 무력화!',
            ),
            ScriptEvent(
              text: '{home} 선수 지상이 뚫렸습니다! 레이스만으로는 부족!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 테란 본진까지 밀어넣습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '지상이 무너졌습니다! 레이스 견제로는 막을 수 없었어요! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
