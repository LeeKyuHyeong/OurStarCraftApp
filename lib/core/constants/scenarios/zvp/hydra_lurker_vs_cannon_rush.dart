part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 히드라 럴커 vs 캐논 러시: 캐논 실패 시 럴커가 지배
// ----------------------------------------------------------
const _zvpHydraLurkerVsCannonRush = ScenarioScript(
  id: 'zvp_hydra_lurker_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_hydra_lurker'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '히드라 럴커 vs 캐논 러시 — 캐논 러시 실패 시 럴커 장악력이 압도하는 구도',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 생산합니다.',
          owner: LogOwner.home,
          homeResource: 10,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 먼저 건설합니다! 캐논 빌드 냄새가 나네요!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 포지가 올라갑니다! 일반적인 타이밍은 아닙니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 저그 앞마당으로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설 중! 오버로드가 정찰을 나갑니다.',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스포닝풀이 올라가면서 오버로드를 보냅니다.',
        ),
        ScriptEvent(
          text: '프로토스 프로브가 저그 진영을 향합니다! 캐논 러시를 노리는 걸까요?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 캐논 러시 전개 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 저그 앞마당에 파일런을 숨겨 건설합니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'harass',
          altText: '{away}, 파일런이 저그 앞마당 구석에 세워집니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논 건설 시작! 해처리를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 캐논 건설을 방해합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          awayArmy: -1,
          favorsStat: 'scout',
          altText: '{home}, 드론이 프로브를 쫓아갑니다! 캐논을 막아야 해요!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산! 프로브를 잡으러 갑니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          favorsStat: 'control',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '캐논이 완성되느냐! 드론이 막느냐! 컨트롤 싸움입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 히드라 럴커 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 히드라덴 건설! 캐논 정리를 위해 히드라리스크를 뽑습니다!',
          owner: LogOwner.home,
          homeResource: -20,
          favorsStat: 'macro',
          altText: '{home}, 히드라덴이 올라갑니다! 캐논에 대한 해답이죠!',
        ),
        ScriptEvent(
          text: '{away} 선수 캐논을 추가로 세워 방어선을 확장합니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라리스크 생산 시작! 캐논보다 사거리가 깁니다!',
          owner: LogOwner.home,
          homeArmy: 4,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '히드라리스크가 나오면 캐논 정리가 가능합니다! 타이밍 문제네요!',
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
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 히드라리스크로 캐논을 하나씩 깨뜨립니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'control',
              altText: '{home}, 히드라리스크 사거리로 캐논을 안전하게 처리합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 럴커 진화! 매몰로 프로토스 진격로를 차단합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 병력이 부족합니다! 캐논에 자원을 너무 썼어요!',
              owner: LogOwner.away,
              awayArmy: -2,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '캐논 러시 실패! 히드라 럴커가 맵을 장악합니다! GG!',
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
              text: '{away} 선수 캐논이 해처리 사정거리 안에 들어갑니다! 때리기 시작해요!',
              owner: LogOwner.away,
              awayArmy: 2,
              homeResource: -25,
              favorsStat: 'attack',
              altText: '{away}, 캐논이 완성됐습니다! 해처리를 타격하기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론을 뺄 수밖에 없습니다! 일꾼 피해가 심각해요!',
              owner: LogOwner.home,
              homeResource: -20,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논으로 앞마당을 완전히 봉쇄합니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeResource: -15,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '캐논 러시 성공! 저그 앞마당이 무너졌습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
