part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 레어 vs 12앞마당 — 빠른 뮤탈 vs 더블 해처리
// 타이밍: 9풀 레어 저글링 2:14, 도착 ~2:51, 레어 3:11, 뮤탈 4:39
//         12앞 풀 2:52, 저글링 ~3:10
// → 9풀 레어 도착(2:51) 시 12앞은 풀이 막 완성! 저글링 없음
// → 초반 압박 후 확장 → 뮤탈전
// ----------------------------------------------------------
const _zvz9poolLairVs12hatch = ScenarioScript(
  id: 'zvz_9pool_lair_vs_12hatch',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_lair'],
  awayBuildIds: ['zvz_12hatch'],
  description: '9풀 레어 vs 12앞 — 저글링 압박 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9풀 레어! 풀과 가스를 동시에!',
        ),
        ScriptEvent(
          text: '{away} 선수 12드론에 앞마당 해처리를 먼저 건설합니다!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 12앞마당! 해처리를 먼저 올리고 풀은 나중에!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 가스 100에서 레어 진화 시작!',
          owner: LogOwner.home,
          homeArmy: 6, homeResource: -5,
          altText: '{home}, 저글링과 레어 진화! 가스 드론은 계속 가스를 캡니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 뒤늦게 스포닝풀을 올립니다! 앞마당에 투자해서 풀이 많이 늦었습니다!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 앞마당 해처리 후 스포닝풀! 저글링이 한참 뒤에 나옵니다!',
        ),
        ScriptEvent(
          text: '9풀 레어 대 12앞마당! 풀 완성 시점에 저글링이 도착합니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '12앞마당의 풀이 막 완성되려는 시점에 저글링이 도착합니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 — 풀 막 완성, 저글링 없음 (lines 11-16)
    ScriptPhase(
      name: 'ling_arrives',
      startLine: 11,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 12앞마당의 풀이 막 완성되는 시점입니다!',
          owner: LogOwner.home,
          favorsStat: 'attack',
          altText: '{home}, 저글링 도착! 상대 풀은 완성됐지만 저글링은 아직 없습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 풀은 완성됐지만 저글링이 아직 없습니다! 드론으로 막아야 합니다!',
          owner: LogOwner.away,
          awayArmy: 3,
          altText: '{away}, 저글링 생산을 시작했지만 나오려면 아직 시간이 필요합니다!',
        ),
        ScriptEvent(
          text: '풀은 완성됐는데 저글링이 안 나왔습니다! 드론으로 버텨야!',
          owner: LogOwner.system,
          skipChance: 0.3,
          altText: '12앞마당의 드론이 많지만 저글링 없이 버틸 수 있을까요?',
        ),
      ],
    ),
    // Phase 2: 초반 교전 결과 (lines 17-22)
    ScriptPhase(
      name: 'initial_fight',
      startLine: 17,
      branches: [
        ScriptBranch(
          id: 'fight_even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론을 뭉쳐서 저글링과 교전합니다! 저글링도 드론을 몇 기 잡습니다!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -1, awayResource: -10,
              altText: '드론 대 저글링! 양쪽 모두 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '비등한 교환! 저글링이 나오기 시작합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_drone_kill',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 드론을 물어뜯습니다! 저글링이 없어서 피해가 큽니다!',
              owner: LogOwner.home,
              homeArmy: -1, awayResource: -15, favorsStat: 'attack',
              altText: '{home}, 저글링 돌파! 드론이 녹고 있습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 피해가 심각합니다! 저글링이 빨리 나와야 하는데!',
              owner: LogOwner.away,
              awayResource: -5,
              altText: '{away}, 저글링 나오기 전에 드론이 많이 빠졌습니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_drone_defense',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론 컨트롤이 좋습니다! 저글링을 잡으면서 피해를 최소화합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 드론을 뭉쳐서 저글링을 하나씩 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 밀립니다! 드론 물량이 많습니다!',
              owner: LogOwner.home,
              altText: '{home}, 저글링이 드론에 당하고 있습니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 — 압박 vs 확장 (lines 23-30)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 23,
      branches: [
        // 분기 A: 저글링 추가 압박 + 뮤탈 선점으로 결착
        ScriptBranch(
          id: 'lair_pressure_kills',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링을 추가합니다! 레어 진화도 계속 진행 중!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -8, favorsStat: 'attack',
              altText: '{home}, 저글링 추가 투입! 레어는 곧 완성됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 노발업 저글링이 나왔지만 수가 부족합니다!',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -10,
              altText: '{away}, 저글링이 나왔지만 드론 손실이 큽니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레어 완성! 테크를 올리면서 압박도 계속합니다!',
              owner: LogOwner.home,
              homeResource: -15, favorsStat: 'harass',
              altText: '{home}, 레어 완성! 압박을 이어갑니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 올립니다! 테크 전환이 빠릅니다!',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
              altText: '{home}, 스파이어를 올립니다! 공중 유닛이 곧 나옵니다!',
            ),
            ScriptEvent(
              text: '저글링 압박에 뮤탈까지! 12앞마당이 버틸 수 없습니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '초반 압박으로 드론을 줄이고 뮤탈로 마무리! 레어 빌드의 승리!',
            ),
          ],
        ),
        // 분기 B: 12앞이 수비 후 라바 이점으로 결착
        ScriptBranch(
          id: 'hatch_defends_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 나오기 시작합니다! 드론과 합세해서 수비!',
              owner: LogOwner.away,
              awayArmy: 4, homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 저글링 합류! 드론과 저글링으로 압박을 막습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 압박이 막혔습니다! 가스 드론 유지로 미네랄도 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
              altText: '{home}, 압박 실패! 가스에 투자한 만큼 저글링이 부족합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바가 돌기 시작합니다! 저글링이 밀려옵니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -10, favorsStat: 'macro',
              altText: '{away}, 라바 이점이 폭발합니다! 저글링 물량이 다릅니다!',
            ),
            ScriptEvent(
              text: '12앞마당 수비 성공! 해처리 라바 이점으로 결착!',
              owner: LogOwner.away,
              decisive: true,
              altText: '드론 컨트롤로 버텨낸 12앞! 해처리 2개가 빛을 발합니다!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링이 나오면서 수비에 성공합니다! 드론 피해는 있지만 버텼습니다!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -2,
              altText: '{away}, 저글링 합류로 수비! 앞마당 해처리는 살아있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레어 완성! 앞마당 해처리도 건설합니다!',
              owner: LogOwner.home,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 레어 챙기고 확장! 테크를 준비합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어도 올립니다!',
              owner: LogOwner.home,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '양쪽 모두 앞마당! 스파이어 싸움이 시작됩니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '둘 다 확장! 테크 타이밍 싸움입니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 스파이어 전환 (lines 29-30)
    ScriptPhase(
      name: 'spire_transition',
      startLine: 29,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 스파이어가 올라갑니다! 공중 전환이 시작됩니다!',
          owner: LogOwner.home,
          altText: '{home}, 스파이어 완성! 공중 유닛 생산을 시작합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 스파이어를 올립니다! 대공 전환을 서두릅니다!',
          owner: LogOwner.away,
          altText: '{away}, 스파이어를 올립니다! 대공 준비에 들어갑니다!',
        ),
      ],
    ),
    // Phase 5: 뮤탈전 (lines 31-38)
    ScriptPhase(
      name: 'mutal_war',
      startLine: 31,
      branches: [
        // 분기: 뮤탈 일방 견제 — 12앞은 스파이어가 없음
        ScriptBranch(
          id: 'home_mutal_dominance',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 12앞마당은 아직 대공이 전혀 없습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 상대는 대공 유닛이 전혀 없어요!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈이 드론을 자유롭게 견제합니다! 대공 유닛이 없습니다!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'harass',
              altText: '{home}, 대공이 없는 12앞을 뮤탈이 마음껏 견제합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지를 급하게 뽑지만 수가 부족합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              altText: '{away}, 스커지로 대응하려 하지만 뮤탈이 너무 많습니다!',
            ),
            ScriptEvent(
              text: '일방적인 뮤탈 견제! 12앞마당의 드론이 전멸합니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '뮤탈을 막을 수단이 없습니다! 레어 빌드의 일방적 승리!',
            ),
          ],
        ),
        // 분기: 12앞이 스커지+저글링 반격으로 뮤탈 견제를 버텨냄
        ScriptBranch(
          id: 'away_survives_mutal',
          baseProbability: 1.0,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 나왔지만 상대 스커지가 정확히 적중합니다!',
              owner: LogOwner.home,
              homeArmy: 3, homeResource: -20,
              altText: '{home}, 뮤탈이 나왔는데 스커지에 당합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 대공 수비! 본진과 앞마당을 지킵니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지로 뮤탈을 잡습니다! 동시에 저글링으로 본진을 역습!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: 4, favorsStat: 'control',
              altText: '{away}, 스커지 적중! 뮤탈이 녹는 사이 저글링으로 반격!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바로 저글링을 쏟아냅니다! 뮤탈이 빠진 본진을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, homeResource: -15, favorsStat: 'macro',
              altText: '{away}, 뮤탈 잡고 저글링 돌진! 라바 이점으로 물량이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '스커지로 뮤탈을 잡고 저글링 반격! 해처리 라바 이점의 승리!',
              owner: LogOwner.away,
              decisive: true,
              altText: '뮤탈을 스커지로 무력화하고 저글링으로 결착! 12앞의 반격 승리!',
            ),
          ],
        ),
      ],
    ),
  ],
);
