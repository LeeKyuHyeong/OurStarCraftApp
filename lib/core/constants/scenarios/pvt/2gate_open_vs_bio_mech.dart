part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 투게이트 질럿 오프닝 vs 바이오 메카닉
// ----------------------------------------------------------
const _pvt2gateOpenVsBioMech = ScenarioScript(
  id: 'pvt_2gate_open_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_2gate_open', 'pvt_2gate_zealot'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_bar_double'],
  description: '투게이트 질럿→드라군 vs 바이오 메카닉 복합 편성',
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
          text: '{away} 선수 배럭과 가스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 배럭에 가스! 메카닉 전환을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 두 번째 게이트웨이! 질럿을 빠르게 뽑겠다는 겁니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 게이트웨이가 두 개! 질럿 생산에 집중합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 올립니다! 바이오닉과 메카닉을 섞을 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '프로토스 질럿 물량 vs 테란 복합 편성! 전형적인 PvT입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 센터로 나갑니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
        ),
      ],
    ),
    // Phase 1: 질럿 견제 vs 바이오닉 방어 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿이 테란 앞마당을 견제합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 질럿 견제! SCV를 압박합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 벌처로 방어합니다! 복합 편성의 장점이죠!',
          owner: LogOwner.away,
          awayArmy: 2,
          homeArmy: -1,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어를 올립니다! 드라군이 필요합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어 건설! 드라군 전환 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미도 올립니다! 마린 메딕을 준비합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '테란이 바이오닉과 메카닉을 섞으면 다양한 대응이 가능합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 드라군 vs 마린+탱크 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드라군이 생산됩니다! 넥서스도 올립니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크와 마린을 함께 배치합니다! 골리앗도 섞습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
          altText: '{away}, 마린 탱크 골리앗! 복합 편성 완성!',
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 물량을 모으고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 커맨드센터를 건설합니다! 자원을 확보합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 복합 편성으로 안전하게 운영합니다!',
        ),
        ScriptEvent(
          text: '양쪽 확장을 마쳤습니다! 본격적인 교전이 다가옵니다!',
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
              text: '{home} 선수 드라군이 골리앗을 먼저 잡아냅니다! 사정거리 싸움!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 드라군 컨트롤! 골리앗을 집중 공격합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 포격이 상대 병력에 맞지 않습니다! 분산 컨트롤이 좋습니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크 라인을 돌파합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '프로토스 드라군이 복합 편성을 뚫었습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군 대군으로 밀어냅니다! 테란이 막을 수 없습니다!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 드라군 물량 압도! 복합 편성을 분쇄합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크가 시즈 포격! 상대 병력이 모여 있는 곳에 직격합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 탱크 포격이 드라군을 직격합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 크게 줄었습니다! 탱크 포격에 녹았습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away} 선수 마린과 골리앗이 전진합니다! 복합 편성의 힘!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '복합 편성의 다양한 유닛이 프로토스를 압박합니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크 골리앗 복합 편성으로 프로토스를 제압합니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 복합 편성의 완성! 프로토스를 밀어냅니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
