part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS vs 레이스 클로킹
// ----------------------------------------------------------
const _tvtBbsVs2star = ScenarioScript(
  id: 'tvt_bbs_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_2star'],
  description: 'BBS vs 레이스 클로킹 초반 러시 vs 공중 테크',
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
          text: '{away} 선수 팩토리 건설 후 스타포트까지 올립니다.',
          owner: LogOwner.away,
          awayResource: -550, // 팩토리(300) + 스타포트(250)
          fixedCost: true,
          altText: '{away} 선수 팩토리에 이어 스타포트가 올라갑니다. 공중 테크.',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설. 배럭을 두 개 올립니다.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home} 선수 배럭 두 개 확인. 마린을 모읍니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 스타포트를 정찰합니다. 공중 유닛이 나올 수 있습니다.',
          owner: LogOwner.home,
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
          text: '{away} 선수 스타포트에서 레이스가 나옵니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 레이스 1대 (2sup)
          awayResource: -250, // 레이스
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
          text: '{away} 선수 마린과 SCV로 벙커 건설을 방해합니다.',
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
              text: '{away} 선수 레이스가 마린을 견제합니다! 공중에서 화력 지원!',
              owner: LogOwner.away,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'defense',
              altText: '{away} 선수 레이스로 마린 격퇴!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 공중 유닛 대응이 없어요!',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 추가 레이스 생산. 마린 공격을 완전히 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, // 레이스 1대 (2sup)
              awayResource: -250, // 레이스
              fixedCost: true,
              homeArmy: -1, // 마린 1기 사망
              altText: '{away} 선수 레이스 물량! 초반 공격을 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -150, // SCV 손실
            ),
            ScriptEvent(
              text: '초반 공격이 막혔습니다. 전환기에 들어갑니다.',
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
              text: '{away} 선수 지상 병력이 부족합니다! 레이스만으로는 안 됩니다!',
              owner: LogOwner.away,
              awayArmy: -2, // 마린/SCV 2 사망
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
              text: '초반 공격이 큰 피해를 줬습니다. 공중 테크가 전세를 뒤집을 수 있을까요.',
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
          text: '{away} 선수 클로킹 연구 완성. 레이스가 사라집니다.',
          owner: LogOwner.away,
          awayResource: -400, // 클로킹(300) + 컨트롤타워(100)
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산 시작. 초반 이후 전환합니다.',
          owner: LogOwner.home,
          homeArmy: 2, // 탱크 1대 (2sup)
          homeResource: -250, // 탱크
          fixedCost: true,
          altText: '{home} 선수 탱크 체제로 전환합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 레이스로 견제. SCV를 노립니다.',
          owner: LogOwner.away,
          awayArmy: 2, // 레이스 1대 (2sup)
          awayResource: -250, // 레이스
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설. 터렛으로 대공 방어.',
          owner: LogOwner.home,
          homeResource: -200, // 엔지니어링베이(125) + 터렛(75)
          fixedCost: true,
          altText: '{home} 선수 엔지니어링 베이 건설. 터렛을 올려 공중 공격을 막습니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵을 올립니다. 탱크도 준비합니다.',
          owner: LogOwner.away,
          awayResource: -100, // 머신샵
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설. 컴샛스테이션을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -150, // 아카데미
          fixedCost: true,
        ),
        ScriptEvent(
          text: '전환기에 들어갑니다. 초반 러시 vs 공중 테크, 누가 유리할까요.',
          owner: LogOwner.system,
          skipChance: 0.2,
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
        // 대공 방어 성공 → 정면 승부
        ScriptBranch(
          id: 'anti_air_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: true,
          events: [
            ScriptEvent(
              text: '{home} 선수 스캔으로 클로킹을 잡고 터렛을 촘촘히 깝니다.',
              owner: LogOwner.home,
              homeResource: -150, // 터렛 2개 (75x2)
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{home} 선수 대공 방어가 완성됩니다. 공중 유닛을 봉쇄합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.home,
              awayResource: -200, // SCV 손실
              awayArmy: -2, // 레이스 1대 사망 (2sup)
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 시즈! 상대 라인을 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: -2, // 탱크 1대 사망
              awayArmy: -4, // 탱크 2대 사망
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 초반 피해에 대공 방어까지! 상대가 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 초반 마린 화력과 탱크로 상대를 압살합니다!',
            ),
          ],
        ),
        // 클로킹 견제 성공 → 레이스가 경기를 결정
        ScriptBranch(
          id: 'cloak_harass_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스 견제가 성공합니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: 2, // 레이스 1대 (2sup) 추가
              awayResource: -250, // 레이스
              fixedCost: true,
              favorsStat: 'harass',
              altText: '{away} 선수 클로킹 견제! 스캔이 없는 곳을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 초반 투자가 무겁습니다. 대공도 늦습니다.',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 레이스로 견제하면서 탱크도 모읍니다!',
              owner: LogOwner.away,
              homeArmy: -3, // 마린 3기 사망
              awayArmy: -2, // 레이스 1대 격추 (2sup)
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 클로킹 견제로 상대를 흔들어 놓고 탱크로 마무리합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 레이스 견제로 초반을 역전합니다!',
            ),
          ],
        ),
        // 소모전: 양쪽 비등, decisive 아님
        ScriptBranch(
          id: 'attrition',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home} 선수 터렛을 촘촘히 깝니다. 공중 유닛 격추!',
              owner: LogOwner.home,
              homeResource: -75, // 터렛 1개
              fixedCost: true,
              awayArmy: -2, // 레이스 1대 격추
            ),
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스로 빈 곳을 노립니다! SCV가 녹습니다!',
              owner: LogOwner.away,
              homeResource: -100, // SCV 손실
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '양쪽 다 결정적인 한 방 없이 소모전이 이어집니다.',
              owner: LogOwner.system,
              homeArmy: -1,
              awayArmy: -1,
            ),
          ],
        ),
      ],
    ),
  ],
);
