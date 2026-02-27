import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/models.dart';

/// 두 선수의 능력치를 겹쳐 표시하는 8각형 레이더 차트
class ComparisonRadarChart extends StatelessWidget {
  final PlayerStats stats1;
  final Color color1;
  final PlayerStats stats2;
  final Color color2;

  const ComparisonRadarChart({
    super.key,
    required this.stats1,
    required this.color1,
    required this.stats2,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ComparisonRadarChartPainter(
        stats1: stats1,
        color1: color1,
        stats2: stats2,
        color2: color2,
      ),
      size: Size.infinite,
    );
  }
}

class _ComparisonRadarChartPainter extends CustomPainter {
  final PlayerStats stats1;
  final Color color1;
  final PlayerStats stats2;
  final Color color2;

  static const _labels = ['센스', '컨트롤', '공격력', '견제', '전략', '물량', '수비력', '정찰'];

  _ComparisonRadarChartPainter({
    required this.stats1,
    required this.color1,
    required this.stats2,
    required this.color2,
  });

  Path _buildPolygonPath(List<double> values, Offset center, double radius, int sides) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final value = values[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 28;
    const sides = 8;

    final values1 = stats1.toRadarData();
    final values2 = stats2.toRadarData();
    final raw1 = [
      stats1.sense, stats1.control, stats1.attack, stats1.harass,
      stats1.strategy, stats1.macro, stats1.defense, stats1.scout,
    ];
    final raw2 = [
      stats2.sense, stats2.control, stats2.attack, stats2.harass,
      stats2.strategy, stats2.macro, stats2.defense, stats2.scout,
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

    // 폴리곤 1 (우리팀 - 파랑 계열)
    final path1 = _buildPolygonPath(values1, center, radius, sides);
    canvas.drawPath(path1, Paint()
      ..color = color1.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill);
    canvas.drawPath(path1, Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);

    // 폴리곤 2 (상대팀 - 빨강 계열)
    final path2 = _buildPolygonPath(values2, center, radius, sides);
    canvas.drawPath(path2, Paint()
      ..color = color2.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill);
    canvas.drawPath(path2, Paint()
      ..color = color2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);

    // 라벨 + 양쪽 수치
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final labelRadius = radius + 24;
      var point = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      textPainter.text = TextSpan(
        children: [
          TextSpan(
            text: '${_labels[i]}\n',
            style: TextStyle(color: Colors.grey[400], fontSize: 8),
          ),
          TextSpan(
            text: '${raw1[i]}',
            style: TextStyle(color: color1, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '/',
            style: TextStyle(color: Colors.grey[600], fontSize: 8),
          ),
          TextSpan(
            text: '${raw2[i]}',
            style: TextStyle(color: color2, fontSize: 9, fontWeight: FontWeight.bold),
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
  }

  @override
  bool shouldRepaint(covariant _ComparisonRadarChartPainter oldDelegate) {
    return stats1 != oldDelegate.stats1 ||
        stats2 != oldDelegate.stats2 ||
        color1 != oldDelegate.color1 ||
        color2 != oldDelegate.color2;
  }
}
