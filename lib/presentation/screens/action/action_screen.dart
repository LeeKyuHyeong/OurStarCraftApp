import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../data/providers/game_provider.dart';
import '../../../domain/models/models.dart';
import '../../widgets/reset_button.dart';

enum ActionType { rest, training, fanMeeting }

class ActionScreen extends ConsumerStatefulWidget {
  const ActionScreen({super.key});

  @override
  ConsumerState<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends ConsumerState<ActionScreen> {
  ActionType _selectedAction = ActionType.rest;
  String? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    if (gameState == null) {
      return const Scaffold(
        body: Center(child: Text('게임 데이터를 불러올 수 없습니다')),
      );
    }

    final team = gameState.playerTeam;
    final players = gameState.playerTeamPlayers;
    final actionPoints = team.actionPoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('선수 행동'),
        leading: ResetButton.leading(),
      ),
      body: Column(
            children: [
              // 상단: 행동력 표시
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.cardBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '보유 행동력',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.flash_on,
                          color: AppTheme.accentGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$actionPoints',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 메인 콘텐츠
              Expanded(
                child: Row(
                  children: [
                    // 왼쪽: 선수 목록
                    SizedBox(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              '선수 목록',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                final player = players[index];
                                final isSelected = player.id == _selectedPlayerId;
                                return Card(
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.cardBackground,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedPlayerId = player.id;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: AppTheme.getRaceColor(player.race.code),
                                            child: Text(
                                              player.race.code,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  player.name,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : AppTheme.textPrimary,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '컨디션 ${player.condition.clamp(0, 100)}%',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: isSelected
                                                        ? Colors.white70
                                                        : _getConditionColor(player.condition),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 오른쪽: 행동 선택 및 실행
                    Expanded(
                      child: Column(
                        children: [
                          // 행동 선택 버튼
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                _buildActionButton(
                                  ActionType.rest,
                                  '휴식',
                                  Icons.hotel,
                                  50,
                                  actionPoints,
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  ActionType.training,
                                  '특훈',
                                  Icons.fitness_center,
                                  100,
                                  actionPoints,
                                ),
                                const SizedBox(width: 8),
                                _buildActionButton(
                                  ActionType.fanMeeting,
                                  '팬미팅',
                                  Icons.people,
                                  200,
                                  actionPoints,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          // 행동 상세 정보
                          Expanded(
                            child: _buildActionDetail(actionPoints, players),
                          ),
                          // 실행 버튼
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _canExecuteAction(actionPoints)
                                    ? () => _executeAction(players)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentGreen,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: AppTheme.cardBackground,
                                ),
                                child: Text(
                                  _getExecuteButtonText(actionPoints),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildActionButton(
    ActionType action,
    String label,
    IconData icon,
    int cost,
    int currentPoints,
  ) {
    final isSelected = _selectedAction == action;
    final canAfford = currentPoints >= cost;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAction = action;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.accentGreen
                  : canAfford
                      ? AppTheme.primaryBlue
                      : Colors.red.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.accentGreen
                    : canAfford
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : canAfford
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$cost AP',
                style: TextStyle(
                  fontSize: 10,
                  color: canAfford ? AppTheme.accentGreen : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionDetail(int actionPoints, List<Player> players) {
    String title;
    String description;
    String effect;
    int cost;

    switch (_selectedAction) {
      case ActionType.rest:
        title = '휴식';
        description = '선수가 휴식을 취합니다.\n쉬면서 컨디션을 회복합니다.';
        effect = '컨디션 +4~5';
        cost = 50;
        break;
      case ActionType.training:
        title = '특훈';
        description = '선수가 특별 훈련을 합니다.\n능력치가 소폭 상승합니다.';
        effect = '능력치 랜덤 상승 (레벨에 따라 차이)\n컨디션 -1';
        cost = 100;
        break;
      case ActionType.fanMeeting:
        title = '팬미팅';
        description = '선수가 팬미팅을 진행합니다.\n소지금을 획득하고, 치어풀을 얻을 수도 있습니다.';
        effect = '소지금 획득 (등급에 따라 차이)\n치어풀 획득 확률 35~55%\n컨디션 -2';
        cost = 200;
        break;
    }

    final selectedPlayer = _selectedPlayerId != null
        ? players.cast<Player?>().firstWhere(
              (p) => p?.id == _selectedPlayerId,
              orElse: () => null,
            )
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 행동 정보
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const Divider(height: 24),
                const Text(
                  '효과',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  effect,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('소모 행동력'),
                    Text(
                      '$cost',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: actionPoints >= cost
                            ? AppTheme.accentGreen
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 선택된 선수 정보
          if (selectedPlayer != null) ...[
            const Text(
              '선택된 선수',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.getRaceColor(selectedPlayer.race.code),
                    child: Text(
                      selectedPlayer.race.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedPlayer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.getGradeColor(selectedPlayer.grade.display),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                selectedPlayer.grade.display,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Lv.${selectedPlayer.level}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '컨디션',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${selectedPlayer.condition.clamp(0, 100)}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getConditionColor(selectedPlayer.condition),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.5),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Text(
                  '왼쪽에서 선수를 선택하세요',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getConditionColor(int condition) {
    if (condition >= 80) return AppTheme.accentGreen;
    if (condition >= 50) return Colors.orange;
    return Colors.red;
  }

  bool _canExecuteAction(int actionPoints) {
    if (_selectedPlayerId == null) return false;

    switch (_selectedAction) {
      case ActionType.rest:
        return actionPoints >= 50;
      case ActionType.training:
        return actionPoints >= 100;
      case ActionType.fanMeeting:
        return actionPoints >= 200;
    }
  }

  String _getExecuteButtonText(int actionPoints) {
    if (_selectedPlayerId == null) return '선수를 선택하세요';

    int requiredPoints;
    switch (_selectedAction) {
      case ActionType.rest:
        requiredPoints = 50;
        break;
      case ActionType.training:
        requiredPoints = 100;
        break;
      case ActionType.fanMeeting:
        requiredPoints = 200;
        break;
    }

    if (actionPoints < requiredPoints) {
      return '행동력 부족 (${requiredPoints - actionPoints} 필요)';
    }

    return '실행';
  }

  void _executeAction(List<Player> players) {
    if (_selectedPlayerId == null) return;

    final player = players.firstWhere((p) => p.id == _selectedPlayerId);
    final notifier = ref.read(gameStateProvider.notifier);

    switch (_selectedAction) {
      case ActionType.rest:
        notifier.playerRest(_selectedPlayerId!);
        _showResultDialog(
          '휴식 완료',
          '${player.name} 선수가 휴식을 취했습니다.\n컨디션이 회복되었습니다.',
          Icons.hotel,
        );
        break;
      case ActionType.training:
        notifier.playerTraining(_selectedPlayerId!);
        _showResultDialog(
          '특훈 완료',
          '${player.name} 선수가 특훈을 완료했습니다.\n능력치가 상승했습니다.',
          Icons.fitness_center,
        );
        break;
      case ActionType.fanMeeting:
        final (gotCheerful, moneyEarned) = notifier.playerFanMeeting(_selectedPlayerId!);
        String message = '${player.name} 선수가 팬미팅을 진행했습니다.\n소지금 +${moneyEarned}만원';
        if (gotCheerful) {
          message += '\n\n치어풀을 획득했습니다!';
        }
        _showResultDialog('팬미팅 완료', message, Icons.people);
        break;
    }
  }

  void _showResultDialog(String title, String message, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Row(
          children: [
            Icon(icon, color: AppTheme.accentGreen),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '확인',
              style: TextStyle(color: AppTheme.accentGreen),
            ),
          ),
        ],
      ),
    );
  }
}
