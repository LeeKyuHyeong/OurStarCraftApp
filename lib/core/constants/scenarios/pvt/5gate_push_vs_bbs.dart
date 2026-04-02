part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs BBS 마린 러시
// ----------------------------------------------------------
const _pvt5gatePushVsBbs = ScenarioScript(
  id: 'pvt_5gate_push_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_1gate_expand'],
  awayBuildIds: ['tvp_bbs'],
  description: '5게이트 타이밍 푸시 vs BBS 마린 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 센터에 배럭! BBS를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 센터 배럭! 올인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어를 올립니다! 드라군을 빠르게 준비하네요!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어 건설! 테크를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 본진 배럭까지! BBS입니다! 가스 없이 마린에 올인합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란 BBS입니다! 프로토스가 초반을 버틸 수 있을지가 관건이죠!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{away} 선수 마린 5기와 SCV를 끌고 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
        ),
      ],
    ),
    // Phase 1: BBS 방어전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 프로토스 앞마당에 벙커를 올리려 합니다!',
          owner: LogOwner.away,
          favorsStat: 'attack',
          altText: '{away}, 벙커 건설 시도! 프로토스 입구를 봉쇄합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 프로브와 질럿으로 벙커 건설을 방해합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          awayArmy: -1,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군이 나오기 시작합니다! 마린보다 사정거리가 깁니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 드라군 합류! 마린을 쏴냅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 드라군에 녹습니다! BBS가 통하지 않습니다!',
          owner: LogOwner.away,
          awayArmy: -2,
          homeArmy: -1,
        ),
        ScriptEvent(
          text: 'BBS를 버텨낸다면 5게이트가 완성되면 프로토스가 압도적으로 유리합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 5게이트 빌드업 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 추가합니다! 3개, 4개, 5개까지!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 게이트웨이를 늘립니다! 5게이트를 향해!',
        ),
        ScriptEvent(
          text: '{away} 선수 BBS가 실패한 후 팩토리를 짓습니다... 늦었습니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔을 올립니다! 질럿 스피드 연구 시작!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아둔 건설! 질럿 다리 업그레이드를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 5게이트에서 드라군과 질럿이 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '5게이트가 가동됩니다! BBS 측은 이 물량을 감당할 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 5게이트 병력이 전진합니다! 드라군과 스피드 질럿!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 5게이트 물량! 드라군 질럿이 밀려갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 1기로 버텨보지만 물량 차이가 너무 큽니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 스피드 질럿이 마린을 덮칩니다! 도망칠 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '5게이트 타이밍! BBS를 쓴 대가가 크게 돌아옵니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트 물량으로 테란을 압도합니다! BBS 완패!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 5게이트 타이밍 완벽! BBS를 완전히 제압합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 BBS로 프로브를 많이 잡았습니다! 프로토스 자원이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -30,
              favorsStat: 'attack',
              altText: '{away}, BBS 피해가 심각합니다! 상대 일꾼이 많이 죽었습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트를 올려도 자원이 없어 유닛을 뽑지 못합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크가 나옵니다! BBS 피해 위에 테크까지!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: 'BBS의 초반 피해가 너무 컸습니다! 5게이트가 가동되지 못합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 초반 피해를 유지하며 승리합니다! BBS 성공!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 BBS로 프로브를 궤멸! 5게이트를 무력화합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
