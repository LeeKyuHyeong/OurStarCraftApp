part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9오버풀 (치즈 vs 준스탠다드)

// 오프닝
// 	- 4드론(home)				:	드론 한개만 뽑고(5드론) - 추가적으로 드론을 안뽑는다는거에 해설이 난리가나야함 / 미네랄 200이 모이자마자 스포닝풀 건설 시작 / 스포닝풀 건설 완료, 저글링 6기 생산 / 상대방 기지 찾아 나섬 까지 동일
// 	- 9드론 레어(away)	:	드론 9기 까지 뽑고 / 오버로드 생산 시작 / 스포닝풀 건설 시작 / 오버로드 생산되면 드론 3기 추가 / 해처리 위치 분기 시작
//
// phase1 (9오버풀의 추가 해처리 분기)
// 	- 분기1-A : away 앞마당에 추가 해처리 선택하고 home 저글링은 상대방 진영으로 이동하며 다음 페이즈
// 	- 분기1-B : away 본진에 추가 해처리 선택하고 home 저글링은 상대방 진영으로 이동하며 다음 페이즈

// phase2 (저글링 싸움 페이즈)
//	- 분기2-A : home이 컨트롤 앞서서 드론까지 타격, 앞마당 해처리 취소 시키며 본진까지 입성 함 > home 승 (control+attack) (낮은 확률) [선행 : 분기1-A]
//	- 분기2-B : home이 컨트롤 앞서서 드론까지 타격, 본진 장악 > home 승 (control+attack) (낮은 확률) [선행 : 분기1-B]
//	- 분기2-C : home이 뒤가 없는 빌드기 때문에 저글링 교전을 계속 걸지만 away 쪽 추가 저글링 합류가 빠른 이점으로 서서히 수비되며 다음 페이즈

