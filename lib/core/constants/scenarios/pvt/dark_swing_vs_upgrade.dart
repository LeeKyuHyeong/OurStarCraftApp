part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs 업그레이드형 테란 - 디텍 부재 착취
// ----------------------------------------------------------
const _pvtDarkSwingVsUpgrade = ScenarioScript(
  id: 'pvt_dark_swing_vs_upgrade',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_trans_upgrade', 'tvp_1fac_gosu'],
  description: '다크 스윙 vs 더블 업그레이드 테란',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
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
          text: '{away} 선수 배럭 건설 후 앞마당 커맨드센터까지 올립니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 더블! 자원을 빠르게 확보하려는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 이어서 아둔!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크를 노리고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이를 올립니다! 업그레이드 시작!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '더블 업그레이드 빌드! 하지만 스캔 에너지 관리가 핵심!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 템플러 아카이브! 다크 준비 완료!',
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 12-20)
    ScriptPhase(
      name: 'dark_deploy',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 테란 앞마당으로!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 2기! 업그레이드 테란에 잠입합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 메딕 편성 중! 업그레이드가 거의 완료!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 다크가 은밀하게 접근합니다! 앞마당을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크가 앞마당 미네랄 라인으로!',
        ),
        ScriptEvent(
          text: '더블 빌드라 자원은 많지만 스캔을 아껴야 합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 디텍 공방 (lines 22-28)
    ScriptPhase(
      name: 'detection_fight',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크가 앞마당에 도착합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 스캔을 쓸까 말까 고민합니다! 에너지가 아까워요!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 스캔 에너지가 부족합니다! 터렛을 올려야 할까요?',
        ),
        ScriptEvent(
          text: '{home}, 다크 한 기가 앞마당, 한 기가 본진을 노립니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크를 분산 투입! 양쪽을 동시에!',
        ),
        ScriptEvent(
          text: '스캔 한 번으로는 두 곳을 동시에 볼 수 없습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 다크 대성공 - 스캔 부족
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크가 앞마당 SCV를 베기 시작합니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 다크가 일꾼을 쓸어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스캔을 쓰지만 본진에도 다크가 있습니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 양쪽에서 다크가 SCV를 베어냅니다! 막을 수 없어요!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
              altText: '{home} 선수 다크 분산 투입 대성공! 양쪽 일꾼이 무너집니다!',
            ),
            ScriptEvent(
              text: '업그레이드가 완료돼도 일꾼이 없으면 의미가 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 일꾼을 전멸시킵니다! 테란이 GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 스윙 완벽! 업그레이드 테란의 약점을 찔렀습니다!',
            ),
          ],
        ),
        // 분기 B: 스캔 + 터렛으로 방어 → 업그레이드 완료 역전
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 터렛을 2개 세웁니다! 다크가 보여요!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 터렛 배치! 다크를 포착합니다!',
            ),
            ScriptEvent(
              text: '{away}, 마린이 다크를 집중 사격! 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 막혔습니다! 투자한 테크가 낭비!',
              owner: LogOwner.home,
              homeResource: -15,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 2-2 업그레이드 완료! 마린 메딕이 강화됩니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -10,
              altText: '{away}, 더블 업그레이드 마린! 화력이 크게 올랐습니다!',
            ),
            ScriptEvent(
              text: '업그레이드 마린 메딕의 화력! 프로토스가 막기 어렵습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 업그레이드 마린으로 밀어냅니다! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 2-2 업그레이드 화력! 다크를 막고 역전!',
            ),
          ],
        ),
      ],
    ),
  ],
);
