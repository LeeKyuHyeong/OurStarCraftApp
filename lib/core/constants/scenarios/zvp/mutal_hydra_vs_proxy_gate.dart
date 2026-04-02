part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 뮤탈 히드라 vs 프록시 게이트웨이
// ----------------------------------------------------------
const _zvpMutalHydraVsProxyGate = ScenarioScript(
  id: 'zvp_mutal_hydra_vs_proxy_gate',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mutal_hydra'],
  awayBuildIds: ['pvz_proxy_gate'],
  description: '뮤탈리스크 히드라 vs 프록시 게이트 질럿 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 해처리에서 드론을 생산합니다.',
          owner: LogOwner.home,
          homeResource: -5,
        ),
        ScriptEvent(
          text: '{away} 선수 프로브를 센터로 보냅니다!',
          owner: LogOwner.away,
          awayResource: -5,
          altText: '{away}, 프로브가 이동합니다! 전진 건물인가요?',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 파일런과 게이트웨이를 건설합니다!',
          owner: LogOwner.away,
          awayResource: -25,
          altText: '{away}, 프록시 게이트웨이! 질럿 러시를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 올립니다.',
          owner: LogOwner.home,
          homeResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.home,
          homeResource: -15,
        ),
      ],
    ),
    // Phase 1: 질럿 러시 방어 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      startLine: 12,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 질럿 2기가 저그 앞마당에 도착합니다!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'attack',
          altText: '{away}, 질럿 도착! 앞마당 해처리를 노립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 저글링과 드론으로 질럿을 막습니다!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -10, favorsStat: 'defense',
          altText: '{home}, 저글링 방어! 드론까지 동원합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 성큰을 건설합니다! 질럿을 저지!',
          owner: LogOwner.home,
          homeArmy: 2, homeResource: -15, favorsStat: 'defense',
        ),
        ScriptEvent(
          text: '{away}, 질럿을 추가 생산! 압박을 계속합니다!',
          owner: LogOwner.away,
          awayArmy: 2, awayResource: -15,
          altText: '{away} 선수 질럿 추가! 성큰 전에 밀어야 합니다!',
        ),
        ScriptEvent(
          text: '성큰이 완성되면 질럿 러시는 막힙니다!',
          owner: LogOwner.system,
          skipChance: 0.2,
        ),
      ],
    ),
    // Phase 2: 뮤탈 전환 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      startLine: 22,
      recoveryArmyPerLine: 2,
      recoveryResourcePerLine: 10,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 질럿을 막아내고 레어를 올립니다! 스파이어를 향합니다!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 레어! 스파이어로 뮤탈을 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스파이어 완성! 뮤탈리스크를 생산합니다!',
          owner: LogOwner.home,
          homeArmy: 4, homeResource: -25, favorsStat: 'harass',
          altText: '{home}, 뮤탈리스크! 프록시가 막혔으니 뮤탈로 견제!',
        ),
        ScriptEvent(
          text: '{away} 선수 프록시 실패 후 본진에서 재건합니다. 넥서스를 올립니다.',
          owner: LogOwner.away,
          awayResource: -30,
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴도 건설합니다! 뮤탈 히드라 조합!',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 히드라덴! 뮤탈과 히드라를 함께 운용합니다!',
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
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈리스크가 프로브를 견제합니다! 일꾼이 줄어듭니다!',
              owner: LogOwner.home,
              awayResource: -15, favorsStat: 'harass',
              altText: '{home}, 뮤탈 견제! 프로브가 녹습니다!',
            ),
            ScriptEvent(
              text: '{home}, 히드라 편대가 전진합니다! 뮤탈과 동시 공격!',
              owner: LogOwner.home,
              homeArmy: 3, awayArmy: -4, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 대공 유닛이 없습니다! 뮤탈을 잡을 수 없습니다!',
              owner: LogOwner.away,
              awayArmy: -3,
            ),
            ScriptEvent(
              text: '프록시 실패 후 뮤탈에 무방비! 저그의 완승입니다!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 질럿이 성큰 완성 전에 앞마당을 파괴합니다!',
              owner: LogOwner.away,
              homeArmy: -3, homeResource: -20, favorsStat: 'attack',
              altText: '{away}, 질럿이 해처리를 부숩니다! 앞마당 파괴!',
            ),
            ScriptEvent(
              text: '{away}, 질럿이 드론까지 추격합니다!',
              owner: LogOwner.away,
              homeResource: -15, favorsStat: 'harass',
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 전환이 늦어집니다! 자원이 부족합니다!',
              owner: LogOwner.home,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '프록시 질럿이 앞마당을 파괴하고 자원을 앞섰습니다!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
