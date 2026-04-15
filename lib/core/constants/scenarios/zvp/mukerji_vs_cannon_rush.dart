part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 캐논 러시: 캐논 파괴 후 뮤탈과 저글링 지배
// ----------------------------------------------------------
const _zvpMukerjiVsCannonRush = ScenarioScript(
  id: 'zvp_mukerji_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji', 'zvp_mukerji'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '뮤탈과 저글링 조합 vs 캐논 러시 — 캐논 파괴 후 맵 장악',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론 생산을 이어갑니다.',
          owner: LogOwner.home,
          homeResource: 10,
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 올린 뒤 프로브를 상대 진영으로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 포지 건설! 캐논 러시 준비에 들어갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저그 앞마당 근처에 파일런을 세웁니다!',
          owner: LogOwner.away,
          awayResource: -10,
          favorsStat: 'strategy',
          altText: '{away}, 파일런이 저그 진영 앞에 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론이 파일런을 발견합니다! 캐논 러시입니다!',
          owner: LogOwner.home,
          favorsStat: 'scout',
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '캐논 러시가 시작됩니다! 저그의 대응이 관건!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 캐논 공방 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논을 건설합니다! 해처리 사정거리에 들어왔습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -15,
          favorsStat: 'strategy',
          altText: '{away}, 캐논이 올라갑니다! 해처리를 노리고 있어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 캐논 건설을 방해합니다!',
          owner: LogOwner.home,
          homeResource: -10,
          awayArmy: -1,
          favorsStat: 'control',
          altText: '{home}, 드론 몰이! 캐논 건설 중인 프로브를 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 나옵니다! 캐논 주변 프로브를 잡습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '{away} 선수 추가 캐논을 올리면서 저글링을 견제합니다.',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '캐논이 완성되느냐, 저글링이 먼저 잡느냐! 초읽기입니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 공방 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논을 추가로 올려 저그 앞마당을 조이기 시작합니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20, favorsStat: 'attack',
          altText: '{away}, 추가 캐논! 포위망이 좁혀옵니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드를 서두릅니다! 스파이어로 반전을 노립니다!',
          owner: LogOwner.home,
          homeResource: -10,
          favorsStat: 'macro',
          altText: '{home}, 레어로 전환! 스파이어 건설 준비!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 건설 중! 뮤탈리스크가 나오면 다릅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '캐논이 먼저 완성되느냐, 뮤탈이 먼저 나오느냐! 타이밍 싸움입니다!',
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
          conditionStat: 'harass',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 프로토스 본진 일꾼을 덮칩니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 뮤탈리스크 프로브 학살! 자원이 끊깁니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 동시에 앞마당으로 진입합니다!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 캐논에 자원을 다 쓴 상태! 병력이 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -4,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '뮤탈과 저글링의 다방면 공격! 캐논 러시의 대가를 치릅니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'strategy',
          baseProbability: 2.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 해처리 사정거리 안에 완성됩니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeResource: -20,
              favorsStat: 'strategy',
              altText: '{away}, 캐논 완성! 해처리가 맞기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 캐논에 녹아내립니다! 병력 손실이 큽니다!',
              owner: LogOwner.home,
              homeArmy: -5,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 추가 캐논으로 포위망을 좁혀갑니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -3,
              favorsStat: 'strategy',
            ),
            ScriptEvent(
              text: '캐논 러시 성공! 저그 앞마당이 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
