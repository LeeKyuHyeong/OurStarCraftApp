part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 캐리어 vs 안티 캐리어 (하드 카운터!)
// ----------------------------------------------------------
const _pvt5gateCarrierVsAntiCarrier = ScenarioScript(
  id: 'pvt_5gate_carrier_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_carrier'],
  awayBuildIds: ['tvp_trans_anti_carrier'],
  description: '5게이트 캐리어 vs 안티 캐리어 골리앗 — 하드 카운터 매치업!',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 배럭에서 팩토리! 아머리까지 빠르게 올립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리에 아머리! 골리앗 체제를 구축합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 이후 넥서스 건설!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 넥서스가 올라갑니다! 확장을 잡습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산 시작! 사거리 업그레이드도 연구합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗에 사거리 업그레이드! 대공 특화 빌드!',
        ),
        ScriptEvent(
          text: '테란이 안티 캐리어 빌드를 가져갑니다! 골리앗 중심!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 추가하며 드라군을 생산합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
        ),
      ],
    ),
    // Phase 1: mid_game (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 골리앗을 대량 생산합니다! 5기, 6기로 늘어나네요!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20, favorsStat: 'macro',
          altText: '{away}, 골리앗 물량! 사거리 업그레이드까지 완료!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타게이트 건설! 플릿 비콘도 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 스타게이트에 플릿 비콘! 캐리어를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크도 섞습니다. 지상 방어와 대공을 겸비!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 탱크에 골리앗! 지상 공중 모두 대비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 캐리어가 골리앗 상대로 힘든 매치업이 될 수 있습니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 물량을 확보하면서 캐리어를 기다립니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
      ],
    ),
    // Phase 2: late_setup (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 더블 스타게이트에서 캐리어 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 캐리어가 나옵니다! 인터셉터를 최대로 채웁니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 10기 이상! 사거리 업그레이드 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
          altText: '{away}, 골리앗 대군! 대공 사거리가 엄청납니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 아둔에 템플러 아카이브! 하이 템플러도 섞습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 캐리어만으로 안 됩니다! 하이 템플러를 추가!',
        ),
        ScriptEvent(
          text: '캐리어의 천적 골리앗! 프로토스가 어떻게 대응할까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: decisive_battle (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 하이 템플러 스톰! 밀집된 골리앗에 대참사!',
              owner: LogOwner.home,
              awayArmy: -7, homeArmy: -1, favorsStat: 'strategy',
              altText: '{home}, 스톰이 골리앗 편대에! 지상 유닛은 스톰에 약합니다!',
            ),
            ScriptEvent(
              text: '{home}, 스톰으로 골리앗을 정리한 뒤 캐리어가 진입합니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayArmy: -4, favorsStat: 'macro',
              altText: '{home} 선수 스톰 후 캐리어 투입! 대공이 사라졌습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 녹으면서 캐리어를 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '스톰으로 골리앗을 제거! 캐리어가 하늘을 지배합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 골리앗이 캐리어에 집중 포화! 사거리가 압도적!',
              owner: LogOwner.away,
              homeArmy: -5, favorsStat: 'defense',
              altText: '{away}, 골리앗 대공! 캐리어가 접근도 못합니다!',
            ),
            ScriptEvent(
              text: '{away}, 캐리어 2기가 연속 격추! 인터셉터도 전멸!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -1,
              altText: '{away} 선수 캐리어를 연속으로 잡아냅니다! 안티 캐리어의 진가!',
            ),
            ScriptEvent(
              text: '{away}, 탱크 골리앗이 전진! 프로토스 본진으로 향합니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '안티 캐리어 전략의 완벽한 실행! 골리앗이 캐리어를 완봉!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
