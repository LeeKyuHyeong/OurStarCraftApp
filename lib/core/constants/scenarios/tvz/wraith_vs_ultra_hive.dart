part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 견제 vs 울트라 하이브 — 클로킹 견제 vs 지상 최종병기
// ----------------------------------------------------------
const _tvzWraithVsUltraHive = ScenarioScript(
  id: 'tvz_wraith_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_3hatch_nopool'],
  description: '레이스 클로킹 견제로 울트라리스크 등장 전에 마무리',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당부터 올리구요. 매크로 빌드입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 건설합니다! 레이스를 향한 테크!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 드론에 집중합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 드론을 많이 뽑습니다! 후반을 노리는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 소량 생산하면서 앞마당을 정찰합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 레이스 vs 매크로 (lines 12-21)
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
          altText: '{home}, 스타포트에서 레이스! 클로킹 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 3번째 해처리를 확보합니다! 자원이 풍부해집니다!',
          owner: LogOwner.away,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리고 하이브를 향합니다! 울트라 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
          altText: '{away}, 하이브 테크를 밟고 있습니다! 울트라가 나올 겁니다!',
        ),
        ScriptEvent(
          text: '레이스가 울트라 전에 피해를 줄 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 클로킹 견제 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스가 저그 후방을 급습합니다!',
          owner: LogOwner.home,
          awayResource: -20,
          favorsStat: 'harass',
          altText: '{home}, 투명 레이스! 드론과 오버로드를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 울트라리스크가 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 테란 앞마당을 견제합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '시간과의 싸움! 울트라 전에 끝낼 수 있을까요?',
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
              text: '{home} 선수 레이스가 드론을 전멸시킵니다! 디텍팅이 없어요!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'harass',
              altText: '{home}, 클로킹 레이스가 일꾼을 쓸어버립니다! 치명적!',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라를 뽑을 자원이 없습니다! 하이브가 무의미!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 지상군으로 마무리 공격! 자원이 말라버렸어요!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '레이스 견제로 울트라를 볼 수 없게 만들었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 등장합니다! 스포어로 레이스도 잡고!',
              owner: LogOwner.away,
              awayArmy: 6,
              homeArmy: -2,
              favorsStat: 'macro',
              altText: '{away}, 울트라가 나왔습니다! 레이스 견제를 버텨냈어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스로는 울트라를 잡을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 울트라와 저글링이 테란 진영을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라가 나와버렸습니다! 레이스 견제로는 부족했어요! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
