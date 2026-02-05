import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/providers/game_provider.dart';
import '../../../data/providers/match_provider.dart';
import '../../../domain/models/models.dart';
import '../../widgets/reset_button.dart';

class RosterSelectScreen extends ConsumerStatefulWidget {
  const RosterSelectScreen({super.key});

  @override
  ConsumerState<RosterSelectScreen> createState() => _RosterSelectScreenState();
}

class _RosterSelectScreenState extends ConsumerState<RosterSelectScreen> {
  // 6세트에 배치된 선수 인덱스 (null = 빈 슬롯)
  final List<int?> selectedPlayers = List.filled(6, null);

  // 현재 focus된 맵 인덱스 (0~5, 처음에는 0번 = 1세트)
  int _focusedMapIndex = 0;

  // 선택된 내 팀 선수 인덱스 (상세정보 표시용)
  int? _selectedMyPlayerIndex;

  // 선택된 상대 팀 선수 인덱스 (상세정보 표시용)
  int? _selectedOpponentPlayerIndex;

  // 세트별 맵 (랜덤 선정)
  List<GameMap> _matchMaps = [];

  // 스나이핑 사용 여부
  bool _snipingUsed = false;

  // 예측된 상대 로스터 (스나이핑 사용 시)
  List<String?> _predictedOpponentRoster = [];

  // 특수 컨디션 (최상/최악) - 선수ID -> SpecialCondition
  Map<String, SpecialCondition> _specialConditions = {};
  bool _specialConditionsRolled = false;

  /// 매치용 맵 7개 선정
  List<GameMap> _getMatchMaps(List<String> seasonMapIds) {
    if (_matchMaps.isNotEmpty) return _matchMaps;

    final allMaps = seasonMapIds
        .map((id) => GameMaps.getById(id))
        .whereType<GameMap>()
        .toList();

    if (allMaps.isEmpty) {
      _matchMaps = GameMaps.all.take(7).toList();
    } else {
      final shuffled = List<GameMap>.from(allMaps)..shuffle(Random());
      _matchMaps = shuffled.take(7).toList();
      while (_matchMaps.length < 7) {
        _matchMaps.add(allMaps[_matchMaps.length % allMaps.length]);
      }
    }

    return _matchMaps;
  }

