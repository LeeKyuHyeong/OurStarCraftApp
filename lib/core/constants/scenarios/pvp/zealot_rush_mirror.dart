part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 질럿 러시 미러 (올인 vs 올인)
// ----------------------------------------------------------
const _pvpZealotRushMirror = ScenarioScript(
  id: 'pvp_zealot_rush_mirror',
  matchup: 'PvP',
  homeBuildIds: ['pvp_zealot_rush'],
  awayBuildIds: ['pvp_zealot_rush'],
  description: '질럿 러시 미러 - 초반 올인 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-12)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 질럿 생산 시작! 빠른 공격을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10,
          altText: '{home}, 질럿을 바로 뽑습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 질럿 생산! 양쪽 질럿 러시!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿을 뽑습니다! 양쪽 러시 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 추가 질럿! 프로브도 함께 전진!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 추가 질럿! 프로브를 끌고 갑니다!',
          owner: LogOwner.away,
          awayArmy: 1, awayResource: -10,
        ),
        ScriptEvent(
          text: '양쪽 질럿 러시! 센터에서 충돌이 불가피합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 1: 질럿 충돌 (lines 13-20)
    ScriptPhase(
      name: 'zealot_clash',
      startLine: 13,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 질럿이 센터에서 부딪힙니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 질럿 전진! 정면 충돌!',
        ),
        ScriptEvent(
          text: '{away}, 질럿이 맞받아칩니다! 프로브 지원까지!',
          owner: LogOwner.away,
          awayArmy: 1, favorsStat: 'attack',
          altText: '{away} 선수 질럿이 맞섭니다!',
        ),
        ScriptEvent(
          text: '질럿 대 질럿! 마이크로 컨트롤이 승부를 가릅니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 교전 결과 - 분기 (lines 21-36)
    ScriptPhase(
      name: 'zealot_fight_result',
      startLine: 21,
      branches: [
        // 분기 A: 홈 질럿이 우세
        ScriptBranch(
          id: 'home_zealot_wins_fight',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 질럿 컨트롤! 상대 질럿을 하나씩 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -1, favorsStat: 'control',
              altText: '{home} 선수 질럿이 교전에서 앞섭니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 녹고 있습니다! 프로브 지원이 필요합니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 남은 질럿으로 상대 진영에 진입!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '교전에서 앞선 질럿이 프로브를 사냥합니다!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 질럿이 우세
        ScriptBranch(
          id: 'away_zealot_wins_fight',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 질럿 컨트롤! 상대 질럿을 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, favorsStat: 'control',
              altText: '{away} 선수 질럿이 교전에서 앞섭니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 질럿이 녹고 있습니다! 프로브 지원이 필요합니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 남은 질럿으로 상대 진영에 진입!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '교전에서 앞선 질럿이 프로브를 사냥합니다!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 장기전 전환 (lines 37-48) - 초반 교전 결착 안 날 때
    ScriptPhase(
      name: 'transition',
      startLine: 37,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 사이버네틱스 코어 건설! 드라군으로 전환!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 사이버네틱스 코어! 드라군 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수도 사이버네틱스 코어! 드라군 전환!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 드라군 생산 시작!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수도 드라군! 양쪽 전환 경쟁!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -15,
        ),
        ScriptEvent(
          text: '질럿 러시 미러에서 장기전으로 넘어갑니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 4: 결전 분기 (lines 49-60)
    ScriptPhase(
      name: 'decisive_clash',
      startLine: 49,
      branches: [
        ScriptBranch(
          id: 'home_dragoon_push_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 드라군 편대로 전진! 상대보다 한 발 빠릅니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 드라군이 앞서갑니다!',
            ),
            ScriptEvent(
              text: '병력 차이가 벌어집니다! 결정적인 전진!',
              owner: LogOwner.home,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_dragoon_push_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 드라군 편대로 전진! 상대보다 한 발 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -2, favorsStat: 'attack',
              altText: '{away} 선수 드라군이 앞서갑니다!',
            ),
            ScriptEvent(
              text: '병력 차이가 벌어집니다! 결정적인 전진!',
              owner: LogOwner.away,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
