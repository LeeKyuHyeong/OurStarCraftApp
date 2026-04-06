part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 스윙 vs 골리앗 대공형 - DT 타이밍 vs 골리앗 빌드업
// ----------------------------------------------------------
const _pvtDarkSwingVsAntiCarrier = ScenarioScript(
  id: 'pvt_dark_swing_vs_anti_carrier',
  matchup: 'PvT',
  homeBuildIds: ['pvt_dark_swing'],
  awayBuildIds: ['tvp_trans_anti_carrier', 'tvp_anti_carrier'],
  description: '다크 스윙 vs 골리앗 대공형 테란',
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
          text: '{away} 선수 배럭 건설 후 팩토리를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어에 아둔까지 건설합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아둔! 다크 테크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아머리를 올립니다! 골리앗을 준비하는 빌드!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아머리! 대공 준비를 하고 있습니다!',
        ),
        ScriptEvent(
          text: '골리앗 빌드는 대공에 특화! 하지만 다크에 대한 대비는?',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설!',
          owner: LogOwner.home,
          homeResource: -20,
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
          text: '{home} 선수 다크 템플러 2기 생산! 테란 진영으로!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          altText: '{home}, 다크 출발! 골리앗 빌드를 방해하러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 1기 생산! 아직 물량이 적어요!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home}, 다크가 테란 본진에 접근합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크가 은밀하게 이동합니다!',
        ),
        ScriptEvent(
          text: '골리앗은 대공 유닛! 보이지 않는 지상 유닛은 별개!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 마린도 추가 생산합니다! 벙커도 세워요!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
      ],
    ),
    // Phase 2: 다크 공방 (lines 22-28)
    ScriptPhase(
      name: 'dark_fight',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 다크가 미네랄 라인에 도착합니다!',
          owner: LogOwner.home,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 디텍 준비를 했을까요? 스캔 에너지가 관건!',
          owner: LogOwner.system,
          altText: '골리앗에 집중한 테란! 디텍을 놓쳤을 수 있습니다!',
        ),
        ScriptEvent(
          text: '{home}, 다크가 잠입합니다! 골리앗으로는 안 보여요!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 다크가 미네랄 라인으로!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗을 추가 생산합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30-40)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        // 분기 A: 다크 성공 → 골리앗 빌드업 차단
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 다크가 SCV를 베기 시작합니다! 디텍이 없어요!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 다크 성공! 골리앗에만 집중해서 디텍이 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗으로 막으려 하지만 다크가 안 보입니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 다크가 SCV를 대량 학살합니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home} 선수 다크 대활약! 테란 일꾼이 무너져요!',
            ),
            ScriptEvent(
              text: '대공에 특화했지만 보이지 않는 지상 유닛에 무력!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 테란을 초토화합니다! GG!',
              owner: LogOwner.home,
              homeArmy: 20,
              awayArmy: -15,
              decisive: true,
              altText: '{home}, 다크 스윙이 골리앗 빌드를 완전히 무너뜨렸습니다!',
            ),
          ],
        ),
        // 분기 B: 스캔으로 방어 → 골리앗 물량 역전
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 스캔! 다크를 포착합니다!',
              owner: LogOwner.away,
              favorsStat: 'scout',
              altText: '{away}, 컴샛으로 다크를 찾아냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 마린과 골리앗이 다크를 집중 사격! 격파!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home} 선수 다크가 잡혔습니다! 골리앗 물량을 감당해야 해요!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗을 다수 편성합니다! 지상 화력도 강합니다!',
              owner: LogOwner.away,
              awayArmy: 6,
              awayResource: -15,
              altText: '{away}, 골리앗 편대! 공중이든 지상이든 대응 가능!',
            ),
            ScriptEvent(
              text: '골리앗의 지상 화력도 무시 못 합니다! 프로토스가 위기!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 편대로 밀어냅니다! 프로토스가 GG!',
              owner: LogOwner.away,
              awayArmy: 20,
              homeArmy: -15,
              decisive: true,
              altText: '{away}, 골리앗 화력! 다크를 막고 역전합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
