part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12풀 vs 노풀 3해처리 (스탠다드 vs 극매크로)
// ----------------------------------------------------------
const _zvz12poolVs3hatchNopool = ScenarioScript(
  id: 'zvz_12pool_vs_3hatch_nopool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12pool'],
  awayBuildIds: ['zvz_3hatch_nopool'],
  description: '12풀 스탠다드 vs 노풀 3해처리',
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
          text: '{home} 선수 12드론에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 12풀 스포닝풀! 스탠다드한 오프닝입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다! 스포닝풀 없이!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 노풀 앞마당! 스포닝풀 없이 자원을 극대화합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 발업 연구 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
          altText: '{home}, 저글링에 발업! 앞마당을 노릴 수 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 계속 뽑고 있습니다. 스포닝풀이 아직 없어요.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
      ],
    ),
    // Phase 1: 저글링 압박 (lines 9-13)
    ScriptPhase(
      name: 'ling_pressure',
      startLine: 9,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 상대 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'attack',
          altText: '{home} 선수 저글링 도착! 3해처리 상대에게 풀이 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론으로 막으면서 스포닝풀 건설을 기다립니다!',
          owner: LogOwner.away,
          awayArmy: 3, favorsStat: 'control',
          altText: '{away}, 드론으로 버팁니다! 풀이 곧 완성됩니다!',
        ),
        ScriptEvent(
          text: '12풀의 저글링이 3해처리를 얼마나 괴롭힐 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 압박 결과 - 분기 (lines 13-28)
    ScriptPhase(
      name: 'pressure_result',
      startLine: 13,
      branches: [
        // 분기 A: 저글링이 드론 피해를 줌
        ScriptBranch(
          id: 'ling_destroys_drones',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 드론을 물어뜯습니다! 앞마당 드론이 녹습니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 심각합니다! 풀이 너무 늦었어요!',
              owner: LogOwner.away,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home}, 추가 저글링 합류! 앞마당 해처리까지 위협!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '12풀 저글링이 3해처리의 약점을 정확히 찔렀습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 3해처리가 수비 성공
        ScriptBranch(
          id: 'macro_defense_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드론 컨트롤로 저글링을 막아냅니다! 풀도 완성!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 3, favorsStat: 'control',
              altText: '{away} 선수 드론과 저글링 합류! 수비 성공!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 제거당합니다! 피해가 적었어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 앞마당 드론이 살아남으면서 자원 우위 확보!',
              owner: LogOwner.away,
              awayResource: 15,
              altText: '{away} 선수 3해처리의 자원! 드론 차이가 벌어집니다!',
            ),
            ScriptEvent(
              text: '수비 성공! 3해처리의 자원 이점이 살아있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 41-54)
    ScriptPhase(
      name: 'spire_race',
      startLine: 41,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어를 올리면서 스파이어를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 스파이어 건설! 뮤탈을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰을 깔면서 앞마당을 안정시킵니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
          altText: '{away}, 성큰 건설! 저글링 공격에 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '스파이어를 올리는 순간이 가장 위험한 타이밍입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 본진에 깔면서 수비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 55-70)
    ScriptPhase(
      name: 'mutal_battle',
      startLine: 55,
      branches: [
        // 분기 A: 뮤탈 견제로 드론 차이 벌림
        ScriptBranch(
          id: 'mutal_harass',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 먼저 나왔습니다! 드론을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 뮤탈 선점! 3해처리의 드론을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어를 올리면서 스커지로 대응합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -15, favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 스포어를 피하며 견제하지만 3해처리의 자원이 풍부합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '뮤탈 견제와 자원 차이의 싸움! 누가 유리할까요?',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 3해처리가 뮤탈 물량으로 압도
        ScriptBranch(
          id: 'macro_mutal_overwhelm',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈이 쏟아집니다! 3해처리의 자원이 빛나는 순간!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -20, favorsStat: 'macro',
              altText: '{away} 선수 뮤탈 물량! 자원 차이가 드러납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 수에서 밀립니다! 스커지를 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 드론을 견제합니다! 자원 격차가 더 벌어집니다!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제! 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '3해처리의 풍부한 자원이 뮤탈 물량으로 전환되고 있습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 (lines 71-85)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈 스커지를 모아서 결전을 걸어봅니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈 편대로 맞섭니다! 물량이 우세합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '뮤탈 편대 충돌! 물량 vs 컨트롤!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 스커지로 뮤탈을 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -5, homeArmy: -4, favorsStat: 'control',
          altText: '{home} 선수 스커지 자폭! 뮤탈을 잡습니다!',
        ),
        ScriptEvent(
          text: '{away}, 남은 뮤탈로 드론을 견제합니다! 자원 차이!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -3, homeResource: -10, favorsStat: 'harass',
          altText: '{away} 선수 남은 뮤탈로 압박! 자원 차이가 드러납니다!',
        ),
      ],
    ),
    // Phase 6: 최종 결과 - 분기 (lines 86-95)
    ScriptPhase(
      name: 'final_result',
      startLine: 86,
      branches: [
        ScriptBranch(
          id: 'home_scourge_wins',
          baseProbability: 0.4,
          events: [
            ScriptEvent(
              text: '{home}, 스커지 컨트롤로 뮤탈 편대를 격파합니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -8, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '스커지 컨트롤이 뮤탈 물량을 압도했습니다! 12풀의 승리! 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mutal_overwhelm',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 물량이 스커지를 흡수하고 남습니다! 드론 견제!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -8, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '뮤탈 물량과 자원 차이가 결정적! 3해처리의 승리! 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
