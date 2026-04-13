import 'package:flutter/material.dart';

class MinimalNavBar extends StatelessWidget {
  final String currentScreen;
  final void Function(String) onNavigate;

  const MinimalNavBar({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_rounded,
            isActive: currentScreen == 'home',
            onTap: () => onNavigate('home'),
          ),
          _NavItem(
            label: 'History',
            icon: Icons.history_rounded,
            isActive: currentScreen == 'history',
            onTap: () => onNavigate('history'),
          ),
          _NavItem(
            label: 'About',
            icon: Icons.info_outline_rounded,
            isActive: currentScreen == 'about',
            onTap: () => onNavigate('about'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF2563EB);
    const inactiveColor = Color(0xFFB0B8C1);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 30,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF2563EB).withOpacity(0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? activeColor : inactiveColor,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
