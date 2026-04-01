part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 7. 973 히드라 전용 (빠른 히드라 올인)
// ----------------------------------------------------------
const _zvp973HydraRush = ScenarioScript(
  id: 'zvp_973_hydra_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_973_hydra', 'zvp_trans_973_hydra'],
  awayBuildIds: ['pvz_forge_cannon', 'pvz_corsair_reaver',
                 'pvz_trans_forge_expand', 'pvz_trans_corsair'],
  description: '973 히드라 빠른 올인 압박',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9서플 7가스 3해처리로 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 973 오프닝! 가스를 일찍 넣습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 포지 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설! 동시에 해처리 추가!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 스포닝풀과 해처리를 동시에! 빠른 테크 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 앞마당 넥서스 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 가스가 빨라서 히드라가 일찍 나옵니다!',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 히드라덴이 빠릅니다! 973 빌드의 핵심!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 캐논으로 입구를 막습니다.',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 게이트웨이와 캐논으로 입구 심시티! 저글링을 대비합니다.',
        ),
      ],
    ),
    // Phase 1: 빠른 히드라 등장 (lines 15-24)
    ScriptPhase(
      name: 'fast_hydra',
      startLine: 15,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라 속업과 사업 동시 연구! 빠릅니다!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -25,
          altText: '{home}, 히드라 업그레이드가 빠르게 올라갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성 후 스타게이트를 올리지만 커세어가 늦을 수 있습니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 사이버네틱스 코어와 스타게이트 건설! 하지만 타이밍이 늦을 수 있습니다!',
        ),
        ScriptEvent(
          text: '{home}, 히드라 편대가 빠르게 모입니다! 프로토스 앞마당으로!',
          owner: LogOwner.home,
          homeArmy: 4, favorsStat: 'attack',
          altText: '{home} 선수 히드라 행군! 973의 빠른 타이밍!',
        ),
        ScriptEvent(
          text: '973 빌드의 히드라 타이밍이 굉장히 빠릅니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 히드라 압박 결과 - 분기 (lines 25-40)
    ScriptPhase(
      name: 'hydra_timing',
      startLine: 25,
      branches: [
        // 분기 A: 히드라 타이밍 성공
        ScriptBranch(
          id: 'hydra_timing_hit',
          baseProbability: 1.1,
          events: [
            ScriptEvent(
              text: '{home}, 히드라가 캐논 라인을 두드립니다! 커세어가 아직 없어요!',
              owner: LogOwner.home,
              awayArmy: -3, awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 히드라 공격! 캐논만으로는 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿과 캐논으로 막으려 하지만 히드라 화력에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              altText: '{away}, 수비가 밀리고 있습니다! 타이밍이 너무 빨랐어요!',
            ),
            ScriptEvent(
              text: '{home}, 히드라가 앞마당 진입! 프로브가 도망칩니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '973 타이밍이 적중! 프로토스 앞마당이 흔들립니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
        // 분기 B: 캐논과 질럿 방어 성공
        ScriptBranch(
          id: 'cannon_zealot_hold',
          baseProbability: 0.9,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논 2개와 질럿으로 버팁니다! 히드라를 잡아냅니다!',
              owner: LogOwner.away,
              homeArmy: -4, awayResource: -15, favorsStat: 'defense',
              altText: '{away}, 캐논 라인이 탄탄합니다! 캐논이 압박을 막아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라 피해가 큽니다! 앞마당을 못 뚫는데요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 커세어 생산 시작! 시간을 벌었습니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -20,
            ),
            ScriptEvent(
              text: '프로토스 수비 성공! 973 타이밍을 넘겼습니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 후반 전환 (lines 41-52)
    ScriptPhase(
      name: 'late_transition',
      startLine: 41,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 멀티 해처리를 추가합니다! 물량으로 밀어붙입니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -20,
          altText: '{home}, 확장! 히드라 물량을 보충합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔과 템플러 아카이브를 올려 하이 템플러 합류! 스톰 준비!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -25,
          altText: '{away}, 아둔과 템플러 아카이브 완성! 하이 템플러가 나왔습니다! 스톰!',
        ),
        ScriptEvent(
          text: '{away}, 스톰! 스톰이 뭉쳐있던 히드라 편대를 강타합니다!',
          owner: LogOwner.away,
          homeArmy: -4, favorsStat: 'strategy',
          altText: '{away} 선수 스톰! 스톰이 히드라 편대에 치명타!',
        ),
        ScriptEvent(
          text: '{home} 선수 럴커 변태! 입구를 잡으면서 버팁니다!',
          owner: LogOwner.home,
          homeArmy: 3, awayArmy: -3, favorsStat: 'defense',
        ),
      ],
    ),
    // Phase 4: 후반 결과 - 분기 (lines 53-54)
    ScriptPhase(
      name: 'late_result',
      startLine: 53,
      branches: [
        ScriptBranch(
          id: 'hydra_quantity_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '히드라 물량이 스톰을 이겨냅니다! 저그 승리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'storm_overwhelms',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '스톰이 히드라를 쓸어버립니다! 프로토스 승리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

