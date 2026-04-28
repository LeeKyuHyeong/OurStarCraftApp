part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12풀 (치즈 vs 스탠다드)
// 오프닝
// 	- 4드론(home)				:	드론 한개만 뽑고(5드론) - 추가적으로 드론을 안뽑는다는거에 해설이 난리가나야함 / 미네랄 200이 모이자마자 스포닝풀 건설 시작 / 스포닝풀 건설 완료, 저글링 6기 생산 / 상대방 기지 찾아 나섬 까지 동일
// 	- 12드론 스포닝풀(away)	:	드론 9기 까지 뽑고 / 오버로드 생산 시작 / 오버로드 생산되면 드론 3기 추가 / 스포닝풀 건설 시작 / 해처리 위치 분기 시작
//
// phase1 (12풀의 추가 해처리 분기)
// 	- 분기1-A : away 앞마당에 추가 해처리 선택하고 home 저글링은 상대방 진영으로 이동하며 다음 페이즈
// 	- 분기1-B : away 본진에 추가 해처리 선택하고 home 저글링은 상대방 진영으로 이동하며 다음 페이즈

// phase2 (저글링 싸움 페이즈)
//	- 분기2-A : home이 컨트롤 away의 저글링이 나오기 전 수비를 하려던 드론을 많이 잡아내고, 저글링이 나오지만 추가 저글링 합류로 앞마당 해처리 취소 시키며 본진까지 입성 함 > home 승 (control+attack) [선행 : 분기1-A]
//	- 분기2-B : home이 컨트롤 away의 저글링이 나오기 전 수비를 하려던 드론을 많이 잡아내고, 저글링이 나오지만 추가 저글링 합류로 본진 해처리 무시하며 본진 드론과 저글링을 초토화 시킴 > home 승 (control+attack) [선행 : 분기1-B]
//	- 분기2-C : home이 뒤가 없는 빌드기 때문에 저글링 교전을 계속 걸지만 away 쪽 드론 컨트롤로 저글링 나올 때 까지 큰 피해없이 저글링이 나오고 저글링, 드론으로 4드론의 저글링을 밀어내며 다음 페이즈

// phase3 (승부 결정 페이즈)
// 	-	분기3-A : home 초반 올인 수비에 막히며 away 앞마당 돌아가니 역전 불가하다고 판단 > away 승리 [선행 : 분기1-A]
// 	-	분기3-B : home 초반 올인 수비에 막히며 away 본진 해처리 까지 두배의 라바 및 드론 수 차이가 나니 역전 불가하다고 판단 > away 승리 [선행 : 분기1-B]
//
// 타이밍: 4풀 도착 2:28, 12풀 저글링 2:42 쯤 생산완료되니 4풀 도착 시 저글링 나오기 까지 드론으로 수비해야함으로 추가 해처리를 앞마당에 설치했냐, 본진에 설치했냐에 따라 수비 가능 확률이 달라짐 (앞마당 선택 쪽이 수비가 좀 더 어려움)

