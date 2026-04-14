part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 히드라 럴커 vs 2스타 커세어: 히드라 대공 vs 커세어 제공권
// ----------------------------------------------------------
const _zvpHydraLurkerVs2starCorsair = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_2star_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker', 'zvp_12pool'],
  awayBuildIds: ['pvz_2star_corsair'],
  description: '히드라 럴커 vs 2스타게이트 커세어 — 히드라 대공과 럴커 지상 장악의 대결',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 생산합니다. 앞마당도 올리구요.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 앞마당 해처리를 올리면서 일꾼을 늘립니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 후 스타게이트를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -25,
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 스타게이트까지! 커세어를 대량으로 뽑으려 합니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스타게이트가 2개! 커세어를 빠르게 쏟아낼 준비를 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 후 히드라덴으로 전환합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '스타게이트가 두 개! 오버로드 사냥이 시작될 것 같습니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 커세어 출현 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 커세어 2기가 저그 진영으로 날아갑니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{away}, 커세어가 저그 진영 상공에 도착합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 오버로드를 사냥합니다! 시야가 사라져요!',
          owner: LogOwner.away,
          homeArmy: -1,
          homeResource: -10,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산을 서두릅니다! 대공 병력이 급합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -15,
          favorsStat: 'macro',
          altText: '{home}, 히드라리스크를 급하게 뽑습니다! 커세어를 막아야 해요!',
        ),
        ScriptEvent(
          text: '{home} 선수 성큰으로 지상 방어를 보강합니다.',
          owner: LogOwner.home,
          homeArmy: 1,
          homeResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '커세어의 오버로드 사냥! 히드라가 나와야 대응이 됩니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 럴커 진화와 지상전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라리스크가 커세어를 요격합니다! 1기 격추!',
          owner: LogOwner.home,
          homeArmy: 2,
          awayArmy: -2,
          favorsStat: 'control',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드 후 럴커 진화를 시작합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'strategy',
          altText: '{home}, 레어에서 럴커 진화가 진행됩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 커세어를 더 모으면서 지상 병력도 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '히드라 대공이 커세어를 억제하고 있습니다! 럴커까지 나올까요?',
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
              text: '{home} 선수 럴커 매몰! 프로토스 지상 병력이 접근하지 못합니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -3,
              favorsStat: 'control',
              altText: '{home}, 럴커가 매몰됩니다! 가시가 지상을 지배하네요!',
            ),
            ScriptEvent(
              text: '{home} 선수 히드라리스크가 남은 커세어도 정리합니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              awayArmy: -3,
              favorsStat: 'defense',
            ),
            ScriptEvent(
              text: '{away} 선수 옵저버가 없어 럴커 위치를 찾지 못합니다!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '히드라 대공 + 럴커 지상 장악! 커세어만으로는 답이 없습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.5,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 커세어가 오버로드를 전멸시킵니다! 보급이 막혀요!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeArmy: -3,
              homeResource: -20,
              favorsStat: 'harass',
              altText: '{away}, 오버로드가 전부 잡혔습니다! 보급이 막힙니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 지상 병력이 합류합니다! 드라군이 히드라를 밀어냅니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 보급이 막혀 병력을 뽑지 못합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '커세어 제공권 장악! 오버로드 전멸로 저그가 무너집니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
