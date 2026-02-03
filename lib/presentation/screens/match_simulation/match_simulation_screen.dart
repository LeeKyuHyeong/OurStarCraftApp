import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class MatchSimulationScreen extends ConsumerStatefulWidget {
  const MatchSimulationScreen({super.key});

  @override
  ConsumerState<MatchSimulationScreen> createState() =>
      _MatchSimulationScreenState();
}

class _MatchSimulationScreenState extends ConsumerState<MatchSimulationScreen> {
  // 매치 상태
  int homeScore = 0;
  int awayScore = 0;
  int currentGame = 0;

  // 현재 게임 상태
  int player1Resource = 100;
  int player1Army = 100;
  int player2Resource = 100;
  int player2Army = 100;

  // 전투 로그
  final List<String> battleLog = [];
  final ScrollController _logScrollController = ScrollController();

  // 배속
  int speed = 1;
  Timer? _gameTimer;
  bool isRunning = false;
  bool gameEnded = false;

  // 샘플 선수 데이터
  final player1 = {'name': '김택용', 'race': 'P', 'grade': 'SS'};
  final player2 = {'name': '송병구', 'race': 'P', 'grade': 'SS'};

  // 전투 텍스트 템플릿
  final List<String> battleTexts = [
    '치열한 교전 중입니다!',
    '양측 모두 물러서지 않습니다!',
    '팽팽한 접전이 이어집니다!',
    '밀고 밀리는 상황!',
    '질럿이 돌격합니다!',
    '드라군이 사격합니다!',
    '완벽한 포커싱!',
    '대규모 교전이 시작됐습니다!',
    '리버가 스캐럽을 발사합니다!',
    '환상적인 컨트롤!',
  ];

