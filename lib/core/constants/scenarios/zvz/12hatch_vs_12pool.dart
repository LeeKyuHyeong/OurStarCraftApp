part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12앞마당 vs 12풀 (확장 vs 스탠다드)
// ----------------------------------------------------------
const _zvz12hatchVs12pool = ScenarioScript(
  id: 'zvz_12hatch_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch'],
  awayBuildIds: ['zvz_12pool'],
  description: '12앞마당 확장 vs 12풀 스탠다드',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 12드론에 앞마당 해처리를 올립니다!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 12앞마당! 확장을 먼저 가져갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 스포닝풀! 스탠다드한 빌드!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 12풀! 저글링으로 앞마당을 견제할 수 있습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 뒤늦게 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 생산! 발업 연구 시작!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링에 발업! 앞마당을 노릴 수 있습니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 압박 (lines 15-24)
    ScriptPhase(
      name: 'ling_pressure',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 발업 저글링이 상대 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 저글링 돌진! 12앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 노발업 저글링과 드론, 성큰으로 수비합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -15, favorsStat: 'defense',
          altText: '{home}, 성큰을 올리면서 수비합니다!',
        ),
        ScriptEvent(
          text: '12풀 저글링이 12앞마당을 괴롭힐 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 25-38)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 25,
      branches: [
        // 분기 A: 저글링이 드론 피해를 줌
        ScriptBranch(
          id: 'ling_damages',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 드론을 물어뜯습니다! 성큰 완성 전!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 앞마당 드론이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 드론 피해가 심각합니다!',
              owner: LogOwner.home,
              homeResource: -10,
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링 합류! 앞마당 해처리까지 위협!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -10, homeArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '앞마당이 큰 피해를 입었습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 수비 성공
        ScriptBranch(
          id: 'defense_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 성큰이 완성됩니다! 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -1, favorsStat: 'defense',
              altText: '{home} 선수 성큰 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 성큰에 막힙니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 드론이 안정됩니다! 확장 이점!',
              owner: LogOwner.home,
              homeResource: 15,
              altText: '{home} 선수 앞마당 안정! 자원 우위 확보!',
            ),
            ScriptEvent(
              text: '수비 성공! 앞마당이 살았습니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 39-52)
    ScriptPhase(
      name: 'spire_race',
      startLine: 39,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스파이어 건설! 뮤탈 경쟁 시작!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 올리면서 스파이어 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어에 스파이어! 뮤탈에 대비합니다!',
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 가장 위험한 타이밍입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 추가하면서 수비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 53-68)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 12앞(홈) 자원 우위로 뮤탈 물량 승리
        ScriptBranch(
          id: 'home_macro_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 자원 vs 타이밍 승부입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 자원으로 뮤탈 물량을 확보합니다!',
              owner: LogOwner.home,
              homeArmy: 8, awayArmy: -5, favorsStat: 'macro',
              altText: '{home} 선수 뮤탈 물량! 앞마당 자원이 빛납니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '12앞마당의 자원 우위가 결정적!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 12풀(어웨이) 뮤탈 컨트롤 승리
        ScriptBranch(
          id: 'away_control_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 vs 뮤탈! 자원 vs 타이밍 승부입니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 컨트롤로 상대 뮤탈을 효율적으로 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 컨트롤! 물량 차이를 극복!',
            ),
            ScriptEvent(
              text: '{away}, 남은 뮤탈로 드론을 견제합니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3, homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤이 자원 차이를 극복했습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
