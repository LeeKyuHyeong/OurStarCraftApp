part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 공중 vs 4풀 — 스타포트 테크 vs 극초반 러시
// ----------------------------------------------------------
const _tvzWraithVs4pool = ScenarioScript(
  id: 'tvz_wraith_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith'],
  awayBuildIds: ['zvt_4pool'],
  description: '레이스 클로킹 빌드 vs 4풀 저글링 러시',
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
          text: '{away} 선수 4풀입니다! 드론 4기만에 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀이 올라갑니다! 올인 러시 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 일찍 넣습니다. 레이스를 위한 테크!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 테란 본진으로 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '4풀 저글링이 달려옵니다! 스타포트 테크가 위험합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 초반 방어 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV로 저글링을 막습니다! 마린이 아직 없어요!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, SCV가 총동원됩니다! 저글링을 막아야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 SCV를 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: -15,
          awayArmy: 1,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 1기가 나왔습니다! 반격 시작!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 보냅니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          altText: '{away}, 저글링이 계속 밀려옵니다!',
        ),
        ScriptEvent(
          text: '테란이 살아남을 수 있을까요? 레이스까지 가려면 멀었습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 생존 후 반격 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린이 늘어나면서 저글링을 밀어냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 일꾼이 너무 적습니다! 자원이 바닥!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올립니다! 아직 레이스를 포기하지 않았어요!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 살아남았다면 레이스가 나올 수 있습니다!',
        ),
        ScriptEvent(
          text: '초반을 버텨낸 쪽이 이기는 경기입니다!',
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
              text: '{home} 선수 저글링을 정리! 마린 물량이 확보됩니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'defense',
              altText: '{home}, 저글링을 막아냈습니다! 역습 준비!',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 병력이 없습니다! 4풀의 한계!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 마린 부대가 저그 본진으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 방어 성공! 테란이 살아남았습니다! GG!',
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
              text: '{away} 선수 저글링이 SCV를 전부 잡아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              homeResource: -20,
              favorsStat: 'attack',
              altText: '{away}, 저글링이 일꾼을 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 자원이 끊겼습니다! 마린 생산이 불가!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 저글링으로 테란을 마무리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 성공! 레이스를 꿈도 꿀 수 없었습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
