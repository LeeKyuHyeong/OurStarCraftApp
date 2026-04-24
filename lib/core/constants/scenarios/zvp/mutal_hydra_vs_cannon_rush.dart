part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// ZvP: 뮤탈 히드라 vs 캐논 러시
// ----------------------------------------------------------
const _zvpMutalHydraVsCannonRush = ScenarioScript(
  id: 'zvp_mutal_hydra_vs_cannon_rush',
  matchup: 'ZvP',
  homeBuildIds: ['zvp_trans_mutal_hydra', 'zvp_2hatch_mutal', 'zvp_9overpool'],
  awayBuildIds: ['pvz_cannon_rush'],
  description: '뮤탈리스크 히드라 vs 전진 캐논 러시',
  phases: [
    // Phase 0: 오프닝 (lines 1-11)
    ScriptPhase(
      name: 'opening',
      startLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 드론을 9개까지 뽑습니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,
          altText: '{home} 선수, 9드론까지 생산합니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 포지를 건설합니다! 캐논 러시?',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 포지 건설! 전진 캐논을 노리는 걸까요?',
        ),
        ScriptEvent(
          text: '{away} 선수 프로브가 저그 앞마당으로 접근합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -5,
        ),
        ScriptEvent(
          text: '{home} 선수 앞마당 해처리를 건설합니다.',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -30,
          altText: '{home} 선수, 앞마당 해처리! 확장을 가져갑니다.',
        ),
        ScriptEvent(
          text: '{away} 선수 전진 파일런! 캐논을 세울 준비를 합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: -15,
          altText: '{away} 선수, 전진 파일런! 캐논 러시입니다!',
        ),
      ],
    ),
    // Phase 1: 캐논 공방 (lines 12-21)
    ScriptPhase(
      name: 'mid_game',
      recoveryArmyPerLine: 1,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논 건설! 앞마당 해처리를 겨냥합니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,
          altText: '{away} 선수, 캐논이 올라갑니다! 해처리가 위험!',
        ),
        ScriptEvent(
          text: '{home} 선수 드론으로 프로브를 쫓습니다! 캐논 건설을 방해!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -5,          altText: '{home} 선수, 드론 동원! 프로브를 쫓아냅니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 스포닝풀 완성! 저글링으로 프로브를 잡습니다!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -10,        ),
        ScriptEvent(
          text: '캐논 러시를 막으면 뮤탈이 자유롭게 날아다닙니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
          skipChance: 0.2,
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 올리면서 스파이어를 준비합니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -20,
          altText: '{home} 선수, 가스 채취! 뮤탈을 향한 테크!',
        ),
      ],
    ),
    // Phase 2: 공방 전개 (lines 22-29)
    ScriptPhase(
      name: 'late_setup',
      recoveryArmyPerLine: 2,
      linearEvents: [
        ScriptEvent(
          text: '{away} 선수 캐논을 추가로 올립니다! 앞마당 포위가 좁혀옵니다!',
          owner: LogOwner.away,
          homeArmy: 0,
          homeResource: 0,
          awayArmy: 3, awayResource: -20,          altText: '{away} 선수, 추가 캐논! 저그 앞마당이 위험합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 레어에서 스파이어를 올립니다! 뮤탈리스크로 반전을 노립니다!',
          owner: LogOwner.home,
          homeArmy: 0,
          awayArmy: 0,
          awayResource: 0,
          homeResource: -25,
          altText: '{home} 선수, 스파이어 건설! 뮤탈리스크를 준비합니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 히드라덴도 건설합니다! 지상군도 준비!',
          owner: LogOwner.home,
          awayArmy: 0,
          awayResource: 0,
          homeArmy: 2, homeResource: -20,
          altText: '{home} 선수, 히드라덴! 뮤탈과 히드라를 함께 운용!',
        ),
        ScriptEvent(
          text: '캐논 vs 뮤탈! 타이밍 싸움이 이 경기의 핵심입니다!',
          owner: LogOwner.system,
          homeArmy: 0,
          awayArmy: 0,
          homeResource: 0,
          awayResource: 0,
        ),
      ],
    ),
    // Phase 3: 결전 (lines 30+)
    ScriptPhase(
      name: 'decisive_battle',
      branches: [
        ScriptBranch(
          id: 'home_wins',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{home} 선수 뮤탈이 프로브를 물어뜯습니다! 대공이 없습니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: -20,              altText: '{home} 선수, 뮤탈이 프로브를 사냥합니다! 일꾼이 전멸해요!',
            ),
            ScriptEvent(
              text: '{home} 선수, 히드라가 전진합니다! 지상도 장악!',
              owner: LogOwner.home,
              homeResource: 0,
              awayResource: 0,
              homeArmy: 3, awayArmy: -4,            ),
            ScriptEvent(
              text: '{away} 선수 캐논만으로는 뮤탈과 히드라를 막을 수 없습니다!',
              owner: LogOwner.away,
              homeArmy: 0,
              homeResource: 0,
              awayResource: 0,
              awayArmy: -2,
            ),
            ScriptEvent(
              text: '캐논 러시 실패! 뮤탈이 하늘을 지배합니다!',
              owner: LogOwner.home,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
        ScriptBranch(
          id: 'away_wins',
          baseProbability: 2.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 캐논이 앞마당 해처리를 파괴합니다!',
              owner: LogOwner.away,
              awayArmy: 0,
              awayResource: 0,
              homeResource: -20, homeArmy: -2,              altText: '{away} 선수, 캐논 화력! 해처리가 무너집니다!',
            ),
            ScriptEvent(
              text: '{away} 선수, 캐논을 본진 입구까지 확장합니다!',
              owner: LogOwner.away,
              homeResource: 0,
              awayResource: 0,
              awayArmy: 3, homeArmy: -2,
            ),
            ScriptEvent(
              text: '{home} 선수 뮤탈 전환이 너무 늦었습니다! 자원이 없습니다!',
              owner: LogOwner.home,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              homeArmy: -2,
            ),
            ScriptEvent(
              text: '캐논 러시가 저그를 봉쇄합니다! 캐논 승리!',
              owner: LogOwner.away,
              homeArmy: 0,
              awayArmy: 0,
              homeResource: 0,
              awayResource: 0,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);
