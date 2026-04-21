part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 커세어 운영 (치즈 vs 밸런스)
// ----------------------------------------------------------
const _zvp4poolVsCorsair = ScenarioScript(
  id: 'zvp_4pool_vs_corsair',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_4pool'],
  awayBuildIds: ['pvz_trans_corsair'],
  description: '4풀 저글링 올인 vs 커세어 운영 빌드',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 4드론에 스포닝풀! 바로 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home}, 극초반 스포닝풀! 저글링 러시를 준비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이와 사이버네틱스 코어를 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6마리 부화! 프로토스 본진으로 출발!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 5, homeResource: -10,
          altText: '{home}, 저글링이 쏟아집니다! 돌격 개시!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타게이트를 건설하려 했지만, 지상 수비가 먼저입니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
          altText: '{away}, 질럿을 먼저 뽑아야 합니다! 커세어는 나중!',
        ),
      ],
    ),
    // Phase 1: 러시 도착 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 저글링이 프로토스 앞마당에 도착합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: 1,          altText: '{home} 선수 저글링 돌진! 질럿이 아직 적습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿 한 기와 프로브로 수비합니다!',
          owner: LogOwner.away,
          awayArmy: 0,
          homeResource: 0,
          homeArmy: -1, awayResource: -5,          altText: '{away}, 프로브까지 동원! 시간을 벌어야 합니다!',
        ),
        ScriptEvent(
          text: '스타게이트에 자원을 쓴 만큼 지상 유닛이 부족합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 프로브를 집중 공격하면서 일꾼을 줄입니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -10,        ),
        ScriptEvent(
          text: '{away}, 추가 질럿이 나오면서 반격합니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2, homeArmy: -2,          altText: '{away} 선수 질럿 합류! 저글링을 잡기 시작합니다!',
        ),
      ],
    ),
    // Phase 2: 후속 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 추가 저글링을 계속 보냅니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -10,
          altText: '{home}, 저글링 물량! 멈추지 않습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 질럿을 모아서 입구를 봉쇄합니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2, homeArmy: -1,        ),
        ScriptEvent(
          text: '{home}, 저글링이 입구에서 막히고 있습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          homeArmy: -2,
          altText: '{home} 선수 입구 봉쇄에 저글링이 녹고 있습니다!',
        ),
        ScriptEvent(
          text: '{away}, 스타게이트에서 커세어가 마침내 나옵니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -10,
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
              text: '{home}, 저글링이 수비 틈을 뚫고 넥서스까지 도달합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -20, awayArmy: -2,              altText: '{home} 선수 넥서스 공격! 프로토스가 흔들립니다!',
            ),
            ScriptEvent(
              text: '커세어가 나왔지만 이미 늦었습니다! 저글링 러시 성공!',
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
              text: '{away}, 질럿이 저글링을 전부 잡고 커세어로 오버로드를 사냥합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -5, awayArmy: 2,              altText: '{away} 선수 오버로드 사냥! 저그의 시야가 사라집니다!',
            ),
            ScriptEvent(
              text: '수비 성공 후 커세어 운영! 프로토스가 하늘을 장악합니다!',
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
