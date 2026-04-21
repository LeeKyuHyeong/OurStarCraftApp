part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 1. 배럭 더블 vs 투팩 벌처
// 투팩이 팩토리 선행으로 병력 빠르게 압박, 배럭더블이 수비 후 자원 우위로 역전
// 수비 성공/실패에 따라 중반 전개가 완전히 달라지는 분기 구조
// ----------------------------------------------------------
const _tvt1barDoubleVs2facPush = ScenarioScript(
  id: 'tvt_1bar_double_vs_2fac_push',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1bar_double'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '배럭 더블 vs 투팩 벌처 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-13)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryArmyPerLine: 0,
      linearEvents: [
        // 홈: 배럭 (-150)
        ScriptEvent(
          text: '{home} 선수 배럭을 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -150,
        ),
        // 어웨이: 배럭 (-150)
        ScriptEvent(
          text: '{away} 선수도 배럭을 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -150,
        ),
        // 홈: SCV 정찰 (전투 행동, 비용 없음)
        ScriptEvent(
          text: '{home} 선수 SCV 정찰을 보냅니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 SCV가 상대 본진으로 향합니다.',
          skipChance: 0.3,
        ),
        // 어웨이: 리파이너리 (-100)
        ScriptEvent(
          text: '{away} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -100,
        ),
        ScriptEvent(
          text: 'SCV 정찰로 상대 팩토리 타이밍을 꼼꼼히 체크합니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.5,
        ),
        // 홈: 커맨드센터 (-400)
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다. 빠른 확장.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -400,
          altText: '{home} 선수 앞마당 커맨드센터. 자원 우위를 가져가겠다는 의도.',
        ),
        // 어웨이: 팩토리(-300) + 머신샵(-100) = -400
        ScriptEvent(
          text: '{away} 선수 팩토리 건설. 머신샵도 바로 붙입니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -400,
          altText: '{away} 선수 팩토리에 머신샵. 테크를 빠르게 올리네요.',
        ),
        // 어웨이: 두 번째 팩토리 (-300)
        ScriptEvent(
          text: '{away} 선수 두 번째 팩토리 건설. 병력 생산을 두 배로 가져갑니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -300,
          altText: '{away} 선수 팩토리가 하나 더. 벌처 대량 생산 체제입니다.',
        ),
        // 홈: 마린 2기 생산 + 가스(-100) + 팩토리(-300) + 머신샵(-100) = -600
        ScriptEvent(
          text: '{home} 선수 마린 2기를 생산하고 팩토리를 올립니다. 머신샵 부착.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, // 마린 2기 (1sup x2)
          homeResource: -600, // 마린 2기(100) + 가스(100) + 팩토리(300) + 머신샵(100)
        ),
        // 어웨이: 벌처 3기 (+6sup, -225)
        ScriptEvent(
          text: '{away} 선수 벌처 생산 시작. 팩토리가 먼저 올라간 만큼 병력도 빠릅니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 6,
          awayResource: -225,
          altText:
              '{away} 선수 벌처가 나옵니다. 상대보다 팩토리가 빨랐으니 당연한 속도 차이.',
        ),
        ScriptEvent(
          text: '후반을 바라보는 상대에게 공격적인 빌드입니다! 수비할 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '공격적인 선택! 병력이 상대보다 빠르게 쏟아집니다.',
        ),
      ],
    ),
    // Phase 1: 투팩 pressure (lines 14-21)
    ScriptPhase(
      name: 'twofac_pressure',
      recoveryArmyPerLine: 0,
      linearEvents: [
        // 어웨이: 벌처 추가 + 시즈탱크 1기 (+2sup벌처 +2sup탱크 = +4, -75-250 = -325)
        ScriptEvent(
          text: '{away} 선수 벌처 3기와 시즈 탱크 1기로 전진합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -325,
          altText: '{away} 선수 두 팩토리에서 나온 병력이 상대 앞마당을 향합니다! 탱크까지 동행!',
        ),
        // 홈: 마린 2기(+2sup, -100) + 벙커(-100) + 벌처 1기(+2sup, -75) = +4sup, -275
        ScriptEvent(
          text: '{home} 선수 앞마당 벙커. 마린과 벌처로 막아봅니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4,
          homeResource: -275,
          altText: '{home} 선수 급하게 벙커를 올립니다. 마린이 들어갑니다.',
        ),
        ScriptEvent(
          text: '팩토리 두 개에서 나오는 병력이 압도적입니다! 상대가 버텨야 합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.4,
          altText: '팩토리 랠리 포인트가 센터로 향합니다.',
        ),
        // 전투: 시즈 포격으로 벙커와 마린 피해
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 포격! 벙커가 녹고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -4,
          altText: '{away} 선수 시즈 포격이 벙커를 직격합니다!',
        ),
        ScriptEvent(
          text: '첫 탱크가 나오기 전까지는 폭풍전야입니다.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.6,
        ),
        // 홈: 첫 탱크 생산 (+2sup, -250)
        ScriptEvent(
          text: '{home} 선수 팩토리에서 탱크가 겨우 나옵니다. 하지만 시즈 연구가 아직입니다.',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2,
          homeResource: -250,
          altText: '{home} 선수 첫 탱크가 나왔지만 시즈 모드가 없습니다.',
        ),
      ],
    ),
    // Phase 2: 수비 결과 분기 (lines 22-29)
    ScriptPhase(
      name: 'defense_result',
      recoveryArmyPerLine: 1,
      branches: [
        // 분기 A: 투팩 공격 성공 — 다양한 피해 양상
        ScriptBranch(
          id: 'twofac_damage',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            // 벌처 우회 → SCV 피해 (전투)
            ScriptEvent(
              text: '{away} 선수 벌처 우회! SCV를 잡아냅니다!',
              owner: LogOwner.away,
              awayResource: 0,
              homeResource: -200, homeArmy: -2, awayArmy: 2,
              altText: '{away} 선수 탱크 포격 사이로 벌처가 SCV를 급습합니다!',
            ),
            // SCV 피해 심화 (전투)
            ScriptEvent(
              text: '{home} 선수 SCV 피해가 심각합니다! 앞마당 일꾼이 거의 없습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -150, homeArmy: -2,
              altText: '{home} 선수 커맨드센터를 띄웁니다! 파괴는 면했지만 가동이 멈춥니다!',
            ),
            // 벙커 파괴 (전투)
            ScriptEvent(
              text: '{away} 선수 탱크 추가 포격! 상대 벙커가 무너집니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -4, awayArmy: 2,
              altText: '{away} 선수 벙커를 밀고 본진까지 병력이 올라갑니다!',
            ),
            ScriptEvent(
              text: '공격이 큰 피해를 줬습니다! 수비 측 병력이 거의 없습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '꾸역꾸역 막고 있지만 힘들어보입니다! 두 팩토리의 압박이 거셉니다!',
              skipChance: 0.4,
            ),
          ],
        ),
        // 분기 B: 배럭더블 수비 성공 — 다양한 수비 양상
        ScriptBranch(
          id: 'double_defense',
          conditionStat: 'defense',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            // 벌처 격파 (전투)
            ScriptEvent(
              text: '{home} 선수 벙커 수리! 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -6, homeArmy: 2,
              altText: '{home} 선수 마인이 탱크를 잡습니다! 공격이 꺾입니다!',
            ),
            // 투팩 측 피해 (전투)
            ScriptEvent(
              text: '{away} 선수 벌처 피해가 큽니다! 탱크까지 잃습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,
              altText: '{away} 선수 벌처를 잃고 탱크만 남습니다! 후퇴를 고민합니다!',
            ),
            // 홈: SCV 복구 (자원 회복은 recovery가 처리)
            ScriptEvent(
              text: '{home} 선수 앞마당이 본격 가동됩니다. 자원 순환이 시작됩니다.',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 2,
              altText: '{home} 선수 SCV를 뽑으며 복구합니다. 앞마당이 정상 가동.',
            ),
            ScriptEvent(
              text: '수비 성공! 공격 측은 병력을 많이 잃었습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '공격이 막혔습니다! 이제 자원 차이가 벌어지기 시작합니다!',
              skipChance: 0.4,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 분기 - 투팩 마무리 vs 배럭더블 확장 (lines 30-37)
    ScriptPhase(
      name: 'post_defense',
      recoveryArmyPerLine: 2,
      branches: [
        // 분기 A: 투팩이 데미지 줬을 때 — 압박 지속, 끝내기
        ScriptBranch(
          id: 'twofac_finish',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            // 어웨이: 탱크 2기 추가 (+4sup, -500)
            ScriptEvent(
              text: '{away} 선수 탱크 추가 생산. 시즈 포격을 이어갑니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -500,
            ),
            // 홈: 시즈모드 연구 완료(-300) + 탱크 1기(+2sup, -250) = -550
            ScriptEvent(
              text: '{home} 선수 시즈 연구 완료. 하지만 병력이 너무 적습니다...',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -550,
            ),
            // 전투: 투팩 물량으로 압도
            ScriptEvent(
              text: '{away} 선수 두 팩토리 물량으로 앞마당까지 밀어냅니다! 탱크가 시즈 걸고 포격!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 4, homeArmy: -6,
              altText: '{away} 선수 두 팩토리의 생산력! 탱크 벌처가 끊임없이 나옵니다!',
            ),
            ScriptEvent(
              text: '끝내기를 노립니다! 수비 측은 벙커도 없고 병력도 없습니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.4,
              altText: '압도적인 화력! 이건 컨트롤로 극복이 안 됩니다!',
            ),
          ],
        ),
        // 분기 B: 배럭더블 수비 성공 후 — 확장
        ScriptBranch(
          id: 'double_expand',
          conditionStat: 'macro',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            // 홈: 시즈모드연구(-300) + 팩토리 추가 2개(-600) = -900, 탱크 생산 +4sup
            ScriptEvent(
              text: '{home} 선수 시즈 연구 완료. 팩토리를 추가합니다. 3팩, 4팩.',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 4,
              homeResource: -900,
              altText: '{home} 선수 더블 자원으로 팩토리가 쭉쭉 늘어납니다!',
            ),
            // 어웨이: 뒤늦은 확장 커맨드센터(-400) + 탱크 재생산
            ScriptEvent(
              text: '{away} 선수 뒤늦게 앞마당 확장... 탱크를 추가 생산합니다.',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, // 탱크 2대 (2sup x2)
              awayResource: -900, // 확장(400) + 탱크 2대(250x2)
            ),
            // 홈: 탱크 2기(+4sup, -500) + 벌처 2기(+4sup, -150) = +8sup, -650
            ScriptEvent(
              text: '{home} 선수 탱크가 쏟아집니다! 더블 자원의 힘!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 6, // 탱크 1대(2sup) + 벌처 2대(2sup x2)
              homeResource: -400, // 탱크(250) + 벌처 2대(75x2)
              altText: '{home} 선수 4팩에서 탱크 벌처가 끊임없이!',
            ),
            ScriptEvent(
              text:
                  '확장 자원 우위가 빛을 발합니다! 물량 차이가 나기 시작하네요!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.4,
              altText: '팩토리가 쉴 새 없이 돌아갑니다. 물량전 예고입니다.',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 판정 (lines 38+)
    ScriptPhase(
      name: 'decisive_outcome',
      recoveryArmyPerLine: 2,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          conditionStat: 'macro',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 더블 자원의 힘! 탱크 물량으로 상대를 압도합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{home} 선수 수비 후 팩토리 물량! 상대가 더 이상 밀 수 없습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 시즈 포격! 상대 앞마당을 완전히 밀어냅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '{away} 선수 두 팩토리 물량으로 끝까지 밀어냅니다! 상대가 버티질 못합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
