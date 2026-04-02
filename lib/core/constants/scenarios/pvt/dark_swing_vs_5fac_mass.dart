part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs 5팩토리 물량 - 초반 디텍 부재 착취
// ----------------------------------------------------------
const _pvtDarkSwingVs5facMass = ScenarioScript(
  id: 'pvt_dark_swing_vs_5fac_mass',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_trans_5fac_mass'],
  description: '다크 스윙 vs 5팩토리 물량 테란',
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
          text: '{away} 선수 배럭 건설 후 빠르게 팩토리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리! 5팩을 향한 첫 단계!',
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어에 아둔까지!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔 건설! 다크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리를 추가합니다! 2팩토리가 됩니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '5팩 빌드는 팩토리에 자원을 집중! 디텍 투자가 늦어질 수 있어요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 다크 투입 (lines 12-19)
    ScriptPhase(
      name: 'dark_deploy',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설! 다크를 뽑습니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 템플러 아카이브! 다크가 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 3개째! 탱크와 골리앗 생산에 집중!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 다크 템플러 2기 생산! 5팩 기지로!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 2기! 팩토리에 집중한 테란을 노립니다!',
        ),
        ScriptEvent(
          text: '5팩에 투자하느라 아카데미가 없을 수 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 다크 잠입 (lines 22-28)
    ScriptPhase(
      name: 'dark_infiltration',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크가 테란 본진에 접근합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home}, 다크가 잠입합니다! 팩토리만 가득한 기지!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처와 탱크만 있습니다! 디텍 유닛이 안 보여요!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 다크가 SCV 라인에 도착합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '팩토리 투자로 디텍이 전혀 없다면 대참사!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 디텍 없음 → 다크 대활약
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'harass',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크가 SCV를 베기 시작합니다! 디텍이 없습니다!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'harass',
              altText: '{home}, 다크 대활약! SCV가 한 기씩 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 벌처가 다크를 쫓지만 보이지 않아요!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 다크 한 기가 팩토리도 공격합니다!',
              owner: LogOwner.home,
              awayResource: -20,
              awayArmy: -3,
              favorsStat: 'harass',
              altText: '{home} 선수 다크가 팩토리까지 부수기 시작합니다!',
            ),
            ScriptEvent(
              text: '5팩토리 빌드의 치명적 약점! 보이지 않는 유닛 앞에 무력!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 SCV를 전멸시킵니다! 5팩이고 뭐고 끝!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 스윙이 5팩을 완전히 무너뜨렸습니다!',
            ),
          ],
        ),
        // 분기 B: 엔지니어링 베이 터렛으로 방어 → 5팩 물량 역전
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 엔지니어링 베이가 있었습니다! 터렛을 세웁니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 터렛! 다크가 보입니다!',
            ),
            ScriptEvent(
              text: '{away}, 마린이 다크를 잡아냅니다! 격파!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 잡혔습니다! 5팩 물량을 감당해야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 5팩토리 가동! 탱크 골리앗이 쏟아져 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 8,
              awayResource: -20,
              altText: '{away}, 5팩토리 풀 가동! 물량이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '5팩 물량 앞에 프로토스가 버틸 수 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 골리앗 물량! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 5팩토리 화력으로 프로토스를 짓밟습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
