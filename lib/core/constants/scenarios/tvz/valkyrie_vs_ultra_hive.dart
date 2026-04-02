part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 발키리 대공 vs 울트라 하이브 — 대공 투자 vs 지상 최종병기
// ----------------------------------------------------------
const _tvzValkyrieVsUltraHive = ScenarioScript(
  id: 'tvz_valkyrie_vs_ultra_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_trans_valkyrie'],
  awayBuildIds: ['zvt_trans_ultra_hive'],
  description: '발키리 대공 투자 vs 울트라리스크 하이브 테크',
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
          text: '{away} 선수 앞마당에 해처리를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 해처리부터 올리면서 드론을 뽑습니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리를 올립니다! 스타포트 테크!',
          owner: LogOwner.home,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설 후 드론에 집중합니다.',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 드론을 열심히 뽑고 있습니다! 매크로 빌드!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린 소량 생산하면서 테크를 올립니다.',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -5,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 테크 경쟁 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스타포트 건설! 컨트롤타워까지 붙입니다!',
          owner: LogOwner.home,
          homeResource: -20,
        ),
        ScriptEvent(
          text: '{away} 선수 레어를 올리고 3번째 해처리를 확보합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'macro',
          altText: '{away}, 3해처리 체제! 자원이 쏟아집니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리 생산을 시작합니다!',
          owner: LogOwner.home,
          homeArmy: 3,
          homeResource: -20,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '{away} 선수 하이브를 올립니다! 울트라리스크를 노립니다!',
          owner: LogOwner.away,
          awayResource: -25,
          favorsStat: 'strategy',
        ),
        ScriptEvent(
          text: '발키리가 나왔지만 저그는 공중이 아닌 지상 최종 테크를 갑니다!',
          owner: LogOwner.system,
        ),
      ],
    ),
    // Phase 2: 울트라 등장 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 울트라리스크 생산 시작! 카이틴 업그레이드!',
          owner: LogOwner.away,
          awayArmy: 5,
          awayResource: -25,
          favorsStat: 'macro',
          altText: '{away}, 울트라리스크가 나옵니다! 지상 최종병기!',
        ),
        ScriptEvent(
          text: '{home} 선수 발키리가 있지만 울트라에는 소용이 없습니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크를 급히 추가합니다! 지상 방어!',
          owner: LogOwner.home,
          homeArmy: 2,
          homeResource: -15,
          favorsStat: 'sense',
        ),
        ScriptEvent(
          text: '울트라리스크가 전장에 등장합니다! 발키리로는 답이 없어요!',
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
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 시즈탱크로 울트라를 집중 포격합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -4,
              favorsStat: 'defense',
              altText: '{home}, 시즈탱크 화력이 울트라를 멈춥니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린 메딕이 합류해서 저글링을 정리합니다!',
              owner: LogOwner.home,
              homeArmy: 3,
              awayArmy: -2,
              favorsStat: 'control',
            ),
            ScriptEvent(
              text: '{away} 선수 울트라가 시즈 화력에 녹습니다! 후속이 부족해요!',
              owner: LogOwner.away,
              awayArmy: -3,
              awayResource: -15,
            ),
            ScriptEvent(
              text: '지상 전환 성공! 울트라를 막아냈습니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 테란 진영을 돌파합니다!',
              owner: LogOwner.away,
              awayArmy: 5,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away}, 울트라가 마린을 밀어버립니다! 막을 수가 없어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 발키리가 하늘에서 바라만 봅니다! 대공이 무의미!',
              owner: LogOwner.home,
              homeArmy: -3,
              homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링과 울트라가 테란 본진을 짓밟습니다!',
              owner: LogOwner.away,
              awayArmy: 3,
              homeArmy: -2,
              favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '울트라 앞에 발키리는 무력했습니다! 지상이 무너졌어요! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
