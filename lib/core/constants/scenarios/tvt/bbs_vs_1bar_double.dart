part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS 센터 2배럭 올인 vs 원배럭더블
// 1배럭더블은 배럭이 먼저 완성(2:14)되어 마린이 있고, 가스도 올라가는 중
// 노배럭더블보다 방어력이 높음 (마린 + 빠른 팩토리 전환)
// 벙커 완성 전에 BBS가 도착하지만, 마린 수비가 가능
// ----------------------------------------------------------
const _tvtBbsVs1barDouble = ScenarioScript(
  id: 'tvt_bbs_vs_1bar_double',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_1bar_double'],
  description: 'BBS 센터 올인 vs 원배럭더블',
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
          text: '{away} 선수 배럭 건설합니다. {home} 선수는 센터에 배럭을 올립니다.',
          owner: LogOwner.system,
          homeResource: -150, // 센터 배럭
          awayResource: -150, // 본진 배럭
          fixedCost: true,
          altText: '양쪽 배럭이 올라갑니다. {home} 선수는 센터, {away} 선수는 본진.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 두 번째 배럭 건설. 센터 배럭 두 개입니다.',
          owner: LogOwner.home,
          homeResource: -150, // 두 번째 센터 배럭
          fixedCost: true,
          altText: '{home} 선수 배럭 두 개입니다. 가스도 안 짓고 마린에 올인하네요.',
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 완성 후 앞마당 커맨드센터를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -400, // CC
          fixedCost: true,
          awayExpansion: true,
          altText: '{away} 선수 앞마당 커맨드센터를 올립니다. 표준적인 원배럭더블.',
        ),
        ScriptEvent(
          text: '{away} 선수 리파이너리 건설합니다. 첫 마린이 나옵니다.',
          owner: LogOwner.away,
          awayResource: -150, // 리파이너리(100) + 마린(50)
          awayArmy: 1, // 마린 1기
          fixedCost: true,
          altText: '{away} 선수 가스를 올리고 마린 생산을 시작합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV 정찰로 센터를 확인합니다. 배럭 두 개! BBS입니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 상대 빌드를 확인합니다. 센터 배럭 두 개네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 센터 배럭 두 개에서 마린이 빠르게 모이고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 5, // 마린 5기
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
          text: '{home} 선수 마린과 SCV를 끌고 전진합니다.',
          owner: LogOwner.home,
          homeArmy: 1, // 마린 1기 추가
          homeResource: -50, // 마린 1기
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수 마린 5기에 SCV를 끌고 상대 앞마당으로 향합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 2기로 앞마당을 지킵니다. 급하게 벙커를 올립니다.',
          owner: LogOwner.away,
          awayArmy: 1, // 마린 1기 추가 (총 2기)
          awayResource: -150, // 마린(50) + 벙커(100)
          fixedCost: true,
          favorsStat: 'defense',
          altText: '{away} 선수 벙커 건설 시작. BBS를 확인했으니 서두릅니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 끌어모아 마린 진격을 늦춥니다.',
          owner: LogOwner.away,
          homeArmy: -2, // 마린 2기 사망 (SCV 방어)
          favorsStat: 'defense',
          altText: '{away} 선수 SCV 컨트롤로 시간을 법니다. 벙커가 올라오고 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 상대 앞마당에 벙커 건설 시도합니다.',
          owner: LogOwner.home,
          homeResource: -100, // 벙커
          fixedCost: true,
          favorsStat: 'attack',
          altText: '{home} 선수도 벙커를 올립니다. 앞마당 벙커 경쟁이네요.',
        ),
        ScriptEvent(
          text: '벙커 경쟁입니다! 어느 쪽 벙커가 먼저 완성되느냐가 승부를 가릅니다.',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 결과 분기 (lines 16+) - recovery 150/줄
    ScriptPhase(
      name: 'bbs_result',
      startLine: 16,
      recoveryResourcePerLine: 150,
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: BBS 벙커 먼저 완성 → 마린 화력 집중 → 앞마당 파괴 → 홈 승리
        ScriptBranch(
          id: 'bbs_bunker_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{home} 선수 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기
              fixedCost: true,
              favorsStat: 'attack',
              altText: '{home} 선수 벙커에 마린 투입. 화력이 집중됩니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커도 올라오지만 마린 수가 적습니다. 화력 열세.',
              owner: LogOwner.away,
              awayArmy: -2, // 마린 2기 사망
              homeArmy: -1, // 마린 교환
              favorsStat: 'control',
              altText: '{away} 선수 마린으로 벙커를 공격하지만 수가 부족합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 SCV 수리까지! 벙커가 버팁니다!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기
              fixedCost: true,
              favorsStat: 'control',
              altText: '{home} 선수 마린이 벙커에서 화력을 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV를 끌어모아 막아보지만 마린 수 차이가 큽니다.',
              owner: LogOwner.away,
              awayArmy: -3, // 마린 3기 사망
              awayResource: -200, // SCV 손실
              homeArmy: -1, // 마린 1기 교환
            ),
            ScriptEvent(
              text: '{home} 선수 커맨드센터를 직접 노립니다! 앞마당에 큰 피해!',
              owner: LogOwner.home,
              homeArmy: 2, // 마린 2기 추가
              homeResource: -100, // 마린 2기
              fixedCost: true,
              awayResource: -300, // CC 피해 + SCV 손실
              favorsStat: 'attack',
              altText: '{home} 선수 앞마당 커맨드센터를 직접 공격합니다!',
            ),
            ScriptEvent(
              text: '마린 물량이 압도적입니다. 커맨드센터가 위험하네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리를 짓고 있지만 벌처가 나오려면 아직 멀었습니다.',
              owner: LogOwner.away,
              awayResource: -300, // 팩토리
              fixedCost: true,
              awayArmy: -2, // 마린 사망
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린 투입! 앞마당을 끝장내려 합니다!',
              owner: LogOwner.home,
              homeArmy: 3, // 마린 3기 추가
              homeResource: -150, // 마린 3기
              fixedCost: true,
              awayArmy: -3, // 마린/SCV 사망
              awayResource: -200, // SCV 손실
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 커맨드센터 파괴! 일꾼 피해도 심각합니다!',
              owner: LogOwner.home,
              homeArmy: 4, // 마린 4기 추가
              homeResource: -200, // 마린 4기
              fixedCost: true,
              awayArmy: -5, // 대량 사상
              decisive: true,
              altText: '{home} 선수 벙커 마린 화력이 쏟아집니다! 상대가 버틸 수 없습니다!',
            ),
          ],
        ),
        // 분기 B: 수비 벙커 완성 → 마린 방어 성공 → 팩토리 전환 → 어웨이 승리
        ScriptBranch(
          id: 'bbs_defense_holds',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커가 먼저 완성됩니다! 마린을 넣습니다!',
              owner: LogOwner.away,
              awayArmy: 2, // 마린 2기 추가
              awayResource: -100, // 마린 2기
              fixedCost: true,
              favorsStat: 'defense',
              altText: '{away} 선수 벙커에 마린 투입. 화력이 집중됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 벙커 화력에 녹습니다! 수가 줄어들고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'attack',
              altText: '{home} 선수 마린이 벙커에 막힙니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 수리로 벙커를 지킵니다. 마린도 계속 나옵니다.',
              owner: LogOwner.away,
              awayArmy: 2, // 마린 2기 추가
              awayResource: -100, // 마린 2기
              fixedCost: true,
              homeArmy: -2, // 마린 2기 사망
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 벙커가 안 뚫립니다... 마린도 SCV도 손실이 큽니다.',
              owner: LogOwner.home,
              homeArmy: -2, // 마린 2기 사망
              homeResource: -150, // SCV 손실
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다. 초반 공격이 실패합니다.',
              owner: LogOwner.home,
              homeArmy: -1, // 후퇴 중 마린 1기 사망
              altText: '{home} 선수 더 이상 밀어붙일 수 없습니다. 물러납니다.',
            ),
            ScriptEvent(
              text: '방어 성공입니다. {away} 선수 앞마당이 가동됩니다.',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리 건설합니다. 가스가 이미 올라와 있어 빠릅니다.',
              owner: LogOwner.away,
              awayResource: -300, // 팩토리
              fixedCost: true,
              altText: '{away} 선수 팩토리 건설. 가스 채취가 진행중이라 빠른 전환입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 이제야 가스를 올립니다... 한참 늦었네요.',
              owner: LogOwner.home,
              homeResource: -100, // 리파이너리
              fixedCost: true,
              altText: '{home} 선수 초반 공격 실패 후 테크 전환이 너무 늦습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 팩토리에서 벌처가 나옵니다. 마린으로는 상대가 안 됩니다.',
              owner: LogOwner.away,
              awayArmy: 4, // 벌처 2대 (2sup x2)
              awayResource: -150, // 벌처 2대 (75x2)
              fixedCost: true,
              homeArmy: -3, // 마린 3기 사망
              favorsStat: 'control',
              altText: '{away} 선수 벌처 기동력! {home} 선수 마린이 잡혀나갑니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 탱크 생산합니다. 앞마당 자원과 테크 격차가 벌어집니다.',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 1대(2sup) + 벌처 1대(2sup)
              awayResource: -325, // 탱크(250) + 벌처(75)
              fixedCost: true,
              homeArmy: -3, // 마린 3기 사망
              altText: '{away} 선수 탱크가 나옵니다. {home} 선수는 아직 팩토리 건설 중입니다.',
            ),
            ScriptEvent(
              text: '앞마당 자원과 테크 우위가 결정적입니다. {home} 선수가 따라잡을 수 없는 격차네요.',
              owner: LogOwner.system,
              homeArmy: -2, // 마린 2기 사망
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 시즈 모드! {home} 선수는 대응할 수단이 없습니다!',
              owner: LogOwner.away,
              awayArmy: 4, // 탱크 2대 (2sup x2)
              awayResource: -500, // 탱크 2대 (250x2)
              fixedCost: true,
              homeArmy: -5, // 대량 사상
              decisive: true,
              altText: '{away} 선수 더블 자원 가동! 물량 차이로 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
