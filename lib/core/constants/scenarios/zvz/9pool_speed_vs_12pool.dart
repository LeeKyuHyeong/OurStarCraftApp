part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 발업 vs 12풀 — 발업 속도 우위 구간 vs 드론 3기 우위
// 타이밍: 9풀 발업 저글링 2:14, 도착 2:51, 발업 완료 2:58
//         12풀 풀 완성 2:22, 저글링 ~2:40, 발업 완료 3:29
// → 9풀 도착(2:51) 시 12풀은 이미 저글링 보유(2:40)!
// → 발업 속도 차이 구간(2:58~3:29)이 승부처
// → 둘 다 무난하면 확장 → 레어 → 스파이어 → 뮤탈전
// ----------------------------------------------------------
const _zvz9poolSpeedVs12pool = ScenarioScript(
  id: 'zvz_9pool_speed_vs_12pool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_speed'],
  awayBuildIds: ['zvz_12pool'],
  description: '9풀 발업 vs 12풀 — 저글링전 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 빌드 차이 (lines 1-10)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 9드론에 스포닝풀과 익스트랙터를 동시에 건설합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -50,
          altText: '{home} 선수, 9드론에 스포닝풀과 가스를 동시에! 저글링 속업을 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 드론을 12기까지 뽑고 스포닝풀을 올립니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -50,
          altText: '{away} 선수, 12드론까지 모은 후 스포닝풀! 드론이 3기 더 많은 상태에서 풀 진입!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 발업도 연구 시작합니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 3, homeResource: -350,
          altText: '{home} 선수, 저글링에 발업! 상대 진영으로 출발합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀이 완성됩니다! 저글링 생산 시작!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 2, awayResource: -100,
          altText: '{away} 선수, 드론을 많이 뽑아서 풀이 늦었지만 드론이 많습니다! 저글링도 나옵니다!',
        ),
        ScriptEvent(
          text: '저글링은 스포닝풀이 빨랐던 쪽이 먼저지만 드론은 상대가 3기 많습니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '발업 타이밍 대 드론 우위! 어느 쪽이 유리할까요?',
        ),
      ],
    ),
    // Phase 1: 9풀 도착 — 12풀은 이미 저글링 보유 (lines 10-14)
    ScriptPhase(
      name: 'ling_arrives',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대도 이미 저글링이 나와있습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home} 선수, 저글링 도착! 하지만 상대 저글링이 수비하고 있습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비합니다! 드론 수도 12기로 여유있습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2,
          altText: '{away} 선수, 저글링이 준비되어 있고 드론도 많습니다!',
        ),
        ScriptEvent(
          text: '노발업 저글링 대 노발업 저글링! 하지만 드론 수에서 차이가 납니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '아직 발업이 안 끝났습니다! 노발업 상태에서 교전!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 교전 결과 (lines 15-19)
    ScriptPhase(
      name: 'ling_skirmish',
      branches: [
        ScriptBranch(
          id: 'ling_even',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '양쪽 저글링이 부딪힙니다! 비등한 교전입니다!',
              owner: LogOwner.system,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2, awayArmy: -2,
              altText: '저글링 대 저글링! 서로 비슷한 피해를 주고받습니다!',
            ),
            ScriptEvent(
              text: '초반 저글링전은 비등! 발업 완료 타이밍이 승부처입니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
            ),
          ],
        ),
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 저글링이 수비 저글링을 피해 드론을 물어뜯습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              homeArmy: -2, awayArmy: -1, awayResource: -100,              altText: '{home} 선수, 저글링 컨트롤! 상대 드론을 몇 기 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠졌지만 아직 드론 우위가 남아있습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{away} 선수, 드론 손실이 있지만 드론 우위는 건재합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_defense',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 드론과 저글링으로 상대 저글링을 잡아냅니다! 드론 물량이 다릅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: -1,              altText: '{away} 선수, 드론 합세로 상대 저글링을 잡습니다! 물량이 다릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 좀 빠졌습니다! 발업 완료를 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home} 선수, 저글링 손실! 발업이 완료되면 속도 차이로 만회해야 합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 발업 속도 차이 구간 + 확장 (lines 20-24)
    ScriptPhase(
      name: 'speed_window',
      branches: [
        // 분기 A: 발업 속도 차이로 드론 격차 뒤집기
        ScriptBranch(
          id: 'speed_closes_gap',
          baseProbability: 0.8,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 상대는 아직 발업이 멀었습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 3, homeResource: -150,
              altText: '{home} 선수, 발업 저글링! 속도 차이가 나기 시작합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 발업 저글링이 노발업 저글링을 압도합니다! 드론까지 물어뜯습니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayArmy: -3, awayResource: -150, homeArmy: -1,              altText: '{home} 선수, 속도 차이가 결정적! 노발업 저글링이 발업을 못 따라갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 손실이 커집니다! 발업 완료까지 시간이 남았는데!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -100,
              altText: '{away} 선수, 발업 완료까지 아직 멀었는데 드론이 빠지고 있습니다!',
            ),
            ScriptEvent(
              text: '발업 속도 차이 구간에서 드론 격차를 뒤집었습니다! 발업 타이밍의 승리!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론 우위가 사라졌습니다! 발업 타이밍이 적중!',
            ),
          ],
        ),
        // 분기 B: 12풀이 드론 우위로 수비 후 경제 승리
        ScriptBranch(
          id: 'twelve_pool_economy',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 압박을 넣지만 상대의 수비가 단단합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 2, homeResource: -100,
              altText: '{home} 선수, 발업 저글링으로 압박! 하지만 상대 물량이 많습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 3기 우위로 저글링을 충분히 보충합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: 3,              altText: '{away} 선수, 드론 물량의 이점! 저글링 보충이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 발업도 완료됩니다! 속도가 같아지면 드론 우위가 결정적!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 2, awayResource: -100,              altText: '{away} 선수, 발업도 완료! 이제 드론 3기 차이만 남았습니다!',
            ),
            ScriptEvent(
              text: '발업 구간을 버텨냈습니다! 드론 우위로 결착!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론 3기 차이를 지켜냈습니다! 경기 운영의 승리!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 발업 완료! 앞마당 해처리도 건설합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -300,
              homeExpansion: true,
              altText: '{home} 선수, 발업 챙기고 확장! 경기가 중반으로 넘어갑니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당 해처리를 건설합니다! 드론 우위를 유지합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -300,
              awayExpansion: true,
              altText: '{away} 선수, 드론 우위를 살려서 확장! 중반전을 가져갑니다!',
            ),
            ScriptEvent(
              text: '양쪽 모두 확장! 이제 테크 싸움이 시작됩니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '둘 다 앞마당! 이제 테크 타이밍이 관건입니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3.5: 스파이어 건설 (startLine 25)
    ScriptPhase(
      name: 'spire_transition',
      linearEvents: [
        ScriptEvent(
          text: '양쪽 스파이어가 올라갑니다! 뮤탈전이 임박합니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '스파이어 완성! 뮤탈리스크 생산이 시작됩니다!',
        ),
      ],
    ),
    // Phase 4: 뮤탈전 (lines 28-35)
    ScriptPhase(
      name: 'mutal_war',
      branches: [
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 진화 시작! 테크를 서두릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -250,
              altText: '{home} 선수, 레어 진화! 뮤탈 타이밍을 노립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수도 레어 진화! 가스를 모읍니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -250,
              altText: '{away} 선수, 레어 진화! 드론 우위로 가스도 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 나옵니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 5, homeResource: -800,
              altText: '{home} 선수, 뮤탈 등장! 상대 드론을 견제합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 상대 스커지를 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -150, awayArmy: -2,              altText: '{home} 선수, 뮤탈 컨트롤이 좋습니다! 스커지를 피하면서 드론을 잡습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 컨트롤 차이! 드론 견제가 누적되면서 결착!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론 견제에서 앞서면서 물량 차이를 벌립니다! 발업 타이밍의 승리!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 레어 진화! 드론 우위로 가스가 빠르게 모입니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -250,
              altText: '{away} 선수, 레어 진화! 드론이 많아서 가스도 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수도 레어 진화! 테크를 서두릅니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -250,
              altText: '{home} 선수, 레어 진화! 테크 타이밍에서 밀리면 안 됩니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스파이어 완성! 뮤탈리스크가 나옵니다! 드론이 많아 보충도 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 6, awayResource: -900,
              altText: '{away} 선수, 뮤탈 등장! 자원 우위로 뮤탈 추가가 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론 견제! 스커지도 정확히 적중합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -150, homeArmy: -2,              altText: '{away} 선수, 뮤탈 물량에서 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '자원 우위가 뮤탈전에서 빛을 발합니다! 물량 차이로 결착!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '드론이 많은 쪽이 뮤탈 보충이 빨라 물량에서 앞섭니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
