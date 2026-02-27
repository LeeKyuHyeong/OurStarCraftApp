import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/utils/responsive.dart';
import '../../domain/models/models.dart';
import 'player_radar_chart.dart';
import 'player_thumbnail.dart';

/// 선수 정보 바텀시트 표시
void showPlayerInfoSheet(BuildContext context, Player player) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PlayerInfoSheetContent(player: player),
  );
}

class _PlayerInfoSheetContent extends StatelessWidget {
  final Player player;

  const _PlayerInfoSheetContent({required this.player});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final gradeColor = AppTheme.getGradeColor(player.grade.display);
    final raceColor = AppTheme.getRaceColor(player.race.code);
    final condition = player.displayCondition;
    final condColor = condition > 100
        ? Colors.greenAccent
        : condition >= 90
            ? Colors.grey[300]!
            : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
        border: Border(
          top: BorderSide(color: gradeColor.withValues(alpha: 0.5), width: 2),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.sp, 12.sp, 20.sp, 24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            width: 40.sp,
            height: 4.sp,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2.sp),
            ),
          ),
          SizedBox(height: 16.sp),

          // 상단: 사진 + 이름/등급/컨디션
          Row(
            children: [
              PlayerThumbnail(
                player: player,
                size: 48,
                borderRadius: BorderRadius.circular(8.sp),
              ),
              SizedBox(width: 12.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름 + 종족
                    Row(
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.sp),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 1.sp),
                          decoration: BoxDecoration(
                            color: raceColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.sp),
                          ),
                          child: Text(
                            player.race.code,
                            style: TextStyle(
                              color: raceColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.sp),
                    // 등급 + 레벨 + 컨디션
                    Row(
                      children: [
                        Text(
                          player.grade.display,
                          style: TextStyle(
                            color: gradeColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          'Lv.${player.level.value}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          '컨디션 $condition%',
                          style: TextStyle(
                            color: condColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),

          // 레이더 차트
          SizedBox(
            width: 180.sp,
            height: 180.sp,
            child: PlayerRadarChart(
              stats: player.stats,
              color: gradeColor,
              grade: player.grade.display,
              level: player.level.value,
              effectiveStats: player.effectiveStats,
              conditionPercent: condition,
            ),
          ),
          SizedBox(height: 8.sp),

          // 총합
          Text(
            '총합 ${player.stats.total}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
