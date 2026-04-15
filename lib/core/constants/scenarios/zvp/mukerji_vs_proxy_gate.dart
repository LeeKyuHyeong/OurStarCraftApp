part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 뮤커지 vs 프록시 게이트: 뮤탈과 저글링 vs 질럿 러시
// ----------------------------------------------------------
const _zvpMukerjiVsProxyGate = ScenarioScript(
  id: 'zvp_mukerji_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mukerji', 'zvp_mukerji'],
  awayBuildIds: ['pvz_proxy_gate', 'pvz_8gat'],
  description: '뮤탈과 저글링 조합 vs 프록시 질럿 러시 — 초반 수비 후 뮤탈 역습',
  phases: [
    // Phase 0: opening (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 뽑으며 자원 확보에 나섭니다.',
          owner: LogOwner.home,
          homeResource: 10,
          altText: '{home}, 드론 생산 우선! 일꾼부터 늘려갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 센터 쪽으로 보냅니다! 게이트웨이가 앞에 올라갑니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 전진 게이트웨이! 아주 공격적인 위치구요!',
        ),
        ScriptEvent(
          text: '{home} 선수 오버로드가 프로토스 본진을 정찰합니다.',
          owner: LogOwner.home,
          skipChance: 0.3,
          favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 생산 시작! 전진 건물이라 이동 거리가 짧습니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          favorsStat: 'attack',
        ),
        ScriptEvent(
          text: '전진 게이트웨이가 발견되지 않았습니다! 저그 입장에서 위험한 상황!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 초반 수비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 질럿이 저그 앞마당에 도착합니다! 드론을 노립니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'attack',
          altText: '{away}, 질럿 2기가 저그 일꾼을 공격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링으로 질럿을 감싸 안습니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          awayArmy: -2,
          favorsStat: 'control',
          altText: '{home}, 저글링 서라운드! 질럿을 잡아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성 후 성큰 건설을 시작합니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 추가 질럿을 밀어넣지만 성큰이 올라갑니다!',
          owner: LogOwner.away,
          awayArmy: 2,
          awayResource: -10,
          favorsStat: 'attack',
          skipChance: 0.25,
        ),
        ScriptEvent(
          text: '저그가 초반 질럿 러시를 버텨냅니다! 이제 뮤탈리스크가 나올 차례!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 뮤탈 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어 업그레이드 후 스파이어를 올립니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 스파이어 건설! 뮤탈리스크 준비에 들어갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 본진에서 게이트웨이를 추가로 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 3기 생산 완료! 프로토스 본진으로 날아갑니다!',
          owner: LogOwner.home,
          homeArmy: 5,
          homeResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크가 하늘을 가릅니다! 역습 시작!',
        ),
        ScriptEvent(
          text: '초반 질럿 러시를 막아낸 저그! 뮤탈리스크로 반격에 나섭니다!',
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
              text: '{home} 선수 뮤탈리스크가 프로토스 일꾼을 학살합니다!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 뮤탈리스크가 프로브를 사냥합니다! 일꾼이 녹아내려요!',
            ),
            ScriptEvent(
              text: '{away} 선수 대공 유닛이 없습니다! 전진 건물에 자원을 다 썼어요!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -10,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링까지 합류! 프로토스 앞마당을 밀어냅니다!',
              owner: LogOwner.home,
              homeArmy: 5,
              awayArmy: -5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '뮤탈과 저글링의 협공! 초반 질럿 러시 실패로 프로토스가 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          conditionStat: 'attack',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 질럿 물량이 저그 앞마당을 무너뜨립니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 질럿이 쏟아져 들어옵니다! 성큰이 부서집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나왔지만 지상 병력이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 해처리를 때립니다! 저그 자원줄이 끊깁니다!',
              owner: LogOwner.away,
              awayArmy: 4,
              homeArmy: -5,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '전진 질럿의 압도적 물량! 저그가 무너집니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
