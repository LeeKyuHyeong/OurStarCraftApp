part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 5팩 타이밍 vs 원팩 확장
// ----------------------------------------------------------
const _tvt5facVs1facExpand = ScenarioScript(
  id: 'tvt_5fac_vs_1fac_expand',
  matchup: 'TvT',
  homeBuildIds: ['tvt_5fac'],
  awayBuildIds: ['tvt_1fac_expand'],
  description: '5팩 타이밍 vs 원팩 확장 공수 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설합니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 빠르게 증설합니다! 3개째!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 팩토리가 빠르게 늘어납니다! 타이밍을 노리나요?',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 앞마당 확장도 가져갑니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 팩토리가 올라갑니다! 확장도 같이!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 뽑으면서 마인을 깔고 있습니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away}, 마인 매설! 수비적으로 운영합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구 시작! 팩토리 5개 체제! 탱크 벌처 대량 생산!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -30,
          altText: '{home}, 머신샵에서 시즈 연구! 5팩토리 풀가동! 병력이 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 커맨드센터! 마인으로 시간을 벌면서!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 트리플 확장! 자원을 최대한 끌어올립니다!',
        ),
      ],
    ),
    // Phase 1: 중반 준비 (lines 17-24)
    ScriptPhase(
      name: 'mid_preparation',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 머신샵 부착! 시즈 모드 연구!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 머신샵에서 시즈 연구! 탱크가 본격 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 머신샵 부착! 벌처 마인도 연구합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 머신샵에서 마인 연구! 수비 준비!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 생산이 시작됩니다! 팩토리 5개에서 쏟아집니다!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -30,
          altText: '{home} 선수 5팩 풀가동! 탱크가 쏟아져 나옵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 벌처로 센터를 장악합니다! 마인 매설!',
          owner: LogOwner.away,
          awayArmy: 2, favorsStat: 'scout',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트 건설! 컨트롤타워 올립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 스타포트 건설 후 컨트롤타워! 드랍십을 대비합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 엔지니어링 베이 건설! 터렛을 올립니다!',
          owner: LogOwner.away,
          awayResource: -10,
          altText: '{away}, 엔지니어링 베이에 터렛! 드랍 대비!',
        ),
        ScriptEvent(
          text: '{home} 선수 병력이 모이고 있습니다! 곧 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
        ),
        ScriptEvent(
          text: '{away} 선수 아머리 건설! 업그레이드를 시작합니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 아머리에서 메카닉 업그레이드!',
        ),
      ],
    ),
    // Phase 2: 5팩 타이밍 (lines 26-30)
    ScriptPhase(
      name: 'timing_push',
      startLine: 26,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 5팩토리 물량이 전진합니다! 탱크 8기!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home} 선수 대규모 전진! 탱크 라인이 밀려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마인 지대에서 수비 준비! 탱크도 배치!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 벌처로 시야 확보! 상대 탱크 위치를 먼저 파악합니다!',
          owner: LogOwner.home,
          awayArmy: -1, favorsStat: 'strategy+scout',
          altText: '{home}, 시즈 탱크 거리재기! 시야 싸움에서 앞서갑니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처를 보내 상대 병력을 확인합니다!',
          owner: LogOwner.away,
          favorsStat: 'scout',
          altText: '{away}, 벌처 정찰! 상대 병력을 파악합니다!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 포격 사거리 안에 들어왔습니다!',
          owner: LogOwner.home,
          homeArmy: 1, favorsStat: 'attack',
          altText: '{home} 선수 탱크 시즈! 사거리 안에 들어왔습니다!',
        ),
        ScriptEvent(
          text: '5팩 타이밍 vs 원팩 확장 수비! 공수 대결의 시작!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 3: 교전 - 분기 (lines 32+)
    ScriptPhase(
      name: 'clash',
      startLine: 32,
      branches: [
        ScriptBranch(
          id: 'timing_breaks_through',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벌처로 마인 지대를 정찰합니다!',
              owner: LogOwner.home,
              favorsStat: 'scout',
              altText: '{home} 선수 벌처 정찰! 마인 위치를 확인합니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 화력이 마인 지대를 뚫습니다! 벌처 돌진!',
              owner: LogOwner.home,
              awayArmy: -3, homeArmy: -2, favorsStat: 'attack',
              altText: '{home} 선수 탱크 시즈 포격! 마인 라인 돌파!',
            ),
            ScriptEvent(
              text: '{away} 선수 수비 라인이 밀리고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 탱크 라인 전진! 시즈 모드로 상대 건물까지 포격!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'attack',
              altText: '{home} 선수 탱크 전진! 상대 앞마당을 위협합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 병력이 녹고 있습니다! 탱크 물량 차이가 납니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 벌처를 보내 역습을 시도하지만 마인에 벌처가 터집니다!',
              owner: LogOwner.away,
              awayArmy: -1,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 5팩 물량으로 마인 라인을 돌파합니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 탱크 시즈 포격! 상대 수비선을 무너뜨립니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'mine_defense_holds',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 마인에 벌처가 터집니다! 진격이 멈추는데요!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{away} 선수 마인 폭발! 벌처가 증발합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 병력 손실! 탱크도 피해를 입었습니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away} 선수 아머리 건설! 골리앗을 준비합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 확장 자원 우위! 탱크 골리앗이 쌓입니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 마인과 확장 자원으로 5팩 타이밍을 버텨냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -3,
              decisive: true,
              altText: '{away} 선수 트리플 자원 가동! 물량 역전에 성공합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
