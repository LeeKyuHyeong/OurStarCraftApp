part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 8. 4게이트 드라군 vs 원겟 멀티 (공격 vs 운영)
// ----------------------------------------------------------
const _pvp4gateVsMulti = ScenarioScript(
  id: 'pvp_4gate_vs_multi',
  matchup: 'PvP',
  homeBuildIds: ['pvp_4gate_dragoon'],
  awayBuildIds: ['pvp_1gate_multi'],
  description: '4게이트 드라군 vs 원겟 멀티',
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
          text: '{home} 선수 사이버네틱스 코어! 드라군 사업!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어 건설!',
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스를 빠르게 건설합니다! 원겟 멀티!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 빠른 확장! 자원 이점을 가져가겠다는 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 건설! 드라군 준비!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 빠르게 추가합니다! 3게이트!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 게이트웨이 추가! 드라군을 빠르게 모읍니다!',
        ),
      ],
    ),
    // Phase 1: 드라군 압박 (lines 15-24)
    ScriptPhase(
      name: 'dragoon_pressure',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 드라군 편대가 전진합니다! 멀티를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20, favorsStat: 'attack',
          altText: '{home} 선수 드라군 전진! 확장을 흔들어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 아직 적습니다! 멀티 자원을 믿고 버팁니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15,
          altText: '{away}, 드라군 수가 부족합니다! 시간을 벌어야 해요!',
        ),
        ScriptEvent(
          text: '4게이트 물량 vs 멀티 확장! 시간이 핵심입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 드라군 물량이 밀어냄
        ScriptBranch(
          id: 'dragoon_rush_wins',
          baseProbability: 0.15,
          events: [
            ScriptEvent(
              text: '{home}, 드라군 물량으로 상대 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -10, favorsStat: 'attack',
              altText: '{home} 선수 드라군이 밀려옵니다! 수가 너무 많아요!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 부족합니다! 게이트가 아직 안 돌아요!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 넥서스를 공격합니다! 확장을 무너뜨립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4게이트 타이밍! 멀티가 자리잡기 전에 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -8,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 멀티가 버텨내며 역전
        ScriptBranch(
          id: 'multi_holds',
          baseProbability: 1.85,
          events: [
            ScriptEvent(
              text: '{away}, 드라군과 질럿으로 앞마당을 지켜냅니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -1, favorsStat: 'defense',
              altText: '{away} 선수 수비 성공! 드라군을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군을 많이 잃었습니다! 압박 실패!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 게이트웨이가 추가로 돌아갑니다! 멀티 자원이 빛을 발합니다!',
              owner: LogOwner.away,
              awayArmy: 12, awayResource: 35,
              altText: '{away} 선수 병력이 쏟아져 나옵니다! 멀티의 힘!',
            ),
            ScriptEvent(
              text: '멀티가 버텨냈습니다! 자원 차이로 병력이 역전됩니다!',
              owner: LogOwner.away,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전개 (lines 41-52)
    ScriptPhase(
      name: 'late_game',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수도 앞마당 확장! 장기전으로 전환!',
          owner: LogOwner.home,
          homeResource: -30,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 멀티 자원으로 병력을 빠르게 보충합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -15,
          altText: '{away}, 멀티의 자원이 빛을 발합니다! 병력 보충이 빠릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 병력을 모읍니다! 아직 포기할 수 없습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 게이트웨이에서 드라군이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away}, 드라군 편대가 전진합니다! 멀티의 힘!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: 10, favorsStat: 'attack',
          altText: '{away} 선수 멀티 자원으로 압도합니다!',
        ),
        ScriptEvent(
          text: '멀티가 살아남으면서 자원 차이가 결정적입니다!',
          owner: LogOwner.away,
          homeArmy: -10,
          decisive: true,
        ),
      ],
    ),
  ],
);

