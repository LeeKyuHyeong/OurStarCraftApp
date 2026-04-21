part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 포지 확장 (치즈 vs 밸런스)
// ----------------------------------------------------------
const _zvp4poolVsForgeExpand = ScenarioScript(
  id: 'zvp_4pool_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_trans_forge_expand', 'pvz_forge_cannon'],
  description: '4풀 저글링 러시 vs 포지 확장 캐논 방어',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4마리에서 스포닝풀을 올립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 4드론에 스포닝풀! 역대급으로 빠릅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 건설하고 앞마당 넥서스를 준비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away}, 포지를 먼저 올리고 앞마당 확장! 캐논으로 수비하려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리 부화! 프로토스 앞마당으로!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 캐논을 건설합니다! 제때 완성될까요?',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away}, 캐논 건설을 서두릅니다! 입구를 막아야 해요!',
        ),
        ScriptEvent(
          text: '극초반 저글링 러시 vs 캐논 수비! ZvP 클래식 대결입니다!',
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
          text: '{home}, 저글링이 프로토스 앞마당에 도착합니다! 캐논이 미완성!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 도착! 캐논이 아직 안 됐습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 모아서 저글링을 막습니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,          altText: '{away}, 프로브 방벽! 캐논 완성까지 버텨야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 프로브를 우선 공격합니다! 일꾼이 줄어듭니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,        ),
        ScriptEvent(
          text: '{away}, 캐논이 간신히 완성됩니다! 저글링을 잡기 시작!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2, awayArmy: 2,          altText: '{away} 선수 캐논 완성! 저글링에 데미지를 줍니다!',
        ),
        ScriptEvent(
          text: '캐논 1기로 저글링 물량을 감당할 수 있을까요?',
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
          text: '{home} 선수 추가 저글링을 보냅니다! 캐논을 집중 공격!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,          altText: '{home}, 저글링 웨이브! 캐논을 부수려 합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 캐논을 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: -10, awayArmy: 1,
          altText: '{away}, 추가 캐논! 방어선을 강화합니다!',
        ),
        ScriptEvent(
          text: '{home}, 발업 연구 완료! 저글링이 빨라졌습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,        ),
        ScriptEvent(
          text: '{away}, 게이트웨이에서 질럿까지 생산하기 시작합니다!',
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
              text: '{home}, 저글링이 캐논을 부수고 넥서스까지 공격합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -3, awayResource: -20,              altText: '{home} 선수 캐논 파괴! 앞마당이 무너집니다!',
            ),
            ScriptEvent(
              text: '캐논 수비 실패! 극초반 저글링의 승리!',
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
              text: '{away}, 캐논과 질럿이 저글링을 전부 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 3,              altText: '{away} 선수 완벽한 수비! 캐논과 질럿 조합!',
            ),
            ScriptEvent(
              text: '포지 확장 수비 성공! 프로토스의 병력이 저그를 압도합니다!',
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
