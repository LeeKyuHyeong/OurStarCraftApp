part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 미러 (극초반 올인 미러)
// ----------------------------------------------------------
const _zvz4PoolMirror = ScenarioScript(
  id: 'zvz_4pool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_4pool'],
  description: '4풀 미러 극초반 저글링 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 극초반 스포닝풀입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 4드론에 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 4풀! 양쪽 다 올인입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 바로 출발합니다!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -15,
          altText: '{home}, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링 6기 생산! 서로를 향해 출발!',
          owner: LogOwner.away,
          awayArmy: 6, awayResource: -15,
          altText: '{away}, 저글링이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '극초반 저글링 싸움이 모든 걸 결정합니다! 컨트롤 싸움이 중요하겠습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 교전 - 센터 vs 엇갈림 분기 (lines 11-30)
    ScriptPhase(
      name: 'ling_battle',
      startLine: 11,
      branches: [
        // ── 분기 A: 센터 교전 → 홈 컨트롤 승리 ──
        ScriptBranch(
          id: 'center_home_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 센터에서 마주칩니다! 수가 같습니다!',
              owner: LogOwner.home,
              altText: '{home} 선수 저글링 교전! 컨트롤이 전부입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링도 맞붙습니다! 드론 수가 적어서 이게 전부예요!',
              owner: LogOwner.away,
              altText: '{away}, 저글링 맞대결! 한 기 차이가 승패를 가릅니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤이 곧 승패입니다! 컨트롤 싸움이 중요하겠습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home}, 저글링 컨트롤 차이! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 저글링 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 녹습니다! 드론으로 막아야 합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 남은 저글링으로 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 저글링 돌파! 드론을 공격합니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이가 승부를 갈랐습니다! 저글링 싸움 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 B: 센터 교전 → 어웨이 컨트롤 승리 ──
        ScriptBranch(
          id: 'center_away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 센터에서 마주칩니다! 수가 같습니다!',
              owner: LogOwner.home,
              altText: '{home} 선수 저글링 교전! 컨트롤이 전부입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링도 맞붙습니다! 한 기 차이가 승패를 가릅니다!',
              owner: LogOwner.away,
              altText: '{away}, 저글링 맞대결! 드론 수가 적어서 이게 전부예요!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤이 곧 승패입니다! 컨트롤 싸움이 중요하겠습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away}, 저글링 컨트롤 차이! 상대 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 저글링 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 녹습니다! 드론으로 막아야 합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 남은 저글링으로 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
              altText: '{away} 선수 저글링 돌파! 드론을 공격합니다!',
            ),
            ScriptEvent(
              text: '저글링 컨트롤 차이가 승부를 갈랐습니다! 저글링 싸움 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 C: 엇갈림 → 홈 멀티태스킹 승리 ──
        ScriptBranch(
          id: 'cross_home_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '저글링이 엇갈립니다! 서로의 본진으로 직행!',
              owner: LogOwner.system,
              altText: '양쪽 저글링이 서로를 지나칩니다! 본진 급습!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 {home} 본진에 도착! 드론을 노립니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
              altText: '{away} 저글링이 본진 침투! 드론이 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론 뭉치기! 저글링을 감싸면서 추가 저글링도 합류!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{home}, 드론으로 저글링을 잡습니다! 추가 저글링까지!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 상대 본진 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home} 저글링이 상대 본진에서 드론을 사냥합니다!',
            ),
            ScriptEvent(
              text: '양쪽 본진에서 동시에 싸움! 멀티태스킹 승부!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 본진 수비하면서 상대 드론까지 잡아냅니다! 멀티태스킹 차이!',
              owner: LogOwner.home,
              homeArmy: 2, awayResource: -10, favorsStat: 'sense',
              altText: '{home}, 양쪽 전선을 동시에 관리합니다! 컨트롤의 차이!',
            ),
            ScriptEvent(
              text: '멀티태스킹 차이가 승부를 갈랐습니다! 저글링 싸움 승리를 거둡니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // ── 분기 D: 엇갈림 → 어웨이 멀티태스킹 승리 ──
        ScriptBranch(
          id: 'cross_away_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '저글링이 엇갈립니다! 서로의 본진으로 직행!',
              owner: LogOwner.system,
              altText: '양쪽 저글링이 서로를 지나칩니다! 본진 급습!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 {away} 본진에 도착! 드론을 노립니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
              altText: '{home} 저글링이 본진 침투! 드론이 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 뭉치기! 저글링을 감싸면서 추가 저글링도 합류!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 드론으로 저글링을 잡습니다! 추가 저글링까지!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 본진 드론을 물어뜯습니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
              altText: '{away} 저글링이 상대 본진에서 드론을 사냥합니다!',
            ),
            ScriptEvent(
              text: '양쪽 본진에서 동시에 싸움! 멀티태스킹 승부!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{away} 선수 본진 수비하면서 상대 드론까지 잡아냅니다! 멀티태스킹 차이!',
              owner: LogOwner.away,
              awayArmy: 2, homeResource: -10, favorsStat: 'sense',
              altText: '{away}, 양쪽 전선을 동시에 관리합니다! 컨트롤의 차이!',
            ),
            ScriptEvent(
              text: '멀티태스킹 차이가 승부를 갈랐습니다! 저글링 싸움 승리를 거둡니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
