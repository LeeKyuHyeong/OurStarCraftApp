part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 vs 4풀: 치즈 vs 치즈 극초반 올인 대결
// ----------------------------------------------------------
const _tvzBunkerVs4pool = ScenarioScript(
  id: 'tvz_bunker_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_4pool'],
  description: '벙커 러시 vs 4풀 저글링 러시 — 극초반 올인 대결',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터에 배럭을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 배럭이 센터 쪽에 올라갑니다! 공격적인 위치구요!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론 4기만에 스포닝풀 건설! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀이 올라갑니다! 아주 빠른 스포닝풀이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 상대 진영으로 보냅니다.',
          owner: LogOwner.home,
          homeResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 바로 테란 본진으로 달립니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '양쪽 모두 올인을 선택했습니다! 누가 먼저 도착할까요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 충돌 전개 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 2기 생산 완료! SCV와 함께 이동 중입니다.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 테란 본진 입구에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 1,
          favorsStat: 'harass',
          altText: '{away}, 저글링 6기가 테란 입구에 몰려옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에 남은 SCV로 저글링을 막아봅니다!',
          owner: LogOwner.home,
          homeArmy: -1,
          homeResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 앞마당에 도착! 벙커 건설을 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'control',
          altText: '{home}, 마린과 SCV가 저그 진영에 도착했습니다! 벙커 올립니다!',
        ),
        ScriptEvent(
          text: '서로 엇갈리는 공격! 양쪽 본진이 위험합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결전 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드론으로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          homeArmy: -1,
          favorsStat: 'control',
          altText: '{away}, 드론이 벙커 건설 중인 SCV를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV로 수리하면서 벙커를 올리려 합니다!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 테란 본진 일꾼을 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: -15,
          awayArmy: 1,
          favorsStat: 'harass',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '이 승부, 벙커가 완성되느냐 마느냐에 달려있습니다!',
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
              text: '{home} 선수 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -5,
              favorsStat: 'control',
              altText: '{home}, 벙커가 완성됐습니다! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론으로 막아보지만 벙커 화력이 강합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린 합류! 저그 본진을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 러시 성공! GG!',
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
              text: '{away} 선수 저글링이 테란 본진 SCV를 모두 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -25,
              awayArmy: 2,
              favorsStat: 'attack',
              altText: '{away}, 저글링이 일꾼을 전멸시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 완성되지 못합니다! SCV가 잡혔어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 저글링이 합류합니다! 테란 진영을 압도합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 저글링이 테란을 무너뜨렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
