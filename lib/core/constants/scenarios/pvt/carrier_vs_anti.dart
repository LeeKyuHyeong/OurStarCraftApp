part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 캐리어 빌드 vs 안티 캐리어 (후반 대결)
// ----------------------------------------------------------
const _pvtCarrierVsAnti = ScenarioScript(
  id: 'pvt_carrier_vs_anti',
  matchup: 'PvT',
  homeBuildIds: [
    'pvt_carrier',
    'pvt_trans_5gate_carrier', 'pvt_trans_reaver_carrier',
  ],
  awayBuildIds: [
    'tvp_anti_carrier', 'tvp_1fac_gosu',
    'tvp_trans_anti_carrier', 'tvp_trans_upgrade',
  ],
  description: '캐리어 빌드 vs 안티 캐리어 후반 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설 후 앞마당 넥서스를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 사이버네틱스 코어에 넥서스까지! 확장을 가져가겠다는 모습!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵! 앞마당 커맨드센터도 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 팩토리 머신샵에 앞마당까지! 안정적인 운영!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 공중 테크로 가는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타게이트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 서두릅니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 대비인가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 플릿 비콘 건설! 공중 대형 유닛을 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 플릿 비콘! 최상위 공중 테크입니다!',
        ),
      ],
    ),
    // Phase 1: 캐리어 빌드업 (lines 17-28)
    ScriptPhase(
      name: 'carrier_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타게이트에서 생산 중! 인터셉터를 채우고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 스타게이트 가동! 공중 유닛 생산 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 업그레이드를 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -15,
          altText: '{away}, 엔지니어링 베이! 방어 태세 강화!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 추가 생산하면서 아둔에 템플러 아카이브까지 올립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 아둔에서 템플러 아카이브! 다중 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 대량 생산! 대공 준비를 합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 골리앗이 쏟아져 나옵니다! 대공 대비!',
        ),
        ScriptEvent(
          text: '양측 후반 테크가 갖추어지고 있습니다.',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 캐리어 생산 시작! 인터셉터 충전 중!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -30,
          altText: '{home}, 캐리어가 나옵니다! 공중 대형 유닛!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크도 추가 생산! 지상 화력을 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '캐리어 대 골리앗의 대결이 예상됩니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 캐리어 교전 - 분기 (lines 29-44)
    ScriptPhase(
      name: 'carrier_battle',
      startLine: 29,
      branches: [
        ScriptBranch(
          id: 'carrier_dominance',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 캐리어 3기! 인터셉터가 쏟아져 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -5, favorsStat: 'macro',
              altText: '{home} 선수 캐리어 편대! 인터셉터가 비처럼 쏟아집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어를 노리지만 인터셉터에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 하이 템플러가 스톰 투하! 테란 병력을 녹여냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -1, favorsStat: 'strategy',
              altText: '{home} 선수 스톰에 캐리어! 이중 화력에 테란이 무너집니다!',
            ),
            ScriptEvent(
              text: '캐리어가 전장을 지배하고 있습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'goliath_counter',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 골리앗 편대가 캐리어를 집중 포화! 대공 화력이 강합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2, favorsStat: 'defense',
              altText: '{away} 선수 골리앗이 집중 사격! 대공 화력으로 압도합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 캐리어 1기가 격추됩니다! 인터셉터도 손실!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크까지 합류! 지상 병력도 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '안티 캐리어 전략이 효과를 보고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
