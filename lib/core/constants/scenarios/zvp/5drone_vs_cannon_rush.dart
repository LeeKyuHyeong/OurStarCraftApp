part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 캐논 러쉬 (극초반 치즈 대결)
// ----------------------------------------------------------
const _zvp5droneVsCannonRush = ScenarioScript(
  id: 'zvp_5drone_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '9투 올인 저글링 vs 캐논 러쉬 - 치즈 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 5마리 후 스포닝풀을 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 스포닝풀 건설 시작! 저글링 올인을 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 보내 저그 근처에 포지를 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 발업도 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -15,
          altText: '{home}, 저글링 발업! 캐논이 완성되기 전에 잡아야 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 캐논을 건설합니다! 저그 앞마당 근처!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 전진 캐논! 해처리 바로 앞에 올립니다!',
        ),
        ScriptEvent(
          text: '양쪽 다 치즈입니다! 누가 먼저 상대를 무너뜨리느냐!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 교전 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 건설 중인 캐논으로 달려갑니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링으로 캐논 건설을 방해합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브로 저글링을 막으면서 캐논을 지킵니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,          altText: '{away}, 프로브 방어! 캐논이 곧 완성됩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 건설 중인 프로브를 집중 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,        ),
        ScriptEvent(
          text: '{away}, 두 번째 캐논도 건설하려 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,
          altText: '{away} 선수 추가 캐논 건설! 방어망을 확장합니다!',
        ),
        ScriptEvent(
          text: '캐논이 완성되면 저글링으로는 힘들어집니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 공방 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 발업 완료! 저글링이 빨라져서 프로브를 추격합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: 2, awayResource: -10,          altText: '{home}, 발업 저글링! 프로브를 잡으면서 캐논을 무시합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논으로 저글링을 잡으려 하지만 수가 부족합니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2, awayArmy: 1,
        ),
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 본진까지 진입합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home} 선수 본진 침투! 저글링이 일꾼을 몰아세웁니다!',
        ),
        ScriptEvent(
          text: '{away}, 캐논을 저그 본진 근처에 추가로 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -10, awayArmy: 1,
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
          events: [
            ScriptEvent(
              text: '{home}, 저글링이 프로브를 전멸시키고 건물을 부수기 시작합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -3,              altText: '{home} 선수 프로브 전멸! 캐논만 남았습니다!',
            ),
            ScriptEvent(
              text: '전진 캐논 실패! 저글링이 프로토스를 밀어붙입니다!',
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
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 캐논이 해처리 근처까지 완성되면서 저그를 압박합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -3, homeResource: -20,              altText: '{away} 선수 캐논 포위! 해처리가 캐논 사정거리 안!',
            ),
            ScriptEvent(
              text: '캐논이 해처리를 직접 공격합니다! 캐논 러쉬 성공!',
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