// phase3 (승부 결정 페이즈)
// 	-	분기3-A : home 초반 올인 수비에 막히며 away 앞마당 돌아가니 역전 불가하다고 판단 > away 승리 [선행 : 분기1-A]
// 	-	분기3-B : home 초반 올인 수비에 막히며 away 본진 해처리 까지 두배의 라바 및 드론 수 차이가 나니 역전 불가하다고 판단 > away 승리 [선행 : 분기1-B]
//
// 타이밍: 4풀 도착 2:28, 9오버풀 저글링 2:35 쯤 생산완료 거리에 따라 거의 비슷하게 도착 하지만 추가 해처리를 앞마당에 설치했냐, 본진에 설치했냐에 따라 수비 가능 확률이 달라짐 (앞마당 선택 쪽이 수비가 좀 더 어려움)
// ----------------------------------------------------------
const _zvz4PoolVs9overpool = ScenarioScript(
  id: 'zvz_4pool_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_9overpool'],
  description: '4풀 치즈 vs 9오버풀 — 해처리 위치에 따른 수비 분기',
  phases: [
    // Phase 0: 오프닝
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수, 드론 한 기를 뽑고 더 이상 드론을 생산하지 않는데요!',
          altText: '{home} 선수, 5드론 이후에 드론이 추가되지 않습니다!',
          homeArmy: 0,
          homeResource: 100,
          awayArmy: 0,
          awayResource: 100,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '드론을 뽑지 않고 있습니다! 극초반 올인이 나왔네요!',
          altText: '5드론에서 멈추고 스포닝풀부터 올리는데요, 앞마당을 먼저 올리는 상대에게 위험할 수 있겠습니다!',
          homeArmy: 0,
          homeResource: 50,
          awayArmy: 0,
          awayResource: 50,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수, 미네랄이 모이자마자 스포닝풀을 건설합니다.',
          altText: '{home} 선수, 드론 한 기를 빼서 스포닝풀 건설합니다.',
          homeArmy: 0,
          homeResource: -200,
          awayArmy: 0,
          awayResource: 50,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수, 9드론에 오버로드를 먼저 올리고 스포닝풀로 이어갑니다.',
          altText: '{away} 선수, 오버로드부터 생산합니다! 이어서 스포닝풀을 건설합니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -300,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 스포닝풀 완성! 저글링 6기 생산합니다!',
          altText: '{home} 선수, 라바 3개를 모두 저글링으로!',
          homeArmy: 3,
          homeResource: -150,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수, 오버로드가 완성되고 드론을 추가 생산합니다.',
          altText: '{away} 선수, 오버로드 완성 후 드론 3기를 추가로 뽑습니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 0,
          awayResource: -150,
        ),
      ],
    ),
    // Phase 1: 해처리 위치 분기 (앞마당 vs 본진)
    ScriptPhase(
      name: 'hatch_choice',
      branches: [
        // 분기 1-A: 앞마당 해처리
        ScriptBranch(
          id: 'nat_hatch',
          description: '(phase1) 분기A - 앞마당 해처리',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 앞마당에 해처리를 올립니다!',
              altText: '{away} 선수, 앞마당으로 드론을 보내 해처리를 건설합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '{home} 선수 저글링이 상대 진영으로 달려가고 있습니다! 앞마당 해처리가 위험할 수 있겠는데요!',
              altText: '저글링이 이동 중입니다! 앞마당에 해처리를 올렸으니 수비에 부담이 되겠습니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 스포닝풀이 곧 완성됩니다! 드론으로 시간을 벌어야 합니다!',
              altText: '{away} 선수, 풀 완성 직전입니다! 저글링이 나올 때까지 드론으로 버텨야 해요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 1,
              awayResource: -50,
            ),
          ],
        ),
        // 분기 1-B: 본진 해처리
        ScriptBranch(
          id: 'main_hatch',
          description: '(phase1) 분기B - 본진 해처리',
          baseProbability: 1.0,
          conditionStat: 'strategy',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 본진에 해처리를 추가합니다!',
              altText: '{away} 선수, 본진에 두 번째 해처리를 건설합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '{home} 선수 저글링이 출발했습니다! 노린 건 아니지만 본진에 해처리를 올리며 수비가 상대적으로 용이해졌습니다!',
              altText: '노린 건 아니지만 본진 해처리라 앞마당보다 수비하기 유리합니다! 하지만 저글링이 나오기까지 피해를 크게 입으면 안됩니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 스포닝풀이 곧 완성됩니다! 드론으로 시간을 벌어야 합니다!',
              altText: '{away} 선수, 풀 완성 직전입니다! 저글링이 나올 때까지 드론으로 버텨야 해요!',
              homeArmy: 0,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -50,
            ),
          ],
        ),
      ],
    ),
    // Phase 2: 저글링 싸움 (3분기)
    ScriptPhase(
      name: 'ling_fight',
      branches: [
        // 분기 2-A: 앞마당 해처리 선택 후 4풀 올인 성공 [선행: nat_hatch]
        ScriptBranch(
          id: 'rush_success_nat',
          description: '(phase2) 분기A - 앞마당 올인 성공',
          baseProbability: 0.7,
          conditionStat: 'control+attack',
          conditionPriorBranchIds: ['nat_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 앞마당 해처리를 노립니다!',
              altText: '{home} 선수, 앞마당 해처리를 발견합니다! 저글링이 달려듭니다!',
              homeArmy: 2,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링 생산 이제 시작합니다!',
              altText: '{away} 선수, 이제야 저글링 생산하기 시작합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링이 나오기 전까지 드론으로 막아야합니다!',
              altText: '{away} 선수, 드론을 앞마당으로 보내지만 내려오는 데 시간이 걸려요!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 병력을 나눠서 일부는 해처리, 일부는 드론을 솎아내려고 합니다!',
              altText: '{home} 선수, 저글링 없이 수비나온 드론부터 잡아주려고 합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 제대로 뭉치지 못한 상대방 드론을 많이 잡아냅니다!',
              altText: '{home} 선수, 상대방저글링이 나오기 전 드론 피해를 많이 입힙니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링이 나왔지만 상대방의 저글링을 줄이지 못해 숫자 차이가 큽니다!',
              altText: '{away} 선수, 저글링이 앞마당 수비를 위해 나오지만 이미 드론 피해가 너무 큽니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -3,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '앞마당을 잃고 드론까지 큰 피해를 입었습니다! 회복이 불가능한 상황!',
              altText: '앞마당 해처리까지 무너지며 자원 차이가 벌어졌습니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-B: 본진 해처리 선택 후 4풀 올인 성공 [선행: main_hatch]
        ScriptBranch(
          id: 'rush_success_main',
          description: '(phase2) 분기B - 본진 올인 성공',
          baseProbability: 0.5,
          conditionStat: 'control+attack',
          conditionPriorBranchIds: ['main_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 본진에 도착합니다! 드론 사이를 파고듭니다!',
              altText: '{home} 선수, 저글링이 본진으로! 드론을 노리며 저글링을 풀어줍니다!',
              homeArmy: 2,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링 생산 이제 시작합니다!',
              altText: '{away} 선수, 이제야 저글링 생산하기 시작합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 저글링 서라운드! 드론을 하나씩 잡아갑니다!',
              altText: '{home} 선수, 놀라운 저글링 컨트롤! 드론이 녹고 있습니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -200,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론이 너무 많이 빠졌습니다! 저글링이 나와도 이미 늦었습니다!',
              altText: '{away} 선수, 본진 드론 손실이 치명적입니다! 회복이 어려운 상황!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '본진 드론을 대부분 잃었습니다! 게임을 이어가기 어려운 상황입니다!',
              altText: '드론이 너무 많이 죽었습니다! 초반 빌드로 타이밍을 잘 잡았네요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-C: 드론+저글링으로 수비됨 → 다음 페이즈
        ScriptBranch(
          id: 'ling_defended',
          description: '(phase2) 분기C - 수비 성공',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론을 뭉쳐서 저글링과 교전합니다!',
              altText: '{away} 선수, 드론 컨트롤! 저글링을 하나씩 잡아냅니다!',
              homeArmy: -2,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 드론에 막히고 있습니다!',
              altText: '{home} 선수, 초반 저글링이 밀립니다! 상대방의 드론 컨트롤이 너무 좋아요!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 스포닝풀 완성! 저글링이 나오기 시작합니다!',
              altText: '{away} 선수, 풀이 완성되고 저글링 생산! 수비 병력이 합류합니다!',
              homeArmy: 0,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -200,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 승부 결정
    ScriptPhase(
      name: 'result',
      branches: [
        // 분기 3-A: 앞마당 해처리가 살아남아 역전 불가 → away 승 [선행: nat_hatch]
        ScriptBranch(
          id: 'nat_secures',
          description: '(phase3) 분기A - 앞마당 살아 역전불가',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['nat_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 초반 러시를 막아냈습니다! 앞마당 해처리가 돌아갑니다!',
              altText: '{away} 선수, 앞마당이 살아있습니다! 이대로 가면 차이가 벌어지죠!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '앞마당 해처리까지 살아있으니 {home} 선수로서는 이길 방법이 없습니다!',
              altText: '드론 수와 라바 차이가 벌어집니다! {home} 선수 미래가 없어요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수가 수비에 성공하며 {home} 선수 전의를 상실합니다!',
              altText: '{away} 선수의 완벽한 수비를 보여주며 승기를 잡습니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 3-B: 본진 해처리 라바 2배 → away 승 [선행: main_hatch]
        ScriptBranch(
          id: 'main_secures',
          description: '(phase3) 분기B - 본진 해처리 라바차이 역전불가',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['main_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 러시를 버텨냈습니다! 드론과 라바 차이가 나기 시작할테죠!',
              altText: '{away} 선수, 수비 성공! 두 해처리에서 저글링을 쏟아냅니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '본진에 해처리가 두 개! 라바 회전이 두 배라 저글링 보충이 빠릅니다!',
              altText: '두 해처리의 라바 차이가 압도적입니다! {home} 선수 미래가 없어요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수의 수비가 성공하며 {home} 선수는 따라 갈 힘이 없습니다!',
              altText: '{away} 선수의 수비력이 빛나는 경기네요, {home} 선수는 공격이 실패한 순간 진 것과 다름없죠!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
