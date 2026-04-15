part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs BBS 마린 러시 - DT가 BBS 이후 역전 노림
// ----------------------------------------------------------
const _pvtDarkSwingVsBbs = ScenarioScript(
  id: 'pvt_dark_swing_vs_bbs',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_bbs'],
  description: '다크 스윙 vs BBS 마린 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭을 두 개 동시에 올립니다! 마린을 빠르게 뽑겠다는 거군요!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 배럭이 두 개! 마린 올인을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 다크 테크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린을 모으면서 SCV와 함께 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '마린 러시 타이밍! 다크 템플러가 나오기 전에 끝낼 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: BBS 공격 + 방어 (lines 12-20)
    ScriptPhase(
      name: 'bbs_attack',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 마린 5기에 SCV 2기! 프로토스 앞으로!',
          owner: LogOwner.away,
          awayArmy: 2,
          favorsStat: 'attack',
          altText: '{away}, 마린과 SCV가 돌격합니다! 전진!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 1기와 프로브로 막습니다! 아슬아슬!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home}, 드라군이 나옵니다! 마린을 상대합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home} 선수 드라군 합류! 마린 러시를 막아내려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린이 밀어붙입니다! 프로브 피해를 줍니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '프로토스가 마린 러시를 막아내면 다크가 나올 시간!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 다크 등장 (lines 22-28)
    ScriptPhase(
      name: 'dark_arrives',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 아둔에 이어 템플러 아카이브가 올라갑니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 마린으로 압박을 이어갑니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -5,
          altText: '{away}, 마린 물량으로 밀어냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 다크 템플러 생산 시작! 역전의 카드!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 템플러가 나옵니다! 테란에 디텍이 있을까요?',
        ),
        ScriptEvent(
          text: '배럭만 두 개라 가스가 없어서 디텍이 없을 확률이 높습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 다크가 BBS를 역전
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크 템플러가 테란 본진에 잠입합니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home}, 다크가 본진으로! 테란에 디텍이 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스캔이 없습니다! 아카데미도 없어요! 디텍 전무!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 다크가 SCV를 베기 시작합니다! 막을 수 없어요!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home} 선수 다크 난무! 다크가 SCV를 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 마린을 빼서 본진으로 돌리지만 보이지 않습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '배럭만 올린 약점! 가스가 없어서 디텍이 전혀 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 다크 템플러가 SCV를 전멸시킵니다! 마린 러시를 역전했습니다!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 역전! 테란이 디텍 없이 무너집니다!',
            ),
          ],
        ),
        // 분기 B: BBS가 다크 전에 프로토스 괴멸
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 마린이 프로토스 본진을 짓밟습니다! 프로브 피해 심각!',
              owner: LogOwner.away,
              homeResource: -30,
              favorsStat: 'attack',
              altText: '{away}, 마린 러시! 상대 일꾼이 전멸합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 나올 시간이 없습니다! 템플러 아카이브가 아직!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 마린이 게이트웨이를 공격합니다!',
              owner: LogOwner.away,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '마린 러시 타이밍이 다크보다 빠릅니다! 프로토스가 견딜 수 없어요!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 러시 성공! 프로토스가',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 다크 나오기 전에 끝! 마린 러시 타이밍 완승!',
            ),
          ],
        ),
      ],
    ),
  ],
);
