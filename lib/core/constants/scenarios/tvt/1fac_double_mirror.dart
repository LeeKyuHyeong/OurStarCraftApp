part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 16. 원팩확장 미러 (장기전)
// ----------------------------------------------------------
const _tvt1facDoubleMirror = ScenarioScript(
  id: 'tvt_1fac_double_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1fac_double'],
  awayBuildIds: ['tvt_1fac_double'],
  description: '원팩확장 미러 장기전',
  phases: [
    // Phase 0: 오프닝 (lines 1-13)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 가스를 올립니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 팩토리 건설합니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처 생산! 마인 연구를 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 벌처에 마인! 수비적 세팅!',
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처에 마인 연구! 수비적 오프닝!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 확장! 원팩 확장입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 커맨드센터! 미러 오프닝!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 확장! 같은 빌드!',
        ),
        ScriptEvent(
          text: '양측 원팩 확장! 수비적인 미러, 장기전이 예상됩니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 마인 수비 + 소규모 교전 (lines 14-23)
    ScriptPhase(
      name: 'mine_defense',
      startLine: 14,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마인을 앞마당 주변에 매설합니다! 영역 확보!',
          owner: LogOwner.home,
          homeResource: -10, favorsStat: 'defense',
          altText: '{home}, 마인 매설! 앞마당을 철통 방어!',
        ),
        ScriptEvent(
          text: '{away} 선수도 마인으로 이동 경로를 차단합니다!',
          owner: LogOwner.away,
          awayResource: -10, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 센터를 정찰합니다! 소규모 교전!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'scout',
          altText: '{home}, 벌처 정찰! 상대 타이밍을 확인합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 벌처로 맞정찰! 양측 조심스럽습니다!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'scout',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양측 수비적! 마인밭 사이로 벌처만 소규모 교전합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 트리플 확장 경쟁 - 분기 (lines 24-37)
    ScriptPhase(
      name: 'triple_race',
      startLine: 24,
      branches: [
        // 분기 A: 홈 트리플 먼저
        ScriptBranch(
          id: 'home_triple_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 세 번째 확장을 올립니다! 트리플 커맨드!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 트리플! 자원 우위를 확보하려 합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 트리플이 늦습니다! 마인으로 시간을 벌어봅니다!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 세 번째 확장이 가동됩니다! 자원이 쏟아집니다!',
              owner: LogOwner.home,
              homeResource: 20, favorsStat: 'macro',
              altText: '{home} 선수 트리플 풀가동! 자원 격차!',
            ),
            ScriptEvent(
              text: '트리플을 먼저 잡은 쪽이 물량에서 앞서게 됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 트리플 먼저
        ScriptBranch(
          id: 'away_triple_first',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 세 번째 확장을 올립니다! 빠른 트리플!',
              owner: LogOwner.away,
              awayResource: -30,
              altText: '{away}, 트리플! 자원을 먼저 확보합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 트리플이 늦었습니다! 마인으로 시간을 벌어봅니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 세 번째 확장이 풀가동! 자원 우위를 확보!',
              owner: LogOwner.away,
              awayResource: 20, favorsStat: 'macro',
              altText: '{away} 선수 트리플 풀가동! 자원이 풍부합니다!',
            ),
            ScriptEvent(
              text: '트리플 확장 먼저! 자원 우위가 물량으로 이어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 동시 트리플
        ScriptBranch(
          id: 'simultaneous_triple',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양측 거의 동시에 세 번째 확장을 올립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 트리플 커맨드 건설!',
              owner: LogOwner.home,
              homeResource: -30,
              altText: '{home}, 트리플! 상대도 같은 타이밍!',
            ),
            ScriptEvent(
              text: '{away} 선수도 트리플! 동등한 자원 경쟁!',
              owner: LogOwner.away,
              awayResource: -30,
            ),
            ScriptEvent(
              text: '동시 트리플! 자원은 동등, 이후 교전 실력이 관건!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 탱크 골리앗 대량 생산 (lines 38-51)
    ScriptPhase(
      name: 'buildup',
      startLine: 38,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 시즈 탱크 대량 생산! 시즈 모드 연구 완료!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 탱크가 쏟아집니다! 시즈 모드!',
        ),
        ScriptEvent(
          text: '{away} 선수도 탱크 대량 생산! 시즈 모드 연구!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설! 공방 업그레이드를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 아머리! 공방업으로 화력을 높입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 아머리 건설! 골리앗 생산 준비!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 드랍십을 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스타포트! 드랍십으로 견제를 노린다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스타포트! 드랍십 대비까지 갖춥니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크, 골리앗, 드랍십! 후반 집중력 싸움이 다가옵니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 드랍 견제 - 분기 (lines 52-67)
    ScriptPhase(
      name: 'drop_harass',
      startLine: 52,
      branches: [
        // 분기 A: 홈 드랍 견제 성공
        ScriptBranch(
          id: 'home_drop_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드랍십 출격! 상대 확장기지에 탱크를 투하합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'strategy',
              altText: '{home} 선수 드랍! 상대 확장기지 SCV가 위험!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장기지 SCV 피해! 골리앗을 돌리지만 이미 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home}, 드랍 성공! 자원 격차가 벌어집니다!',
              owner: LogOwner.home,
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 대성공! SCV 대량 피해!',
            ),
            ScriptEvent(
              text: '확장기지 타격! 자원 격차가 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 드랍 견제 성공
        ScriptBranch(
          id: 'away_drop_harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드랍십으로 상대 본진을 기습합니다! 탱크 투하!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'strategy',
              altText: '{away} 선수 본진 드랍! 생산시설이 위협받습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 피해! 팩토리가 타격을 받습니다!',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 본진 기습 성공! 생산력에 타격!',
              owner: LogOwner.away,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍 성공! 생산시설 피해!',
            ),
            ScriptEvent(
              text: '본진 견제 성공! 생산력 차이가 벌어집니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 68-80)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 68,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크, 골리앗, 드랍십 총동원! 최종 결전!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 전 병력 결집! 마지막 집중력 싸움!',
        ),
        ScriptEvent(
          text: '{away} 선수도 전 병력 배치! 정면 교전 준비!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면 충돌! 집중력 싸움입니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 시즈 포격 집중! 상대 탱크가 터집니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -5, favorsStat: 'attack',
          altText: '{home} 선수 시즈 화력! 상대 병력이 무너집니다!',
        ),
        ScriptEvent(
          text: '{away}, 골리앗 집중 포화로 반격합니다!',
          owner: LogOwner.away,
          homeArmy: -5, awayArmy: -5, favorsStat: 'defense',
          altText: '{away} 선수 골리앗 반격! 마지막까지 맞섭니다!',
        ),
      ],
    ),
    // Phase 6: 결전 판정 - 분기 (lines 81+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 81,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍 견제 성공! 상대 생산시설을 타격합니다!',
              altText: '{home} 선수 탱크 라인 집중력 싸움에서 한 수 위입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십 기습! 상대 팩토리를 타격합니다!',
              altText: '{away} 선수 정면 교전에서 탱크 화력이 앞섭니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
