part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9풀 레어 vs 9오버풀 — 빠른 뮤탈 vs 드론 안정
// 타이밍: 9풀 레어 저글링 2:14, 레어 3:11, 스파이어 4:01, 뮤탈 4:39
//         9오버풀 풀 2:15, 저글링 ~2:33, 드론 1기 우위
// 핵심: 9풀 레어가 뮤탈을 빨리 뽑지만 가스 드론 유지로 미네랄 부족
//       9오버풀은 드론 안정 + 확장 분기로 대응
// ----------------------------------------------------------
const _zvz9poolLairVs9overpool = ScenarioScript(
  id: 'zvz_9pool_lair_vs_9overpool',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9pool_lair'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9풀 레어 vs 9오버풀 — 저글링전 → 확장 → 뮤탈전',
  phases: [
    // Phase 0: 오프닝 (lines 1-10)
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
          homeResource: -15,
          altText: '{home}, 9드론에 스포닝풀과 가스를 동시에! 빠른 레어를 노리나봅니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 9드론에 오버로드를 먼저 올립니다! 풀은 그 다음!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
          altText: '{away}, 9드론에 오버로드 후 스포닝풀! 인구를 먼저 확보하고 풀 진입!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 6기 생산! 가스 100에서 레어 진화 시작!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 6, homeResource: -5,
          altText: '{home}, 저글링과 레어 진화! 가스 드론은 계속 가스를 캡니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 풀이 완성되면서 저글링 생산! 오버로드를 먼저 올린 만큼 살짝 늦습니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 4, awayResource: -10,
          altText: '{away}, 저글링이 나옵니다! 상대보다 한 박자 늦지만 드론이 1기 많습니다!',
        ),
        ScriptEvent(
          text: '빠른 테크를 노리는 쪽 대 드론 안정을 가진 쪽! 어느 쪽이 유리할까요?',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '테크가 빠른 쪽과 드론이 안정적인 쪽의 대결입니다!',
        ),
      ],
    ),
    // Phase 1: 저글링 도착 (lines 8-12)
    ScriptPhase(
      name: 'ling_arrives',
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링이 도착합니다! 상대도 저글링이 나와있습니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          altText: '{home}, 저글링 도착! 하지만 상대 저글링과 마주칩니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링으로 수비합니다! 드론도 1기 더 많은 상태!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayResource: 0,
          awayArmy: 2,
          altText: '{away}, 저글링이 준비되어 있습니다!',
        ),
        ScriptEvent(
          text: '가스 드론을 유지하고 있어서 저글링 보충이 살짝 느립니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.3,
          altText: '레어 진화를 위해 가스에 투자하는 중! 미네랄이 부족합니다!',
        ),
      ],
    ),
    // Phase 2: 초반 저글링 교전 (lines 13-17)
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
              text: '초반 저글링전은 비등! 이제 확장과 테크 타이밍이 중요합니다!',
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
              homeArmy: -2, awayArmy: -1, awayResource: -10,              altText: '{home}, 저글링 컨트롤! 드론을 몇 기 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론이 빠졌지만 아직 괜찮습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{away}, 드론 손실이 있지만 게임은 계속됩니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_ling_defense',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 저글링과 드론으로 상대 저글링을 잡아냅니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -3, awayArmy: -1,              altText: '{away}, 드론 합세로 저글링을 잡습니다! 깔끔한 수비!',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링이 좀 빠졌습니다! 레어 완성을 기다려야 합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              altText: '{home}, 저글링 손실! 레어 진화에 집중해야 합니다!',
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 확장 + 테크 분기 (lines 18-22)
    ScriptPhase(
      name: 'expansion_phase',
      branches: [
        // 분기 A: 9풀 레어가 뮤탈 선점으로 확장 타이밍 끊기
        ScriptBranch(
          id: 'lair_mutal_timing',
          baseProbability: 0.8,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 완성! 바로 테크를 올립니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
              altText: '{home}, 레어 완성! 바로 테크를 올립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어를 올립니다! 뮤탈이 빠르게 나옵니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수 해처리를 추가하면서 확장에 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,
              altText: '{away}, 앞마당 해처리! 하지만 상대 테크가 먼저 올라올 시점!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크 등장! 확장 중인 상대 드론을 견제합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              homeArmy: 5, awayResource: -15,              altText: '{home}, 뮤탈로 드론 견제! 확장 타이밍을 정확히 노렸습니다!',
            ),
            ScriptEvent(
              text: '뮤탈 선점이 확장 타이밍을 끊었습니다! 레어 빌드의 승리!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '빠른 뮤탈이 빛을 발합니다! 드론 견제로 결착!',
            ),
          ],
        ),
        // 분기 B: 9오버풀이 확장 수비 후 경제 우위
        ScriptBranch(
          id: 'overpool_economy_wins',
          baseProbability: 0.8,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away} 선수 해처리를 추가하면서 저글링도 충분히 보충합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 3, awayResource: -20,
              altText: '{away}, 확장과 수비를 동시에! 드론 우위가 빛납니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 레어는 완성됐지만 미네랄이 부족해서 테크가 늦어집니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,
              altText: '{home}, 가스 드론 유지로 미네랄이 부족합니다! 테크가 늦어요!',
            ),
            ScriptEvent(
              text: '{away} 선수 해처리 2개의 라바로 저글링을 쏟아냅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayArmy: 4, awayResource: -10,              altText: '{away}, 라바 이점이 폭발합니다! 저글링 물량이 밀려옵니다!',
            ),
            ScriptEvent(
              text: '스파이어 완성 전에 저글링 물량으로 밀어붙입니다! 라바 차이!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '스파이어 전에 저글링으로 결착! 라바 이점의 승리!',
            ),
          ],
        ),
        // 분기 C: 양쪽 확장 → 뮤탈전
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 레어 완성! 앞마당 해처리도 건설합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20,
              homeExpansion: true,
              altText: '{home}, 레어 챙기고 확장! 테크를 준비합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 스파이어도 올립니다!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 0, awayArmy: 0,
            ),
            ScriptEvent(
              text: '{away} 선수도 해처리를 추가합니다! 확장에 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,
              awayExpansion: true,
              altText: '{away}, 앞마당 해처리! 경기가 중반으로 넘어갑니다!',
            ),
            ScriptEvent(
              text: '양쪽 모두 확장! 스파이어 싸움이 시작됩니다!',
              owner: LogOwner.system,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              skipChance: 0.3,
              altText: '둘 다 앞마당! 빠른 레어 쪽 테크가 먼저 완성될까요?',
            ),
          ],
        ),
      ],
    ),
    // Phase 3.5: 스파이어 건설 (startLine 23)
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
    // Phase 4: 뮤탈전 (lines 26-33)
    ScriptPhase(
      name: 'mutal_war',
      branches: [
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 스파이어 완성! 뮤탈리스크가 먼저 나옵니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 5, homeResource: -20,
              altText: '{home}, 뮤탈 등장! 레어 빌드의 타이밍 이점!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈이 아직 멀었습니다! 스커지로 대응합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
              altText: '{away}, 스커지로 뮤탈을 잡으려 하지만 수가 부족합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 컨트롤로 스커지를 떨쳐냅니다! 드론 견제 성공!',
              owner: LogOwner.home,
              homeArmy: 0,
              homeResource: 0,
              awayResource: -15, awayArmy: -2,              altText: '{home}, 스커지를 피하면서 드론을 잡습니다! 뮤탈 컨트롤!',
            ),
            ScriptEvent(
              text: '뮤탈 선점 타이밍이 빛납니다! 드론 견제로 결착!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '레어 빌드의 뮤탈 타이밍 이점! 빠른 뮤탈이 승부를 갈랐습니다!',
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
              text: '{home} 선수 뮤탈이 먼저 나왔지만 상대 스커지가 정확히 적중합니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              awayResource: 0,
              homeArmy: 3, homeResource: -20,
              altText: '{home}, 뮤탈이 먼저지만 스커지에 피해를 입습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스포어 콜로니로 수비합니다! 공중 피해를 최소화합니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -10,
              skipChance: 0.7,
              altText: '{away}, 스포어로 본진과 앞마당을 수비합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 스커지로 뮤탈을 잡고 자기 뮤탈도 합류합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              homeArmy: -3, awayArmy: 5, awayResource: -20,              altText: '{away}, 스커지 적중! 뮤탈도 나오면서 물량 역전!',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈로 드론 견제! 해처리 라바 이점으로 보충도 빠릅니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -15,              altText: '{away}, 뮤탈 물량에서 앞섭니다! 드론 견제가 누적됩니다!',
            ),
            ScriptEvent(
              text: '스커지로 뮤탈 선점을 무력화! 라바 이점으로 물량 역전!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
              altText: '뮤탈 타이밍을 뒤집었습니다! 드론 우위의 승리!',
            ),
          ],
        ),
      ],
    ),
  ],
);
