import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onStartDiagnosis;
  final void Function(String)? onNavigate;
  final String? currentScreen;

  const HomeScreen({
    super.key,
    this.onStartDiagnosis,
    this.onNavigate,
    this.currentScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FF),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) onNavigate?.call('home');
            if (index == 1) onNavigate?.call('history');
            if (index == 2) onNavigate?.call('about');
          },
        ),
        body: Stack(
          children: [
            const _PremiumHomeBackground(),
            const _SoftCircle(top: -60, right: -60, size: 190, opacity: .33),
            const _SoftCircle(top: 170, left: -75, size: 180, opacity: .20),
            const _SoftCircle(bottom: 80, right: -45, size: 150, opacity: .20),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _BokehPainter()),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 42),
                child: Column(
                  children: [
                    _buildHeader(),
                    const Spacer(),
                    _buildFeatureSection(),
                    const Spacer(),
                    _buildStartButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'NailScan',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0A2A66),
                  letterSpacing: -0.7,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'AI Nail Health Analysis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF46639A),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Scan your fingernail for fast AI-powered nail health screening.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5F79A6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: 62,
              height: 62,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.44),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(.75)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B5CFF).withOpacity(.12),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF0B5CFF),
                  size: 34,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.34),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(.72),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0B5CFF).withOpacity(.12),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(.26),
                blurRadius: 16,
                offset: const Offset(-6, -6),
              ),
            ],
          ),
          child: const Column(
            children: [
              FeatureCard(
                icon: Icons.flash_on_rounded,
                title: 'Instant Analysis',
                subtitle: 'Get results in seconds.',
                showDivider: true,
              ),
              FeatureCard(
                icon: Icons.history_rounded,
                title: 'Scan History',
                subtitle: 'View your previous scans.',
                showDivider: true,
              ),
              FeatureCard(
                icon: Icons.lock_rounded,
                title: 'Private & Secure',
                subtitle: 'Your data is stored only on your device.',
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: onStartDiagnosis,
      child: Container(
        height: 62,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF3B82F6), Color(0xFF0B5CFF), Color(0xFF1D4ED8)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B5CFF).withOpacity(.36),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: const Color(0xFF60A5FA).withOpacity(.30),
              blurRadius: 44,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(.45)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 22,
              right: 22,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(.23), Colors.transparent],
                  ),
                ),
              ),
            ),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Start Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showDivider;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.34),
                  border: Border.all(color: Colors.white.withOpacity(.54)),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF0B5CFF),
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF0A2A66),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B84A8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            color: const Color(0xFF0A2A66).withOpacity(.08),
          ),
      ],
    );
  }
}

class _PremiumHomeBackground extends StatelessWidget {
  const _PremiumHomeBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD5EBFF),
            Color(0xFFEEF7FF),
            Color(0xFFBFDFFF),
            Color(0xFF88C4FF),
          ],
          stops: [0.0, 0.34, 0.72, 1.0],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftCircle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity),
              const Color(0xFF0B5CFF).withOpacity(opacity * .25),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _BokehPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dots = [
      [0.08, 0.13, 15.0, .14],
      [0.73, 0.18, 21.0, .14],
      [0.92, 0.08, 12.0, .18],
      [0.20, 0.55, 10.0, .12],
      [0.82, 0.61, 20.0, .12],
      [0.48, 0.86, 13.0, .12],
    ];

    for (final dot in dots) {
      canvas.drawCircle(
        Offset(size.width * dot[0], size.height * dot[1]),
        dot[2],
        Paint()
          ..color = Colors.white.withOpacity(dot[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}