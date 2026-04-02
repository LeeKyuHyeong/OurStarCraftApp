part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 선엔베 4배럭 vs 뮤탈 럴커 — 타이밍 공격 vs 밸런스 조합
// ----------------------------------------------------------
const _tvz4raxEnbeVsMutalLurker = ScenarioScript(
  id: 'tvz_4rax_enbe_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_4rax_enbe'],
  awayBuildIds: ['zvt_trans_mutal_lurker', 'zvt_12pool', 'zvt_9pool'],
  description: '선엔베 4배럭 타이밍 vs 뮤탈 럴커 밸런스 조합',
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
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 공격력 업그레이드를 준비합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 엔지니어링 베이가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀과 가스를 넣습니다. 뮤탈을 준비하는 빌드!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 가스를 넣으면서 뮤탈을 노립니다!',
        ),
        ScriptEvent(
          text: '양쪽 모두 자기 빌드에 집중합니다.',
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
          text: '{home} 선수 배럭을 4개까지 올립니다! 아카데미도 건설!',
          owner: LogOwner.home,
          homeResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 스파이어 건설!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 레어와 스파이어를 올립니다! 뮤탈 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕을 뽑고 있습니다! 물량이 늘어나네요.',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 뽑으면서 히드라덴도 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '테란은 마린 메딕 물량을, 저그는 뮤탈 럴커를 준비하고 있습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 뮤탈 등장 + 타이밍 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 나왔습니다! 테란 앞을 정찰합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -15,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 메딕이 모였습니다! 터렛도 건설 완료!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          altText: '{home}, 마린 메딕 부대 완성! 터렛으로 대공 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크가 마린 뒤쪽 일꾼을 견제합니다!',
          owner: LogOwner.away,
          homeResource: -10,
          favorsStat: 'harass',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '뮤탈 견제를 받으면서 마린이 진격해야 합니다! 멀티태스킹 싸움!',
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
              text: '{home} 선수 스팀팩 마린 메딕이 앞마당으로 진격합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 아직 부족합니다! 마린을 못 막아요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
              altText: '{away} 선수 럴커가 아직 부족합니다! 테란 보병을 못 막아요!',
            ),
            ScriptEvent(
              text: '{home} 선수 앞마당을 밀고 본진까지 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '마린 메딕 물량이 압도적! 4배럭 타이밍 성공! GG!',
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
              text: '{away} 선수 뮤탈리스크가 테란 본진을 급습합니다!',
              owner: LogOwner.away,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 뮤탈이 테란 일꾼을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 럴커가 앞마당에서 마린을 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 럴커 양면 공격! 테란이 대응하지 못합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 럴커 조합에 테란이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
