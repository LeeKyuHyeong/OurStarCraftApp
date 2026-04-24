part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 뮤탈 히드라 vs 드라군 푸시
// ----------------------------------------------------------
const _zvpMutalHydraVsDragoonPush = ScenarioScript(
  id: 'zvp_mutal_hydra_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mutal_hydra', 'zvp_2hatch_mutal', 'zvp_9overpool'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '뮤탈 견제 + 히드라 방어 vs 2게이트 드라군 푸시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 9개까지 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
          altText: '{home} 선수, 9드론까지 생산합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 2개를 가동합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away} 선수, 2게이트! 질럿부터 생산합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 사이버네틱스 코어 완성! 드라군으로 전환합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 사이버네틱스 코어! 드라군을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀과 가스를 넣으면서 레어를 향합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
        ),
      ],
    ),
    // Phase 1: 드라군 푸시 + 뮤탈 준비 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 드라군 4기가 전진합니다! 앞마당을 압박!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -20,          altText: '{away} 선수, 드라군 행군! 저그 앞마당을 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링과 성큰으로 시간을 법니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -15,          altText: '{home} 선수, 성큰 건설! 드라군을 막아야 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어 완성! 스파이어를 올리고 뮤탈리스크를 준비합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -25,
          altText: '{home} 선수, 스파이어! 뮤탈이 나오면 판이 바뀝니다!',
        ),
        ScriptEvent(
          text: '드라군 푸시를 뮤탈이 나올 때까지 버텨야 합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{away} 선수, 드라군이 성큰을 집중 사격합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,        ),
      ],
    ),
    // Phase 2: 뮤탈 견제 + 히드라 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 뮤탈리스크 5기가 프로토스 본진으로 날아갑니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: 2, awayResource: -15,          altText: '{home} 선수, 뮤탈 5기! 프로브를 견제합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수, 뮤탈이 프로브를 물어뜯습니다! 드라군이 돌아갑니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,          altText: '{home} 선수 뮤탈 견제 성공! 드라군이 후퇴합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴을 건설합니다! 히드라 생산 시작!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 4, homeResource: -20,
          altText: '{home} 선수, 히드라덴! 뮤탈과 히드라를 함께 운용!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군을 본진으로 복귀시킵니다! 뮤탈 방어!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -15,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 2.5,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 드라군을 유인하는 사이 히드라가 전진합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3,              altText: '{home} 선수, 뮤탈 유인! 히드라가 전진합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라와 뮤탈이 양방향에서 협공합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -5,              altText: '{home} 선수 양방향 공격! 드라군이 갈 곳이 없습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드라군이 양면 공격에 무너집니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '뮤탈 견제가 드라군 푸시를 완전히 무력화했습니다!',
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
              text: '{away} 선수 드라군이 뮤탈 합류 전에 앞마당을 밀어버립니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -4, homeResource: -15,              altText: '{away} 선수, 드라군 화력! 앞마당이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 드라군이 본진까지 진입합니다! 해처리를 파괴!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20, homeArmy: -2,            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈만으로는 드라군 물량을 막을 수 없습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '드라군 푸시가 뮤탈 전환을 허용하지 않았습니다!',
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
