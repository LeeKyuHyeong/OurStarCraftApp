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
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 빠르게 건설합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지 건설! 캐논 러시인가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브가 저그 앞마당으로 이동합니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 프로브가 접근합니다! 전진 캐논!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{away} 선수 파일런을 저그 앞마당 근처에 건설! 캐논 러시입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 전진 파일런! 캐논을 세울 자리를 확보합니다!',
        ),
      ],
    ),
    // Phase 1: 캐논 공방 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논 건설 시작! 앞마당 해처리를 겨냥합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
          altText: '{away}, 캐논이 올라갑니다! 해처리가 사정거리 안!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 캐논을 막으려 합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -5, favorsStat: 'scout',
          altText: '{home}, 드론 동원! 캐논 건설을 방해합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성! 저글링으로 프로브를 쫓습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'control',
          altText: '{home}, 저글링 등장! 프로브를 잡으러 갑니다!',
        ),
        ScriptEvent(
          text: '캐논 러시를 막느냐 못 막느냐! 앞마당의 운명이 걸렸습니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away}, 캐논 추가 건설! 화력을 집중합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
        ),
      ],
    ),
    // Phase 2: 매크로 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 캐논을 막아내고 해처리를 추가합니다! 매크로 확장!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 캐논 수비 성공! 해처리를 더 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 히드라리스크를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 캐논 러시 실패 후 뒤늦게 넥서스를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 뒤늦은 넥서스! 자원 손실이 큽니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 5해처리 체제 완성! 히드라 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25, favorsStat: 'macro',
          altText: '{home}, 히드라가 쏟아집니다! 5해처리의 위력!',
        ),
        ScriptEvent(
          text: '캐논 러시 실패 후 자원 차이가 벌어지고 있습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
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
              text: '{home} 선수 히드라 편대가 전진합니다! 캐논을 부수며 진격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -3, favorsStat: 'attack',
              altText: '{home}, 히드라가 캐논을 쓸어버립니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라 물량이 프로토스 본진까지 밀어붙입니다!',
              owner: LogOwner.home,
              awayArmy: -4, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군을 급히 뽑지만 이미 늦었습니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1,
            ),
            ScriptEvent(
              text: '캐논 러시 실패! 5해처리 히드라가 승리를 가져갑니다!',
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
              text: '{away} 선수 캐논이 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.away,
              homeArmy: -2, homeResource: -20, favorsStat: 'attack',
              altText: '{away}, 캐논 화력! 해처리가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away}, 캐논을 본진 입구까지 올립니다! 저그가 갇힙니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 탈출을 시도하지만 캐논 포위망에 걸립니다!',
              owner: LogOwner.home,
              homeArmy: -3, homeResource: -15,
            ),
            ScriptEvent(
              text: '캐논이 저그를 완전히 봉쇄합니다! 캐논 러시 성공!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
