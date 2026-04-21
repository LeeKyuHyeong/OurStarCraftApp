part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 5해처리 히드라 vs 캐논 러시
// ----------------------------------------------------------
const _zvp5hatchHydraVsCannonRush = ScenarioScript(
  id: 'zvp_5hatch_hydra_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_5hatch_hydra', 'zvp_12hatch', 'zvp_3hatch_hydra'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '5해처리 히드라 매크로 vs 전진 캐논 러시',
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
          text: '{away} 선수 포지를 빠르게 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 포지 건설! 캐논 러시인가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브가 저그 앞마당으로 이동합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{away} 선수, 프로브가 접근합니다! 전진 캐논!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런을 저그 앞마당 근처에 건설! 캐논 러시입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 전진 파일런! 캐논을 세울 자리를 확보합니다!',
        ),
      ],
    ),
    // Phase 1: 캐논 공방 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논이 완성됩니다! 앞마당 해처리를 포격합니다!',
          owner: LogOwner.away,
          awayResource: 0,
          awayArmy: 5, homeArmy: -1, homeResource: -15,          altText: '{away} 선수, 캐논 완성! 해처리가 맞기 시작합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성! 저글링으로 프로브를 쫓습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -10,          altText: '{home} 선수, 저글링 등장! 캐논 주변 프로브를 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 캐논 건설! 저글링도 막아냅니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 4, homeArmy: -1,        ),
        ScriptEvent(
          text: '캐논 화력이 무섭습니다! 저그가 버틸 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 드론을 동원해 버텨봅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 1, homeResource: -5,        ),
      ],
    ),
    // Phase 2: 공방 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논이 앞마당 해처리를 집중 포격합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayResource: 0,
          awayArmy: 3, homeResource: -15,          altText: '{away} 선수, 캐논 포격! 해처리 체력이 빠르게 줄어듭니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 캐논 주변에 보내봅니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: -1,          altText: '{home} 선수, 저글링! 캐논 주변 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라리스크로 역전을 노립니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -20,        ),
        ScriptEvent(
          text: '캐논이 자리를 잡을수록 저그의 탈출은 어려워집니다!',
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
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라리스크가 나오면서 캐논을 원거리 사격으로 제거합니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3, awayArmy: -4,              altText: '{home} 선수, 히드라리스크 사거리로 캐논을 안전하게 처리합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라 물량이 프로토스 본진까지 밀어붙입니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,            ),
            ScriptEvent(
              text: '{away} 선수 드라군을 급히 뽑지만 이미 늦었습니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '캐논 러시 실패! 히드라가 승리를 가져갑니다!',
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
          baseProbability: 2.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -2, homeResource: -25,              altText: '{away} 선수, 캐논 화력! 해처리가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 캐논을 본진 입구까지 올립니다! 저그가 갇힙니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 3, homeArmy: -3,
            ),
            ScriptEvent(
              text: '{home} 선수 탈출을 시도하지만 캐논 포위망에 걸립니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -3, homeResource: -15,
            ),
            ScriptEvent(
              text: '캐논이 저그를 완전히 봉쇄합니다! 캐논 러시 성공!',
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
