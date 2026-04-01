part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 6. 공격적 빌드 대결 (타이밍 싸움)
// ----------------------------------------------------------
const _tvtAggressiveMirror = ScenarioScript(
  id: 'tvt_aggressive_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_push', 'tvt_5fac'],
  awayBuildIds: ['tvt_wraith_cloak', 'tvt_2fac_vulture'],
  description: '공격적 빌드 대결 타이밍 싸움',
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
          text: '{home} 선수 팩토리 건설! 공격적인 운영!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설! 테크 경쟁입니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 벌처가 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 유닛 생산! 양쪽 다 공격적입니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '양측 다 확장 없이 병력에 집중하고 있습니다!',
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
          text: '{home} 선수 추가 팩토리 건설! 머신샵 부착합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 팩토리에 머신샵 추가! 물량 싸움을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 머신샵 부착! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구! 아머리도 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 시즈 연구와 아머리! 후반 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트 건설 후 컨트롤타워! 드랍십을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트 건설! 컨트롤타워 올리고 있습니다!',
          owner: LogOwner.away,
          awayResource: -25,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 센터에서 벌처 교전! 선제 타격을 노립니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 벌처 기동! 상대 벌처를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 맞대응! 벌처 컨트롤 대결!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산! 기동전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '공격적인 빌드 대결! 먼저 밀리면 끝입니다!',
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
          id: 'home_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처 컨트롤이 앞섭니다! 상대 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 벌처 싸움 승리! 맵 컨트롤!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 녹았습니다! 시야가 불리해지네요!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 벌처로 센터 장악! 마인까지 깔면서!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'harass',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_vulture_win',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 벌처 컨트롤이 더 좋습니다! 선제 타격!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 벌처 싸움 승리!',
            ),
            ScriptEvent(
              text: '{home} 선수 벌처 피해! 맵 컨트롤을 뺏겼습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처로 정찰하면서 상대 움직임을 파악합니다!',
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
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'strategy',
          altText: '{home}, 탱크 라인 구축! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈! 맞서는 모양새!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '양쪽 탱크 라인이 대치하고 있습니다! 거리재기!',
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
          text: '{away} 선수 벌처로 마인 매설! 진격로를 차단합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 타이밍 교전 결전 - 분기 (lines 40+)
    ScriptPhase(
      name: 'timing_clash',
      startLine: 40,
      branches: [
        // 분기 A: 홈 타이밍 성공
        ScriptBranch(
          id: 'home_timing',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 탱크 시즈! 상대 병력을 포격합니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 라인을 뚫습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 터집니다! 화력에서 밀리고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 탱크 골리앗으로 밀어붙입니다! 상대 생산시설까지 위협!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 골리앗 화력 추가! 압도적입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 타이밍 공격 성공! 병력 차이가 벌어집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 역습 성공
        ScriptBranch(
          id: 'away_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 병력이 더 빠르게 모입니다! 역습!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 역습! 상대 탱크 라인을 무너뜨립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 라인이 뚫립니다! 후퇴!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 탱크 골리앗으로 추격! 상대 생산시설을 노립니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 역습 성공! 생산력 차이로 결정됩니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

