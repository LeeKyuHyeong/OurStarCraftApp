import 'package:flutter_test/flutter_test.dart';
import 'pvp_500_helper.dart';

void main() {
  // S5: 센터 게이트 질럿 러시 vs 스탠다드
  test('PvP S5: 센터 게이트 질럿 러시 vs 스탠다드 500경기', () async {
    await runPvpScenario(
      scenNum: 5,
      scenId: 'pvp_zealot_rush',
      desc: '센터 게이트 질럿 러시 vs 스탠다드',
      homeBuild: 'pvp_zealot_rush',
      awayBuild: 'pvp_2gate_dragoon',
      phases: {
        'Phase 2: 러시 결과': {
          'A. 러시 성공': [
            '질럿이 프로브를 잡습니다! 수적 우위',
            '질럿이 프로브를 베어냅니다',
            '추가 질럿까지 합류! 상대 본진 초토화',
            '질럿 러시 성공! 프로토스가 무너지고',
          ],
          'B. 수비 성공': [
            '질럿과 프로브로 협공! 적 질럿을 잡아냅니다',
            '완벽한 수비! 질럿 러시를 막습니다',
            '질럿이 녹고 있습니다! 러시 실패',
            '질럿 러시가 막혔습니다! 테크 차이',
          ],
        },
      },
    );
  });

  // S6: 다크 올인 vs 질럿 러시
  test('PvP S6: 다크 올인 vs 질럿 러시 500경기', () async {
    await runPvpScenario(
      scenNum: 6,
      scenId: 'pvp_dark_vs_zealot_rush',
      desc: '다크 올인 vs 질럿 러시',
      homeBuild: 'pvp_dark_allin',
      awayBuild: 'pvp_zealot_rush',
      phases: {
        'Phase 2: 치즈 대결 결과': {
          'A. 질럿 돌파': [
            '질럿이 게이트웨이를 부수고 들어갑니다',
            '질럿이 건물을 부수기 시작합니다',
            '추가 질럿 합류! 템플러 아카이브도 위험',
            '질럿 러시가 다크보다 빨랐습니다',
          ],
          'B. 다크 역전': [
            '다크 템플러가 나옵니다! 질럿 러시를 버텨냈습니다',
            '다크 등장! 보이지 않는 반격',
            '다크를 상대 본진으로 보냅니다',
            '다크 템플러가 판을 뒤집습니다',
          ],
        },
      },
    );
  });
}
