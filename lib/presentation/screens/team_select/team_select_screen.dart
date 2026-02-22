import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/constants/initial_data.dart';
import '../../../core/constants/team_data.dart';
import '../../../domain/models/player.dart';
import '../../widgets/player_radar_chart.dart';
import '../../widgets/player_thumbnail.dart';
import '../../widgets/reset_button.dart';

class TeamSelectScreen extends ConsumerStatefulWidget {
  const TeamSelectScreen({super.key});

  @override
  ConsumerState<TeamSelectScreen> createState() => _TeamSelectScreenState();
}

class _TeamSelectScreenState extends ConsumerState<TeamSelectScreen> {
  String? selectedTeamId;
  late final Map<String, List<Player>> _playersByTeam;

  @override
  void initState() {
    super.initState();
    final allPlayers = InitialData.createPlayers();
    _playersByTeam = {};
    for (final player in allPlayers) {
      final teamId = player.teamId;
      if (teamId != null) {
        _playersByTeam.putIfAbsent(teamId, () => []).add(player);
      }
    }
    // 등급(능력치 합계) 내림차순 정렬 → 에이스가 맨 앞
    for (final players in _playersByTeam.values) {
      players.sort((a, b) => b.stats.total.compareTo(a.stats.total));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임단 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [ResetButton.action()],
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
                      final teamId = team['id'] as String;
                      final isSelected = selectedTeamId == teamId;

                      return _TeamCard(
                        team: team,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedTeamId = teamId;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              // 선택된 팀 선수 카드
              if (selectedTeamId != null) ...[
                Builder(
                  builder: (context) {
                    final selectedTeam = TeamData.teams.firstWhere(
                      (t) => t['id'] == selectedTeamId,
                    );
                    final players = _playersByTeam[selectedTeamId] ?? [];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: AppTheme.cardBackground,
                      child: Column(
                        children: [
                          Text(
                            selectedTeam['name'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 210,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: players.length,
                              itemBuilder: (context, index) {
                                return _PlayerCard(player: players[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                            context.go('/director-name');
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
    final teamColor = Color(team['color'] as int);
    final teamName = team['name'] as String;
    final teamShortName = team['shortName'] as String;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? teamColor : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: teamColor.withOpacity(0.3),
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
                color: teamColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: teamColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  teamShortName,
                  style: TextStyle(
                    color: teamColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 팀명
            Text(
              teamName,
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

class _PlayerCard extends StatelessWidget {
  final Player player;

  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final gradeDisplay = player.grade.display;
    final gradeColor = AppTheme.getGradeColor(gradeDisplay);

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          PlayerThumbnail(player: player, size: 36),
          const SizedBox(height: 4),
          Text(
            player.nickname ?? player.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: PlayerRadarChart(
              stats: player.stats,
              color: gradeColor,
              grade: gradeDisplay,
              level: player.level.value,
            ),
          ),
        ],
      ),
    );
  }
}
