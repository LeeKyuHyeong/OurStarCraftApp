part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 뮤탈 럴커 — 치즈 vs 밸런스형
// ----------------------------------------------------------
const _tvzBunkerVsMutalLurker = ScenarioScript(
  id: 'tvz_bunker_vs_mutal_lurker',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_mutal_lurker'],
  description: '벙커 러시 vs 뮤탈 럴커 — 초반 올인 vs 밸런스 조합',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설! 센터에 올립니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 센터 배럭이 올라가고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 SCV가 일찍 출발합니다. 벙커 러시!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 가스를 넣습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀과 가스를 동시에 넣습니다!',
        ),
        ScriptEvent(
          text: '테란이 벙커 러시를 준비합니다! 저그는 뮤탈 테크를 가져가려 하구요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벙커 돌입 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 SCV가 저그 앞마당에 도착합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 저글링이 SCV를 쫓아다닙니다! 벙커가 안 올라가요!',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV로 수리하며 벙커를 고수합니다!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리고 있습니다! 스파이어 준비!',
          owner: LogOwner.away,
          awayResource: -20,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '벙커 완성이 관건입니다! 저그는 뮤탈을 준비하고 있네요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 전환기 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 스파이어를 건설합니다! 뮤탈리스크가 곧 나옵니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스파이어가 올라갑니다! 뮤탈이 곧이네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 마린을 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴도 건설! 뮤탈과 럴커를 동시에 준비하는군요!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '뮤탈과 럴커가 합류하면 테란은 답이 없습니다!',
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
              text: '{home} 선수 벙커 완성! 마린이 앞마당을 압박합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링만으로는 못 막습니다! 앞마당이 위험해요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 해처리를 부수고 있습니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
              altText: '{home}, 앞마당 해처리가 무너집니다!',
            ),
            ScriptEvent(
              text: '뮤탈이 나오기 전에 끝냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away} 선수 벙커 러시를 막아냅니다! 저글링이 마린을 잡았어요!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away}, 저글링 서라운드로 마린을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈리스크가 나왔습니다! 테란 본진으로 향합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크가 마린을 잡아냅니다! 터렛이 없는 본진!',
              owner: LogOwner.away,
              homeArmy: -3,
              homeResource: -25,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '뮤탈 럴커 조합이 완성됩니다! 테란이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
