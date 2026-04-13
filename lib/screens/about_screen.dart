import 'dart:ui';
import 'package:flutter/material.dart';

// Warm skin-tone palette constants
const Color _primary   = Color(0xFFC97A5A); // terracotta – primary
const Color _mid       = Color(0xFFD9956E); // warm peach – mid
const Color _blush     = Color(0xFFD4A09A); // dusty rose – accent
const Color _light     = Color(0xFFECC9B8); // peachy cream – highlight
const Color _cream     = Color(0xFFF9EDE6); // softest bg
const Color _textDark  = Color(0xFF4A2416); // deep brown
const Color _textMid   = Color(0xFF7A4030); // medium brown
const Color _textMuted = Color(0xFFAA7060); // muted terracotta
const Color _cardBorder= Color(0xFFF0D0C0);
const Color _healthy   = Color(0xFF8BAF7A); // muted sage – healthy
const Color _warning   = Color(0xFFD9956E); // warm amber-peach – warning

class AboutScreen extends StatefulWidget {
  final Function(String)? onNavigate;
  final String? currentScreen;

  const AboutScreen({
    super.key,
    this.onNavigate,
    this.currentScreen,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 2;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const List<String> _screenKeys = ['home', 'history', 'about'];

  // Conditions with warm palette colours
  final List<Map<String, dynamic>> _conditions = const [
    {'name': 'Onychomycosis',                   'color': Color(0xFFC97A5A)},
    {'name': 'Acral Lentiginous Melanoma (ALM)', 'color': Color(0xFFD9956E)},
    {'name': 'Nail Clubbing',                    'color': Color(0xFFD4A09A)},
    {'name': 'Healthy Nail',                     'color': Color(0xFF8BAF7A)},
    {'name': 'Unidentified',                     'color': Color(0xFFB8A09A)},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.currentScreen != null) {
      final idx = _screenKeys.indexOf(widget.currentScreen!);
      if (idx != -1) _selectedIndex = idx;
    }

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          _buildBackground(size),
          _buildBlurredOverlay(size),
          _buildBokehDots(size),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(),
              ),
            ),
          ),
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
            Color(0xFFF5DDD0),
            Color(0xFFF9EDE6),
            Color(0xFFF2D8C8),
            Color(0xFFEDCFBE),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildBlurredOverlay(Size size) {
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
              colors: [Color(0xFFECC9B8), Color(0xFFD4A09A)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBokehDots(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _BokehPainter()),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Logo
            _buildLogo(),
            const SizedBox(height: 16),

            // App name
            const Text(
              'NailScan',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),

            // Version badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _primary.withOpacity(0.18),
                ),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _textMid,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // What is NailScan card
            _buildInfoCard(
              title: 'What is NailScan?',
              child: const Text(
                'NailScan is a mobile application designed to assist in identifying visible nail conditions using image analysis. It aims to provide quick preliminary screening based on nail appearance patterns.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textMid,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Conditions detected card
            _buildInfoCard(
              title: 'Conditions Detected',
              child: Column(
                children: _conditions.map((c) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: c['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          c['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Disclaimer card
            _buildInfoCard(
              title: 'Disclaimer',
              accentColor: _warning,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded,
                      color: _warning, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This app is for informational purposes only and does not replace professional medical advice. Always consult a healthcare provider for diagnosis.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _textMuted,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Start scan CTA
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD9956E), Color(0xFFC97A5A)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () => widget.onNavigate?.call('home'),
                icon: const Icon(Icons.fingerprint, color: Colors.white, size: 20),
                label: const Text(
                  'Start a Scan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD9956E), Color(0xFFC97A5A)],
        ),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.40),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Icon(Icons.fingerprint, size: 46, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Widget child,
    Color? accentColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.07),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (accentColor != null)
                Container(
                  width: 4,
                  height: 18,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
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
              top: BorderSide(color: _cardBorder.withOpacity(0.5), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0, screenKey: 'home'),
              _buildNavItem(icon: Icons.history_rounded, label: 'History', index: 1, screenKey: 'history'),
              _buildNavItem(icon: Icons.info_outline_rounded, label: 'About', index: 2, screenKey: 'about'),
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
    required String screenKey,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        widget.onNavigate?.call(screenKey);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26,
              color: isSelected ? _primary : const Color(0xFFB8A09A)),
            const SizedBox(height: 4),
            Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? _primary : const Color(0xFFB8A09A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BokehPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dots = [
      [0.08, 0.12, 18.0, 0.18], [0.88, 0.06, 12.0, 0.13],
      [0.15, 0.55, 10.0, 0.10], [0.92, 0.35, 22.0, 0.15],
      [0.5,  0.08,  8.0, 0.12], [0.75, 0.75, 16.0, 0.10],
      [0.3,  0.88, 20.0, 0.08], [0.65, 0.5,   6.0, 0.09],
      [0.02, 0.72, 14.0, 0.11], [0.95, 0.88, 10.0, 0.08],
    ];
    for (final d in dots) {
      canvas.drawCircle(
        Offset(size.width * d[0], size.height * d[1]),
        d[2],
        Paint()
          // Warm peach bokeh dots instead of cold blue
          ..color = const Color(0xFFD9956E).withOpacity(d[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
