import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/team_data.dart';

class TeamSelectScreen extends ConsumerStatefulWidget {
  const TeamSelectScreen({super.key});

  @override
  ConsumerState<TeamSelectScreen> createState() => _TeamSelectScreenState();
}

class _TeamSelectScreenState extends ConsumerState<TeamSelectScreen> {
  String? selectedTeamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임단 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '운영할 게임단을 선택하세요',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // 팀 그리드
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: TeamData.teams.length,
                itemBuilder: (context, index) {
                  final team = TeamData.teams[index];
                  final isSelected = selectedTeamId == team['id'];

                  return _TeamCard(
                    team: team,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedTeamId = team['id'];
                      });
                    },
                  );
                },
              ),
            ),
          ),

          // 선택된 팀 정보
          if (selectedTeamId != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppTheme.cardBackground,
              child: Column(
                children: [
                  Text(
                    TeamData.teams.firstWhere(
                      (t) => t['id'] == selectedTeamId,
                    )['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '에이스: ${TeamData.teams.firstWhere((t) => t['id'] == selectedTeamId)['ace']}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 확정 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedTeamId == null
                    ? null
                    : () {
                        // TODO: 선택한 팀 저장
                        context.go('/main');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppTheme.cardBackground,
                ),
                child: const Text(
                  '게임 시작',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final bool isSelected;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color(team['color'])
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(team['color']).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 팀 로고 플레이스홀더
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(team['color']).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(team['color']),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  team['shortName'],
                  style: TextStyle(
                    color: Color(team['color']),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 팀명
            Text(
              team['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
