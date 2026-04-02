part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 뮤탈 히드라 vs 2스타게이트 커세어 (공중 대결)
// ----------------------------------------------------------
const _zvpMutalHydraVs2starCorsair = ScenarioScript(
  id: 'zvp_mutal_hydra_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mutal_hydra'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '뮤탈리스크 vs 2스타게이트 커세어 공중전',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
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
          text: '{away} 선수 파일런 건설 후 게이트웨이를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어에서 스타게이트 2개를 올립니다!',
          owner: LogOwner.away,
          awayResource: -35,
          altText: '{away}, 스타게이트 2개! 커세어 물량을 쏟아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 올리면서 레어를 향합니다.',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 가스 채취! 스파이어를 노립니다!',
        ),
      ],
    ),
    // Phase 1: 공중 대결 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 4기가 동시 출격합니다!',
          owner: LogOwner.away,
          awayArmy: 5, awayResource: -25,
          altText: '{away}, 커세어 4기! 오버로드를 사냥합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 완성! 스파이어에서 뮤탈리스크를 뽑습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 스파이어 완성! 뮤탈 생산 시작!',
        ),
        ScriptEvent(
          text: '{away}, 커세어가 오버로드를 격추합니다!',
          owner: LogOwner.away,
          homeArmy: -1, homeResource: -10, favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈 3기 완성! 커세어와 공중전 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20, favorsStat: 'control',
          altText: '{home}, 뮤탈 출격! 커세어와 맞붙습니다!',
        ),
        ScriptEvent(
          text: '커세어의 뉴트론 플레어 vs 뮤탈의 기동력! 공중 패권 다툼!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 지상 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라로 대공 화력을 보강합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 히드라덴! 히드라가 커세어를 격추합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스커지도 섞어서 커세어를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, awayArmy: -2, homeResource: -10, favorsStat: 'control',
          altText: '{home}, 스커지 돌진! 커세어를 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어 수가 줄어듭니다! 지상군을 보충합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 드라군을 뽑습니다! 지상전 대비!',
        ),
        ScriptEvent(
          text: '공중전의 결과가 지상전까지 영향을 미칩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈과 스커지로 커세어를 전멸시킵니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'control',
              altText: '{home}, 뮤탈+스커지! 커세어가 전부 격추됩니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈이 프로브를 견제합니다! 히드라가 지상을 밀어붙입니다!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -3, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 공중 유닛을 잃고 지상군도 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '공중전에서 승리한 뮤탈이 전장을 지배합니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어 물량으로 뮤탈을 격추합니다! 범위 공격!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'control',
              altText: '{away}, 커세어 뉴트론 플레어! 뮤탈이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away}, 오버로드를 전멸시키고 드라군이 전진합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -10, awayArmy: 2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 공중 유닛을 잃고 히드라만으로는 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '커세어 물량이 뮤탈을 제압! 공중 패권을 장악합니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
