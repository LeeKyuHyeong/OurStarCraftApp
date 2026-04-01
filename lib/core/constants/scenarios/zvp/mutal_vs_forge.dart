part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 2. 뮤탈 운영 vs 포지더블 (뮤탈 택)
// ----------------------------------------------------------
const _zvpMutalVsForge = ScenarioScript(
  id: 'zvp_mutal_vs_forge',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_2hatch_mutal', 'zvp_trans_mutal_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_corsair', 'pvz_trans_forge_expand'],
  description: '뮤탈 운영 vs 포지더블',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스와 게이트웨이, 캐논 건설!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 포지더블 완성! 게이트웨이와 캐논으로 입구를 단단히 막습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 스포닝풀 건설 후 가스 채취! 테크를 올리려는 건가요?',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 올리면서 스파이어 준비합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어에서 스파이어가 올라갑니다! 뮤탈리스크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트 건설! 커세어를 준비합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
      ],
    ),
    // Phase 1: 뮤탈 등장 (lines 17-26)
    ScriptPhase(
      name: 'mutal_debut',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 생산 시작! 5기가 빠르게 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25,
          altText: '{home}, 뮤탈 5기 완성! 견제 출발!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어와 스포어로 대비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 프로브를 노립니다! 견제!',
          owner: LogOwner.home,
          favorsStat: 'harass',
          altText: '{home} 선수 뮤탈 기동! 프로브를 노립니다!',
        ),
      ],
    ),
    // Phase 2: 뮤탈 견제 - 분기 (lines 27-40)
    ScriptPhase(
      name: 'mutal_harass',
      startLine: 27,
      branches: [
        // 분기 A: 뮤탈 견제 성공 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'mutal_harass_success',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 물어뜯습니다! 커세어가 늦었어요!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 선수 뮤짤! 일꾼이 줄줄이 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 뒤늦게 대응합니다!',
              owner: LogOwner.away,
              homeArmy: -1, awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈을 빼면서 다른 곳을 노립니다! 기동력이 좋네요!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 이리저리 피하면서 견제합니다!',
            ),
            ScriptEvent(
              text: '뮤탈 견제가 성공적입니다! 프로토스 일꾼에 타격!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 커세어가 뮤탈 대응 (조건 없음 → 항상 eligible, 가중치로 선택)
        ScriptBranch(
          id: 'corsair_mutal_counter',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 커세어가 뮤탈을 쫓아갑니다! 공중 추격전!',
              owner: LogOwner.away,
              homeArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 커세어 컨트롤! 뮤탈을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈이 피해를 입었지만 빠져나갑니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away} 선수 커세어로 오버로드를 사냥합니다!',
              owner: LogOwner.away,
              homeResource: -5, awayArmy: 1,
            ),
            ScriptEvent(
              text: '커세어가 뮤탈을 견제하면서 안정적인 운영!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 교전 (lines 41-54)
    ScriptPhase(
      name: 'mid_battle',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 지상 전력도 준비합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 히드라덴이 올라갑니다! 복합 편성을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라를 추가 생산합니다! 뮤탈 히드라 조합!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -20,
          altText: '{home}, 뮤탈에 히드라까지! 복합 편성입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 하이 템플러 합류! 스톰 준비 완료!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
        ),
        ScriptEvent(
          text: '{home}, 히드라 편대가 프로토스 앞마당을 공격합니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 스톰이 히드라 편대 위에 떨어집니다!',
          owner: LogOwner.away,
          homeArmy: -5, favorsStat: 'strategy',
          altText: '{away} 선수 스톰 투하! 스톰이 히드라 편대를 강타합니다!',
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 하이 템플러를 물어뜯습니다! 스톰 시전을 방해!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'control',
          altText: '{home} 선수 뮤탈 견제! 하이 템플러가 잡힙니다!',
        ),
        ScriptEvent(
          text: '스톰과 뮤탈 기동력의 대결입니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 4: 결전 전개 (lines 55-66)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 55,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 전 병력 총동원! 뮤탈 히드라 저글링!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군 질럿 하이 템플러 총출동!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
        ),
        ScriptEvent(
          text: '양측 전면전이 시작됩니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{home}, 뮤탈이 하이 템플러를 노립니다! 스톰을 막아야 합니다!',
          owner: LogOwner.home,
          awayArmy: -4, homeArmy: -3, favorsStat: 'control',
          altText: '{home} 선수 뮤탈로 하이 템플러 솎아내기! 핵심 유닛을 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 스톰 투하! 스톰이 히드라 편대를 덮칩니다!',
          owner: LogOwner.away,
          homeArmy: -4, awayArmy: -2, favorsStat: 'strategy',
          altText: '{away} 선수 스톰! 스톰이 히드라 편대에 치명타!',
        ),
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 확장기지로 침투합니다! 프로브가 위험!',
          owner: LogOwner.home,
          awayResource: -15, favorsStat: 'harass',
          altText: '{home} 선수 저글링 견제! 프로브를 노립니다!',
        ),
      ],
    ),
    // Phase 5: 결전 결과 - 분기 (lines 67-70)
    ScriptPhase(
      name: 'decisive_result',
      startLine: 67,
      branches: [
        ScriptBranch(
          id: 'zerg_mutal_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '뮤탈 기동력이 승부를 결정합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'protoss_storm_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '스톰이 히드라를 쓸어버립니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

