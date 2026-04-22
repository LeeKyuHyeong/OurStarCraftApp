part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 드라군 푸쉬 (치즈 vs 공격형)
// ----------------------------------------------------------
const _zvp4poolVsDragoonPush = ScenarioScript(
  id: 'zvp_4pool_vs_dragoon_push',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_trans_dragoon_push', 'pvz_2gate_zealot'],
  description: '4풀 저글링 러시 vs 질럿과 드라군 푸쉬',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4드론에 스포닝풀이 바로 올라갑니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 드론 4마리에서 스포닝풀 건설! 올인입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이를 건설하고 질럿 생산을 준비합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 게이트웨이 건설 시작! 질럿을 빠르게 뽑으려 합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리가 부화합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 완성! 입구에서 대기합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -10,
          altText: '{away} 선수, 첫 질럿 완성! 입구 방어 위치를 잡습니다!',
        ),
        ScriptEvent(
          text: '질럿이 있는 상태에서 저글링이 들어갈 수 있을까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수, 저글링이 프로토스 입구에 도착! 질럿과 맞닥뜨립니다!',
          owner: LogOwner.home,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -1, awayArmy: -1,          altText: '{home} 선수 저글링 돌진! 질럿과 교전!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿이 입구를 막고 저글링을 잡습니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,          altText: '{away} 선수, 질럿이 입구를 틀어막습니다! 저글링이 힘들어요!',
        ),
        ScriptEvent(
          text: '{home} 선수 프로브를 노리려 하지만 질럿 뒤로 갈 수가 없습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -1,
        ),
        ScriptEvent(
          text: '{away} 선수, 사이버네틱스 코어에서 드라군 생산을 시작합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
          altText: '{away} 선수 드라군 생산! 수비가 더 단단해집니다!',
        ),
        ScriptEvent(
          text: '드라군까지 나오면 저글링으로는 힘들어지죠.',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 후속 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 보내지만 질럿과 드라군 조합에 막힙니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -10,
          altText: '{home} 선수, 저글링 추가! 하지만 돌파가 어렵습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드라군이 원거리에서 저글링을 잡아냅니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -3, awayArmy: 1,        ),
        ScriptEvent(
          text: '{home} 선수, 발업을 연구하면서 마지막 돌파를 시도합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 발업 저글링! 마지막 기회입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수, 게이트웨이 추가 건설! 역공을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수, 발업 저글링이 틈을 뚫고 프로브를 잡습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -15, awayArmy: -2,              altText: '{home} 선수 프로브 사냥! 질럿 뒤를 파고들었습니다!',
            ),
            ScriptEvent(
              text: '일꾼 피해가 크다! 극초반 저글링의 돌파 성공!',
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
              text: '{away} 선수, 드라군이 저글링을 전멸시키고 역공을 시작합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 3,              altText: '{away} 선수 드라군 역공! 저그 본진으로 진격합니다!',
            ),
            ScriptEvent(
              text: '드라군 푸쉬! 드론이 없는 저그를 밀어냅니다!',
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
