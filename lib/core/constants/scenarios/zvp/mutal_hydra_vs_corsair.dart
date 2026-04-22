part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 뮤탈 히드라 vs 커세어 + 지상군
// ----------------------------------------------------------
const _zvpMutalHydraVsCorsair = ScenarioScript(
  id: 'zvp_mutal_hydra_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mutal_hydra', 'zvp_2hatch_mutal', 'zvp_9overpool'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '뮤탈리스크 히드라 vs 커세어 공중 견제 + 지상군',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑기 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런 건설 후 게이트웨이를 올립니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 자원을 챙깁니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어에서 스타게이트를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 스타게이트! 커세어를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣으면서 레어를 향합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
        ),
      ],
    ),
    // Phase 1: 공중 대결 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 생산! 오버로드를 사냥합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 커세어 출격! 오버로드를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 완성! 뮤탈리스크를 생산합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,
          altText: '{home} 선수, 뮤탈리스크 출격! 커세어와 맞붙습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수, 뮤탈이 커세어를 피해 프로브를 견제합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home} 선수 뮤탈 우회! 프로브를 물어뜯습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수, 커세어가 오버로드를 격추합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: -1, homeResource: -10,        ),
        ScriptEvent(
          text: '뮤탈 vs 커세어! 서로의 약점을 노리는 견제전입니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 지상 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라와 뮤탈을 함께 운용합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -20,
          altText: '{home} 선수, 히드라덴! 뮤탈 히드라 조합!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔에서 템플러 아카이브를 올립니다! 스톰 준비!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -25,
          altText: '{away} 선수, 템플러 아카이브! 하이 템플러를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈로 계속 프로브를 견제합니다! 자원 차이를 만듭니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home} 선수, 뮤탈 견제 지속! 일꾼이 줄어듭니다!',
        ),
        ScriptEvent(
          text: '뮤탈의 견제력이냐 커세어의 시야 장악이냐!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 하이 템플러를 잡습니다! 스톰 위협 제거!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,              altText: '{home} 선수, 뮤탈이 하이 템플러를 사냥! 스톰을 봉인!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라 편대가 프로토스 앞마당을 공격합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3, awayArmy: -4,            ),
            ScriptEvent(
              text: '{away} 선수 스톰 없이 히드라 물량을 감당할 수 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '뮤탈의 견제력이 프로토스 테크를 차단했습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 하이 템플러 합류! 스톰이 히드라를 강타합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5,              altText: '{away} 선수, 스톰이 저그 병력을 녹여버립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 커세어가 뮤탈을 쫓아내고 드라군이 전진합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: 2,            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈과 히드라 모두 피해가 큽니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '스톰과 커세어의 조합! 뮤탈 히드라를 제압합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
