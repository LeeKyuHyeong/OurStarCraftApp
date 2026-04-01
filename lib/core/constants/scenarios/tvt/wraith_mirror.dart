part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12. 투스타 레이스 미러 (공중전)
// ----------------------------------------------------------
const _tvtWraithMirror = ScenarioScript(
  id: 'tvt_wraith_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_wraith_cloak'],
  awayBuildIds: ['tvt_wraith_cloak'],
  description: '투스타 레이스 미러 클로킹 공중전',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
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
          text: '{home} 선수 가스 채취! 팩토리 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 그리고 2번째 스타포트도!',
          owner: LogOwner.home,
          homeResource: -50,
          altText: '{home}, 투스타포트! 레이스를 대량 생산하겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수도 투스타포트! 레이스 대량 생산!',
          owner: LogOwner.away,
          awayResource: -50,
          altText: '{away}, 투스타포트! 양쪽 투스타 레이스 미러입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산 시작! 클로킹 연구도 시작!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 생산! 클로킹 연구!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '투스타 레이스 미러! 클로킹 타이밍이 승부를 가릅니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 레이스 공중전 (lines 12-19)
    ScriptPhase(
      name: 'wraith_clash',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 레이스 3기로 상대 진영 정찰! 공중전 시작!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'control',
          altText: '{home} 선수 레이스 출격! 상대 레이스와 마주칩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레이스로 맞대응! 공중에서 교전!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'control',
          altText: '{away}, 레이스 대 레이스! 공중전입니다!',
        ),
        ScriptEvent(
          text: '레이스 대 레이스! 컨트롤 대결이 펼쳐집니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 레이스 컨트롤! 상대 레이스를 집중 공격!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤이 좋습니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 컨트롤! 맞교환!',
          owner: LogOwner.away,
          homeArmy: -1, favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 클로킹 연구가 곧 완성됩니다! 타이밍이 중요해요!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 클로킹 전쟁 - 분기 (lines 20-31)
    ScriptPhase(
      name: 'cloak_war',
      startLine: 20,
      branches: [
        // 분기 A: 홈 클로킹 먼저
        ScriptBranch(
          id: 'home_cloak_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 완성! 레이스가 투명해집니다! 상대 진영 침투!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV가 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디텍이 늦습니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 SCV를 학살합니다! 대참사!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
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
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! SCV를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 디텍이 없습니다! SCV가 쓰러지고 있어요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 클로킹 레이스로 SCV 학살! 상대 경제가 무너집니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
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
            ),
            ScriptEvent(
              text: '{home}, 클로킹 레이스로 상대 레이스와 공중전! 보이지 않는 전투!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 클로킹 레이스 대 레이스! 컨트롤 대결!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 컨트롤로 반격! 치열한 공중전!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'control',
              altText: '{away}, 레이스 컨트롤! 클로킹 공중전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '클로킹 레이스 대 클로킹 레이스! 순수 컨트롤 대결!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 지상전 전환 (lines 32-49)
    ScriptPhase(
      name: 'ground_transition',
      startLine: 32,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 골리앗 생산 시작!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리! 골리앗으로 대공과 지상 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리! 골리앗 생산!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아머리가 올라갑니다! 골리앗 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 탱크 생산! 시즈 모드 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 골리앗 탱크! 시즈 연구까지! 지상 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 골리앗 탱크 생산! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 시즈! 라인을 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          altText: '{home}, 탱크 골리앗 조합! 라인을 잡아갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 시즈! 라인 대치!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
        ScriptEvent(
          text: '레이스 교전이 끝나고 지상전으로! 레이스를 잃은 쪽이 불리합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 결전 (lines 50-60)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 50,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 총동원! 최종 교전 준비!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 전투!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 골리앗 전 병력 배치! 정면 교전!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격! 상대 탱크 라인을 직격!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 화력으로 반격!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞섭니다!',
        ),
      ],
    ),
    // Phase 5: 결전 판정 - 분기 (lines 61+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 61,
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

