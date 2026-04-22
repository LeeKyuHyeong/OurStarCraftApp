part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 더블 업그레이드
// ----------------------------------------------------------
const _pvt5gateCarrierVsUpgrade = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier', 'pvt_1gate_expand', 'pvt_carrier'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '5게이트 캐리어 vs 더블 업그레이드 — 후반 공중 vs 업그레이드 지상',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭에서 팩토리까지. 앞마당 커맨드센터도 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 팩토리에 앞마당까지! 안정적인 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 넥서스 건설! 양쪽 모두 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 엔지니어링 베이! 공방 업그레이드를 올리겠네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 늘리면서 드라군을 생산합니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -15,
        ),
        ScriptEvent(
          text: '양측 모두 후반을 준비하는 빌드입니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 1-1 업그레이드가 진행 중입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -20,
          altText: '{away} 선수, 아머리에서 공방 업그레이드! 풀업을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 공중 테크를 택합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 스타게이트가 올라갑니다! 캐리어 루트!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 편대가 견제를 시도합니다. 드랍십으로 기습!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2,          altText: '{away} 선수, 드랍십 기습! 프로토스 일꾼을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군으로 드랍십을 막아냅니다.',
          owner: LogOwner.home,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1, awayArmy: -1,        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 캐리어 테크를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
          altText: '{home} 선수, 플릿 비콘! 캐리어 생산을 향해 달립니다!',
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 더블 스타게이트에서 주력 함선 생산!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -30,
          altText: '{home} 선수, 캐리어가 나옵니다! 인터셉터를 채우는 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 2-2 업그레이드 완료! 3-3 연구 시작!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 2-2 완료! 풀업까지 얼마 남지 않았습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산도 추가합니다! 대공 준비!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -15,
          altText: '{away} 선수, 골리앗! 캐리어 대비를 서둡니다!',
        ),
        ScriptEvent(
          text: '캐리어 vs 풀업 바이오닉, 어느 쪽이 강할까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 캐리어 3기 편대! 인터셉터가 비처럼 쏟아집니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 5, awayArmy: -6,              altText: '{home} 선수, 캐리어 편대 출격! 인터셉터 폭풍!',
            ),
            ScriptEvent(
              text: '{away} 선수 풀업 마린이 캐리어를 쏘지만 인터셉터가 벽입니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4, homeArmy: -1,
              altText: '{away} 선수, 마린이 쏘지만 인터셉터에 가로막힙니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 캐리어가 테란 확장기지를 파괴합니다! 자원이 끊깁니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -30,            ),
            ScriptEvent(
              text: '캐리어 공중 화력이 업그레이드 지상군을 압도합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 3-3 풀업 마린 골리앗이 대공 사격! 집중 화력!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4, awayArmy: 2,              altText: '{away} 선수, 풀업 병력의 대공! 골리앗이 집중 사격! 적 함대가 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 캐리어 1기 격추! 골리앗 사거리 업그레이드가 빛납니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
              altText: '{away} 선수 캐리어를 잡았습니다! 인터셉터도 소멸!',
            ),
            ScriptEvent(
              text: '{away} 선수, 풀업 마린 메딕 총공격! 프로토스 지상 병력을 밀어냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: -2,            ),
            ScriptEvent(
              text: '풀업 바이오닉과 골리앗의 조합! 캐리어를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
