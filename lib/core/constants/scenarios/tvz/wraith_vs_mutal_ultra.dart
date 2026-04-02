part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 공중 vs 뮤탈 울트라 — 클로킹 견제 vs 공중과 지상 전환
// ----------------------------------------------------------
const _tvzWraithVsMutalUltra = ScenarioScript(
  id: 'tvz_wraith_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith', 'tvz_2star_wraith'],
  awayBuildIds: ['zvt_trans_mutal_ultra', 'zvt_9overpool', 'zvt_3hatch_mutal'],
  description: '레이스 클로킹 견제 vs 뮤탈리스크 울트라리스크 전환',
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
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 매크로 빌드입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 스타포트를 향합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 팩토리가 올라갑니다! 레이스 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 저글링을 소량 뽑습니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 소수 마린으로 정찰합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 공중전 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설합니다! 레이스 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리고 스파이어 건설!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스파이어가 올라갑니다! 뮤탈 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다! 은밀한 공격!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 편대 생산 완료! 견제 나갑니다!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '레이스 vs 뮤탈리스크! 공중 대결이 시작됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공중 교전 + 울트라 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스가 오버로드를 사냥합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 클로킹 레이스! 오버로드가 터집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈이 테란 일꾼을 잡습니다! 서로 견제전!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 슬쩍 올립니다! 울트라 전환 준비!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '서로 공중 견제를 주고받습니다! 하지만 저그가 울트라를 준비하고 있어요!',
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
              text: '{home} 선수 클로킹 레이스가 저그 드론을 학살합니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 투명 레이스가 일꾼을 잡아냅니다! 디텍팅이 없어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니가 늦었습니다! 드론 피해가 심각!',
              owner: LogOwner.away,
              awayResource: -15,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 지상군으로 마무리 공격! 자원 차이가 결정적!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '클로킹 견제가 울트라 전에 승부를 결정지었습니다! GG!',
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
              text: '{away} 선수 울트라리스크가 등장합니다! 지상이 뚫립니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -25,
              favorsStat: 'macro',
              altText: '{away}, 울트라가 나왔습니다! 테란 지상군이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스로는 울트라를 잡을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 울트라와 저글링이 테란 본진을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라 전환 성공! 공중 견제로는 막을 수 없었습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
