part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 바이오닉 푸시 vs 4풀 (초반 치즈 대응)
// ----------------------------------------------------------
const _tvzBionicPushVs4pool = ScenarioScript(
  id: 'tvz_bionic_push_vs_4pool',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_bionic_push'],
  awayBuildIds: ['zvt_4pool'],
  description: '바이오닉 푸시 vs 4풀 극초반 저글링 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
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
          text: '{away} 선수 드론 4기만에 스포닝풀 건설! 4풀입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀이 정말 빠릅니다! 4풀이구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV로 정찰을 나갑니다.',
          owner: LogOwner.home,
          homeResource: -3,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 바로 출발합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링이 쏟아져 나옵니다! 테란 본진을 향해 달립니다!',
        ),
        ScriptEvent(
          text: '4풀 저글링이 매우 일찍 도착할 텐데요, 테란이 대비가 됐을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 + 초반 교전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 저글링이 테란 본진에 도착합니다! 마린이 아직 부족해요!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -1, favorsStat: 'attack',
          altText: '{away} 선수 저글링이 본진에 들어갑니다! 마린이 1기뿐!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 동원해서 저글링을 막아봅니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'defense',
          altText: '{home}, SCV 수리하면서 마린과 함께 저글링을 상대합니다!',
        ),
        ScriptEvent(
          text: '{away}, 추가 저글링이 합류합니다! 일꾼 피해를 노리구요!',
          owner: LogOwner.away,
          awayArmy: 2, homeResource: -15, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린이 계속 나오고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -8,
          altText: '{home}, 마린 생산이 이어집니다! 조금만 버티면!',
        ),
        ScriptEvent(
          text: '테란이 초반 위기를 넘길 수 있을지가 관건이네요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 테란 안정화 시도 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 숫자가 늘어나면서 저글링을 밀어냅니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -2, favorsStat: 'control',
          altText: '{home}, 마린이 모이면서 저글링을 처리합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 저글링을 보내지만 화력이 부족합니다.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 스팀팩 연구를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 일꾼이 4기뿐이라 자원 수급이 어렵습니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 드론이 너무 적어서 후속 병력이 나오질 않습니다.',
        ),
        ScriptEvent(
          text: '4풀의 초반 피해가 충분했는지가 승패를 가를 것 같습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-38)
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
              text: '{home} 선수 마린 메딕 부대가 완성됩니다! 바이오닉 푸시 나갑니다!',
              owner: LogOwner.home,
              homeArmy: 5, favorsStat: 'attack',
              altText: '{home}, 스팀팩 마린과 메딕이 저그 진영으로 출발합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 부족합니다! 4풀의 후유증이 크네요.',
              owner: LogOwner.away,
              awayArmy: -3, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 마린 메딕이 저그 본진을 압박합니다! 막을 수가 없어요!',
              owner: LogOwner.home,
              homeArmy: 2, awayArmy: -3, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '바이오닉 푸시가 성공합니다! GG!',
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
              text: '{away}, 초반 저글링 공격으로 SCV를 대량 학살했습니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
              altText: '{away} 선수 4풀 저글링이 일꾼을 거의 전멸시켰습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 자원이 바닥입니다! 마린 생산이 끊겼어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링으로 남은 건물까지 정리합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4풀 러시가 성공했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
