import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/models/models.dart';
import '../../../data/providers/game_provider.dart';
import '../../widgets/reset_button.dart';

/// 시즌 종료 화면
class SeasonEndScreen extends ConsumerStatefulWidget {
  const SeasonEndScreen({super.key});

  @override
  ConsumerState<SeasonEndScreen> createState() => _SeasonEndScreenState();
}

class _SeasonEndScreenState extends ConsumerState<SeasonEndScreen> {
  int _currentPage = 0; // 0: 시즌 결과, 1: 레벨업, 2: 은퇴/신인, 3: 이적 시장 안내
  List<Player> _retiredPlayers = [];
  List<Player> _newRookies = [];
  bool _seasonCompleted = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    if (gameState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            _buildHeader(gameState),

            // 메인 컨텐츠
            Expanded(
              child: _buildContent(gameState),
            ),

            // 하단 버튼
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GameState gameState) {
    final season = gameState.currentSeason;
    final titles = ['시즌 결과', '선수 레벨업', '은퇴 및 신인 영입', '이적 시장'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withValues(alpha:0.3)),
        ),
      ),
      child: Row(
        children: [
          ResetButton.back(),
          const Spacer(),
          Icon(Icons.emoji_events, color: Colors.amber, size: 28.sp),
          SizedBox(width: 12.sp),
          Column(
            children: [
              Text(
                '${2012} 시즌 ${season.number} 종료',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                titles[_currentPage],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          const ResetButton(small: true),
        ],
      ),
    );
  }

  Widget _buildContent(GameState gameState) {
    switch (_currentPage) {
      case 0:
        return _buildSeasonResultPage(gameState);
      case 1:
        return _buildLevelUpPage(gameState);
      case 2:
        return _buildRetirementAndRookiePage(gameState);
      case 3:
        return _buildTransferMarketPage(gameState);
      default:
        return const SizedBox();
    }
  }

  /// 페이지 0: 시즌 결과
  Widget _buildSeasonResultPage(GameState gameState) {
    final playerTeam = gameState.playerTeam;
    final allTeams = gameState.saveData.allTeams;

    // 팀 순위 정렬
    final sortedTeams = List<Team>.from(allTeams)
      ..sort((a, b) {
        final aPoints = a.seasonRecord.wins * 3;
        final bPoints = b.seasonRecord.wins * 3;
        if (aPoints != bPoints) return bPoints - aPoints;
        final aSetDiff = a.seasonRecord.setWins - a.seasonRecord.setLosses;
        final bSetDiff = b.seasonRecord.setWins - b.seasonRecord.setLosses;
        return bSetDiff - aSetDiff;
      });

    final playerRank = sortedTeams.indexWhere((t) => t.id == playerTeam.id) + 1;

    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Row(
        children: [
          // 좌측: 내 팀 결과
          Expanded(
            flex: 1,
            child: _buildMyTeamResult(playerTeam, playerRank),
          ),

          // 우측: 전체 순위
          Expanded(
            flex: 1,
            child: _buildFinalRanking(sortedTeams, playerTeam.id),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTeamResult(Team team, int rank) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 팀 로고
          Container(
            width: 120.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.sp),
              boxShadow: [
                BoxShadow(
                  color: Color(team.colorValue).withValues(alpha:0.5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Center(
              child: Text(
                team.shortName,
                style: TextStyle(
                  color: Color(team.colorValue),
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 20.sp),

          Text(
            team.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24.sp),

          // 최종 순위
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.sp, vertical: 12.sp),
            decoration: BoxDecoration(
              color: _getRankColor(rank).withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(24.sp),
              border: Border.all(color: _getRankColor(rank), width: 2),
            ),
            child: Text(
              '최종 $rank위',
              style: TextStyle(
                color: _getRankColor(rank),
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 24.sp),

          // 전적
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBox('승', team.seasonRecord.wins, Colors.green),
              SizedBox(width: 16.sp),
              _buildStatBox('패', team.seasonRecord.losses, Colors.red),
            ],
          ),

          SizedBox(height: 12.sp),

          Text(
            '세트 스코어: ${team.seasonRecord.setWins} - ${team.seasonRecord.setLosses}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 24.sp),

          // 포스트시즌 진출 여부
          if (rank <= 4)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(4.sp),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                '포스트시즌 진출!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            color: color,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalRanking(List<Team> teams, String playerTeamId) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최종 순위',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.sp),
          Expanded(
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                final isMyTeam = team.id == playerTeamId;

                return Container(
                  margin: EdgeInsets.only(bottom: 8.sp),
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: isMyTeam ? AppColors.primary.withValues(alpha:0.2) : null,
                    borderRadius: BorderRadius.circular(4.sp),
                    border: isMyTeam ? Border.all(color: AppColors.accent) : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40.sp,
                        child: Text(
                          '${index + 1}위',
                          style: TextStyle(
                            color: _getRankColor(index + 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 35.sp,
                        height: 25.sp,
                        decoration: BoxDecoration(
                          color: Color(team.colorValue).withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(2.sp),
                        ),
                        child: Center(
                          child: Text(
                            team.shortName,
                            style: TextStyle(
                              color: Color(team.colorValue),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      Expanded(
                        child: Text(
                          team.name,
                          style: TextStyle(
                            color: isMyTeam ? Colors.white : Colors.grey[300],
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${team.seasonRecord.wins}W ${team.seasonRecord.losses}L',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 페이지 1: 레벨업
  Widget _buildLevelUpPage(GameState gameState) {
    final players = gameState.saveData.getTeamPlayers(gameState.playerTeam.id);

    // 커리어 진행 대상 선수 (임시: 모든 선수 표시)
    final levelUpPlayers = players.where((p) => p.careerSeasons >= 1).toList();

    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward, color: Colors.green, size: 24.sp),
                SizedBox(width: 8.sp),
                Text(
                  '선수 레벨업 안내',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.sp),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.cardBackground.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: levelUpPlayers.isEmpty
                  ? Center(
                      child: Text(
                        '이번 시즌 레벨업한 선수가 없습니다.',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    )
                  : ListView.builder(
                      itemCount: levelUpPlayers.length,
                      itemBuilder: (context, index) {
                        final player = levelUpPlayers[index];
                        return _buildLevelUpItem(player);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelUpItem(Player player) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: Colors.green.withValues(alpha:0.5)),
      ),
      child: Row(
        children: [
          // 종족 아이콘
          Container(
            width: 36.sp,
            height: 36.sp,
            decoration: BoxDecoration(
              color: _getRaceColor(player.race).withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(4.sp),
            ),
            child: Center(
              child: Text(
                player.race.code,
                style: TextStyle(
                  color: _getRaceColor(player.race),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.sp),

          // 선수 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '등급: ${player.grade.display}',
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
              ],
            ),
          ),

          // 레벨 변화
          Row(
            children: [
              Text(
                'Lv.${player.level.value - 1}',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                child: Icon(Icons.arrow_forward, color: Colors.green, size: 20.sp),
              ),
              Text(
                'Lv.${player.level.value}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 페이지 2: 은퇴 및 신인
  Widget _buildRetirementAndRookiePage(GameState gameState) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Row(
        children: [
          // 좌측: 은퇴 선수
          Expanded(
            child: _buildRetirementPanel(),
          ),

          SizedBox(width: 16.sp),

          // 우측: 신인 선수
          Expanded(
            child: _buildRookiePanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildRetirementPanel() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.sp),
              Text(
                '은퇴 선수',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${_retiredPlayers.length}명',
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Expanded(
            child: _retiredPlayers.isEmpty
                ? Center(
                    child: Text(
                      '이번 시즌 은퇴 선수가 없습니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: _retiredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = _retiredPlayers[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.sp),
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(4.sp),
                          border: Border.all(color: Colors.red.withValues(alpha:0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24.sp,
                              height: 24.sp,
                              decoration: BoxDecoration(
                                color: _getRaceColor(player.race).withValues(alpha:0.2),
                                borderRadius: BorderRadius.circular(4.sp),
                              ),
                              child: Center(
                                child: Text(
                                  player.race.code,
                                  style: TextStyle(
                                    color: _getRaceColor(player.race),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${player.grade.display} / Lv.${player.level.value}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${player.record.wins}W ${player.record.losses}L',
                              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRookiePanel() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 24.sp),
              SizedBox(width: 8.sp),
              Text(
                '신인 선수 영입',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${_newRookies.length}명',
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Expanded(
            child: _newRookies.isEmpty
                ? Center(
                    child: Text(
                      '이번 시즌 신인 영입이 없습니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: _newRookies.length,
                    itemBuilder: (context, index) {
                      final player = _newRookies[index];
                      final gameState = ref.read(gameStateProvider);
                      final team = gameState?.saveData.getTeamById(player.teamId ?? '');
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.sp),
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(4.sp),
                          border: Border.all(color: Colors.amber.withValues(alpha:0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24.sp,
                              height: 24.sp,
                              decoration: BoxDecoration(
                                color: _getRaceColor(player.race).withValues(alpha:0.2),
                                borderRadius: BorderRadius.circular(4.sp),
                              ),
                              child: Center(
                                child: Text(
                                  player.race.code,
                                  style: TextStyle(
                                    color: _getRaceColor(player.race),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${player.grade.display} / ${player.race.name}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (team != null)
                              Text(
                                team.shortName,
                                style: TextStyle(
                                  color: Color(team.colorValue),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// 페이지 3: 이적 시장 안내
  Widget _buildTransferMarketPage(GameState gameState) {
    return Container(
      padding: EdgeInsets.all(24.sp),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32.sp),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swap_horiz,
                color: Colors.amber,
                size: 64.sp,
              ),

              SizedBox(height: 24.sp),

              Text(
                '이적 시장이 열렸습니다!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.sp),

              Text(
                '무소속 선수 영입, 트레이드, 선수 방출이 가능합니다.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),

              SizedBox(height: 32.sp),

              ElevatedButton(
                onPressed: () => context.go('/transfer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: EdgeInsets.symmetric(horizontal: 48.sp, vertical: 16.sp),
                ),
                child: Text(
                  '이적 시장 입장',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final isLastPage = _currentPage == 3;

    return Container(
      padding: EdgeInsets.all(16.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 페이지 인디케이터
          Row(
            children: List.generate(4, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.sp),
                width: 12.sp,
                height: 12.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage
                      ? AppColors.accent
                      : Colors.grey.withValues(alpha:0.3),
                ),
              );
            }),
          ),

          SizedBox(width: 32.sp),

          // 다음 버튼
          ElevatedButton(
            onPressed: () {
              if (isLastPage) {
                context.go('/transfer');
              } else {
                // 페이지 2(은퇴/신인)로 넘어갈 때 시즌 완료 처리
                if (_currentPage == 1 && !_seasonCompleted) {
                  final (retired, rookies, _) = ref
                      .read(gameStateProvider.notifier)
                      .completeSeasonAndPrepareNext();
                  _retiredPlayers = retired;
                  _newRookies = rookies;
                  _seasonCompleted = true;
                }
                setState(() {
                  _currentPage++;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastPage ? AppColors.accent : AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 48.sp, vertical: 14.sp),
            ),
            child: Row(
              children: [
                Text(
                  isLastPage ? '이적 시장으로' : 'Next',
                  style: TextStyle(
                    color: isLastPage ? Colors.black : Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.sp),
                Icon(
                  Icons.arrow_forward,
                  color: isLastPage ? Colors.black : Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[300]!;
    if (rank == 3) return Colors.brown[300]!;
    if (rank <= 4) return Colors.green;
    return Colors.white;
  }

  Color _getRaceColor(Race race) {
    switch (race) {
      case Race.terran:
        return AppColors.terran;
      case Race.zerg:
        return AppColors.zerg;
      case Race.protoss:
        return AppColors.protoss;
    }
  }
}
