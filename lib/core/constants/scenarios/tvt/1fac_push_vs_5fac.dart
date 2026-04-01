part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9. 원팩원스타 vs 5팩토리 (비대칭 공격 대결)
// ----------------------------------------------------------
const _tvt1facPushVs5fac = ScenarioScript(
  id: 'tvt_1fac_push_vs_5fac',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_push'],
  awayBuildIds: ['tvt_5fac'],
  description: '원팩원스타 소수정예 vs 5팩토리 물량 올인',
  phases: [
    // Phase 0: 오프닝 (lines 1-13)
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
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취! 팩토리 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 가스 채취! 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 빠른 테크입니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 원팩원스타!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2팩... 3팩!',
          owner: LogOwner.away,
          awayResource: -40,
          altText: '{away}, 팩토리가 계속 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 탱크 소수 생산! 시즈 모드 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 벌처와 탱크가 나옵니다! 시즈 연구까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 4팩, 5팩! 벌처 탱크 대량 생산 체제!',
          owner: LogOwner.away,
          awayResource: -40, awayArmy: 2,
          altText: '{away}, 5팩토리! 물량으로 밀어붙이겠다는 의도!',
        ),
        ScriptEvent(
          text: '원팩원스타의 기술 vs 5팩의 물량! 극과극 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 원팩 선제공격 (lines 14-21)
    ScriptPhase(
      name: 'early_clash',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 벌처 탱크 소수정예로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 소수정예 출격! 5팩이 완성되기 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아직 물량이 덜 모였습니다! 팩토리에서 유닛이 나오는 중!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈! 상대 앞마당을 포격합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 시즈 포격! 상대 병력이 나오기 전에 밀어야!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 나오면서 마인을 깝니다! 시간을 끕니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'defense',
          altText: '{away}, 마인으로 시간 벌기! 물량이 모이길 기다립니다!',
        ),
        ScriptEvent(
          text: '5팩 물량이 도착하기 전에 끝내야 합니다! 시간이 없어요!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 선제공격 결과 - 분기 (lines 22-34)
    ScriptPhase(
      name: 'clash_result',
      startLine: 22,
      branches: [
        // 분기 A: 원팩 선제 성공 - 드랍과 정면 돌파
        ScriptBranch(
          id: 'push_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 탱크로 상대 팩토리 라인을 향해 돌진합니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 정면 돌파! 상대 생산시설을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리가 파괴됩니다! 생산력이 줄어들고 있어요!',
              owner: LogOwner.away,
              awayResource: -20, awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드랍십으로 후방 기습! 탱크를 내립니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'strategy',
              altText: '{home} 선수 드랍십 출격! 상대 후방이 불바다!',
            ),
            ScriptEvent(
              text: '정면과 후방 동시 공격! 5팩의 생산력을 꺾었습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 5팩 물량 도달 - 숫자로 압도
        ScriptBranch(
          id: 'mass_arrives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 5팩토리에서 탱크 벌처가 쏟아집니다! 물량이 도착했습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25, favorsStat: 'macro',
              altText: '{away} 선수 물량 폭발! 5팩의 위력이 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 소수정예로는 숫자를 감당할 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 탱크 벌처 대군으로 역공! 숫자가 힘!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'attack',
              altText: '{away} 선수 물량 공세! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '5팩 물량 앞에 소수정예가 한계를 드러냅니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반전 (lines 35-54)
    ScriptPhase(
      name: 'late_fight',
      startLine: 35,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 생산! 공중에서 견제를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 레이스 출격! 드랍과 레이스 투트랙 견제!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 골리앗으로 대공 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 생산!',
        ),
        ScriptEvent(
          text: '{home}, 드랍십으로 상대 확장기지를 노립니다!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'harass',
          altText: '{home} 선수 드랍 견제! 상대 SCV를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 생산 시작! 탱크 골리앗 조합으로 전환!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 골리앗이 합류합니다! 물량이 더 두터워집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 물량으로 벌처를 대량 보냅니다! 마인으로 상대 이동을 봉쇄!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'macro',
          skipChance: 0.3,
          altText: '{away}, 벌처 물량! 마인 매설로 상대 기동을 제한합니다!',
        ),
        ScriptEvent(
          text: '기술 vs 물량! 결전의 시간이 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 55-65)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원! 마지막 승부!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 결전입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 5팩 풀가동 물량! 탱크, 골리앗, 벌처 대군!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 총동원! 기술과 물량의 최종 대결!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격에 드랍 동시 투입! 상대 라인을 흔듭니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 멀티포인트 공격! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 물량으로 밀어붙입니다! 골리앗 화력 집중!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 화력! 숫자의 힘!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 66+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 66,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수가 결정적인 한 방을 날립니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수가 결정적인 한 방을 날립니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

