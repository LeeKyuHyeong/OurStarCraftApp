part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 빌드 vs 4풀 — 스타포트 테크 vs 극초반 러시
// ----------------------------------------------------------
const _tvzValkyrieVs4pool = ScenarioScript(
  id: 'tvz_valkyrie_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_4pool'],
  description: '발키리 대공 빌드 vs 4풀 저글링 러시',
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
          text: '{away} 선수 드론 4기만에 스포닝풀! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀이 올라갑니다! 극초반 러시 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 일찍 넣습니다. 스타포트를 노리는 빌드!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 바로 테란 본진으로 달립니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
          altText: '{away}, 저글링이 쏟아져 나옵니다! 6기가 달려갑니다!',
        ),
        ScriptEvent(
          text: '4풀 저글링이 테란 본진에 도착합니다! 배럭이 아직 완성 전입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 초반 방어전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 동원해서 저글링을 막습니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, SCV로 저글링을 상대합니다! 필사적인 수비!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링이 SCV를 잡아냅니다! 일꾼 피해가 발생!',
          owner: LogOwner.away,
          homeResource: -15,
          awayArmy: 1,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 1기 생산! SCV와 함께 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          favorsStat: 'control',
          altText: '{home}, 마린이 나왔습니다! 이제 반격할 수 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 생산합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '스타포트 테크가 늦어지고 있습니다! 일단 살아남아야 합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 생존 후 테크 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린이 추가 합류! 저글링을 밀어냅니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -2,
          favorsStat: 'attack',
          altText: '{home}, 마린 물량이 늘어나면서 저글링을 정리합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 일꾼이 부족합니다! 자원 수급이 막혔어요!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 건설합니다! 늦었지만 테크를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '테란이 초반을 버텼느냐가 관건입니다! 발키리까지 갈 수 있을까요?',
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
              text: '{home} 선수 저글링을 완전히 정리! 마린 물량이 확보됩니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 병력이 없습니다! 일꾼 피해가 너무 컸어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 마린 부대가 저그 본진으로! 드론이 남아있지 않습니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{home}, 역습 들어갑니다! 저그 본진이 텅 비었어요!',
            ),
            ScriptEvent(
              text: '4풀 실패! 테란이 살아남았습니다! GG!',
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
              text: '{away} 선수 저글링이 마린을 둘러쌉니다! SCV 피해가 계속됩니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              homeResource: -20,
              favorsStat: 'attack',
              altText: '{away}, 저글링이 사방에서 SCV를 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 일꾼이 거의 남지 않았습니다! 자원이 바닥!',
              owner: LogOwner.home,
              homeResource: -15,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 저글링 합류! 테란 본진을 완전히 제압합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 러시 성공! 스타포트 테크를 볼 수 없었습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