  @override
  void initState() {
    super.initState();
    _addLog('경기가 시작됩니다!');
    _addLog('${player1['name']} vs ${player2['name']}');
    _startGame();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      isRunning = true;
      gameEnded = false;
    });

    _gameTimer = Timer.periodic(
      Duration(milliseconds: 1000 ~/ speed),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _simulateTurn();
      },
    );
  }

  void _simulateTurn() {
    final random = Random();

    // 랜덤 이벤트
    final eventType = random.nextInt(10);

    if (eventType < 4) {
      // 자원 변화
      final resourceChange = random.nextInt(10) + 5;
      if (random.nextBool()) {
        player1Resource = (player1Resource - resourceChange).clamp(0, 100);
        player2Resource = (player2Resource + resourceChange ~/ 2).clamp(0, 100);
      } else {
        player2Resource = (player2Resource - resourceChange).clamp(0, 100);
        player1Resource = (player1Resource + resourceChange ~/ 2).clamp(0, 100);
      }
    } else {
      // 전투
      final damage1 = random.nextInt(15) + 5;
      final damage2 = random.nextInt(15) + 5;

      if (random.nextBool()) {
        player2Army = (player2Army - damage1).clamp(0, 100);
        player1Army = (player1Army - damage2 ~/ 2).clamp(0, 100);
        _addLog('${player1['name']} 선수, 우세한 상황입니다!');
      } else {
        player1Army = (player1Army - damage2).clamp(0, 100);
        player2Army = (player2Army - damage1 ~/ 2).clamp(0, 100);
        _addLog('${player2['name']} 선수, 우세한 상황입니다!');
      }
    }

    // 랜덤 전투 텍스트
    if (random.nextInt(3) == 0) {
      _addLog(battleTexts[random.nextInt(battleTexts.length)]);
    }

    // 승패 체크
    if (_checkGameEnd()) {
      _gameTimer?.cancel();
      setState(() {
        isRunning = false;
        gameEnded = true;
      });
    } else {
      setState(() {});
    }
  }

  bool _checkGameEnd() {
    if (player1Army <= 0 || player2Army <= 0) {
      final winner = player1Army > player2Army ? player1 : player2;
      final loser = player1Army > player2Army ? player2 : player1;

      _addLog('');
      _addLog('${loser['name']} 선수, GG를 선언합니다.');
      _addLog('${winner['name']} 선수 승리!');

      if (player1Army > player2Army) {
        homeScore++;
      } else {
        awayScore++;
      }

      return true;
    }

    // GG 조건: (자원+병력) < 상대의 30%
    final player1Total = player1Resource + player1Army;
    final player2Total = player2Resource + player2Army;

    if (player1Total < player2Total * 0.3) {
      _addLog('');
      _addLog('${player1['name']} 선수, GG를 선언합니다.');
      _addLog('${player2['name']} 선수 승리!');
      awayScore++;
      return true;
    }

    if (player2Total < player1Total * 0.3) {
      _addLog('');
      _addLog('${player2['name']} 선수, GG를 선언합니다.');
      _addLog('${player1['name']} 선수 승리!');
      homeScore++;
      return true;
    }

    return false;
  }

  void _addLog(String text) {
    setState(() {
      battleLog.add(text);
    });

    // 스크롤 아래로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _changeSpeed(int newSpeed) {
    setState(() {
      speed = newSpeed;
    });

    if (isRunning) {
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
        Duration(milliseconds: 1000 ~/ speed),
        (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          _simulateTurn();
        },
      );
    }
  }

  void _nextGame() {
    if (homeScore >= 4 || awayScore >= 4) {
      // 매치 종료
      _showMatchResult();
    } else {
      // 다음 게임
      setState(() {
        currentGame++;
        player1Resource = 100;
        player1Army = 100;
        player2Resource = 100;
        player2Army = 100;
        battleLog.clear();
        gameEnded = false;
      });
      _addLog('Game ${currentGame + 1} 시작!');
      _startGame();
    }
  }

  void _showMatchResult() {
    final isWin = homeScore > awayScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          isWin ? '승리!' : '패배...',
          style: TextStyle(
            color: isWin ? AppTheme.accentGreen : Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$homeScore : $awayScore',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isWin ? '축하합니다!' : '다음에는 꼭 이기세요!',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/main');
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경기 진행'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              _gameTimer?.cancel();
              context.go('/main');
            },
            child: const Text('나가기'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 매치 스코어
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.cardBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'SK텔레콤 T1',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$homeScore : $awayScore',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const Text(
                  '삼성전자 칸',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 선수 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _PlayerPanel(player: player1, isHome: true)),
                const SizedBox(width: 16),
                Expanded(child: _PlayerPanel(player: player2, isHome: false)),
              ],
            ),
          ),

          // 자원/병력 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _ResourceBar(
                  label: '자원',
                  value1: player1Resource,
                  value2: player2Resource,
                  color: Colors.yellow,
                ),
                const SizedBox(height: 8),
                _ResourceBar(
                  label: '병력',
                  value1: player1Army,
                  value2: player2Army,
                  color: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 전투 로그
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue),
              ),
              child: ListView.builder(
                controller: _logScrollController,
                itemCount: battleLog.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      battleLog[index],
                      style: TextStyle(
                        color: battleLog[index].contains('승리')
                            ? AppTheme.accentGreen
                            : battleLog[index].contains('GG')
                                ? Colors.orange
                                : AppTheme.textPrimary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 컨트롤
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 배속 버튼
                ...[1, 2, 4, 8].map((s) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => _changeSpeed(s),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: speed == s
                              ? AppTheme.accentGreen
                              : AppTheme.cardBackground,
                          foregroundColor:
                              speed == s ? Colors.black : AppTheme.textPrimary,
                          minimumSize: const Size(50, 40),
                        ),
                        child: Text('x$s'),
                      ),
                    )),
                const SizedBox(width: 16),
                // 다음 게임 / 스킵
                if (gameEnded)
                  ElevatedButton(
                    onPressed: _nextGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      homeScore >= 4 || awayScore >= 4 ? '결과 확인' : '다음 게임',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerPanel extends StatelessWidget {
  final Map<String, dynamic> player;
  final bool isHome;

  const _PlayerPanel({required this.player, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHome ? AppTheme.accentGreen : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.getRaceColor(player['race']),
            child: Text(
              player['race'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.getGradeColor(player['grade']),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player['grade'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceBar extends StatelessWidget {
  final String label;
  final int value1;
  final int value2;
  final Color color;

  const _ResourceBar({
    required this.label,
    required this.value1,
    required this.value2,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // Player 1 bar (오른쪽으로)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerRight,
                          widthFactor: value1 / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$value1',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Player 2 bar (왼쪽으로)
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$value2',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: value2 / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
