part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 레이스 vs 2해처리 뮤탈 — 클로킹 vs 디텍팅, 공중 주도권
// ----------------------------------------------------------
const _tvzWraithVs2hatchMutal = ScenarioScript(
  id: 'tvz_wraith_vs_2hatch_mutal',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_wraith'],
  awayBuildIds: ['zvt_trans_2hatch_mutal'],
  description: '레이스 클로킹 vs 2해처리 빠른 뮤탈리스크',
  phases: [
    // Phase 0: opening (lines 1-11)
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
          text: '{away} 선수 앞마당 해처리를 올립니다! 2해처리 뮤탈!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 2해처리 체제! 뮤탈을 빠르게 뽑을 준비입니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 건설합니다! 스타포트를 향한 테크!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 가스를 빠르게 넣습니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 가스를 서둘러 넣습니다! 뮤탈이 빠르겠네요!',
        ),
        ScriptEvent(
          text: '양쪽 모두 공중 유닛을 준비합니다! 하늘의 주인은 누구?',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 1: 공중 유닛 생산 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 레이스 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -20,
          altText: '{home}, 스타포트에서 레이스! 클로킹을 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 레어 완성! 스파이어를 올립니다!',
          owner: LogOwner.away,
          awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈리스크 편대 생산! 테란 본진으로!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'harass',
          altText: '{away}, 뮤탈이 나왔습니다! 곧장 견제 갑니다!',
        ),
        ScriptEvent(
          text: '레이스와 뮤탈이 동시에 전장에 등장합니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 견제전 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 클로킹 레이스가 오버로드를 사냥합니다!',
          owner: LogOwner.home,
          awayResource: -15,
          favorsStat: 'harass',
          altText: '{home}, 투명 레이스! 오버로드를 하나둘 잡습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뮤탈이 테란 SCV를 급습합니다!',
          owner: LogOwner.away,
          homeResource: -15,
          favorsStat: 'harass',
        ),
        ScriptEvent(
          text: '{away} 선수 스포어 콜로니를 건설합니다! 클로킹 대비!',
          owner: LogOwner.away,
          awayResource: -10,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '클로킹 vs 디텍팅! 서로의 일꾼을 노리는 견제전!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 30,
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스가 드론을 학살합니다! 디텍팅이 부족!',
              owner: LogOwner.home,
              awayResource: -25,
              favorsStat: 'harass',
              altText: '{home}, 레이스가 보이지 않습니다! 드론이 녹아요!',
            ),
            ScriptEvent(
              text: '{away} 선수 오버로드가 전멸! 서플라이가 막혔습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '{home} 선수 지상군으로 마무리! 자원 차이가 압도적!',
              owner: LogOwner.home,
              homeArmy: 4,
              awayArmy: -3,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '클로킹 레이스가 저그의 숨통을 끊었습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 레이스를 잡아냅니다! 디텍팅 성공!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'scout',
              altText: '{away}, 스포어가 클로킹 레이스를 발견! 격추!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 수적 우위! SCV를 계속 잡습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeResource: -20,
              favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 격추당하고 지상군도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '뮤탈이 제공권 장악! 클로킹이 통하지 않았습니다! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
