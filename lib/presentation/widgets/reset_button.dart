import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/responsive.dart';

/// 모든 화면에서 사용하는 R(리셋) 버튼
/// 기본 위치: 좌측 하단 (다른 UI와 겹치지 않음)
class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Container(
      width: 40.sp,
      height: 40.sp,
      decoration: BoxDecoration(
        color: Colors.red[800],
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: Colors.red[400]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.sp),
          onTap: () => context.go('/'),
          child: Center(
            child: Text(
              'R',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Positioned로 감싼 R 버튼 (Stack 내에서 사용)
  /// 기본 위치: 좌측 하단 (bottom: 80, left: 16)
  static Widget positioned() {
    return Builder(
      builder: (context) {
        Responsive.init(context);
        return Positioned(
          bottom: 80.sp,
          left: 16.sp,
          child: const ResetButton(),
        );
      },
    );
  }
}
