part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5드론 vs 포지 확장 (올인 vs 밸런스)
// ----------------------------------------------------------
const _zvp5droneVsForgeExpand = ScenarioScript(
  id: 'zvp_5drone_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_5drone'],
  awayBuildIds: ['pvz_trans_forge_expand', 'pvz_forge_cannon'],
  description: '9투 올인 저글링 vs 포지 확장 캐논 방어',
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
          text: '{away} 선수 포지를 먼저 올리고 앞마당 넥서스를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 포지 확장! 캐논으로 앞마당을 지키려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 발업도 연구!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 캐논을 올리기 시작합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 캐논 건설을 서두릅니다! 빨리 완성해야 합니다!',
        ),
        ScriptEvent(
          text: '캐논 수비 vs 저글링 물량! ZvP 클래식 구도!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 발업 저글링이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 돌진! 캐논이 완성됐을까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논이 거의 완성됩니다! 프로브로 시간을 법니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,          altText: '{away}, 프로브 방벽! 캐논까지 몇 초만 버텨야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 프로브를 우선 잡으면서 일꾼을 줄입니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,        ),
        ScriptEvent(
          text: '{away}, 캐논 완성! 저글링을 잡기 시작합니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2, awayArmy: 2,          altText: '{away} 선수 캐논 가동! 저글링에 데미지를 줍니다!',
        ),
        ScriptEvent(
          text: '캐논이 완성됐지만 저글링 수가 많습니다! 막을 수 있을까요?',
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
          text: '{home} 선수 추가 저글링을 보냅니다! 캐논을 집중 타격!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,          altText: '{home}, 저글링 웨이브! 캐논을 부수려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 캐논을 건설하면서 방어선을 확장합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -10, awayArmy: 1,
          altText: '{away}, 두 번째 캐논! 방어선이 넓어집니다!',
        ),
        ScriptEvent(
          text: '{home}, 발업 저글링이 캐논 사이를 파고듭니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수 저글링 컨트롤! 캐논 사각지대를 노립니다!',
        ),
        ScriptEvent(
          text: '{away}, 게이트웨이에서 질럿이 나오기 시작합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
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
              text: '{home}, 저글링이 캐논을 파괴하고 넥서스를 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -3, awayResource: -20,              altText: '{home} 선수 캐논 파괴! 앞마당 넥서스가 위험합니다!',
            ),
            ScriptEvent(
              text: '캐논 수비 실패! 저글링 물량의 승리!',
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
              text: '{away}, 캐논과 질럿으로 저글링을 전부 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 3,              altText: '{away} 선수 완벽한 수비! 캐논과 질럿 방어선!',
            ),
            ScriptEvent(
              text: '캐논 수비 성공! 드론이 부족한 저그를 압도합니다!',
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
