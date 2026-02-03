import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0A0E14),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 게임 로고/타이틀
                const Text(
                  'MyStar',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                    shadows: [
                      Shadow(
                        color: AppTheme.accentGreen,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '프로게이머 육성 시뮬레이션',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 80),

                // 메뉴 버튼들
                _MenuButton(
                  label: '새 게임',
                  icon: Icons.play_arrow,
                  onPressed: () => context.go('/team-select'),
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  label: '이어하기',
                  icon: Icons.save,
                  onPressed: () => context.go('/save-load'),
                ),
                const SizedBox(height: 16),
                _MenuButton(
                  label: '설정',
                  icon: Icons.settings,
                  onPressed: () {
                    // TODO: 설정 화면
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('설정 화면 준비 중')),
                    );
                  },
                ),

                const SizedBox(height: 80),

                // 버전 정보
                const Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.cardBackground,
          foregroundColor: AppTheme.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppTheme.primaryBlue,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
