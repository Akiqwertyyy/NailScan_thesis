import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            border: const Border(top: BorderSide(color: AppColors.border)),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: Offset(0, -6)),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(Icons.home_rounded, 'Home', 0),
                _buildItem(Icons.history_rounded, 'History', 1),
                _buildItem(Icons.info_outline_rounded, 'About', 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, int index) {
    final active = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 94,
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: active ? AppColors.primary : AppColors.textMuted),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
