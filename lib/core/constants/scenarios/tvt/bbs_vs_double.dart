part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 2. BBS vs 노배럭 더블 (초반 공격)
// ----------------------------------------------------------
const _tvtBbsVsDouble = ScenarioScript(
  id: 'tvt_bbs_vs_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_cc_first', 'tvt_1fac_expand'],
  description: 'BBS 센터 배럭 vs 노배럭 더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-7)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노배럭 더블! 배럭 없이 커맨드 먼저 짓습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 배럭! 공격적인 빌드입니다!',
        ),
        ScriptEvent(
          text: '빌드가 극과극으로 나뉘었는데요! {away} 선수가 피해 없이 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, BBS 확정! 센터 마린3, 본진 마린2를 모읍니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 센터배럭 마린 3기, 본진배럭 마린 2기 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: 벙커 시도 (lines 11-14)
    ScriptPhase(
      name: 'bunker_attempt',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 5기에 본진 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 전진! 상대 앞마당에 벙커를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭이 완성됩니다! 마린 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 2,
          altText: '{away}, 마린 나오기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home}, 상대 앞마당에 벙커 건설 시작!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home} 선수 벙커 올립니다! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '벙커링이 시작됐습니다! 마린이 벙커에 들어가기 전에 끊을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: SCV 컨트롤로 마린 끊기 - 분기 (lines 17+)
    // 수비쪽 defense+control이 높으면 마린을 끊어냄
    ScriptPhase(
      name: 'marine_cut',
      startLine: 17,
      branches: [
        // 분기 A: 수비쪽 SCV가 마린을 끊어냄 → BBS 방어
        ScriptBranch(
          id: 'scv_cuts_marines',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV를 뭉쳐서 마린을 끊습니다! 벙커에 마린이 못 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'defense+control',
              altText: '{away}, SCV 컨트롤! 마린이 벙커에 못 들어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 줄어들고 있습니다! BBS가 흔들립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원 손실이 크겠는데요.',
              owner: LogOwner.home,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드를 지켜냅니다! BBS 완전 차단!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: 10,
              altText: '{away}, 앞마당이 가동됩니다! BBS를 막아냈습니다!',
            ),
            ScriptEvent(
              text: 'BBS 방어 성공! 더블 측이 자원 우위를 확보합니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 마린이 벙커에 들어감 → 벙커 완성
        ScriptBranch(
          id: 'bunker_success',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV로 막으려 하지만 벙커를 건설하는 SCV를 제거하지 못합니다!',
              owner: LogOwner.away,
              favorsStat: 'attack+control',
            ),
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 마린 투입!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린으로 벙커를 공격합니다! 하지만 쉽지 않습니다!',
              owner: LogOwner.away,
              awayArmy: -1, homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, SCV 수리까지! 벙커가 버팁니다!',
              owner: LogOwner.home,
              awayArmy: -1, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 위협합니다! 커맨드에 피해가 갑니다!',
              owner: LogOwner.home,
              awayResource: -20,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후속 전개 (lines 25-35)
    ScriptPhase(
      name: 'post_rush',
      startLine: 25,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리에 머신샵! 탱크를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리에 머신샵! 본격적인 메카닉 체제!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 탱크 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산! 속업까지!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 벌처로 맵 컨트롤을 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 더블 자원으로 탱크 벌처가 빠르게 모입니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'macro',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워를 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트 건설 후 컨트롤타워! 드랍십을 노립니다!',
        ),
        ScriptEvent(
          text: 'BBS 이후 전환기에 접어들었습니다! 양쪽 다 테크업!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 중반 결전 - 분기 (lines 38+)
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 38,
      branches: [
        ScriptBranch(
          id: 'home_recovers',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십에 탱크를 태워서 뒤로 보냅니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 뒤를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤쪽 미네랄 라인에 탱크가 내려옵니다!',
              owner: LogOwner.away,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 정면에서도 탱크 시즈! 양쪽에서 압박합니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 이후 완벽한 전환! 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_advantage',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 더블 자원으로 병력이 압도적! 탱크 라인이 두텁습니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'macro',
              altText: '{away} 선수 물량 차이가 나기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 초반 투자가 발목을 잡네요! 물량이 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 더블의 힘! 자원 우위로 밀어냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

