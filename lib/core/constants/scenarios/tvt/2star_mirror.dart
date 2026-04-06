part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 12. 투스타 레이스 미러 (공중전)
// ----------------------------------------------------------
const _tvt2starMirror = ScenarioScript(
  id: 'tvt_wraith_mirror',
  matchup: 'TvT',
  homeBuildIds: ['tvt_2star'],
  awayBuildIds: ['tvt_2star'],
  description: '투스타 레이스 미러 클로킹 공중전',
  phases: [
    // ── Phase 0: 오프닝 (lines 1-11) ── recovery 100/줄
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      recoveryResourcePerLine: 100,
      recoveryArmyPerLine: 0,
      linearEvents: [
        ScriptEvent(
          text: '양쪽 SCV가 정찰을 나갑니다. 투스타 미러 냄새가 납니다.',
          owner: LogOwner.system,
          altText: '양 선수 SCV 정찰. 상대 빌드를 확인합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 배럭 건설합니다. {away} 선수도 배럭.',
          owner: LogOwner.system,
          homeResource: -150, // 배럭 150
          awayResource: -150,
          fixedCost: true,
          altText: '양쪽 배럭이 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올립니다. {away} 선수도 가스.',
          owner: LogOwner.system,
          homeResource: -100, // 리파이너리 100
          awayResource: -100,
          fixedCost: true,
          altText: '양쪽 가스를 넣습니다.',
        ),
        ScriptEvent(
          text: '가스가 모이기 시작합니다. 테크 빌딩이 곧 올라오겠죠.',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 건설합니다. {away} 선수도 팩토리.',
          owner: LogOwner.system,
          homeResource: -300, // 팩토리 300
          awayResource: -300,
          fixedCost: true,
          altText: '양쪽 팩토리가 올라갑니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 스타포트 건설합니다. {away} 선수도 스타포트.',
          owner: LogOwner.system,
          homeResource: -250, // 스타포트 250
          awayResource: -250,
          fixedCost: true,
          altText: '양쪽 스타포트. 공중 유닛 생산 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 2번째 스타포트. {away} 선수도 투스타포트 완성.',
          owner: LogOwner.system,
          homeResource: -250, // 스타포트 250
          awayResource: -250,
          fixedCost: true,
          altText: '양쪽 투스타포트. 대량 생산 체제에 돌입합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 생산합니다. {away} 선수도 레이스.',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -250, // 레이스 250 (2sup)
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '양쪽 레이스가 출격합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 컨트롤타워 건설합니다. {away} 선수도 컨트롤타워.',
          owner: LogOwner.system,
          homeResource: -100, // 컨트롤타워 100
          awayResource: -100,
          fixedCost: true,
          altText: '양쪽 컨트롤타워. 클로킹 연구를 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 클로킹 연구 시작합니다. {away} 선수도 클로킹.',
          owner: LogOwner.system,
          homeResource: -300, // 클로킹 300
          awayResource: -300,
          fixedCost: true,
          altText: '양쪽 클로킹 연구. 타이밍이 승부를 가릅니다.',
        ),
        ScriptEvent(
          text: '투스타 레이스 미러! 클로킹 타이밍이 승부를 가릅니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // ── Phase 1: 레이스 공중전 (lines 12-19) ── recovery 150/줄 (early-mid)
    ScriptPhase(
      name: 'wraith_clash',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 레이스 추가 생산합니다. {away} 선수도 레이스 추가.',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -250, // 레이스 추가 (250/2sup)
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '양쪽 레이스가 추가 출격. 공중전이 시작됩니다.',
        ),
        ScriptEvent(
          text: '레이스 대 레이스! 컨트롤 대결이 펼쳐집니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 레이스 컨트롤! 상대 레이스를 집중 공격!',
          owner: LogOwner.home,
          awayArmy: -2, // 레이스 1기 격파 (2sup)
          favorsStat: 'control',
          altText: '{home} 선수 레이스 컨트롤이 좋습니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수도 레이스 컨트롤! 맞교환!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'control',
          altText: '{away} 선수 레이스 반격! 한 기를 잡아냅니다!',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '양쪽 클로킹 연구가 곧 완성됩니다. 타이밍이 중요해요.',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // ── Phase 2: 클로킹 전쟁 - 분기 (lines 20-31) ── recovery 150/줄
    ScriptPhase(
      name: 'cloak_war',
      startLine: 20,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 150,
      branches: [
        // 분기 A: 홈 클로킹 먼저
        ScriptBranch(
          id: 'home_cloak_first',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{home} 선수 클로킹 완성! 레이스가 투명해집니다! 상대 진영 침투!',
              owner: LogOwner.home,
              awayResource: -300, // SCV 학살
              favorsStat: 'harass',
              altText: '{home} 선수 클로킹 레이스 침투! SCV를 잡아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 디텍이 늦습니다. SCV가 녹고 있어요.',
              owner: LogOwner.away,
              awayArmy: -2, awayResource: -200,
              altText: '{away} 선수 터렛이 아직입니다. 일꾼 피해가 심각합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스로 SCV를 학살합니다! 대참사!',
              owner: LogOwner.home,
              awayResource: -200,
              favorsStat: 'harass',
              altText: '{home} 선수 레이스 학살! 일꾼이 전멸 직전!',
            ),
            ScriptEvent(
              text: '클로킹 한 발 차이. 디텍이 늦으면 이렇게 됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 어웨이 클로킹 먼저
        ScriptBranch(
          id: 'away_cloak_first',
          baseProbability: 1.0,
          conditionStat: 'harass',
          events: [
            ScriptEvent(
              text: '{away} 선수 클로킹 완성! 레이스가 상대 진영에 침투합니다!',
              owner: LogOwner.away,
              homeResource: -300,
              favorsStat: 'harass',
              altText: '{away} 선수 클로킹 레이스! SCV를 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 디텍이 없습니다. SCV가 녹고 있어요.',
              owner: LogOwner.home,
              homeArmy: -2, homeResource: -200,
              altText: '{home} 선수 터렛이 아직입니다. 일꾼 피해가 심각합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 클로킹 레이스로 SCV 학살! 상대 자원줄이 무너집니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 레이스 학살! 상대 일꾼이 녹습니다!',
            ),
            ScriptEvent(
              text: '클로킹 타이밍 차이! 한 발 빠른 쪽이 크게 앞섭니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 C: 양쪽 클로킹 동시
        ScriptBranch(
          id: 'both_cloak',
          baseProbability: 0.8,
          events: [
            ScriptEvent(
              text: '양쪽 클로킹이 거의 동시에 완성됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
            ScriptEvent(
              text: '{home} 선수 클로킹 레이스로 상대 레이스와 공중전! 보이지 않는 전투!',
              owner: LogOwner.home,
              awayArmy: -2, homeArmy: -2,
              favorsStat: 'control',
              altText: '{home} 선수 클로킹 레이스 대 레이스! 컨트롤 대결!',
            ),
            ScriptEvent(
              text: '{away} 선수 레이스 컨트롤로 반격! 치열한 공중전!',
              owner: LogOwner.away,
              homeArmy: -2, awayArmy: -2,
              favorsStat: 'control',
              altText: '{away} 선수 레이스 컨트롤! 클로킹 공중전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '클로킹 레이스 대 클로킹 레이스. 순수 컨트롤 대결입니다.',
              owner: LogOwner.system,
              skipChance: 0.4,
            ),
          ],
        ),
      ],
    ),
    // ── Phase 3: 지상 전환 + 터렛 (lines 32-39) ── recovery 200/줄 (mid-game)
    ScriptPhase(
      name: 'ground_transition',
      startLine: 32,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 터렛을 세웁니다. {away} 선수도 터렛.',
          owner: LogOwner.system,
          homeResource: -75, // 터렛 75
          awayResource: -75,
          fixedCost: true,
          altText: '양쪽 터렛 건설. 클로킹 대비입니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 아머리 건설합니다. {away} 선수도 아머리.',
          owner: LogOwner.system,
          homeResource: -150, // 아머리 150
          awayResource: -150,
          fixedCost: true,
          altText: '양쪽 아머리가 올라갑니다. 골리앗 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗 생산합니다. {away} 선수도 골리앗.',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -150, // 골리앗(150/2sup)
          awayArmy: 2, awayResource: -150,
          fixedCost: true,
          altText: '양쪽 골리앗이 생산됩니다. 대공 방어 준비.',
        ),
        ScriptEvent(
          text: '{home} 선수 머신샵 건설합니다. {away} 선수도 머신샵.',
          owner: LogOwner.system,
          homeResource: -100, // 머신샵 100
          awayResource: -100,
          fixedCost: true,
          altText: '양쪽 머신샵. 시즈 모드 연구를 준비합니다.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈탱크 생산합니다. {away} 선수도 시즈탱크.',
          owner: LogOwner.system,
          homeArmy: 2, homeResource: -250, // 시즈탱크(250/2sup)
          awayArmy: 2, awayResource: -250,
          fixedCost: true,
          altText: '양쪽 시즈탱크가 나옵니다. 지상전 전환.',
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 모드 연구합니다. {away} 선수도 시즈 모드.',
          owner: LogOwner.system,
          homeResource: -300, // 시즈모드 300
          awayResource: -300,
          fixedCost: true,
          altText: '양쪽 시즈 모드 연구. 포격전이 다가옵니다.',
        ),
        ScriptEvent(
          text: '레이스 교전이 끝나고 지상전으로 전환합니다. 레이스를 잃은 쪽이 불리합니다.',
          owner: LogOwner.system,
          skipChance: 0.4,
        ),
      ],
    ),
    // ── Phase 4: 탱크 푸시 체크 - 분기 (lines 40-49) ── recovery 200/줄
    ScriptPhase(
      name: 'tank_push_check',
      startLine: 40,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 비등 - 양쪽 라인 유지 (가장 빈번)
        ScriptBranch(
          id: 'tank_even',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 생산합니다. {away} 선수도 병력 보강.',
              owner: LogOwner.system,
              homeArmy: 4, homeResource: -400, // 탱크(250) + 골리앗(150)
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '양쪽 탱크 골리앗 조합. 라인을 잡아갑니다.',
            ),
            ScriptEvent(
              text: '양쪽 시즈 라인이 대치합니다. 누가 먼저 움직이느냐가 관건이죠.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '시즈 라인 대치. 쉽게 움직일 수 없는 상황입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 레이스가 남아 있어 정찰이 유리합니다.',
              owner: LogOwner.home,
              awayArmy: -2,
              favorsStat: 'scout',
              skipChance: 0.4,
              altText: '{home} 선수 레이스로 상대 병력 배치를 확인합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗 대공 사격! 레이스를 견제합니다!',
              owner: LogOwner.away,
              homeArmy: -2,
              favorsStat: 'defense',
              skipChance: 0.4,
              altText: '{away} 선수 골리앗으로 레이스를 쫓아냅니다!',
            ),
          ],
        ),
        // 홈 탱크 푸시 (레이스 우위 → 시야 확보 → 시즈 전진)
        ScriptBranch(
          id: 'home_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 레이스 수 우위! 시야를 확보하고 탱크가 전진합니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400, // 탱크와 골리앗 추가
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '{home} 선수 공중 우위를 살려 시즈 라인을 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
              owner: LogOwner.home,
              awayArmy: -6,
              homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 시즈탱크 화력! 상대 방어선이 무너집니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 화력 집중! {away} 선수 탱크가 녹습니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 레이스와 탱크 합동 공격! 막을 수가 없습니다!',
            ),
          ],
        ),
        // 어웨이 탱크 푸시
        ScriptBranch(
          id: 'away_tank_push',
          baseProbability: 0.5,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스 수 우위! 시야를 확보하고 탱크가 전진합니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              altText: '{away} 선수 공중 우위를 살려 시즈 라인을 밀어냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격! 상대 탱크 라인을 직격합니다!',
              owner: LogOwner.away,
              homeArmy: -6,
              awayArmy: -2,
              favorsStat: 'attack',
              altText: '{away} 선수 시즈탱크 화력! 상대 방어선이 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 화력 집중! {home} 선수 탱크가 녹습니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 레이스와 탱크 합동 공격! 막을 수가 없습니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 5: 확장 타이밍 - 분기 (lines 50-61) ── recovery 200/줄
    ScriptPhase(
      name: 'expansion_timing',
      startLine: 50,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      branches: [
        // 동시 확장 (가장 빈번)
        ScriptBranch(
          id: 'both_expand',
          baseProbability: 1.5,
          events: [
            ScriptEvent(
              text: '{home} 선수 앞마당에 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400, // 커맨드센터 400
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 앞마당 확장. 자원 보충이 필요합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 앞마당에 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 앞마당 확장. 미러 전개입니다.',
            ),
            ScriptEvent(
              text: '양쪽 앞마당 확장이 올라갑니다. 자원 싸움이 본격화됩니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '양쪽 확장이 비슷한 타이밍. 균형 잡힌 전개입니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 보강합니다. {away} 선수도 병력 추가.',
              owner: LogOwner.system,
              homeArmy: 4, homeResource: -400, // 탱크와 골리앗
              awayArmy: 4, awayResource: -400,
              fixedCost: true,
              altText: '양쪽 탱크 골리앗 물량이 늘어갑니다.',
            ),
          ],
        ),
        // 홈 빠른 확장 (자원 우위 노림)
        ScriptBranch(
          id: 'home_fast_expand',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수 빠른 확장. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 병력을 모아 압박합니다! 확장 타이밍을 노립니다!',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400, // 탱크와 골리앗 추가
              fixedCost: true,
              altText: '{away} 선수 확장 대신 병력에 집중합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 탱크로 앞마당을 지킵니다. 확장이 살아남느냐가 관건입니다.',
              owner: LogOwner.home,
              homeArmy: 2, homeResource: -250, // 탱크 추가
              fixedCost: true,
              altText: '{home} 선수 시즈 모드로 수비. 확장 기지를 사수합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수도 이제 앞마당을 올립니다. 자원 차이가 벌어졌습니다.',
            ),
          ],
        ),
        // 어웨이 빠른 확장
        ScriptBranch(
          id: 'away_fast_expand',
          baseProbability: 0.7,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{away} 선수 먼저 앞마당 커맨드센터를 건설합니다.',
              owner: LogOwner.away,
              awayResource: -400,
              fixedCost: true,
              awayExpansion: true,
              altText: '{away} 선수 빠른 확장. 자원 우위를 노립니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 병력을 모아 압박합니다! 확장 타이밍을 노립니다!',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400,
              fixedCost: true,
              altText: '{home} 선수 확장 대신 병력에 집중합니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 탱크로 앞마당을 지킵니다. 확장이 살아남느냐가 관건입니다.',
              owner: LogOwner.away,
              awayArmy: 2, awayResource: -250,
              fixedCost: true,
              altText: '{away} 선수 시즈 모드로 수비. 확장 기지를 사수합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 뒤늦게 확장을 올립니다.',
              owner: LogOwner.home,
              homeResource: -400,
              fixedCost: true,
              homeExpansion: true,
              altText: '{home} 선수도 이제 앞마당을 올립니다. 자원 차이가 벌어졌습니다.',
            ),
          ],
        ),
        // 홈 확장 스킵 공격 (올인)
        ScriptBranch(
          id: 'home_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{home} 선수 확장을 포기합니다! 병력에 올인!',
              owner: LogOwner.home,
              homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
              awayResource: -400, // 어웨이 CC
              fixedCost: true,
              altText: '{home} 선수 확장 대신 탱크 골리앗을 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 확장 타이밍에 공격을 감행합니다! {away} 선수 위험합니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              altText: '{home} 선수 확장 타이밍에 시즈 전진! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 총공격! 확장 기지를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 올인 공격! 확장 기지가 무너집니다!',
            ),
          ],
        ),
        // 어웨이 확장 스킵 공격 (올인)
        ScriptBranch(
          id: 'away_skip_expand_attack',
          baseProbability: 0.4,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 확장을 포기합니다! 병력에 올인!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -650,
              homeResource: -400, // 홈 CC
              fixedCost: true,
              altText: '{away} 선수 확장 대신 탱크 골리앗을 쏟아냅니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 확장 타이밍에 공격을 감행합니다! {home} 선수 위험합니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              altText: '{away} 선수 확장 타이밍에 시즈 전진! 상대가 위험합니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 총공격! 확장 기지를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{away} 선수 올인 공격! 확장 기지가 무너집니다!',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 6: 결전 + 맵 특성 (lines 62-75) ── recovery 200/줄
    ScriptPhase(
      name: 'decisive_battle',
      startLine: 62,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 200,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 탱크 골리앗 총동원합니다. {away} 선수도 전 병력 배치.',
          owner: LogOwner.system,
          homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
          awayArmy: 6, awayResource: -650,
          fixedCost: true,
          altText: '양측 전 병력 결집. 최종 교전 준비.',
        ),
        ScriptEvent(
          text: '양측 탱크 골리앗이 정면으로 부딪칩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{home} 선수 시즈 포격! 상대 탱크 라인을 직격!',
          owner: LogOwner.home,
          awayArmy: -6, homeArmy: -4,
          favorsStat: 'attack',
          altText: '{home} 선수 탱크 화력! 상대 병력이 녹습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 골리앗 화력으로 반격!',
          owner: LogOwner.away,
          homeArmy: -6, awayArmy: -4,
          favorsStat: 'defense',
          altText: '{away} 선수 골리앗 집중 포화! 맞섭니다!',
        ),
        // ── 맵 특성 이벤트 ──
        // 근거리 맵: 탱크 교전 강화 (공격 능력치 유리)
        ScriptEvent(
          text: '{home} 선수 근거리 맵이라 탱크가 바로 사거리에 들어옵니다! 시즈 포격!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 근거리 맵 이점을 살려 시즈 포격!',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'attack',
          requiresMapTag: 'rushShort',
          skipChance: 0.5,
        ),
        // 복잡 지형 맵: 고지대 시즈 배치
        ScriptEvent(
          text: '{home} 선수 고지대를 점령하고 시즈 포격! 아래에서는 사거리가 안 닿습니다!',
          owner: LogOwner.home,
          awayArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        ScriptEvent(
          text: '{away} 선수도 반대편 고지대에 탱크를 올립니다. 지형 싸움입니다.',
          owner: LogOwner.away,
          homeArmy: -2,
          favorsStat: 'strategy',
          requiresMapTag: 'terrainHigh',
          skipChance: 0.5,
        ),
        // 원거리 맵: 멀티 확장 안전
        ScriptEvent(
          text: '원거리 맵이라 멀티 확장이 안전합니다. 양측 자원이 풍부해집니다.',
          owner: LogOwner.system,
          homeResource: 200, awayResource: 200,
          requiresMapTag: 'rushLong',
        ),
      ],
    ),
    // ── Phase 7: 드랍 운영 - 분기 (lines 76-89) ── recovery 300/줄 (late)
    ScriptPhase(
      name: 'drop_phase',
      startLine: 76,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        // 게릴라 드랍 (가장 빈번, 자잘한 피해)
        ScriptBranch(
          id: 'guerrilla',
          baseProbability: 1.2,
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 생산합니다. {away} 선수도 드랍십.',
              owner: LogOwner.system,
              homeArmy: 2, homeResource: -200, // 드랍십 200/2sup
              awayArmy: 2, awayResource: -200,
              fixedCost: true,
              altText: '양쪽 드랍십이 생산됩니다. 견제전이 시작됩니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 드랍십에 탱크를 싣고 상대 확장으로 향합니다.',
              owner: LogOwner.home,
              awayResource: -200, // SCV 견제 피해
              favorsStat: 'harass',
              altText: '{home} 선수 드랍 견제! 확장 기지에 탱크를 내립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 골리앗이 달려오지만, 이미 드랍십이 빠져나갑니다.',
              owner: LogOwner.away,
              skipChance: 0.3,
              altText: '{away} 선수 대응이 조금 늦었습니다. 일꾼 피해를 입습니다.',
            ),
            ScriptEvent(
              text: '{away} 선수도 드랍으로 맞견제! 상대 일꾼을 노립니다!',
              owner: LogOwner.away,
              homeResource: -200,
              favorsStat: 'harass',
              altText: '{away} 선수 드랍십 견제! {home} 선수 확장 기지가 흔들립니다!',
            ),
            ScriptEvent(
              text: '드랍 견제전이 치열합니다. 정면은 대치 상황입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '양쪽 드랍으로 시선을 끌면서 정면 거리재기가 계속됩니다.',
            ),
          ],
        ),
        // 마무리 드랍 (유리한 쪽이 드랍과 정면 동시)
        ScriptBranch(
          id: 'finishing',
          baseProbability: 0.7,
          conditionStat: 'strategy',
          events: [
            ScriptEvent(
              text: '{home} 선수 드랍십 두 대를 생산합니다. 마무리를 노립니다.',
              owner: LogOwner.home,
              homeArmy: 4, homeResource: -400, // 드랍십 2대
              awayArmy: 2, awayResource: -200, // 어웨이 드랍십 1대
              fixedCost: true,
              altText: '{home} 선수 드랍십 대량 생산. 마지막 승부를 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 본진과 확장에 동시 드랍! 정면 탱크도 전진!',
              owner: LogOwner.home,
              awayArmy: -4, awayResource: -300,
              favorsStat: 'strategy',
              altText: '{home} 선수 세 방향 공격! 수비가 분산됩니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 다방면 공격! {away} 선수 수비가 갈립니다!',
              owner: LogOwner.home,
              awayArmy: -4,
              favorsStat: 'attack',
              decisive: true,
              altText: '{home} 선수 드랍과 정면 동시 공격! 승부를 결정짓습니다!',
            ),
          ],
        ),
        // 정면 돌파 (드랍 없이 탱크 물량 밀어붙이기)
        ScriptBranch(
          id: 'frontal',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 탱크 골리앗 추가 보강합니다. {away} 선수도 물량 쌓기.',
              owner: LogOwner.system,
              homeArmy: 6, homeResource: -650, // 탱크2+골리앗1
              awayArmy: 6, awayResource: -650,
              fixedCost: true,
              altText: '양쪽 최대 물량 생산. 정면 결전을 준비합니다.',
            ),
            ScriptEvent(
              text: '{home} 선수 시즈 라인 전진! 상대 앞마당을 노립니다!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2,
              favorsStat: 'attack',
              altText: '{home} 선수 탱크 화력! 상대 앞마당 탱크를 깨뜨립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 시즈 포격으로 맞불! 치열한 포격전!',
              owner: LogOwner.away,
              homeArmy: -4, awayArmy: -2,
              favorsStat: 'defense',
              altText: '{away} 선수 탱크 집중 사격! 정면 포격전이 뜨겁습니다!',
            ),
            ScriptEvent(
              text: '양쪽 탱크가 녹아내립니다. 누가 더 버티느냐의 싸움입니다.',
              owner: LogOwner.system,
              skipChance: 0.3,
              altText: '포격전에서 탱크가 빠르게 소모됩니다. 집중력 싸움입니다.',
            ),
          ],
        ),
        // 역전 드랍 (불리한 쪽 승부수)
        ScriptBranch(
          id: 'desperate',
          baseProbability: 0.6,
          events: [
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대를 생산합니다. 승부수를 던집니다.',
              owner: LogOwner.away,
              awayArmy: 4, awayResource: -400, // 드랍십 2대
              homeArmy: 2, homeResource: -200, // 홈 드랍십 1대
              fixedCost: true,
              altText: '{away} 선수 드랍십 대량 생산. 역전의 한 수를 노립니다.',
            ),
            ScriptEvent(
              text: '{away} 선수 드랍십 두 대에 탱크를 싣고 상대 본진으로!',
              owner: LogOwner.away,
              homeResource: -300, // 본진 시설 파괴
              favorsStat: 'harass',
              altText: '{away} 선수 본진 올인 드랍! 승부수입니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 본진 탱크 투하! 시즈 모드! 팩토리를 노립니다!',
              owner: LogOwner.away,
              homeArmy: -4, homeResource: -200,
              favorsStat: 'attack',
              altText: '{away} 선수 드랍 올인! 생산시설이 파괴되고 있습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 본진 수비에 병력을 돌립니다. 정면이 비어버립니다.',
              owner: LogOwner.home,
              homeArmy: -2,
              favorsStat: 'defense',
              altText: '{home} 선수 수비 병력 복귀. 정면 라인이 약해집니다.',
            ),
          ],
        ),
      ],
    ),
    // ── Phase 8: 최종 결전 판정 - 분기 (lines 90+) ── recovery 300/줄
    ScriptPhase(
      name: 'decisive_outcome',
      startLine: 90,
      recoveryArmyPerLine: 3,
      recoveryResourcePerLine: 300,
      branches: [
        ScriptBranch(
          id: 'home_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 최종 포격전에서 승리! 상대 병력을 괴멸시킵니다!',
              altText: '{home} 선수 레이스와 탱크 조합으로 완벽한 마무리!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins_decisive',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 최종 포격전에서 승리! 상대 병력을 괴멸시킵니다!',
              altText: '{away} 선수 골리앗 대공과 탱크 화력으로 완벽한 마무리!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
