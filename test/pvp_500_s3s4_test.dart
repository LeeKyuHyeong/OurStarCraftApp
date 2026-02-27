import 'package:flutter_test/flutter_test.dart';
import 'pvp_500_helper.dart';

void main() {
  // S3: 원겟 로보 리버 vs 투겟 드라군
  test('PvP S3: 원겟 로보 리버 vs 투겟 드라군 500경기', () async {
    await runPvpScenario(
      scenNum: 3,
      scenId: 'pvp_robo_vs_2gate_dragoon',
      desc: '원겟 로보 리버 vs 투겟 드라군',
      homeBuild: 'pvp_1gate_robo',
      awayBuild: 'pvp_2gate_dragoon',
      phases: {
        'Phase 2: 교전 결과': {
          'A. 드라군 압도': [
            '드라군 물량이 리버 나오기 전에 밀어냅니다',
            '드라군이 압도합니다! 수가 너무 많아요',
            '리버를 잡아냅니다! 드라군 집중 사격',
            '드라군 물량 차이가 결정적',
          ],
          'B. 리버 역전': [
            '리버 스캐럽! 드라군 2기가 한 번에',
            '스캐럽 명중! 드라군이 터집니다',
            '셔틀 리버 컨트롤! 내렸다 태웠다',
            '리버 화력이 드라군 물량을 압도',
          ],
        },
        'Phase 4: 결전': {
          'A. 스톰+리버 화력': [
            '스톰과 리버 화력! 드라군이 녹습니다',
            '스톰+스캐럽 이중 화력',
          ],
          'B. 맞스톰 역전': [
            '맞스톰! 양쪽 병력이 동시에 소멸',
          ],
        },
      },
    );
  });

  // S4: 다크 올인 vs 스탠다드
  test('PvP S4: 다크 올인 vs 스탠다드 500경기', () async {
    await runPvpScenario(
      scenNum: 4,
      scenId: 'pvp_dark_vs_dragoon',
      desc: '다크 올인 vs 스탠다드 드라군',
      homeBuild: 'pvp_dark_allin',
      awayBuild: 'pvp_2gate_dragoon',
      phases: {
        'Phase 2: 다크 결과': {
          'A. 다크 학살': [
            '다크가 프로브를 베기 시작합니다! 옵저버가 없어요',
            '다크 성공! 프로브가 몰살',
            '다크가 프로브를 전멸',
            '다크 올인 대성공',
          ],
          'B. 다크 차단': [
            '옵저버가 다크를 포착',
            '옵저버 있습니다! 다크가 보여요',
            '드라군이 다크를 집중 사격! 격파',
            '다크를 잡아냅니다',
            '다크 올인이 막혔습니다',
          ],
        },
      },
    );
  });
}
