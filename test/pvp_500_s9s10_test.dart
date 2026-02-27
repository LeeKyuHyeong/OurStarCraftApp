import 'package:flutter_test/flutter_test.dart';
import 'pvp_500_helper.dart';

void main() {
  // S9: 질럿 러시 vs 리버
  test('PvP S9: 질럿 러시 vs 로보 리버 500경기', () async {
    await runPvpScenario(
      scenNum: 9,
      scenId: 'pvp_zealot_rush_vs_reaver',
      desc: '질럿 러시 vs 로보 리버',
      homeBuild: 'pvp_zealot_rush',
      awayBuild: 'pvp_1gate_robo',
      phases: {
        'Phase 2: 러시 vs 테크': {
          'A. 질럿 선제 돌파': [
            '질럿이 프로브를 잡습니다! 리버가 아직이에요',
            '추가 질럿 합류! 로보틱스까지 위협',
            '질럿 러시 성공! 리버가 나오기 전에 밀어냈습니다',
          ],
          'B. 리버 역전': [
            '질럿과 프로브로 버팁니다! 리버가 곧',
            '리버만 나오면',
            '리버가 나왔습니다! 스캐럽! 질럿이 터집니다',
            '리버가 판을 뒤집습니다',
          ],
        },
      },
    );
  });

  // S10: 다크 올인 미러
  test('PvP S10: 다크 올인 미러 500경기', () async {
    await runPvpScenario(
      scenNum: 10,
      scenId: 'pvp_dark_mirror',
      desc: '다크 올인 미러',
      homeBuild: 'pvp_dark_allin',
      awayBuild: 'pvp_dark_allin',
      phases: {
        'Phase 2: 다크 교환 결과': {
          'A. 홈 다크 우세': [
            '다크가 프로브 라인에 도착! 학살',
            '다크 성공! 프로브가 몰살',
            '다크 컨트롤! 프로브를 더 많이 잡았습니다',
          ],
          'B. 어웨이 다크 우세': [
            '다크가 프로브를 베기 시작합니다! 큰 피해',
            '다크 대성공! 프로브가 녹습니다',
            '다크 컨트롤! 더 많은 프로브를 잡습니다',
          ],
        },
      },
    );
  });
}
