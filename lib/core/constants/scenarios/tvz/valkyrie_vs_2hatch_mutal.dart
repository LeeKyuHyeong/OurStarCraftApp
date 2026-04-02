part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 2해처리 뮤탈 — 대공 스플래시 vs 빠른 뮤탈
// ----------------------------------------------------------
const _tvzValkyrieVs2hatchMutal = ScenarioScript(
  id: 'tvz_valkyrie_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie', 'tvz_valkyrie'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '발키리 스플래시 대공 vs 2해처리 빠른 뮤탈리스크',
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
          text: '{away} 선수 앞마당에 해처리를 올립니다! 2해처리 체제!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 빠른 확장이네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 스타포트를 향합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 가스를 빨리 넣습니다! 공중 유닛을 서두르는군요.',
        ),
        ScriptEvent(
          text: '양쪽 모두 테크를 서두르고 있습니다! 누가 먼저 완성할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 테크 경쟁 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 스파이어가 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 붙입니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타포트에 컨트롤타워! 대공 유닛 생산 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 완성! 뮤탈리스크 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 편대가 출격합니다!',
          owner: LogOwner.away,
          homeResource: -5,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '뮤탈이 먼저 나왔습니다! 테란의 대공 유닛이 곧 합류할 텐데요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공중 교전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 뮤탈이 테란 본진을 급습합니다! SCV를 노립니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈 편대가 테란 일꾼을 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리가 본진으로 복귀! 뮤탈을 요격합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -3,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 터렛을 건설합니다! 대공망 구축!',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '발키리 스플래시가 뮤탈 뭉침을 노립니다! 공중 싸움이 관건이네요!',
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
              text: '{home} 선수 발키리 스플래시가 뮤탈 편대를 녹입니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -5,
              favorsStat: 'control',
              altText: '{home}, 발키리 한 방에 뮤탈 여러 기가 떨어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 녹아내립니다! 뭉쳐서 당했어요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 제공권 장악! 지상군으로 저그 진영을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '발키리가 뮤탈을 완벽히 카운터! 제공권을 빼앗겼습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈이 분산해서 견제합니다! 발키리를 피합니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈이 흩어져서 테란 곳곳을 공격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 뮤탈을 따라가지 못합니다! 속도 차이!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 일꾼 피해가 누적! 자원 차이가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 분산 견제 성공! 발키리가 따라잡지 못했습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
