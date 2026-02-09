import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/providers/game_provider.dart';
import '../../widgets/reset_button.dart';

class SaveLoadScreen extends ConsumerWidget {
  const SaveLoadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Responsive.init(context);
    final slotInfoAsync = ref.watch(slotInfoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('세이브 / 로드'),
        leading: ResetButton.leading(),
      ),
      body: slotInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('오류: $error')),
        data: (slots) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];

            return _SaveSlotCard(
              slot: slot.slotNumber,
              team: slot.isEmpty ? null : slot.teamName,
              season: slot.isEmpty ? null : slot.seasonNumber,
              rank: slot.isEmpty ? null : slot.rank,
              date: slot.isEmpty
                  ? null
                  : '${slot.savedAt.year}-${slot.savedAt.month.toString().padLeft(2, '0')}-${slot.savedAt.day.toString().padLeft(2, '0')} ${slot.savedAt.hour.toString().padLeft(2, '0')}:${slot.savedAt.minute.toString().padLeft(2, '0')}',
              isEmpty: slot.isEmpty,
              onLoad: slot.isEmpty
                  ? null
                  : () async {
                      final notifier = ref.read(gameStateProvider.notifier);
                      final success = await notifier.loadGame(slot.slotNumber);
                      if (context.mounted) {
                        if (success) {
                          context.go('/main');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('로드에 실패했습니다')),
                          );
                        }
                      }
                    },
              onSave: () async {
                final gameState = ref.read(gameStateProvider);
                if (gameState == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('진행 중인 게임이 없습니다')),
                  );
                  return;
                }
                // 기존 데이터가 있으면 덮어쓰기 확인
                if (!slot.isEmpty) {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('덮어쓰기 확인'),
                      content: Text('슬롯 ${slot.slotNumber}에 이미 데이터가 있습니다. 덮어쓰시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('덮어쓰기'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                }
                final saveData = gameState.saveData.copyWith(
                  slotNumber: slot.slotNumber,
                  savedAt: DateTime.now(),
                );
                final repository = ref.read(saveRepositoryProvider);
                await repository.save(saveData);
                ref.invalidate(slotInfoListProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('슬롯 ${slot.slotNumber}에 저장되었습니다')),
                  );
                }
              },
              onDelete: slot.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('삭제 확인'),
                          content: Text('슬롯 ${slot.slotNumber}의 데이터를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                final repository = ref.read(saveRepositoryProvider);
                                await repository.delete(slot.slotNumber);
                                ref.invalidate(slotInfoListProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('삭제되었습니다')),
                                  );
                                }
                              },
                              child: const Text(
                                '삭제',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}

class _SaveSlotCard extends StatelessWidget {
  final int slot;
  final String? team;
  final int? season;
  final int? rank;
  final String? date;
  final bool isEmpty;
  final VoidCallback? onLoad;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  const _SaveSlotCard({
    required this.slot,
    required this.team,
    required this.season,
    required this.rank,
    required this.date,
    required this.isEmpty,
    required this.onLoad,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 슬롯 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isEmpty
                        ? AppTheme.textSecondary.withOpacity(0.3)
                        : AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '슬롯 $slot',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (!isEmpty && date != null)
                  Text(
                    date!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 세이브 정보
            if (isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '빈 슬롯',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else ...[
              Text(
                team!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _InfoChip(label: '시즌', value: '$season'),
                  const SizedBox(width: 8),
                  _InfoChip(label: '순위', value: '$rank위'),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isEmpty) ...[
                  OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('삭제'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onLoad,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('불러오기'),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton(
                  onPressed: onSave,
                  child: const Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
