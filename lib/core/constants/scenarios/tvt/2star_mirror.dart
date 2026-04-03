part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12. 투스타 레이스 미러 (공중전)
// ----------------------------------------------------------
const _tvt2starMirror = ScenarioScript(
  id: 'tvt_wraith_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_2star'],
  description: '투스타 레이스 미러 클로킹 공중전',
  phases: [
    // Phase 0: 오프닝 (lines 1-11) - recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 SCV가 정찰을 나갑니다! 투스타 미러 냄새가 납니다!',
          owner: LogOwner.system,
          altText: '양 선수 SCV 정찰! 상대 빌드를 확인합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설! {away} 선수도 배럭!',
          owner: LogOwner.system,
          homeResource: -150, // 배럭 150
          awayResource: -150,
          fixedCost: true,
          altText: '양쪽 배럭이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취! {away} 선수도 가스!',
          owner: LogOwner.system,
          homeResource: -100, // 리파이너리 100
          awayResource: -100,
          fixedCost: true,
          altText: '양쪽 가스를 넣습니다!',
        ),
        ScriptEvent(
          text: '가스가 모이기 시작합니다! 테크 빌딩이 곧 올라오겠죠!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! {away} 선수도 팩토리!',
          owner: LogOwner.system,
          homeResource: -300, // 팩토리 300
          awayResource: -300,
          fixedCost: true,
          altText: '양쪽 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! {away} 선수도 스타포트!',
          owner: LogOwner.system,
          homeResource: -250, // 스타포트 250
          awayResource: -250,
          fixedCost: true,
          altText: '양쪽 스타포트! 공중 유닛 생산 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 스타포트! {away} 선수도 투스타포트 완성!',
          owner: LogOwner.system,
          homeResource: -250, // 스타포트 250
          awayResource: -250,
          fixedCost: true,
          altText: '양쪽 투스타포트! 대량 생산 체제에 돌입합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산! {away} 선수도 레이스!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -250, // 레이스 250 (2sup)
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '양쪽 레이스가 출격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구! {away} 선수도 클로킹!',
          owner: LogOwner.system,
          homeResource: -300, // 클로킹 300
          awayResource: -300,
          fixedCost: true,
          altText: '양쪽 클로킹 연구 시작! 타이밍이 승부를 가릅니다!',
        ),
        ScriptEvent(
          text: '투스타 레이스 미러! 클로킹 타이밍이 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // Phase 1: 레이스 공중전 (lines 12-19) - recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'wraith_clash',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 추가 생산! {away} 선수도 레이스 추가!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -250, // 레이스 추가 (250/2sup)
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '양쪽 레이스가 추가 출격! 공중전이 시작됩니다!',
        ),
        ScriptEvent(
          text: '레이스 대 레이스! 컨트롤 대결이 펼쳐집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 레이스 컨트롤! 상대 레이스를 집중 공격!',
          owner: LogOwner.home,
          awayArmy: -2, // 레이스 1기 격파 (2sup)
          favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤이 좋습니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 컨트롤! 맞교환!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 클로킹 연구가 곧 완성됩니다! 타이밍이 중요해요!',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // Phase 2: 클로킹 전쟁 - 분기 (lines 20-31) - recovery 150/줄
    ScriptPhase(
      name: 'cloak_war',
      startLine: 20,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 클로킹 먼저
        ScriptBranch(
          id: 'home_cloak_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스가 투명해집니다! 상대 진영 침투!',
              owner: LogOwner.home,
              awayResource: -300, // SCV 학살
              favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디텍이 늦습니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -200,
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 SCV를 학살합니다! 대참사!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 레이스 학살! 일꾼이 전멸 직전!',
            ),
            ScriptEvent(
              text: '클로킹 한 발 차이! 디텍이 늦으면 이렇게 됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 클로킹 먼저
        ScriptBranch(
          id: 'away_cloak_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 클로킹 완성! 레이스가 상대 진영에 침투합니다!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! SCV를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 디텍이 없습니다! SCV가 녹고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -200,
            ),
            ScriptEvent(
              text: '{away}, 클로킹 레이스로 SCV 학살! 상대 자원줄이 무너집니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 레이스 학살! 상대 일꾼이 녹습니다!',
            ),
            ScriptEvent(
              text: '클로킹 타이밍 차이! 한 발 빠른 쪽이 크게 앞섭니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 양쪽 클로킹 동시
        ScriptBranch(
          id: 'both_cloak',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 클로킹이 거의 동시에 완성됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 상대 레이스와 공중전! 보이지 않는 전투!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 클로킹 레이스 대 레이스! 컨트롤 대결!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 컨트롤로 반격! 치열한 공중전!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away}, 레이스 컨트롤! 클로킹 공중전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '클로킹 레이스 대 클로킹 레이스! 순수 컨트롤 대결!',
              owner: LogOwner.system,
              skipChance: 0.4,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 지상전 전환 (lines 32-49) - recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'ground_transition',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설! {away} 선수도 아머리!',
          owner: LogOwner.system,
          homeResource: -150, // 아머리 150
          awayResource: -150,
          fixedCost: true,
          altText: '양쪽 아머리가 올라갑니다! 골리앗 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산! {away} 선수도 골리앗!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -150, // 골리앗(150/2sup)
          awayArmy: 2, awayResource: -150,
          fixedCost: true,
          altText: '양쪽 골리앗이 생산됩니다! 대공 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크 생산! 시즈 모드 연구! {away} 선수도 탱크!',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -550, // 탱크(250/2sup) + 시즈모드(300)
          awayArmy: 2, awayResource: -550,
          fixedCost: true,
          altText: '양쪽 시즈탱크가 나옵니다! 시즈 연구 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 추가! {away} 선수도 병력 보강!',
          owner: LogOwner.system,
          homeArmy: 4, homeResource: -400, // 탱크(250/2sup) + 골리앗(150/2sup)
          awayArmy: 4, awayResource: -400,
          fixedCost: true,
          altText: '양쪽 탱크 골리앗 조합! 라인을 잡아갑니다!',
        ),
        ScriptEvent(
          text: '레이스 교전이 끝나고 지상전으로! 레이스를 잃은 쪽이 불리합니다!',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 50-60) - recovery 200/줄
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 총동원! {away} 선수도 전 병력 배치!',
          owner: LogOwner.system,
          homeArmy: 6, homeResource: -400, // 탱크(250/2sup) + 골리앗(150/2sup)
          awayArmy: 6, awayResource: -400,
          fixedCost: true,
          altText: '양측 전 병력 결집! 최종 교전 준비!',
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞섭니다!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 61+) - recovery 200/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 61,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 컨트롤 승리! 공중전에서 앞섭니다!',
              altText: '{home} 선수 골리앗 전환이 빠릅니다! 지상에서 밀어냅니다!',
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
              text: '{away} 선수 레이스 수싸움에서 승리! 상대 공중 전력을 괴멸시킵니다!',
              altText: '{away} 선수 클로킹 레이스로 상대 SCV를 학살! 자원 격차를 벌립니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
