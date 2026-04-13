part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 9. 9오버풀 미러 (준스탠다드 미러)
// ----------------------------------------------------------
const _zvz9overpoolMirror = ScenarioScript(
  id: 'zvz_9overpool_mirror',
  matchup: 'ZvZ',
  homeBuildIds: ['zvz_9overpool'],
  awayBuildIds: ['zvz_9overpool'],
  description: '9오버풀 미러 대결',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 모읍니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 드론 생산합니다.',
          owner: LogOwner.away,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 9드론에 오버로드 먼저! 이후 스포닝풀!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 9오버풀! 오버로드를 먼저 올리고 스포닝풀을 짓습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 9오버풀 스포닝풀!',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 9오버풀 스포닝풀! 드론 수가 같습니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링 생산과 발업 연구 시작!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 저글링과 발업! 드론 수가 같습니다!',
          owner: LogOwner.away,
          awayArmy: 4, awayResource: -10,
        ),
        ScriptEvent(
          text: '드론 수도 비슷합니다! 운영 싸움이 중요하겠습니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 1: 앞마당 선택 타이밍 (lines 17-28)
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 17,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 저글링을 모으면서 앞마당 건설 타이밍을 보고 있습니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'strategy',
          altText: '{home}, 저글링을 뭉칩니다! 앞마당을 시도할까요?',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당을 올리려 하지만 저글링이 걱정입니다.',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -10, favorsStat: 'strategy',
          altText: '{away}, 앞마당 타이밍을 노립니다! 저글링 견제가 두렵습니다!',
        ),
        ScriptEvent(
          text: 'ZvZ에서 앞마당을 올리는 순간이 가장 위험한 타이밍이죠!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다! 저글링을 앞에 세워두고 수비!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 앞마당 건설! 저글링으로 입구를 막으면서 시간을 법니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 앞마당 건설! 저글링을 앞에 깔아두면서 확장합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 앞마당! 양쪽 다 저글링 수비하면서 확장에 들어갑니다!',
        ),
      ],
    ),
    // Phase 2: 저글링 견제 - 분기 (lines 29-42)
    ScriptPhase(
      name: 'ling_skirmish',
      startLine: 29,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 6,
      branches: [
        // 분기 A: 홈이 저글링 견제 성공
        ScriptBranch(
          id: 'home_ling_harass',
          baseProbability: 0.6,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home}, 저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전!',
              owner: LogOwner.home,
              awayResource: -10, awayArmy: -2, favorsStat: 'harass',
              altText: '{home} 선수 저글링 견제! 앞마당 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 성큰이 아직 완성되지 않았습니다! 드론으로 막습니다!',
              owner: LogOwner.away,
              awayArmy: -1,
            ),
            ScriptEvent(
              text: '{home}, 드론 2기를 잡고 빠집니다! 약간의 이득!',
              owner: LogOwner.home,
              awayResource: -5, favorsStat: 'control',
              altText: '{home} 선수 깔끔한 견제! 드론 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '소소한 견제 성공! 이 작은 차이가 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이가 저글링 견제 성공
        ScriptBranch(
          id: 'away_ling_harass',
          baseProbability: 0.6,
          conditionStat: 'harass',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{away}, 저글링으로 상대 앞마당 드론을 노립니다! 성큰 완성 전!',
              owner: LogOwner.away,
              homeResource: -10, homeArmy: -2, favorsStat: 'harass',
              altText: '{away} 선수 저글링 견제! 앞마당 드론을 물어뜯습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 성큰이 아직 완성되지 않았습니다! 드론으로 막습니다!',
              owner: LogOwner.home,
              homeArmy: -1,
            ),
            ScriptEvent(
              text: '{away}, 드론 2기를 잡고 빠집니다! 약간의 이득!',
              owner: LogOwner.away,
              homeResource: -5, favorsStat: 'control',
              altText: '{away} 선수 깔끔한 견제! 드론 피해를 주고 빠집니다!',
            ),
            ScriptEvent(
              text: '소소한 견제 성공! 이 작은 차이가 중요합니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 스파이어 경쟁 (lines 43-58)
    ScriptPhase(
      name: 'spire_race',
      startLine: 43,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레어 진화를 시작합니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 해처리를 레어로 진화시킵니다!',
        ),
        ScriptEvent(
          text: '{away} 선수도 레어 진화! 누가 먼저 완성할까요?',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away} 선수도 레어! 테크 싸움이 시작됩니다!',
        ),
        ScriptEvent(
          text: '레어를 진화시키는 동안이 서로에게 가장 위험합니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 추가하면서 저글링 공격에 대비합니다.',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 성큰 추가! 안정적인 수비 태세!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 레어 완성! 다음 단계로 넘어갑니다!',
          owner: LogOwner.home,
          homeResource: -5,
          altText: '{home}, 레어 완성! 테크가 올라갑니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 건설! 공중 유닛 생산이 코앞입니다!',
          owner: LogOwner.home,
          homeResource: -10,
        ),
        ScriptEvent(
          text: '{away} 선수도 스파이어 건설! 누가 먼저 공중 유닛을 뽑을까요?',
          owner: LogOwner.away,
          awayResource: -15,
          altText: '{away}, 스파이어! 양쪽 공중전이 본격화됩니다!',
        ),
      ],
    ),
    // Phase 4: 뮤탈 교전 - 분기 (lines 59-72)
    ScriptPhase(
      name: 'mutal_clash',
      startLine: 59,
      branches: [
        // 분기 A: 홈 뮤탈 컨트롤 우위 (공격형)
        ScriptBranch(
          id: 'home_mutal_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지도 섞습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 스커지도 섞습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 집중 사격! 상대 뮤탈을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'control',
              altText: '{home} 선수 뮤탈 컨트롤! 효율적인 교환!',
            ),
            ScriptEvent(
              text: '{home}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 컨트롤 우위 (공격형)
        ScriptBranch(
          id: 'away_mutal_wins',
          baseProbability: 0.6,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지도 섞습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 스커지도 섞습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '{away}, 스커지로 뮤탈을 격추합니다! 동반 추락!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'control',
              altText: '{away} 선수 스커지 자폭! 뮤탈을 잡습니다!',
            ),
            ScriptEvent(
              text: '{away}, 드론을 물어뜯으면서 압박합니다!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 C: 홈 스포어 수비형 (에볼루션 챔버 + 스포어)
        ScriptBranch(
          id: 'home_spore_defense',
          baseProbability: 0.4,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 에볼루션 챔버에 스포어까지! 수비적인 선택!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 스커지도 섞습니다!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -20,
            ),
            ScriptEvent(
              text: '{home}, 스포어가 상대 뮤탈을 견제합니다! 안정적인 수비!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'defense',
              altText: '{home} 선수 스포어 수비! 뮤탈 피해를 줄입니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 드론을 물어뜯습니다! 드론 투자한 만큼 견제로 회수!',
              owner: LogOwner.home,
              awayResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
        // 분기 D: 어웨이 스포어 수비형 (에볼루션 챔버 + 스포어)
        ScriptBranch(
          id: 'away_spore_defense',
          baseProbability: 0.4,
          conditionStat: 'defense',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 나옵니다! 스커지도 섞습니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -20,
            ),
            ScriptEvent(
              text: '{away} 선수도 뮤탈 편대 완성! 에볼루션 챔버에 스포어까지! 수비적인 선택!',
              owner: LogOwner.away,
              awayArmy: 5, awayResource: -25,
            ),
            ScriptEvent(
              text: '{away}, 스포어가 상대 뮤탈을 견제합니다! 안정적인 수비!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away} 선수 스포어 수비! 뮤탈 피해를 줄입니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 드론을 물어뜯습니다! 드론 투자한 만큼 견제로 회수!',
              owner: LogOwner.away,
              homeResource: -10, favorsStat: 'harass',
            ),
          ],
        ),
      ],
    ),
    // Phase 5: 결전 - 분기 (lines 71-84)
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 71,
      branches: [
        // 분기 A: 홈 뮤탈 견제 승리
        ScriptBranch(
          id: 'home_decisive_win',
          baseProbability: 1.0,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 여기서 승부가 갈립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.home,
              homeArmy: 5, awayArmy: -5, awayResource: -15, favorsStat: 'harass',
              altText: '{home} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{home}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -5, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {home} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 어웨이 뮤탈 견제 승리
        ScriptBranch(
          id: 'away_decisive_win',
          baseProbability: 1.0,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전! 여기서 승부가 갈립니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away}, 뮤탈로 상대 드론을 견제합니다! 효율적인 교환!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -5, homeResource: -15, favorsStat: 'harass',
              altText: '{away} 선수 드론 견제! 자원 차이를 벌립니다!',
            ),
            ScriptEvent(
              text: '{away}, 뮤탈 수 차이로 제공권 장악!',
              owner: LogOwner.away,
              awayArmy: 3, homeArmy: -5, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '누적된 드론 차이가 결정적! {away} 선수 뮤탈 물량으로 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 홈 역전 (스커지 회피 + 스커지 적중)
        ScriptBranch(
          id: 'home_comeback',
          baseProbability: 0.05,
          conditionStat: 'control',
          events: [
            ScriptEvent(
              text: '밀리던 {home} 선수! 뮤탈 컨트롤로 상대 스커지를 전부 떨쳐냅니다!',
              owner: LogOwner.home,
              homeArmy: 2,
              altText: '{home} 선수 불리한 상황! 하지만 뮤탈 컨트롤이 살아있습니다!',
            ),
            ScriptEvent(
              text: '상대 스커지가 빗나갑니다! {home} 선수 뮤탈이 살아남았습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 스커지는 정확히 적중! 상대 뮤탈이 격추됩니다!',
              owner: LogOwner.home,
              awayArmy: -8, homeArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 스커지 명중! 한 순간에 뮤탈 수가 뒤집어집니다!',
            ),
            ScriptEvent(
              text: '스커지 회피와 적중이 동시에! {home} 선수 기적같은 역전승!',
              owner: LogOwner.home,
              awayResource: -20, favorsStat: 'attack',
              decisive: true,
            ),
          ],
        ),
        // 분기 D: 어웨이 역전 (스커지 회피 + 스커지 적중)
        ScriptBranch(
          id: 'away_comeback',
          baseProbability: 0.05,
          conditionStat: 'control',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '밀리던 {away} 선수! 뮤탈 컨트롤로 상대 스커지를 전부 떨쳐냅니다!',
              owner: LogOwner.away,
              awayArmy: 2,
              altText: '{away} 선수 불리한 상황! 하지만 뮤탈 컨트롤이 살아있습니다!',
            ),
            ScriptEvent(
              text: '상대 스커지가 빗나갑니다! {away} 선수 뮤탈이 살아남았습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 스커지는 정확히 적중! 상대 뮤탈이 격추됩니다!',
              owner: LogOwner.away,
              homeArmy: -8, awayArmy: -2, favorsStat: 'control',
              altText: '{away} 선수 스커지 명중! 한 순간에 뮤탈 수가 뒤집어집니다!',
            ),
            ScriptEvent(
              text: '스커지 회피와 적중이 동시에! {away} 선수 기적같은 역전승!',
              owner: LogOwner.away,
              homeResource: -20, favorsStat: 'attack',
              decisive: true,
            ),
          ],
        ),
        // 분기 E: 홈 저글링 서라운드 승리
        ScriptBranch(
          id: 'home_ling_surround',
          baseProbability: 0.6,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '뮤탈 소모전이 길어집니다! 양쪽 다 드론 피해가 쌓이고 있습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 저글링을 대량으로 보충합니다! 뮤탈 견제 틈을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 8, homeResource: -15, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{home} 선수 저글링 서라운드! 상대 본진까지 밀고 들어갑니다!',
              owner: LogOwner.home,
              awayArmy: -5, homeArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 견제와 저글링 서라운드 동시 공격! 막을 수가 없습니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 F: 어웨이 저글링 서라운드 승리
        ScriptBranch(
          id: 'away_ling_surround',
          baseProbability: 0.6,
          conditionStat: 'attack',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전이 길어집니다! 양쪽 다 드론 피해가 쌓이고 있습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{away} 선수 저글링을 대량으로 보충합니다! 뮤탈 견제 틈을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 8, awayResource: -15, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '{away} 선수 저글링 서라운드! 상대 본진까지 밀고 들어갑니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 뮤탈 견제와 저글링 서라운드 동시 공격! 막을 수가 없습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 G: 소모전 끝에 홈 승리 (장기전)
        ScriptBranch(
          id: 'home_long_game',
          baseProbability: 0.4,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '뮤탈 소모전이 길어집니다! 양쪽 다 드론을 보충하면서 버팁니다!',
              owner: LogOwner.system,
              homeResource: 10, awayResource: 10,
            ),
            ScriptEvent(
              text: '{home} 선수 드론 보충이 빠릅니다! 뮤탈을 추가로 뽑습니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -15, favorsStat: 'macro',
              altText: '{home}, 라바 차이! 뮤탈 추가 생산이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 드론 수가 점점 밀립니다! 뮤탈 보충이 느려지고 있습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '미세한 자원 차이가 누적되면서 {home} 선수가 서서히 밀어붙입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 H: 소모전 끝에 어웨이 승리 (장기전)
        ScriptBranch(
          id: 'away_long_game',
          baseProbability: 0.4,
          conditionStat: 'macro',
          homeStatMustBeHigher: false,
          events: [
            ScriptEvent(
              text: '뮤탈 소모전이 길어집니다! 양쪽 다 드론을 보충하면서 버팁니다!',
              owner: LogOwner.system,
              homeResource: 10, awayResource: 10,
            ),
            ScriptEvent(
              text: '{away} 선수 드론 보충이 빠릅니다! 뮤탈을 추가로 뽑습니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -15, favorsStat: 'macro',
              altText: '{away}, 라바 차이! 뮤탈 추가 생산이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 드론 수가 점점 밀립니다! 뮤탈 보충이 느려지고 있습니다!',
              owner: LogOwner.home,
              homeArmy: -3,
            ),
            ScriptEvent(
              text: '미세한 자원 차이가 누적되면서 {away} 선수가 서서히 밀어붙입니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
