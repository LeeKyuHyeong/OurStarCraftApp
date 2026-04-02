part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5팩 vs 레이스 클로킹
// ----------------------------------------------------------
const _tvt5facVsWraith = ScenarioScript(
  id: 'tvt_5fac_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_wraith_cloak'],
  description: '5팩 타이밍 vs 레이스 클로킹 지상 vs 공중',
  phases: [
    // Phase 0: 오프닝 (lines 1-8)
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
          text: '{home} 선수 팩토리를 빠르게 증설합니다! 5팩 체제!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 늘어납니다! 5팩!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설 후 스타포트! 레이스를 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작! 5팩 가동!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 5팩에서 벌처가 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트에서 레이스 생산! 클로킹을 노립니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '5팩 물량 vs 레이스 견제! 지상과 공중의 대결!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 교전 준비 (lines 12-22)
    ScriptPhase(
      name: 'mid_buildup',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 5팩에 머신샵 부착! 탱크 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 5팩 풀가동! 탱크가 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스 추가 생산! 클로킹 연구 중!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 아머리도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 시즈 연구와 아머리! 골리앗으로 대공까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 레이스로 견제! SCV를 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 터렛으로 대공!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 터렛을 올립니다! 레이스를 막아야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 스타포트! 레이스 물량을 늘립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 5팩 벌처로 센터를 장악합니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 벌처 물량! 지상에서는 압도적!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 상대 건설 SCV를 괴롭힙니다!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산! 대공 화력을 갖춥니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '5팩 물량 vs 클로킹 견제! 승부처가 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 초반 교전 - 분기 (lines 26+)
    ScriptPhase(
      name: 'first_clash',
      startLine: 26,
      branches: [
        ScriptBranch(
          id: 'home_ground_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 골리앗으로 레이스를 격추합니다! 5팩 대공!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 골리앗 화력! 레이스가 떨어집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스가 녹았습니다! 5팩 물량 앞에 견제 효과가 줄어듭니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 물량으로 전진 준비! 탱크 시즈!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'attack',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_air_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 클로킹 레이스 견제 대성공! SCV가 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 침투! 5팩 자원줄이 끊깁니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 가동이 늦어집니다! SCV 부족!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 시야 장악! 상대 움직임을 파악합니다!',
              owner: LogOwner.away,
              awayArmy: 1, favorsStat: 'scout',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 교전 (lines 32-38)
    ScriptPhase(
      name: 'tank_battle',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 5팩 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          altText: '{home}, 5팩 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리에서 탱크 시즈! 맞서는 모양새!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '5팩 탱크 라인 대 레이스 빌드! 물량 차이가 관건!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십으로 뒤쪽을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 드랍 견제! 뒤를 노립니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 정찰하면서 상대 움직임 파악!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+)
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      branches: [
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 5팩 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 5팩 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 물량에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크 골리앗으로 밀어붙입니다! 레이스까지 격추!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 골리앗 대공까지! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 물량으로 레이스 빌드를 꺾습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 5팩 타이밍 성공! 상대 병력을 압도합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 레이스 견제로 SCV 피해! 5팩 가동이 느려집니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 견제 대성공! 5팩 자원줄이 끊겼습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 물량이 부족합니다! SCV 피해가 결정적!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 레이스로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 공중 견제로 5팩을 무력화시킵니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 레이스 견제로 5팩을 꺾습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
