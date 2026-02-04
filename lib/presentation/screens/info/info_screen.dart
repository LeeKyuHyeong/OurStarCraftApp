import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../data/providers/game_provider.dart';
import '../../../domain/models/models.dart';
import '../../widgets/reset_button.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({super.key});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedTeamId;
  String? _selectedPlayerId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    if (gameState == null) {
      return const Scaffold(
        body: Center(child: Text('게임 데이터를 불러올 수 없습니다')),
      );
    }

    _selectedTeamId ??= gameState.playerTeam.id;
    final allTeams = gameState.saveData.allTeams;
    final selectedTeam = allTeams.firstWhere(
      (t) => t.id == _selectedTeamId,
      orElse: () => gameState.playerTeam,
    );
    final teamPlayers = gameState.saveData.getTeamPlayers(selectedTeam.id);

    if (_selectedPlayerId == null && teamPlayers.isNotEmpty) {
      _selectedPlayerId = teamPlayers.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('정보'),
        leading: ResetButton.leading(),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '선수 정보'),
            Tab(text: '구단 정보'),
          ],
        ),
      ),
      body: Column(
            children: [
              // 팀 선택 드롭다운
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppTheme.cardBackground,
                child: Row(
                  children: [
                    const Text(
                      '팀: ',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedTeamId,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        underline: Container(),
                        items: allTeams.map((team) {
                          final isPlayerTeam = team.id == gameState.playerTeam.id;
                          return DropdownMenuItem(
                            value: team.id,
                            child: Text(
                              isPlayerTeam ? '${team.name} (내 팀)' : team.name,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: isPlayerTeam ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return allTeams.map((team) {
                            final isPlayerTeam = team.id == gameState.playerTeam.id;
                            return Text(
                              isPlayerTeam ? '${team.name} (내 팀)' : team.name,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: isPlayerTeam ? FontWeight.bold : FontWeight.normal,
                              ),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedTeamId = value;
                            _selectedPlayerId = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 탭 내용
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPlayerInfoTab(teamPlayers, gameState),
                    _buildTeamInfoTab(selectedTeam, gameState),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPlayerInfoTab(List<Player> players, GameState gameState) {
    if (players.isEmpty) {
      return const Center(child: Text('선수가 없습니다'));
    }

    final selectedPlayer = players.firstWhere(
      (p) => p.id == _selectedPlayerId,
      orElse: () => players.first,
    );

    return Row(
      children: [
        // 왼쪽: 선수 목록
        SizedBox(
          width: 140,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final isSelected = player.id == _selectedPlayerId;
              return Card(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.cardBackground,
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
                          radius: 14,
                          backgroundColor: AppTheme.getRaceColor(player.race.code),
                          child: Text(
                            player.race.code,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            player.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
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
        // 오른쪽: 선수 상세 정보
        Expanded(
          child: _buildPlayerDetail(selectedPlayer),
        ),
      ],
    );
  }

  Widget _buildPlayerDetail(Player player) {
    final stats = player.stats;
    final grade = player.grade;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 기본 정보
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.getRaceColor(player.race.code),
                child: Text(
                  player.race.code,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.getGradeColor(grade.display),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            grade.display,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lv.${player.level}',
                          style: const TextStyle(color: AppTheme.textSecondary),
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
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '${player.condition.clamp(0, 100)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: player.condition >= 80
                          ? AppTheme.accentGreen
                          : player.condition >= 50
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 능력치
          const Text(
            '능력치',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatRow('센스', stats.sense),
          _buildStatRow('컨트롤', stats.control),
          _buildStatRow('공격력', stats.attack),
          _buildStatRow('견제', stats.harass),
          _buildStatRow('전략', stats.strategy),
          _buildStatRow('물량', stats.macro),
          _buildStatRow('수비력', stats.defense),
          _buildStatRow('정찰', stats.scout),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총합',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${stats.total}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 전적
          const Text(
            '전적',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildRecordRow('총 전적', player.record.wins, player.record.losses),
          _buildRecordRow('vs 테란', player.record.vsTerranWins, player.record.vsTerranLosses),
          _buildRecordRow('vs 저그', player.record.vsZergWins, player.record.vsZergLosses),
          _buildRecordRow('vs 프로토스', player.record.vsProtossWins, player.record.vsProtossLosses),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAchievementBox('우승', player.record.championships),
              const SizedBox(width: 8),
              _buildAchievementBox('준우승', player.record.runnerUps),
              const SizedBox(width: 8),
              _buildAchievementBox('연승', player.record.currentWinStreak),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String name, int value) {
    final percentage = (value / 999).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.accentGreen.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordRow(String label, int wins, int losses) {
    final total = wins + losses;
    final winRate = total > 0 ? (wins / total * 100).toStringAsFixed(1) : '0.0';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            '${wins}승 ${losses}패',
            style: const TextStyle(fontSize: 12),
          ),
          const Spacer(),
          Text(
            '($winRate%)',
            style: TextStyle(
              fontSize: 12,
              color: double.parse(winRate) >= 50
                  ? AppTheme.accentGreen
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBox(String label, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: count > 0 ? AppTheme.accentGreen : AppTheme.primaryBlue.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: count > 0 ? AppTheme.accentGreen : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamInfoTab(Team team, GameState gameState) {
    final record = team.record;
    final totalMatches = record.wins + record.losses;
    final winRate = totalMatches > 0
        ? (record.wins / totalMatches * 100).toStringAsFixed(1)
        : '0.0';

    // 이번 시즌 전적 계산
    final season = gameState.saveData.currentSeason;
    final seasonMatches = season.proleagueSchedule.where(
      (m) => m.isCompleted && (m.homeTeamId == team.id || m.awayTeamId == team.id),
    );
    int seasonWins = 0;
    int seasonLosses = 0;
    int seasonSetsWon = 0;
    int seasonSetsLost = 0;

    for (final match in seasonMatches) {
      final result = match.result;
      if (result == null) continue;
      final isHome = match.homeTeamId == team.id;
      final ourScore = isHome ? result.homeScore : result.awayScore;
      final theirScore = isHome ? result.awayScore : result.homeScore;

      if (ourScore > theirScore) {
        seasonWins++;
      } else {
        seasonLosses++;
      }
      seasonSetsWon += ourScore;
      seasonSetsLost += theirScore;
    }

    final seasonTotal = seasonWins + seasonLosses;
    final seasonWinRate = seasonTotal > 0
        ? (seasonWins / seasonTotal * 100).toStringAsFixed(1)
        : '0.0';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 팀 기본 정보
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.groups,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '자금: ${team.money}만원 | 행동력: ${team.actionPoints}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 전체 전적
          const Text(
            '전체 전적',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamStatColumn('승', record.wins, AppTheme.accentGreen),
                    _buildTeamStatColumn('패', record.losses, Colors.red),
                    _buildTeamStatColumn('승률', '$winRate%',
                        double.parse(winRate) >= 50 ? AppTheme.accentGreen : AppTheme.textSecondary),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamStatColumn('프로리그 우승', record.proleagueChampionships, Colors.amber),
                    _buildTeamStatColumn('프로리그 준우승', record.proleagueRunnerUps, Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamStatColumn('개인리그 우승', record.individualChampionships, Colors.amber),
                    _buildTeamStatColumn('개인리그 준우승', record.individualRunnerUps, Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 이번 시즌 전적
          const Text(
            '이번 시즌 전적',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamStatColumn('승', seasonWins, AppTheme.accentGreen),
                    _buildTeamStatColumn('패', seasonLosses, Colors.red),
                    _buildTeamStatColumn('승률', '$seasonWinRate%',
                        double.parse(seasonWinRate) >= 50 ? AppTheme.accentGreen : AppTheme.textSecondary),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamStatColumn('세트 득', seasonSetsWon, AppTheme.accentGreen),
                    _buildTeamStatColumn('세트 실', seasonSetsLost, Colors.red),
                    _buildTeamStatColumn('세트 차', seasonSetsWon - seasonSetsLost,
                        seasonSetsWon >= seasonSetsLost ? AppTheme.accentGreen : Colors.red),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 하단 버튼
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/player-ranking'),
                  icon: const Icon(Icons.person),
                  label: const Text('선수 순위'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentGreen,
                    side: const BorderSide(color: AppTheme.accentGreen),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/team-ranking'),
                  icon: const Icon(Icons.groups),
                  label: const Text('구단 순위'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentGreen,
                    side: const BorderSide(color: AppTheme.accentGreen),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamStatColumn(String label, dynamic value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
