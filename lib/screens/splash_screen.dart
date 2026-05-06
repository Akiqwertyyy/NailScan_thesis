import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _PremiumBlueBackground(),
          const _SoftGlow(top: -70, left: -55, size: 190, opacity: .30),
          const _SoftGlow(top: 90, right: -80, size: 230, opacity: .24),
          const _SoftGlow(bottom: -80, left: 55, size: 230, opacity: .20),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BokehPainter()),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: 118,
                      height: 118,
                      padding: const EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withOpacity(.42),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0B5CFF).withOpacity(.30),
                            blurRadius: 34,
                            offset: const Offset(0, 14),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(.16),
                            blurRadius: 18,
                            offset: const Offset(-6, -6),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white,
                          size: 62,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'NailScan',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(.28)),
                  ),
                  child: const Text(
                    'AI Nail Health Analysis',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumBlueBackground extends StatelessWidget {
  const _PremiumBlueBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF2563EB),
            Color(0xFF3B82F6),
            Color(0xFFBFE2FF),
          ],
          stops: [0.0, 0.42, 0.78, 1.0],
        ),
      ),
    );
  }
}

class _SoftGlow extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftGlow({
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
              Colors.white.withOpacity(0),
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
      [0.10, 0.10, 18.0, .16],
      [0.90, 0.08, 12.0, .16],
      [0.16, 0.38, 26.0, .10],
      [0.78, 0.30, 38.0, .13],
      [0.42, 0.16, 12.0, .12],
      [0.86, 0.72, 22.0, .12],
      [0.24, 0.78, 16.0, .12],
    ];

    for (final dot in dots) {
      canvas.drawCircle(
        Offset(size.width * dot[0], size.height * dot[1]),
        dot[2],
        Paint()
          ..color = Colors.white.withOpacity(dot[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
