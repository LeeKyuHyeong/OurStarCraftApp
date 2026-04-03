part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// BBS vs 레이스 클로킹
// ----------------------------------------------------------
const _tvtBbsVs2star = ScenarioScript(
  id: 'tvt_bbs_vs_wraith',
  matchup: 'TvT',
  homeBuildIds: ['tvt_bbs'],
  awayBuildIds: ['tvt_2star'],
  description: 'BBS vs 레이스 클로킹 초반 러시 vs 공중 테크',
  phases: [
    // Phase 0: 오프닝 (lines 1-6)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 SCV를 센터로 보냅니다!',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 배럭 건설, 가스 채취를 시작합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 센터에 배럭 건설!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, 센터 배럭! 공격적인 빌드!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리 건설 후 스타포트! 레이스를 노립니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 스타포트가 올라갑니다! 클로킹 레이스!',
        ),
        ScriptEvent(
          text: '{home} 선수 본진에도 배럭 건설! BBS입니다!',
          owner: LogOwner.home,
          homeResource: -15,
          altText: '{home}, BBS 확정! 마린을 모읍니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 마린이 모이고 있습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -5,
        ),
      ],
    ),
    // Phase 1: BBS 돌진 (lines 10-12)
    ScriptPhase(
      name: 'bbs_rush',
      startLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home}, 마린 3기에 SCV를 끌고 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 1, homeResource: -10, favorsStat: 'attack',
          altText: '{home} 선수 마린과 SCV 돌진! 빠른 공격!',
        ),
        ScriptEvent(
          text: '{away} 선수 스타포트에서 레이스가 나옵니다!',
          owner: LogOwner.away,
          awayArmy: 2,
        ),
        ScriptEvent(
          text: '{home}, 상대 진지에 벙커 건설 시도!',
          owner: LogOwner.home,
          altText: '{home} 선수 벙커를 올립니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 마린과 SCV로 벙커 건설을 방해합니다!',
          owner: LogOwner.away,
          favorsStat: 'defense',
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 결과 분기 (lines 15+)
    ScriptPhase(
      name: 'rush_result',
      startLine: 15,
      branches: [
        ScriptBranch(
          id: 'tech_defends',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 레이스가 마린을 견제합니다! 공중에서 화력 지원!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'defense',
              altText: '{away}, 레이스로 마린 격퇴!',
            ),
            ScriptEvent(
              text: '{home} 선수 마린이 녹고 있습니다! 공중 유닛 대응이 없어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 추가 레이스까지 생산! BBS를 완전히 막아냅니다!',
              owner: LogOwner.away,
              awayArmy: 2, homeArmy: -1,
              altText: '{away} 선수 레이스 물량! BBS를 완전히 차단합니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 후퇴합니다... 자원도 병력도 뒤처졌습니다.',
              owner: LogOwner.home,
              homeResource: -20,
            ),
            ScriptEvent(
              text: 'BBS가 막혔습니다! 전환기에 들어갑니다!',
              owner: LogOwner.system,
            ),
          ],
        ),
        ScriptBranch(
          id: 'bbs_overwhelm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 벙커 완성! 마린 화력이 쏟아집니다!',
              owner: LogOwner.home,
              homeArmy: 1, favorsStat: 'attack',
              altText: '{home} 선수 벙커 완성! 화력 집중!',
            ),
            ScriptEvent(
              text: '{away} 선수 지상 병력이 부족합니다! 레이스만으로는 안 됩니다!',
              owner: LogOwner.away,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '{home}, 마린으로 밀어붙입니다! SCV 수리까지!',
              owner: LogOwner.home,
              awayArmy: -2, favorsStat: 'control',
              altText: '{home} 선수 마린 화력! 상대가 밀립니다!',
            ),
            ScriptEvent(
              text: '{away} 선수 SCV 피해가 큽니다! 일꾼이 많이 죽었습니다!',
              owner: LogOwner.away,
              awayResource: -20,
            ),
            ScriptEvent(
              text: 'BBS 공격이 큰 피해를 줬습니다! 레이스가 전세를 뒤집을 수 있을까요?',
              owner: LogOwner.system,
            ),
          ],
        ),
      ],
    ),
    // Phase 3: 중반 전환 (lines 24-32)
    ScriptPhase(
      name: 'mid_transition',
      startLine: 24,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 12,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 팩토리 건설! 머신샵도 올립니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리에 머신샵! 메카닉 전환!',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 연구 완성! 레이스가 사라집니다!',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 탱크 생산 시작! BBS 이후 전환!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -15,
          altText: '{home}, 탱크 체제로 전환합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 클로킹 레이스로 견제! SCV를 노립니다!',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -20,
        ),
        ScriptEvent(
          text: '{home} 선수 엔지니어링 베이 건설! 터렛으로 대공 방어!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 엔지니어링 베이! 터렛을 올려 레이스를 막습니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 팩토리에 머신샵! 탱크도 준비합니다!',
          owner: LogOwner.away,
          awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 아카데미 건설! 컴샛스테이션을 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 1,
        ),
        ScriptEvent(
          text: '전환기에 들어갑니다! BBS vs 레이스, 누가 유리할까요?',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 4: 중반 결전 - 분기 (lines 34+)
    ScriptPhase(
      name: 'mid_decisive',
      startLine: 34,
      branches: [
        ScriptBranch(
          id: 'bbs_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home}, 스캔으로 클로킹을 잡고 터렛을 촘촘히 깝니다!',
              owner: LogOwner.home,
              favorsStat: 'defense',
              altText: '{home} 선수 대공 방어 완벽! 레이스를 격추합니다!',
            ),
            ScriptEvent(
              text: '{home}, 탱크 라인으로 전진! 시즈 포격!',
              owner: LogOwner.home,
              awayResource: -15, awayArmy: -2, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 정면에서도 탱크 시즈! 상대 라인을 뚫습니다!',
              owner: LogOwner.home,
              homeArmy: -1, awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 초반 피해에 대공 방어까지! 레이스 측이 무너집니다!',
              owner: LogOwner.home,
              decisive: true,
              altText: '{home} 선수 초반 마린 화력과 탱크로 상대를 압살합니다!',
            ),
          ],
        ),
        ScriptBranch(
          id: 'tech_player_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away}, 클로킹 레이스 견제가 성공합니다! SCV가 녹고 있어요!',
              owner: LogOwner.away,
              awayArmy: 4, favorsStat: 'harass',
              altText: '{away} 선수 클로킹 견제! 스캔이 없는 곳을 노립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 BBS 투자가 무겁습니다! 대공도 늦어요!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '{away}, 레이스로 견제하면서 탱크도 모읍니다!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -1, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 클로킹 견제로 상대를 흔들어 놓고 탱크로 마무리합니다!',
              owner: LogOwner.away,
              decisive: true,
              altText: '{away} 선수 레이스 견제로 BBS를 역전합니다!',
            ),
          ],
        ),
      ],
    ),
  ],
);
