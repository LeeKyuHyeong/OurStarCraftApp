part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 아콘 조합 (치즈 vs 밸런스)
// ----------------------------------------------------------
const _zvp4poolVsArchon = ScenarioScript(
  id: 'zvp_4pool_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_trans_archon'],
  description: '4풀 저글링 올인 vs 하이템플러+아콘 조합',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4풀 빌드! 스포닝풀이 올라갑니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 드론 4마리에서 스포닝풀! 극초반 러시!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 올립니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 건물을 올리기 시작합니다. 템플러 아카이브로 가는 테크 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리가 나옵니다! 출발!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 첫 질럿을 생산합니다. 아콘까지는 멀었습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿 생산! 하이템플러는 아직 한참 남았죠!',
        ),
        ScriptEvent(
          text: '아콘이 나오기 전에 끝내야 합니다! 시간 싸움!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 입구에 도착! 질럿과 교전!',
          owner: LogOwner.home,
          homeArmy: -1, awayArmy: -1, favorsStat: 'control',
          altText: '{home} 선수 저글링 진입! 질럿을 에워쌉니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브까지 동원해서 저글링을 막습니다!',
          owner: LogOwner.away,
          homeArmy: -1, awayResource: -5, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 질럿을 우회해서 프로브를 노립니다!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'harass',
          altText: '{home}, 프로브 사냥! 일꾼이 줄어듭니다!',
        ),
        ScriptEvent(
          text: '{away}, 추가 질럿으로 저글링을 압박합니다!',
          owner: LogOwner.away,
          awayArmy: 2, homeArmy: -2, favorsStat: 'defense',
          altText: '{away} 선수 질럿 추가! 저글링을 잡아냅니다!',
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 보냅니다! 시간이 없습니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 추가 투입! 아콘 전에 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔까지 건설하면서 하이템플러를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{away}, 템플러 아카이브가 올라가고 있습니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away} 선수 템플러 아카이브 건설! 아콘이 곧 나옵니다!',
        ),
        ScriptEvent(
          text: '하이템플러가 나오면 저글링은 사이오닉 스톰에 녹습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
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
              text: '{home}, 저글링이 하이템플러 완성 전에 돌파합니다! 프로브 전멸!',
              owner: LogOwner.home,
              awayResource: -20, awayArmy: -3, favorsStat: 'attack',
              altText: '{home} 선수 돌파 성공! 아콘이 나오기 전에 끝냈습니다!',
            ),
            ScriptEvent(
              text: '아콘 테크가 완성되기 전에 게임이 끝납니다!',
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
              text: '{away}, 질럿으로 저글링을 막고 하이템플러가 합류합니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: 4, favorsStat: 'defense',
              altText: '{away} 선수 하이템플러 합류! 사이오닉 스톰!',
            ),
            ScriptEvent(
              text: '하이템플러+아콘 합류! 저글링을 전멸시킵니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
