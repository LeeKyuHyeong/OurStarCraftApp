part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 10. BBS 미러 (치즈 미러)
// 양쪽 센터+본진 배럭 → 마린 SCV 러쉬 → 벙커 경쟁
// ----------------------------------------------------------
const _tvtBbsMirror = ScenarioScript(
  id: 'tvt_bbs_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_bbs'],
  description: 'BBS 같은 빌드 센터 배럭 치즈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-9) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 SCV가 센터로 향합니다. BBS 같은 빌드입니다.',
          owner: LogOwner.system,
          altText: '양 선수 SCV를 센터로 보냅니다. 센터 배럭을 노립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설. {away} 선수도 센터 배럭을 올립니다.',
          owner: LogOwner.system,
          homeResource: -150, // 센터 배럭
          awayResource: -150, // 센터 배럭
          fixedCost: true,
          altText: '양쪽 센터에 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭을 올립니다. {away} 선수도 본진 배럭.',
          owner: LogOwner.system,
          homeResource: -150, // 본진 배럭
          awayResource: -150, // 본진 배럭
          fixedCost: true,
          altText: '양쪽 본진에도 배럭이 올라갑니다. BBS 같은 빌드.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭에서 마린 3기 생산. {away} 선수 배럭에서도 마린 3기.',
          owner: LogOwner.system,
          homeArmy: 3, homeResource: -150, // 마린 3기 (50x3)
          awayArmy: 3, awayResource: -150,
          fixedCost: true,
          altText: '양쪽 배럭에서 마린이 쏟아집니다! 센터에서 곧 마주칩니다!',
        ),
      ],
    ),
    // Phase 1: 마린 SCV 전진 (lines 10-17) - recovery 100/줄
    ScriptPhase(
      name: 'marine_clash',
      startLine: 10,
      recoveryResourcePerLine: 100,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린과 SCV를 뭉쳐서 전진! {away} 선수도 전진! 센터에서 마주칩니다!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -100, // 마린 2기 추가 (50x2)
          awayArmy: 2, awayResource: -100,
          fixedCost: true,
          altText: '양쪽 마린과 SCV가 센터에서 정면으로 부딪칩니다!',
        ),
        ScriptEvent(
          text: '센터에서 마린과 SCV 대결! 누가 먼저 벙커를 올리느냐!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 벙커 건설. {away} 선수도 벙커를 올립니다. 양쪽 벙커 싸움입니다.',
          owner: LogOwner.system,
          homeResource: -100, // 벙커 100
          awayResource: -100,
          fixedCost: true,
          altText: '양쪽 벙커가 동시에 올라갑니다. 벙커 싸움입니다.',
        ),
      ],
    ),
    // Phase 2: 벙커 전쟁 - 분기 (lines 18-27) - recovery 100/줄
    ScriptPhase(
      name: 'bunker_war',
      startLine: 18,
      recoveryResourcePerLine: 100,
      branches: [
        // 분기 A: 홈 벙커 선점
        ScriptBranch(
          id: 'home_bunker_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 완성! 마린이 먼저 들어갑니다!',
              owner: LogOwner.home,
              favorsStat: 'control',
              altText: '{home} 선수 벙커 선점! 마린이 투입됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커가 아직 짓는 중! 마린이 벙커 화력에 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2, // 마린 2기 사망
              altText: '{away} 선수 벙커 완성이 늦습니다! 마린이 녹고 있어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV 수리! 벙커가 안 무너집니다!',
              owner: LogOwner.home,
              awayArmy: -1,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커 선점 차이! 먼저 완성한 쪽이 크게 유리합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 벙커 선점
        ScriptBranch(
          id: 'away_bunker_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 완성! 마린이 먼저 들어갑니다!',
              owner: LogOwner.away,
              favorsStat: 'control',
              altText: '{away} 선수 벙커 선점! 마린 투입!',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 늦습니다! 마린이 상대 벙커에 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home} 선수 벙커 완성이 늦어서 마린 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 수리까지! 벙커를 지켜냅니다!',
              owner: LogOwner.away,
              homeArmy: -1,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '벙커 선점! 한 발 빠른 완성이 승부를 결정합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 양쪽 벙커 교착
        ScriptBranch(
          id: 'both_bunkers',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 벙커가 거의 동시에 완성됩니다! 교착 상태!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린으로 상대 벙커를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -50, // 마린 1기
              awayArmy: -1,
              awayResource: -50, // 어웨이도 마린 추가 생산 중
              favorsStat: 'attack',
              altText: '{home} 선수 추가 마린 투입! 상대 벙커를 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 추가 마린! SCV로 벙커를 수리합니다!',
              owner: LogOwner.away,
              awayArmy: 1, awayResource: -50,
              homeArmy: -1,
              homeResource: -50, // 홈도 마린 추가 생산 중
              favorsStat: 'defense',
              altText: '{away} 선수 마린과 SCV로 버팁니다!',
            ),
            ScriptEvent(
              text: '양쪽 벙커 교착! 후반전으로 넘어갑니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반전 - 팩토리 전환 (lines 28-40) - recovery 150/줄
    ScriptPhase(
      name: 'aftermath',
      startLine: 28,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 가스를 올리고 팩토리 건설. {away} 선수도 팩토리를 올립니다.',
          owner: LogOwner.system,
          homeResource: -400, // 리파이너리(100) + 팩토리(300)
          awayResource: -400,
          fixedCost: true,
          altText: '양쪽 팩토리가 올라갑니다. 벌처로 전환합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산. {away} 선수도 벌처를 뽑습니다. 센터에서 교전!',
          owner: LogOwner.system,
          homeArmy: 4, homeResource: -150, // 벌처 2기 (75x2)
          awayArmy: 4, awayResource: -150,
          fixedCost: true,
          altText: '양쪽 벌처가 출격합니다. 기동전으로 전환합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵에서 탱크 생산. 시즈 모드 연구를 시작합니다. {away} 선수도 탱크.',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -550, // 시즈탱크(250) + 시즈모드(300)
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          altText: '양쪽 팩토리에서 탱크가 나옵니다. 시즈 연구도 시작합니다.',
        ),
        ScriptEvent(
          text: '양측 탱크가 충돌합니다! 최종 교전!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크를 직격!',
          owner: LogOwner.home,
          awayArmy: -4, homeArmy: -2,
          awayResource: -200,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 우회! 탱크 포격에 맞섭니다!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -2,
          homeResource: -200,
          favorsStat: 'defense',
          altText: '{away} 선수 벌처 우회 공격! 반격!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 벌처/탱크 교전 강화 (공격 능력치 유리)
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다, 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // Phase 4: 결전 판정 - 분기 (lines 41+) - recovery 150/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 41,
      recoveryResourcePerLine: 150,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 센터 벙커전 승리! 마린 컨트롤 차이가 결정적입니다!',
              altText: '{home} 선수 추가 마린이 합류하며 상대 벙커를 무너뜨립니다!',
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
              text: '{away} 선수 센터 벙커전 승리! 마린 수싸움에서 앞섭니다!',
              altText: '{away} 선수 SCV 수리 타이밍이 적절했습니다! 벙커를 사수합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
