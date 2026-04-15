part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 프록시 게이트 질럿 러시 vs 바이오 메카닉 테란
// ----------------------------------------------------------
const _pvtProxyGateVsBioMech = ScenarioScript(
  id: 'pvt_proxy_gate_vs_bio_mech',
  matchup: 'PvT',
  homeBuildIds: ['pvt_proxy_gate'],
  awayBuildIds: ['tvp_trans_bio_mech', 'tvp_bar_double'],
  description: '프록시 게이트 질럿 러시 vs 바이오 메카닉 수비형',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 프로브를 일찍 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다. 안정적인 시작!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 상대 근처에 게이트웨이를 숨겨서 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 숨겨진 게이트웨이! 들키지 않았습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 올리고 팩토리를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 가스 팩토리! 밸런스 있는 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 전진 건물이라서 빨리 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '전진 게이트웨이가 발각되지 않았다면 큰일입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 질럿 돌진 (lines 12-19)
    ScriptPhase(
      name: 'zealot_rush',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿 2기가 테란 본진을 향합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
          favorsStat: 'attack',
          altText: '{home}, 질럿이 달려갑니다! 마린이 부족할 때!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린 2기가 입구를 지키고 있습니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 질럿이 마린을 밀어내면서 진입합니다!',
          owner: LogOwner.home,
          awayArmy: -1,
          homeArmy: -1,
          favorsStat: 'control',
          altText: '{home} 선수 질럿이 마린 한 기를 잡고 돌파!',
        ),
        ScriptEvent(
          text: '{away} 선수 벙커를 짓습니다! 마린을 넣어야 합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '벙커가 올라오기 전에 질럿이 피해를 줄 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 공방 (lines 22-28)
    ScriptPhase(
      name: 'bunker_defense',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿이 SCV를 잡으면서 피해를 줍니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 마린이 나오면서 벙커에 투입합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -5,
          altText: '{away}, 마린이 벙커로! 화력이 집중됩니다!',
        ),
        ScriptEvent(
          text: '{home}, 질럿을 추가합니다! 전진 건물에서 바로 합류!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '질럿이 벙커를 깰 수 있을까, 마린이 먼저 모일까!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 질럿이 벙커 전에 치명타
        ScriptBranch(
          id: 'home_wins',
          conditionStat: 'attack',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 질럿이 벙커 짓는 SCV를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 벙커가 완성되지 못합니다! 상대 병력이 본진을 휩씁니다!',
              owner: LogOwner.away,
              awayResource: -25,
              altText: '{away}, 벙커 건설 실패! 질럿에게 SCV를 잡혀냅니다!',
            ),
            ScriptEvent(
              text: '{home}, 질럿이 팩토리까지 공격합니다!',
              owner: LogOwner.home,
              awayArmy: -3,
              awayResource: -15,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '전진 게이트웨이 대성공! 테란 본진이 초토화!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 커맨드센터를 부숩니다!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 전진 질럿! 테란 복합 편성이 구성되기도 전에 끝!',
            ),
          ],
        ),
        // 분기 B: 벙커+마린 방어 → 탱크 골리앗 반격
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 완성! 마린 화력으로 질럿을 막습니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              favorsStat: 'defense',
              altText: '{away}, 벙커에 마린 가득! 상대 병력이 접근 못 합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 손실됩니다! 벙커를 깨지 못해요!',
              owner: LogOwner.home,
              homeArmy: -4,
            ),
            ScriptEvent(
              text: '{away}, 벌처와 탱크가 나옵니다! 복합 편성이 갖춰지고 있어요!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -15,
              altText: '{away} 선수 탱크 벌처! 질럿으로는 상대 불가!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗까지 합류! 풀 편성으로 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -5,
            ),
            ScriptEvent(
              text: '전진 건물에 투자한 자원이 전부 날아갔습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 마린 탱크 골리앗! 프로토스가',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 복합 편성의 화력! 프로토스를 압도합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
