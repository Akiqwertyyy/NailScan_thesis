import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const NailScanApp());
}

class NailScanApp extends StatelessWidget {
  const NailScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NailScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const NailScanHomePage(),
    );
  }
}

class NailScanHomePage extends StatefulWidget {
  const NailScanHomePage({super.key});

  @override
  State<NailScanHomePage> createState() => _NailScanHomePageState();
}

class _NailScanHomePageState extends State<NailScanHomePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      body: Stack(
        children: [
          // Background gradient
          _buildBackground(size),

          // Blurred nail image overlay
          _buildBlurredNailOverlay(size),

          // Floating bokeh dots
          _buildBokehDots(size),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(size, padding),
              ),
            ),
          ),

          // Bottom Nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD6E4FF),
            Color(0xFFEEF3FF),
            Color(0xFFD9EAFF),
            Color(0xFFC8DCFF),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildBlurredNailOverlay(Size size) {
    return Positioned(
      top: -40,
      right: -60,
      child: Opacity(
        opacity: 0.18,
        child: Container(
          width: size.width * 0.75,
          height: size.height * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const RadialGradient(
              colors: [Color(0xFFFFCDD2), Color(0xFFFFE0B2)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBokehDots(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: BokehPainter(),
        ),
      ),
    );
  }

  Widget _buildMainContent(Size size, EdgeInsets padding) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 90,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Logo
                  _buildLogo(),
                  const SizedBox(height: 20),

                  // Title
                  _buildTitle(),
                  const SizedBox(height: 8),

                  // Subtitle badge
                  _buildSubtitleBadge(),
                  const SizedBox(height: 22),

                  // Description
                  _buildDescription(),
                  const SizedBox(height: 32),

                  // Start Diagnosis Button
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) => _buildStartButton(),
                  ),
                  const SizedBox(height: 28),

                  // Feature cards
                  _buildFeatureCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Instant AI-powered analysis',
                    subtitle: 'AI-powered analysis today.',
                    iconColor: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureCard(
                    icon: Icons.history_rounded,
                    title: 'Track your nail health history',
                    subtitle: 'Review past scan results.',
                    iconColor: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkles
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 12,
            child: Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: Colors.white38,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Icon(
            Icons.fingerprint,
            size: 52,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'NailScan',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: -0.5,
        height: 1.1,
      ),
    );
  }

  Widget _buildSubtitleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2563EB).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: const Text(
        'AI-Powered Nail Health Analysis',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF475569),
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'Scan your fingernail to detect possible\nconditions using advanced AI technology.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF475569),
          height: 1.6,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: () {},
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB)
                      .withOpacity(0.35 * _glowAnimation.value),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: const Color(0xFF60A5FA)
                      .withOpacity(0.2 * _glowAnimation.value),
                  blurRadius: 40,
                  spreadRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Shine overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Button text
                const Center(
                  child: Text(
                    'Start Diagnosis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.07),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 1,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Icon(
            Icons.chevron_right_rounded,
            color: const Color(0xFF94A3B8),
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.history_rounded,
                label: 'History',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.info_outline_rounded,
                label: 'About',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for background bokeh/sparkle dots
class BokehPainter extends CustomPainter {
  final List<_BokehDot> dots = const [
    _BokehDot(0.08, 0.12, 18, 0.18),
    _BokehDot(0.88, 0.06, 12, 0.13),
    _BokehDot(0.15, 0.55, 10, 0.10),
    _BokehDot(0.92, 0.35, 22, 0.15),
    _BokehDot(0.5, 0.08, 8, 0.12),
    _BokehDot(0.75, 0.75, 16, 0.10),
    _BokehDot(0.3, 0.88, 20, 0.08),
    _BokehDot(0.65, 0.5, 6, 0.09),
    _BokehDot(0.02, 0.72, 14, 0.11),
    _BokehDot(0.95, 0.88, 10, 0.08),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in dots) {
      final paint = Paint()
        ..color = const Color(0xFF93C5FD).withOpacity(dot.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(
        Offset(size.width * dot.xFraction, size.height * dot.yFraction),
        dot.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BokehDot {
  final double xFraction;
  final double yFraction;
  final double radius;
  final double opacity;

  const _BokehDot(
      this.xFraction, this.yFraction, this.radius, this.opacity);
}
