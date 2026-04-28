part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 9풀 레어 (치즈 vs 테크 우선)
// 오프닝
// 	- 4드론(home)				:	드론 한개만 뽑고(5드론) - 추가적으로 드론을 안뽑는다는거에 해설이 난리가나야함 / 미네랄 200이 모이자마자 스포닝풀 건설 시작 / 스포닝풀 건설 완료, 저글링 6기 생산 / 상대방 기지 찾아 나섬 까지 동일
// 	- 9드론 레어(away)	:	드론 9기 까지 뽑고 스포닝풀+익스트랙터 건설 / 가스 드론 안 빼고 계속 채취 / 가스 100 즉시 레어 진화 / 노발업 저글링 6기 생산 / 가스 2회차 100에 발업 시작 / 레어→스파이어→뮤탈 목표
//
// phase1 (저글링 싸움 — 노발업 동급)
// 	- 분기1-A : home이 컨트롤 앞서서 드론까지 타격, 레어 진화 무의미 > home 승 (control+attack) (낮은 확률)
// 	-	분기1-B : away가 노발업 저글링+드론으로 수비, 레어 진화 유지하며 완승 > away 승 (control)
//
// 타이밍: 4풀 도착 2:28, 9풀 레어 첫 저글링 2:14 (9풀 레어는 노발업, 가스 드론 안 빼고 계속 채취 → 가스 100에 레어 진화(2:08) → 2차 가스 100에 발업(2:25))
// 9풀 레어도 9풀 발업과 저글링 타이밍(2:14) 동일, 초기 수비력은 비슷하지만 가스 드론을 안 빼므로 미네랄이 약간 적음
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
          owner: LogOwner.home,
          text: '{home} 선수 드론 한 기를 뽑고 더이상 드론을 생산하지 않는데요!',
          altText: '{home} 선수, 5드론 이후에 드론이 추가되지 않습니다!',
          homeArmy: 0,
          homeResource: 100,
          awayArmy: 0,
          awayResource: 100,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '일반적으론 드론이 더 뽑혀야하는데요, 극초반 올인 빌드가 나왔네요!',
          altText: '일반적인 빌드가 아니네요, 빠른 확장을 하는 상대를 노린 것 같습니다!',
          homeArmy: 0,
          homeResource: 50,
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
          awayResource: 50,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다.',
          altText: '{away} 선수, 9드론에 스포닝풀과 가스를 동시에 올립니다.',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -250,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 스포닝풀 완성! 저글링 6기 생산 시작합니다!',
          altText: '{home} 선수, 라바 3개 모두 저글링을 누릅니다!',
          homeArmy: 3,
          homeResource: -150,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링 생산 되자마자 상대방 진영을 찾아나섭니다!',
          altText: '{home} 선수, 저글링 나오자마자 상대방을 찾아나섭니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '{home} 선수는 상대방 앞마당이 진행되고 있기를 빌텐데요!',
          altText: '{home} 선수는 상대방이 가까이에 있기를 바랄텐데요!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 1,
          awayResource: -50,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 저글링 6기 생산! 도착할때 쯤 나오겠는데요.',
          altText: '{away} 선수, 저글링 누릅니다. 상대방 올인인 건 아직 모르고 있습니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3,
          awayResource: -150,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 가스 100이 모이자마자 레어 진화를 시작합니다.',
          altText: '{away} 선수, 바로 레어 진화 돌입합니다.',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 1,
          awayResource: -300,
        ),
      ],
    ),
    // Phase 1: 4풀 도착 — 9풀 레어는 노발업 저글링+드론으로 수비, 레어 진화 진행중 (lines 8-12)
    ScriptPhase(
      name: 'ling_clash',
      linearEvents: [
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링이 도착합니다! 앞마당이 아닌 건 확인했지만 뺄 수 없습니다!',
          altText: '{home} 선수, 저글링 도착! 상대방의 빌드를 확인합니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 상대방 저글링 도착을 보고 빌드를 이제 알텐데요 저글링이 늦지않게 나옵니다!',
          altText: '{away} 선수, 상대방의 빠른 저글링을 보고 수비만 하면 레어가 빨라서 유리하다는 생각을 가질텐데요!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 1,
          awayResource: -50,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '초반 올인 빌드는 여기서 뺄 수 없습니다 두 선수 저글링 교전!',
          altText: '양쪽 다 노발업 저글링이지만 드론 수 차이가 나기 때문에 수비 여부에 따라 승부가 갈립니다!',
          homeArmy: 1,
          homeResource: -50,
          awayArmy: 1,
          awayResource: -50,
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
          description: '(phase2) 분기A - 4풀 드론 피해',
          baseProbability: 0.3,
          conditionStat: 'control+attack',
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 혼신의 저글링 컨트롤이 나옵니다!',
              altText: '{home} 선수, 저글링 움직임이 남다릅니다!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 교전 끝에 약간의 승리를 거두며 추가 저글링이 계속 뛰어옵니다!',
              altText: '{home} 선수, 저글링으로 상대방 저글링을 감싸며 놀라운 교전 집중력을 보여줍니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -100,
              skipChance: 0.7,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 상대방 드론 타격도 줍니다!',
              altText: '{home} 선수, 드론까지 공격해줍니다, 뒤가 없어요!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: -2,
              awayResource: -100,
              skipChance: 0.3,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 드론이 많이 죽었습니다! 레어 진화가 진행 중인데 큰 위기입니다!',
              altText: '{away} 선수, 드론 손실이 큽니다! 레어 완성 전에 위기가 찾아오는데요!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 추가 저글링 투입! 계속해서 압박을 줍니다!',
              altText: '{home} 선수, 초반 러시의 끈질긴 압박! 길게 가면 불리한 걸 알죠!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 초반 저글링 교전 승리와 이어진 드론 제거로 쉽지 않은 경기 이겨냅니다!',
              altText: '{home} 선수 뒤가 없는 빌드 선택과 그에 따른 혼신의 컨트롤로 상대방 본진을 초토화시킵니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: -1,
              awayResource: -100,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 9풀 레어가 노발업 저글링+드론으로 수비 성공
        ScriptBranch(
          id: 'lair_reacts_defense',
          description: '(phase2) 분기B - 레어 수비 성공',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 저글링으로 정면 교전! 드론도 합세합니다!',
              altText: '{away} 선수, 저글링과 드론으로 협공! 상대 저글링을 잡아냅니다!',
              homeArmy: -2,
              homeResource: -100,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.system,
              text: '{away} 선수 본진에서 싸우는 상황, 저글링 합류가 더 빠릅니다!',
              altText: '{home} 선수는 추가 저글링이 본진까지 합류하기까지 시간이 걸려요!',
              homeArmy: -1,
              homeResource: -50,
              awayArmy: 1,
              awayResource: -100,
              skipChance: 0.7,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 녹습니다! 초반에 끝내지 못하면 불리한데요!',
              altText: '{home} 선수, 초반 저글링이 밀립니다! 극단적인 빌드라 이대로 가면 불리한데요!',
              homeArmy: -2,
              homeResource: -100,
              awayArmy: -1,
              awayResource: -50,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 수비 성공! 레어 진화도 계속 진행 중입니다!',
              altText: '{away} 선수, 초반 러시를 완벽하게 막았습니다! 레어 진화가 곧 완료됩니다!',
              homeArmy: 1,
              homeResource: -50,
              awayArmy: 2,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수가 큰 피해 없이 막아내며 {home} 선수 전의를 상실합니다!',
              altText: '{away} 선수의 뮤탈이 나오면 {home} 선수는 막을 방법이 없습니다!',
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
