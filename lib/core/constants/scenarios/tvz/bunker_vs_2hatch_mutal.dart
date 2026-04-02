part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 벙커 러시 vs 2해처리 뮤탈 — 치즈 vs 빠른 뮤탈
// ----------------------------------------------------------
const _tvzBunkerVs2hatchMutal = ScenarioScript(
  id: 'tvz_bunker_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_bunker'],
  awayBuildIds: ['zvt_trans_2hatch_mutal', 'zvt_2hatch_mutal'],
  description: '벙커 러시 vs 2해처리 뮤탈리스크 — 초반 공세 vs 빠른 뮤탈',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다. 센터에 올립니다!',
          owner: LogOwner.home,
          homeResource: -10,
          altText: '{home}, 센터 배럭이 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 12해처리 빌드입니다. 앞마당 해처리를 올리구요.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 SCV를 저그 진영 쪽으로 보내고 있습니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 드론을 계속 뽑습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스포닝풀 올리면서 일꾼 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '테란의 움직임이 심상치 않습니다! 저그는 확장에만 신경 쓰고 있네요.',
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
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링을 급히 생산합니다! 벙커를 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
          altText: '{away}, 급하게 저글링을 뽑습니다! 벙커 건설을 저지해야 해요!',
        ),
        ScriptEvent(
          text: '{home} 선수 벙커 건설 중! SCV가 수리합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 드론까지 동원해 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          homeArmy: -1,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '벙커 완성 여부가 이 경기의 승패를 가를 것 같습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 뮤탈 등장 위협 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 레어를 올립니다! 스파이어 준비 중!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 추가 마린을 보냅니다! 시간이 없습니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 마린을 추가로 보내고 있습니다! 빨리 끝내야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 성큰 건설! 수비를 강화합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '뮤탈리스크가 나오기 전에 승부를 봐야 합니다! 시간 싸움이네요!',
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
              text: '{home} 선수 벙커가 완성됩니다! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰이 부족합니다! 앞마당 해처리가 위험해요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 앞마당을 부수고 있습니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayResource: -25,
              favorsStat: 'attack',
              altText: '{home}, 앞마당 해처리를 때리고 있습니다! 저그가 무너지네요!',
            ),
            ScriptEvent(
              text: '벙커 러시 성공! 저그가 버티지 못합니다! GG!',
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
              text: '{away} 선수 성큰과 저글링으로 벙커 러시를 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              favorsStat: 'defense',
              altText: '{away} 선수 저글링이 벙커 건설을 막았습니다! 테란 보병이 녹아요!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈리스크가 테란 본진을 급습합니다! 대공이 없네요!',
              owner: LogOwner.away,
              homeResource: -25,
              homeArmy: -2,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '2해처리 뮤탈이 완성됐습니다! 테란이 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
