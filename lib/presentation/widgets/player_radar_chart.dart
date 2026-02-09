import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/models.dart';

/// 8각형 레이더 차트 위젯 (통합)
///
/// title_screen의 CompactRadarChartPainter 스타일을 기준으로 통일.
/// - 5단계 그리드
/// - 축선
/// - 꼭짓점에 라벨 + 능력치 수치
/// - 중앙에 등급 + 레벨 (옵션)
class PlayerRadarChart extends StatelessWidget {
  final PlayerStats stats;
  final Color color;
  final String? grade;
  final int? level;

  const PlayerRadarChart({
    super.key,
    required this.stats,
    required this.color,
    this.grade,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PlayerRadarChartPainter(
        stats: stats,
        color: color,
        grade: grade,
        level: level,
      ),
      size: Size.infinite,
    );
  }
}

class _PlayerRadarChartPainter extends CustomPainter {
  final PlayerStats stats;
  final Color color;
  final String? grade;
  final int? level;

  static const _labels = ['센스', '컨트롤', '공격력', '견제', '전략', '물량', '수비력', '정찰'];

  _PlayerRadarChartPainter({
    required this.stats,
    required this.color,
    this.grade,
    this.level,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 28;
    const sides = 8;

    final normalizedValues = stats.toRadarData();
    final rawValues = [
      stats.sense, stats.control, stats.attack, stats.harass,
      stats.strategy, stats.macro, stats.defense, stats.scout,
    ];

    // 배경 그리드 (5단계)
    final gridPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var lvl = 1; lvl <= 5; lvl++) {
      final levelRadius = radius * lvl / 5;
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final angle = (i * 2 * pi / sides) - pi / 2;
        final point = Offset(
          center.dx + levelRadius * cos(angle),
          center.dy + levelRadius * sin(angle),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // 축선
    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }

    // 데이터 영역
    final dataPath = Path();
    final dataPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final dataStrokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final value = normalizedValues[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, dataStrokePaint);

    // 라벨 + 수치
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final labelRadius = radius + 22;
      var point = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      textPainter.text = TextSpan(
        children: [
          TextSpan(
            text: '${_labels[i]}\n',
            style: TextStyle(color: Colors.grey[400], fontSize: 9),
          ),
          TextSpan(
            text: '${rawValues[i]}',
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      );
      textPainter.textAlign = TextAlign.center;
      textPainter.layout();

      point = Offset(
        point.dx - textPainter.width / 2,
        point.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, point);
    }

    // 중앙에 등급 + 레벨 표시
    if (grade != null && level != null) {
      final gradePainter = TextPainter(textDirection: TextDirection.ltr);
      gradePainter.text = TextSpan(
        children: [
          TextSpan(
            text: '$grade\n',
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Lv.$level',
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
        ],
      );
      gradePainter.textAlign = TextAlign.center;
      gradePainter.layout();
      gradePainter.paint(
        canvas,
        Offset(center.dx - gradePainter.width / 2, center.dy - gradePainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PlayerRadarChartPainter oldDelegate) {
    return stats != oldDelegate.stats ||
        color != oldDelegate.color ||
        grade != oldDelegate.grade ||
        level != oldDelegate.level;
  }
}
