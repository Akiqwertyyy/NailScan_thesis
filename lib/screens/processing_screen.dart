import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProcessingScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ProcessingScreen({
    super.key,
    this.onBack,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _ProcessingBackground(),
          const _SoftCircle(top: -90, left: -75, size: 255, opacity: .24),
          const _SoftCircle(top: 130, right: -95, size: 220, opacity: .15),
          const _SoftCircle(bottom: -85, right: -75, size: 240, opacity: .20),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _WavePainter()),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ParticlePainter()),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
              child: Column(
                children: [
                  _appBar(context),
                  const Spacer(flex: 2),
                  const Text(
                    'Analyzing Nail Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF071F55),
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Our AI is carefully analyzing your nail\nto provide accurate results',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF23416F),
                    ),
                  ),
                  const Spacer(flex: 2),
                  _ProcessingRing(animation: _controller),
                  const Spacer(flex: 2),
                  const Text(
                    'Please wait while NailScan\nprocesses your image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF143875),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Icon(
                    Icons.hourglass_empty_rounded,
                    size: 48,
                    color: Color(0xFF0B55C7),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: GestureDetector(
                  onTap: widget.onBack ?? () => Navigator.maybePop(context),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.68),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(.82)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF06245C),
                      size: 23,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Nail Capture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: Color(0xFF071F55),
              letterSpacing: -.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingRing extends StatelessWidget {
  final Animation<double> animation;

  const _ProcessingRing({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 210,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: animation.value * math.pi * 2,
                child: CustomPaint(
                  size: const Size(210, 210),
                  painter: _RingPainter(),
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(.40),
                      blurRadius: 42,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/logo.png',
                width: 86,
                fit: BoxFit.contain,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2.55);

    final outerDot = Paint()
      ..color = Colors.white.withOpacity(.58)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 72; i++) {
      final angle = (math.pi * 2 / 72) * i;
      final p1 = Offset(
        center.dx + math.cos(angle) * (size.width / 2.22),
        center.dy + math.sin(angle) * (size.width / 2.22),
      );
      canvas.drawCircle(p1, 1.2, outerDot);
    }

    final softRing = Paint()
      ..color = Colors.white.withOpacity(.38)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, size.width / 2.7, softRing);

    final glowRing = Paint()
      ..color = Colors.white.withOpacity(.72)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.72, false, glowRing);

    final blueRing = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFF0A5DFF),
          Color(0xFF35C8FF),
          Color(0xFFFFFFFF),
          Color(0xFF0A5DFF),
        ],
        stops: [0.0, .42, .47, 1.0],
      ).createShader(rect)
      ..strokeWidth = 8.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, -math.pi / 1.25, math.pi * 1.82, false, blueRing);

    final whiteDot = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final dotAngle1 = -math.pi / 3.4;
    final dotAngle2 = math.pi * .78;
    canvas.drawCircle(
      Offset(
        center.dx + math.cos(dotAngle1) * (size.width / 2.55),
        center.dy + math.sin(dotAngle1) * (size.width / 2.55),
      ),
      8,
      whiteDot,
    );
    canvas.drawCircle(
      Offset(
        center.dx + math.cos(dotAngle2) * (size.width / 2.55),
        center.dy + math.sin(dotAngle2) * (size.width / 2.55),
      ),
      6,
      whiteDot,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProcessingBackground extends StatelessWidget {
  const _ProcessingBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFDCEBFF),
            Color(0xFFBFDFFF),
            Color(0xFF88C4FF),
            Color(0xFF5EACFF),
          ],
          stops: [0.0, .38, .76, 1.0],
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
              Colors.white.withOpacity(opacity * .46),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.14)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final yBase = size.height * (.42 + i * .05);
      path.moveTo(-40, yBase + 70);
      path.cubicTo(
        size.width * .25,
        yBase + 150,
        size.width * .55,
        yBase - 70,
        size.width + 80,
        yBase + 20,
      );
      canvas.drawPath(path, paint);
    }

    for (int i = 0; i < 3; i++) {
      final path = Path();
      final yBase = size.height * (.17 + i * .045);
      path.moveTo(size.width * .62, yBase + 120);
      path.cubicTo(
        size.width * .78,
        yBase + 70,
        size.width * .88,
        yBase - 20,
        size.width + 40,
        yBase - 90,
      );
      canvas.drawPath(path, paint..color = Colors.white.withOpacity(.11));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dots = [
      [0.14, 0.26, 5.5, .85],
      [0.10, 0.35, 7.5, .34],
      [0.90, 0.13, 5.5, .76],
      [0.77, 0.62, 5.5, .28],
      [0.16, 0.80, 6.8, .72],
      [0.83, 0.92, 6.6, .78],
    ];

    for (final dot in dots) {
      canvas.drawCircle(
        Offset(size.width * dot[0], size.height * dot[1]),
        dot[2],
        Paint()
          ..color = Colors.white.withOpacity(dot[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
