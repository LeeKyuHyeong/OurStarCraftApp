import 'package:flutter_test/flutter_test.dart';
import 'pvp_500_helper.dart';

void main() {
  // S7: 로보 미러
  test('PvP S7: 로보틱스 미러 500경기', () async {
    await runPvpScenario(
      scenNum: 7,
      scenId: 'pvp_robo_mirror',
      desc: '로보틱스 미러 - 셔틀 리버 대결',
      homeBuild: 'pvp_1gate_robo',
      awayBuild: 'pvp_1gate_robo',
      phases: {
        'Phase 2: 셔틀 리버 견제 결과': {
          'A. 홈 리버 우세': [
            '리버가 프로브 라인에 착지! 스캐럽',
            '리버 투하! 프로브가 날아갑니다',
            '셔틀은 잃었지만 프로브 피해를 더 많이 줬습니다',
          ],
          'B. 어웨이 리버 우세': [
            '리버가 프로브 라인에 투하! 스캐럽 명중',
            '리버 투하! 프로브가 쓸려갑니다',
            '프로브 피해를 더 많이 입혔습니다! 자원 이점',
          ],
        },
      },
    );
  });

  // S8: 4게이트 드라군 vs 원겟 멀티
  test('PvP S8: 4게이트 드라군 vs 원겟 멀티 500경기', () async {
    await runPvpScenario(
      scenNum: 8,
      scenId: 'pvp_4gate_vs_multi',
      desc: '4게이트 드라군 vs 원겟 멀티',
      homeBuild: 'pvp_4gate_dragoon',
      awayBuild: 'pvp_1gate_multi',
      phases: {
        'Phase 2: 압박 결과': {
          'A. 드라군 타이밍 성공': [
            '드라군 물량으로 상대 앞마당을 밀어냅니다',
            '드라군이 밀려옵니다! 수가 너무 많아요',
            '앞마당 넥서스를 공격합니다',
            '4게이트 타이밍!',
          ],
          'B. 멀티 수비 성공': [
            '드라군과 질럿으로 앞마당을 지켜냅니다',
            '수비 성공! 드라군을 잡아냅니다',
            '게이트웨이가 추가로 돌아갑니다! 멀티 자원',
            '멀티가 버텨냈습니다',
          ],
        },
      },
    );
  });
}
