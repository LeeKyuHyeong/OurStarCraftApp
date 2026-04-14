part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS 올인 러시 vs 노배럭더블
// ----------------------------------------------------------
const _tvtBbsVsNobarDouble = ScenarioScript(
  id: 'tvt_bbs_vs_nobar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_nobar_double'],
  description: 'BBS 올인 러시 vs 노배럭더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-7) - recovery 100/줄
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
          text: '{away} 선수 앞마당에 커맨드센터를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -400, // 커맨드센터
          fixedCost: true,
          altText: '{away} 선수 배럭 없이 커맨드센터를 먼저 짓습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home} 선수 센터 배럭을 올립니다. 공격적인 빌드입니다.',
        ),
        ScriptEvent(
          text: '빌드가 극과극으로 나뉘었는데요! {away} 선수가 피해 없이 막을 수 있을까요?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설. 배럭을 두 개 올립니다. 초반에 승부를 보겠다는 거죠.',
          owner: LogOwner.home,
          homeResource: -150, // 배럭
          fixedCost: true,
          altText: '{home} 선수 배럭 두 개입니다. 가스도 안 짓고 마린에 올인하네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -150, // 배럭
          fixedCost: true,
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다. 센터배럭 3기, 본진 2기.',
          owner: LogOwner.home,
          homeArmy: 5, // 마린 5기 (1sup each)
          homeResource: -250, // 마린 5기 (50x5)
          fixedCost: true,
          altText: '{home} 선수 마린 5기가 빠르게 모입니다.',
        ),
      ],
    ),
    // Phase 1: BBS 공격 (lines 10-14) - recovery 100/줄
    ScriptPhase(
      name: 'bbs_attack',
      startLine: 10,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 5기에 SCV를 끌고 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 1, // 마린 1기 추가
          homeResource: -50, // 마린 1기
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 전진. 상대 앞마당에 벙커를 노립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭이 완성됩니다. 마린 생산 시작.',
          owner: LogOwner.away,
          awayArmy: 2, // 마린 2기
          awayResource: -100, // 마린 2기
          fixedCost: true,
          altText: '{away} 선수 마린이 나오기 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 끌어모아 마린 진격로를 막습니다.',
          owner: LogOwner.away,
          homeArmy: -2, // 마린 2기 사망 (SCV 방어)
          awayArmy: 1,
          favorsStat: 'defense',
          altText: '{away} 선수 SCV 컨트롤! 마린 진격을 늦춥니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 앞마당에 벙커 건설 시도.',
          owner: LogOwner.home,
          homeResource: -100, // 벙커
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 벙커를 올립니다. 마린이 들어가면 큰일입니다.',
        ),
        ScriptEvent(
          text: '벙커링이 시작됐습니다! SCV로 벙커를 끊을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: BBS 결과 → 후속 전개 → 결전 (통합 분기) - recovery 150/줄
    ScriptPhase(
      name: 'bbs_full_result',
      startLine: 16,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 벙커 완성 → BBS 성공 → 앞마당 파괴 → 홈 승리
        ScriptBranch(
          id: 'bbs_success_to_victory',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 0.7,
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 벙커에 마린 투입. 화력이 집중됩니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 마린으로 벙커를 공격하지만 화력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -3, // 마린 3기 사망
              homeArmy: -1, // 마린 1기 사망
            ),
            ScriptEvent(
              text: '{home} 선수 SCV 수리까지! 벙커가 버팁니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 마린이 벙커에서 쏟아내는 화력! SCV 수리!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터를 직접 노립니다! 커맨드에 큰 피해!',
              owner: LogOwner.home,
              awayArmy: -2, // 마린 2기 사망
              awayResource: -300, // 커맨드센터 피해 + SCV 손실
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 심각합니다! 일꾼이 녹고 있습니다!',
              owner: LogOwner.away,
              awayResource: -200, // SCV 손실
              awayArmy: -1, // 마린 1기 사망
            ),
            ScriptEvent(
              text: '마린 공격이 성공하고 있습니다! 앞마당이 위험합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린 투입! 앞마당을 끝장내려 합니다!',
              owner: LogOwner.home,
              homeArmy: 3, // 마린 3기 추가
              homeResource: -150, // 마린 3기 (50x3)
              fixedCost: true,
              awayArmy: -2, // 마린/SCV 사망
              awayResource: -150, // SCV 손실
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 필사적으로 SCV를 끌어모아 막아봅니다!',
              owner: LogOwner.away,
              awayArmy: 1,
            ),
            ScriptEvent(
              text: '{away} 선수 가스를 올리고 팩토리를 짓기 시작합니다. 탱크가 나오면 반격.',
              owner: LogOwner.away,
              awayResource: -400, // 리파이너리(100) + 팩토리(300)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '앞마당이 무너지기 전에 메카닉 유닛이 나올 수 있을까요?',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터 파괴! SCV를 몰살합니다!',
              owner: LogOwner.home,
              homeArmy: 4, // 마린 4기 추가
              homeResource: -200, // 마린 4기 (50x4)
              fixedCost: true,
              awayArmy: -5, // 대량 사상
              decisive: true,
              altText: '{home} 선수 벙커 마린 화력이 쏟아집니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
        // 분기 B: SCV로 마린 끊기 → BBS 방어 → 노배럭더블 반격 → 어웨이 승리
        ScriptBranch(
          id: 'bbs_defense_to_victory',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 SCV를 뭉쳐서 마린을 끊습니다! 벙커에 마린이 못 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'defense',
              altText: '{away} 선수 SCV 컨트롤로 벙커 짓는 SCV를 잡아냅니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 초반 공격이 실패합니다!',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 벙커 건설을 방해합니다. 벙커가 올라오지 못합니다.',
              owner: LogOwner.away,
              homeArmy: -1, // 마린 1기 사망
              altText: '{away} 선수 SCV로 벙커 짓는 SCV를 집중 공격!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 마린도 SCV도 손실이 큽니다.',
              owner: LogOwner.home,
              homeArmy: -1, // 마린 1기 사망
              homeResource: -150, // SCV 손실
            ),
            ScriptEvent(
              text: '{away} 선수 앞마당 커맨드를 지켜냅니다! 초반 러시 완전 차단!',
              owner: LogOwner.away,
              awayArmy: 2, // 마린 2기 생산
              awayResource: -100, // 마린 2기 (50x2)
              fixedCost: true,
              altText: '{away} 선수 앞마당이 가동됩니다. 초반 공격을 막아냈습니다.',
            ),
            ScriptEvent(
              text: '방어 성공. 공격 측은 가스도 없고 테크도 없습니다.',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 가스 채취 시작. 팩토리 건설.',
              owner: LogOwner.away,
              awayArmy: 2, // 벌처 1대 (2sup)
              awayResource: -475, // 리파이너리(100) + 팩토리(300) + 벌처(75)
              fixedCost: true,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리에서 벌처가 나옵니다. 빠르게 반격 준비.',
              owner: LogOwner.away,
              awayArmy: 4, // 벌처 2대 (2sup x2)
              awayResource: -150, // 벌처 2대 (75x2)
              fixedCost: true,
              homeArmy: -3, // 마린 3기 사망
            ),
            ScriptEvent(
              text: '{home} 선수 이제야 가스를 올립니다... 한참 늦었습니다.',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
              homeResource: -100, // 리파이너리
              fixedCost: true,
              altText: '{home} 선수 초반 공격 실패 후 테크 전환이 너무 늦습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 생산. {home} 선수는 탱크가 한참 멀었습니다.',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
              awayResource: -625, // 시즈모드(300) + 탱크(250) + 벌처(75)
              fixedCost: true,
              homeArmy: -3, // 마린 3기 사망
              altText: '{away} 선수 탱크가 나옵니다. 상대는 아직 팩토리 건설 중.',
            ),
            ScriptEvent(
              text: '빠른 확장의 자원과 테크 우위. 공격 측이 따라잡을 수 없는 격차입니다.',
              owner: LogOwner.system,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 마린을 덮칩니다! 마린으로는 상대가 안 됩니다!',
              owner: LogOwner.away,
              homeArmy: -4, // 마린 4기 사망
              awayArmy: 2, // 벌처 1대 (2sup) 추가
              awayResource: -75, // 벌처 1대
              fixedCost: true,
              favorsStat: 'control',
              altText: '{away} 선수 벌처 기동력! {home} 선수 마린이 잡혀나갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크가 도착합니다! 상대는 대응할 수단이 없습니다!',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 2대 (2sup x2)
              awayResource: -500, // 탱크 2대 (250x2)
              fixedCost: true,
              homeArmy: -5, // 마린 5기 사망
              decisive: true,
              altText: '{away} 선수 더블 자원 가동! 물량 차이로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
