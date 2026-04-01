part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 2. 메카닉 vs 럴커/디파일러 (장기전)
// ----------------------------------------------------------
const _tvzMechVsLurker = ScenarioScript(
  id: 'tvz_mech_vs_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_3fac_goliath', 'tvz_valkyrie', 'tvz_trans_mech_goliath', 'tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_2hatch_lurker', 'zvt_1hatch_allin', 'zvt_trans_lurker_defiler', 'zvt_trans_530_mutal', 'zvt_trans_ultra_hive'],
  description: '메카닉 vs 럴커/디파일러 장기전',
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
          text: '{away} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 드론 생산에 집중하고 있습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.2,
          altText: '{away}, 앞마당 확장! 확장을 가져가려는 모습입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵까지! 메카닉 테크로 가는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리에 머신샵! 메카닉 테크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 유닛 생산이 시작됩니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 첫 메카닉 유닛이 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 넣으면서 테크를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스 채취 시작! 상위 테크 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설 시작합니다. 히드라 테크를 노리는 모습!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 히드라덴이 올라갑니다!',
        ),
      ],
    ),
    // Phase 1: 내정 확장 (lines 17-28)
    ScriptPhase(
      name: 'buildup',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 증설! 본격적인 메카닉 체제입니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -25,
          altText: '{home}, 팩토리 2개째 올라갑니다! 메카닉 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라 생산 시작합니다. 가스 비중을 높이는 모습이구요.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 히드라리스크 뽑기 시작! 수비 준비!',
        ),
        ScriptEvent(
          text: '{home}, 아머리 건설! 골리앗 1기 생산! 대공까지 가능한 조합이구요.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 완성! 럴커 변태가 시작됩니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -20,
          altText: '{away}, 럴커 아스펙트 연구 들어갑니다!',
        ),
        ScriptEvent(
          text: '양측 모두 내정에 집중하는 모습입니다. 아직은 고요하구요.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 사이언스 퍼실리티까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스타포트에서 사이언스 퍼실리티까지! 고급 테크!',
        ),
      ],
    ),
    // Phase 2: 럴커 포진 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'lurker_positioning',
      startLine: 29,
      branches: [
        ScriptBranch(
          id: 'terran_scan_lurker',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 4기 완성! 앞마당 입구에 매복시킵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 스캔! 럴커 위치를 정확히 포착합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 컴샛 스테이션으로 럴커 위치 확인!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 탱크로 럴커 위치를 정밀 포격!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'strategy',
              altText: '{home}, 탱크 포격! 럴커를 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 당했습니다! 수비 라인에 구멍이 생겼는데요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '테란의 정찰이 빛나는 순간이었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_lurker_hold',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 럴커 포진! 입구를 완벽하게 틀어막습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 럴커 매복! 완벽한 위치선정입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 전진하는데... 럴커에 마린 전멸!',
              owner: LogOwner.home,
              homeArmy: -4, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 급히 후퇴! 시즈 탱크를 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
              altText: '{home} 선수 전진을 멈추고 탱크를 앞세웁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 그 사이 세 번째 해처리! 자원이 돌아가기 시작합니다!',
              owner: LogOwner.away,
              awayResource: 25,
            ),
            ScriptEvent(
              text: '럴커 수비가 완벽했습니다. 저그가 시간을 벌었네요.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중후반 전투 (lines 43-60)
    ScriptPhase(
      name: 'mid_late_battle',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 대량 생산! 5팩토리 풀가동입니다!',
          owner: LogOwner.home,
          homeArmy: 8, homeResource: -30, favorsStat: 'macro',
          altText: '{home}, 골리앗 물량이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away}, 하이브 완성! 디파일러 마운드 건설하면서 다크스웜 연구 들어갑니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away} 선수 하이브에서 디파일러 마운드까지! 다크스웜 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 골리앗 조합으로 전진!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away}, 다크스웜 깔아줍니다! 탱크 포격이 무력화됩니다!',
          owner: LogOwner.away,
          favorsStat: 'strategy',
          altText: '{away} 선수 다크스웜! 포격을 완전히 무력화시킵니다!',
        ),
        ScriptEvent(
          text: '{home}, 사이언스 베슬 이레디에이트! 디파일러를 노립니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'strategy',
          altText: '{home} 선수 이레디! 디파일러 잡을 수 있을까요!',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '다크스웜 속에서 치열한 접전이 벌어지고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 61-72)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 61,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 울트라리스크 캐번에서 울트라리스크 등장! 전면전 태세입니다!',
          owner: LogOwner.away,
          awayArmy: 8, awayResource: -30,
          altText: '{away}, 울트라리스크 캐번 완성! 울트라가 나왔습니다!',
        ),
        ScriptEvent(
          text: '{home}, 골리앗 편대로 맞섭니다! 화력전입니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away}, 울트라 저글링 돌진! 탱크 라인 정면 돌파!',
          owner: LogOwner.away,
          homeArmy: -3, awayArmy: -4, favorsStat: 'attack',
          altText: '{away} 선수 울트라가 탱크 라인을 뚫습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗이 울트라를 집중 포화!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -3, favorsStat: 'defense',
          altText: '{home}, 골리앗 화력으로 울트라를 잡아냅니다!',
        ),
      ],
    ),
    // Phase 5: 결전 결과
    ScriptPhase(
      name: 'decisive_result',
      startLine: 73,
      branches: [
        ScriptBranch(
          id: 'terran_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 골리앗 화력이 울트라를 잡아냈습니다! 메카닉 라인 유지!',
              owner: LogOwner.home,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '메카닉 화력이 저그를 밀어냅니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'zerg_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 울트라가 탱크 라인을 완전히 뚫었습니다! 저그 물량이 밀려옵니다!',
              owner: LogOwner.away,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '저그 물량이 메카닉을 압도합니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

// ----------------------------------------------------------
