import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.beige,
            AppColors.surface,
            AppColors.skyBlue,
          ],
          stops: [0.0, 0.62, 1.0],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
