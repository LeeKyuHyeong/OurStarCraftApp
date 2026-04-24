part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 타이밍: 4풀 도착 2:28, 9풀 발업 첫 저글링 2:14 (4풀보다 14초 빠름)

// 4드론(5드론) vs 9드론발업
// 오프닝
// 	- 4드론(home)				:	드론 한개만 뽑고(5드론) - 추가적으로 드론을 안뽑는다는거에 해설이 난리가나야함 / 미네랄 200이 모이자마자 스포닝풀 건설 시작 / 스포닝풀 건설 완료, 저글링 6기 생산 / 상대방 기지 찾아 나섬 까지 동일
// 	- 9드론 발업(away)	:	드론 9기 까지 뽑고 스포닝풀 건설 / 가스 건설 / 드론 한기 추가 생산 / 오버로드 생산 / 스포닝풀 건설 완료, 저글링 6기 생산 / 저글링 나올때 쯤 4풀의 저글링이 본진 도착 가능(맵 길이별로 차이가 있을 순 있음)
//
// phase1 (저글링 싸움)
// 	- 분기1-A : home 이 컨트롤 앞서서 겨우 상대방 발업이 완료되기전 저글링 교전 대승하며 그대로 상대방 드론까지 타격 > home 승 (control+attack) (낮은 확률)
// 	-	분기1-B : away 가 처음 저글링싸움도 밀리지 않고 발업까지 완료되어 무난하게 승 > away 승
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
          owner: LogOwner.home,
          text: '{home} 선수 드론 한 기를 뽑고 더이상 드론을 생산하지 않는데요!',
          altText: '{home} 선수, 5드론 이후에 드론이 추가되지 않습니다!',
          homeArmy: 0,
          homeResource: 50,
          awayArmy: 0,
          awayResource: 50,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '드론을 뽑지 않고 있습니다! 극초반 올인 빌드가 나왔네요!',
          altText: '5드론에서 멈추고 스포닝풀부터 올리는데요! 올인 빌드입니다!',
          homeArmy: 0,
          homeResource: 100,
          awayArmy: 0,
          awayResource: 50,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 미네랄이 모이자마자 스포닝풀을 건설합니다.',
          altText: '{home} 선수 드론 한 기를 빼서 스포닝풀 건설합니다.',
          homeArmy: 0,
          homeResource: -200,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          altText: '{away} 선수, 9드론에 스포닝풀과 가스를 동시에 올립니다! 저글링 속업을 노리나봅니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -250,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          altText: '{home} 선수, 극초반 첫 저글링이 달려갑니다!',
          homeArmy: 3,
          homeResource: -150,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 가스를 모으면서 저글링 생산! 발업도 연구 시작합니다!',
          altText: '{away} 선수, 저글링이 이미 나왔습니다! 발업 연구도 시작!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3,
          awayResource: -150,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '상대도 스포닝풀이 빨라서 저글링이 먼저 나와있습니다! 수비 준비가 되어있습니다!',
          altText: '저글링이 도착했지만 상대도 이미 저글링이 있습니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 1,
          awayResource: -50,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 4풀 저글링 도착 — 9풀은 이미 저글링으로 수비중 (lines 8-12)
    ScriptPhase(
      name: 'ling_clash',
      linearEvents: [
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링이 도착합니다! 하지만 상대 저글링이 이미 나와있습니다!',
          altText: '{home} 선수, 저글링 도착! 그런데 상대 저글링이 벌써 수비하고 있습니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 저글링으로 바로 수비합니다! 드론 수도 9기로 여유있습니다!',
          altText: '{away} 선수, 저글링이 준비되어 있습니다! 막기만 하면 유리합니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 1,
          awayResource: -50,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '{home} 선수 드론 숫자 차이 때문에 피해를 무조건 줘야하는데요!',
          altText: '{home} 선수 피해를 입히지 못하면 드론 숫자 차이 때문에 불리합니다!',
          homeArmy: 0,
          homeResource: 50,
          awayArmy: 0,
          awayResource: 100,
          skipChance: 0.3,
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
          description: '(phase2) 분기A - 4풀 컨트롤 돌파',
          baseProbability: 0.3,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링 컨트롤! 상대 저글링이 수비 진영을 쌓기 전에 둘러쌉니다!',
              altText: '{home} 선수, 상대가 수비 진영을 갖추기 전에 파고듭니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -2,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 저글링으로 초반 교전의 피해가 큽니다!',
              altText: '{away} 선수, 저글링이 나오는 족족 둘러쌓입니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 추가 저글링 투입! 드론 손실이 누적됩니다!',
              altText: '{home} 선수, 저글링을 계속 보냅니다! 4기뿐인 드론에서 쥐어짜냅니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '발업이 되면 승산이 없었는데 비좁은 타이밍을 뚫어냈습니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -3,
              awayResource: -50,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀 발업 저글링으로 제압
        ScriptBranch(
          id: 'speed_lings_dominate',
          description: '(phase2) 분기B - 발업 저글링 제압',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 저글링이 상대 저글링과 정면 교전! 드론도 합세합니다!',
              altText: '{away} 선수, 저글링과 드론 협공! 상대 저글링을 잡아냅니다!',
              homeArmy: -2,
              homeResource: -150,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 녹습니다! 하지만 뒤가 없기 때문에 계속해서 싸움을 겁니다!',
              altText: '{home} 선수, 초반 저글링이 밀립니다! 이대로 가면 드론 수 차이가 큰데요!',
              homeArmy: -1,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 발업이 곧 완료됩니다! 추가 저글링까지 합류!',
              altText: '{away} 선수, 발업 저글링의 속도 차이! 상대 저글링을 압도합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '결국 초반에 끝내지못한 {home} 선수, {away} 선수의 발업이 완료된 저글링이 극초반 러시를 제압합니다!!',
              homeArmy: -3,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -50,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
