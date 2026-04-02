part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 포게이트 드라군 vs 쓰리게이트 스피드질럿
// ----------------------------------------------------------
const _pvp4gateDragoonVs3gateSpeedzealot = ScenarioScript(
  id: 'pvp_4gate_dragoon_vs_3gate_speedzealot',
  matchup: 'PvP',
  homeBuildIds: ['pvp_4gate_dragoon'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '포게이트 드라군 vs 쓰리게이트 스피드질럿',
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
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군 사업!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 포게이트 드라군을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔 건설! 각속 업그레이드를 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아둔! 스피드질럿 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 빠르게 추가합니다! 포게이트!',
          owner: LogOwner.home,
          homeResource: -45,
          altText: '{home}, 게이트웨이 4개! 드라군 물량!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 추가합니다! 쓰리게이트!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
      ],
    ),
    // Phase 1: 양측 병력 충돌 (lines 15-22)
    ScriptPhase(
      name: 'armies_clash',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 포게이트에서 드라군이 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20, favorsStat: 'attack',
          altText: '{home} 선수 드라군 편대! 사정거리로 밀어냅니다!',
        ),
        ScriptEvent(
          text: '{away}, 각속 완료! 스피드질럿이 돌진합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15, favorsStat: 'attack',
          altText: '{away} 선수 스피드질럿! 빠른 질럿이 드라군에 달라붙습니다!',
        ),
        ScriptEvent(
          text: '드라군 물량 vs 스피드질럿 돌진! 사정거리 vs 속도의 대결!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'clash_result',
      startLine: 23,
      branches: [
        // 분기 A: 드라군이 거리 유지하며 승리
        ScriptBranch(
          id: 'dragoon_kites',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{home}, 드라군이 거리를 유지하며 질럿을 잡습니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home} 선수 드라군 컨트롤! 질럿이 접근하지 못합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 도착하기 전에 녹습니다! 사정거리 차이!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드라군 편대로 반격! 본진까지 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '포게이트 드라군! 사정거리로 스피드질럿을 제압합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 스피드질럿이 접근전에서 승리
        ScriptBranch(
          id: 'speedzealot_melee',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{away}, 스피드질럿이 드라군에 달라붙습니다! 접근 성공!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'attack',
              altText: '{away} 선수 질럿이 달라붙으면 드라군은 끝!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 근접전에서 질럿을 이기지 못합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 추가 스피드질럿 합류! 드라군이 전멸합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '스피드질럿 돌진! 접근전에서 드라군을 녹여버립니다!',
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
