part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 8. 리버 셔틀 vs BBS 대응
// ----------------------------------------------------------
const _pvtReaverVsBbs = ScenarioScript(
  id: 'pvt_reaver_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_reaver_shuttle', 'pvt_proxy_dark',
                 'pvt_trans_reaver_push'],
  awayBuildIds: ['tvp_bbs'],
  description: '리버 셔틀 vs BBS 타이밍',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 센터로 SCV를 보냅니다! 8배럭 오프닝!',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 로보틱스를 노리는 건가요?',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 사이버네틱스 코어가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 센터 배럭에서 마린 생산! 본진 배럭도 돌아갑니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 마린이 빠르게 쌓이고 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 로보틱스 건설! 서포트 베이도 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 로보틱스에 서포트 베이 건설! 셔틀 준비!',
        ),
        ScriptEvent(
          text: '{away}, SCV까지 끌고 프로토스 앞마당으로 진격합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 SCV 동원! BBS 돌진!',
        ),
      ],
    ),
    // Phase 1: BBS 공격 도착 (lines 15-22)
    ScriptPhase(
      name: 'bbs_attack',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 프로토스 앞마당에 벙커를 올리려 합니다!',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'attack',
          altText: '{away} 선수 벙커링 시도! 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿과 드라군으로 방어합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 질럿 드라군 방어! 벙커를 막으려 합니다!',
        ),
        ScriptEvent(
          text: 'BBS가 도착했습니다! 프로토스가 막아낼 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: BBS 결과 - 분기 (lines 23-36)
    ScriptPhase(
      name: 'bbs_result',
      startLine: 23,
      branches: [
        // 분기 A: BBS 수비 성공 → 리버 투입
        ScriptBranch(
          id: 'defense_success_reaver',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{home}, 프로브까지 동원해서 벙커 건설을 저지합니다!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 프로브 컨트롤! SCV를 끊어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커가 안 올라갑니다! 마린만으로는 부족해요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 리버 생산 완료! 셔틀에 탑승합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -20,
              altText: '{home}, 리버가 나왔습니다! 셔틀 리버 출격!',
            ),
            ScriptEvent(
              text: '{home}, 셔틀 리버가 테란 본진으로! 스캐럽 투하!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'harass',
              altText: '{home} 선수 스캐럽이 명중! 테란 일꾼을 날려버립니다!',
            ),
            ScriptEvent(
              text: 'BBS를 막고 리버 역습! 프로토스가 판을 뒤집습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: BBS 성공
        ScriptBranch(
          id: 'bbs_breakthrough',
          baseProbability: 0.5,
          events: [
            ScriptEvent(
              text: '{away}, 벙커 완성! 마린이 들어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'attack',
              altText: '{away} 선수 벙커링 성공! 프로토스 앞마당이 위험!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿으로 벙커를 부수려 하지만 마린 화력이 강합니다!',
              owner: LogOwner.home,
              homeArmy: -4, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 추가 마린 합류! 프로브까지 노립니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'attack',
              altText: '{away} 선수 마린이 프로브를 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 리버가 아직 안 나왔습니다! 테크가 늦었어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: 'BBS가 프로토스를 무너뜨리고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

