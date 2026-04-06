part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS vs 원팩 푸시
// ----------------------------------------------------------
const _tvtBbsVs1fac1star = ScenarioScript(
  id: 'tvt_bbs_vs_1fac_push',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_1fac_1star'],
  description: 'BBS vs 원팩 푸시 초반 공격 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-6) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 센터로 보냅니다.',
          owner: LogOwner.home,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설, 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -250, // 배럭(150) + 리파이너리(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home} 선수 센터 배럭을 올립니다. 공격적인 빌드.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 원팩 푸시를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -300, // 팩토리
          fixedCost: true,
          altText: '{away} 선수 팩토리가 올라갑니다. 빠른 메카닉을 노립니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설. BBS입니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home} 선수 BBS 확정. 마린을 모읍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 3, // 마린 3기
          homeResource: -150, // 마린 3기 (50x3)
          fixedCost: true,
        ),
      ],
    ),
    // Phase 1: BBS 돌진 (lines 10-12) - recovery 100/줄
    ScriptPhase(
      name: 'bbs_rush',
      startLine: 10,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 3기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, // 마린 2기 추가
          homeResource: -100, // 마린 2기 (50x2)
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 돌진! 빠른 공격!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에서 벌처가 나옵니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 벌처 1대 (2sup)
          awayResource: -75, // 벌처
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 상대 진지에 벙커 건설 시도.',
          owner: LogOwner.home,
          homeResource: -100, // 벙커
          fixedCost: true,
          altText: '{home} 선수 벙커를 올립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 벌처로 벙커 건설을 방해합니다.',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 분기 (lines 15+) - recovery 150/줄
    ScriptPhase(
      name: 'rush_result',
      startLine: 15,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        ScriptBranch(
          id: 'tech_defends',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 마린을 견제합니다! 기동력 차이!',
              owner: LogOwner.away,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'defense',
              altText: '{away} 선수 벌처로 마린 격퇴!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 기계화 유닛을 못 잡아요!',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 탱크까지 합류! BBS를 완전히 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, // 탱크 1대 (2sup)
              awayResource: -250, // 탱크
              fixedCost: true,
              homeArmy: -1, // 마린 1기 사망
              altText: '{away} 선수 탱크가 도착합니다! BBS를 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -150, // SCV 손실
            ),
            ScriptEvent(
              text: 'BBS가 막혔습니다. 전환기에 들어갑니다.',
              owner: LogOwner.system,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bbs_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 화력 집중!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처밖에 없습니다! 벙커 마린을 못 뚫어요!',
              owner: LogOwner.away,
              awayArmy: -2, // 벌처 1대 사망 (2sup)
            ),
            ScriptEvent(
              text: '{home} 선수 마린으로 밀어붙입니다! SCV 수리까지!',
              owner: LogOwner.home,
              awayArmy: -1, // 마린 1기 사망
              favorsStat: 'control',
              altText: '{home} 선수 마린 화력! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 일꾼이 많이 죽었습니다!',
              owner: LogOwner.away,
              awayResource: -200, // SCV 손실
            ),
            ScriptEvent(
              text: 'BBS 공격이 큰 피해를 줬습니다. 하지만 끝나진 않았습니다.',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 24-32) - recovery 200/줄
    ScriptPhase(
      name: 'mid_transition',
      startLine: 24,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설. 머신샵도 올립니다.',
          owner: LogOwner.home,
          homeResource: -500, // 리파이너리(100) + 팩토리(300) + 머신샵(100)
          fixedCost: true,
          altText: '{home} 선수 팩토리에 머신샵을 올립니다. 메카닉 전환.',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵에서 시즈 모드 연구를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -300, // 시즈모드 + 머신샵(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산 시작. BBS 이후 전환합니다.',
          owner: LogOwner.home,
          homeArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
          homeResource: -325, // 탱크(250) + 벌처(75)
          fixedCost: true,
          altText: '{home} 선수 탱크와 벌처로 전환합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크 벌처가 모입니다. 원팩 푸시의 장점이 나옵니다.',
          owner: LogOwner.away,
          awayArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
          awayResource: -325, // 탱크(250) + 벌처(75)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설. 컨트롤타워를 올립니다.',
          owner: LogOwner.home,
          homeResource: -350, // 스타포트(250) + 컨트롤타워(100)
          fixedCost: true,
          altText: '{home} 선수 스타포트 건설 후 컨트롤타워를 올립니다. 드랍십을 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 상대 스타포트를 확인합니다. 드랍십 견제 가능성이 있습니다.',
          owner: LogOwner.away,
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설. 업그레이드를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -125, // 엔지니어링베이
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 드랍십 생산 시작. 기동전을 노립니다.',
          owner: LogOwner.home,
          homeArmy: 2, // 드랍십 1대 (2sup)
          homeResource: -200, // 드랍십
          fixedCost: true,
        ),
        ScriptEvent(
          text: '전환기에 들어갑니다. 양쪽 모두 메카닉 체제.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 교전 강화 (공격 능력치 유리)
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
    // Phase 4: 중반 결전 - 분기 (lines 34+) - recovery 200/줄
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 34,
      recoveryResourcePerLine: 200,
      recoveryArmyPerLine: 2,
      branches: [
        // 게릴라 드랍: 견제 후 회수, decisive 아님
        ScriptBranch(
          id: 'guerrilla_drop',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크 한 대를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍십 출격. 상대 미네랄 라인을 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 확장기지에 탱크 투하! SCV를 잡아냅니다!',
              owner: LogOwner.home,
              awayResource: -200, // SCV 손실
              awayArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 시즈! 원팩 측 생산 건물을 포격합니다!',
              owner: LogOwner.home,
              awayResource: -150,
              awayArmy: -1,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 피해가 큽니다! 원팩 측이 당황합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 대응합니다. {home} 선수 드랍십을 회수합니다.',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '드랍으로 시선을 끈 사이 정면에서 거리재기가 이어집니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 마무리 드랍: 유리한 쪽이 드랍과 정면 동시로 끝냄
        ScriptBranch(
          id: 'finishing_drop',
          baseProbability: 1.1,
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대 출격. 본진과 확장 동시 투하를 노립니다.',
              owner: LogOwner.home,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크를 내립니다! 뒤쪽 미네랄 라인 공격!',
              owner: LogOwner.home,
              awayResource: -200, // SCV 손실
              awayArmy: -2, // 피해
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 시즈! 양면 공격!',
              owner: LogOwner.home,
              homeArmy: -2, // 탱크 1대 사망
              awayArmy: -4, // 탱크 2대 사망
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 초반 피해를 이어갑니다! 원팩 측이 회복하지 못합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 양면 공격으로 상대를 압살합니다!',
            ),
          ],
        ),
        // 정면 승부: 드랍 없이 탱크 라인 전진
        ScriptBranch(
          id: 'frontal_push',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{away} 선수 테크 우위. 탱크 벌처 물량이 앞섭니다.',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
              awayResource: -325, // 탱크(250) + 벌처(75)
              fixedCost: true,
              favorsStat: 'macro',
              altText: '{away} 선수 물량 차이. 원팩 푸시의 힘이 나옵니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.away,
              homeArmy: -4, // 탱크 2대 사망
              awayArmy: -2, // 탱크 1대 사망
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 벌처로 밀어냅니다! BBS를 역전합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 초반을 버텨내고 물량 차이로 밀어냅니다!',
            ),
          ],
        ),
        // 역전 드랍: 불리한 쪽이 올인 본진 드랍
        ScriptBranch(
          id: 'desperate_drop',
          baseProbability: 0.8,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 정면에서 밀리고 있습니다. 승부수를 던집니다.',
              owner: LogOwner.home,
              homeArmy: -2, // 정면 피해
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 올인 드랍! 본진을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.home,
              awayResource: -300, // 팩토리 피해
              awayArmy: -3, // 피해
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '올인 드랍이 큰 피해를 줬습니다. 이후 결전에서 판가름 납니다.',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
  ],
);
