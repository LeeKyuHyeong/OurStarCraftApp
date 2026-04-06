part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 캐논 러쉬 (치즈 vs 치즈)
// ----------------------------------------------------------
const _zvp4poolVsCannonRush = ScenarioScript(
  id: 'zvp_4pool_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '4풀 저글링 러시 vs 캐논 러쉬 - 타이밍 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 4풀! 극초반 러시 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 보내 저그 앞마당 근처에 포지를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 전진 포지! 캐논 러쉬를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 부화합니다! 6마리가 나옵니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 전진 캐논 건설을 시작합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 캐논이 올라갑니다! 완성되기 전에 저글링이 올까요?',
        ),
        ScriptEvent(
          text: '저글링과 캐논의 타이밍 싸움! 누가 먼저 완성되느냐!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 중반 충돌 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 캐논 완성 전에 도착! 프로브를 공격합니다!',
          owner: LogOwner.home,
          awayResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 저글링이 건설 중인 프로브를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브로 저글링을 막으면서 캐논 완성을 기다립니다!',
          owner: LogOwner.away,
          homeArmy: -1, awayResource: -5,
          altText: '{away}, 프로브 방벽! 캐논이 곧 완성됩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 건설 중인 캐논을 집중 공격합니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away}, 두 번째 캐논까지 건설하려 합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away} 선수 추가 캐논! 방어선을 강화하려 합니다!',
        ),
      ],
    ),
    // Phase 2: 후반 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 추가 저글링을 보내면서 캐논을 부수려 합니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 저글링 웨이브! 캐논을 집중 타격!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논이 저글링을 잡고 있지만 수가 부족합니다!',
          owner: LogOwner.away,
          homeArmy: -2, awayArmy: 1,
        ),
        ScriptEvent(
          text: '캐논 한 기로 이 물량을 막을 수 있을까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 발업 연구까지 완료! 저글링이 더 빨라졌습니다!',
          owner: LogOwner.home,
          homeArmy: 2, favorsStat: 'control',
          altText: '{home}, 발업 저글링! 캐논 사이를 파고듭니다!',
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
              text: '{home}, 저글링이 캐논을 부수고 프로토스 본진으로 진입합니다!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -20, favorsStat: 'attack',
              altText: '{home} 선수 캐논 파괴! 프로토스 본진이 뚫립니다!',
            ),
            ScriptEvent(
              text: '캐논 러쉬 실패! 저글링이 프로토스를 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{away}, 캐논이 완성되면서 저글링을 전부 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: 2, favorsStat: 'defense',
              altText: '{away} 선수 캐논 완성! 저글링이 녹습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논이 저그 앞마당 입구를 봉쇄합니다!',
              owner: LogOwner.away,
              homeResource: -20, awayArmy: 2,
            ),
            ScriptEvent(
              text: '캐논 러쉬 성공! 저그 앞마당이 봉쇄됩니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