  /// 다음 빈 슬롯으로 focus 이동
  void _moveToNextEmptySlot() {
    for (int i = 0; i < 6; i++) {
      if (selectedPlayers[i] == null) {
        setState(() {
          _focusedMapIndex = i;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final gameState = ref.watch(gameStateProvider);
    if (gameState == null) {
      return const Scaffold(
        body: Center(child: Text('게임 데이터를 불러올 수 없습니다')),
      );
    }

    final playerTeam = gameState.playerTeam;
    final teamPlayers = gameState.playerTeamPlayers;

    final scheduleForRoll = gameState.saveData.currentSeason.proleagueSchedule;
    final nextMatchForRoll = _findNextMatch(scheduleForRoll, playerTeam.id);
    if (nextMatchForRoll != null && !_specialConditionsRolled) {
      final isHomeForRoll = nextMatchForRoll.homeTeamId == playerTeam.id;
      final opponentIdForRoll = isHomeForRoll ? nextMatchForRoll.awayTeamId : nextMatchForRoll.homeTeamId;
      final opponentPlayersForRoll = gameState.saveData.getTeamPlayers(opponentIdForRoll);

      _specialConditions = {};
      for (final player in teamPlayers) {
        _specialConditions[player.id] = SpecialCondition.roll();
      }
      for (final player in opponentPlayersForRoll) {
        _specialConditions[player.id] = SpecialCondition.roll();
      }
      _specialConditionsRolled = true;
    }
    final schedule = gameState.saveData.currentSeason.proleagueSchedule;
    final nextMatch = _findNextMatch(schedule, playerTeam.id);

    if (nextMatch == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 경기가 완료되었습니다.')),
        );
        context.go('/main');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isHome = nextMatch.homeTeamId == playerTeam.id;
    final opponentId = isHome ? nextMatch.awayTeamId : nextMatch.homeTeamId;
    final opponentTeam = gameState.saveData.getTeamById(opponentId) ??
        gameState.saveData.allTeams.firstWhere((t) => t.id != playerTeam.id);

    final opponentPlayers = gameState.saveData.getTeamPlayers(opponentId);
    final seasonMapIds = gameState.saveData.currentSeason.seasonMapIds;
    final matchMaps = _getMatchMaps(seasonMapIds);

    final selectedCount = selectedPlayers.where((p) => p != null).length;
    final canSubmit = selectedCount >= 6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('로스터 선택'),
        leading: ResetButton.leading(),
      ),
      body: Column(
        children: [
          // 매치 정보
          _buildMatchInfo(playerTeam, opponentTeam, isHome),

          // 메인 영역: 3열 구조
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 내 팀
                Expanded(
                  flex: 3,
                  child: _buildMyTeamSection(teamPlayers),
                ),

                // 중앙: 7개 맵 세로 배치
                SizedBox(
                  width: 110,
                  child: _buildMapColumn(matchMaps, teamPlayers),
                ),

                // 오른쪽: 상대 팀
                Expanded(
                  flex: 3,
                  child: _buildOpponentSection(opponentPlayers, opponentId),
                ),
              ],
            ),
          ),

          // 제출 버튼
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: canSubmit
                    ? () => _submitRoster(playerTeam, opponentTeam, teamPlayers)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppTheme.cardBackground,
                ),
                child: Text(
                  canSubmit ? '로스터 제출' : '선수 배치 필요 ($selectedCount/6)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 매치 정보 헤더
  Widget _buildMatchInfo(Team playerTeam, Team opponentTeam, bool isHome) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: AppTheme.cardBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(playerTeam.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(isHome ? 'HOME' : 'AWAY', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
          const Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.accentGreen)),
          Column(
            children: [
              Text(opponentTeam.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(isHome ? 'AWAY' : 'HOME', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  /// 내 팀 섹션 (그리드 + 상세정보)
  Widget _buildMyTeamSection(List<Player> teamPlayers) {
    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: AppTheme.primaryBlue.withOpacity(0.2),
          child: Row(
            children: [
              const Icon(Icons.person, size: 12, color: AppTheme.primaryBlue),
              const SizedBox(width: 4),
              Text('내 팀 (${teamPlayers.length}명)',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
            ],
          ),
        ),
        // 선수 그리드 (2열)
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: teamPlayers.length,
            itemBuilder: (context, index) {
              final player = teamPlayers[index];
              final isAssigned = selectedPlayers.contains(index);
              final isSelected = _selectedMyPlayerIndex == index;
              final assignedSet = selectedPlayers.indexOf(index);

              return _PlayerGridItem(
                player: player,
                isAssigned: isAssigned,
                isSelected: isSelected,
                assignedSet: assignedSet >= 0 ? assignedSet + 1 : null,
                onTap: () {
                  setState(() {
                    _selectedMyPlayerIndex = index;
                  });
                },
                onDoubleTap: isAssigned
                    ? null
                    : () {
                        if (_focusedMapIndex < 6 && selectedPlayers[_focusedMapIndex] == null) {
                          setState(() {
                            selectedPlayers[_focusedMapIndex] = index;
                          });
                          _moveToNextEmptySlot();
                        }
                      },
              );
            },
          ),
        ),
        // 선택된 선수 상세정보 (8각형 + 컨디션)
        if (_selectedMyPlayerIndex != null && _selectedMyPlayerIndex! < teamPlayers.length)
          _buildPlayerDetail(teamPlayers[_selectedMyPlayerIndex!], true),
      ],
    );
  }

  /// 상대 팀 섹션 (그리드 + 상세정보)
  Widget _buildOpponentSection(List<Player> opponentPlayers, String opponentTeamId) {
    // 컨디션 + 등급 기준 정렬
    final sortedPlayers = List<Player>.from(opponentPlayers)
      ..sort((a, b) {
        final scoreA = a.condition + a.grade.index * 10;
        final scoreB = b.condition + b.grade.index * 10;
        return scoreB - scoreA;
      });

    final gameState = ref.watch(gameStateProvider);
    final snipingCount = gameState?.inventory.getConsumableCount('sniping') ?? 0;

    return Column(
      children: [
        // 헤더 + 스나이핑
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.red.withOpacity(0.2),
          child: Row(
            children: [
              const Icon(Icons.groups, size: 12, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text('상대 팀 (${opponentPlayers.length}명)',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
              ),
              if (snipingCount > 0 && !_snipingUsed)
                GestureDetector(
                  onTap: () => _useSniping(opponentTeamId, opponentPlayers),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(3)),
                    child: Text('스나이핑($snipingCount)', style: const TextStyle(fontSize: 8, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ),
        // 선수 그리드 (2열)
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: sortedPlayers.length,
            itemBuilder: (context, index) {
              final player = sortedPlayers[index];
              final isSelected = _selectedOpponentPlayerIndex == index;
              final isPredicted = _snipingUsed && _predictedOpponentRoster.contains(player.id);
              final predictedSet = isPredicted ? _predictedOpponentRoster.indexOf(player.id) + 1 : null;

              return _OpponentGridItem(
                player: player,
                isSelected: isSelected,
                isPredicted: isPredicted,
                predictedSet: predictedSet,
                onTap: () {
                  setState(() {
                    _selectedOpponentPlayerIndex = index;
                  });
                },
              );
            },
          ),
        ),
        // 선택된 선수 상세정보
        if (_selectedOpponentPlayerIndex != null && _selectedOpponentPlayerIndex! < sortedPlayers.length)
          _buildPlayerDetail(sortedPlayers[_selectedOpponentPlayerIndex!], false),
      ],
    );
  }

  /// 선수 상세정보 (8각형 레이더 + 컨디션)
  Widget _buildPlayerDetail(Player player, bool isMyTeam) {
    final specialCondition = _specialConditions[player.id] ?? SpecialCondition.none;
    final condition = player.getDisplayConditionWithSpecial(specialCondition);

    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isMyTeam ? AppTheme.primaryBlue.withOpacity(0.5) : Colors.red.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // (T)이영호 + 배치 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '(${player.race.code})',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getRaceColor(player.race.code),
                ),
              ),
              const SizedBox(width: 2),
              Text(player.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              if (isMyTeam) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_focusedMapIndex < 6 && selectedPlayers[_focusedMapIndex] == null) {
                      final playerIndex = ref.read(gameStateProvider)!.playerTeamPlayers.indexOf(player);
                      if (!selectedPlayers.contains(playerIndex)) {
                        setState(() {
                          selectedPlayers[_focusedMapIndex] = playerIndex;
                        });
                        _moveToNextEmptySlot();
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text('배치', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // 8각형 레이더 차트 + 컨디션
          Row(
            children: [
              // 8각형 레이더 차트
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: CustomPaint(
                    painter: _RadarChartPainter(player.stats),
                  ),
                ),
              ),
              // 컨디션 + 특수 컨디션
              Container(
                width: 50,
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    const Text('컨디션', style: TextStyle(fontSize: 8, color: AppTheme.textSecondary)),
                    const SizedBox(height: 2),
                    if (specialCondition != SpecialCondition.none)
                      Icon(
                        Icons.priority_high,
                        size: 12,
                        color: specialCondition == SpecialCondition.best ? Colors.green : Colors.red,
                      ),
                    Text(
                      '$condition%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: condition >= 80 ? Colors.green : (condition >= 50 ? Colors.orange : Colors.red),
                      ),
                    ),
                    if (specialCondition != SpecialCondition.none)
                      Text(
                        specialCondition == SpecialCondition.best ? '최상' : '최악',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: specialCondition == SpecialCondition.best ? Colors.green : Colors.red,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text('Lv.${player.level}', style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 중앙 맵 컬럼 (7개 세로 배치)
  Widget _buildMapColumn(List<GameMap> matchMaps, List<Player> teamPlayers) {
    return Container(
      color: AppTheme.cardBackground.withOpacity(0.5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Text('7전 4선승', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final map = index < matchMaps.length ? matchMaps[index] : null;

                if (index == 6) {
                  return _AceMapRow(map: map);
                }

                final playerIndex = selectedPlayers[index];
                final player = playerIndex != null && playerIndex < teamPlayers.length
                    ? teamPlayers[playerIndex]
                    : null;
                final isFocused = _focusedMapIndex == index;

                return _MapRow(
                  setNumber: index + 1,
                  map: map,
                  player: player,
                  isFocused: isFocused,
                  onTap: () {
                    setState(() {
                      _focusedMapIndex = index;
                    });
                  },
                  onPlayerRemove: () {
                    setState(() {
                      selectedPlayers[index] = null;
                      _focusedMapIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _useSniping(String opponentTeamId, List<Player> opponentPlayers) {
    final gameState = ref.read(gameStateProvider);
    if (gameState == null) return;

    final updatedInventory = gameState.inventory.useConsumable('sniping');
    ref.read(gameStateProvider.notifier).updateInventory(updatedInventory);

    _predictedOpponentRoster = _generatePredictedRoster(opponentPlayers);

    setState(() {
      _snipingUsed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스나이핑 발동!'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
    );
  }

  List<String?> _generatePredictedRoster(List<Player> opponentPlayers) {
    if (opponentPlayers.isEmpty) return List.filled(6, null);

    final sortedPlayers = List<Player>.from(opponentPlayers)
      ..sort((a, b) {
        final scoreA = a.condition + a.grade.index * 10;
        final scoreB = b.condition + b.grade.index * 10;
        return scoreB - scoreA;
      });

    final selectedCount = sortedPlayers.length >= 6 ? 6 : sortedPlayers.length;
    final roster = <String?>[];

    for (int i = 0; i < 6; i++) {
      if (i < selectedCount) {
        roster.add(sortedPlayers[i].id);
      } else {
        roster.add(null);
      }
    }

    final random = Random();
    for (int i = roster.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = roster[i];
      roster[i] = roster[j];
      roster[j] = temp;
    }

    return roster;
  }

  ScheduleItem? _findNextMatch(dynamic schedule, String playerTeamId) {
    final List<ScheduleItem> typedSchedule = List<ScheduleItem>.from(schedule);

    final myIncompleteMatches = typedSchedule.where((s) =>
      !s.isCompleted &&
      (s.homeTeamId == playerTeamId || s.awayTeamId == playerTeamId)
    ).toList();

    if (myIncompleteMatches.isEmpty) return null;

    myIncompleteMatches.sort((a, b) => a.roundNumber.compareTo(b.roundNumber));
    return myIncompleteMatches.first;
  }

  void _submitRoster(Team playerTeam, Team opponentTeam, List<Player> teamPlayers) {
    final gameState = ref.read(gameStateProvider);
    if (gameState == null) return;

    final schedule = gameState.saveData.currentSeason.proleagueSchedule;
    final nextMatch = _findNextMatch(schedule, playerTeam.id);
    if (nextMatch == null) return;

    final isHome = nextMatch.homeTeamId == playerTeam.id;

    final roster = selectedPlayers.map((index) {
      if (index != null && index < teamPlayers.length) {
        return teamPlayers[index].id;
      }
      return null;
    }).toList();

    if (isHome) {
      ref.read(currentMatchProvider.notifier).startMatch(
        homeTeamId: playerTeam.id,
        awayTeamId: opponentTeam.id,
        homeRoster: roster,
      );
    } else {
      ref.read(currentMatchProvider.notifier).startMatch(
        homeTeamId: opponentTeam.id,
        awayTeamId: playerTeam.id,
        awayRoster: roster,
      );
    }

    ref.read(currentMatchProvider.notifier).setSpecialConditions(_specialConditions);

    context.go('/match');
  }
}

/// 8각형 레이더 차트 페인터
class _RadarChartPainter extends CustomPainter {
  final PlayerStats stats;

  _RadarChartPainter(this.stats);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 8;

    // 8개 능력치
    final values = [
      stats.sense / 1000,
      stats.control / 1000,
      stats.attack / 1000,
      stats.harass / 1000,
      stats.strategy / 1000,
      stats.macro / 1000,
      stats.defense / 1000,
      stats.scout / 1000,
    ];

    final labels = ['센스', '컨트롤', '공격', '견제', '전략', '물량', '수비', '정찰'];

    // 배경 그리드
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 1; i <= 4; i++) {
      final path = Path();
      for (var j = 0; j < 8; j++) {
        final angle = (j * 45 - 90) * pi / 180;
        final r = radius * i / 4;
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 데이터 영역
    final dataPath = Path();
    final dataPaint = Paint()
      ..color = AppTheme.primaryBlue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppTheme.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * pi / 180;
      final r = radius * values[i].clamp(0.0, 1.0);
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, borderPaint);

    // 라벨
    final textStyle = TextStyle(color: AppTheme.textSecondary, fontSize: 7);
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * pi / 180;
      final x = center.dx + (radius + 10) * cos(angle);
      final y = center.dy + (radius + 10) * sin(angle);

      final textSpan = TextSpan(text: labels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 내 팀 선수 그리드 아이템
class _PlayerGridItem extends StatelessWidget {
  final Player player;
  final bool isAssigned;
  final bool isSelected;
  final int? assignedSet;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const _PlayerGridItem({
    required this.player,
    required this.isAssigned,
    required this.isSelected,
    this.assignedSet,
    required this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withOpacity(0.3)
              : (isAssigned ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.cardBackground),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : (isAssigned ? AppTheme.accentGreen : Colors.transparent),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 종족 (T)이영호 형태
            Text(
              '(${player.race.code})',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppTheme.getRaceColor(player.race.code),
              ),
            ),
            const SizedBox(width: 2),
            // 이름
            Expanded(
              child: Text(
                player.name,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isAssigned ? AppTheme.textSecondary : AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 세트 표시
            if (isAssigned && assignedSet != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(2)),
                child: Text('$assignedSet', style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}

/// 상대 팀 선수 그리드 아이템
class _OpponentGridItem extends StatelessWidget {
  final Player player;
  final bool isSelected;
  final bool isPredicted;
  final int? predictedSet;
  final VoidCallback onTap;

  const _OpponentGridItem({
    required this.player,
    required this.isSelected,
    this.isPredicted = false,
    this.predictedSet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.red.withOpacity(0.3)
              : (isPredicted ? Colors.green.withOpacity(0.2) : AppTheme.cardBackground),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? Colors.red : (isPredicted ? Colors.green : Colors.transparent),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // 예측 세트
            if (isPredicted && predictedSet != null) ...[
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2)),
                child: Center(child: Text('$predictedSet', style: const TextStyle(fontSize: 7, color: Colors.white))),
              ),
              const SizedBox(width: 2),
            ],
            // 종족 (T)이영호 형태
            Text(
              '(${player.race.code})',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppTheme.getRaceColor(player.race.code),
              ),
            ),
            const SizedBox(width: 2),
            // 이름
            Expanded(
              child: Text(
                player.name,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 맵 행
class _MapRow extends StatelessWidget {
  final int setNumber;
  final GameMap? map;
  final Player? player;
  final bool isFocused;
  final VoidCallback onTap;
  final VoidCallback onPlayerRemove;

  const _MapRow({
    required this.setNumber,
    required this.map,
    required this.player,
    required this.isFocused,
    required this.onTap,
    required this.onPlayerRemove,
  });

  @override
  Widget build(BuildContext context) {
    final mapName = map?.name ?? '맵 $setNumber';
    final shortMapName = mapName.length > 5 ? '${mapName.substring(0, 4)}..' : mapName;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isFocused
              ? AppTheme.accentGreen.withOpacity(0.2)
              : (player != null ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.transparent),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isFocused
                ? AppTheme.accentGreen
                : (player != null ? AppTheme.primaryBlue : AppTheme.textSecondary.withOpacity(0.3)),
            width: isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16, height: 16,
              decoration: BoxDecoration(
                color: isFocused ? AppTheme.accentGreen : AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('$setNumber', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold,
                    color: isFocused ? Colors.black : AppTheme.textSecondary)),
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shortMapName, style: TextStyle(fontSize: 8,
                      color: isFocused ? AppTheme.accentGreen : AppTheme.textSecondary), overflow: TextOverflow.ellipsis),
                  if (player != null)
                    GestureDetector(
                      onTap: onPlayerRemove,
                      child: Row(
                        children: [
                          CircleAvatar(radius: 5, backgroundColor: AppTheme.getRaceColor(player!.race.code),
                              child: Text(player!.race.code, style: const TextStyle(fontSize: 5, color: Colors.white))),
                          const SizedBox(width: 2),
                          Expanded(child: Text(player!.name, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    )
                  else
                    Text(isFocused ? '← 선택' : '', style: TextStyle(fontSize: 7,
                        color: isFocused ? AppTheme.accentGreen : AppTheme.textSecondary.withOpacity(0.5))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 에이스 맵 행
class _AceMapRow extends StatelessWidget {
  final GameMap? map;

  const _AceMapRow({required this.map});

  @override
  Widget build(BuildContext context) {
    final mapName = map?.name ?? 'ACE';
    final shortMapName = mapName.length > 5 ? '${mapName.substring(0, 4)}..' : mapName;

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Icon(Icons.star, size: 10, color: Colors.orange)),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shortMapName, style: TextStyle(fontSize: 8, color: Colors.orange.withOpacity(0.8)), overflow: TextOverflow.ellipsis),
                Text('ACE (3:3)', style: TextStyle(fontSize: 7, color: Colors.orange.withOpacity(0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
