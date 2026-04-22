part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9풀 발업 (치즈 vs 발업 압박)
// 타이밍: 4풀 도착 2:28, 9풀 발업 첫 저글링 2:14 (4풀보다 14초 빠름)
// ----------------------------------------------------------
const _zvz4PoolVs9poolSpeed = ScenarioScript(
  id: 'zvz_4pool_vs_9pool_speed',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_9pool_speed'],
  description: '4풀 vs 9풀 발업 — 9풀 발업이 저글링이 먼저 나와 수비 유리',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 4드론에 스포닝풀을 올립니다! 극단적인 올인이에요!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away} 선수, 9드론에 스포닝풀과 가스를 동시에 올립니다! 저글링 속업을 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -8,          altText: '{home} 선수, 극초반 첫 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 가스를 모으면서 저글링 생산! 발업도 연구 시작합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 6, awayResource: -10,
          altText: '{away} 선수, 저글링이 이미 나왔습니다! 발업 연구도 시작!',
        ),
        ScriptEvent(
          text: '상대도 스포닝풀이 빨라서 저글링이 먼저 나와있습니다! 수비 준비가 되어있습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '저글링이 도착했지만 상대도 이미 저글링이 있습니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 — 9풀은 이미 저글링으로 수비중 (lines 8-12)
    ScriptPhase(
      name: 'ling_clash',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 하지만 상대 저글링이 이미 나와있습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수, 저글링 도착! 그런데 상대 저글링이 벌써 수비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 바로 수비합니다! 드론 수도 9기로 여유있습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 1,
          altText: '{away} 선수, 저글링이 준비되어 있습니다! 드론 피해 없이 교전!',
        ),
        ScriptEvent(
          text: '저글링 대 저글링! 스포닝풀이 빨랐던 쪽은 수가 적고 상대는 드론 우위까지 있습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '저글링 6기 대 6기! 하지만 드론 차이가 5기나 납니다!',
        ),
      ],
    ),
    // Phase 2: 결과 — 분기 (lines 13-24)
    ScriptPhase(
      name: 'rush_result',
      branches: [
        // 분기 A: 4풀이 컨트롤로 돌파
        ScriptBranch(
          id: 'pool_breaks_through',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링 컨트롤! 상대 저글링을 피하면서 드론을 노립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: -15, awayArmy: -2, homeArmy: -2,              altText: '{home} 선수, 저글링으로 드론을 물어뜯습니다! 수비 저글링을 피해서!',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링으로 막지만 드론까지 피해를 입습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -10, awayArmy: -1,
              altText: '{away} 선수, 수비하지만 드론이 몇 기 빠집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 저글링 투입! 드론 손실이 누적됩니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -10,              altText: '{home} 선수, 저글링을 계속 보냅니다! 4기뿐인 드론에서 쥐어짜냅니다!',
            ),
            ScriptEvent(
              text: '드론 차이를 좁혔습니다! 극초반 러시의 끈질긴 압박이 성공합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀 발업 저글링으로 제압
        ScriptBranch(
          id: 'speed_lings_dominate',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 상대 저글링과 정면 교전! 드론도 합세합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: -2,              altText: '{away} 선수, 저글링과 드론 협공! 상대 저글링을 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 녹습니다! 드론이 4기뿐이라 보충이 안 됩니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
              altText: '{home} 선수, 초반 저글링이 밀립니다! 라바가 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 발업이 곧 완료됩니다! 추가 저글링까지 합류!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -10,              altText: '{away} 선수, 발업 저글링의 속도 차이! 상대 저글링을 압도합니다!',
            ),
            ScriptEvent(
              text: '발업 저글링이 극초반 러시를 제압합니다! 저글링이 먼저 나온 게 결정적!',
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
