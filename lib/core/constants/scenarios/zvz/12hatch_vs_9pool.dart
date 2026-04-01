part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 2. 12앞마당 vs 9풀 (수비형 vs 공격형)
// ----------------------------------------------------------
const _zvz12hatchVs9pool = ScenarioScript(
  id: 'zvz_12hatch_vs_9pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_12hatch', 'zvz_12pool'],
  awayBuildIds: ['zvz_9pool', 'zvz_9overpool'],
  description: '12앞마당 수비 vs 9풀 공격',
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
          altText: '{home}, 12앞마당! 확장을 가져가겠다는 배짱 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀 건설! 공격적입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9풀! 스포닝풀 올리고 빠른 저글링으로 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀을 뒤늦게 올립니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 발업 저글링 생산 시작!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
          altText: '{away}, 저글링 나옵니다! 발업까지!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 15-20)
    ScriptPhase(
      name: 'ling_attack',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{away}, 발업 저글링이 상대 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'attack',
          altText: '{away} 선수 저글링 돌진! 12앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 노발업 저글링, 드론, 성큰으로 수비합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -15, favorsStat: 'defense',
          altText: '{home}, 성큰을 올리면서 드론도 같이 막습니다!',
        ),
        ScriptEvent(
          text: '12앞마당을 지킬 수 있을까요? 결정적인 순간입니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 앞마당 수비 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'hatch_defense',
      startLine: 21,
      branches: [
        // 분기 A: 앞마당 파괴 (9풀 공격 성공)
        ScriptBranch(
          id: 'hatch_destroyed',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 저글링이 드론을 뚫습니다! 앞마당 해처리를 공격!',
              owner: LogOwner.away,
              homeResource: -15, homeArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 앞마당이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리가 부서지고 있습니다!',
              owner: LogOwner.home,
              homeResource: -15,
              altText: '{home}, 앞마당이 무너집니다! 자원 손실이 크네요!',
            ),
            ScriptEvent(
              text: '{away}, 추가 저글링 합류! 드론까지 물어뜯습니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '앞마당이 큰 피해를 입었습니다! 9풀 공격 성공!',
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
              text: '{away} 선수 저글링이 성큰에 막힙니다! 피해만 누적!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 드론으로 협공! 수비 성공!',
              owner: LogOwner.home,
              homeArmy: 1, awayArmy: -1, favorsStat: 'control',
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
    // Phase 3: 뮤탈 경쟁 (lines 37-52)
    ScriptPhase(
      name: 'mutal_race',
      startLine: 37,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 5,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 스파이어 건설 서두릅니다!',
          owner: LogOwner.away,
          awayResource: -25, awayArmy: 2,
          altText: '{away}, 스파이어를 빠르게 올립니다! 뮤탈 선점!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어를 올리면서 스파이어를 준비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 레어에 스파이어 건설! 뮤탈에 대비합니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈리스크가 먼저 나옵니다! 소수라도 강합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수 뮤탈 선점! 드론을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 뮤탈로 드론을 견제합니다! 빠른 뮤탈의 힘!',
          owner: LogOwner.away,
          homeResource: -10, favorsStat: 'harass',
          altText: '{away}, 뮤탈 견제! 드론을 물어뜯습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포어로 버티면서 스파이어 완성을 기다립니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '뮤탈 타이밍 경쟁이 승부를 가르고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 - 분기 (lines 53-68)
    // 9풀이 뮤탈 선점으로 견제, 12앞은 자원으로 버팀
    // 목표: 전체 35-42% 홈(12앞) 승률
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 53,
      branches: [
        // 분기 A: 12앞(홈)이 자원 우위로 뮤탈 물량 역전
        ScriptBranch(
          id: 'home_macro_comeback',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 드디어 합류합니다! 물량이 늘어나고 있어요!',
              owner: LogOwner.home,
              homeArmy: 8, homeResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 앞마당 자원 덕분에 뮤탈 수를 따라잡습니다!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -5, favorsStat: 'macro',
              altText: '{home} 선수 자원 우위! 뮤탈 물량으로 역전하는데요!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 반격! 상대 드론을 견제합니다!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, awayResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '12앞마당의 자원이 빛나는 순간입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀(어웨이)이 뮤탈 선점 유지
        ScriptBranch(
          id: 'away_mutal_dominance',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 공중전을 압도합니다!',
              owner: LogOwner.away,
              awayArmy: 8, homeArmy: -5, favorsStat: 'control',
              altText: '{away} 선수 뮤탈 수 우세! 공중전 승리!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 드론을 계속 물어뜯습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -15, homeArmy: -5, favorsStat: 'harass',
              altText: '{away} 선수 뮤탈 견제 이어갑니다! 드론이 녹습니다!',
            ),
            ScriptEvent(
              text: '{home}, 스커지로 뮤탈을 잡으려 하지만 수가 부족합니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '뮤탈 타이밍 차이가 승부를 가르고 있습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

