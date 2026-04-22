part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 다크 올인 vs 쓰리게이트 스피드질럿
// ----------------------------------------------------------
const _pvpDarkVs3gateSpeedzealot = ScenarioScript(
  id: 'pvp_dark_vs_3gate_speedzealot',
  matchup: 'PvP',
  homeBuildIds: ['pvp_dark_allin'],
  awayBuildIds: ['pvp_3gate_speedzealot'],
  description: '다크 올인 vs 쓰리게이트 스피드질럿',
  phases: [
    // Phase 0: 오프닝 (lines 1-14)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -15,
        ),
        ScriptEvent(
          text: '{away} 선수 게이트웨이 건설합니다.',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 아둔 건설! 다크를 노립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 아둔! 다크 올인 빌드입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 아둔 건설! 스피드 질럿을 준비합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -20,
          altText: '{away} 선수, 아둔! 질럿 각속 업그레이드를 노립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 게이트웨이를 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -30,
          altText: '{away} 선수, 게이트웨이가 벌써 세 개! 질럿 물량이 나옵니다!',
        ),
        ScriptEvent(
          text: '양쪽 다 아둔을 갔지만 목적이 다릅니다! 다크 vs 스피드질럿!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 스피드질럿 돌진 + 다크 투입 (lines 15-22)
    ScriptPhase(
      name: 'race_to_tech',
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수, 각속 업그레이드 완료! 스피드질럿이 쏟아집니다!',
          owner: LogOwner.away,
          homeResource: 0,
          awayArmy: 5, homeArmy: 2, awayResource: -15,          altText: '{away} 선수 스피드질럿! 빠른 질럿이 돌진합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 템플러 아카이브 건설 중! 다크가 곧 나옵니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 1, homeResource: -20,
        ),
        ScriptEvent(
          text: '스피드질럿이 먼저 도착할까, 다크가 먼저 나올까! 타이밍 승부!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 2: 결과 - 분기 (lines 23-38)
    ScriptPhase(
      name: 'timing_result',
      branches: [
        // 분기 A: 스피드질럿이 먼저 밀어냄
        ScriptBranch(
          id: 'speedzealot_rush',
          baseProbability: 1.05,
          events: [
            ScriptEvent(
              text: '{away} 선수, 스피드질럿이 본진을 돌파합니다! 너무 빠릅니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: -2, homeResource: -10,              altText: '{away} 선수 스피드질럿 돌진! 다크가 나오기 전입니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 프로브로 막으려 하지만 질럿이 너무 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,
            ),
            ScriptEvent(
              text: '{away} 선수, 추가 스피드질럿 합류! 건물이 무너집니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayResource: 0,
              awayArmy: 2, homeResource: -10,            ),
            ScriptEvent(
              text: '스피드질럿 물량이 다크보다 빨랐습니다! 본진 초토화!',
              owner: LogOwner.away,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -10,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 다크가 나와서 역전
        ScriptBranch(
          id: 'dark_reversal',
          baseProbability: 0.95,
          events: [
            ScriptEvent(
              text: '{home} 선수, 다크 템플러가 나옵니다! 스피드질럿을 막아냅니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3,              altText: '{home} 선수 다크 등장! 질럿이 보이지 않는 칼에 쓰러집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 질럿이 다크에 녹습니다! 디텍이 없어요!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -4,
            ),
            ScriptEvent(
              text: '{home} 선수, 다크를 상대 본진으로 투입합니다! 프로브 사냥!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -25,            ),
            ScriptEvent(
              text: '다크 올인 성공! 스피드질럿 물량을 넘겼습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -10,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
