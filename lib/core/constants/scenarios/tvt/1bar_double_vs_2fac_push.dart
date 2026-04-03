part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 1. 배럭 더블 vs 투팩 벌처
// 투팩이 팩토리 선행으로 병력 빠르게 압박, 배럭더블이 수비 후 자원 우위로 역전
// 수비 성공/실패에 따라 중반 전개가 완전히 달라지는 분기 구조
// ----------------------------------------------------------
const _tvt1barDoubleVs2facPush = ScenarioScript(
  id: 'tvt_1bar_double_vs_2fac_push',
  matchup: 'TvT',
  homeBuildIds: ['tvt_1bar_double'],
  awayBuildIds: ['tvt_2fac_push'],
  description: '배럭 더블 vs 투팩 벌처 밸런스전',
  phases: [
    // Phase 0: 오프닝 (lines 1-13)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 배럭을 건설합니다.',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 배럭을 올립니다.',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 SCV 정찰을 보냅니다!',
          owner: LogOwner.home,
          homeResource: -3,
          altText: '{home}, SCV가 상대 본진으로 향합니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당에 커맨드센터를 건설합니다! 빠른 확장!',
          owner: LogOwner.home,
          homeResource: -30,
          altText: '{home}, 앞마당 커맨드센터! 자원 우위를 가져가겠다는 의도!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설! 머신샵도 바로 붙입니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 팩토리에 머신샵! 빠른 메카닉 테크!',
        ),
        ScriptEvent(
          text: '{away} 선수 두 번째 팩토리 건설! 투팩 체제입니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 투팩! 병력 생산을 두 배로 가져갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수도 팩토리를 올립니다. 머신샵 부착!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 벌처 생산 시작! 팩토리가 먼저 올라간 만큼 병력도 빠릅니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          awayResource: -10,
          altText:
              '{away}, 벌처가 나옵니다! 배럭더블보다 팩토리가 빨랐으니 당연한 속도 차이!',
        ),
        ScriptEvent(
          text: '투팩 빌드! 병력이 상대보다 빠르게 쏟아집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 투팩 pressure (lines 14-21)
    ScriptPhase(
      name: 'twofac_pressure',
      startLine: 14,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 벌처 3기와 시즈 탱크 1기로 전진합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          favorsStat: 'attack',
          altText: '{away}, 투팩 병력이 상대 앞마당을 향합니다! 탱크까지 동행!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 벙커! 마린과 벌처로 막아봅니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 급하게 벙커를 올립니다! 마린이 들어갑니다!',
        ),
        ScriptEvent(
          text: '투팩 병력이 압도적입니다! 배럭더블이 버텨야 합니다!',
          owner: LogOwner.system,
        ),
        ScriptEvent(
          text: '{away} 선수 시즈 탱크 포격! 벙커가 녹고 있습니다!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          altText: '{away}, 시즈 포격이 벙커를 직격합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리에서 탱크가 겨우 나옵니다! 하지만 시즈 연구가 아직입니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -10,
          altText: '{home}, 첫 탱크가 나왔지만 시즈 모드가 없습니다!',
        ),
      ],
    ),
    // Phase 2: 수비 결과 분기 (lines 22-29)
    ScriptPhase(
      name: 'defense_result',
      startLine: 22,
      branches: [
        // 분기 A: 투팩 공격 성공 — 다양한 피해 양상
        ScriptBranch(
          id: 'twofac_damage',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            // 벌처 우회 → SCV 피해 (altText로 변주)
            ScriptEvent(
              text: '{away} 선수 벌처 우회! SCV를 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: -20, homeArmy: -2, awayArmy: 2,
              favorsStat: 'harass',
              altText: '{away}, 탱크 포격 사이로 벌처가 SCV를 급습합니다!',
            ),
            // SCV 피해 심화 (altText: 커맨드센터 띄우기)
            ScriptEvent(
              text: '{home} 선수 SCV 피해가 심각합니다! 앞마당 일꾼이 거의 없습니다!',
              owner: LogOwner.home,
              homeResource: -15, homeArmy: -1,
              altText: '{home} 선수 커맨드센터를 띄웁니다! 파괴는 면했지만 가동이 멈춥니다!',
            ),
            // 벙커 파괴 (altText: 본진까지 침투)
            ScriptEvent(
              text: '{away} 선수 탱크 추가 포격! 상대 벙커가 무너집니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 2,
              altText: '{away}, 벙커를 밀고 본진까지 병력이 올라갑니다!',
            ),
            // 마무리 해설 (altText로 변주)
            ScriptEvent(
              text: '투팩 공격이 큰 피해를 줬습니다! 배럭더블의 병력이 거의 없습니다!',
              owner: LogOwner.system,
              altText: '꾸역꾸역 막고 있지만 힘들어보입니다! 투팩의 압박이 거셉니다!',
            ),
          ],
        ),
        // 분기 B: 배럭더블 수비 성공 — 다양한 수비 양상
        ScriptBranch(
          id: 'double_defense',
          conditionStat: 'defense',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            // 벙커+탱크로 벌처 격파 (altText: 마인으로 벌처 잡기)
            ScriptEvent(
              text: '{home} 선수 벙커 수리! 벌처를 잡아냅니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: 2,
              favorsStat: 'defense',
              altText: '{home}, 마인이 벌처를 잡습니다! 투팩 공격이 꺾입니다!',
            ),
            // 투팩 측 피해 (altText: 탱크 후퇴)
            ScriptEvent(
              text: '{away} 선수 벌처 피해가 큽니다! 탱크까지 잃습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              altText: '{away}, 벌처를 잃고 탱크만 남습니다! 후퇴를 고민합니다!',
            ),
            // 경제 가동 (altText: SCV 복구)
            ScriptEvent(
              text: '{home} 선수 앞마당이 본격 가동됩니다! 자원 순환이 시작됩니다!',
              owner: LogOwner.home,
              homeResource: 30, homeArmy: 2,
              altText: '{home}, SCV를 뽑으며 복구합니다! 앞마당이 정상 가동!',
            ),
            ScriptEvent(
              text: '배럭더블 수비 성공! 투팩 측은 병력을 많이 잃었습니다!',
              owner: LogOwner.system,
              altText: '투팩 공격이 막혔습니다! 이제 자원 차이가 벌어지기 시작합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 분기 - 투팩 마무리 vs 배럭더블 확장 (lines 30-37)
    ScriptPhase(
      name: 'post_defense',
      startLine: 30,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      branches: [
        // 분기 A: 투팩이 데미지 줬을 때 — 압박 지속, 끝내기
        ScriptBranch(
          id: 'twofac_finish',
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 탱크 추가 생산! 시즈 포격을 이어갑니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 연구 완료! 하지만 병력이 너무 적습니다...',
              owner: LogOwner.home,
              homeArmy: 1, homeResource: -10,
            ),
            ScriptEvent(
              text: '{away} 선수 투팩 물량으로 앞마당까지 밀어냅니다! 탱크가 시즈 걸고 포격!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -3,
              favorsStat: 'attack',
              altText: '{away}, 투팩의 생산력! 탱크 벌처가 끊임없이 나옵니다!',
            ),
            ScriptEvent(
              text: '투팩이 끝내기를 노립니다! 배럭더블은 벙커도 없고 병력도 없습니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        // 분기 B: 배럭더블 수비 성공 후 — 확장
        ScriptBranch(
          id: 'double_expand',
          conditionStat: 'macro',
          homeStatMustBeHigher: true,
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈 연구 완료! 팩토리를 추가합니다! 3팩, 4팩!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -20,
              altText: '{home}, 더블 자원으로 팩토리가 쭉쭉 늘어납니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 앞마당 확장... 자원이 부족합니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: '{home} 선수 탱크가 쏟아집니다! 더블 자원의 힘!',
              owner: LogOwner.home,
              homeArmy: 3,
              homeResource: -15,
              altText: '{home}, 4팩에서 탱크 벌처가 끊임없이!',
            ),
            ScriptEvent(
              text:
                  '배럭더블의 자원 우위가 빛을 발합니다! 물량 차이가 나기 시작하네요!',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 결전 판정 (lines 38+)
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 38,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 더블 자원의 힘! 탱크 물량으로 상대를 압도합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 수비 후 팩토리 물량! 상대가 더 이상 밀 수 없습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 투팩 시즈 포격! 상대 앞마당을 완전히 밀어냅니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 투팩 물량으로 끝까지 밀어냅니다! 배럭더블이 버티질 못합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
