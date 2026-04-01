part of '../../scenario_scripts.dart';

// ----------------------------------------------------------
// 11. 메카닉 vs 하이브 운영 (후반 대규모 전면전)
// ----------------------------------------------------------
const _tvzMechVsHive = ScenarioScript(
  id: 'tvz_mech_vs_hive',
  matchup: 'TvZ',
  homeBuildIds: ['tvz_3fac_goliath', 'tvz_trans_mech_goliath'],
  awayBuildIds: ['zvt_trans_ultra_hive', 'zvt_trans_lurker_defiler'],
  description: '메카닉 vs 하이브 울트라/디파일러 후반전',
  phases: [
    // Phase 0: 오프닝 (lines 1-16)
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
          altText: '{away}, 해처리부터 올립니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 가스를 일찍 넣으면서 팩토리에 머신샵까지!',
          owner: LogOwner.home,
          homeResource: -25,
          altText: '{home}, 팩토리 머신샵! 메카닉 테크입니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 스포닝풀 건설합니다.',
          owner: LogOwner.away,
          awayResource: -15,
        ),
        ScriptEvent(
          text: '{home} 선수 팩토리 증설! 메카닉 체제를 확립합니다.',
          owner: LogOwner.home,
          homeResource: -20,
          altText: '{home}, 팩토리 2개! 본격 메카닉 가동!',
        ),
        ScriptEvent(
          text: '{away} 선수 저글링 소량 생산하면서 앞마당 가스를 넣습니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -10,
        ),
        ScriptEvent(
          text: '{home} 선수 첫 시즈 탱크 생산! 골리앗도 곧 나옵니다.',
          owner: LogOwner.home,
          homeArmy: 3, homeResource: -20,
          altText: '{home}, 탱크가 나왔습니다! 골리앗도 생산 대기 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 세 번째 해처리 건설합니다.',
          owner: LogOwner.away,
          awayResource: -30,
          skipChance: 0.2,
          altText: '{away}, 3번째 해처리! 자원을 벌려갑니다!',
        ),
      ],
    ),
    // Phase 1: 중반 내정 확장 (lines 17-30)
    ScriptPhase(
      name: 'mid_expansion',
      startLine: 17,
      recoveryArmyPerLine: 1,
      recoveryResourcePerLine: 8,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 대량 생산 시작! 아머리 업그레이드도!',
          owner: LogOwner.home,
          homeArmy: 5, homeResource: -25,
          altText: '{home}, 골리앗이 쏟아져 나옵니다! 업그레이드도 진행 중!',
        ),
        ScriptEvent(
          text: '{away} 선수 히드라덴 건설! 레어 올리면서 럴커 테크 준비합니다.',
          owner: LogOwner.away,
          awayArmy: 3, awayResource: -25,
          altText: '{away}, 히드라덴에 레어까지! 럴커 준비!',
        ),
        ScriptEvent(
          text: '{home}, 앞마당 커맨드센터 건설! 테란도 확장합니다.',
          owner: LogOwner.home,
          homeResource: -30,
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '{away} 선수 하이브 진화 시작합니다! 디파일러 마운드 건설!',
          owner: LogOwner.away,
          awayResource: -30,
          altText: '{away}, 하이브 완성! 디파일러 마운드까지!',
        ),
        ScriptEvent(
          text: '양쪽 모두 후반 빌드업 중입니다. 고요하지만 긴장감이 있는 전개!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 2: 중반 교전 (lines 31-44)
    ScriptPhase(
      name: 'mid_clash',
      startLine: 31,
      linearEvents: [
        ScriptEvent(
          text: '{home} 선수 골리앗 탱크 조합으로 전진합니다!',
          owner: LogOwner.home,
          homeArmy: 3, favorsStat: 'attack',
          altText: '{home}, 메카닉 부대 전진! 탱크 시즈 준비!',
        ),
        ScriptEvent(
          text: '{away} 선수 럴커가 앞마당 입구에 포진합니다! 막아내려는 모습!',
          owner: LogOwner.away,
          awayArmy: 4, favorsStat: 'defense',
          altText: '{away}, 럴커 포진! 메카닉 전진을 저지합니다!',
        ),
        ScriptEvent(
          text: '{away} 선수 울트라리스크 캐번 건설! 울트라 준비에 들어갑니다!',
          owner: LogOwner.away,
          awayResource: -20,
          altText: '{away}, 울트라리스크 캐번까지! 후반 준비 완료!',
        ),
        ScriptEvent(
          text: '{home}, 탱크 시즈 모드! 럴커를 스캔으로 잡아냅니다!',
          owner: LogOwner.home,
          awayArmy: -3, favorsStat: 'strategy',
          altText: '{home} 선수 스캔 + 탱크 포격! 럴커를 하나씩 제거합니다!',
        ),
        ScriptEvent(
          text: '{away}, 저글링이 탱크 사이로 파고듭니다! 시즈 라인을 흔들어요!',
          owner: LogOwner.away,
          homeArmy: -2, awayArmy: -3, favorsStat: 'control',
          altText: '{away} 선수 저글링 돌진! 탱크 뒤를 칩니다!',
        ),
        ScriptEvent(
          text: '{home} 선수 골리앗으로 저글링을 정리합니다!',
          owner: LogOwner.home,
          awayArmy: -2, favorsStat: 'defense',
          skipChance: 0.3,
        ),
        ScriptEvent(
          text: '중반 교전을 치렀습니다! 이제 후반 테크 싸움이 시작됩니다!',
          owner: LogOwner.system,
          skipChance: 0.3,
        ),
      ],
    ),
    // Phase 3: 하이브 테크 등장 - 분기 (lines 45-60)
    ScriptPhase(
      name: 'hive_tech',
      startLine: 45,
      branches: [
        // 분기 A: 울트라 등장
        ScriptBranch(
          id: 'ultra_arrives',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라리스크가 등장합니다! 최종 병기!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30,
              altText: '{away}, 울트라가 나왔습니다! 거대한 병기!',
            ),
            ScriptEvent(
              text: '{away}, 울트라가 골리앗 라인을 향해 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 울트라 돌진! 골리앗 라인이 밀립니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗이 울트라를 집중 사격합니다! 골리앗이 울트라에 강하죠!',
              owner: LogOwner.home,
              awayArmy: -4, homeArmy: -2, favorsStat: 'defense',
              altText: '{home}, 골리앗이 집중 포화! 상대 지상 유닛을 격파합니다!',
            ),
            ScriptEvent(
              text: '{away}, 하지만 뒤이어 저글링이 쏟아져 나옵니다! 물량 압박!',
              owner: LogOwner.away,
              awayArmy: 5, homeArmy: -2, favorsStat: 'macro',
            ),
            ScriptEvent(
              text: '골리앗이 울트라를 잡았지만 뒤따르는 물량이 문제입니다!',
              owner: LogOwner.system,
              skipChance: 0.3,
            ),
          ],
        ),
        // 분기 B: 디파일러 다크스웜
        ScriptBranch(
          id: 'defiler_darkswarm',
          baseProbability: 1.0,
          events: [
            ScriptEvent(
              text: '{away} 선수 디파일러가 전선에 합류합니다!',
              owner: LogOwner.away,
              awayArmy: 3, awayResource: -25, favorsStat: 'strategy',
              altText: '{away}, 디파일러 등장! 다크스웜 준비!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜! 디파일러가 상대 화력을 완전히 무력화시킵니다!',
              owner: LogOwner.away,
              homeArmy: -4, favorsStat: 'strategy',
              altText: '{away} 선수 스웜! 메카닉 화력이 의미를 잃습니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 사이언스 베슬 이레디에이트로 디파일러를 노립니다!',
              owner: LogOwner.home,
              awayArmy: -3, homeResource: -15, favorsStat: 'strategy',
              altText: '{home}, 이레디! 디파일러를 잡을 수 있을까요!',
            ),
            ScriptEvent(
              text: '{away}, 디파일러가 컨슘으로 에너지를 채우면서 스웜을 계속 깔아줍니다!',
              owner: LogOwner.away,
              favorsStat: 'control',
              altText: '{away} 선수 컨슘! 디파일러 에너지 회복! 스웜이 끊이질 않습니다!',
            ),
            ScriptEvent(
              text: '다크스웜 vs 이레디에이트! 마법 대결이 승부를 가릅니다!',
              owner: LogOwner.system,
              skipChance: 0.2,
            ),
          ],
        ),
      ],
    ),
    // Phase 4: 최종 결전 (lines 61-80)
    ScriptPhase(
      name: 'final_battle',
      startLine: 61,
      branches: [
        // 분기 A: 메카닉 물량으로 밀어붙이기
        ScriptBranch(
          id: 'mech_overwhelm',
          baseProbability: 1.0,
          conditionStat: 'macro',
          events: [
            ScriptEvent(
              text: '{home} 선수 5팩토리 풀가동! 골리앗이 끝없이 나옵니다!',
              owner: LogOwner.home,
              homeArmy: 9, homeResource: -30, favorsStat: 'macro',
              altText: '{home}, 골리앗 물량! 메카닉 재생산이 빠릅니다!',
            ),
            ScriptEvent(
              text: '{home}, 골리앗 탱크 편대가 저그 4번째 확장을 노립니다!',
              owner: LogOwner.home,
              awayResource: -25, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '{away} 선수 수비가 갈립니다! 확장이 하나씩 무너지고 있어요!',
              owner: LogOwner.away,
              awayArmy: -4, awayResource: -20,
              altText: '{away}, 멀티가 밀리고 있습니다! 자원이 끊겨요!',
            ),
            ScriptEvent(
              text: '{home}, 메카닉 물량으로 저그 확장을 하나씩 밀어냅니다!',
              owner: LogOwner.home,
              awayArmy: -3, favorsStat: 'attack',
            ),
            ScriptEvent(
              text: '메카닉 물량이 확장을 무너뜨립니다! GG!',
              owner: LogOwner.home,
              decisive: true,
            ),
          ],
        ),
        // 분기 B: 하이브 유닛 총공격
        ScriptBranch(
          id: 'hive_all_out',
          baseProbability: 1.0,
          conditionStat: 'attack',
          events: [
            ScriptEvent(
              text: '{away} 선수 울트라 디파일러 저글링 총동원! 전면전 태세!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -30,
              altText: '{away}, 하이브 유닛 풀가동! 최종 결전 준비!',
            ),
            ScriptEvent(
              text: '{away}, 다크스웜 깔면서 울트라가 돌진합니다!',
              owner: LogOwner.away,
              homeArmy: -5, awayArmy: -3, favorsStat: 'attack',
              altText: '{away} 선수 스웜 속 울트라가 돌진! 상대 화력을 무력화시킵니다!',
            ),
            ScriptEvent(
              text: '{home} 선수 골리앗으로 울트라를 잡으려 하지만 스웜에 화력이 막힙니다!',
              owner: LogOwner.home,
              homeArmy: -4, favorsStat: 'defense',
              altText: '{home}, 다크스웜 속에서 골리앗이 제 화력을 못 냅니다!',
            ),
            ScriptEvent(
              text: '{away}, 저글링이 탱크 라인 뒤로 파고듭니다! 전선이 무너지는데요!',
              owner: LogOwner.away,
              homeArmy: -3, awayArmy: -5, favorsStat: 'control',
            ),
            ScriptEvent(
              text: '최종 병기 총공격! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
        // 분기 C: 접전 끝 재건 경쟁
        ScriptBranch(
          id: 'rebuild_race',
          baseProbability: 1.0,
          conditionStat: 'defense',
          events: [
            ScriptEvent(
              text: '양측 모두 큰 전투 후 병력이 바닥났습니다!',
              owner: LogOwner.system,
            ),
            ScriptEvent(
              text: '{home} 선수 5팩토리에서 골리앗을 재생산합니다!',
              owner: LogOwner.home,
              homeArmy: 5, homeResource: -25, favorsStat: 'macro',
              altText: '{home}, 메카닉 재생산! 팩토리 풀가동!',
            ),
            ScriptEvent(
              text: '{away} 선수 3해처리에서 저글링 울트라를 다시 뽑습니다!',
              owner: LogOwner.away,
              awayArmy: 6, awayResource: -25, favorsStat: 'macro',
              altText: '{away}, 다해처리 재생산! 물량을 다시 채웁니다!',
            ),
            ScriptEvent(
              text: '재건 속도 대결! GG!',
              owner: LogOwner.away,
              decisive: true,
            ),
          ],
        ),
      ],
    ),
  ],
);

