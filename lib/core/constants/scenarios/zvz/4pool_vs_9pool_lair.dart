part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9풀 레어 (치즈 vs 테크 우선)
// 타이밍: 4풀 도착 2:28, 9풀 레어 첫 저글링 2:14 (4풀보다 14초 빠름)
// 9풀 레어도 9풀 발업과 저글링 타이밍은 동일 — 가스 드론 3기가 있지만
// 미네랄 드론 6기가 있어서 초기 수비력은 9풀 발업과 크게 다르지 않음
// 4풀 보이면 가스 드론을 미네랄로 옮겨 대응 가능
// ----------------------------------------------------------
const _zvz4PoolVs9poolLair = ScenarioScript(
  id: 'zvz_4pool_vs_9pool_lair',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_9pool_lair'],
  description: '4풀 치즈 vs 9풀 레어 — 저글링 타이밍 동일, 레어 진화 유지하며 수비',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론 4기만에 스포닝풀 건설!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
          altText: '{home} 선수, 4드론에 스포닝풀을 올립니다! 극초반 올인이네요!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away} 선수, 9드론에 스포닝풀과 가스를 동시에! 빠른 테크를 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링이 빠르게 나옵니다! 상대로 출발!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -15,
          altText: '{home} 선수, 저글링이 달려갑니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 6기 생산! 가스 100이 모이면 바로 레어 진화 예정!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 6, awayResource: -10,
          altText: '{away} 선수, 저글링이 나왔습니다! 레어 진화를 준비합니다!',
        ),
        ScriptEvent(
          text: '상대도 저글링이 먼저 나와있습니다! 스포닝풀 타이밍이 같아서 저글링이 이미 있네요!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '저글링이 이미 나와있어서 빠른 스포닝풀 수비가 가능합니다!',
        ),
      ],
    ),
    // Phase 1: 4풀 도착 — 9풀 레어는 저글링으로 수비 + 가스 드론 반응 (lines 8-12)
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
          altText: '{home} 선수, 저글링 도착! 상대도 저글링이 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비합니다! 가스 드론을 미네랄로 돌려서 추가 생산 준비!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 1,
          altText: '{away} 선수, 빠른 스포닝풀을 확인하고 가스 드론을 미네랄로 전환! 저글링 보충에 집중!',
        ),
        ScriptEvent(
          text: '저글링 6기 대 6기! 드론 수가 9기라 수비하는 쪽이 유리합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '가스 드론을 빼고 수비 체제로 전환합니다!',
        ),
      ],
    ),
    // Phase 2: 초반 교전 결과 - 분기 (lines 13-24)
    ScriptPhase(
      name: 'rush_result',
      branches: [
        // 분기 A: 4풀이 컨트롤로 드론 피해를 줌
        ScriptBranch(
          id: 'pool_exploits',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 교전하면서 드론도 물어뜯습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: -15, awayArmy: -3, homeArmy: -3,              altText: '{home} 선수, 저글링 서라운드! 수비 저글링을 잡으면서 드론까지!',
            ),
            ScriptEvent(
              text: '{away} 선수 가스 드론을 옮기지만 이미 드론이 많이 빠졌습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 1, awayResource: -10,
              altText: '{away} 선수, 뒤늦게 가스 드론을 미네랄로 옮기지만 드론 손실이 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 추가 저글링 투입! 드론 수를 더 벌려놓습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 2, awayResource: -10,              altText: '{home} 선수, 초반 러시의 끈질긴 압박! 드론 차이를 좁혔습니다!',
            ),
            ScriptEvent(
              text: '초반 저글링이 드론을 충분히 잡았습니다! 레어 진화가 무의미해졌습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론이 너무 많이 빠졌습니다! 테크를 올릴 자원이 남아있지 않습니다!',
            ),
          ],
        ),
        // 분기 B: 9풀 레어가 반응 수비로 완벽히 막음
        ScriptBranch(
          id: 'lair_reacts_defense',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링으로 정면 교전! 드론도 합세합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: -2,              altText: '{away} 선수, 저글링과 드론으로 협공! 상대 저글링을 잡아냅니다!',
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
              text: '{away} 선수 수비 성공! 레어 진화도 계속 진행 중입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 3, awayResource: -10,              altText: '{away} 선수, 초반 러시를 완벽하게 막았습니다! 레어 진화가 곧 완료됩니다!',
            ),
            ScriptEvent(
              text: '초반 러시가 막혔습니다! 레어 진화까지 챙기면서 수비했습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '수비 성공에 레어 진화까지! 완벽한 대응입니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
