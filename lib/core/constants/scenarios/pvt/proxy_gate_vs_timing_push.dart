part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 타이밍 푸시 테란
// ----------------------------------------------------------
const _pvtProxyGateVsTimingPush = ScenarioScript(
  id: 'pvt_proxy_gate_vs_timing_push',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_timing_push', 'tvp_fake_double', 'tvp_1fac_drop'],
  description: '프록시 게이트 질럿 러시 vs 타이밍 푸시',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 보냅니다! 위치를 잡고 있어요!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다. 가스도 올려요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 상대 근처에 게이트웨이를 숨겨서 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 게이트웨이를 숨겨서 짓습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 머신샵 부착!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리 머신샵! 타이밍 공격을 준비합니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 공격적인 성향! 질럿이 먼저 도착할 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 질럿 공격 (lines 12-19)
    ScriptPhase(
      name: 'zealot_attack',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 2기 생산! 테란 진영으로 질주!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -10,
          altText: '{home}, 질럿 출발! 빠른 타이밍입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 3기로 입구를 막고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 마린을 쫓으면서 본진에 진입합니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          homeArmy: -1,
          favorsStat: 'attack',
          altText: '{home} 선수 질럿이 마린 한 기를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 SCV를 끌어서 질럿을 둘러쌉니다! 시간을 벌어야 합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '질럿 vs 마린+SCV! 어떤 쪽이 먼저 밀리느냐!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-28)
    ScriptPhase(
      name: 'followup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿을 추가 생산합니다! 압박을 멈추지 않습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처가 나오기 시작합니다! 질럿 상대로 기동력!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          altText: '{away}, 벌처 등장! 질럿에 강한 유닛입니다!',
        ),
        ScriptEvent(
          text: '{home}, 질럿이 SCV를 몇 기 더 잡아냅니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '질럿의 피해가 누적되고 있지만 테란도 타이밍이 늦어지고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 질럿이 타이밍 전에 테란 괴멸
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 SCV를 전멸시킵니다! 일꾼이 남지 않았습니다!',
              owner: LogOwner.home,
              awayResource: -30,
              favorsStat: 'attack',
              altText: '{home}, 질럿 난무! 질럿이 SCV를 녹여냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 타이밍 공격을 준비할 수 없습니다! 자원이 끊겼어요!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '전진 게이트웨이가 타이밍 푸시를 사전에 차단했습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 건물까지 파괴합니다! 테란이 GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 완벽한 질럿 러시! 타이밍 공격이 시작도 못 합니다!',
            ),
          ],
        ),
        // 분기 B: 테란이 질럿을 막고 타이밍 푸시
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벌처가 질럿을 제압합니다! 기동력 차이!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'control',
              altText: '{away}, 벌처 마이크로! 상대 병력이 쫓아가지 못합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿 러시가 실패합니다! 남은 병력이 없어요!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '{away}, 시즈 탱크와 마린을 모아서 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 8,
              awayResource: -15,
              altText: '{away} 선수 타이밍 푸시! 마린 탱크 편대가 출발!',
            ),
            ScriptEvent(
              text: '전진 건물에 자원을 소모한 프로토스에 남은 게 없습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 탱크 시즈! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 타이밍 푸시가 프로토스를 짓밟습니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
