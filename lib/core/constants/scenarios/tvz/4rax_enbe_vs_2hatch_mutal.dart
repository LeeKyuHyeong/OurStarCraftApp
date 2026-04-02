part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 2해처리 뮤탈 — 타이밍 푸시 vs 빠른 뮤탈
// ----------------------------------------------------------
const _tvz4raxEnbeVs2hatchMutal = ScenarioScript(
  id: 'tvz_4rax_enbe_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4rax_enbe'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '선엔베 4배럭 타이밍 vs 2해처리 뮤탈리스크',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 해처리를 앞마당에 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리를 올리는 안정적인 빌드네요.',
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀과 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '양쪽 다 자기 빌드에 집중하고 있습니다.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 빌드업 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 추가! 4배럭 체제를 갖춥니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 배럭이 4개 올라갑니다! 마린 물량 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 스파이어를 빠르게 가져갑니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 메딕 생산 준비합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 2해처리에서 드론을 뽑으면서 뮤탈을 준비합니다.',
          owner: LogOwner.away,
          awayResource: 10,
          favorsStat: 'macro',
          altText: '{away}, 일꾼이 빠르게 늘어나고 있습니다!',
        ),
        ScriptEvent(
          text: '마린 메딕 타이밍과 뮤탈리스크 타이밍의 대결이 될 것 같습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 뮤탈 등장 & 타이밍 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕 부대를 모읍니다! 터렛도 올립니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          altText: '{home}, 마린 메딕을 모으면서 터렛으로 대공 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 테란 앞마당을 견제합니다!',
          owner: LogOwner.away,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '뮤탈 견제와 마린 타이밍이 동시에 진행됩니다! 집중력 싸움!',
          owner: LogOwner.system,
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
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 스팀팩 마린 메딕이 앞마당으로 돌격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 마린 메딕 물량으로 저그 앞마당을 압박합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링만으로는 못 막습니다! 뮤탈이 돌아오기 전이에요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당 해처리를 때립니다! 저그가 밀리고 있습니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '4배럭 타이밍 성공! 마린 물량 앞에 저그가 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 테란 본진을 급습합니다! 일꾼이 잡힙니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈이 SCV를 잡아내고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링과 성큰으로 마린 푸시를 막습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크 추가 생산! 하늘을 장악합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈리스크에 테란이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
