part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs 바이오 메카닉
// ----------------------------------------------------------
const _pvt5gatePushVsBioMech = ScenarioScript(
  id: 'pvt_5gate_push_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_1gate_expand'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_bar_double'],
  description: '5게이트 드라군+질럿 vs 바이오 메카닉 복합 편성',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이와 사이버네틱스 코어를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭과 팩토리를 동시에 준비합니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭에 팩토리까지! 복합 편성을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 생산하면서 게이트웨이를 추가합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          altText: '{home}, 드라군 생산! 게이트웨이를 늘립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미를 올립니다! 메딕과 스팀팩을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '프로토스 5게이트 vs 테란 바이오 메카닉! 물량 vs 다양성의 대결!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 3개 완성!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 5게이트 빌드업 vs 복합 편성 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 질럿 스피드를 연구합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 아둔! 스피드 질럿으로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕에 탱크를 섞습니다! 골리앗도 생산!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 5게이트 완성! 드라군과 질럿을 동시에 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          altText: '{home}, 5게이트 가동! 병력이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 프로토스 확장을 정찰합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '5게이트 물량이 모이고 있습니다! 바이오 메카닉이 대응할 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 물량 집결 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스피드 질럿 연구 완료! 드라군과 함께 전진 준비!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 탱크 골리앗! 완벽한 복합 편성입니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 바이오 메카닉 풀편성! 다양한 유닛이 갖춰졌습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 전군 전진합니다! 5게이트 타이밍!',
          owner: LogOwner.home,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 올리면서 방어 준비합니다!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '프로토스 물량이 쏟아집니다! 바이오 메카닉이 막아낼 수 있을까요?',
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
              text: '{home} 선수 스피드 질럿이 마린 메딕 라인을 덮칩니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 스피드 질럿! 마린 사이로 파고듭니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 메딕이 녹습니다! 마린 생존력이 급감합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크를 처리합니다! 골리앗도 밀립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '5게이트 물량이 바이오 메카닉을 압도합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5게이트 대군으로 테란을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 5게이트 물량! 바이오 메카닉을 분쇄합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 포격이 드라군 무리에 명중합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -5,
              favorsStat: 'attack',
              altText: '{away}, 탱크가 직격! 상대 병력이 뭉쳐서 피해가 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 마린에 막힙니다! 스팀팩 화력에 밀립니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 남은 드라군을 처리합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '바이오 메카닉의 다양한 유닛 조합이 5게이트를 막아냈습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 복합 편성으로 프로토스를 제압합니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 바이오 메카닉 완성! 5게이트 푸시를 막고 역공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
