part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 뮤탈리스크 울트라리스크 — 치즈 vs 매크로
// ----------------------------------------------------------
const _tvzBunkerVsMutalUltra = ScenarioScript(
  id: 'tvz_bunker_vs_mutal_ultra',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_mutal_ultra'],
  description: '벙커 러시 vs 뮤탈 울트라 — 초반 올인 vs 장기전',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 센터 배럭을 건설합니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 해처리를 먼저 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 앞마당 해처리부터 올리는군요.',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 앞으로 보냅니다! 벙커 러시 준비!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설하면서 드론 생산을 계속합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '테란이 공격적인 움직임을 보이고 있습니다! 저그는 확장에 집중하구요.',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 벙커 공격 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 마린 SCV가 저그 앞마당에 도착! 벙커 건설!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'control',
          altText: '{home}, 마린과 SCV가 저그 진영에 도착합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 소량으로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 SCV로 수리하면서 벙커를 올리려 합니다!',
          owner: LogOwner.home,
          homeResource: -5,
          favorsStat: 'control',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 드론까지 동원해서 벙커를 막습니다!',
          owner: LogOwner.away,
          awayResource: -10,
          awayArmy: -1,
          favorsStat: 'defense',
          altText: '{away}, 드론을 빼서 SCV를 잡으려 합니다!',
        ),
        ScriptEvent(
          text: '벙커가 완성되면 테란 유리, 막히면 저그 유리! 긴장되는 순간!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 결전 준비 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 성큰을 추가합니다! 수비를 굳힙니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 마린을 보내고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수 레어 올리면서 스파이어 준비! 뮤탈리스크가 나온다면 끝입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 레어를 올립니다! 스파이어가 곧 완성되겠네요!',
        ),
        ScriptEvent(
          text: '테란이 지금 끝내지 못하면 뮤탈리스크에 무너질 수 있습니다!',
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
              text: '{home} 선수 벙커 완성! 마린 화력으로 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
              altText: '{home}, 벙커가 올라갔습니다! 마린이 쏟아져 나옵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰이 부족합니다! 앞마당이 무너지고 있어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 추가 마린까지 합류! 저그 본진까지 밀고 들어갑니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '벙커 러시 성공! 뮤탈 전에 끝났습니다! GG!',
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
              text: '{away} 선수 성큰과 저글링으로 벙커를 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{away}, 성큰이 마린을 녹입니다! 벙커가 소용없어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크 생산 시작!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크가 테란 본진을 급습합니다! 터렛이 없습니다!',
              owner: LogOwner.away,
              homeResource: -30,
              homeArmy: -3,
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