// ----------------------------------------------------------
const _zvz4PoolVs12pool = ScenarioScript(
  id: 'zvz_4pool_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_12pool'],
  description: '4풀 극초반 올인 vs 12풀 스탠다드 — 해처리 위치에 따른 수비 분기',
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
          altText: '5드론에서 멈추고 스포닝풀부터 올리는데요, 앞마당을 먼저 가면 노려보겠다는 거죠!',
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
          text: '{away} 선수, 오버로드 완성 후 드론을 12기까지 뽑습니다.',
          altText: '{away} 선수, 오버로드 이후 드론 12개까지 생산!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -100,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수, 스포닝풀과 가스를 동시에 건설합니다.',
          altText: '{away} 선수, 스포닝풀 건설! 가스도 같이 올립니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -250,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 스포닝풀 완성! 저글링 6기 생산합니다!',
          altText: '{home} 선수, 라바 3개를 모두 저글링으로!',
          homeArmy: 4,
          homeResource: -150,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수, 아직까진 상대 빌드를 모르는데요 도착하면 저글링 나오기 전까지 드론으로 버텨야합니다!',
          altText: '{away} 선수, 아직은 상대방 빌드 모르죠, 드론 피해없이 막을 수 있을까요!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 0,
          awayResource: -50,
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
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '상대적으로 본진 해처리 선택보다 수비가 어려워지겠네요!',
              altText: '저글링은 오고 있는데 앞마당 선택, 수비를 한번 지켜보시죠!',
              homeArmy: 2,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론으로 버텨야 합니다! 풀 완성까지 시간이 남았습니다!',
              altText: '{away} 선수, 풀이 아직 조금 남았습니다! 드론 컨트롤로 시간을 벌어야 해요!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 2,
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
              altText: '{away} 선수, 본진에 두 번째 해처리를 건설합니다! 무난한 선택이죠!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: -300,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '상대적으로 앞마당 해처리 선택보다는 수비가 용이하지만 그래도 지켜봐야겠죠!',
              altText: '본진 해처리라 앞마당보다 안전합니다! 하지만 풀 완성까지 드론으로 막아야 합니다!',
              homeArmy: 2,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론 뭉치기로 버텨야 합니다! 풀 완성까지 시간이 남았습니다!',
              altText: '{away} 선수, 풀이 아직 조금 남았어요! 드론으로 시간을 벌어야 해요!',
              homeArmy: 1,
              homeResource: 0,
              awayArmy: 2,
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
          baseProbability: 0.8,
          conditionStat: 'control+attack',
          conditionPriorBranchIds: ['nat_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 앞마당 해처리부터 노립니다!!',
              altText: '{home} 선수, 앞마당 해처리를 발견합니다!',
              homeArmy: 0,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 풀 완성 되자마자 저글링 누릅니다!',
              altText: '{away} 선수, 저글링 이제야 생산 시작합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론을 내려보내지만 앞마당 해처리가 계속 타격 받고 있습니다!',
              altText: '{away} 선수, 앞마당 수비가 늦습니다! 해처리가 위험해질 수 있어요!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 저글링 없이 내려온 드론을 골라 잡아줍니다!',
              altText: '{home} 선수, 저글링 컨트롤이 상대방 드론 컨트롤보다 좋습니다! {away} 선수 드론 피해가 쌓입니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링 생산되자마자 수비에 투입합니다!',
              altText: '{away} 선수, 앞마당을 지키기 위해 저글링 나오자마자 수비하던 드론과 합류합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 뒤가 없기 때문에 추가 저글링을 계속 생산하여 상대방 진영으로 보냅니다!',
              altText: '{home} 선수, 여기서 계속해서 밀어 붙입니다! 극 초반 올인으로 적당한 피해는 패배로 보면됩니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 저글링 물량 차이로 늦게나마 나온 상대방 저글링도 다 잡아내고 앞마당을 취소시킵니다!',
              altText: '{home} 선수, 수비하는 상대방의 병력을 싸먹으며 결국 앞마당을 취소시킵니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -4,
              awayResource: -250,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 상대방 앞마당 취소 시킨 후 기세 그대로 이어가며 본진까지 입성합니다!',
              altText: '{home} 선수 공격적인 빌드 선택과 집중력으로 빠른 시간 내에 상대방 본진을 초토화 시킵니다.!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -2,
              awayResource: -200,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-B: 본진 해처리 선택 후 4풀 올인 성공 [선행: main_hatch]
        ScriptBranch(
          id: 'rush_success_main',
          description: '(phase2) 분기B - 본진 올인 성공',
          baseProbability: 0.6,
          conditionStat: 'control+attack',
          conditionPriorBranchIds: ['main_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 상대방 본진에 도착합니다!',
              altText: '{home} 선수, 저글링이 상대방 본진으로! 드론밖에 없는 상황!',
              homeArmy: 0,
              homeResource: -50,
              awayArmy: 0,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 풀 완성 되자마자 저글링 누릅니다!',
              altText: '{away} 선수, 저글링 이제야 생산 시작합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 3,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론을 뭉쳐서 저글링 나오는 시간을 벌어보려고 합니다!',
              altText: '{away} 선수, 저글링 나오기 전까지 드론으로 막아야합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 저글링 컨트롤이 좋습니다! 드론을 하나씩 잡아갑니다!',
              altText: '{home} 선수, 저글링으로 드론을 둘러쌉니다! 드론 피해가 쌓입니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -200,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링 생산되자마자 수비에 투입합니다!',
              altText: '{away} 선수, 저글링 나오자마자 수비하던 드론과 합류합니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 뒤가 없기 때문에 추가 저글링을 계속 생산하여 상대방 진영으로 보냅니다!',
              altText: '{home} 선수, 여기서 계속해서 밀어 붙입니다! 극 초반 올인으로 적당한 피해는 패배로 보면됩니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수, 저글링 물량 차이로 늦게나마 나온 상대방 저글링도 다 잡아내고 무방비가 된 드론까지 잡아냅니다!',
              altText: '{home} 선수, 수비하는 상대방의 병력을 싸먹으며 결국 본진을 장악합니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -4,
              awayResource: -250,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 초반 수비에 어려움을 느끼며 밀립니다!',
              altText: '{away} 선수, 본진 드론 손실이 너무 큽니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '공격적인 빌드 선택한 {home} 선수, 컨트롤까지 더해지며 초반부터 승부를 끝냅니다!',
              altText: '{home} 선수, 이대로 끝내기 위해 스포닝풀과 해처리까지 타격합니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -1,
              awayResource: -100,
              decisive: true,
            ),
          ],
        ),
        // 분기 2-C: 드론 컨트롤로 버티고 저글링 합류 → 다음 페이즈
        ScriptBranch(
          id: 'ling_defended',
          description: '(phase2) 분기C - 드론 수비 후 저글링 합류',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 드론을 뭉쳐서 저글링과 맞붙습니다!',
              altText: '{away} 선수, 드론 컨트롤로 저글링을 상대합니다!',
              homeArmy: -2,
              homeResource: -100,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 드론에 막히고 있습니다! {away} 선수의 드론 컨트롤이 대박인데요!',
              altText: '{home} 선수, 저글링이 밀립니다! {away} 선수의 드론 뭉치기가 너무 좋습니다!',
              homeArmy: -2,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 저글링이 합류하며 수비를 이어갑니다, 발업도 돌아갑니다!',
              altText: '{away} 선수, 저글링 생산되며 수비에 합류합니다! 발업 연구도 시작합니다!',
              homeArmy: -2,
              homeResource: -100,
              awayArmy: 1,
              awayResource: -250,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 승부 결정
    ScriptPhase(
      name: 'result',
      branches: [
        // 분기 3-A: 앞마당 해처리 살아남아 역전 불가 → away 승 [선행: nat_hatch]
        ScriptBranch(
          id: 'nat_secures',
          description: '(phase3) 분기A - 앞마당 살아 역전불가',
          baseProbability: 1.0,
          conditionPriorBranchIds: ['nat_hatch'],
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 초반 러시를 막아냈습니다! 앞마당 해처리가 돌아갑니다!',
              altText: '{away} 선수, 수비 성공! 앞마당이 살아있고 발업도 진행 중입니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '앞마당 해처리에 가스까지! 발업 저글링이 나오면 {home} 선수는 답이 없습니다!',
              altText: '드론 수와 라바 차이에 발업까지! {home} 선수 뒤가 없어요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수가 수비에 성공하며 {home} 선수 전의를 상실합니다!',
              altText: '드론 물량과 앞마당 운영으로 {away} 선수의 완벽한 수비!',
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
              text: '{away} 선수, 러시를 버텨냈습니다! 본진 해처리에서 라바가 쏟아집니다!',
              altText: '{away} 선수, 수비 성공! 두 해처리에서 저글링을 쏟아냅니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '본진에 해처리가 두 개에 발업까지! 저글링 물량 차이가 압도적입니다!',
              altText: '두 해처리의 라바 차이에 발업 저글링까지! {home} 선수 뒤가 없어요!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수, 라바 2배와 발업 저글링으로 {home} 선수를 압도합니다!',
              altText: '{away} 선수의 본진 해처리가 빛을 발합니다! 발업 저글링으로 마무리!',
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
