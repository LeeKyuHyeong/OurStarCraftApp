import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/responsive.dart';
import '../../widgets/reset_button.dart';

class RosterSelectScreen extends ConsumerStatefulWidget {
  const RosterSelectScreen({super.key});

  @override
  ConsumerState<RosterSelectScreen> createState() => _RosterSelectScreenState();
}

class _RosterSelectScreenState extends ConsumerState<RosterSelectScreen> {
  // 7맵에 배치된 선수 (null = 빈 슬롯)
  final List<int?> selectedPlayers = List.filled(7, null);

  // 샘플 선수 데이터
  final List<Map<String, dynamic>> players = [
    {'name': '김택용', 'race': 'P', 'grade': 'SS', 'condition': 100},
    {'name': '도재욱', 'race': 'P', 'grade': 'S+', 'condition': 95},
    {'name': '정명훈', 'race': 'T', 'grade': 'S', 'condition': 100},
    {'name': '박재혁', 'race': 'T', 'grade': 'A+', 'condition': 90},
    {'name': '이승석', 'race': 'Z', 'grade': 'A', 'condition': 100},
    {'name': '한상봉', 'race': 'Z', 'grade': 'B+', 'condition': 85},
    {'name': '정경두', 'race': 'P', 'grade': 'B', 'condition': 100},
    {'name': '권오혁', 'race': 'T', 'grade': 'B', 'condition': 100},
  ];

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('로스터 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/main'),
        ),
      ),
      body: Stack(
        children: [
          Column(
        children: [
          // 매치 정보
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.cardBackground,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('SK텔레콤 T1', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('HOME', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
                Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
                Column(
                  children: [
                    Text('삼성전자 칸', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('AWAY', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // 맵 슬롯
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '맵별 선수 배치 (7전 4선승제)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                return _MapSlot(
                  mapNumber: index + 1,
                  player: selectedPlayers[index] != null
                      ? players[selectedPlayers[index]!]
                      : null,
                  onTap: () {
                    // 선수 선택 해제
                    if (selectedPlayers[index] != null) {
                      setState(() {
                        selectedPlayers[index] = null;
                      });
                    }
                  },
                );
              },
            ),
          ),

          const Divider(),

          // 선수 목록
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('선수 목록', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Text('터치하여 맵에 배치', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final isAssigned = selectedPlayers.contains(index);

                return _PlayerCard(
                  player: player,
                  isAssigned: isAssigned,
                  onTap: isAssigned
                      ? null
                      : () {
                          // 빈 슬롯 찾아서 배치
                          final emptySlot = selectedPlayers.indexOf(null);
                          if (emptySlot != -1) {
                            setState(() {
                              selectedPlayers[emptySlot] = index;
                            });
                          }
                        },
                );
              },
            ),
          ),

          // 제출 버튼
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedPlayers.where((p) => p != null).length >= 4
                    ? () => context.go('/match')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppTheme.cardBackground,
                ),
                child: Text(
                  '로스터 제출 (${selectedPlayers.where((p) => p != null).length}/7)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
          ),
          ResetButton.positioned(),
        ],
      ),
    );
  }
}

class _MapSlot extends StatelessWidget {
  final int mapNumber;
  final Map<String, dynamic>? player;
  final VoidCallback onTap;

  const _MapSlot({
    required this.mapNumber,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: player != null ? AppTheme.accentGreen : AppTheme.primaryBlue,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MAP $mapNumber',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            if (player != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.getRaceColor(player!['race']),
                child: Text(
                  player!['race'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                player!['name'],
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.textSecondary,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '빈 슬롯',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  final bool isAssigned;
  final VoidCallback? onTap;

  const _PlayerCard({
    required this.player,
    required this.isAssigned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isAssigned
          ? AppTheme.cardBackground.withOpacity(0.5)
          : AppTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppTheme.getRaceColor(player['race']),
          child: Text(
            player['race'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player['name'],
          style: TextStyle(
            color: isAssigned ? AppTheme.textSecondary : AppTheme.textPrimary,
          ),
        ),
        subtitle: Text('컨디션: ${player['condition']}%'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.getGradeColor(player['grade']),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                player['grade'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            if (isAssigned) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, color: AppTheme.accentGreen),
            ],
          ],
        ),
      ),
    );
  }
}
