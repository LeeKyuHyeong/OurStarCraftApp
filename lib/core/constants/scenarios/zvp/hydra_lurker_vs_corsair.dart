part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 히드라 럴커 vs 커세어 지상: 히드라 대공 + 럴커 지상 방어
// ----------------------------------------------------------
const _zvpHydraLurkerVsCorsair = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_12pool'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '히드라 럴커 vs 커세어+지상 — 커세어가 럴커를 감지하지만 처치는 못하는 구도',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리와 앞마당을 올립니다. 표준 오프닝이네요.',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 건설합니다! 커세어를 준비합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타게이트가 올라갑니다! 커세어를 뽑을 준비를 하네요!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 올려 히드라리스크를 준비합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'strategy',
          altText: '{home}, 히드라덴 건설! 대공과 지상 모두 커버하겠다는 거죠!',
        ),
        ScriptEvent(
          text: '{away} 선수 넥서스 확장과 게이트웨이 추가 건설을 병행합니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '커세어와 지상 병력을 병행하는 프로토스! 히드라 럴커로 대응할 수 있을까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 커세어 견제와 히드라 대공 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어가 저그 상공을 돌아다닙니다! 오버로드를 노려요!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크가 커세어를 쫓아냅니다! 대공 사격!',
          owner: LogOwner.home,
          homeArmy: 4,
          awayArmy: -1,
          homeResource: -15,
          favorsStat: 'defense',
          altText: '{home}, 히드라리스크가 커세어에 대공 사격을 가합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿과 드라군을 모아 지상 공격을 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'macro',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드 중! 럴커를 대비합니다!',
          owner: LogOwner.home,
          homeResource: -20,
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '히드라로 하늘을 막고 럴커로 땅을 막는다! 과연 통할까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 전개와 지상 대치 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 럴커 진화 완료! 앞마당 앞에 매몰합니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
          favorsStat: 'control',
          altText: '{home}, 럴커가 매몰됩니다! 지상 접근을 차단하네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어가 럴커 위치를 밝혀냅니다! 하지만 공격은 못 해요!',
          owner: LogOwner.away,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 지상 병력을 집결시킵니다. 사이버네틱스 코어에서 나온 드라군과 질럿이 전진해요.',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          altText: '{away}, 드라군 물량이 상당합니다! 럴커를 처리할 수 있을까요?',
        ),
        ScriptEvent(
          text: '커세어가 럴커를 보여주지만 처치는 지상 병력의 몫입니다!',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 럴커 가시가 질럿 부대를 관통합니다! 엄청난 피해!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{home}, 럴커 가시에 질럿이 녹아내립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라리스크가 커세어를 추가로 격추합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 럴커를 잡으려 하지만 히드라 화력에 밀립니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '히드라 대공 + 럴커 지상! 완벽한 조합입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 럴커 위치를 모두 밝히고 드라군이 집중 사격!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 커세어 시야 확보! 드라군이 럴커를 정확히 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 돌파합니다! 히드라리스크를 근접에서 압도해요!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커가 정리되자 히드라만으로는 물량을 못 버팁니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '커세어 감지 + 드라군 화력! 럴커를 완전히 무력화했습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
