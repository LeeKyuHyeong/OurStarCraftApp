import 'package:flutter_test/flutter_test.dart';
import 'pvp_500_helper.dart';

void main() {
  // S1: 원겟 드라군 넥서스 미러
  test('PvP S1: 원겟 드라군 넥서스 미러 500경기', () async {
    await runPvpScenario(
      scenNum: 1,
      scenId: 'pvp_dragoon_nexus_mirror',
      desc: '원겟 드라군 넥서스 미러',
      homeBuild: 'pvp_2gate_dragoon',
      awayBuild: 'pvp_2gate_dragoon',
      phases: {
        'Phase 2: 테크 분기': {
          'A. 로보+다크': [
            '시타델 오브 아둔 건설! 다크를 노립니다',
            '다크 테크! 기습을 노리는',
            '다크 템플러가 잠입합니다',
          ],
          'B. 양쪽 로보': [
            '셔틀 리버 경쟁',
            '양측 셔틀 리버가 교차',
            '서로 견제합니다',
          ],
        },
        'Phase 3: 셔틀 리버 교전': {
          'A. 리버 성공': [
            '셔틀이 상대 프로브 라인에 리버를 내립니다',
            '리버 투하! 프로브가 날아갑니다',
            '리버 견제가 성공',
          ],
          'B. 셔틀 격추': [
            '드라군이 셔틀을 집중 사격합니다! 격추',
            '드라군 집중! 셔틀이 격추',
            '셔틀 격추! PvP에서',
          ],
        },
      },
    );
  });

  // S2: 원겟 드라군 vs 노겟 넥서스
  test('PvP S2: 원겟 드라군 vs 노겟 넥서스 500경기', () async {
    await runPvpScenario(
      scenNum: 2,
      scenId: 'pvp_dragoon_vs_nogate',
      desc: '원겟 드라군 넥서스 vs 노겟 넥서스',
      homeBuild: 'pvp_2gate_dragoon',
      awayBuild: 'pvp_1gate_multi',
      phases: {
        'Phase 2: 초반 압박 결과': {
          'A. 질럿 피해 성공': [
            '질럿이 프로브 3기를 잡습니다',
            '질럿 컨트롤! 프로브 피해가',
            '노겟 넥서스를 흔듭니다',
            '질럿 견제 성공',
          ],
          'B. 프로브 방어 성공': [
            '프로브와 질럿의 협공으로',
            '프로브 컨트롤! 질럿을 잡습니다',
            '넥서스의 자원이 빛을 발합니다',
            '프로브 수비 성공',
          ],
        },
        'Phase 5: 결전': {
          'A. 홈 스톰 승': [
            '스톰! 상대 드라군이 녹습니다',
            '스톰! 드라군 편대가 무너집니다',
          ],
          'B. 어웨이 견제 승': [
            '셔틀에 하이 템플러를 태워서 본진 견제',
            '셔틀 하이 템플러! 본진 스톰',
          ],
        },
      },
    );
  });
}
