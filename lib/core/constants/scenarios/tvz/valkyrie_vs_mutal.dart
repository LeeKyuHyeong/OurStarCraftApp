part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 8. 발키리 바이오닉 vs 뮤탈 (대공 특화)
// ----------------------------------------------------------
const _tvzValkyrieVsMutal = ScenarioScript(
  id: 'tvz_valkyrie_vs_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_valkyrie', 'tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_2hatch_mutal', 'zvt_3hatch_mutal',
                 'zvt_trans_2hatch_mutal', 'zvt_trans_mutal_ultra'],
  description: '발키리 대공 vs 뮤탈리스크',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          text: '{away} 선수 앞마당에 해처리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올립니다! 앞마당 확장!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에 머신샵 부착하면서 테크를 올립니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리 머신샵! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산하면서 레어 올립니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워 부착에 아머리까지!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 스타포트 컨트롤타워 아머리가 동시에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스파이어 올립니다! 뮤탈 준비!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 마린을 소량 뽑아두면서 방어 체제를 갖춥니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
          altText: '{home}, 마린 소량 생산! 수비 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 깔아놓으면서 버팁니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -5,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 테크를 올리면서 본격적인 대결을 준비합니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 발키리 생산 vs 뮤탈 등장 (lines 17-26)
    ScriptPhase(
      name: 'valkyrie_buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트에서 발키리 생산 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -20,
          altText: '{home}, 발키리가 나옵니다! 대공 특화 유닛!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 3기 등장합니다!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -20,
          altText: '{away}, 뮤탈이 떴습니다! 견제를 나갈 텐데요.',
        ),
        ScriptEvent(
          text: '{home}, 마린 메딕도 생산하면서 복합 편성 준비!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 뮤탈이 테란 본진을 정찰합니다! 발키리를 확인!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away} 선수 뮤탈 정찰! 발키리를 확인했습니다!',
        ),
      ],
    ),
    // Phase 2: 뮤탈 견제 대응 - 분기 (lines 27-38)
    ScriptPhase(
      name: 'mutal_harass_response',
      startLine: 27,
      branches: [
        // 분기 A: 발키리 대공 성공
        ScriptBranch(
          id: 'valkyrie_counter_mutal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈이 SCV를 노리고 들어오는데! 발키리가 대응합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home}, 발키리 스플래시 데미지! 뭉쳐있던 뮤탈에 큰 피해!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'defense',
              altText: '{home} 선수 발키리가 범위 공격! 공중 유닛을 한꺼번에 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 산개! 하지만 피해가 있었습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              altText: '{away}, 뮤탈을 빼지만 피해가 있네요!',
            ),
            ScriptEvent(
              text: '발키리 대공이 빛나는 순간입니다! 뮤탈이 자유롭게 움직이지 못합니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 뮤탈 소수 견제 후 물량전 전환
        ScriptBranch(
          id: 'mutal_avoid_valkyrie',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 발키리를 확인하고 뮤탈을 다른 곳으로 빼줍니다!',
              owner: LogOwner.away,
              awayArmy: 2, favorsStat: 'strategy',
              altText: '{away}, 발키리를 피해서 앞마당 쪽으로 뮤탈 기동!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈이 발키리 없는 앞마당 SCV를 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 뮤짤! 앞마당이 비어있어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 달려오지만 이미 뮤탈이 빠졌습니다.',
              owner: LogOwner.home,
              homeResource: -5,
              altText: '{home}, 발키리 대응이 늦었습니다! SCV 피해가 크네요.',
            ),
            ScriptEvent(
              text: '뮤탈이 발키리를 피해 기동하면서 견제를 이어갑니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 병력 운용 (lines 39-52)
    ScriptPhase(
      name: 'mid_game',
      startLine: 39,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 발키리 추가 생산! 골리앗도 섞어줍니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 발키리 골리앗 조합! 대공 화력이 엄청납니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로는 정면 교전이 불리합니다. 저글링 물량을 늘립니다.',
          owner: LogOwner.away,
          awayArmy: 7, awayResource: -15,
          altText: '{away} 선수 뮤탈 대신 지상 물량으로 전환!',
        ),
        ScriptEvent(
          text: '{home}, 바이오닉과 발키리 복합 편성으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 마린 메딕 발키리 출진! 저그 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈이 후방에서 견제하면서 저글링이 정면에서 막습니다!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -2, favorsStat: 'control',
          altText: '{away} 선수 뮤탈 견제와 저글링 수비 동시에!',
        ),
        ScriptEvent(
          text: '대공이 완벽한 테란 vs 기동성의 뮤탈! 어디서 교전하느냐가 관건입니다.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 전환기 - 분기 (lines 53-66)
    ScriptPhase(
      name: 'transition',
      startLine: 53,
      branches: [
        // 분기 A: 테란 발키리 밀어붙이기
        ScriptBranch(
          id: 'terran_valkyrie_push',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발키리 3기! 하늘을 완전히 장악합니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -20, favorsStat: 'defense',
              altText: '{home}, 발키리 편대가 하늘을 지배합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 대신 저글링 물량을 크게 늘려갑니다!',
              owner: LogOwner.away,
              awayArmy: 2,
            ),
            ScriptEvent(
              text: '{home}, 안전하게 확장하면서 화력을 키워갑니다!',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: 10,
              altText: '{home} 선수 발키리 덕에 안정적! 멀티까지!',
            ),
            ScriptEvent(
              text: '대공 장악이 완벽합니다! 뮤탈이 갈 곳이 없네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 저그 럴커 전환
        ScriptBranch(
          id: 'zerg_lurker_transition',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈이 막히니까 럴커로 전환합니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -25, favorsStat: 'strategy',
              altText: '{away}, 히드라덴 건설! 럴커로 노선 변경!',
            ),
            ScriptEvent(
              text: '{away}, 럴커가 앞마당 입구에 포진! 발키리로는 못 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 럴커 매복! 지상에서 막겠다는 의도!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 지상은 못 치죠! 탱크를 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '발키리의 약점이 드러납니다. 지상 화력이 부족한 상황!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 전개 (lines 67-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 67,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 총 병력을 모읍니다! 바이오닉 발키리 탱크 복합!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 최종 편성 완료! 공중 지상 모두 갖췄습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 남은 뮤탈과 저글링 럴커를 총동원합니다!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -20,
          altText: '{away}, 공중 지상 총출동! 전면전 준비!',
        ),
        ScriptEvent(
          text: '양측 풀 병력 전면전입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 발키리가 뮤탈을 잡고 마린이 저글링을 잡습니다! 체계적인 전투!',
          owner: LogOwner.home,
          awayArmy: -3, homeArmy: -5,
          altText: '{home} 선수 발키리 대공 + 바이오닉 지상! 역할 분담이 완벽합니다!',
        ),
        ScriptEvent(
          text: '{away}, 럴커가 마린을 녹이고 저글링이 탱크를 덮칩니다!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          altText: '{away} 선수 럴커 저글링 합동! 바이오닉이 녹아내립니다!',
        ),
      ],
    ),
    // Phase 6: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 81,
      branches: [
        ScriptBranch(
          id: 'terran_complex_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발키리 탱크 복합이 저그를 제압합니다!',
              owner: LogOwner.home,
              homeArmy: 15,
            ),
            ScriptEvent(
              text: '복합 편성의 위력! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_overwhelms',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 럴커 저글링 물량이 테란 전선을 무너뜨립니다!',
              owner: LogOwner.away,
              awayArmy: 15,
            ),
            ScriptEvent(
              text: '물량이 상대를 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

