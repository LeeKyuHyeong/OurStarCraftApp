part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 쓰리게이트 스피드질럿 vs 투게이트 드라군
// ----------------------------------------------------------
const _pvp3gateSpeedzealotVs2gateDragoon = ScenarioScript(
  id: 'pvp_3gate_speedzealot_vs_2gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_3gate_speedzealot'],
  awayBuildIds: ['pvp_2gate_dragoon'],
  description: '쓰리게이트 스피드질럿 vs 투게이트 드라군',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 각속 업그레이드를 노립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 스피드질럿 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가합니다! 쓰리게이트!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 게이트웨이 3개! 스피드질럿 물량!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 추가! 투게이트 드라군!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
      ],
    ),
    // Phase 1: 스피드질럿 돌진 (lines 15-20)
    ScriptPhase(
      name: 'speedzealot_push',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 각속 업그레이드 완료! 스피드질럿이 돌진합니다!',
          owner: LogOwner.home,
          homeArmy: 5, favorsStat: 'attack',
          altText: '{home} 선수 스피드질럿! 빠른 질럿이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 모아 대응합니다! 사정거리로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -15,
        ),
        ScriptEvent(
          text: '스피드질럿 vs 드라군! 접근하면 질럿, 거리를 유지하면 드라군!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'clash_result',
      startLine: 21,
      branches: [
        // 분기 A: 스피드질럿 물량이 밀어냄
        ScriptBranch(
          id: 'speedzealot_overwhelm',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{home}, 스피드질럿이 드라군에 달라붙습니다! 수가 너무 많아요!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 질럿이 달라붙으면 드라군이 버틸 수 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 녹습니다! 각속 질럿이 너무 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 본진으로 돌진합니다! 프로브까지 노립니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스피드질럿 물량! 드라군이 녹으면서 본진이 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 드라군이 거리 유지하며 수비
        ScriptBranch(
          id: 'dragoon_kites',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{away}, 드라군이 거리를 유지하며 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away} 선수 드라군 컨트롤! 질럿이 접근하지 못합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 접근하기 전에 녹습니다! 사정거리 차이!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 사이버네틱스 코어에서 드라군 사거리 업그레이드! 격차가 벌어집니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -10,
            ),
            ScriptEvent(
              text: '드라군 컨트롤이 스피드질럿을 막아냅니다! 테크 차이가 결정적!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
