part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5. 투스타 레이스 vs 뮤탈 (공중전)
// ----------------------------------------------------------
const _tvzWraithVsMutal = ScenarioScript(
  id: 'tvz_wraith_vs_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_2star_wraith', 'tvz_trans_wraith'],
  awayBuildIds: ['zvt_2hatch_mutal', 'zvt_3hatch_mutal',
                 'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra'],
  description: '투스타 레이스 vs 뮤탈리스크 공중전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 앞마당 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 일찍 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착! 테크를 서두르고 있습니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다! 빠른 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산하면서 레어 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 공중 유닛을 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 건설 준비! 뮤탈 타이밍이 다가옵니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 테크 빌드업 (lines 17-24)
    ScriptPhase(
      name: 'tech_buildup',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 공중 테크로 갑니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트가 올라갑니다! 레이스 생산을 노리는 건가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 저글링 깔아놓습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 가스 넣고 레어 테크 올리는 중입니다.',
        ),
        ScriptEvent(
          text: '{home}, 레이스 1기 생산! 클로킹 연구도 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수 첫 레이스가 나옵니다! 클로킹까지!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 건설 들어갑니다! 뮤탈 타이밍이 다가오는데요.',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 올라갑니다! 뮤탈 준비!',
        ),
      ],
    ),
    // Phase 2: 레이스 견제 vs 뮤탈 등장 - 분기 (lines 25-36)
    ScriptPhase(
      name: 'air_first_contact',
      startLine: 25,
      branches: [
        ScriptBranch(
          id: 'wraith_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 클로킹 레이스가 저그 본진으로 침투합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 클로킹! 레이스가 보이지 않습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 오버로드 격추! 서플라이가 막히는데요!',
              owner: LogOwner.home,
              awayArmy: -2, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 대공이 없습니다! 드론이 당하고 있어요!',
              owner: LogOwner.away,
              awayResource: -20,
              altText: '{away}, 오버로드도 빠지고 드론도 당합니다!',
            ),
            ScriptEvent(
              text: '레이스 견제가 효과적입니다! 뮤탈 타이밍이 크게 밀리겠는데요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'mutal_fast_response',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 빠르게 등장합니다! 레이스를 쫓아갑니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20, favorsStat: 'control',
              altText: '{away}, 뮤탈 타이밍이 절묘합니다! 레이스를 견제하러 갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 뮤탈에 쫓기고 있습니다! 수적 열세!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 레이스가 열세입니다! 뮤탈 물량에 밀려요!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 바로 SCV를 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 기동! 일꾼부터 노립니다!',
            ),
            ScriptEvent(
              text: '뮤탈 물량에 레이스가 밀리기 시작합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 공중전 본격화 (lines 37-50)
    ScriptPhase(
      name: 'air_battle',
      startLine: 37,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 추가 생산! 편대가 두꺼워집니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 레이스 3기째 나옵니다! 공중 화력이 강해지고 있어요!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크로 SCV를 물어뜯습니다!',
          owner: LogOwner.away,
          homeResource: -20, favorsStat: 'harass',
          altText: '{away} 선수 뮤짤! 일꾼을 솎아냅니다!',
        ),
        ScriptEvent(
          text: '{home}, 레이스가 뮤탈을 쫓아갑니다! 공중 추격전!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤! 뮤탈을 하나씩 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스커지 생산! 레이스를 노립니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayResource: -15, favorsStat: 'strategy',
          altText: '{away}, 스커지가 레이스에 돌진합니다!',
        ),
        ScriptEvent(
          text: '공중에서 치열한 전투가 벌어지고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 터렛 보강하면서 뮤탈 견제에 대비합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 51-65)
    ScriptPhase(
      name: 'transition',
      startLine: 51,
      branches: [
        ScriptBranch(
          id: 'terran_ground_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 견제 유지하면서 지상 병력 전환!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20, favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{home}, 아머리에서 골리앗 생산! 시즈 탱크와 합류합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home} 선수 지상 메카닉 합류! 화력이 두꺼워집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 견제하려 하지만 대공이 촘촘합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '레이스와 지상 복합 편성! 테란의 전환이 빛나는 순간입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_mutal_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 3해처리 풀가동! 뮤탈이 끝없이 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20, favorsStat: 'macro',
              altText: '{away}, 뮤탈 12기 돌파! 물량이 압도적!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 편대가 본진과 앞마당을 동시에 노립니다!',
              owner: LogOwner.away,
              homeResource: -25, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스만으로 막기 어렵습니다! 터렛이 부족해요!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
              altText: '{home}, 뮤탈 물량에 밀리고 있습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 물량이 레이스를 압도하기 시작합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 전개 (lines 66-78)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 66,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 남은 공중 병력 총동원! 최후의 공습!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 레이스 편대 전원 출격!',
        ),
        ScriptEvent(
          text: '{away} 선수도 뮤탈 스커지 풀가동! 공중 결전입니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -20,
          altText: '{away}, 뮤탈 스커지 총출동! 하늘의 승부!',
        ),
        ScriptEvent(
          text: '양측 공중 병력이 정면 충돌합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 레이스가 포격합니다! 뮤탈 편대를 격추시킵니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
          altText: '{home} 선수 레이스가 집중 사격! 공중 유닛을 격추합니다!',
        ),
        ScriptEvent(
          text: '{away}, 스커지가 자폭합니다! 상대 공중 유닛 격추!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -3, favorsStat: 'control',
          altText: '{away} 선수 스커지가 레이스를 잡아냅니다!',
        ),
      ],
    ),
    // Phase 6: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 79,
      branches: [
        ScriptBranch(
          id: 'terran_air_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스가 뮤탈을 제압했습니다! 제공권 장악!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -8,
            ),
            ScriptEvent(
              text: '제공권을 장악합니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_air_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 물량이 레이스를 압도합니다! 저그의 하늘!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8,
            ),
            ScriptEvent(
              text: '공중 유닛 물량이 제공권을 차지합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

