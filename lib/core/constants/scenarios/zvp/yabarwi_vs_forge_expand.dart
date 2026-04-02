part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 야바위 vs 포지 확장: 야바위 다면 공격 vs 캐논 라인 수비
// ----------------------------------------------------------
const _zvpYabarwiVsForgeExpand = ScenarioScript(
  id: 'zvp_yabarwi_vs_forge_expand',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_yabarwi'],
  awayBuildIds: ['pvz_trans_forge_expand'],
  description: '야바위 기만 공격 vs 포지 확장 캐논 수비 — 캐논 라인을 뚫을 수 있나',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다. 드론을 돌려요.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 앞마당 해처리 완성! 자원 확보 우선!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 올리고 앞마당 넥서스를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지 확장! 캐논으로 방어를 갖추겠다는 전략!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당에 캐논 2기를 세웁니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설합니다. 럴커를 만들 준비!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '양쪽 모두 확장! 중반 이후 누가 먼저 공격하느냐가 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 기만전 vs 캐논 라인 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 프로토스 앞마당 쪽으로 보냅니다! 가짜 공격!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
          altText: '{home}, 저글링 기습! 하지만 캐논 라인 앞에서 멈춥니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논이 저글링을 잡아냅니다. 방어선이 단단합니다.',
          owner: LogOwner.away,
          homeArmy: -1,
          awayArmy: 2,
          favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{home} 선수 럴커를 완성합니다! 캐논 사각지대를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'strategy',
          altText: '{home}, 럴커 완성! 캐논을 우회할 수 있을까!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 본진 쪽으로도 한 부대 보냅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'harass',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '야바위 전술로 캐논 라인을 우회할 수 있을까!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 다면 공격 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 3해처리를 올립니다! 자원 우위를 가져갑니다!',
          owner: LogOwner.home,
          homeResource: 15,
          altText: '{home}, 3해처리 체제! 물량으로 밀어붙일 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군+질럿을 생산하며 센터로 이동합니다.',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링+럴커를 양쪽에서 동시 투입합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '다면 공격 vs 캐논+병력 방어! 프로토스 방어선의 한계가 시험됩니다!',
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
          conditionStat: 'strategy',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커가 캐논 사각지대로 진입합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home}, 럴커가 캐논을 우회합니다! 프로브가 위험!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 반대편에서 넥서스를 때립니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 양쪽을 동시에 막을 수 없습니다! 캐논 라인이 뚫렸어요!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '야바위 전술이 캐논 라인을 무력화합니다! 포지 확장이 무너집니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'defense',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 럴커 접근을 완벽히 차단합니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              awayArmy: 3,
              favorsStat: 'defense',
              altText: '{away}, 캐논 배치가 완벽합니다! 럴커가 접근하질 못해요!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군+질럿이 저글링을 막아내며 반격합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -4,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 다면 공격이 전부 막혔습니다! 자원 소모만 심해졌어요!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '캐논 라인 방어 완벽! 야바위가 통하지 않았습니다! 프로토스 반격! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
