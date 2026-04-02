part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 포게이트 드라군
// ----------------------------------------------------------
const _pvpDarkVs4gateDragoon = ScenarioScript(
  id: 'pvp_dark_vs_4gate_dragoon',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_4gate_dragoon'],
  description: '다크 올인 vs 포게이트 드라군',
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
          text: '{home} 선수 아둔 건설! 다크를 노립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크 올인으로 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 사업!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 빠르게 추가합니다! 포게이트 드라군!',
          owner: LogOwner.away,
          awayResource: -45,
          altText: '{away}, 게이트웨이 4개! 드라군 물량 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크 확정!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'dark_rush',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 포게이트 상대에게 다크!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 다크 출격! 포게이트에 자원을 쏟은 상대를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 빠르게 모으고 있습니다! 옵저버는 없어요!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -20,
        ),
        ScriptEvent(
          text: '포게이트는 로보틱스를 안 갔습니다! 디텍이 없을 가능성이 높아요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다크 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'dark_result',
      startLine: 23,
      branches: [
        // 분기 A: 디텍 없어 다크 성공
        ScriptBranch(
          id: 'dark_massacre',
          baseProbability: 0.65,
          events: [
            ScriptEvent(
              text: '{home}, 다크가 프로브를 학살합니다! 디텍이 없습니다!',
              owner: LogOwner.home,
              awayResource: -30, favorsStat: 'harass',
              altText: '{home} 선수 다크 대성공! 포게이트 빌드라 로보틱스가 없어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군으로 쫓지만 다크가 보이지 않습니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 프로브가 전멸! 게이트웨이가 있어도 자원이 없습니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '다크 올인 성공! 포게이트의 약점을 정확히 찌릅니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 캐논으로 급히 대응
        ScriptBranch(
          id: 'emergency_cannon',
          baseProbability: 1.35,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논을 긴급 건설합니다! 다크를 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -10, favorsStat: 'scout',
              altText: '{away}, 포지+캐논! 다크를 포착합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 캐논에 잡힙니다! 프로브 피해는 적습니다!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 포게이트 드라군이 전진합니다! 다크 실패 후 물량 차이!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15,
            ),
            ScriptEvent(
              text: '다크 올인 실패! 포게이트 드라군 물량이 밀려옵니다!',
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
