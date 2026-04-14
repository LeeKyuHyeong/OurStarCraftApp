part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5게이트 푸시 vs 업그레이드 운영
// ----------------------------------------------------------
const _pvt5gatePushVsUpgrade = ScenarioScript(
  id: 'pvt_5gate_push_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_trans_5gate_push', 'pvt_1gate_expand'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '5게이트 타이밍 푸시 vs 업그레이드 운영 — 타이밍 대 후반 파워',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭과 엔지니어링 베이를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 엔지니어링 베이! 업그레이드 운영을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어를 건설합니다! 드라군 준비!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 드라군 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 공격력 업그레이드 시작! 앞마당 커맨드센터도 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '테란이 업그레이드에 투자합니다! 프로토스는 게이트웨이 물량으로 치기 전에 깨야 합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군을 뽑으면서 게이트웨이를 추가합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 5게이트 빌드업 vs 업그레이드 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔을 올립니다! 질럿 스피드 연구!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 1차 공격력 업그레이드 완료! 방어력도 연구합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'macro',
          altText: '{away}, 1업 완료! 2차 업그레이드까지 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 게이트웨이 네 개, 다섯 개까지 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 게이트웨이 다섯 개 완성! 이제 물량을 모읍니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아카데미를 건설합니다! 메딕과 스팀팩 준비!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '업그레이드가 2단계로 올라가기 전에 게이트웨이가 다 완성됐습니다! 시간 싸움!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 타이밍 윈도우 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 다섯 개에서 드라군과 스피드 질럿이 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 편성을 갖췄습니다! 업그레이드 마린 화력!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          altText: '{away}, 업그레이드 마린 메딕! 화력이 다릅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 전군 전진! 업그레이드 완성 전에 밀어야 합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 탱크도 배치합니다! 수비 라인이 형성됩니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '게이트웨이 물량 타이밍 윈도우! 업그레이드 완성 전이 마지막 기회입니다!',
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
              text: '{home} 선수 스피드 질럿이 마린 라인에 돌진합니다! 메딕을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 질럿이 메딕을 집중 공격! 마린 치료가 끊깁니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 메딕이 녹습니다! 마린 치료 없이 버텨야 합니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{home} 선수 드라군이 탱크를 처리합니다! 게이트웨이 다섯 개의 물량!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '타이밍이 딱 맞았습니다! 업그레이드 완성 전에 뚫었습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 게이트웨이 물량으로 테란을 제압합니다! 타이밍 승리!',
              owner: LogOwner.home,
              homeArmy: 25,
              awayArmy: -15,
              decisive: true,
              altText: '{home} 선수 업그레이드 완성 전에 끝냅니다! 게이트웨이 물량 타이밍!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          events: [
            ScriptEvent(
              text: '{away} 선수 2차 업그레이드 마린이 드라군을 녹입니다! 화력이 압도적!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'macro',
              altText: '{away}, 업그레이드 차이! 마린 화력이 드라군을 녹입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿도 스팀팩 마린에 접근하기 어렵습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 메딕이 마린을 치료합니다! 게이트웨이 물량에도 안 밀립니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '업그레이드의 힘! 게이트웨이 물량 타이밍이 늦었습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 마린 메딕으로 프로토스를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 25,
              homeArmy: -15,
              decisive: true,
              altText: '{away} 선수 업그레이드 완성! 게이트웨이 물량도 감당합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
