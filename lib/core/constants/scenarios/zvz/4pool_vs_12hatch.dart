part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 4풀 vs 12앞마당 (극초반 올인 vs 확장)
//
//  4드론(5드론) vs 12앞
// 오프닝
// 	- 4드론(home)				:	드론 한개만 뽑고(5드론) - 추가적으로 드론을 안뽑는다는거에 해설이 난리가나야함 / 미네랄 200이 모이자마자 스포닝풀 건설 시작 / 스포닝풀 건설 완료, 저글링 6기 생산 / 상대방 기지 찾아 나섬 까지 동일
// 	- 12앞(away)						: 드론 9기 > 오버로드 1기 > 드론 추가 3기 > 앞마당 건설 시작 > 스포닝풀 건설 > 가스 건설 > (이때 상대 저글링 도착 예정) 까지
//
// phase1 (저글링 싸움)
// 	- 분기1-A : away 가 드론 피해는 있지만 완전히 대패는 하지 않으며 앞마당 지키기와 저글링 뽑기까지 이어지며 라바 수 차이, 자원 차이가 나게 됨 > away 승 (control+defense) (낮은 확률)
// 	-	분기1-B : home 저글링이 앞마당을 두드리며 상대방 드론을 앞마당으로 부르는 뉘앙스, 드론을 뭉쳐서 대응해보지만 계속해서 추가되는 저글링을 막지못하고 앞마당 취소 home은 그대로 본진으로 진격하며 이제 나오기 시작한 away 저글링과 드론을 학살하며 > home 승
// ----------------------------------------------------------
const _zvz4PoolVs12hatch = ScenarioScript(
  id: 'zvz_4pool_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_4pool'],
  awayBuildIds: ['zvz_12hatch'],
  description: '4풀 극초반 올인 vs 12앞마당',
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
          homeResource: 0,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '드론을 뽑지 않고 있습니다! 극초반 올인 빌드가 나왔네요!',
          altText: '5드론에서 멈추고 스포닝풀부터 올리는데요! 앞마당이 위험합니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: 0,
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
          text: '{away} 선수 드론을 12기까지 뽑고 앞마당 해처리를 건설합니다!',
          altText: '{away} 선수, 오버로드 하나 올리고 드론 12기까지 뽑은 뒤 앞마당 해처리!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -300,
        ),
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링 6기 생산! 상대 진영으로 출발합니다!',
          altText: '{home} 선수, 저글링이 달려갑니다! 앞마당부터 올린 상대에게 최악의 타이밍!',
          homeArmy: 3,
          homeResource: -150,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 앞마당 해처리 후 스포닝풀과 가스를 건설합니다! 아직 풀이 멀었습니다!',
          altText: '{away} 선수, 스포닝풀과 가스가 올라가지만 저글링은 아직 한참 남았습니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: -275,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '스포닝풀이 아주 빨리 올라갔는데 상대는 풀조차 없는 상태에서 저글링이 옵니다!',
          altText: '앞마당을 먼저 올렸는데 이렇게 빠른 스포닝풀에는 가장 취약합니다! 풀이 아예 없어요!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 8-12)
    ScriptPhase(
      name: 'ling_rush',
      linearEvents: [
        ScriptEvent(
          owner: LogOwner.home,
          text: '{home} 선수 저글링이 상대 앞마당에 도착합니다! 스포닝풀이 없습니다!',
          altText: '{home} 선수, 저글링 도착! 상대는 아직 풀도 없습니다!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.away,
          text: '{away} 선수 스포닝풀이 없습니다! 드론으로 막아야 합니다!',
          altText: '{away} 선수, 드론밖에 없습니다! 풀이 올라오기까지 버텨야 해요!',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4,
          awayResource: 0,
        ),
        ScriptEvent(
          owner: LogOwner.system,
          text: '극초반 저글링 올인! 앞마당부터 올린 상대는 드론만으로 막을 수 있을까요?',
          altText: '앞마당부터 올린 쪽은 드론 수가 많지만 저글링 상대로 충분할까요?',
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 13-24)
    ScriptPhase(
      name: 'rush_result',
      branches: [
        // 분기 A: 12앞마당 수비 성공 (낮은 확률)
        ScriptBranch(
          id: 'drone_defense',
          description: '(phase2) 분기A - 드론 수비 성공',
          baseProbability: 1.0,
          conditionStat: 'control+defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 드론을 뭉쳐서 저글링과 교전합니다! 드론 컨트롤이 좋습니다!',
              altText: '{away} 선수, 드론 컨트롤! 앞마당에서 저글링을 잡아냅니다!',
              homeArmy: -4,
              homeResource: 0,
              awayArmy: -1,
              awayResource: -100,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 드론에 당하고 있습니다! 앞마당을 뚫지 못합니다!',
              altText: '{home} 선수, 초반 저글링이 밀립니다! 드론 물량을 못 이깁니다!',
              homeArmy: -3,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 앞마당을 지켜냈습니다! 스포닝풀 완성에 저글링까지 나옵니다!',
              altText: '{away} 선수, 풀 완성! 저글링이 나오면서 라바 2개의 위력이 시작됩니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 10,
              awayResource: -500,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '초반 저글링 러시가 막혔습니다! 해처리 2개의 라바 차이가 압도적입니다!',
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 4풀 올인 성공
        ScriptBranch(
          id: 'pool_crushes',
          description: '(phase2) 분기B - 4풀 올인 성공',
          baseProbability: 3.0,
          events: [
            ScriptEvent(
              owner: LogOwner.home,
              text: '{home} 선수 저글링이 앞마당을 두드립니다! {away} 선수 드론이 앞마당으로 몰려갑니다!',
              altText: '{home} 선수, 저글링이 앞마당 해처리를 공격! 드론이 수비하러 내려옵니다!',
              homeArmy: 2,
              homeResource: 0,
              awayArmy: -5,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 드론을 뭉쳐서 대응해보지만 저글링이 계속 추가됩니다!',
              altText: '{away} 선수, 드론으로 막아보지만 저글링이 끝없이 들어옵니다!',
              homeArmy: 2,
              homeResource: -100,
              awayArmy: -5,
              awayResource: -150,
            ),
            ScriptEvent(
              owner: LogOwner.away,
              text: '{away} 선수 앞마당 해처리를 취소합니다! 하지만 저글링은 그대로 본진까지!',
              altText: '{away} 선수, 앞마당을 포기합니다! 저글링이 본진으로 진격합니다!',
              homeArmy: 2,
              homeResource: -100,
              awayArmy: -3,
              awayResource: -200,
            ),
            ScriptEvent(
              owner: LogOwner.home,
              text: '본진까지 진격한 저글링이 이제 나오기 시작한 저글링과 드론을 학살합니다! 앞마당이 너무 컸습니다!',
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
