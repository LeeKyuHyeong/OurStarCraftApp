part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 히드라 럴커 vs 아콘: 범위 공격 대결 — 스톰 vs 매몰
// ----------------------------------------------------------
const _zvpHydraLurkerVsArchon = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_archon',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_12pool'],
  awayBuildIds: ['pvz_trans_archon', 'pvz_corsair_reaver'],
  description: '히드라 럴커 vs 아콘과 질럿 — 범위 공격 대결, 사이오닉 스톰과 럴커 매몰의 승부',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올리며 일꾼을 생산합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 해처리와 드론 생산에 집중합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 후 사이버네틱스 코어를 건설합니다.',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 올립니다! 히드라리스크를 준비하는군요!',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔 건설! 질럿 다리 업그레이드를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 아둔이 올라갑니다! 템플러 테크를 노리는 건가요?',
        ),
        ScriptEvent(
          text: '아둔에서 템플러 아카이브까지! 하이템플러 테크를 가는 것 같습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 템플러 테크와 럴커 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 템플러 아카이브 건설! 하이템플러를 생산합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
          altText: '{away}, 템플러 아카이브가 완성됩니다! 하이템플러가 나오겠죠!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크를 물량으로 모으고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -20,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{away} 선수 하이템플러 2기를 아콘으로 합체합니다! 강력합니다!',
          owner: LogOwner.away,
          awayArmy: 4,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드 중! 럴커 진화가 핵심이죠!',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '아콘의 범위 공격 vs 럴커의 매몰! 양쪽 다 범위 데미지군요!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 아콘과 럴커 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 럴커 진화 완료! 전방에 배치합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{away} 선수 아콘과 질럿 조합으로 진격합니다! 하이템플러도 뒤에 있어요!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 아콘이 앞장서고 질럿이 뒤따릅니다! 하이템플러까지 합류!',
        ),
        ScriptEvent(
          text: '{away} 선수 하이템플러가 사이오닉 스톰을 준비합니다!',
          owner: LogOwner.away,
          favorsStat: 'sense',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '아콘 스플래시 vs 럴커 스파이크! 두 범위 공격의 정면 대결입니다!',
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
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커 가시가 질럿 무리를 관통합니다! 순식간에 녹아요!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 럴커 매몰 위치가 완벽합니다! 질럿이 접근조차 못 해요!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라리스크가 아콘을 집중 사격합니다! 쉴드가 깎여요!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 스톰을 쓰지만 럴커는 매몰 상태라 피해가 적습니다!',
              owner: LogOwner.away,
              homeArmy: -1,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '럴커 매몰이 아콘 조합을 완벽히 상대합니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'sense',
          events: [
            ScriptEvent(
              text: '{away} 선수 사이오닉 스톰이 히드라리스크 군단 위에 떨어집니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -5,
              favorsStat: 'sense',
              altText: '{away}, 스톰 한 방에 히드라리스크가 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 아콘이 남은 히드라를 범위 공격으로 쓸어버립니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커만 남았지만 옵저버에 위치가 드러납니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '스톰 + 아콘 스플래시! 히드라 럴커를 완전히 녹여버렸습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
