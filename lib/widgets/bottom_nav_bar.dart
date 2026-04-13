import 'package:flutter/material.dart';

/// Reusable bottom navigation bar widget
class BottomNavBar extends StatelessWidget {
  final String currentScreen;
  final Function(String) onNavigate;

  const BottomNavBar({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavButton(
              icon: Icons.home,
              label: 'Diagnose',
              isActive: currentScreen == 'home',
              onTap: () => onNavigate('home'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.history,
              label: 'History',
              isActive: currentScreen == 'history',
              onTap: () => onNavigate('history'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.info,
              label: 'About',
              isActive: currentScreen == 'about',
              onTap: () => onNavigate('about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  )
                : null,
            color: isActive ? null : Colors.white,
            border: isActive
                ? null
                : Border.all(color: const Color(0xFFE5E7EB), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
