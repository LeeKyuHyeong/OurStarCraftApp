part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 야바위 vs 커세어: 지상 기만 vs 커세어 정찰 — 페이크를 간파할 수 있나
// ----------------------------------------------------------
const _zvpYabarwiVsCorsair = ScenarioScript(
  id: 'zvp_yabarwi_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_yabarwi'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '야바위 기만 전술 vs 커세어+지상 — 커세어 정찰이 페이크를 간파하는가',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올리고 드론을 뽑습니다.',
          owner: LogOwner.home,
          homeResource: 10,
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 건설합니다. 커세어 준비!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스타게이트 건설! 커세어 체제로 전환!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 올립니다. 럴커 전환을 준비합니다.',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 나옵니다! 오버로드를 추격하기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '커세어가 정찰에 나섭니다! 저그의 움직임을 포착할 수 있을까!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 커세어 정찰 vs 기만 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어로 저그 진영을 정찰합니다! 히드라덴이 보입니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 커세어 정찰! 저그 테크를 확인합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링을 센터로 보내 가짜 공격을 시도합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'strategy',
          altText: '{home}, 저글링 기습! 하지만 본공격은 아닙니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 럴커를 별도 루트로 이동시킵니다. 진짜 공격은 여기!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 생산하며 지상 병력을 보충합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '커세어의 시야 vs 야바위의 기만! 정보전이 펼쳐집니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 교전 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 3방향으로 분산시킵니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          favorsStat: 'harass',
          altText: '{home}, 저글링 3방향 분산! 어디가 진짜인가!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 저글링 이동을 포착합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 럴커를 프로토스 확장기지 방향으로 은밀히 이동합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          favorsStat: 'strategy',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '커세어의 눈을 속일 수 있느냐! 야바위의 핵심 순간입니다!',
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
              text: '{home} 선수 럴커가 프로토스 확장기지를 기습합니다! 캐논이 없는 곳!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -4,
              favorsStat: 'strategy',
              altText: '{home}, 럴커 기습! 방어가 없는 확장기지를 급습합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 동시에 본진 프로브를 잡습니다!',
              owner: LogOwner.home,
              awayResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{away} 선수 커세어가 보고는 있지만 지상을 막을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '커세어의 정찰을 속였습니다! 야바위 전술 대성공! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'scout',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 럴커 이동 경로를 포착합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              favorsStat: 'scout',
              altText: '{away}, 커세어가 럴커를 발견했습니다! 드라군을 보냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 럴커를 사정거리 밖에서 처리합니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -5,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{home} 선수 페이크가 들통났습니다! 병력이 분산된 상태에서 역공!',
              owner: LogOwner.home,
              homeArmy: -4,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '커세어의 정찰이 야바위를 간파합니다! 프로토스 역습! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
